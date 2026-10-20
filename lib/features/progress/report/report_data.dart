/// Data model + DB gathering for the weekly / monthly PDF progress report.
library;

import 'package:drift/drift.dart';

import '../../../core/calc/stats.dart';
import '../../../core/calc/strength_calc.dart';
import '../../../core/providers.dart';
import '../../../data/repositories/exercise_repository.dart';
import '../../exercises/exercise_labels.dart';
import '../progress_providers.dart';

enum ReportKind { weekly, monthly }

/// Which period a report covers.
enum ReportRange { thisWeek, lastWeek, thisMonth, lastMonth }

extension ReportRangeX on ReportRange {
  ReportKind get kind =>
      this == ReportRange.thisWeek || this == ReportRange.lastWeek ? ReportKind.weekly : ReportKind.monthly;

  /// Inclusive day range (weeks are Saturday → Friday).
  (DateTime from, DateTime to) resolve(DateTime now) {
    switch (this) {
      case ReportRange.thisWeek:
        final s = weekStartSat(now);
        return (s, addDays(s, 6));
      case ReportRange.lastWeek:
        final s = addDays(weekStartSat(now), -7);
        return (s, addDays(s, 6));
      case ReportRange.thisMonth:
        return (DateTime(now.year, now.month, 1), DateTime(now.year, now.month + 1, 0));
      case ReportRange.lastMonth:
        return (DateTime(now.year, now.month - 1, 1), DateTime(now.year, now.month, 0));
    }
  }
}

class ReportSessionRow {
  final DateTime date;
  final String name;
  final String status; // completed / partial / in_progress / missed
  final int? durationMin;
  final int sets;
  final double volume;
  final int prs;
  const ReportSessionRow({
    required this.date,
    required this.name,
    required this.status,
    this.durationMin,
    required this.sets,
    required this.volume,
    required this.prs,
  });
}

class ReportPrRow {
  final DateTime date;
  final String exercise;
  final Set<PrType> types;
  final double weightKg;
  final int reps;
  const ReportPrRow({
    required this.date,
    required this.exercise,
    required this.types,
    required this.weightKg,
    required this.reps,
  });
  double get e1rm => StrengthCalc.epley1Rm(weightKg, reps);
}

class ReportBodyRow {
  final DateTime date;
  final double? weightKg, waistCm, chestCm, armCm, thighCm, neckCm, hipsCm, bodyFatPct;
  const ReportBodyRow({
    required this.date,
    this.weightKg,
    this.waistCm,
    this.chestCm,
    this.armCm,
    this.thighCm,
    this.neckCm,
    this.hipsCm,
    this.bodyFatPct,
  });
}

class ReportMuscleRow {
  final String muscle; // localized label
  final double volume;
  final int effectiveSets;
  const ReportMuscleRow(this.muscle, this.volume, this.effectiveSets);
}

/// Everything the PDF needs, already localized (names) and aggregated.
class ReportData {
  final ReportKind kind;
  final DateTime from, to; // inclusive days
  final DateTime generatedAt;
  final AdherenceSummary adherence;
  final double totalVolume;
  final int totalSets;
  final List<ReportSessionRow> sessions;
  final List<ReportPrRow> prs;
  final List<ReportBodyRow> bodyMetrics;
  final List<DatedValue> weights; // daily
  final List<NutritionDay> nutrition;
  final int? calorieTarget, proteinTarget;
  final double? avgSleepHours;
  final double? avgRecovery;
  final List<ReportMuscleRow> muscles;
  final String? coachSummary;

  const ReportData({
    required this.kind,
    required this.from,
    required this.to,
    required this.generatedAt,
    required this.adherence,
    required this.totalVolume,
    required this.totalSets,
    required this.sessions,
    required this.prs,
    required this.bodyMetrics,
    required this.weights,
    required this.nutrition,
    this.calorieTarget,
    this.proteinTarget,
    this.avgSleepHours,
    this.avgRecovery,
    required this.muscles,
    this.coachSummary,
  });

