import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/calc/strength_calc.dart';
import '../../core/providers.dart';
import '../../core/utils/context_ext.dart' show dayOf;
import 'workout_logic.dart';

/// A plan exercise joined with its exercise row.
class PlanExerciseItem {
  final PlanExercise pe;
  final Exercise ex;
  const PlanExerciseItem(this.pe, this.ex);
}

/// History row: session + number of sets and PRs.
class SessionListItem {
  final WorkoutSession session;
  final int sets;
  final int prs;
  const SessionListItem(this.session, this.sets, this.prs);
}

/// Previous session's working sets of one exercise.
class PastSession {
  final int sessionId;
  final DateTime date;
  final List<SetLog> sets;
  const PastSession(this.sessionId, this.date, this.sets);
}

/// Re-runs [load] whenever any of [tables] changes.
Stream<T> watchTables<T>(AppDatabase db, Set<ResultSetImplementation> tables, Future<T> Function() load) async* {
  yield await load();
  await for (final _ in db.tableUpdates(TableUpdateQuery.onAllTables(tables))) {
    yield await load();
  }
}

class WorkoutRepository {
  final AppDatabase db;
  WorkoutRepository(this.db);

  // ---------------------------------------------------------------- plans

  Future<WorkoutPlan?> activePlan() => (db.select(db.workoutPlans)
        ..where((t) => t.isActive.equals(true))
        ..orderBy([(t) => OrderingTerm.desc(t.activatedAt)])
        ..limit(1))
      .getSingleOrNull();

  Stream<WorkoutPlan?> watchActivePlan() => (db.select(db.workoutPlans)
        ..where((t) => t.isActive.equals(true))
        ..orderBy([(t) => OrderingTerm.desc(t.activatedAt)])
        ..limit(1))
      .watchSingleOrNull();

  Stream<WorkoutPlan?> watchPlan(int id) =>
      (db.select(db.workoutPlans)..where((t) => t.id.equals(id))).watchSingleOrNull();

