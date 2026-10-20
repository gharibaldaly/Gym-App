/// Progress tab: pure aggregation functions (testable without Flutter) and the
/// Riverpod providers that feed them from live Drift queries.
library;

import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/calc/stats.dart';
import '../../core/calc/strength_calc.dart';
import '../../core/providers.dart';
import '../../data/repositories/exercise_repository.dart';
import '../../data/repositories/profile_repository.dart';

// ---------------------------------------------------------------------------
// Date helpers (DST-safe: always rebuild from y/m/d instead of adding Durations)
// ---------------------------------------------------------------------------

DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

/// [d] + [n] calendar days at local midnight.
DateTime addDays(DateTime d, int n) => DateTime(d.year, d.month, d.day + n);

/// Saturday-based start of week (Egyptian week: Sat … Fri).
DateTime weekStartSat(DateTime d) {
  final x = _day(d);
  return addDays(x, -((x.weekday - DateTime.saturday) % 7));
}

/// Number of Saturday-based weeks touched by [from]..[to] (inclusive, ≥ 1).
int weeksInRange(DateTime from, DateTime to) {
  final a = weekStartSat(from), b = weekStartSat(to);
  if (b.isBefore(a)) return 1;
  return (_daysBetween(a, b) ~/ 7) + 1;
}

int _daysBetween(DateTime a, DateTime b) =>
    DateTime.utc(b.year, b.month, b.day).difference(DateTime.utc(a.year, a.month, a.day)).inDays;

// ---------------------------------------------------------------------------
// Period filter
// ---------------------------------------------------------------------------

enum ProgressPeriod { week, month, threeMonths, year, all }

extension ProgressPeriodX on ProgressPeriod {
  /// Rolling window length in days; null = all time.
  int? get days => switch (this) {
        ProgressPeriod.week => 7,
        ProgressPeriod.month => 30,
        ProgressPeriod.threeMonths => 90,
        ProgressPeriod.year => 365,
        ProgressPeriod.all => null,
      };

  /// First day (local midnight, inclusive) of the window ending on [today].
  DateTime? startFrom(DateTime today) => days == null ? null : addDays(_day(today), -(days! - 1));
}

class ProgressPeriodNotifier extends Notifier<ProgressPeriod> {
  @override
  ProgressPeriod build() => ProgressPeriod.month;
  void set(ProgressPeriod p) => state = p;
}

/// Period shared by every chart on the Progress tab.
final progressPeriodProvider =
    NotifierProvider<ProgressPeriodNotifier, ProgressPeriod>(ProgressPeriodNotifier.new);

/// Start date of the selected period (null = all time).
final progressPeriodStartProvider = Provider<DateTime?>((ref) {
  final p = ref.watch(progressPeriodProvider);
  return p.startFrom(DateTime.now());
});

// ---------------------------------------------------------------------------
// Set rows (set_logs ⋈ workout_sessions ⋈ exercises)
// ---------------------------------------------------------------------------

/// One logged set with the context needed by every aggregation.
class SetRow {
  final int sessionId;
  final DateTime date; // session day (local midnight)
  final String exerciseId;
  final int setIndex;
  final double weightKg;
  final int reps;
  final double? rpe;
  final String setType; // normal / warmup / drop / failure
  final bool isPr;
  final List<String> primaryMuscles;
  final DateTime createdAt;

  const SetRow({
    required this.sessionId,
    required this.date,
    required this.exerciseId,
    this.setIndex = 0,
    required this.weightKg,
    required this.reps,
    this.rpe,
    this.setType = 'normal',
    this.isPr = false,
    this.primaryMuscles = const [],
    DateTime? createdAt,
  }) : createdAt = createdAt ?? date;

  bool get isWarmup => setType == 'warmup';

  /// Working set close enough to failure to count as a growth stimulus:
  /// non-warmup with RPE ≥ 7 (or RPE not logged).
  bool get isEffective => !isWarmup && reps > 0 && (rpe == null || rpe! >= 7);

  double get volume => weightKg * reps;
  double get e1rm => StrengthCalc.epley1Rm(weightKg, reps);
}

int _chrono(SetRow a, SetRow b) {
  var c = a.date.compareTo(b.date);
  if (c != 0) return c;
  c = a.createdAt.compareTo(b.createdAt);
  if (c != 0) return c;
  c = a.sessionId.compareTo(b.sessionId);
  if (c != 0) return c;
  return a.setIndex.compareTo(b.setIndex);
}

/// Live set rows, optionally limited to a date range (inclusive days) and an exercise.
Stream<List<SetRow>> watchSetRows(AppDatabase db, {DateTime? from, DateTime? to, String? exerciseId}) =>
    _setRowsQuery(db, from: from, to: to, exerciseId: exerciseId).watch().map((rows) => rows.map(_toSetRow(db)).toList());

Future<List<SetRow>> loadSetRows(AppDatabase db, {DateTime? from, DateTime? to, String? exerciseId}) async =>
    (await _setRowsQuery(db, from: from, to: to, exerciseId: exerciseId).get()).map(_toSetRow(db)).toList();

