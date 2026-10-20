import 'dart:convert';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironmind/core/providers.dart';
import 'package:ironmind/features/nutrition/egyptian_foods.dart';
import 'package:ironmind/features/nutrition/meal_plan_generator.dart';
import 'package:ironmind/features/nutrition/nutrition_logic.dart';
import 'package:ironmind/features/nutrition/nutrition_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

FoodEntry _e(String id, double g) => FoodEntry.fromFood(food(id), g);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late NutritionRepository repo;
  final day = DateTime(2026, 10, 19); // Monday
  final next = DateTime(2026, 10, 20);

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = NutritionRepository(db);
  });
  tearDown(() => db.close());

  Future<int> addSupplement({double protein = 24, double kcal = 120}) => db.into(db.supplements).insert(
      SupplementsCompanion.insert(name: 'Whey', proteinG: Value(protein), calories: Value(kcal), carbsG: const Value(3)));

  group('DayNutrition aggregation', () {
    test('meals + supplements taken are summed, pending AI logs are not counted', () async {
      await repo.addLog(day: day, name: 'Breakfast', items: [_e('egg', 100), _e('baladi_bread', 90)]);
      await repo.addLog(day: day, name: 'Lunch', items: [_e('chicken_breast', 200), _e('rice', 250)], mealIndex: 1);
      await repo.addLog(day: day, name: 'Photo', items: const [], source: 'ai_photo', status: 'pending_ai');
      await repo.addLog(day: next, name: 'Tomorrow', items: [_e('rice', 100)]);
      final sup = await addSupplement();
      await db.into(db.supplementLogs).insert(SupplementLogsCompanion.insert(date: day, supplementId: sup));
      // not taken → ignored
      await db.into(db.supplementLogs).insert(
          SupplementLogsCompanion.insert(date: day, supplementId: sup, taken: const Value(false)));

      final c = await repo.consumedForDay(day);
      final meals = sumEntries([_e('egg', 100), _e('baladi_bread', 90), _e('chicken_breast', 200), _e('rice', 250)]);
      expect(c.mealsLogged, 2);
      expect(c.pendingCount, 1);
      expect(c.meals.calories, closeTo(meals.calories, 0.5));
      expect(c.supplements.protein, 24);
      expect(c.total.protein, closeTo(meals.protein + 24, 0.5));
      expect(c.total.calories, closeTo(meals.calories + 120, 0.5));
    });

    test('range gives one entry per day', () async {
      await repo.addLog(day: day, name: 'a', items: [_e('rice', 100)]);
      await repo.addLog(day: next, name: 'b', items: [_e('rice', 200)]);
      final sup = await addSupplement();
      await db.into(db.supplementLogs).insert(SupplementLogsCompanion.insert(date: next, supplementId: sup));
      final m = await repo.consumedRange(DateTime(2026, 10, 18), next);
      expect(m.keys.toList(), [DateTime(2026, 10, 18), day, next]);
      expect(m[DateTime(2026, 10, 18)]!.total.calories, 0);
      expect(m[day]!.total.calories, closeTo(130, 0.5));
      expect(m[next]!.total.calories, closeTo(260 + 120, 0.5));
    });

    test('stream updates when a meal or supplement is logged', () async {
      final values = <double>[];
      final sub = repo.watchConsumedForDay(day).listen((c) => values.add(c.total.calories));
      await pumpEventQueue();
      await repo.addLog(day: day, name: 'a', items: [_e('rice', 100)]);
      await pumpEventQueue();
      final sup = await addSupplement();
      await db.into(db.supplementLogs).insert(SupplementLogsCompanion.insert(date: day, supplementId: sup));
      await pumpEventQueue();
      await sub.cancel();
      expect(values.first, 0);
      expect(values.last, closeTo(250, 0.5));
    });

    test('provider uses training vs rest day targets (carb cycling)', () async {
      await db.into(db.userProfiles).insert(UserProfilesCompanion.insert(
            id: const Value(1),
            trainingDaysJson: const Value('[1,3,5]'),
            calorieTarget: const Value(2500),
            proteinG: const Value(180),
            carbsG: const Value(280),
            fatG: const Value(75),
            trainingDayCarbsG: const Value(320),
            restDayCarbsG: const Value(250),
          ));
      await repo.addLog(day: day, name: 'a', items: [_e('rice', 100)]);
      final container = ProviderContainer(overrides: [databaseProvider.overrideWithValue(db)]);
      addTearDown(container.dispose);

      final mon = await container.read(nutritionForDayProvider(day).future); // Monday = training
      expect(mon.isTrainingDay, isTrue);
      expect(mon.targetCarbs, 320);
      expect(mon.targetCalories, 2500 + 40 * 4);
      expect(mon.calories, closeTo(130, 0.5));
      expect(mon.remainingCalories, closeTo(2660 - 130, 0.5));

      final tue = await container.read(nutritionForDayProvider(next).future); // Tuesday = rest
      expect(tue.isTrainingDay, isFalse);
      expect(tue.targetCarbs, 250);
      expect(tue.targetCalories, 2500 - 30 * 4);
      expect(tue.calories, 0);

      final range = await container.read(nutritionRangeProvider((from: day, to: next)).future);
      expect(range.length, 2);
      expect(range.first.date, day);
    });
  });

  group('plans', () {
    PlanDraft draft(String name) => PlanDraft(
          name: name,
          notes: 'n',
          trainingDay: [
            PlanMealDraft(nameAr: 'فطار', nameEn: 'Breakfast', time: '09:00', items: [_e('egg', 150)]),
            PlanMealDraft(nameAr: 'غدا', nameEn: 'Lunch', time: '15:00', items: [_e('rice', 300)]),
          ],
          restDay: [
            PlanMealDraft(nameAr: 'فطار', nameEn: 'Breakfast', time: '09:00', items: [_e('egg', 100)]),
          ],
        );

    test('savePlan makes it the only active plan with training/rest rows', () async {
      final a = await repo.savePlan(draft('A'));
      final b = await repo.savePlan(draft('B'));
      final active = await repo.activePlan();
      expect(active!.id, b);
      final plans = await db.select(db.mealPlans).get();
      expect(plans.where((p) => p.isActive).length, 1);
      expect(plans.firstWhere((p) => p.id == a).isActive, isFalse);
      final meals = await repo.plannedMeals(b);
      expect(meals.where((m) => m.dayType == 'training').length, 2);
      expect(meals.where((m) => m.dayType == 'rest').length, 1);
      final lunch = meals.firstWhere((m) => m.dayType == 'training' && m.mealIndex == 1);
      expect(lunch.calories, closeTo(390, 0.5));
      expect(pickBilingual(lunch.name, 'ar'), 'غدا');
      expect(jsonDecode(active.rawJson!)['trainingDay']['meals'], hasLength(2));
      expect(mealsForDayType(meals, training: false).single.mealIndex, 0);
    });

    test('swap replaces a planned meal and one-tap logging copies it', () async {
      final id = await repo.savePlan(draft('A'));
      final meal = (await repo.plannedMeals(id)).first;
      await repo.replacePlannedMeal(meal.id, nameAr: 'فول', nameEn: 'Foul', items: [_e('foul', 300), _e('baladi_bread', 90)]);
      final swapped = (await repo.plannedMeals(id)).firstWhere((m) => m.id == meal.id);
      expect(pickBilingual(swapped.name, 'en'), 'Foul');
      expect(swapped.calories, closeTo(330 + 229.5, 0.5));

      final logId = await repo.logPlannedMeal(swapped, day, portion: 0.5);
      final log = await repo.getLog(logId);
      expect(log!.source, 'plan');
      expect(log.plannedMealId, swapped.id);
      expect(log.mealIndex, swapped.mealIndex);
      expect(log.calories, closeTo(swapped.calories / 2, 0.5));
    });

    test('generator falls back to the template plan without an API key', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      await db.into(db.userProfiles).insert(UserProfilesCompanion.insert(
            id: const Value(1),
            trainingDaysJson: const Value('[1,3,5]'),
            mealsPerDay: const Value(4),
            calorieTarget: const Value(2500),
            proteinG: const Value(170),
            carbsG: const Value(290),
            fatG: const Value(75),
            trainingDayCarbsG: const Value(330),
            restDayCarbsG: const Value(260),
          ));
      final container = ProviderContainer(overrides: [
        databaseProvider.overrideWithValue(db),
        sharedPrefsProvider.overrideWithValue(prefs),
        isOnlineProvider.overrideWithValue(true),
      ]);
      addTearDown(container.dispose);
      final res = await container.read(mealPlanGeneratorProvider).generate();
      expect(res.usedAi, isFalse);
      final plan = await repo.activePlan();
      expect(plan!.id, res.planId);
      final meals = await repo.plannedMeals(plan.id);
      expect(meals.where((m) => m.dayType == 'training').length, 4);
      final trainingKcal =
          meals.where((m) => m.dayType == 'training').fold(0.0, (a, m) => a + m.calories);
      expect(withinTolerance(trainingKcal, 2500 + 40 * 4), isTrue);
    });
  });

  group('my foods', () {
    test('save upserts by name and one-tap log counts uses', () async {
      final id = await repo.saveMyFood('كشري', [_e('koshary', 400)]);
      final again = await repo.saveMyFood('كشري', [_e('koshary', 500)]);
      expect(again, id);
      var f = (await db.select(db.foodItems).get()).single;
      expect(f.calories, closeTo(775, 0.5));
      expect(f.useCount, 0);
      final logId = await repo.logMyFood(f, day, portion: 0.5);
      f = (await db.select(db.foodItems).get()).single;
      expect(f.useCount, 1);
      final log = await repo.getLog(logId);
      expect(log!.source, 'saved');
      expect(log.calories, closeTo(387.5, 0.5));
    });

    test('delete + restore a log (undo)', () async {
      final id = await repo.addLog(day: day, name: 'x', items: [_e('rice', 100)]);
      final deleted = await repo.deleteLog(id, deletePhoto: false);
      expect(await repo.getLog(id), isNull);
      await repo.restoreLog(deleted!);
      expect((await repo.consumedForDay(day)).total.calories, closeTo(130, 0.5));
    });
  });
}