  /// Sessions with logged work (completed or partial).
  int get sessionsDone => sessions.where((s) => s.status == 'completed' || s.status == 'partial' || s.sets > 0).length;
  int get sessionsMissed => adherence.missed;
  double? get adherencePct => adherence.percent;

  double? get weightStart => weights.isEmpty ? null : weights.first.value;
  double? get weightEnd => weights.isEmpty ? null : weights.last.value;
  double? get weightChange => weights.length < 2 ? null : weightEnd! - weightStart!;

  double? get avgCalories => Stats.mean(nutrition.map((n) => n.calories));
  double? get avgProtein => Stats.mean(nutrition.map((n) => n.protein));
}

DateTime _d(DateTime d) => DateTime(d.year, d.month, d.day);

/// Collects every number for a report covering [from]..[to] (inclusive days).
/// Names are localized for [lang] ('ar' | 'en').
Future<ReportData> gatherReportData(
  AppDatabase db, {
  required DateTime from,
  required DateTime to,
  required ReportKind kind,
  required String lang,
  DateTime? now,
}) async {
  final f = _d(from), t = _d(to), end = addDays(t, 1);
  final nowTs = now ?? DateTime.now();

  // Workouts ---------------------------------------------------------------
  final allSetsToEnd = await loadSetRows(db, to: t);
  final periodSets = allSetsToEnd.where((s) => !s.date.isBefore(f)).toList();
  final prEvents = detectPrEvents(allSetsToEnd).where((e) => !e.set.date.isBefore(f)).toList();

  final exIds = {...periodSets.map((s) => s.exerciseId)};
  final exercises = exIds.isEmpty
      ? <String, Exercise>{}
      : {for (final e in await ExerciseRepository(db).byIds(exIds)) e.id: e};
  String exName(String id) => exercises[id]?.name(lang) ?? id;

  final sessions = await (db.select(db.workoutSessions)
        ..where((x) => x.date.isBiggerOrEqualValue(f) & x.date.isSmallerThanValue(end))
        ..orderBy([(x) => OrderingTerm.asc(x.date), (x) => OrderingTerm.asc(x.startedAt)]))
      .get();
  final sessionRows = <ReportSessionRow>[];
  for (final s in sessions) {
    final sets = periodSets.where((x) => x.sessionId == s.id).toList();
    if (s.status == 'missed' && sets.isEmpty) continue;
    if (s.status == 'in_progress' && sets.isEmpty) continue;
    final working = sets.where((x) => !x.isWarmup);
    sessionRows.add(ReportSessionRow(
      date: _d(s.date),
      name: (s.name?.trim().isNotEmpty ?? false) ? s.name!.trim() : _sessionFallbackName(sets, exName),
      status: s.status,
      durationMin: s.startedAt != null && s.endedAt != null ? s.endedAt!.difference(s.startedAt!).inMinutes : null,
      sets: working.length,
      volume: working.fold(0.0, (a, x) => a + x.volume),
      prs: prEvents.where((e) => e.set.sessionId == s.id).length,
    ));
  }

  final adherenceSessions = await sessionsLiteQuery(db, f, t).get();
  final weekdays = await loadTrainingWeekdays(db);
  final start = await loadTrackingStart(db);
  final adherence = summarizeAdherence(adherenceForRange(
    from: f,
    to: t,
    sessions: adherenceSessions,
    trainingWeekdays: weekdays,
    today: nowTs,
    trackingStart: start,
  ).values);

  final working = periodSets.where((s) => !s.isWarmup && s.reps > 0);
  final muscles = summarizeMuscles(weeklyMuscleStats(periodSets), weeks: 1.0)
      .map((m) => ReportMuscleRow(muscleShortLabel(m.muscle, lang), m.totalVolume, m.totalEffectiveSets))
      .toList();

  // Body ---------------------------------------------------------------------
  final metrics = await (db.select(db.bodyMetrics)
        ..where((x) => x.date.isBiggerOrEqualValue(f) & x.date.isSmallerThanValue(end))
        ..orderBy([(x) => OrderingTerm.asc(x.date)]))
      .get();
  final bodyRows = <DateTime, ReportBodyRow>{};
  for (final m in metrics) {
    final d = _d(m.date);
    final p = bodyRows[d];
    bodyRows[d] = ReportBodyRow(
      date: d,
      weightKg: m.weightKg ?? p?.weightKg,
      waistCm: m.waistCm ?? p?.waistCm,
      chestCm: m.chestCm ?? p?.chestCm,
      armCm: m.armCm ?? p?.armCm,
      thighCm: m.thighCm ?? p?.thighCm,
      neckCm: m.neckCm ?? p?.neckCm,
      hipsCm: m.hipsCm ?? p?.hipsCm,
      bodyFatPct: m.bodyFatPct ?? p?.bodyFatPct,
    );
  }

  // Nutrition, sleep, recovery -------------------------------------------------
  final profile = await (db.select(db.userProfiles)..where((x) => x.id.equals(1))).getSingleOrNull();
  final meals = await (db.select(db.mealLogs)
        ..where((x) => x.date.isBiggerOrEqualValue(f) & x.date.isSmallerThanValue(end)))
      .get();
  final sleep = await (db.select(db.sleepLogs)
        ..where((x) => x.date.isBiggerOrEqualValue(f) & x.date.isSmallerThanValue(end)))
      .get();
  final health = await (db.select(db.healthDaily)
        ..where((x) => x.date.isBiggerOrEqualValue(f) & x.date.isSmallerThanValue(end)))
      .get();
  final sleepDays = sleepByDay(sleep, health);

  // Coach summary: latest weekly report written in the period (1-day grace so a
  // report generated the morning after the week ends still belongs to it).
  final coach = await (db.select(db.coachMessages)
        ..where((x) =>
            x.kind.equals('weekly') &
            x.role.equals('assistant') &
            x.createdAt.isBiggerOrEqualValue(f) &
            x.createdAt.isSmallerThanValue(addDays(end, 1)))
        ..orderBy([(x) => OrderingTerm.desc(x.createdAt)])
        ..limit(1))
      .getSingleOrNull();

  return ReportData(
    kind: kind,
    from: f,
    to: t,
    generatedAt: nowTs,
    adherence: adherence,
    totalVolume: working.fold(0.0, (a, s) => a + s.volume),
    totalSets: working.length,
    sessions: sessionRows,
    prs: [
      for (final e in prEvents)
        ReportPrRow(
          date: e.set.date,
          exercise: exName(e.set.exerciseId),
          types: e.types,
          weightKg: e.set.weightKg,
          reps: e.set.reps,
        ),
    ],
    bodyMetrics: bodyRows.values.toList(),
    weights: dailyWeights(metrics),
    nutrition: nutritionByDay(meals, profile),
    calorieTarget: profile?.calorieTarget,
    proteinTarget: profile?.proteinG,
    avgSleepHours: Stats.mean(sleepDays.map((s) => s.hours).whereType<double>()),
    avgRecovery: Stats.mean(sleepDays.map((s) => s.recovery).whereType<int>().map((v) => v.toDouble())),
    muscles: muscles,
    coachSummary: (coach?.content.trim().isNotEmpty ?? false) ? coach!.content.trim() : null,
  );
}

String _sessionFallbackName(List<SetRow> sets, String Function(String) exName) {
  final ids = <String>[];
  for (final s in sets) {
    if (!ids.contains(s.exerciseId)) ids.add(s.exerciseId);
  }
  if (ids.isEmpty) return '—';
  final names = ids.take(2).map(exName).join(', ');
  return ids.length > 2 ? '$names…' : names;
}