JoinedSelectStatement _setRowsQuery(AppDatabase db, {DateTime? from, DateTime? to, String? exerciseId}) {
  final q = db.select(db.setLogs).join([
    innerJoin(db.workoutSessions, db.workoutSessions.id.equalsExp(db.setLogs.sessionId)),
    leftOuterJoin(db.exercises, db.exercises.id.equalsExp(db.setLogs.exerciseId)),
  ]);
  Expression<bool> where = const Constant(true);
  if (from != null) where = where & db.workoutSessions.date.isBiggerOrEqualValue(_day(from));
  if (to != null) where = where & db.workoutSessions.date.isSmallerThanValue(addDays(to, 1));
  if (exerciseId != null) where = where & db.setLogs.exerciseId.equals(exerciseId);
  q.where(where);
  q.orderBy([
    OrderingTerm.asc(db.workoutSessions.date),
    OrderingTerm.asc(db.setLogs.createdAt),
    OrderingTerm.asc(db.setLogs.setIndex),
  ]);
  return q;
}

SetRow Function(TypedResult) _toSetRow(AppDatabase db) => (r) {
      final s = r.readTable(db.setLogs);
      final session = r.readTable(db.workoutSessions);
      final ex = r.readTableOrNull(db.exercises);
      List<String> muscles = const [];
      if (ex != null) {
        try {
          muscles = ex.primaryMuscles;
        } catch (_) {}
      }
      return SetRow(
        sessionId: s.sessionId,
        date: _day(session.date),
        exerciseId: s.exerciseId,
        setIndex: s.setIndex,
        weightKg: s.weightKg,
        reps: s.reps,
        rpe: s.rpe,
        setType: s.setType,
        isPr: s.isPr,
        primaryMuscles: muscles,
        createdAt: s.createdAt,
      );
    };

// ---------------------------------------------------------------------------
// Weekly volume per muscle
// ---------------------------------------------------------------------------

/// Volume and set counts of one muscle in one Saturday-based week.
class MuscleWeekStat {
  final DateTime weekStart;
  final String muscle;
  double volume = 0;
  int effectiveSets = 0;
  int workingSets = 0;
  MuscleWeekStat(this.weekStart, this.muscle);
}

/// Weight × reps summed per primary muscle per week (warmups excluded) plus
/// effective-set counts. Every primary muscle of an exercise gets the full set.
List<MuscleWeekStat> weeklyMuscleStats(Iterable<SetRow> sets) {
  final map = <(DateTime, String), MuscleWeekStat>{};
  for (final s in sets) {
    if (s.isWarmup || s.reps <= 0) continue;
    final w = weekStartSat(s.date);
    for (final m in s.primaryMuscles.toSet()) {
      final st = map.putIfAbsent((w, m), () => MuscleWeekStat(w, m));
      st.volume += s.volume;
      st.workingSets++;
      if (s.isEffective) st.effectiveSets++;
    }
  }
  final out = map.values.toList()
    ..sort((a, b) {
      final c = a.weekStart.compareTo(b.weekStart);
      return c != 0 ? c : b.volume.compareTo(a.volume);
    });
  return out;
}

class MuscleSummary {
  final String muscle;
  final double totalVolume;
  final int totalEffectiveSets;
  final int totalWorkingSets;
  final double weeks;
  const MuscleSummary({
    required this.muscle,
    required this.totalVolume,
    required this.totalEffectiveSets,
    required this.totalWorkingSets,
    required this.weeks,
  });
  double get avgWeeklyVolume => totalVolume / weeks;
  double get avgWeeklyEffectiveSets => totalEffectiveSets / weeks;
}

/// Totals per muscle averaged over [weeks] weeks (min 1), sorted by volume (desc).
List<MuscleSummary> summarizeMuscles(Iterable<MuscleWeekStat> stats, {required double weeks}) {
  final w = weeks < 1 ? 1.0 : weeks;
  final acc = <String, (double, int, int)>{};
  for (final s in stats) {
    final a = acc[s.muscle] ?? (0.0, 0, 0);
    acc[s.muscle] = (a.$1 + s.volume, a.$2 + s.effectiveSets, a.$3 + s.workingSets);
  }
  final out = [
    for (final e in acc.entries)
      MuscleSummary(
        muscle: e.key,
        totalVolume: e.value.$1,
        totalEffectiveSets: e.value.$2,
        totalWorkingSets: e.value.$3,
        weeks: w,
      ),
  ]..sort((a, b) {
      final c = b.totalVolume.compareTo(a.totalVolume);
      return c != 0 ? c : b.totalEffectiveSets.compareTo(a.totalEffectiveSets);
    });
  return out;
}

/// Total (all muscles, warmups excluded) volume per week, every week in
/// [from]..[to] present (zero-filled).
List<DatedValue> weeklyTotalVolume(Iterable<SetRow> sets, {required DateTime from, required DateTime to}) {
  final totals = <DateTime, double>{};
  for (final s in sets) {
    if (s.isWarmup || s.reps <= 0) continue;
    final w = weekStartSat(s.date);
    totals[w] = (totals[w] ?? 0) + s.volume;
  }
  final out = <DatedValue>[];
  for (var w = weekStartSat(from); !w.isAfter(weekStartSat(to)); w = addDays(w, 7)) {
    out.add(DatedValue(w, totals[w] ?? 0));
  }
  return out;
}

class MuscleVolumeData {
  final List<MuscleSummary> muscles;
  final List<DatedValue> weeklyTotals;

  /// Calendar days the averages are spread over.
  final int days;
  const MuscleVolumeData({required this.muscles, required this.weeklyTotals, required this.days});
  bool get isEmpty => muscles.isEmpty;
}