  Future<WorkoutPlan?> plan(int id) => (db.select(db.workoutPlans)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Generated plans that were never approved (newest first).
  Stream<List<WorkoutPlan>> watchPendingPlans() => (db.select(db.workoutPlans)
        ..where((t) => t.isActive.equals(false) & t.activatedAt.isNull())
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
      .watch();

  Future<List<PlanDay>> days(int planId) => (db.select(db.planDays)
        ..where((t) => t.planId.equals(planId))
        ..orderBy([(t) => OrderingTerm.asc(t.orderIndex), (t) => OrderingTerm.asc(t.weekday)]))
      .get();

  Stream<List<PlanDay>> watchDays(int planId) => (db.select(db.planDays)
        ..where((t) => t.planId.equals(planId))
        ..orderBy([(t) => OrderingTerm.asc(t.orderIndex), (t) => OrderingTerm.asc(t.weekday)]))
      .watch();

  Future<PlanDay?> day(int id) => (db.select(db.planDays)..where((t) => t.id.equals(id))).getSingleOrNull();

  Stream<PlanDay?> watchDay(int id) => (db.select(db.planDays)..where((t) => t.id.equals(id))).watchSingleOrNull();

  JoinedSelectStatement<HasResultSet, dynamic> _dayExercisesQuery(int dayId) {
    final q = db.select(db.planExercises).join([
      innerJoin(db.exercises, db.exercises.id.equalsExp(db.planExercises.exerciseId)),
    ])
      ..where(db.planExercises.planDayId.equals(dayId))
      ..orderBy([OrderingTerm.asc(db.planExercises.orderIndex), OrderingTerm.asc(db.planExercises.id)]);
    return q;
  }

  PlanExerciseItem _mapItem(TypedResult r) =>
      PlanExerciseItem(r.readTable(db.planExercises), r.readTable(db.exercises));

  Future<List<PlanExerciseItem>> dayExercises(int dayId) async =>
      (await _dayExercisesQuery(dayId).get()).map(_mapItem).toList();

  Stream<List<PlanExerciseItem>> watchDayExercises(int dayId) =>
      _dayExercisesQuery(dayId).watch().map((rows) => rows.map(_mapItem).toList());

  /// Number of exercises per plan day of [planId].
  Future<Map<int, int>> exerciseCounts(int planId) async {
    final c = db.planExercises.id.count();
    final q = db.selectOnly(db.planExercises).join([
      innerJoin(db.planDays, db.planDays.id.equalsExp(db.planExercises.planDayId)),
    ])
      ..addColumns([db.planExercises.planDayId, c])
      ..where(db.planDays.planId.equals(planId))
      ..groupBy([db.planExercises.planDayId]);
    final rows = await q.get();
    return {for (final r in rows) r.read(db.planExercises.planDayId)!: r.read(c) ?? 0};
  }

  Stream<Map<int, int>> watchExerciseCounts(int planId) =>
      watchTables(db, {db.planExercises, db.planDays}, () => exerciseCounts(planId));

  Future<void> updatePlanExercise(int id, PlanExercisesCompanion data) =>
      (db.update(db.planExercises)..where((t) => t.id.equals(id))).write(data);

  Future<void> removePlanExercise(int id) => (db.delete(db.planExercises)..where((t) => t.id.equals(id))).go();

  Future<int> addPlanExercise(int dayId, String exerciseId, {int sets = 3, int repMin = 8, int repMax = 12}) async {
    final maxIdx = db.planExercises.orderIndex.max();
    final cur = await (db.selectOnly(db.planExercises)
          ..addColumns([maxIdx])
          ..where(db.planExercises.planDayId.equals(dayId)))
        .map((r) => r.read(maxIdx))
        .getSingleOrNull();
    return db.into(db.planExercises).insert(PlanExercisesCompanion.insert(
          planDayId: dayId,
          exerciseId: exerciseId,
          orderIndex: Value((cur ?? -1) + 1),
          sets: Value(sets),
          repMin: Value(repMin),
          repMax: Value(repMax),
        ));
  }

  Future<void> reorder(List<int> orderedIds) => db.transaction(() async {
        for (var i = 0; i < orderedIds.length; i++) {
          await (db.update(db.planExercises)..where((t) => t.id.equals(orderedIds[i])))
              .write(PlanExercisesCompanion(orderIndex: Value(i)));
        }
      });

  /// Replaces the exercise (keeps sets/reps/rest); the planned weight is cleared.
  Future<void> swapPlanExercise(int id, String newExerciseId) =>
      (db.update(db.planExercises)..where((t) => t.id.equals(id))).write(PlanExercisesCompanion(
        exerciseId: Value(newExerciseId),
        suggestedWeightKg: const Value(null),
      ));

  /// Deactivates every other plan and activates [planId].
  Future<void> approvePlan(int planId) => db.transaction(() async {
        await (db.update(db.workoutPlans)..where((t) => t.id.equals(planId).not()))
            .write(const WorkoutPlansCompanion(isActive: Value(false)));
        await (db.update(db.workoutPlans)..where((t) => t.id.equals(planId))).write(WorkoutPlansCompanion(
          isActive: const Value(true),
          activatedAt: Value(DateTime.now()),
        ));
      });

  Future<void> deletePlan(int planId) => db.transaction(() async {
        // Sessions keep their history (plan_day_id → NULL via ON DELETE SET NULL).
        await (db.delete(db.workoutPlans)..where((t) => t.id.equals(planId))).go();
      });

  /// Saves a validated plan JSON (AI or template) as an inactive plan. Non-training
  /// weekdays become rest days. Returns the plan id.
  Future<int> savePlanJson(Map<String, dynamic> json, {String source = 'ai', String? rawJson}) {
    return db.transaction(() async {
      final planId = await db.into(db.workoutPlans).insert(WorkoutPlansCompanion.insert(
            name: (json['name'] as String?)?.trim().isNotEmpty == true ? json['name'] as String : 'Plan',
            notes: Value(json['notes'] as String?),
            source: Value(source),
            isActive: const Value(false),
            deloadEveryWeeks: Value((json['deloadEveryWeeks'] as num?)?.toInt()),
            rawJson: Value(rawJson ?? jsonEncode(json)),
          ));
      final byWeekday = <int, Map<String, dynamic>>{};
      for (final d in (json['days'] as List).cast<Map<String, dynamic>>()) {
        byWeekday[(d['weekday'] as num).toInt()] = d;
      }
      for (var wd = 1; wd <= 7; wd++) {
        final d = byWeekday[wd];
        if (d == null) {
          await db.into(db.planDays).insert(PlanDaysCompanion.insert(
                planId: planId,
                weekday: Value(wd),
                orderIndex: Value(wd),
                name: 'Rest',
                isRest: const Value(true),
              ));
          continue;
        }
        final dayId = await db.into(db.planDays).insert(PlanDaysCompanion.insert(
              planId: planId,
              weekday: Value(wd),
              orderIndex: Value(wd),
              name: d['name'] as String,
              focus: Value(d['focus'] as String?),
              warmupJson: Value(jsonEncode(d['warmup'] ?? const [])),
              cooldownJson: Value(jsonEncode(d['cooldown'] ?? const [])),
            ));
        final exs = (d['exercises'] as List).cast<Map<String, dynamic>>();
        for (var i = 0; i < exs.length; i++) {
          final e = exs[i];
          await db.into(db.planExercises).insert(PlanExercisesCompanion.insert(
                planDayId: dayId,
                exerciseId: e['exerciseId'] as String,
                orderIndex: Value(i),
                sets: Value((e['sets'] as num).toInt()),
                repMin: Value((e['repMin'] as num).toInt()),
                repMax: Value((e['repMax'] as num).toInt()),
                suggestedWeightKg: Value((e['suggestedWeightKg'] as num?)?.toDouble()),
                targetRpe: Value((e['targetRpe'] as num?)?.toDouble()),
                restSeconds: Value((e['restSeconds'] as num?)?.toInt() ?? 90),
                notes: Value((e['notes'] as String?)?.trim().isEmpty == true ? null : e['notes'] as String?),
              ));
        }
      }
      return planId;
    });
  }

  /// Training plan day for a weekday of the active plan (null when rest / no plan).
  Future<PlanDay?> activeDayForWeekday(int weekday) async {
    final plan = await activePlan();
    if (plan == null) return null;
    return (db.select(db.planDays)
          ..where((t) => t.planId.equals(plan.id) & t.weekday.equals(weekday))
          ..limit(1))
        .getSingleOrNull();
  }

  // ------------------------------------------------------------- sessions

  Future<WorkoutSession?> session(int id) =>
      (db.select(db.workoutSessions)..where((t) => t.id.equals(id))).getSingleOrNull();

  Stream<WorkoutSession?> watchSession(int id) =>
      (db.select(db.workoutSessions)..where((t) => t.id.equals(id))).watchSingleOrNull();

  /// Today's (non-missed) session, preferring an in-progress one, optionally for a plan day.
  Future<WorkoutSession?> sessionOn(DateTime day, {int? planDayId}) async {
    final rows = await (db.select(db.workoutSessions)
          ..where((t) {
            Expression<bool> e = t.date.equals(dayOf(day)) & t.status.equals(SessionStatus.missed).not();
            if (planDayId != null) e = e & t.planDayId.equals(planDayId);
            return e;
          })
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
        .get();
    if (rows.isEmpty) return null;
    return rows.firstWhere((s) => s.status == SessionStatus.inProgress, orElse: () => rows.first);
  }

  Future<int> startSession({int? planDayId, String? name, bool isDeload = false}) =>
      db.into(db.workoutSessions).insert(WorkoutSessionsCompanion.insert(
            date: dayOf(DateTime.now()),
            planDayId: Value(planDayId),
            name: Value(name),
            startedAt: Value(DateTime.now()),
            status: const Value(SessionStatus.inProgress),
            isDeload: Value(isDeload),
          ));

  Future<void> reopenSession(int id) => (db.update(db.workoutSessions)..where((t) => t.id.equals(id)))
      .write(const WorkoutSessionsCompanion(status: Value(SessionStatus.inProgress)));

  Future<void> deleteSession(int id) => (db.delete(db.workoutSessions)..where((t) => t.id.equals(id))).go();

  Future<void> updateSessionNotes(int id, String? notes) => (db.update(db.workoutSessions)
        ..where((t) => t.id.equals(id)))
      .write(WorkoutSessionsCompanion(notes: Value(notes?.trim().isEmpty == true ? null : notes?.trim())));

  Future<void> finishSession(int id, {required String status, required double volume, String? notes}) =>
      (db.update(db.workoutSessions)..where((t) => t.id.equals(id))).write(WorkoutSessionsCompanion(
        status: Value(status),
        totalVolume: Value(volume),
        endedAt: Value(DateTime.now()),
        notes: notes == null ? const Value.absent() : Value(notes.trim().isEmpty ? null : notes.trim()),
      ));

  Future<List<SetLog>> sessionSets(int sessionId) => (db.select(db.setLogs)
        ..where((t) => t.sessionId.equals(sessionId))
        ..orderBy([(t) => OrderingTerm.asc(t.createdAt), (t) => OrderingTerm.asc(t.id)]))
      .get();

  Stream<List<SetLog>> watchSessionSets(int sessionId) => (db.select(db.setLogs)
        ..where((t) => t.sessionId.equals(sessionId))
        ..orderBy([(t) => OrderingTerm.asc(t.createdAt), (t) => OrderingTerm.asc(t.id)]))
      .watch();

  /// All earlier working sets of [exerciseId] (any session) for PR comparison.
  Future<List<HistSet>> prHistory(String exerciseId) async {
    final rows = await (db.select(db.setLogs)
          ..where((t) => t.exerciseId.equals(exerciseId) & t.setType.equals(SetType.warmup).not()))
        .get();
    return rows.map((r) => HistSet(r.weightKg, r.reps)).toList();
  }

  /// Logs a set; detects PRs for working sets against every earlier working set.
  Future<({int id, Set<PrType> prs})> addSet({
    required int sessionId,
    required String exerciseId,
    required double weightKg,
    required int reps,
    double? rpe,
    String setType = SetType.normal,
  }) async {
    var prs = <PrType>{};
    if (isWorkingSet(setType)) {
      prs = PrDetector.detect(weightKg: weightKg, reps: reps, history: await prHistory(exerciseId));
    }
    final c = db.setLogs.id.count();
    final count = await (db.selectOnly(db.setLogs)
          ..addColumns([c])
          ..where(db.setLogs.sessionId.equals(sessionId) & db.setLogs.exerciseId.equals(exerciseId)))
        .map((r) => r.read(c) ?? 0)
        .getSingle();
    final id = await db.into(db.setLogs).insert(SetLogsCompanion.insert(
          sessionId: sessionId,
          exerciseId: exerciseId,
          setIndex: count,
          weightKg: weightKg,
          reps: reps,
          rpe: Value(rpe),
          setType: Value(setType),
          isPr: Value(prs.isNotEmpty),
          prTypes: Value(prs.isEmpty ? null : prs.map((p) => p.name).join(',')),
        ));
    return (id: id, prs: prs);
  }

  Future<void> deleteSet(int id) => (db.delete(db.setLogs)..where((t) => t.id.equals(id))).go();

  /// Working sets of [exerciseId] grouped by earlier sessions, most recent first.
  Future<List<PastSession>> pastSessions(String exerciseId, {int? excludeSessionId, int limit = 2, DateTime? before}) async {
    final q = db.select(db.setLogs).join([
      innerJoin(db.workoutSessions, db.workoutSessions.id.equalsExp(db.setLogs.sessionId)),
    ])
      ..where(db.setLogs.exerciseId.equals(exerciseId) &
          db.setLogs.setType.equals(SetType.warmup).not() &
          (excludeSessionId == null ? const Constant(true) : db.setLogs.sessionId.equals(excludeSessionId).not()) &
          (before == null ? const Constant(true) : db.workoutSessions.date.isSmallerOrEqualValue(before)))
      ..orderBy([
        OrderingTerm.desc(db.workoutSessions.date),
        OrderingTerm.desc(db.workoutSessions.id),
        OrderingTerm.asc(db.setLogs.setIndex),
      ]);
    final rows = await q.get();
    final out = <PastSession>[];
    for (final r in rows) {
      final s = r.readTable(db.workoutSessions);
      final set = r.readTable(db.setLogs);
      if (out.isEmpty || out.last.sessionId != s.id) {
        if (out.length == limit) break;
        out.add(PastSession(s.id, s.date, []));
      }
      out.last.sets.add(set);
    }
    return out;
  }

  /// Best e1RM per session for [exerciseId] (chronological).
  Future<List<({DateTime date, double e1rm})>> sessionBests(String exerciseId, {DateTime? since}) async {
    final q = db.select(db.setLogs).join([
      innerJoin(db.workoutSessions, db.workoutSessions.id.equalsExp(db.setLogs.sessionId)),
    ])
      ..where(db.setLogs.exerciseId.equals(exerciseId) &
          db.setLogs.setType.equals(SetType.warmup).not() &
          (since == null ? const Constant(true) : db.workoutSessions.date.isBiggerOrEqualValue(since)));
    final rows = await q.get();
    final best = <int, ({DateTime date, double e1rm})>{};
    for (final r in rows) {
      final s = r.readTable(db.workoutSessions);
      final set = r.readTable(db.setLogs);
      final e = StrengthCalc.epley1Rm(set.weightKg, set.reps);
      final cur = best[s.id];
      if (cur == null || e > cur.e1rm) best[s.id] = (date: s.startedAt ?? s.date, e1rm: e);
    }
    return best.values.toList()..sort((a, b) => a.date.compareTo(b.date));
  }

  // -------------------------------------------------------------- notes

  Stream<List<SessionExerciseNote>> watchExerciseNotes(int sessionId) =>
      (db.select(db.sessionExerciseNotes)..where((t) => t.sessionId.equals(sessionId))).watch();

  Future<void> setExerciseNote(int sessionId, String exerciseId, String note) => db.transaction(() async {
        await (db.delete(db.sessionExerciseNotes)
              ..where((t) => t.sessionId.equals(sessionId) & t.exerciseId.equals(exerciseId)))
            .go();
        if (note.trim().isNotEmpty) {
          await db.into(db.sessionExerciseNotes).insert(SessionExerciseNotesCompanion.insert(
                sessionId: sessionId,
                exerciseId: exerciseId,
                note: note.trim(),
              ));
        }
      });

  // ------------------------------------------------------------- cardio

  Stream<List<CardioLog>> watchCardio(int sessionId) => (db.select(db.cardioLogs)
        ..where((t) => t.sessionId.equals(sessionId))
        ..orderBy([(t) => OrderingTerm.asc(t.id)]))
      .watch();

  Future<int> addCardio(CardioLogsCompanion c) => db.into(db.cardioLogs).insert(c);

  Future<void> deleteCardio(int id) => (db.delete(db.cardioLogs)..where((t) => t.id.equals(id))).go();

  /// Latest body weight (body_metrics → profile → 75 kg default).
  Future<double> currentBodyweight() async {
    final m = await (db.select(db.bodyMetrics)
          ..where((t) => t.weightKg.isNotNull())
          ..orderBy([(t) => OrderingTerm.desc(t.date)])
          ..limit(1))
        .getSingleOrNull();
    if (m?.weightKg != null) return m!.weightKg!;
    final p = await (db.select(db.userProfiles)..limit(1)).getSingleOrNull();
    return p?.weightKg ?? 75;
  }

  // ------------------------------------------------------------- history

  Stream<List<SessionListItem>> watchHistory({int limit = 300}) {
    return db
        .customSelect(
          'SELECT s.*, COUNT(l.id) AS set_count, COALESCE(SUM(l.is_pr), 0) AS pr_count '
          'FROM workout_sessions s LEFT JOIN set_logs l ON l.session_id = s.id '
          'GROUP BY s.id ORDER BY s.date DESC, s.id DESC LIMIT ?',
          variables: [Variable.withInt(limit)],
          readsFrom: {db.workoutSessions, db.setLogs},
        )
        .watch()
        .map((rows) => rows
            .map((r) => SessionListItem(
                  db.workoutSessions.map(r.data),
                  r.read<int>('set_count'),
                  r.read<int>('pr_count'),
                ))
            .toList());
  }

  /// Sessions of the week starting [weekStart] keyed by local day.
  Stream<Map<DateTime, WorkoutSession>> watchWeekSessions(DateTime weekStart) {
    final end = DateTime(weekStart.year, weekStart.month, weekStart.day + 7);
    return (db.select(db.workoutSessions)
          ..where((t) => t.date.isBiggerOrEqualValue(weekStart) & t.date.isSmallerThanValue(end))
          ..orderBy([(t) => OrderingTerm.asc(t.id)]))
        .watch()
        .map((rows) {
      final m = <DateTime, WorkoutSession>{};
      for (final s in rows) {
        final d = dayOf(s.date);
        final cur = m[d];
        // Prefer a real session over a "missed" marker.
        if (cur == null || cur.status == SessionStatus.missed) m[d] = s;
      }
      return m;
    });
  }
}

final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) => WorkoutRepository(ref.watch(databaseProvider)));

final activePlanProvider = StreamProvider<WorkoutPlan?>((ref) => ref.watch(workoutRepositoryProvider).watchActivePlan());

final pendingPlansProvider =
    StreamProvider<List<WorkoutPlan>>((ref) => ref.watch(workoutRepositoryProvider).watchPendingPlans());

final planProvider =
    StreamProvider.autoDispose.family<WorkoutPlan?, int>((ref, id) => ref.watch(workoutRepositoryProvider).watchPlan(id));

final planDaysProvider =
    StreamProvider.autoDispose.family<List<PlanDay>, int>((ref, planId) => ref.watch(workoutRepositoryProvider).watchDays(planId));

final planDayProvider =
    StreamProvider.autoDispose.family<PlanDay?, int>((ref, id) => ref.watch(workoutRepositoryProvider).watchDay(id));

final planDayExercisesProvider = StreamProvider.autoDispose.family<List<PlanExerciseItem>, int>(
    (ref, dayId) => ref.watch(workoutRepositoryProvider).watchDayExercises(dayId));

final planExerciseCountsProvider = StreamProvider.autoDispose.family<Map<int, int>, int>(
    (ref, planId) => ref.watch(workoutRepositoryProvider).watchExerciseCounts(planId));

final sessionProvider =
    StreamProvider.autoDispose.family<WorkoutSession?, int>((ref, id) => ref.watch(workoutRepositoryProvider).watchSession(id));

final sessionSetsProvider = StreamProvider.autoDispose.family<List<SetLog>, int>(
    (ref, id) => ref.watch(workoutRepositoryProvider).watchSessionSets(id));

final sessionCardioProvider =
    StreamProvider.autoDispose.family<List<CardioLog>, int>((ref, id) => ref.watch(workoutRepositoryProvider).watchCardio(id));

final sessionNotesProvider = StreamProvider.autoDispose.family<List<SessionExerciseNote>, int>(
    (ref, id) => ref.watch(workoutRepositoryProvider).watchExerciseNotes(id));

final workoutHistoryProvider =
    StreamProvider.autoDispose<List<SessionListItem>>((ref) => ref.watch(workoutRepositoryProvider).watchHistory());

/// Sessions of the 7-day window starting at the given local day, keyed by day.
final weekSessionsProvider = StreamProvider.autoDispose.family<Map<DateTime, WorkoutSession>, DateTime>(
    (ref, start) => ref.watch(workoutRepositoryProvider).watchWeekSessions(start));

/// First day of the displayed week containing [now] for a weekday [order] (see weekOrder()).
DateTime displayWeekStart(DateTime now, List<int> order) {
  final d = dayOf(now);
  return DateTime(d.year, d.month, d.day - (d.weekday - order.first + 7) % 7);
}
