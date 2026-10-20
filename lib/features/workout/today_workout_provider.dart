import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import 'workout_repository.dart';

class TodayWorkout {
  final PlanDay? planDay; // null → no active plan
  final bool isRestDay;
  final int exerciseCount;
  final WorkoutSession? session; // today's session if started/finished
  const TodayWorkout({this.planDay, this.isRestDay = false, this.exerciseCount = 0, this.session});

  bool get hasPlan => planDay != null || isRestDay;
  bool get inProgress => session?.status == 'in_progress';
  bool get finished => session != null && (session!.status == 'completed' || session!.status == 'partial');
}

/// Loads today's plan day + session (exposed for tests and the home widget).
Future<TodayWorkout> loadTodayWorkout(WorkoutRepository repo, DateTime now) async {
  final plan = await repo.activePlan();
  final session = await repo.sessionOn(now);
  if (plan == null) return TodayWorkout(session: session);
  final day = await repo.activeDayForWeekday(now.weekday);
  if (day == null || day.isRest) return TodayWorkout(planDay: day, isRestDay: true, session: session);
  final count = (await repo.dayExercises(day.id)).length;
  return TodayWorkout(planDay: day, exerciseCount: count, session: session);
}

/// Today's planned workout (from the active plan by weekday) + today's session.
final todayWorkoutProvider = StreamProvider<TodayWorkout>((ref) {
  final db = ref.watch(databaseProvider);
  final repo = ref.watch(workoutRepositoryProvider);
  // Recompute after midnight.
  final now = DateTime.now();
  final midnight = DateTime(now.year, now.month, now.day + 1);
  final timer = Timer(midnight.difference(now) + const Duration(seconds: 1), ref.invalidateSelf);
  ref.onDispose(timer.cancel);
  return watchTables(
    db,
    {db.workoutPlans, db.planDays, db.planExercises, db.workoutSessions},
    () => loadTodayWorkout(repo, DateTime.now()),
  );
});