/// Builds the volume card data for a period. Averages are "per 7 days" over the
/// period ([from] null = since the first logged set), never over less than a week.
MuscleVolumeData buildMuscleVolume(List<SetRow> sets, {DateTime? from, required DateTime today}) {
  if (sets.isEmpty) return const MuscleVolumeData(muscles: [], weeklyTotals: [], days: 0);
  final first = sets.map((s) => s.date).reduce((a, b) => a.isBefore(b) ? a : b);
  final start = from ?? first;
  final days = _daysBetween(start, today) + 1;
  return MuscleVolumeData(
    muscles: summarizeMuscles(weeklyMuscleStats(sets), weeks: days / 7),
    weeklyTotals: weeklyTotalVolume(sets, from: start.isAfter(first) ? start : first, to: today),
    days: days,
  );
}

// ---------------------------------------------------------------------------
// Per-exercise progress
// ---------------------------------------------------------------------------

class ExerciseProgressPoint {
  final DateTime date;
  final double topWeight;
  final int topReps; // reps of the top (heaviest) set
  final double bestE1rm;
  final double volume;
  const ExerciseProgressPoint({
    required this.date,
    required this.topWeight,
    required this.topReps,
    required this.bestE1rm,
    required this.volume,
  });
}

/// One point per training day: heaviest working set and best Epley e1RM.
List<ExerciseProgressPoint> exerciseProgressSeries(Iterable<SetRow> sets) {
  final byDay = <DateTime, List<SetRow>>{};
  for (final s in sets) {
    if (s.isWarmup || s.reps <= 0) continue;
    byDay.putIfAbsent(s.date, () => []).add(s);
  }
  final days = byDay.keys.toList()..sort();
  return [
    for (final d in days)
      () {
        final l = byDay[d]!;
        var top = l.first;
        for (final s in l) {
          if (s.weightKg > top.weightKg || (s.weightKg == top.weightKg && s.reps > top.reps)) top = s;
        }
        return ExerciseProgressPoint(
          date: d,
          topWeight: top.weightKg,
          topReps: top.reps,
          bestE1rm: l.map((s) => s.e1rm).reduce((a, b) => a > b ? a : b),
          volume: l.fold(0.0, (a, s) => a + s.volume),
        );
      }(),
  ];
}

// ---------------------------------------------------------------------------
// Personal records
// ---------------------------------------------------------------------------

class PrEntry {
  final double weightKg;
  final int reps;
  final DateTime date;
  const PrEntry(this.weightKg, this.reps, this.date);
  double get e1rm => StrengthCalc.epley1Rm(weightKg, reps);
}

class ExercisePrs {
  final String exerciseId;
  final PrEntry heaviest;
  final PrEntry bestE1rm;

  /// Most reps achieved at each weight, heaviest weight first.
  final List<PrEntry> repsAtWeight;
  final int workingSets;
  final DateTime lastDate;
  const ExercisePrs({
    required this.exerciseId,
    required this.heaviest,
    required this.bestE1rm,
    required this.repsAtWeight,
    required this.workingSets,
    required this.lastDate,
  });
}

/// All-time records per exercise (warmups excluded). Ties keep the first date
/// the record was reached. Sorted by most recently trained.
List<ExercisePrs> computeExercisePrs(Iterable<SetRow> sets) {
  final byEx = <String, List<SetRow>>{};
  for (final s in sets) {
    if (s.isWarmup || s.reps <= 0) continue;
    byEx.putIfAbsent(s.exerciseId, () => []).add(s);
  }
  final out = <ExercisePrs>[];
  byEx.forEach((id, list) {
    list.sort(_chrono);
    var heavy = list.first, best = list.first;
    final atWeight = <int, PrEntry>{}; // key: weight in grams
    for (final s in list) {
      if (s.weightKg > heavy.weightKg || (s.weightKg == heavy.weightKg && s.reps > heavy.reps)) heavy = s;
      if (s.e1rm > best.e1rm + 1e-9) best = s;
      final k = (s.weightKg * 1000).round();
      final cur = atWeight[k];
      if (cur == null || s.reps > cur.reps) atWeight[k] = PrEntry(s.weightKg, s.reps, s.date);
    }
    final reps = atWeight.values.toList()..sort((a, b) => b.weightKg.compareTo(a.weightKg));
    out.add(ExercisePrs(
      exerciseId: id,
      heaviest: PrEntry(heavy.weightKg, heavy.reps, heavy.date),
      bestE1rm: PrEntry(best.weightKg, best.reps, best.date),
      repsAtWeight: reps,
      workingSets: list.length,
      lastDate: list.last.date,
    ));
  });
  out.sort((a, b) => b.lastDate.compareTo(a.lastDate));
  return out;
}

/// A set that broke at least one record at the time it was logged.
class PrEvent {
  final SetRow set;
  final Set<PrType> types;
  const PrEvent(this.set, this.types);
}

