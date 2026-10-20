import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/calc/nutrition_calc.dart';
import '../../core/providers.dart';

/// Access to the single user_profiles row (id = 1).
class ProfileRepository {
  final AppDatabase db;
  ProfileRepository(this.db);

  static const _id = 1;

  Future<UserProfile?> get() => (db.select(db.userProfiles)..where((t) => t.id.equals(_id))).getSingleOrNull();

  Stream<UserProfile?> watch() =>
      (db.select(db.userProfiles)..where((t) => t.id.equals(_id))).watchSingleOrNull();

  /// Insert-or-update with the given fields.
  Future<void> upsert(UserProfilesCompanion data) async {
    final existing = await get();
    final withTs = data.copyWith(updatedAt: Value(DateTime.now()));
    if (existing == null) {
      await db.into(db.userProfiles).insert(withTs.copyWith(id: const Value(_id)));
    } else {
      await (db.update(db.userProfiles)..where((t) => t.id.equals(_id))).write(withTs);
    }
  }

  /// Recomputes BMR/TDEE/macros/water locally from the profile (offline baseline).
  Future<NutritionTargets?> recomputeTargets() async {
    final p = await get();
    if (p == null || p.weightKg == null || p.heightCm == null || p.age == null) return null;
    final t = NutritionCalc.compute(
      male: p.sex != 'female',
      weightKg: p.weightKg!,
      heightCm: p.heightCm!,
      age: p.age!,
      bodyFatPct: p.bodyFatPct,
      jobType: p.jobType,
      trainingDays: p.daysPerWeek ?? 3,
      goal: p.goal,
    );
    await upsert(UserProfilesCompanion(
      bmr: Value(t.bmr),
      tdee: Value(t.tdee),
      calorieTarget: Value(t.calories),
      proteinG: Value(t.proteinG),
      carbsG: Value(t.carbsG),
      fatG: Value(t.fatG),
      trainingDayCarbsG: Value(t.trainingDayCarbsG),
      restDayCarbsG: Value(t.restDayCarbsG),
      waterGoalMl: Value(p.waterGoalMl ?? NutritionCalc.waterGoalMl(p.weightKg!)),
    ));
    return t;
  }
}

/// JSON-column helpers on the generated data class.
extension UserProfileX on UserProfile {
  List<int> get trainingDays => (jsonDecode(trainingDaysJson) as List).cast<int>();
  List<String> get focusMuscles => (jsonDecode(focusMusclesJson) as List).cast<String>();
  List<String> get injuries => (jsonDecode(injuriesJson) as List).cast<String>();
  List<String> get mealTimes => (jsonDecode(mealTimesJson) as List).cast<String>();
  Map<String, dynamic> get measurements => jsonDecode(measurementsJson) as Map<String, dynamic>;

  /// [{name, dose}]
  List<Map<String, dynamic>> get supplementsList =>
      (jsonDecode(supplementsJson) as List).cast<Map<String, dynamic>>();

  bool isTrainingDay(DateTime d) => trainingDays.contains(d.weekday);

  /// Carb target for a given day (carb cycling), falls back to the flat target.
  int? carbsFor(DateTime d) => isTrainingDay(d) ? (trainingDayCarbsG ?? carbsG) : (restDayCarbsG ?? carbsG);

  int? caloriesFor(DateTime d) {
    if (calorieTarget == null) return null;
    final c = carbsFor(d), base = carbsG;
    if (c == null || base == null) return calorieTarget;
    return calorieTarget! + (c - base) * 4;
  }

  /// Compact text block used in AI prompts.
  String toPromptSummary() {
    final m = <String, Object?>{
      'sex': sex,
      'age': age,
      'height_cm': heightCm,
      'weight_kg': weightKg,
      'body_fat_pct': bodyFatPct,
      'measurements_cm': measurements,
      'goal': goal,
      'target_weight_kg': targetWeightKg,
      'goal_weeks': goalWeeks,
      'level': level,
      'training_experience': trainingExperience,
      'days_per_week': daysPerWeek,
      'training_weekdays': trainingDays, // 1=Mon … 7=Sun
      'session_minutes': sessionMinutes,
      'split_preference': splitPreference,
      'focus_muscles': focusMuscles,
      'location': location,
      'injuries': injuries,
      'injuries_note': injuriesNote,
      'job_type': jobType,
      'job_hours': jobHours,
      'sleep_time': sleepTime,
      'wake_time': wakeTime,
      'training_time_of_day': trainingTimeOfDay,
      'cardio': {'type': cardioType, 'per_week': cardioPerWeek},
      'meals_per_day': mealsPerDay,
      'meal_times': mealTimes,
      'liked_foods': likedFoods,
      'disliked_foods': dislikedFoods,
      'allergies': allergies,
      'monthly_food_budget': {'level': budgetLevel, 'egp': budgetEgp},
      'supplements': supplementsList,
      'water_goal_ml': waterGoalMl,
      'targets': {
        'bmr': bmr?.round(),
        'tdee': tdee?.round(),
        'calories': calorieTarget,
        'protein_g': proteinG,
        'carbs_g': carbsG,
        'fat_g': fatG,
        'training_day_carbs_g': trainingDayCarbsG,
        'rest_day_carbs_g': restDayCarbsG,
      },
    }..removeWhere((k, v) => v == null);
    return const JsonEncoder.withIndent(' ').convert(m);
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>((ref) => ProfileRepository(ref.watch(databaseProvider)));

final profileProvider = StreamProvider<UserProfile?>((ref) => ref.watch(profileRepositoryProvider).watch());
