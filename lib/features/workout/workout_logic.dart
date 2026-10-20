/// Pure (DB-free) workout logic: plan JSON schema + validation, session status,
/// volume, missed-day computation, recovery adjustment, deload heuristics.
/// Everything here is unit-tested in test/wo_*_test.dart.
library;

import 'dart:convert';
import 'dart:math' as math;

import '../../core/calc/progression.dart';
import '../../core/calc/strength_calc.dart';

// ---------------------------------------------------------------------------
// Plan JSON (shared by the AI generator and the offline template builder)
// ---------------------------------------------------------------------------

/// JSON schema Claude must follow for a weekly plan.
const Map<String, dynamic> workoutPlanSchema = {
  'type': 'object',
  'properties': {
    'name': {'type': 'string'},
    'notes': {'type': 'string'},
    'deloadEveryWeeks': {'type': 'integer'},
    'days': {
      'type': 'array',
      'minItems': 1,
      'items': {
        'type': 'object',
        'properties': {
          'weekday': {'type': 'integer'},
          'name': {'type': 'string'},
          'focus': {'type': 'string'},
          'warmup': {
            'type': 'array',
            'items': {'type': 'string'},
          },
          'cooldown': {
            'type': 'array',
            'items': {'type': 'string'},
          },
          'exercises': {
            'type': 'array',
            'minItems': 1,
            'items': {
              'type': 'object',
              'properties': {
                'exerciseId': {'type': 'string'},
                'sets': {'type': 'integer'},
                'repMin': {'type': 'integer'},
                'repMax': {'type': 'integer'},
                'suggestedWeightKg': {
                  'type': ['number', 'null'],
                },
                'targetRpe': {'type': 'number'},
                'restSeconds': {'type': 'integer'},
                'notes': {
                  'type': ['string', 'null'],
                },
              },
              'required': [
                'exerciseId',
                'sets',
                'repMin',
                'repMax',
                'suggestedWeightKg',
                'targetRpe',
                'restSeconds',
                'notes',
              ],
            },
          },
        },
        'required': ['weekday', 'name', 'focus', 'warmup', 'cooldown', 'exercises'],
      },
    },
  },
  'required': ['name', 'notes', 'deloadEveryWeeks', 'days'],
};

/// Domain validation on top of the schema. [knownIds] = exercise ids the model was
/// allowed to use; [trainingDays] = the user's chosen weekdays (1=Mon … 7=Sun).
List<String> validatePlanJson(
  Map<String, dynamic> json, {
  required Set<String> knownIds,
  required List<int> trainingDays,
}) {
  final errors = <String>[];
  final deload = json['deloadEveryWeeks'];
  if (deload is! num || deload < 4 || deload > 6) {
    errors.add('deloadEveryWeeks must be between 4 and 6');
  }
  final days = json['days'];
  if (days is! List || days.isEmpty) {
    errors.add('days must contain the training days');
    return errors;
  }
  final seen = <int>{};
  for (var i = 0; i < days.length; i++) {
    final d = days[i];
    if (d is! Map) {
      errors.add('days[$i] must be an object');
      continue;
    }
    final wd = d['weekday'];
    if (wd is! num || wd < 1 || wd > 7) {
      errors.add('days[$i].weekday must be 1..7 (1=Monday)');
    } else {
      if (!seen.add(wd.toInt())) errors.add('days[$i].weekday $wd is duplicated');
      if (trainingDays.isNotEmpty && !trainingDays.contains(wd.toInt())) {
        errors.add('days[$i].weekday $wd is not one of the training weekdays $trainingDays');
      }
    }
    if ((d['warmup'] as List?)?.isEmpty ?? true) errors.add('days[$i].warmup must have steps');
    if ((d['cooldown'] as List?)?.isEmpty ?? true) errors.add('days[$i].cooldown must have stretch steps');
    final exs = d['exercises'];
    if (exs is! List || exs.isEmpty) {
      errors.add('days[$i].exercises must not be empty');
      continue;
    }
    final usedIds = <String>{};
    for (var j = 0; j < exs.length; j++) {
      final e = exs[j];
      if (e is! Map) continue;
      final p = 'days[$i].exercises[$j]';
      final id = e['exerciseId'];
      if (id is! String || !knownIds.contains(id)) {
        errors.add('$p.exerciseId "$id" is unknown – use only ids from the candidate list, exactly as written');
      } else if (!usedIds.add(id)) {
        errors.add('$p.exerciseId "$id" appears twice in the same day');
      }
      final sets = e['sets'];
      if (sets is! num || sets < 1 || sets > 10) errors.add('$p.sets must be 1..10');
      final rMin = e['repMin'], rMax = e['repMax'];
      if (rMin is! num || rMin < 1 || rMin > 100) errors.add('$p.repMin must be 1..100');
      if (rMax is! num || rMax < 1 || rMax > 100) errors.add('$p.repMax must be 1..100');
      if (rMin is num && rMax is num && rMin > rMax) errors.add('$p.repMin must be <= repMax');
      final rest = e['restSeconds'];
      if (rest is! num || rest < 15 || rest > 600) errors.add('$p.restSeconds must be 15..600');
      final rpe = e['targetRpe'];
      if (rpe is! num || rpe < 1 || rpe > 10) errors.add('$p.targetRpe must be 1..10');
      final w = e['suggestedWeightKg'];
      if (w != null && (w is! num || w < 0 || w > 500)) errors.add('$p.suggestedWeightKg must be null or 0..500');
    }
  }
  if (trainingDays.isNotEmpty) {
    for (final t in trainingDays) {
      if (!seen.contains(t)) errors.add('training weekday $t is missing from days');
    }
  }
  return errors;
}