/// Replays history chronologically (same rules as [PrDetector]: the first
/// time an exercise is logged is not a record) and returns every PR set.
List<PrEvent> detectPrEvents(Iterable<SetRow> sets) {
  final sorted = sets.where((s) => !s.isWarmup && s.reps > 0).toList()..sort(_chrono);
  final maxW = <String, double>{};
  final bestE = <String, double>{};
  final repsAt = <String, Map<int, int>>{};
  final out = <PrEvent>[];
  for (final s in sorted) {
    final id = s.exerciseId;
    final k = (s.weightKg * 1000).round();
    final at = repsAt.putIfAbsent(id, () => {});
    if (maxW.containsKey(id)) {
      final types = <PrType>{};
      if (s.weightKg > maxW[id]! + 1e-9) types.add(PrType.weight);
      final prevReps = at[k];
      if (prevReps != null && s.reps > prevReps) types.add(PrType.reps);
      if (s.e1rm > bestE[id]! + 0.01) types.add(PrType.e1rm);
      if (types.isNotEmpty) out.add(PrEvent(s, types));
    }
    if (!maxW.containsKey(id) || s.weightKg > maxW[id]!) maxW[id] = s.weightKg;
    if (!bestE.containsKey(id) || s.e1rm > bestE[id]!) bestE[id] = s.e1rm;
    if ((at[k] ?? 0) < s.reps) at[k] = s.reps;
  }
  return out;
}

// ---------------------------------------------------------------------------
// Adherence calendar
// ---------------------------------------------------------------------------

enum DayStatus { completed, partial, missed, rest, today, future, none }

class SessionLite {
  final int id;
  final DateTime date;
  final String status; // in_progress / completed / partial / missed
  final int setCount;
  final String? name;
  const SessionLite({required this.id, required this.date, required this.status, this.setCount = 0, this.name});
}

/// Status colour of one calendar day.
///
/// * completed session → completed; partial (or an in-progress one with sets) → partial;
///   an explicit `missed` row → missed. Best session of the day wins.
/// * no session: future → future, before [trackingStart] → none, non-training
///   weekday → rest, today → today (still pending), otherwise → missed.
DayStatus dayStatus({
  required DateTime day,
  required List<SessionLite> sessions,
  required Set<int> trainingWeekdays,
  required DateTime today,
  DateTime? trackingStart,
}) {
  final d = _day(day), t = _day(today);
  if (d.isAfter(t)) return DayStatus.future;
  var best = -1; // 0 missed, 1 partial, 2 completed
  for (final s in sessions) {
    final v = switch (s.status) {
      'completed' => 2,
      'partial' => 1,
      'in_progress' => s.setCount > 0 ? 1 : -1,
      'missed' => 0,
      _ => s.setCount > 0 ? 1 : -1,
    };
    if (v > best) best = v;
  }
  if (best == 2) return DayStatus.completed;
  if (best == 1) return DayStatus.partial;
  if (best == 0) return DayStatus.missed;
  if (trackingStart != null && d.isBefore(_day(trackingStart))) return DayStatus.none;
  if (!trainingWeekdays.contains(d.weekday)) return DayStatus.rest;
  if (d == t) return DayStatus.today;
  return DayStatus.missed;
}

/// Day → status for every day of [from]..[to] (inclusive).
Map<DateTime, DayStatus> adherenceForRange({
  required DateTime from,
  required DateTime to,
  required List<SessionLite> sessions,
  required Set<int> trainingWeekdays,
  required DateTime today,
  DateTime? trackingStart,
}) {
  final byDay = <DateTime, List<SessionLite>>{};
  for (final s in sessions) {
    byDay.putIfAbsent(_day(s.date), () => []).add(s);
  }
  final out = <DateTime, DayStatus>{};
  for (var d = _day(from); !d.isAfter(_day(to)); d = addDays(d, 1)) {
    out[d] = dayStatus(
      day: d,
      sessions: byDay[d] ?? const [],
      trainingWeekdays: trainingWeekdays,
      today: today,
      trackingStart: trackingStart,
    );
  }
  return out;
}

class AdherenceSummary {
  final int completed, partial, missed, rest;
  const AdherenceSummary({this.completed = 0, this.partial = 0, this.missed = 0, this.rest = 0});

  int get planned => completed + partial + missed;

  /// (completed + ½ partial) / (completed + partial + missed); null when nothing was due.
  double? get percent => planned == 0 ? null : (completed + partial * 0.5) / planned * 100;
}

AdherenceSummary summarizeAdherence(Iterable<DayStatus> days) {
  var c = 0, p = 0, m = 0, r = 0;
  for (final d in days) {
    switch (d) {
      case DayStatus.completed:
        c++;
      case DayStatus.partial:
        p++;
      case DayStatus.missed:
        m++;
      case DayStatus.rest:
        r++;
      default:
        break;
    }
  }
  return AdherenceSummary(completed: c, partial: p, missed: m, rest: r);
}

/// Training weekdays from the profile, falling back to the active plan's days.
Future<Set<int>> loadTrainingWeekdays(AppDatabase db) async {
  final p = await (db.select(db.userProfiles)..where((t) => t.id.equals(1))).getSingleOrNull();
  final fromProfile = p == null ? <int>{} : _safeTrainingDays(p);
  if (fromProfile.isNotEmpty) return fromProfile;
  final plan = await (db.select(db.workoutPlans)..where((t) => t.isActive.equals(true))).get();
  if (plan.isEmpty) return {};
  final days = await (db.select(db.planDays)
        ..where((t) => t.planId.equals(plan.first.id) & t.isRest.equals(false) & t.weekday.isNotNull()))
      .get();
  return days.map((d) => d.weekday!).toSet();
}

Set<int> _safeTrainingDays(UserProfile p) {
  try {
    return p.trainingDays.toSet();
  } catch (_) {
    return {};
  }
}

