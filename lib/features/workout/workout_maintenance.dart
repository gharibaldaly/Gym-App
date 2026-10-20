import 'package:drift/drift.dart';

import '../../core/providers.dart';
import 'workout_logic.dart';
import 'workout_repository.dart';

/// Marks past planned training days with no session as 'missed' (schedule doesn't shift).
/// Looks back from the day after the active plan's activation, at most 60 days. Idempotent.
Future<void> markMissedDays(AppDatabase db, {DateTime? now}) async {
  final t = now ?? DateTime.now();
  final repo = WorkoutRepository(db);
  final plan = await repo.activePlan();
  if (plan == null || plan.activatedAt == null) return;
  final days = await repo.days(plan.id);
  final training = <int, PlanDay>{
    for (final d in days)
      if (!d.isRest && d.weekday != null) d.weekday!: d,
  };
  if (training.isEmpty) return;
  final earliest = DateTime(t.year, t.month, t.day - 61);
  final sessions = await (db.select(db.workoutSessions)..where((s) => s.date.isBiggerOrEqualValue(earliest))).get();
  final sessionDays = sessions.map((s) => DateTime(s.date.year, s.date.month, s.date.day)).toSet();
  final missing = missedDates(
    activatedAt: plan.activatedAt!,
    now: t,
    trainingWeekdays: training.keys.toSet(),
    sessionDays: sessionDays,
  );
  if (missing.isEmpty) return;
  await db.batch((b) {
    for (final d in missing) {
      final pd = training[d.weekday]!;
      b.insert(
        db.workoutSessions,
        WorkoutSessionsCompanion.insert(
          date: d,
          planDayId: Value(pd.id),
          name: Value(pd.name),
          status: const Value(SessionStatus.missed),
        ),
      );
    }
  });
}

/// Registers offline AI-queue handlers owned by the workout feature.
/// The workout feature queues nothing itself: the post-workout summary is queued by the
/// coach (`CoachInitiatives.onWorkoutFinished`) and voice parsing is interactive.
void registerWorkoutAiHandlers() {}
