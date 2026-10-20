// Shared in-memory DB seeding for the progress feature tests.
import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:ironmind/core/providers.dart';

AppDatabase memoryDb() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  return AppDatabase(NativeDatabase.memory());
}

Future<void> seedExercises(AppDatabase db) async {
  Future<void> ex(String id, String en, String ar, String muscles) => db.into(db.exercises).insert(
        ExercisesCompanion.insert(id: id, nameEn: en, nameAr: ar, primaryMusclesJson: Value(muscles)),
      );
  await ex('bench', 'Barbell Bench Press', 'بنش برس بالبار', '["chest"]');
  await ex('squat', 'Barbell Squat', 'سكوات بالبار', '["quadriceps"]');
  await ex('row', 'Bent Over Row', 'تجديف بالبار', '["middle back","lats"]');
}

Future<void> seedProfile(AppDatabase db, {required DateTime createdAt, String trainingDays = '[6,1,3]'}) =>
    db.into(db.userProfiles).insert(UserProfilesCompanion.insert(
          id: const Value(1),
          trainingDaysJson: Value(trainingDays),
          calorieTarget: const Value(2500),
          proteinG: const Value(160),
          carbsG: const Value(280),
          fatG: const Value(80),
          waterGoalMl: const Value(3000),
          createdAt: Value(createdAt),
        ));

Future<int> addSession(AppDatabase db, DateTime day, {String status = 'completed', String? name}) =>
    db.into(db.workoutSessions).insert(WorkoutSessionsCompanion.insert(
          date: day,
          status: Value(status),
          name: Value(name),
          startedAt: Value(day.add(const Duration(hours: 18))),
          endedAt: Value(day.add(const Duration(hours: 19, minutes: 5))),
        ));

int _setCounter = 0;

Future<void> addSet(
  AppDatabase db,
  int sessionId,
  String exerciseId,
  double weight,
  int reps, {
  double? rpe,
  String type = 'normal',
  required DateTime day,
}) {
  _setCounter++;
  return db.into(db.setLogs).insert(SetLogsCompanion.insert(
        sessionId: sessionId,
        exerciseId: exerciseId,
        setIndex: _setCounter,
        weightKg: weight,
        reps: reps,
        rpe: Value(rpe),
        setType: Value(type),
        createdAt: Value(day.add(Duration(hours: 18, seconds: _setCounter))),
      ));
}

/// A realistic fortnight (Sat 2026-10-03 … Tue 2026-10-20) used by several tests.
Future<void> seedFortnight(AppDatabase db) async {
  await seedExercises(db);
  await seedProfile(db, createdAt: DateTime(2026, 10, 1));

  // Week 1 (Sat 3 Oct – Fri 9 Oct): Sat completed, Mon completed, Wed partial.
  var s = await addSession(db, DateTime(2026, 10, 3), name: 'Push A');
  await addSet(db, s, 'bench', 40, 10, type: 'warmup', day: DateTime(2026, 10, 3));
  await addSet(db, s, 'bench', 80, 8, rpe: 8, day: DateTime(2026, 10, 3));
  await addSet(db, s, 'bench', 80, 7, rpe: 9, day: DateTime(2026, 10, 3));
  s = await addSession(db, DateTime(2026, 10, 5), name: 'Legs');
  await addSet(db, s, 'squat', 100, 5, rpe: 6, day: DateTime(2026, 10, 5));
  await addSet(db, s, 'squat', 100, 5, day: DateTime(2026, 10, 5));
  s = await addSession(db, DateTime(2026, 10, 7), status: 'partial', name: 'Pull');
  await addSet(db, s, 'row', 60, 10, rpe: 7, day: DateTime(2026, 10, 7));

  // Week 2 (Sat 10 Oct – Fri 16 Oct): Sat completed with PRs, Mon missed (no session), Wed explicit missed row.
  s = await addSession(db, DateTime(2026, 10, 10), name: 'Push A');
  await addSet(db, s, 'bench', 82.5, 8, rpe: 9, day: DateTime(2026, 10, 10)); // weight + e1rm PR
  await addSet(db, s, 'bench', 80, 9, rpe: 9, day: DateTime(2026, 10, 10)); // reps PR at 80
  await addSession(db, DateTime(2026, 10, 14), status: 'missed');

  // Week 3: Sat 17 completed (squat PR), Mon 19 nothing, Tue 20 = "today" (rest day).
  s = await addSession(db, DateTime(2026, 10, 17), name: 'Legs');
  await addSet(db, s, 'squat', 105, 5, rpe: 8, day: DateTime(2026, 10, 17));

  // Body weight + measurements.
  for (final (d, w) in [(3, 80.0), (6, 79.6), (10, 79.4), (13, 79.0), (17, 78.8)]) {
    await db.into(db.bodyMetrics).insert(BodyMetricsCompanion.insert(date: DateTime(2026, 10, d), weightKg: Value(w)));
  }
  await db.into(db.bodyMetrics).insert(
      BodyMetricsCompanion.insert(date: DateTime(2026, 10, 10), waistCm: const Value(84), armCm: const Value(37.5)));

  // Meals.
  for (final d in [10, 11, 12]) {
    await db.into(db.mealLogs).insert(MealLogsCompanion.insert(
        date: DateTime(2026, 10, d), name: 'فول وبيض', calories: const Value(1200), protein: const Value(70)));
    await db.into(db.mealLogs).insert(MealLogsCompanion.insert(
        date: DateTime(2026, 10, d), name: 'Chicken & rice', calories: const Value(1100), protein: const Value(80)));
  }
  await db.into(db.mealLogs).insert(MealLogsCompanion.insert(
      date: DateTime(2026, 10, 12), name: 'pending', calories: const Value(999), status: const Value('pending_ai')));

  // Water, sleep, recovery.
  await db.into(db.waterLogs).insert(WaterLogsCompanion.insert(timestamp: DateTime(2026, 10, 10, 9), amountMl: 500));
  await db.into(db.waterLogs).insert(WaterLogsCompanion.insert(timestamp: DateTime(2026, 10, 10, 15), amountMl: 750));
  await db.into(db.sleepLogs).insert(SleepLogsCompanion.insert(date: DateTime(2026, 10, 10), durationMin: 420, quality: const Value(4)));
  await db.into(db.sleepLogs).insert(SleepLogsCompanion.insert(date: DateTime(2026, 10, 11), durationMin: 480));
  await db.into(db.healthDaily).insert(HealthDailyCompanion.insert(date: DateTime(2026, 10, 10), recoveryScore: const Value(72)));

  // Coach weekly report inside week 2.
  await db.into(db.coachMessages).insert(CoachMessagesCompanion.insert(
        role: 'assistant',
        content: '## الأسبوع ده\n**شغل كويس** في البنش، كسرت رقمك.\n- الغياب يوم الحد مش مقبول.\n- زوّد البروتين شوية.',
        kind: const Value('weekly'),
        createdAt: Value(DateTime(2026, 10, 16, 21)),
      ));
}