/// Sessions (with set counts) in [from]..[to] inclusive.
Selectable<SessionLite> sessionsLiteQuery(AppDatabase db, DateTime from, DateTime to) {
  return db.customSelect(
    'SELECT ws.id AS id, ws.date AS date, ws.status AS status, ws.name AS name, '
    '(SELECT COUNT(*) FROM set_logs sl WHERE sl.session_id = ws.id) AS cnt '
    'FROM workout_sessions ws WHERE ws.date >= ? AND ws.date < ? ORDER BY ws.date',
    variables: [Variable.withDateTime(_day(from)), Variable.withDateTime(addDays(to, 1))],
    readsFrom: {db.workoutSessions, db.setLogs},
  ).map((r) => SessionLite(
        id: r.read<int>('id'),
        date: _day(r.read<DateTime>('date')),
        status: r.read<String>('status'),
        name: r.readNullable<String>('name'),
        setCount: r.read<int>('cnt'),
      ));
}

/// First day that counts for adherence: profile creation or the first session, whichever is earlier.
Future<DateTime?> loadTrackingStart(AppDatabase db) async {
  final p = await (db.select(db.userProfiles)..where((t) => t.id.equals(1))).getSingleOrNull();
  final minDate = db.workoutSessions.date.min();
  final first = await (db.selectOnly(db.workoutSessions)..addColumns([minDate])).map((r) => r.read(minDate)).getSingle();
  DateTime? start = p == null ? null : _day(p.createdAt);
  if (first != null && (start == null || first.isBefore(start))) start = _day(first);
  return start;
}

class MonthAdherence {
  final DateTime month; // first day of month
  final Map<DateTime, DayStatus> days;
  final AdherenceSummary summary;
  const MonthAdherence(this.month, this.days, this.summary);
}

// ---------------------------------------------------------------------------
// Body weight, nutrition, sleep
// ---------------------------------------------------------------------------

/// Last logged weight per day, ascending.
List<DatedValue> dailyWeights(Iterable<BodyMetric> metrics) {
  final byDay = <DateTime, BodyMetric>{};
  for (final m in metrics) {
    if (m.weightKg == null) continue;
    final d = _day(m.date);
    final cur = byDay[d];
    if (cur == null || !m.date.isBefore(cur.date)) byDay[d] = m;
  }
  final days = byDay.keys.toList()..sort();
  return [for (final d in days) DatedValue(d, byDay[d]!.weightKg!)];
}

enum MeasureKind { waist, chest, arm, thigh, neck, hips, bodyFat }

double? measureOf(BodyMetric m, MeasureKind k) => switch (k) {
      MeasureKind.waist => m.waistCm,
      MeasureKind.chest => m.chestCm,
      MeasureKind.arm => m.armCm,
      MeasureKind.thigh => m.thighCm,
      MeasureKind.neck => m.neckCm,
      MeasureKind.hips => m.hipsCm,
      MeasureKind.bodyFat => m.bodyFatPct,
    };

/// Series per measurement (only kinds that have data), last value per day.
Map<MeasureKind, List<DatedValue>> measurementSeries(Iterable<BodyMetric> metrics) {
  final out = <MeasureKind, List<DatedValue>>{};
  final sorted = metrics.toList()..sort((a, b) => a.date.compareTo(b.date));
  for (final k in MeasureKind.values) {
    final byDay = <DateTime, double>{};
    for (final m in sorted) {
      final v = measureOf(m, k);
      if (v != null) byDay[_day(m.date)] = v;
    }
    if (byDay.isNotEmpty) {
      final days = byDay.keys.toList()..sort();
      out[k] = [for (final d in days) DatedValue(d, byDay[d]!)];
    }
  }
  return out;
}

class NutritionDay {
  final DateTime date;
  final double calories, protein, carbs, fat;
  final int? calorieTarget, proteinTarget, carbsTarget, fatTarget;
  const NutritionDay({
    required this.date,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.calorieTarget,
    this.proteinTarget,
    this.carbsTarget,
    this.fatTarget,
  });
}

/// Meal-log sums per day (pending AI analyses skipped) vs the profile targets for that day.
List<NutritionDay> nutritionByDay(Iterable<MealLog> logs, UserProfile? profile) {
  final acc = <DateTime, List<double>>{};
  for (final m in logs) {
    if (m.status != 'done') continue;
    final a = acc.putIfAbsent(_day(m.date), () => [0, 0, 0, 0]);
    a[0] += m.calories;
    a[1] += m.protein;
    a[2] += m.carbs;
    a[3] += m.fat;
  }
  final days = acc.keys.toList()..sort();
  return [
    for (final d in days)
      NutritionDay(
        date: d,
        calories: acc[d]![0],
        protein: acc[d]![1],
        carbs: acc[d]![2],
        fat: acc[d]![3],
        calorieTarget: profile == null ? null : _safe<int?>(() => profile.caloriesFor(d)) ?? profile.calorieTarget,
        proteinTarget: profile?.proteinG,
        carbsTarget: profile == null ? null : _safe<int?>(() => profile.carbsFor(d)) ?? profile.carbsG,
        fatTarget: profile?.fatG,
      ),
  ];
}

T? _safe<T>(T Function() f) {
  try {
    return f();
  } catch (_) {
    return null;
  }
}

