import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/providers.dart';
import 'egyptian_foods.dart';
import 'nutrition_logic.dart';

/// Totals eaten on one day (meal logs + supplements taken).
class ConsumedTotals {
  final FoodMacros meals;
  final FoodMacros supplements;
  final int mealsLogged;
  final int pendingCount;
  const ConsumedTotals({
    this.meals = const FoodMacros(),
    this.supplements = const FoodMacros(),
    this.mealsLogged = 0,
    this.pendingCount = 0,
  });

  FoodMacros get total => meals + supplements;
}

/// A supplement marked as taken on a day, with its macros.
class TakenSupplement {
  final Supplement supplement;
  final int count;
  const TakenSupplement(this.supplement, this.count);

  FoodMacros get macros => FoodMacros(
        calories: supplement.calories * count,
        protein: supplement.proteinG * count,
        carbs: supplement.carbsG * count,
        fat: supplement.fatG * count,
      );
}

/// Pure aggregation used by the providers (and tests).
ConsumedTotals aggregateConsumed(List<MealLog> logs, List<TakenSupplement> supplements) {
  var meals = const FoodMacros();
  var done = 0, pending = 0;
  for (final l in logs) {
    if (l.status == 'pending_ai') {
      pending++;
      continue;
    }
    done++;
    meals += FoodMacros(calories: l.calories, protein: l.protein, carbs: l.carbs, fat: l.fat);
  }
  final sup = supplements.fold(const FoodMacros(), (a, s) => a + s.macros);
  return ConsumedTotals(meals: meals, supplements: sup, mealsLogged: done, pendingCount: pending);
}

/// Folder (inside app documents) holding meal photos. Paths are stored relative to documents.
const mealPhotoDir = 'meal_photos';

Future<String> resolveAppPath(String stored) async {
  if (p.isAbsolute(stored)) return stored;
  final docs = await getApplicationDocumentsDirectory();
  return p.join(docs.path, stored);
}

/// All nutrition DB access (plans, logs, "my foods", supplements read-only).
class NutritionRepository {
  final AppDatabase db;
  NutritionRepository(this.db);

  /// Emits [fetch]'s result now and again whenever one of [tables] changes.
  Stream<T> _watchTables<T>(List<TableInfo> tables, Future<T> Function() fetch) async* {
    yield await fetch();
    await for (final _ in db.tableUpdates(TableUpdateQuery.onAllTables(tables))) {
      yield await fetch();
    }
  }

  // ---------------------------------------------------------------- plans

  Future<MealPlan?> activePlan() =>
      (db.select(db.mealPlans)
            ..where((t) => t.isActive.equals(true))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
            ..limit(1))
          .getSingleOrNull();

  Stream<MealPlan?> watchActivePlan() =>
      (db.select(db.mealPlans)
            ..where((t) => t.isActive.equals(true))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
            ..limit(1))
          .watchSingleOrNull();

  Future<List<PlannedMeal>> plannedMeals(int planId) => (db.select(db.plannedMeals)
        ..where((t) => t.mealPlanId.equals(planId))
        ..orderBy([(t) => OrderingTerm.asc(t.mealIndex)]))
      .get();

  Stream<List<PlannedMeal>> watchPlannedMeals(int planId) => (db.select(db.plannedMeals)
        ..where((t) => t.mealPlanId.equals(planId))
        ..orderBy([(t) => OrderingTerm.asc(t.mealIndex)]))
      .watch();

  /// Saves [draft] as the only active plan (others deactivated) and returns its id.
  Future<int> savePlan(PlanDraft draft) {
    return db.transaction(() async {
      await db.update(db.mealPlans).write(const MealPlansCompanion(isActive: Value(false)));
      final id = await db.into(db.mealPlans).insert(MealPlansCompanion.insert(
            name: draft.name.isEmpty ? joinBilingual('خطة الأكل', 'Meal plan') : draft.name,
            isActive: const Value(true),
            notes: Value(draft.notes.isEmpty ? null : draft.notes),
            rawJson: Value(jsonEncode(draft.toJson())),
          ));
      Future<void> insertDay(List<PlanMealDraft> meals, String dayType) async {
        for (final (i, m) in meals.indexed) {
          final t = m.totals;
          await db.into(db.plannedMeals).insert(PlannedMealsCompanion.insert(
                mealPlanId: id,
                dayType: Value(dayType),
                mealIndex: i,
                name: joinBilingual(m.nameAr, m.nameEn),
                time: Value(m.time),
                itemsJson: Value(encodeItems(m.items)),
                calories: Value(t.calories),
                protein: Value(t.protein),
                carbs: Value(t.carbs),
                fat: Value(t.fat),
              ));
        }
      }

      await insertDay(draft.trainingDay, 'training');
      await insertDay(draft.restDay, 'rest');
      return id;
    });
  }