/// Display order of weekdays: Saturday-first for Arabic (Egyptian week), Monday-first otherwise.
List<int> weekOrder({required bool ar}) => ar ? const [6, 7, 1, 2, 3, 4, 5] : const [1, 2, 3, 4, 5, 6, 7];

List<String> decodeStringList(String? raw) {
  if (raw == null || raw.isEmpty) return const [];
  try {
    return (jsonDecode(raw) as List).map((e) => e.toString()).toList();
  } catch (_) {
    return const [];
  }
}

// ---------------------------------------------------------------------------
// Sessions
// ---------------------------------------------------------------------------

class SessionStatus {
  static const inProgress = 'in_progress';
  static const completed = 'completed';
  static const partial = 'partial';
  static const missed = 'missed';
}

class SetType {
  static const normal = 'normal';
  static const warmup = 'warmup';
  static const drop = 'drop';
  static const failure = 'failure';
  static const all = [normal, warmup, drop, failure];
}

/// Planned vs done working sets for one planned exercise.
typedef PlannedProgress = ({int planned, int done});

/// completed = every planned exercise got all its working sets; partial otherwise.
/// A free workout (nothing planned) is completed as soon as something was logged.
String computeSessionStatus(List<PlannedProgress> items, {required bool anythingLogged}) {
  final planned = items.where((i) => i.planned > 0).toList();
  if (planned.isEmpty) return anythingLogged ? SessionStatus.completed : SessionStatus.partial;
  return planned.every((i) => i.done >= i.planned) ? SessionStatus.completed : SessionStatus.partial;
}

bool isWorkingSet(String setType) => setType != SetType.warmup;

/// Total volume (kg × reps) of working sets – warm-ups excluded.
double sessionVolume(Iterable<({double weight, int reps, String setType})> sets) =>
    sets.where((s) => isWorkingSet(s.setType)).fold(0.0, (a, s) => a + s.weight * s.reps);

/// Best Epley e1RM among working sets.
double bestE1rm(Iterable<({double weight, int reps, String setType})> sets) {
  var best = 0.0;
  for (final s in sets) {
    if (!isWorkingSet(s.setType)) continue;
    best = math.max(best, StrengthCalc.epley1Rm(s.weight, s.reps));
  }
  return best;
}

/// Past training days (from the day after activation, at most [maxDays] back,
/// up to yesterday) that have no session. The schedule never shifts.
List<DateTime> missedDates({
  required DateTime activatedAt,
  required DateTime now,
  required Set<int> trainingWeekdays,
  required Set<DateTime> sessionDays,
  int maxDays = 60,
}) {
  DateTime day(DateTime d) => DateTime(d.year, d.month, d.day);
  final today = day(now);
  final act = day(activatedAt);
  var start = DateTime(act.year, act.month, act.day + 1);
  final earliest = DateTime(today.year, today.month, today.day - maxDays);
  if (start.isBefore(earliest)) start = earliest;
  final out = <DateTime>[];
  for (var d = start; d.isBefore(today); d = DateTime(d.year, d.month, d.day + 1)) {
    if (trainingWeekdays.contains(d.weekday) && !sessionDays.contains(d)) out.add(d);
  }
  return out;
}