class SleepDay {
  final DateTime date;
  final double? hours;
  final int? quality;
  final int? recovery;
  const SleepDay({required this.date, this.hours, this.quality, this.recovery});
}

/// Sleep hours (all sleep logs of the wake-up day summed) joined with the recovery score.
List<SleepDay> sleepByDay(Iterable<SleepLog> sleep, Iterable<HealthDailyData> health) {
  final mins = <DateTime, int>{};
  final quality = <DateTime, int>{};
  for (final s in sleep) {
    final d = _day(s.date);
    mins[d] = (mins[d] ?? 0) + s.durationMin;
    if (s.quality != null) quality[d] = s.quality!;
  }
  final rec = <DateTime, int>{};
  for (final h in health) {
    if (h.recoveryScore != null) rec[_day(h.date)] = h.recoveryScore!;
  }
  final days = {...mins.keys, ...rec.keys}.toList()..sort();
  return [
    for (final d in days)
      SleepDay(date: d, hours: mins[d] == null ? null : mins[d]! / 60.0, quality: quality[d], recovery: rec[d]),
  ];
}

// ---------------------------------------------------------------------------
// Day details (calendar sheet)
// ---------------------------------------------------------------------------

class DaySetDetail {
  final double weightKg;
  final int reps;
  final double? rpe;
  final String setType;
  final bool isPr;
  const DaySetDetail(this.weightKg, this.reps, this.rpe, this.setType, this.isPr);
}

class DayExerciseDetail {
  final String exerciseId;
  final Exercise? exercise;
  final List<DaySetDetail> sets;
  const DayExerciseDetail(this.exerciseId, this.exercise, this.sets);
  double get volume => sets.where((s) => s.setType != 'warmup').fold(0.0, (a, s) => a + s.weightKg * s.reps);
}

class DaySessionDetail {
  final WorkoutSession session;
  final List<DayExerciseDetail> exercises;
  final List<CardioLog> cardio;
  const DaySessionDetail(this.session, this.exercises, this.cardio);
  double get volume => exercises.fold(0.0, (a, e) => a + e.volume);
  int get prCount => exercises.fold(0, (a, e) => a + e.sets.where((s) => s.isPr).length);
  int get setCount => exercises.fold(0, (a, e) => a + e.sets.length);
}

class DayDetails {
  final DateTime day;
  final DayStatus status;
  final List<DaySessionDetail> sessions;
  final List<CardioLog> standaloneCardio;
  final double calories, protein, carbs, fat;
  final int mealCount;
  final int? calorieTarget, proteinTarget;
  final int waterMl;
  final int? waterGoalMl;
  final double? sleepHours;
  final int? sleepQuality;
  final int? recovery;
  final double? weightKg;
  const DayDetails({
    required this.day,
    required this.status,
    required this.sessions,
    required this.standaloneCardio,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.mealCount,
    this.calorieTarget,
    this.proteinTarget,
    required this.waterMl,
    this.waterGoalMl,
    this.sleepHours,
    this.sleepQuality,
    this.recovery,
    this.weightKg,
  });

  bool get isEmpty =>
      sessions.isEmpty &&
      standaloneCardio.isEmpty &&
      mealCount == 0 &&
      waterMl == 0 &&
      sleepHours == null &&
      weightKg == null &&
      recovery == null;
}