  /// Replaces one planned meal's content (meal swap).
  Future<void> replacePlannedMeal(int plannedMealId, {required String nameAr, required String nameEn, required List<FoodEntry> items}) async {
    final t = sumEntries(items);
    await (db.update(db.plannedMeals)..where((r) => r.id.equals(plannedMealId))).write(PlannedMealsCompanion(
      name: Value(joinBilingual(nameAr, nameEn)),
      itemsJson: Value(encodeItems(items)),
      calories: Value(t.calories),
      protein: Value(t.protein),
      carbs: Value(t.carbs),
      fat: Value(t.fat),
    ));
  }

  // ---------------------------------------------------------------- logs

  Future<MealLog?> getLog(int id) => (db.select(db.mealLogs)..where((t) => t.id.equals(id))).getSingleOrNull();

  Expression<bool> _onDay(GeneratedColumn<DateTime> col, DateTime day) {
    final d = DateTime(day.year, day.month, day.day);
    return col.isBiggerOrEqualValue(d) & col.isSmallerThanValue(DateTime(d.year, d.month, d.day + 1));
  }

  Stream<List<MealLog>> watchLogsForDay(DateTime day) => (db.select(db.mealLogs)
        ..where((t) => _onDay(t.date, day))
        ..orderBy([(t) => OrderingTerm.asc(t.loggedAt)]))
      .watch();

  Future<List<MealLog>> logsBetween(DateTime from, DateTime toExclusive) => (db.select(db.mealLogs)
        ..where((t) => t.date.isBiggerOrEqualValue(from) & t.date.isSmallerThanValue(toExclusive)))
      .get();

  Future<int> addLog({
    required DateTime day,
    required String name,
    required List<FoodEntry> items,
    String source = 'manual',
    int? mealIndex,
    int? plannedMealId,
    String? photoPath,
    double? confidence,
    String status = 'done',
  }) {
    final t = sumEntries(items);
    return db.into(db.mealLogs).insert(MealLogsCompanion.insert(
          date: DateTime(day.year, day.month, day.day),
          loggedAt: Value(DateTime.now()),
          name: name,
          mealIndex: Value(mealIndex),
          plannedMealId: Value(plannedMealId),
          itemsJson: Value(encodeItems(items)),
          calories: Value(t.calories),
          protein: Value(t.protein),
          carbs: Value(t.carbs),
          fat: Value(t.fat),
          photoPath: Value(photoPath),
          source: Value(source),
          confidence: Value(confidence),
          status: Value(status),
        ));
  }

  Future<void> updateLog(int id, {required String name, required List<FoodEntry> items, int? mealIndex, bool clearMealIndex = false, double? confidence, String? status}) async {
    final t = sumEntries(items);
    await (db.update(db.mealLogs)..where((r) => r.id.equals(id))).write(MealLogsCompanion(
      name: Value(name),
      itemsJson: Value(encodeItems(items)),
      calories: Value(t.calories),
      protein: Value(t.protein),
      carbs: Value(t.carbs),
      fat: Value(t.fat),
      mealIndex: clearMealIndex ? const Value(null) : (mealIndex == null ? const Value.absent() : Value(mealIndex)),
      confidence: confidence == null ? const Value.absent() : Value(confidence),
      status: status == null ? const Value.absent() : Value(status),
    ));
  }

  /// Deletes a log (and its photo file, best-effort).
  Future<MealLog?> deleteLog(int id, {bool deletePhoto = true}) async {
    final log = await getLog(id);
    await (db.delete(db.mealLogs)..where((t) => t.id.equals(id))).go();
    if (deletePhoto && log?.photoPath != null) {
      try {
        final f = File(await resolveAppPath(log!.photoPath!));
        if (await f.exists()) await f.delete();
      } catch (_) {}
    }
    return log;
  }

