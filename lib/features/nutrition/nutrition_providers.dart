import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../ai/ai_queue.dart';
import '../../core/providers.dart';
import '../../core/utils/context_ext.dart' show dayOf, today;
import '../../data/repositories/profile_repository.dart';
import 'egyptian_foods.dart';
import 'food_ai.dart';
import 'nutrition_logic.dart';
import 'nutrition_repository.dart';

export 'nutrition_repository.dart' show nutritionRepositoryProvider, NutritionRepository, ConsumedTotals, TakenSupplement;

class DayNutrition {
  final double calories, protein, carbs, fat;
  final double targetCalories, targetProtein, targetCarbs, targetFat;

  /// The day these numbers are for (local midnight); null for legacy callers.
  final DateTime? date;
  final bool isTrainingDay;

  /// Part of the consumed totals that came from supplements (already included above).
  final double supplementCalories, supplementProtein;
  final int mealsLogged;

  /// Photo/text logs still waiting for AI analysis (not counted yet).
  final int pendingCount;

  const DayNutrition({
    this.calories = 0,
    this.protein = 0,
    this.carbs = 0,
    this.fat = 0,
    this.targetCalories = 0,
    this.targetProtein = 0,
    this.targetCarbs = 0,
    this.targetFat = 0,
    this.date,
    this.isTrainingDay = false,
    this.supplementCalories = 0,
    this.supplementProtein = 0,
    this.mealsLogged = 0,
    this.pendingCount = 0,
  });
  double get remainingCalories => targetCalories - calories;
  double get remainingProtein => targetProtein - protein;
  double get remainingCarbs => targetCarbs - carbs;
  double get remainingFat => targetFat - fat;

  /// 0..1+ share of the calorie target eaten.
  double get calorieProgress => targetCalories <= 0 ? 0 : calories / targetCalories;

  bool get hasTargets => targetCalories > 0;
  bool get isEmpty => calories == 0 && mealsLogged == 0;
}

/// Day targets from the profile (carb cycling: training vs rest day).
MacroTargets? targetsForDay(UserProfile? p, DateTime day) {
  if (p == null || p.calorieTarget == null) return null;
  return MacroTargets(
    calories: (p.caloriesFor(day) ?? p.calorieTarget!).toDouble(),
    protein: (p.proteinG ?? 0).toDouble(),
    carbs: (p.carbsFor(day) ?? 0).toDouble(),
    fat: (p.fatG ?? 0).toDouble(),
  );
}

/// Training/rest day targets regardless of date.
MacroTargets? targetsForDayType(UserProfile? p, {required bool training}) {
  if (p == null || p.calorieTarget == null) return null;
  return MacroTargets.forDay(
    calorieTarget: p.calorieTarget!,
    proteinG: p.proteinG ?? 0,
    carbsG: p.carbsG ?? 0,
    fatG: p.fatG ?? 0,
    dayCarbsG: training ? p.trainingDayCarbsG : p.restDayCarbsG,
  );
}

DayNutrition buildDayNutrition(DateTime day, ConsumedTotals c, UserProfile? p) {
  final t = targetsForDay(p, day);
  final total = c.total;
  return DayNutrition(
    calories: total.calories,
    protein: total.protein,
    carbs: total.carbs,
    fat: total.fat,
    targetCalories: t?.calories ?? 0,
    targetProtein: t?.protein ?? 0,
    targetCarbs: t?.carbs ?? 0,
    targetFat: t?.fat ?? 0,
    date: dayOf(day),
    isTrainingDay: p?.isTrainingDay(day) ?? false,
    supplementCalories: c.supplements.calories,
    supplementProtein: c.supplements.protein,
    mealsLogged: c.mealsLogged,
    pendingCount: c.pendingCount,
  );
}

/// Invalidates [ref] at the next local midnight so "today" providers roll over.
void _rollOverAtMidnight(Ref ref) {
  final now = DateTime.now();
  final next = DateTime(now.year, now.month, now.day + 1);
  final t = Timer(next.difference(now) + const Duration(seconds: 1), ref.invalidateSelf);
  ref.onDispose(t.cancel);
}

/// Consumed (meals + supplements) vs targets for one day. Used by Progress & reports.
final nutritionForDayProvider = StreamProvider.family<DayNutrition, DateTime>((ref, date) async* {
  final day = dayOf(date);
  final profile = await ref.watch(profileProvider.future);
  yield* ref.watch(nutritionRepositoryProvider).watchConsumedForDay(day).map((c) => buildDayNutrition(day, c, profile));
});