Future<DayDetails> loadDayDetails(AppDatabase db, DateTime day, {DateTime? now}) async {
  final d = _day(day), next = addDays(d, 1);
  final sessions = await (db.select(db.workoutSessions)
        ..where((t) => t.date.isBiggerOrEqualValue(d) & t.date.isSmallerThanValue(next))
        ..orderBy([(t) => OrderingTerm.asc(t.startedAt)]))
      .get();
  final ids = sessions.map((s) => s.id).toList();
  final sets = ids.isEmpty
      ? <SetLog>[]
      : await (db.select(db.setLogs)
            ..where((t) => t.sessionId.isIn(ids))
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt), (t) => OrderingTerm.asc(t.setIndex)]))
          .get();
  final exIds = sets.map((s) => s.exerciseId).toSet();
  final exercises = exIds.isEmpty
      ? <String, Exercise>{}
      : {for (final e in await ExerciseRepository(db).byIds(exIds)) e.id: e};
  final cardio = await (db.select(db.cardioLogs)
        ..where((t) => t.date.isBiggerOrEqualValue(d) & t.date.isSmallerThanValue(next)))
      .get();

  final sessionDetails = <DaySessionDetail>[];
  for (final s in sessions) {
    final byEx = <String, List<DaySetDetail>>{};
    for (final x in sets.where((x) => x.sessionId == s.id)) {
      byEx.putIfAbsent(x.exerciseId, () => []).add(DaySetDetail(x.weightKg, x.reps, x.rpe, x.setType, x.isPr));
    }
    sessionDetails.add(DaySessionDetail(
      s,
      [for (final e in byEx.entries) DayExerciseDetail(e.key, exercises[e.key], e.value)],
      cardio.where((c) => c.sessionId == s.id).toList(),
    ));
  }

  final meals = await (db.select(db.mealLogs)
        ..where((t) => t.date.isBiggerOrEqualValue(d) & t.date.isSmallerThanValue(next) & t.status.equals('done')))
      .get();
  final water = await (db.select(db.waterLogs)
        ..where((t) => t.timestamp.isBiggerOrEqualValue(d) & t.timestamp.isSmallerThanValue(next)))
      .get();
  final sleep = await (db.select(db.sleepLogs)
        ..where((t) => t.date.isBiggerOrEqualValue(d) & t.date.isSmallerThanValue(next)))
      .get();
  final health = await (db.select(db.healthDaily)
        ..where((t) => t.date.isBiggerOrEqualValue(d) & t.date.isSmallerThanValue(next)))
      .get();
  final weights = await (db.select(db.bodyMetrics)
        ..where((t) => t.date.isBiggerOrEqualValue(d) & t.date.isSmallerThanValue(next) & t.weightKg.isNotNull())
        ..orderBy([(t) => OrderingTerm.desc(t.date), (t) => OrderingTerm.desc(t.id)]))
      .get();
  final profile = await (db.select(db.userProfiles)..where((t) => t.id.equals(1))).getSingleOrNull();
  final weekdays = await loadTrainingWeekdays(db);
  final start = await loadTrackingStart(db);

  final status = dayStatus(
    day: d,
    sessions: [
      for (final s in sessions)
        SessionLite(id: s.id, date: s.date, status: s.status, setCount: sets.where((x) => x.sessionId == s.id).length),
    ],
    trainingWeekdays: weekdays,
    today: now ?? DateTime.now(),
    trackingStart: start,
  );
  final sleepMin = sleep.fold<int>(0, (a, s) => a + s.durationMin);

  return DayDetails(
    day: d,
    status: status,
    sessions: sessionDetails,
    standaloneCardio: cardio.where((c) => c.sessionId == null || !ids.contains(c.sessionId)).toList(),
    calories: meals.fold(0.0, (a, m) => a + m.calories),
    protein: meals.fold(0.0, (a, m) => a + m.protein),
    carbs: meals.fold(0.0, (a, m) => a + m.carbs),
    fat: meals.fold(0.0, (a, m) => a + m.fat),
    mealCount: meals.length,
    calorieTarget: profile == null ? null : _safe<int?>(() => profile.caloriesFor(d)) ?? profile.calorieTarget,
    proteinTarget: profile?.proteinG,
    waterMl: water.fold(0, (a, w) => a + w.amountMl),
    waterGoalMl: profile?.waterGoalMl,
    sleepHours: sleep.isEmpty ? null : sleepMin / 60.0,
    sleepQuality: sleep.map((s) => s.quality).whereType<int>().lastOrNull,
    recovery: health.map((h) => h.recoveryScore).whereType<int>().lastOrNull,
    weightKg: weights.isEmpty ? null : weights.first.weightKg,
  );
}

// ---------------------------------------------------------------------------
// Providers
// ---------------------------------------------------------------------------

/// Set rows inside the selected period (live).
final periodSetRowsProvider = StreamProvider<List<SetRow>>((ref) {
  final db = ref.watch(databaseProvider);
  final from = ref.watch(progressPeriodStartProvider);
  return watchSetRows(db, from: from);
});

/// Weekly volume per muscle + effective sets for the selected period.
final muscleVolumeProvider = Provider<AsyncValue<MuscleVolumeData>>((ref) {
  final from = ref.watch(progressPeriodStartProvider);
  return ref
      .watch(periodSetRowsProvider)
      .whenData((rows) => buildMuscleVolume(rows, from: from, today: DateTime.now()));
});

class LoggedExercise {
  final Exercise exercise;
  final DateTime lastLogged;
  final int sets;
  const LoggedExercise(this.exercise, this.lastLogged, this.sets);
}

/// Exercises the user has logged at least one set of, most recently trained first.
final loggedExercisesProvider = StreamProvider<List<LoggedExercise>>((ref) {
  final db = ref.watch(databaseProvider);
  final last = db.setLogs.createdAt.max();
  final count = db.setLogs.id.count();
  final q = db.selectOnly(db.setLogs)
    ..addColumns([db.setLogs.exerciseId, last, count])
    ..groupBy([db.setLogs.exerciseId]);
  return q.watch().asyncMap((rows) async {
    final meta = {
      for (final r in rows) r.read(db.setLogs.exerciseId)!: (r.read(last) ?? DateTime(2000), r.read(count) ?? 0),
    };
    if (meta.isEmpty) return <LoggedExercise>[];
    final exs = await ExerciseRepository(db).byIds(meta.keys);
    final out = [for (final e in exs) LoggedExercise(e, meta[e.id]!.$1, meta[e.id]!.$2)]
      ..sort((a, b) => b.lastLogged.compareTo(a.lastLogged));
    return out;
  });
});

class SelectedExerciseNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  void select(String? id) => state = id;
}

/// Exercise picked in the progress chart (null → most recently trained).
final selectedProgressExerciseProvider =
    NotifierProvider<SelectedExerciseNotifier, String?>(SelectedExerciseNotifier.new);

/// Effective exercise id for the progress chart.
final effectiveProgressExerciseProvider = Provider<String?>((ref) {
  final picked = ref.watch(selectedProgressExerciseProvider);
  if (picked != null) return picked;
  final list = ref.watch(loggedExercisesProvider).value;
  return (list == null || list.isEmpty) ? null : list.first.exercise.id;
});

