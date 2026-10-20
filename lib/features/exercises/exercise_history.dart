import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/calc/strength_calc.dart';
import '../../core/providers.dart';

/// One logged set with the date of its session.
typedef DatedSet = ({SetLog set, DateTime date});

/// Performance of one exercise in one session (working sets only).
class SessionPerformance {
  final int sessionId;
  final DateTime date;
  final List<SetLog> sets;
  const SessionPerformance(this.sessionId, this.date, this.sets);

  double get topWeight => sets.fold(0.0, (m, s) => s.weightKg > m ? s.weightKg : m);
  double get bestE1rm => sets.fold(0.0, (m, s) {
        final e = StrengthCalc.epley1Rm(s.weightKg, s.reps);
        return e > m ? e : m;
      });
  double get volume => sets.fold(0.0, (v, s) => v + s.weightKg * s.reps);
  int get totalReps => sets.fold(0, (v, s) => v + s.reps);
}

class WeightRecord {
  final double weightKg;
  final int reps;
  final DateTime date;
  const WeightRecord(this.weightKg, this.reps, this.date);
  double get e1rm => StrengthCalc.epley1Rm(weightKg, reps);
}

class ExercisePrs {
  /// Heaviest working weight (with the most reps done at it).
  final WeightRecord? heaviest;

  /// Best estimated 1RM (Epley).
  final WeightRecord? bestE1rm;

  /// Most reps per weight, heaviest weights first (max 6 rows).
  final List<WeightRecord> repRecords;

  const ExercisePrs({this.heaviest, this.bestE1rm, this.repRecords = const []});
}

class ExerciseHistory {
  /// Chronological sessions that contain at least one working set.
  final List<SessionPerformance> sessions;
  final ExercisePrs prs;
  const ExerciseHistory(this.sessions, this.prs);

  static const empty = ExerciseHistory([], ExercisePrs());

  bool get isEmpty => sessions.isEmpty;
  SessionPerformance? get last => sessions.isEmpty ? null : sessions.last;
}

/// Groups raw rows into sessions and computes PRs. Warm-up sets and sets with
/// no reps are ignored; bodyweight sets (0 kg) count for reps only.
ExerciseHistory computeExerciseHistory(Iterable<DatedSet> rows) {
  final working = rows.where((r) => r.set.setType != 'warmup' && r.set.reps > 0).toList();
  if (working.isEmpty) return ExerciseHistory.empty;

  final bySession = <int, List<DatedSet>>{};
  for (final r in working) {
    bySession.putIfAbsent(r.set.sessionId, () => []).add(r);
  }
  final sessions = bySession.entries.map((e) {
    final sets = e.value.map((r) => r.set).toList()..sort((a, b) => a.setIndex.compareTo(b.setIndex));
    return SessionPerformance(e.key, e.value.first.date, sets);
  }).toList()
    ..sort((a, b) {
      final c = a.date.compareTo(b.date);
      return c != 0 ? c : a.sessionId.compareTo(b.sessionId);
    });

  WeightRecord? heaviest;
  WeightRecord? best;
  final repsAt = <double, WeightRecord>{};
  for (final s in sessions) {
    for (final set in s.sets) {
      final rec = WeightRecord(set.weightKg, set.reps, s.date);
      if (heaviest == null ||
          set.weightKg > heaviest.weightKg ||
          (set.weightKg == heaviest.weightKg && set.reps > heaviest.reps)) {
        heaviest = rec;
      }
      if (set.weightKg > 0 && (best == null || rec.e1rm > best.e1rm + 1e-9)) best = rec;
      final key = (set.weightKg * 100).roundToDouble() / 100;
      final prev = repsAt[key];
      if (prev == null || set.reps > prev.reps) repsAt[key] = rec;
    }
  }
  final repRecords = repsAt.values.toList()..sort((a, b) => b.weightKg.compareTo(a.weightKg));
  return ExerciseHistory(
    sessions,
    ExercisePrs(heaviest: heaviest, bestE1rm: best, repRecords: repRecords.take(6).toList()),
  );
}

/// Live history of one exercise from set_logs (newest data as soon as a set is logged).
final exerciseHistoryProvider = StreamProvider.autoDispose.family<ExerciseHistory, String>((ref, exerciseId) {
  final db = ref.watch(databaseProvider);
  final q = db.select(db.setLogs).join([
    innerJoin(db.workoutSessions, db.workoutSessions.id.equalsExp(db.setLogs.sessionId)),
  ])
    ..where(db.setLogs.exerciseId.equals(exerciseId))
    ..orderBy([OrderingTerm.asc(db.workoutSessions.date), OrderingTerm.asc(db.setLogs.setIndex)]);
  return q.watch().map((rows) => computeExerciseHistory(rows.map((r) {
        final session = r.readTable(db.workoutSessions);
        return (set: r.readTable(db.setLogs), date: session.date);
      })));
});
