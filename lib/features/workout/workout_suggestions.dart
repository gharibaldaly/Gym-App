import 'package:shared_preferences/shared_preferences.dart';

import '../../core/calc/progression.dart';
import '../../core/providers.dart';
import '../../data/repositories/exercise_repository.dart';
import 'deload.dart';
import 'workout_logic.dart';
import 'workout_repository.dart';

/// Everything the live screen needs to show "last time" + "try this time" for one exercise.
class ExerciseTarget {
  final int sets;
  final int repMin;
  final int repMax;
  final double? targetRpe;
  final int restSeconds;
  final double increment;
  final List<SetLog> lastSets;
  final DateTime? lastDate;
  final List<SetSuggestion> suggestions;
  final bool deload;
  final RecoveryAdjust? recovery;

  const ExerciseTarget({
    required this.sets,
    required this.repMin,
    required this.repMax,
    required this.targetRpe,
    required this.restSeconds,
    required this.increment,
    required this.lastSets,
    required this.lastDate,
    required this.suggestions,
    required this.deload,
    required this.recovery,
  });

  SetSuggestion suggestionFor(int setIndex) =>
      suggestions.isEmpty ? SetSuggestion(0, repMin, ProgressionReason.firstTime) : suggestions[setIndex.clamp(0, suggestions.length - 1)];

  SetLog? lastFor(int setIndex) => setIndex < lastSets.length ? lastSets[setIndex] : null;
}

/// Pure: per-set suggestions via double progression, then deload (85%) and today's
/// recovery adjustment (weight factor) on top.
List<SetSuggestion> buildSetSuggestions({
  required int sets,
  required int repMin,
  required int repMax,
  required List<LastSet> lastSession,
  List<LastSet>? sessionBefore,
  double? planWeightKg,
  required double increment,
  bool deload = false,
  RecoveryAdjust? recovery,
}) {
  final out = <SetSuggestion>[];
  for (var i = 0; i < sets; i++) {
    var s = Progression.suggest(
      setIndex: i,
      repMin: repMin,
      repMax: repMax,
      lastSession: lastSession,
      sessionBefore: sessionBefore,
      planWeightKg: planWeightKg,
      increment: increment,
      deload: deload,
    );
    if (deload && lastSession.isEmpty && s.weightKg > 0) {
      s = SetSuggestion(roundToStep(s.weightKg * 0.85, increment > 0 ? increment : 0.5), repMin, ProgressionReason.deload);
    }
    if (recovery != null) s = recovery.apply(s, increment);
    out.add(s);
  }
  return out;
}

/// Loads history for [ex] and computes today's target. [pe] is the plan entry (null for
/// exercises added on the fly). [sessionId] is excluded from "last time".
Future<ExerciseTarget> computeExerciseTarget({
  required WorkoutRepository repo,
  required SharedPreferences prefs,
  required Exercise ex,
  PlanExercise? pe,
  int? sessionId,
  DateTime? now,
}) async {
  final t = now ?? DateTime.now();
  final past = await repo.pastSessions(ex.id, excludeSessionId: sessionId, limit: 2);
  final last = past.isEmpty ? const <SetLog>[] : past.first.sets;
  LastSet toLast(SetLog s) => LastSet(s.weightKg, s.reps, rpe: s.rpe);
  final repMin = pe?.repMin ?? 8;
  final repMax = pe?.repMax ?? 12;
  final recovery = RecoveryAdjust.parse(prefs.getString(recoveryAdjustKey(t)));
  final baseSets = pe?.sets ?? (last.isEmpty ? 3 : last.length.clamp(1, 6));
  final sets = recovery?.applySets(baseSets) ?? baseSets;
  final increment = Progression.incrementFor(ex.equipment, lowerBody: ex.isLowerBody);
  final deload = isDeloadWeekActive(prefs, t);
  final suggestions = buildSetSuggestions(
    sets: sets,
    repMin: repMin,
    repMax: repMax,
    lastSession: last.map(toLast).toList(),
    sessionBefore: past.length > 1 ? past[1].sets.map(toLast).toList() : null,
    planWeightKg: pe?.suggestedWeightKg,
    increment: increment,
    deload: deload,
    recovery: recovery,
  );
  return ExerciseTarget(
    sets: sets,
    repMin: repMin,
    repMax: repMax,
    targetRpe: pe?.targetRpe,
    restSeconds: pe?.restSeconds ?? 90,
    increment: increment,
    lastSets: last,
    lastDate: past.isEmpty ? null : past.first.date,
    suggestions: suggestions,
    deload: deload,
    recovery: recovery,
  );
}