/// Top-set weight and e1RM per day for one exercise within the selected period.
final exerciseProgressProvider = StreamProvider.family<List<ExerciseProgressPoint>, String>((ref, exerciseId) {
  final db = ref.watch(databaseProvider);
  final from = ref.watch(progressPeriodStartProvider);
  return watchSetRows(db, from: from, exerciseId: exerciseId).map(exerciseProgressSeries);
});

/// Body metrics rows inside the period (live).
final periodBodyMetricsProvider = StreamProvider<List<BodyMetric>>((ref) {
  final db = ref.watch(databaseProvider);
  final from = ref.watch(progressPeriodStartProvider);
  final q = db.select(db.bodyMetrics)..orderBy([(t) => OrderingTerm.asc(t.date)]);
  if (from != null) q.where((t) => t.date.isBiggerOrEqualValue(from));
  return q.watch();
});

class BodyWeightData {
  final List<DatedValue> daily;
  final List<DatedValue> avg7;
  final Map<MeasureKind, List<DatedValue>> measurements;
  const BodyWeightData(this.daily, this.avg7, this.measurements);
}

final bodyWeightDataProvider = Provider<AsyncValue<BodyWeightData>>((ref) {
  return ref.watch(periodBodyMetricsProvider).whenData((rows) {
    final daily = dailyWeights(rows);
    return BodyWeightData(daily, Stats.movingAverage(daily, days: 7), measurementSeries(rows));
  });
});

final _periodMealLogsProvider = StreamProvider<List<MealLog>>((ref) {
  final db = ref.watch(databaseProvider);
  final from = ref.watch(progressPeriodStartProvider);
  final q = db.select(db.mealLogs)..orderBy([(t) => OrderingTerm.asc(t.date)]);
  if (from != null) q.where((t) => t.date.isBiggerOrEqualValue(from));
  return q.watch();
});

/// Calories & macros per day vs targets inside the period.
final nutritionDaysProvider = Provider<AsyncValue<List<NutritionDay>>>((ref) {
  final logs = ref.watch(_periodMealLogsProvider);
  final profile = ref.watch(profileProvider);
  if (logs.hasError) return AsyncValue.error(logs.error!, logs.stackTrace ?? StackTrace.current);
  if (!logs.hasValue) return const AsyncValue.loading();
  return AsyncValue.data(nutritionByDay(logs.requireValue, profile.value));
});

final _periodSleepProvider = StreamProvider<List<SleepLog>>((ref) {
  final db = ref.watch(databaseProvider);
  final from = ref.watch(progressPeriodStartProvider);
  final q = db.select(db.sleepLogs)..orderBy([(t) => OrderingTerm.asc(t.date)]);
  if (from != null) q.where((t) => t.date.isBiggerOrEqualValue(from));
  return q.watch();
});

final _periodHealthProvider = StreamProvider<List<HealthDailyData>>((ref) {
  final db = ref.watch(databaseProvider);
  final from = ref.watch(progressPeriodStartProvider);
  final q = db.select(db.healthDaily)..orderBy([(t) => OrderingTerm.asc(t.date)]);
  if (from != null) q.where((t) => t.date.isBiggerOrEqualValue(from));
  return q.watch();
});

/// Sleep hours + recovery score per day inside the period.
final sleepDaysProvider = Provider<AsyncValue<List<SleepDay>>>((ref) {
  final s = ref.watch(_periodSleepProvider);
  final h = ref.watch(_periodHealthProvider);
  for (final a in [s, h]) {
    if (a.hasError) return AsyncValue.error(a.error!, a.stackTrace ?? StackTrace.current);
  }
  if (!s.hasValue || !h.hasValue) return const AsyncValue.loading();
  return AsyncValue.data(sleepByDay(s.requireValue, h.requireValue));
});

/// Adherence statuses for a calendar month (key: any date inside the month).
final monthAdherenceProvider = StreamProvider.family<MonthAdherence, DateTime>((ref, month) {
  final db = ref.watch(databaseProvider);
  // Recompute when the profile (training days) changes.
  ref.watch(profileProvider);
  final first = DateTime(month.year, month.month, 1);
  final last = DateTime(month.year, month.month + 1, 0);
  return sessionsLiteQuery(db, first, last).watch().asyncMap((sessions) async {
    final weekdays = await loadTrainingWeekdays(db);
    final start = await loadTrackingStart(db);
    final days = adherenceForRange(
      from: first,
      to: last,
      sessions: sessions,
      trainingWeekdays: weekdays,
      today: DateTime.now(),
      trackingStart: start,
    );
    return MonthAdherence(first, days, summarizeAdherence(days.values));
  });
});

class PrListItem {
  final ExercisePrs prs;
  final Exercise? exercise;
  const PrListItem(this.prs, this.exercise);
}

/// All-time personal records for every logged exercise (live).
final prListProvider = StreamProvider<List<PrListItem>>((ref) {
  final db = ref.watch(databaseProvider);
  return watchSetRows(db).asyncMap((rows) async {
    final prs = computeExercisePrs(rows);
    if (prs.isEmpty) return <PrListItem>[];
    final exs = {for (final e in await ExerciseRepository(db).byIds(prs.map((p) => p.exerciseId))) e.id: e};
    return [for (final p in prs) PrListItem(p, exs[p.exerciseId])];
  });
});

/// Everything logged on one day (calendar sheet).
final dayDetailsProvider = FutureProvider.autoDispose.family<DayDetails, DateTime>((ref, day) {
  return loadDayDetails(ref.watch(databaseProvider), day);
});
