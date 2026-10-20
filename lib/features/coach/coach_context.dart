import 'dart:convert';

import 'package:drift/drift.dart';

import '../../ai/ai_service.dart';
import '../../core/calc/strength_calc.dart';
import '../../core/providers.dart';
import '../../core/utils/context_ext.dart' show dayOf, ymd, fmtNum;
import '../../data/repositories/exercise_repository.dart';
import '../../data/repositories/profile_repository.dart';
import 'coach_persona.dart';

const _weekdaysEn = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
String weekdayEn(int weekday) => _weekdaysEn[(weekday - 1).clamp(0, 6)];

/// System prompt split in a cacheable [stable] part (persona + profile + plan)
/// and a [dynamic] part (date, last days of logs, memories, pending proposals).
class CoachContext {
  final String stable;
  final String dynamic;
  const CoachContext(this.stable, this.dynamic);

  List<Map<String, dynamic>> get systemBlocks => AiService.systemBlocks(stable, dynamic: dynamic);

  /// Rough token estimate (≈ 4 chars/token for English, ~2.5 for Arabic).
  int get approxTokens => ((stable.length + dynamic.length) / 3).round();
}

/// Builds the compact context summary sent with every coach request.
/// Pure DB reads – no providers – so it works in tests and background isolates.
class CoachContextBuilder {
  final AppDatabase db;
  final String lang;
  final DateTime now;
  CoachContextBuilder(this.db, {required this.lang, DateTime? now}) : now = now ?? DateTime.now();

  DateTime get _today => dayOf(now);

  Future<CoachContext> build({int days = 7}) async {
    final stable = await buildStable();
    final dynamicPart = await buildDynamic(days: days);
    return CoachContext(stable, dynamicPart);
  }

  // ---------------------------------------------------------------- stable

  Future<String> buildStable() async {
    final b = StringBuffer(coachPersona(lang));
    b.writeln();
    b.writeln();
    b.writeln('## USER PROFILE');
    final profile = await ProfileRepository(db).get();
    b.writeln(profile == null ? '(no profile yet)' : profile.toPromptSummary());
    b.writeln();
    b.writeln('## ACTIVE WORKOUT PLAN');
    b.write(await planSummary());
    return b.toString().trimRight();
  }

