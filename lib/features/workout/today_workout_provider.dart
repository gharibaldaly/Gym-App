import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';

class TodayWorkout {
  final PlanDay? planDay; // null → no active plan
  final bool isRestDay;
  final int exerciseCount;
  final WorkoutSession? session; // today's session if started/finished
  const TodayWorkout({this.planDay, this.isRestDay = false, this.exerciseCount = 0, this.session});
}

/// Today's planned workout (from the active plan by weekday) + today's session.
final todayWorkoutProvider = StreamProvider<TodayWorkout>((ref) => Stream.value(const TodayWorkout()));
