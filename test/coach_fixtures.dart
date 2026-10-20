import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:ironmind/core/providers.dart';

/// Fixed "now" used by coach tests: Tuesday 2026-10-20 10:00.
final testNow = DateTime(2026, 10, 20, 10);

class CoachFixture {
  final AppDatabase db;
  final int planId;
  final int pushDayId; // Tuesday
  final int restDayId; // Wednesday
  final int benchPeId;
  final int flyPeId;
  CoachFixture(this.db, this.planId, this.pushDayId, this.restDayId, this.benchPeId, this.flyPeId);
}

Future<void> _ex(AppDatabase db, String id, String en, String ar, String muscle, String equipment) =>
    db.into(db.exercises).insert(ExercisesCompanion.insert(
          id: id,
          nameEn: en,
          nameAr: ar,
          primaryMusclesJson: Value('["$muscle"]'),
          equipment: Value(equipment),
          force: const Value('push'),
          mechanic: const Value('compound'),
          category: const Value('strength'),
        ));

/// In-memory DB with a profile, an active plan, two weeks of sessions, meals,
/// weights, sleep/recovery and a memory.
Future<CoachFixture> seedCoachDb({bool withLogs = true}) async {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  final db = AppDatabase(NativeDatabase.memory());
  await _ex(db, 'Barbell_Bench_Press', 'Barbell Bench Press', 'بنش برس بالبار', 'chest', 'barbell');
  await _ex(db, 'Dumbbell_Bench_Press', 'Dumbbell Bench Press', 'بنش برس دمبل', 'chest', 'dumbbell');
  await _ex(db, 'Cable_Fly', 'Cable Fly', 'فلاي كابل', 'chest', 'cable');
  await _ex(db, 'Barbell_Squat', 'Barbell Squat', 'سكوات بالبار', 'quadriceps', 'barbell');

  await db.into(db.userProfiles).insert(UserProfilesCompanion.insert(
        id: const Value(1),
        language: const Value('ar'),
        sex: const Value('male'),
        age: const Value(30),
        heightCm: const Value(180),
        weightKg: const Value(82),
        goal: const Value('cut'),
        wakeTime: const Value('07:00'),
        trainingDaysJson: const Value('[2,4,6]'),
        calorieTarget: const Value(2400),
        proteinG: const Value(180),
        carbsG: const Value(240),
        fatG: const Value(70),
        trainingDayCarbsG: const Value(270),
        restDayCarbsG: const Value(210),
        onboardingComplete: const Value(true),
      ));

  final planId = await db.into(db.workoutPlans).insert(WorkoutPlansCompanion.insert(
        name: 'Push Pull Legs',
        isActive: const Value(true),
        activatedAt: Value(DateTime(2026, 9, 1)),
      ));
  final pushDay = await db.into(db.planDays).insert(PlanDaysCompanion.insert(
        planId: planId,
        name: 'Push A',
        weekday: const Value(DateTime.tuesday),
        focus: const Value('chest'),
      ));
  final restDay = await db.into(db.planDays).insert(PlanDaysCompanion.insert(
        planId: planId,
        name: 'Rest',
        weekday: const Value(DateTime.wednesday),
        isRest: const Value(true),
        orderIndex: const Value(1),
      ));
  final benchPe = await db.into(db.planExercises).insert(PlanExercisesCompanion.insert(
        planDayId: pushDay,
        exerciseId: 'Barbell_Bench_Press',
        sets: const Value(3),
        repMin: const Value(6),
        repMax: const Value(8),
        suggestedWeightKg: const Value(80),
        restSeconds: const Value(120),
      ));
  final flyPe = await db.into(db.planExercises).insert(PlanExercisesCompanion.insert(
        planDayId: pushDay,
        exerciseId: 'Cable_Fly',
        orderIndex: const Value(1),
      ));

  if (withLogs) {
    // Two sessions in the last 7 days + one older.
    Future<int> session(DateTime day, String status) => db.into(db.workoutSessions).insert(
          WorkoutSessionsCompanion.insert(
            date: day,
            planDayId: Value(pushDay),
            name: const Value('Push A'),
            status: Value(status),
            startedAt: Value(day.add(const Duration(hours: 18))),
            endedAt: Value(day.add(const Duration(hours: 19, minutes: 5))),
          ),
        );
    Future<void> set(int sid, String ex, int idx, double w, int reps, {bool pr = false, String type = 'normal', DateTime? at}) =>
        db.into(db.setLogs).insert(SetLogsCompanion.insert(
              sessionId: sid,
              exerciseId: ex,
              setIndex: idx,
              weightKg: w,
              reps: reps,
              rpe: const Value(8),
              setType: Value(type),
              isPr: Value(pr),
              prTypes: Value(pr ? 'weight,e1rm' : null),
              createdAt: Value(at ?? DateTime(2026, 10, 1)),
            ));
    final old = await session(DateTime(2026, 10, 6), 'completed');
    await set(old, 'Barbell_Bench_Press', 0, 77.5, 8, at: DateTime(2026, 10, 6, 18));
    final s1 = await session(DateTime(2026, 10, 15), 'completed');
    await set(s1, 'Barbell_Bench_Press', 0, 40, 10, type: 'warmup', at: DateTime(2026, 10, 15, 18));
    await set(s1, 'Barbell_Bench_Press', 1, 80, 8, pr: true, at: DateTime(2026, 10, 15, 18, 5));
    await set(s1, 'Barbell_Bench_Press', 2, 80, 7, at: DateTime(2026, 10, 15, 18, 8));
    await set(s1, 'Cable_Fly', 0, 15, 12, at: DateTime(2026, 10, 15, 18, 20));
    await session(DateTime(2026, 10, 17), 'missed');

    await db.into(db.mealLogs).insert(MealLogsCompanion.insert(
          date: DateTime(2026, 10, 19),
          name: 'Koshary',
          calories: const Value(1200),
          protein: const Value(40),
          carbs: const Value(200),
          fat: const Value(25),
        ));
    await db.into(db.mealLogs).insert(MealLogsCompanion.insert(
          date: DateTime(2026, 10, 19),
          name: 'Chicken',
          calories: const Value(900),
          protein: const Value(110),
          carbs: const Value(30),
          fat: const Value(30),
        ));
    for (final (d, w) in [(DateTime(2026, 10, 8), 83.4), (DateTime(2026, 10, 12), 83.0), (DateTime(2026, 10, 19), 82.2)]) {
      await db.into(db.bodyMetrics).insert(BodyMetricsCompanion.insert(date: d, weightKg: Value(w)));
    }
    await db.into(db.sleepLogs).insert(SleepLogsCompanion.insert(
          date: DateTime(2026, 10, 19),
          durationMin: 390,
          quality: const Value(3),
        ));
    await db.into(db.healthDaily).insert(HealthDailyCompanion.insert(
          date: DateTime(2026, 10, 19),
          recoveryScore: const Value(55),
          hrv: const Value(48),
          restingHr: const Value(58),
        ));
    await db.into(db.coachMemories).insert(CoachMemoriesCompanion.insert(content: 'الكتف الشمال بيوجع في الـ Overhead Press'));
  }
  return CoachFixture(db, planId, pushDay, restDay, benchPe, flyPe);
}