  /// Active plan, compact: one line per day with plan-exercise ids for tools.
  Future<String> planSummary() async {
    final plan = await (db.select(db.workoutPlans)
          ..where((t) => t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.desc(t.activatedAt), (t) => OrderingTerm.desc(t.id)])
          ..limit(1))
        .getSingleOrNull();
    if (plan == null) return '(no active plan)\n';
    final days = await (db.select(db.planDays)
          ..where((t) => t.planId.equals(plan.id))
          ..orderBy([(t) => OrderingTerm.asc(t.orderIndex), (t) => OrderingTerm.asc(t.id)]))
        .get();
    final dayIds = days.map((d) => d.id).toList();
    final pes = dayIds.isEmpty
        ? <PlanExercise>[]
        : await (db.select(db.planExercises)
              ..where((t) => t.planDayId.isIn(dayIds))
              ..orderBy([(t) => OrderingTerm.asc(t.orderIndex), (t) => OrderingTerm.asc(t.id)]))
            .get();
    final names = await _exerciseNames(pes.map((e) => e.exerciseId));
    final b = StringBuffer('Plan "${plan.name}" (planId ${plan.id}'
        '${plan.deloadEveryWeeks != null ? ', deload every ${plan.deloadEveryWeeks} weeks' : ''})\n');
    for (final d in days) {
      final wd = d.weekday != null ? weekdayEn(d.weekday!) : '-';
      if (d.isRest) {
        b.writeln('- planDayId ${d.id} $wd "${d.name}": rest');
        continue;
      }
      final items = pes.where((e) => e.planDayId == d.id).map((e) {
        final parts = <String>[
          '[pe ${e.id}] ${names[e.exerciseId] ?? e.exerciseId} (${e.exerciseId})',
          '${e.sets}x${e.repMin == e.repMax ? e.repMin : '${e.repMin}-${e.repMax}'}',
          if (e.suggestedWeightKg != null) '${fmtNum(e.suggestedWeightKg!)}kg',
          if (e.targetRpe != null) 'RPE${fmtNum(e.targetRpe!)}',
          'rest${e.restSeconds}s',
        ];
        return parts.join(' ');
      }).join('; ');
      b.writeln('- planDayId ${d.id} $wd "${d.name}"${d.focus != null ? ' (${d.focus})' : ''}: $items');
    }
    return b.toString();
  }

  // --------------------------------------------------------------- dynamic

  Future<String> buildDynamic({int days = 7, DateTime? end}) async {
    final endDay = dayOf(end ?? now);
    final start = endDay.subtract(Duration(days: days - 1));
    final b = StringBuffer();
    b.writeln('## NOW');
    b.writeln(await todayLine());
    b.writeln();
    b.writeln('## TRAINING ${ymd(start)} → ${ymd(endDay)}');
    b.write(await trainingSummary(start, endDay));
    b.writeln();
    b.writeln('## NUTRITION (eaten / target per day)');
    b.write(await nutritionSummary(start, endDay));
    b.writeln();
    b.writeln('## BODY WEIGHT');
    b.writeln(await weightSummary(endDay));
    b.writeln();
    b.writeln('## SLEEP & RECOVERY');
    b.write(await sleepRecoverySummary(start, endDay));
    b.writeln();
    b.writeln('## PERSONAL RECORDS (best estimated 1RM, recently trained)');
    b.write(await prSummary());
    b.writeln();
    b.writeln('## COACH MEMORY (facts saved from earlier chats)');
    b.write(await memorySummary());
    b.writeln();
    b.writeln('## PENDING PROPOSALS (waiting for user approval)');
    b.write(await pendingProposalsSummary());
    return b.toString().trimRight();
  }

  Future<String> todayLine() async {
    final t = _today;
    final parts = <String>['Today ${ymd(t)} (${weekdayEn(t.weekday)})'];
    final day = await todayPlanDay();
    if (day == null) {
      parts.add('no active plan day today');
    } else if (day.isRest) {
      parts.add('planned: rest day');
    } else {
      parts.add('planned: planDayId ${day.id} "${day.name}"');
    }
    final session = await (db.select(db.workoutSessions)
          ..where((s) => s.date.equals(t))
          ..orderBy([(s) => OrderingTerm.desc(s.id)])
          ..limit(1))
        .getSingleOrNull();
    parts.add(session == null ? 'no session yet' : 'session status ${session.status}');
    final water = await _sumWater(t, t.add(const Duration(days: 1)));
    final profile = await ProfileRepository(db).get();
    parts.add('water ${water}ml${profile?.waterGoalMl != null ? '/${profile!.waterGoalMl}ml' : ''}');
    return '${parts.join('; ')}.';
  }

  /// The active plan's day for today's weekday (null when no plan / not scheduled).
  Future<PlanDay?> todayPlanDay() async {
    final plan = await (db.select(db.workoutPlans)
          ..where((t) => t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.desc(t.activatedAt), (t) => OrderingTerm.desc(t.id)])
          ..limit(1))
        .getSingleOrNull();
    if (plan == null) return null;
    return (db.select(db.planDays)
          ..where((d) => d.planId.equals(plan.id) & d.weekday.equals(_today.weekday))
          ..limit(1))
        .getSingleOrNull();
  }

  /// Sessions in [start, end] with per-exercise condensed sets.
  Future<String> trainingSummary(DateTime start, DateTime end) async {
    final sessions = await (db.select(db.workoutSessions)
          ..where((s) => s.date.isBetweenValues(start, end))
          ..orderBy([(s) => OrderingTerm.asc(s.date), (s) => OrderingTerm.asc(s.id)]))
        .get();
    final cardio = await (db.select(db.cardioLogs)
          ..where((c) => c.date.isBetweenValues(start, end.add(const Duration(days: 1))))
          ..orderBy([(c) => OrderingTerm.asc(c.date)]))
        .get();
    if (sessions.isEmpty && cardio.isEmpty) return '(no workouts logged)\n';
    final ids = sessions.map((s) => s.id).toList();
    final sets = ids.isEmpty
        ? <SetLog>[]
        : await (db.select(db.setLogs)
              ..where((s) => s.sessionId.isIn(ids))
              ..orderBy([(s) => OrderingTerm.asc(s.setIndex), (s) => OrderingTerm.asc(s.id)]))
            .get();
    final names = await _exerciseNames(sets.map((s) => s.exerciseId));
    final b = StringBuffer();
    for (final s in sessions) {
      final head = <String>[
        ymd(s.date),
        weekdayEn(s.date.weekday),
        if (s.name != null) '"${s.name}"',
        s.status,
        if (s.isDeload) 'deload',
        if (s.startedAt != null && s.endedAt != null) '${s.endedAt!.difference(s.startedAt!).inMinutes}min',
      ];
      final mine = sets.where((x) => x.sessionId == s.id).toList();
      final vol = s.totalVolume ?? mine.where((x) => x.setType != 'warmup').fold<double>(0, (a, x) => a + x.weightKg * x.reps);
      if (mine.isNotEmpty || s.totalVolume != null) head.add('vol ${vol.round()}kg');
      b.writeln('- ${head.join(' ')}');
      for (final c in condenseSets(mine)) {
        b.writeln('  • ${names[c.exerciseId] ?? c.exerciseId}: ${c.describe()}');
      }
      if (s.notes != null && s.notes!.trim().isNotEmpty) b.writeln('  note: ${_short(s.notes!, 120)}');
    }
    for (final c in cardio) {
      b.writeln('- ${ymd(c.date)} cardio ${c.type} ${fmtNum(c.durationMin)}min'
          '${c.calories != null ? ' ${c.calories!.round()}kcal' : ''}');
    }
    return b.toString();
  }

  Future<String> nutritionSummary(DateTime start, DateTime end) async {
    final profile = await ProfileRepository(db).get();
    final logs = await (db.select(db.mealLogs)..where((m) => m.date.isBetweenValues(start, end))).get();
    final b = StringBuffer();
    var anyLogged = false;
    for (var d = start; !d.isAfter(end); d = DateTime(d.year, d.month, d.day + 1)) {
      final dayLogs = logs.where((m) => dayOf(m.date) == d).toList();
      if (dayLogs.isEmpty) {
        b.writeln('- ${ymd(d)}: no meals logged');
        continue;
      }
      anyLogged = true;
      double sum(double Function(MealLog) f) => dayLogs.fold(0.0, (a, m) => a + f(m));
      String t(num? v) => v == null ? '?' : '${v.round()}';
      b.writeln('- ${ymd(d)}: ${sum((m) => m.calories).round()}/${t(profile?.caloriesFor(d))} kcal, '
          'P ${sum((m) => m.protein).round()}/${t(profile?.proteinG)}, '
          'C ${sum((m) => m.carbs).round()}/${t(profile?.carbsFor(d))}, '
          'F ${sum((m) => m.fat).round()}/${t(profile?.fatG)} (${dayLogs.length} meals)');
    }
    if (!anyLogged) return '(no meals logged in this period)\n';
    return b.toString();
  }

  Future<String> weightSummary(DateTime end) async {
    final from = end.subtract(const Duration(days: 20));
    final rows = await (db.select(db.bodyMetrics)
          ..where((m) => m.date.isBetweenValues(from, end.add(const Duration(days: 1))) & m.weightKg.isNotNull())
          ..orderBy([(m) => OrderingTerm.asc(m.date)]))
        .get();
    if (rows.isEmpty) return '(no weigh-ins in the last 3 weeks)';
    final latest = rows.last;
    double? avg(DateTime a, DateTime b) {
      final w = rows.where((r) => !dayOf(r.date).isBefore(a) && !dayOf(r.date).isAfter(b)).map((r) => r.weightKg!).toList();
      return w.isEmpty ? null : w.reduce((x, y) => x + y) / w.length;
    }

    final cur = avg(end.subtract(const Duration(days: 6)), end);
    final prev = avg(end.subtract(const Duration(days: 13)), end.subtract(const Duration(days: 7)));
    final parts = <String>['latest ${fmtNum(latest.weightKg!)}kg (${ymd(latest.date)})'];
    if (cur != null) parts.add('7-day avg ${cur.toStringAsFixed(1)}');
    if (prev != null) parts.add('previous 7-day avg ${prev.toStringAsFixed(1)}');
    if (cur != null && prev != null) {
      final diff = cur - prev;
      parts.add('change ${diff >= 0 ? '+' : ''}${diff.toStringAsFixed(1)}kg/week');
    }
    final m = rows.lastWhere((r) => r.waistCm != null, orElse: () => latest);
    if (m.waistCm != null) parts.add('waist ${fmtNum(m.waistCm!)}cm (${ymd(m.date)})');
    return parts.join(', ');
  }

  Future<String> sleepRecoverySummary(DateTime start, DateTime end) async {
    final sleeps = await (db.select(db.sleepLogs)..where((s) => s.date.isBetweenValues(start, end))).get();
    final health = await (db.select(db.healthDaily)..where((h) => h.date.isBetweenValues(start, end))).get();
    if (sleeps.isEmpty && health.isEmpty) return '(no sleep or recovery data)\n';
    final b = StringBuffer();
    for (var d = start; !d.isAfter(end); d = DateTime(d.year, d.month, d.day + 1)) {
      final s = sleeps.where((x) => dayOf(x.date) == d).toList();
      final h = health.where((x) => dayOf(x.date) == d).firstOrNull;
      final parts = <String>[];
      if (s.isNotEmpty) {
        final mins = s.fold<int>(0, (a, x) => a + x.durationMin);
        final q = s.map((x) => x.quality).whereType<int>().firstOrNull;
        final deep = s.map((x) => x.deepMin).whereType<int>().firstOrNull;
        parts.add('sleep ${(mins / 60).toStringAsFixed(1)}h${q != null ? ' q$q/5' : ''}${deep != null ? ' deep${deep}m' : ''}');
      }
      if (h != null) {
        if (h.recoveryScore != null) parts.add('recovery ${h.recoveryScore}');
        if (h.hrv != null) parts.add('HRV ${h.hrv!.round()}');
        if (h.restingHr != null) parts.add('RHR ${h.restingHr!.round()}');
        if (h.steps != null) parts.add('steps ${h.steps}');
      }
      if (parts.isNotEmpty) b.writeln('- ${ymd(d)}: ${parts.join(', ')}');
    }
    return b.isEmpty ? '(no sleep or recovery data)\n' : b.toString();
  }

  /// Best e1RM per exercise among the 12 most recently trained exercises.
  Future<String> prSummary({int limit = 12}) async {
    final since = now.subtract(const Duration(days: 365));
    final rows = await (db.select(db.setLogs)
          ..where((s) => s.createdAt.isBiggerOrEqualValue(since) & s.setType.equals('warmup').not()))
        .get();
    if (rows.isEmpty) return '(no sets logged yet)\n';
    final byEx = <String, List<SetLog>>{};
    for (final r in rows) {
      byEx.putIfAbsent(r.exerciseId, () => []).add(r);
    }
    final entries = byEx.entries.toList()
      ..sort((a, b) => b.value.map((x) => x.createdAt).reduce(_maxDate).compareTo(a.value.map((x) => x.createdAt).reduce(_maxDate)));
    final names = await _exerciseNames(entries.take(limit).map((e) => e.key));
    final b = StringBuffer();
    for (final e in entries.take(limit)) {
      final best = e.value.reduce((a, c) =>
          StrengthCalc.epley1Rm(c.weightKg, c.reps) > StrengthCalc.epley1Rm(a.weightKg, a.reps) ? c : a);
      final heaviest = e.value.map((x) => x.weightKg).reduce((a, c) => a > c ? a : c);
      b.writeln('- ${names[e.key] ?? e.key}: ${fmtNum(best.weightKg)}x${best.reps} '
          '(e1RM ${StrengthCalc.epley1Rm(best.weightKg, best.reps).round()}) on ${ymd(best.createdAt)}, '
          'heaviest ${fmtNum(heaviest)}kg');
    }
    return b.toString();
  }

  Future<String> memorySummary({int limit = 40}) async {
    final mems = await (db.select(db.coachMemories)
          ..orderBy([(m) => OrderingTerm.desc(m.createdAt), (m) => OrderingTerm.desc(m.id)])
          ..limit(limit))
        .get();
    if (mems.isEmpty) return '(none)\n';
    return '${mems.reversed.map((m) => '- ${_short(m.content, 200)}').join('\n')}\n';
  }

  Future<String> pendingProposalsSummary() async {
    final ps = await (db.select(db.coachProposals)
          ..where((p) => p.status.equals('pending'))
          ..orderBy([(p) => OrderingTerm.desc(p.createdAt)])
          ..limit(10))
        .get();
    if (ps.isEmpty) return '(none)\n';
    return '${ps.map((p) => '- #${p.id} ${p.type}: ${_short(p.title, 100)}').join('\n')}\n';
  }

  // --------------------------------------------------------------- helpers

  Future<Map<String, String>> _exerciseNames(Iterable<String> ids) async {
    final set = ids.toSet();
    if (set.isEmpty) return {};
    final ex = await ExerciseRepository(db).byIds(set);
    return {for (final e in ex) e.id: e.name(lang)};
  }

  Future<int> _sumWater(DateTime from, DateTime to) async {
    final rows = await (db.select(db.waterLogs)
          ..where((w) => w.timestamp.isBiggerOrEqualValue(from) & w.timestamp.isSmallerThanValue(to)))
        .get();
    return rows.fold<int>(0, (a, w) => a + w.amountMl);
  }

  static DateTime _maxDate(DateTime a, DateTime b) => a.isAfter(b) ? a : b;

  static String _short(String s, int max) {
    final t = s.replaceAll('\n', ' ').trim();
    return t.length <= max ? t : '${t.substring(0, max)}…';
  }
}