  /// Restores a deleted log (undo).
  Future<int> restoreLog(MealLog log) => db.into(db.mealLogs).insert(log.toCompanion(true).copyWith(id: const Value.absent()));

  /// One-tap "ate as planned".
  Future<int> logPlannedMeal(PlannedMeal meal, DateTime day, {double portion = 1}) {
    final items = scaleMeal(decodeItems(meal.itemsJson), portion);
    return addLog(
      day: day,
      name: meal.name,
      items: items,
      source: 'plan',
      mealIndex: meal.mealIndex,
      plannedMealId: meal.id,
    );
  }

  // ---------------------------------------------------------------- my foods

  Stream<List<FoodItem>> watchMyFoods() => (db.select(db.foodItems)
        ..orderBy([
          (t) => OrderingTerm.desc(t.isFavorite),
          (t) => OrderingTerm.desc(t.useCount),
          (t) => OrderingTerm.desc(t.lastUsed),
        ]))
      .watch();

  /// Saves (or refreshes, matched by name) a meal into "my foods".
  Future<int> saveMyFood(String name, List<FoodEntry> items, {bool countUse = false}) async {
    final t = sumEntries(items);
    final existing = await (db.select(db.foodItems)..where((r) => r.name.equals(name))..limit(1)).getSingleOrNull();
    if (existing != null) {
      await (db.update(db.foodItems)..where((r) => r.id.equals(existing.id))).write(FoodItemsCompanion(
        itemsJson: Value(encodeItems(items)),
        calories: Value(t.calories),
        protein: Value(t.protein),
        carbs: Value(t.carbs),
        fat: Value(t.fat),
        useCount: countUse ? Value(existing.useCount + 1) : const Value.absent(),
        lastUsed: countUse ? Value(DateTime.now()) : const Value.absent(),
      ));
      return existing.id;
    }
    return db.into(db.foodItems).insert(FoodItemsCompanion.insert(
          name: name,
          itemsJson: Value(encodeItems(items)),
          calories: t.calories,
          protein: t.protein,
          carbs: t.carbs,
          fat: t.fat,
          useCount: Value(countUse ? 1 : 0),
          lastUsed: Value(countUse ? DateTime.now() : null),
        ));
  }

  /// One-tap log from "my foods" (no AI, offline).
  Future<int> logMyFood(FoodItem f, DateTime day, {int? mealIndex, double portion = 1}) async {
    await (db.update(db.foodItems)..where((r) => r.id.equals(f.id)))
        .write(FoodItemsCompanion(useCount: Value(f.useCount + 1), lastUsed: Value(DateTime.now())));
    var items = decodeItems(f.itemsJson);
    if (items.isEmpty) {
      items = [
        FoodEntry(nameAr: f.name, nameEn: f.name, grams: 0, calories: f.calories, protein: f.protein, carbs: f.carbs, fat: f.fat),
      ];
    }
    return addLog(day: day, name: f.name, items: scaleMeal(items, portion), source: 'saved', mealIndex: mealIndex);
  }

  Future<void> deleteMyFood(int id) => (db.delete(db.foodItems)..where((t) => t.id.equals(id))).go();

  Future<void> setMyFoodFavorite(int id, bool fav) =>
      (db.update(db.foodItems)..where((t) => t.id.equals(id))).write(FoodItemsCompanion(isFavorite: Value(fav)));

  // ---------------------------------------------------------------- supplements (written by tracking)

  Future<List<TakenSupplement>> supplementsTaken(DateTime from, DateTime toExclusive) async {
    final q = db.select(db.supplementLogs).join([
      innerJoin(db.supplements, db.supplements.id.equalsExp(db.supplementLogs.supplementId)),
    ])
      ..where(db.supplementLogs.taken.equals(true) &
          db.supplementLogs.date.isBiggerOrEqualValue(from) &
          db.supplementLogs.date.isSmallerThanValue(toExclusive));
    final rows = await q.get();
    final counts = <int, int>{};
    final sups = <int, Supplement>{};
    for (final r in rows) {
      final s = r.readTable(db.supplements);
      sups[s.id] = s;
      counts[s.id] = (counts[s.id] ?? 0) + 1;
    }
    return [for (final e in counts.entries) TakenSupplement(sups[e.key]!, e.value)];
  }