/// Consumed (meals + supplements) vs targets for today.
final todayNutritionProvider = StreamProvider<DayNutrition>((ref) async* {
  _rollOverAtMidnight(ref);
  final day = today();
  final profile = await ref.watch(profileProvider.future);
  yield* ref.watch(nutritionRepositoryProvider).watchConsumedForDay(day).map((c) => buildDayNutrition(day, c, profile));
});

/// Per-day nutrition for an inclusive date range (charts / reports).
final nutritionRangeProvider =
    StreamProvider.family<List<DayNutrition>, ({DateTime from, DateTime to})>((ref, range) async* {
  final profile = await ref.watch(profileProvider.future);
  yield* ref
      .watch(nutritionRepositoryProvider)
      .watchConsumedRange(dayOf(range.from), dayOf(range.to))
      .map((m) => [for (final e in m.entries) buildDayNutrition(e.key, e.value, profile)]);
});

/// Last 7 days ending today (oldest first).
final weeklyNutritionProvider = StreamProvider<List<DayNutrition>>((ref) async* {
  _rollOverAtMidnight(ref);
  final end = today();
  final start = DateTime(end.year, end.month, end.day - 6);
  final profile = await ref.watch(profileProvider.future);
  yield* ref
      .watch(nutritionRepositoryProvider)
      .watchConsumedRange(start, end)
      .map((m) => [for (final e in m.entries) buildDayNutrition(e.key, e.value, profile)]);
});

/// Active meal plan (null = none yet).
final activeMealPlanProvider = StreamProvider<MealPlan?>((ref) => ref.watch(nutritionRepositoryProvider).watchActivePlan());

/// Planned meals of the active plan (both day types).
final activePlannedMealsProvider = StreamProvider<List<PlannedMeal>>((ref) async* {
  final plan = await ref.watch(activeMealPlanProvider.future);
  if (plan == null) {
    yield const [];
    return;
  }
  yield* ref.watch(nutritionRepositoryProvider).watchPlannedMeals(plan.id);
});

/// Planned meals for a given day type ('training' / 'rest'; 'all' rows always included).
List<PlannedMeal> mealsForDayType(List<PlannedMeal> all, {required bool training}) {
  final type = training ? 'training' : 'rest';
  final list = all.where((m) => m.dayType == type || m.dayType == 'all').toList()
    ..sort((a, b) => a.mealIndex.compareTo(b.mealIndex));
  return list;
}

/// Planned meals for today's day type.
final todayPlannedMealsProvider = Provider<AsyncValue<List<PlannedMeal>>>((ref) {
  final profile = ref.watch(profileProvider).value;
  final training = profile?.isTrainingDay(DateTime.now()) ?? false;
  return ref.watch(activePlannedMealsProvider).whenData((all) => mealsForDayType(all, training: training));
});

/// Meal logs of today (incl. pending AI ones).
final todayMealLogsProvider = StreamProvider<List<MealLog>>((ref) {
  _rollOverAtMidnight(ref);
  return ref.watch(nutritionRepositoryProvider).watchLogsForDay(today());
});

final mealLogsForDayProvider = StreamProvider.family<List<MealLog>, DateTime>(
    (ref, day) => ref.watch(nutritionRepositoryProvider).watchLogsForDay(dayOf(day)));

/// Supplements marked as taken today (rows written by the tracking feature).
final todaySupplementsTakenProvider = StreamProvider<List<TakenSupplement>>((ref) {
  _rollOverAtMidnight(ref);
  return ref.watch(nutritionRepositoryProvider).watchSupplementsTaken(today());
});

/// "My foods" sorted by favorite, then use count.
final myFoodsProvider = StreamProvider<List<FoodItem>>((ref) => ref.watch(nutritionRepositoryProvider).watchMyFoods());

/// Number of nutrition AI jobs still waiting in the offline queue.
final pendingAiJobsProvider = StreamProvider<int>((ref) => ref.watch(aiQueueProvider).watchPendingCount());

/// Re-exported so feature code can look up built-in foods by id.
EgyptianFood? builtInFood(String id) => egyptianFoodsById[id];

/// Registers offline AI-queue handlers owned by nutrition (food photo analysis…).
void registerNutritionAiHandlers() {
  AiQueueService.register(FoodAi.photoQueueKey, FoodAi.handlePhotoJob);
  AiQueueService.register(FoodAi.textQueueKey, FoodAi.handleTextJob);
}