/// Condensed per-exercise view of a session's sets.
class CondensedExercise {
  final String exerciseId;
  final int workingSets;
  final SetLog top; // heaviest working set (ties → more reps)
  final double volume;
  final List<String> prTypes;
  final List<String> repsList;
  const CondensedExercise({
    required this.exerciseId,
    required this.workingSets,
    required this.top,
    required this.volume,
    required this.prTypes,
    required this.repsList,
  });

  String describe() {
    final rpe = top.rpe != null ? ' @${fmtNum(top.rpe!)}' : '';
    final pr = prTypes.isEmpty ? '' : ', PR(${prTypes.join('/')})';
    return '$workingSets sets [${repsList.join(', ')}], top ${fmtNum(top.weightKg)}x${top.reps}$rpe, '
        'vol ${volume.round()}$pr';
  }
}

/// Groups sets by exercise (in first-seen order), ignoring warm-ups.
List<CondensedExercise> condenseSets(List<SetLog> sets) {
  final order = <String>[];
  final by = <String, List<SetLog>>{};
  for (final s in sets) {
    if (s.setType == 'warmup') continue;
    if (!by.containsKey(s.exerciseId)) order.add(s.exerciseId);
    by.putIfAbsent(s.exerciseId, () => []).add(s);
  }
  return [
    for (final id in order)
      () {
        final list = by[id]!;
        final top = list.reduce((a, b) => b.weightKg > a.weightKg || (b.weightKg == a.weightKg && b.reps > a.reps) ? b : a);
        final prs = <String>{};
        for (final s in list.where((x) => x.isPr)) {
          prs.addAll((s.prTypes ?? 'pr').split(',').map((e) => e.trim()).where((e) => e.isNotEmpty));
        }
        return CondensedExercise(
          exerciseId: id,
          workingSets: list.length,
          top: top,
          volume: list.fold(0.0, (a, s) => a + s.weightKg * s.reps),
          prTypes: prs.toList(),
          repsList: list.map((s) => '${fmtNum(s.weightKg)}x${s.reps}${s.setType == 'drop' ? 'd' : s.setType == 'failure' ? 'f' : ''}').toList(),
        );
      }(),
  ];
}

/// Decodes a JSON object column safely.
Map<String, dynamic> decodeJsonMap(String? s) {
  if (s == null || s.isEmpty) return {};
  try {
    final v = jsonDecode(s);
    return v is Map<String, dynamic> ? v : {};
  } catch (_) {
    return {};
  }
}