  Future<List<(DateTime, Supplement)>> _supplementRows(DateTime from, DateTime toExclusive) async {
    final q = db.select(db.supplementLogs).join([
      innerJoin(db.supplements, db.supplements.id.equalsExp(db.supplementLogs.supplementId)),
    ])
      ..where(db.supplementLogs.taken.equals(true) &
          db.supplementLogs.date.isBiggerOrEqualValue(from) &
          db.supplementLogs.date.isSmallerThanValue(toExclusive));
    final rows = await q.get();
    return [for (final r in rows) (r.readTable(db.supplementLogs).date, r.readTable(db.supplements))];
  }

  Stream<List<TakenSupplement>> watchSupplementsTaken(DateTime day) {
    final d = DateTime(day.year, day.month, day.day);
    return _watchTables([db.supplementLogs, db.supplements], () => supplementsTaken(d, DateTime(d.year, d.month, d.day + 1)));
  }

  // ---------------------------------------------------------------- aggregates

  Future<ConsumedTotals> consumedForDay(DateTime day) async {
    final d = DateTime(day.year, day.month, day.day);
    final next = DateTime(d.year, d.month, d.day + 1);
    return aggregateConsumed(await logsBetween(d, next), await supplementsTaken(d, next));
  }

  Stream<ConsumedTotals> watchConsumedForDay(DateTime day) =>
      _watchTables([db.mealLogs, db.supplementLogs, db.supplements], () => consumedForDay(day));

  /// Per-day totals for [from, toInclusive] (every day present, zeros when empty).
  Future<Map<DateTime, ConsumedTotals>> consumedRange(DateTime from, DateTime toInclusive) async {
    final start = DateTime(from.year, from.month, from.day);
    final end = DateTime(toInclusive.year, toInclusive.month, toInclusive.day + 1);
    final logs = await logsBetween(start, end);
    final sups = await _supplementRows(start, end);
    final logsByDay = <DateTime, List<MealLog>>{};
    for (final l in logs) {
      logsByDay.putIfAbsent(DateTime(l.date.year, l.date.month, l.date.day), () => []).add(l);
    }
    final supByDay = <DateTime, Map<int, TakenSupplement>>{};
    for (final (date, s) in sups) {
      final m = supByDay.putIfAbsent(DateTime(date.year, date.month, date.day), () => {});
      m[s.id] = TakenSupplement(s, (m[s.id]?.count ?? 0) + 1);
    }
    final out = <DateTime, ConsumedTotals>{};
    for (var d = start; d.isBefore(end); d = DateTime(d.year, d.month, d.day + 1)) {
      out[d] = aggregateConsumed(logsByDay[d] ?? const [], supByDay[d]?.values.toList() ?? const []);
    }
    return out;
  }

  Stream<Map<DateTime, ConsumedTotals>> watchConsumedRange(DateTime from, DateTime toInclusive) =>
      _watchTables([db.mealLogs, db.supplementLogs, db.supplements], () => consumedRange(from, toInclusive));

  // ---------------------------------------------------------------- photos

  /// Copies [bytes] into the app's private meal photo folder; returns the relative path.
  static Future<String> savePhoto(List<int> bytes) async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, mealPhotoDir));
    if (!await dir.exists()) await dir.create(recursive: true);
    final name = 'meal_${DateTime.now().millisecondsSinceEpoch}.jpg';
    await File(p.join(dir.path, name)).writeAsBytes(bytes, flush: true);
    return p.join(mealPhotoDir, name);
  }
}

final nutritionRepositoryProvider =
    Provider<NutritionRepository>((ref) => NutritionRepository(ref.watch(databaseProvider)));

/// Shared matcher re-export for UI code.
EgyptianFood? matchFood(FoodEntry e) =>
    (e.foodId != null ? egyptianFoodsById[e.foodId] : null) ?? matchEgyptianFood(e.nameAr, e.nameEn);
