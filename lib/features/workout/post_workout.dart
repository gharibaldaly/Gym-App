import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/calc/plateau.dart';
import '../../core/calc/strength_calc.dart';
import '../../core/providers.dart';
import '../../core/utils/context_ext.dart' show dayOf, ymd;
import '../coach/coach_initiatives.dart';
import 'workout_logic.dart';
import 'workout_repository.dart';

String plateauNotifiedKey(String exerciseId) => 'wo_plateau_notified_$exerciseId';

/// Local plateau rule (no AI) over per-session best e1RM for each exercise done.
/// Returns exercises that plateaued and were not reported in the last 7 days; marks
/// them as reported (once per exercise per week).
Future<List<String>> detectNewPlateaus(
  WorkoutRepository repo,
  SharedPreferences prefs,
  Iterable<String> exerciseIds, {
  DateTime? now,
}) async {
  final t = now ?? DateTime.now();
  final out = <String>[];
  for (final id in exerciseIds.toSet()) {
    final bests = await repo.sessionBests(id);
    final sessions = bests.where((b) => b.e1rm > 0).map((b) => SessionBest(b.date, b.e1rm)).toList();
    if (!PlateauDetector.isPlateau(sessions)) continue;
    final last = DateTime.tryParse(prefs.getString(plateauNotifiedKey(id)) ?? '');
    if (last != null && dayOf(t).difference(dayOf(last)).inDays < 7) continue;
    await prefs.setString(plateauNotifiedKey(id), ymd(t));
    out.add(id);
  }
  return out;
}

/// Per-exercise comparison with the previous session that had the exercise.
class ExerciseComparison {
  final String exerciseId;
  final List<SetLog> sets;
  final double volume;
  final double bestE1rm;
  final SetLog? bestSet;
  final double? prevVolume;
  final double? prevBestE1rm;
  final SetLog? prevBestSet;
  const ExerciseComparison({
    required this.exerciseId,
    required this.sets,
    required this.volume,
    required this.bestE1rm,
    required this.bestSet,
    this.prevVolume,
    this.prevBestE1rm,
    this.prevBestSet,
  });

  double? get volumeDeltaPct => prevVolume == null || prevVolume == 0 ? null : (volume - prevVolume!) / prevVolume! * 100;
  double? get e1rmDeltaPct => prevBestE1rm == null || prevBestE1rm == 0 ? null : (bestE1rm - prevBestE1rm!) / prevBestE1rm! * 100;
}

SetLog? _bestSet(Iterable<SetLog> sets) {
  SetLog? best;
  var bestE = -1.0;
  for (final s in sets) {
    if (!isWorkingSet(s.setType)) continue;
    final e = StrengthCalc.epley1Rm(s.weightKg, s.reps);
    if (e > bestE) {
      bestE = e;
      best = s;
    }
  }
  return best;
}

typedef _V = ({double weight, int reps, String setType});
Iterable<_V> _vals(Iterable<SetLog> s) => s.map((x) => (weight: x.weightKg, reps: x.reps, setType: x.setType));

/// Builds comparisons for every exercise of [session] (in logging order).
Future<List<ExerciseComparison>> compareWithPrevious(WorkoutRepository repo, WorkoutSession session) async {
  final sets = await repo.sessionSets(session.id);
  final order = <String>[];
  final by = <String, List<SetLog>>{};
  for (final s in sets) {
    if (!by.containsKey(s.exerciseId)) order.add(s.exerciseId);
    by.putIfAbsent(s.exerciseId, () => []).add(s);
  }
  final out = <ExerciseComparison>[];
  for (final id in order) {
    final mine = by[id]!;
    final prev = await repo.pastSessions(id, excludeSessionId: session.id, limit: 3, before: session.date);
    // Only sessions that happened before this one.
    final earlier = prev.where((p) => p.sessionId < session.id || p.date.isBefore(session.date)).toList();
    final p = earlier.isEmpty ? null : earlier.first.sets;
    out.add(ExerciseComparison(
      exerciseId: id,
      sets: mine,
      volume: sessionVolume(_vals(mine)),
      bestE1rm: bestE1rm(_vals(mine)),
      bestSet: _bestSet(mine),
      prevVolume: p == null ? null : sessionVolume(_vals(p)),
      prevBestE1rm: p == null ? null : bestE1rm(_vals(p)),
      prevBestSet: p == null ? null : _bestSet(p),
    ));
  }
  return out;
}

/// After finishing: ask the coach for the summary (queued offline by the coach).
/// `CoachInitiatives.onWorkoutFinished` also runs the local plateau rule and asks for
/// explanations itself (deduped), so no separate plateau call is made here. Never throws.
Future<void> runPostWorkout({required CoachInitiatives coach, required int sessionId}) async {
  try {
    await coach.onWorkoutFinished(sessionId);
  } catch (e) {
    debugPrint('onWorkoutFinished failed: $e');
  }
}
