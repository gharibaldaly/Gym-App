/// BMR / TDEE / calorie & macro targets / water goal.
/// Used as a local baseline (works offline); the AI plan may refine it.
library;

import 'dart:math';

class NutritionTargets {
  final double bmr;
  final double tdee;
  final int calories;
  final int proteinG;
  final int carbsG;
  final int fatG;
  final int trainingDayCarbsG;
  final int restDayCarbsG;
  const NutritionTargets({
    required this.bmr,
    required this.tdee,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.trainingDayCarbsG,
    required this.restDayCarbsG,
  });
}

class NutritionCalc {
  /// Mifflin-St Jeor, or Katch-McArdle when body-fat % is known.
  static double bmr({
    required bool male,
    required double weightKg,
    required double heightCm,
    required int age,
    double? bodyFatPct,
  }) {
    if (bodyFatPct != null && bodyFatPct > 3 && bodyFatPct < 60) {
      final lbm = weightKg * (1 - bodyFatPct / 100);
      return 370 + 21.6 * lbm;
    }
    final base = 10 * weightKg + 6.25 * heightCm - 5 * age;
    return male ? base + 5 : base - 161;
  }

  /// Activity multiplier from job type (desk/mobile/physical) and training days per week.
  static double activityFactor({String? jobType, int trainingDays = 3}) {
    final job = switch (jobType) {
      'physical' => 0.25,
      'mobile' => 0.12,
      _ => 0.0,
    };
    final training = (trainingDays.clamp(0, 7)) * 0.05; // ~0.05 per weekly session
    return 1.2 + job + training;
  }

  static double tdee(double bmr, double factor) => bmr * factor;

  /// Calorie adjustment by goal.
  static int calorieTarget(double tdee, String? goal) {
    final f = switch (goal) {
      'bulk' => 1.10,
      'cut' => 0.80,
      'recomp' => 0.95,
      'strength' => 1.05,
      _ => 1.0,
    };
    return (tdee * f).round();
  }

  static NutritionTargets compute({
    required bool male,
    required double weightKg,
    required double heightCm,
    required int age,
    double? bodyFatPct,
    String? jobType,
    int trainingDays = 3,
    String? goal,
  }) {
    final b = bmr(male: male, weightKg: weightKg, heightCm: heightCm, age: age, bodyFatPct: bodyFatPct);
    final t = tdee(b, activityFactor(jobType: jobType, trainingDays: trainingDays));
    final kcal = calorieTarget(t, goal);
    final proteinPerKg = switch (goal) {
      'cut' => 2.2,
      'recomp' => 2.0,
      'bulk' => 1.8,
      'strength' => 1.8,
      _ => 1.6,
    };
    final protein = (weightKg * proteinPerKg).round();
    final fat = max((weightKg * 0.8).round(), (kcal * 0.22 / 9).round());
    final carbs = max(0, ((kcal - protein * 4 - fat * 9) / 4).round());
    // Carb cycling: training days +15%, rest days balanced so the weekly average matches.
    final days = trainingDays.clamp(0, 7);
    final trainCarbs = (carbs * 1.15).round();
    final restCarbs = days >= 7 ? carbs : max(0, ((carbs * 7 - trainCarbs * days) / (7 - days)).round());
    return NutritionTargets(
      bmr: b,
      tdee: t,
      calories: kcal,
      proteinG: protein,
      carbsG: carbs,
      fatG: fat,
      trainingDayCarbsG: days == 0 ? carbs : trainCarbs,
      restDayCarbsG: restCarbs,
    );
  }

  /// ~35 ml/kg + 500 ml on training days, rounded to 250 ml.
  static int waterGoalMl(double weightKg, {bool trainingDay = true}) {
    final ml = weightKg * 35 + (trainingDay ? 500 : 0);
    return ((ml / 250).round() * 250).clamp(1500, 6000);
  }

  static double macroCalories({double protein = 0, double carbs = 0, double fat = 0}) =>
      protein * 4 + carbs * 4 + fat * 9;
}