// ---------------------------------------------------------------------------
// Recovery adjustment (written by the coach when the user accepts a low-recovery suggestion)
// ---------------------------------------------------------------------------

String recoveryAdjustKey(DateTime day) {
  final m = day.month.toString().padLeft(2, '0'), d = day.day.toString().padLeft(2, '0');
  return 'recovery_adjust_${day.year}-$m-$d';
}

class RecoveryAdjust {
  final double weightFactor;
  final int setsDelta;
  const RecoveryAdjust({this.weightFactor = 1.0, this.setsDelta = 0});

  bool get isNeutral => weightFactor == 1.0 && setsDelta == 0;

  static RecoveryAdjust? parse(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final m = jsonDecode(raw) as Map<String, dynamic>;
      final f = (m['weightFactor'] as num?)?.toDouble() ?? 1.0;
      final s = (m['setsDelta'] as num?)?.toInt() ?? 0;
      return RecoveryAdjust(weightFactor: f.clamp(0.5, 1.0), setsDelta: s.clamp(-5, 0));
    } catch (_) {
      return null;
    }
  }

  int applySets(int sets) => math.max(1, sets + setsDelta);

  SetSuggestion apply(SetSuggestion s, double increment) {
    if (weightFactor >= 1.0 || s.weightKg <= 0) return s;
    final step = increment > 0 ? increment : 0.5;
    final w = roundToStep(s.weightKg * weightFactor, step);
    return SetSuggestion(w, s.reps, s.reason);
  }
}

double roundToStep(double v, double step) {
  if (step <= 0) return v;
  final r = (v / step).round() * step;
  return double.parse(r.toStringAsFixed(2));
}

// ---------------------------------------------------------------------------
// Deload
// ---------------------------------------------------------------------------

const deloadWeekStartKey = 'deload_week_start';

/// Whole weeks between [anchor] and [now].
int weeksSince(DateTime anchor, DateTime now) => now.difference(anchor).inDays ~/ 7;

/// True when [now] falls inside the 7-day deload window starting at [start].
bool deloadActiveOn(DateTime? start, DateTime now) {
  if (start == null) return false;
  final s = DateTime(start.year, start.month, start.day);
  final d = DateTime(now.year, now.month, now.day);
  return !d.isBefore(s) && d.difference(s).inDays < 7;
}

/// Per-exercise session bests (e1RM) split into the last 14 days vs the 14 days before.
/// Returns the average ratio recent/previous over exercises present in both windows,
/// or null when fewer than [minExercises] exercises can be compared.
double? e1rmTrendRatio(
  Map<String, List<({DateTime date, double e1rm})>> bests, {
  required DateTime now,
  int minExercises = 3,
}) {
  final recentFrom = now.subtract(const Duration(days: 14));
  final prevFrom = now.subtract(const Duration(days: 28));
  final ratios = <double>[];
  bests.forEach((_, list) {
    final recent = list.where((b) => !b.date.isBefore(recentFrom) && b.e1rm > 0).map((b) => b.e1rm).toList();
    final prev = list
        .where((b) => !b.date.isBefore(prevFrom) && b.date.isBefore(recentFrom) && b.e1rm > 0)
        .map((b) => b.e1rm)
        .toList();
    if (recent.isEmpty || prev.isEmpty) return;
    final r = recent.reduce((a, b) => a + b) / recent.length;
    final p = prev.reduce((a, b) => a + b) / prev.length;
    if (p > 0) ratios.add(r / p);
  });
  if (ratios.length < minExercises) return null;
  return ratios.reduce((a, b) => a + b) / ratios.length;
}

/// A ≥3% average drop in estimated 1RM over the last 2 weeks suggests accumulated fatigue.
bool performanceDropped(double? ratio, {double threshold = 0.97}) => ratio != null && ratio < threshold;
