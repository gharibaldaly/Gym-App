import 'dart:async';
import 'dart:convert';
import 'dart:ui' show Locale;

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../ai/ai_queue.dart';
import '../../ai/ai_service.dart';
import '../../core/calc/plateau.dart';
import '../../core/calc/progression.dart';
import '../../core/calc/strength_calc.dart';
import '../../core/providers.dart';
import '../../core/utils/context_ext.dart' show dayOf, ymd, fmtNum;
import '../../data/repositories/exercise_repository.dart';
import '../../data/repositories/profile_repository.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../services/notifications/notification_service.dart';
import 'coach_context.dart';
import 'coach_memory.dart';
import 'coach_persona.dart';
import 'coach_proposals.dart';
import 'coach_repository.dart';

/// Offline-queue job keys owned by the coach.
class CoachJobs {
  static const morning = 'coach_morning';
  static const workoutSummary = 'workout_summary';
  static const plateau = 'coach_plateau';
  static const weekly = 'coach_weekly';
}

/// Recovery score below which the coach proposes a lighter session.
const lowRecoveryThreshold = 40;

// ------------------------------------------------------------------ pure due logic

/// Morning message is due once per day, after the user's wake time (default 07:00).
bool isMorningDue({required DateTime now, String? wakeTime, String? lastSent}) {
  if (lastSent == ymd(now)) return false;
  final parts = (wakeTime ?? '').split(':');
  final h = parts.length == 2 ? int.tryParse(parts[0]) : null;
  final m = parts.length == 2 ? int.tryParse(parts[1]) : null;
  final wake = DateTime(now.year, now.month, now.day, h ?? 7, m ?? 0);
  return !now.isBefore(wake);
}

/// The Friday (local midnight) ending the week whose report is due, or null.
/// A week's report becomes due on Friday at 18:00 (or on the first check after).
DateTime? dueWeeklyReportEnd({required DateTime now, String? lastSent}) {
  final d = dayOf(now);
  final back = (d.weekday - DateTime.friday + 7) % 7;
  var fri = DateTime(d.year, d.month, d.day - back);
  if (now.isBefore(DateTime(fri.year, fri.month, fri.day, 18))) {
    fri = DateTime(fri.year, fri.month, fri.day - 7);
  }
  if (lastSent != null && lastSent.compareTo(ymd(fri)) >= 0) return null;
  return fri;
}

/// True when a low-recovery proposal should be created for today.
bool shouldProposeRecoveryAdjust({
  required int? recoveryScore,
  required bool isTrainingDay,
  required bool alreadyProposed,
  required bool sessionDone,
}) =>
    recoveryScore != null &&
    recoveryScore < lowRecoveryThreshold &&
    isTrainingDay &&
    !alreadyProposed &&
    !sessionDone;

/// Newest-first assistant messages → the one for the Today card
/// (today's morning message wins, else the latest).
CoachMessage? pickLatestCoachMessage(List<CoachMessage> newestFirst, DateTime now) {
  final usable = newestFirst.where((m) => m.role == 'assistant' && m.kind != CoachKinds.offlineNotice).toList();
  if (usable.isEmpty) return null;
  final today = dayOf(now);
  final morning = usable.where((m) => m.kind == CoachKinds.morning && dayOf(m.createdAt) == today).firstOrNull;
  return morning ?? usable.first;
}

/// Markdown-ish text → short plain preview for notifications.
String plainPreview(String md, {int max = 180}) {
  final t = md
      .replaceAll('**', '')
      .replaceAll(RegExp(r'^\s*[-•*]\s+', multiLine: true), '• ')
      .replaceAll(RegExp(r'^#+\s*', multiLine: true), '')
      .replaceAll(RegExp(r'\s*\n+\s*'), ' ')
      .trim();
  return t.length <= max ? t : '${t.substring(0, max - 1)}…';
}

// ------------------------------------------------------------------ service

/// Proactive coach messages: morning, workout summary, plateau, weekly report.
class CoachInitiatives {
  final Ref ref;
  CoachInitiatives(this.ref);

  AppDatabase get _db => ref.read(databaseProvider);
  CoachRepository get _repo => CoachRepository(_db);
  DateTime _now() {
    try {
      return ref.read(coachClockProvider)();
    } catch (_) {
      return DateTime.now();
    }
  }

  Future<String> _lang() async {
    String? lang;
    try {
      lang = ref.read(localeProvider);
    } catch (_) {
      lang = null;
    }
    if (lang != null) return lang;
    {
      final p = await ProfileRepository(_db).get();
      return p?.language ?? 'ar';
    }
  }

  AppLocalizations _l(String lang) => lookupAppLocalizations(Locale(lang == 'ar' ? 'ar' : 'en'));

  // ------------------------------------------------------------ entry points

  /// Called right after a workout is finished (queues the AI summary if offline).
  Future<void> onWorkoutFinished(int sessionId) async {
    try {
      for (final exId in await detectPlateaus(sessionId)) {
        await explainPlateau(exId);
      }
    } catch (e) {
      debugPrint('coach plateau detection failed: $e');
    }
    try {
      await _enqueueOnce(CoachJobs.workoutSummary, {'sessionId': sessionId});
    } catch (e) {
      debugPrint('coach workout summary enqueue failed: $e');
    }
  }

  /// Called when the local rule detects a plateau for [exerciseId].
  Future<void> explainPlateau(String exerciseId) async {
    try {
      final since = _now().subtract(const Duration(days: 21));
      final recent = await (_db.select(_db.coachMessages)
            ..where((m) => m.kind.equals(CoachKinds.plateau) & m.createdAt.isBiggerOrEqualValue(since)))
          .get();
      if (recent.any((m) => m.meta['exerciseId'] == exerciseId)) return;
      await _enqueueOnce(CoachJobs.plateau, {'exerciseId': exerciseId});
    } catch (e) {
      debugPrint('coach explainPlateau failed: $e');
    }
  }

  /// Morning message + weekly report when due. Safe to call often (on open / background).
  /// Works without a BuildContext and never throws.
  Future<void> runScheduledChecks() async {
    Future<void> guard(String name, Future<void> Function() f) async {
      try {
        await f();
      } catch (e, st) {
        debugPrint('coach check $name failed: $e\n$st');
      }
    }

    await guard('recovery', checkRecovery);
    await guard('morning', checkMorning);
    await guard('weekly', checkWeekly);
    await guard('memory', () => ref.read(coachMemoryServiceProvider).scheduleExtraction());
  }

  // ------------------------------------------------------------ scheduled checks

  /// Creates a 'recovery_adjust' proposal (local, no AI) when today's recovery is low.
  Future<void> checkRecovery() async {
    final now = _now();
    final today = dayOf(now);
    final health = await (_db.select(_db.healthDaily)..where((h) => h.date.equals(today))).getSingleOrNull();
    final lang = await _lang();
    final builder = CoachContextBuilder(_db, lang: lang, now: now);
    final day = await builder.todayPlanDay();
    final proposals = await (_db.select(_db.coachProposals)
          ..where((p) => p.type.equals(ProposalTypes.recoveryAdjust)))
        .get();
    final already = proposals.any((p) => p.payload['date'] == ymd(today));
    final sessions = await (_db.select(_db.workoutSessions)
          ..where((s) => s.date.equals(today) & s.status.isIn(['completed', 'partial'])))
        .get();
    final score = health?.recoveryScore;
    if (!shouldProposeRecoveryAdjust(
      recoveryScore: score,
      isTrainingDay: day != null && !day.isRest,
      alreadyProposed: already,
      sessionDone: sessions.isNotEmpty,
    )) {
      return;
    }
    final l = _l(lang);
    final text = l.coachRecoveryMessage(score!);
    final msgId = await _repo.addMessage(
      role: 'assistant',
      content: text,
      kind: CoachKinds.recovery,
      meta: {'date': ymd(today), 'recoveryScore': score},
    );
    await _db.into(_db.coachProposals).insert(CoachProposalsCompanion.insert(
          type: ProposalTypes.recoveryAdjust,
          title: l.coachPropRecoveryTitle(score),
          description: Value(l.coachPropRecoveryDesc),
          payloadJson: jsonEncode({
            'date': ymd(today),
            'weightFactor': 0.9,
            'setsDelta': -1,
            'recoveryScore': score,
          }),
          messageId: Value(msgId),
          createdAt: Value(now),
        ));
    await _notify(l.coachNotifRecovery, text);
  }

  Future<void> checkMorning() async {
    final prefs = ref.read(sharedPrefsProvider);
    final now = _now();
    final profile = await ProfileRepository(_db).get();
    if (profile == null || !profile.onboardingComplete) return;
    if (!isMorningDue(now: now, wakeTime: profile.wakeTime, lastSent: prefs.getString(SettingsKeys.lastMorningMessage))) {
      return;
    }
    if (!await ref.read(aiServiceProvider).hasKey) return; // retried on the next check once a key exists
    await prefs.setString(SettingsKeys.lastMorningMessage, ymd(now));
    await _enqueueOnce(CoachJobs.morning, {'date': ymd(now)});
  }

  Future<void> checkWeekly() async {
    final prefs = ref.read(sharedPrefsProvider);
    final now = _now();
    final profile = await ProfileRepository(_db).get();
    if (profile == null || !profile.onboardingComplete) return;
    final end = dueWeeklyReportEnd(now: now, lastSent: prefs.getString(SettingsKeys.lastWeeklyReport));
    if (end == null) return;
    if (!await _hasWeekData(end)) {
      await prefs.setString(SettingsKeys.lastWeeklyReport, ymd(end)); // nothing to report
      return;
    }
    if (!await ref.read(aiServiceProvider).hasKey) return;
    await prefs.setString(SettingsKeys.lastWeeklyReport, ymd(end));
    await _enqueueOnce(CoachJobs.weekly, {'weekEnd': ymd(end)});
  }

  Future<bool> _hasWeekData(DateTime end) async {
    final start = DateTime(end.year, end.month, end.day - 6);
    final s = await (_db.select(_db.workoutSessions)
          ..where((t) => t.date.isBetweenValues(start, end))
          ..limit(1))
        .get();
    if (s.isNotEmpty) return true;
    final m = await (_db.select(_db.mealLogs)
          ..where((t) => t.date.isBetweenValues(start, end))
          ..limit(1))
        .get();
    if (m.isNotEmpty) return true;
    final b = await (_db.select(_db.bodyMetrics)
          ..where((t) => t.date.isBetweenValues(start, end.add(const Duration(days: 1))))
          ..limit(1))
        .get();
    return b.isNotEmpty;
  }

  // ------------------------------------------------------------ queue jobs

  Future<void> runMorningJob(Map<String, dynamic> payload) async {
    final now = _now();
    final today = dayOf(now);
    if (payload['date'] != ymd(today)) return; // stale – a morning message is only useful that day
    final existing = await (_db.select(_db.coachMessages)
          ..where((m) => m.kind.equals(CoachKinds.morning) & m.createdAt.isBiggerOrEqualValue(today)))
        .get();
    if (existing.isNotEmpty) return;
    final lang = await _lang();
    final builder = CoachContextBuilder(_db, lang: lang, now: now);
    final ctx = await builder.build();
    final health = await (_db.select(_db.healthDaily)..where((h) => h.date.equals(today))).getSingleOrNull();
    final pendingRecovery = await (_db.select(_db.coachProposals)
          ..where((p) => p.type.equals(ProposalTypes.recoveryAdjust) & p.status.equals('pending')))
        .get();
    final hasRecoveryProposal = pendingRecovery.any((p) => p.payload['date'] == ymd(today));
    final day = await builder.todayPlanDay();
    final prompt = '''
Write this morning's message to the user (it is shown as a notification and in the chat).
- Today's plan: ${day == null ? 'no plan day' : day.isRest ? 'rest day' : 'planDayId ${day.id} "${day.name}" (see ACTIVE WORKOUT PLAN)'}. Name the key lifts with today's targets, or give rest-day guidance.
- Recovery score today: ${health?.recoveryScore ?? 'no data'}${health?.recoveryScore != null ? '/100' : ''}. Say what it means for today.
${hasRecoveryProposal ? '- A lighter-session proposal (−10% weight, one set less) is already waiting for approval; mention it.\n' : ''}- Suggest concrete adjustments if the numbers call for it (sleep, protein, water, volume). Mention yesterday's misses if any.
Max 110 words. ${replyLanguageLine(lang)}''';
    final text = await ref.read(aiServiceProvider).text(
          feature: AiFeature.morningMessage,
          system: ctx.systemBlocks,
          prompt: prompt,
          maxTokens: 3000,
        );
    if (text.trim().isEmpty) return;
    await _repo.addMessage(
      role: 'assistant',
      content: text.trim(),
      kind: CoachKinds.morning,
      meta: {'date': ymd(today), 'recoveryScore': health?.recoveryScore},
    );
    await _notify(_l(lang).coachNotifMorning, text);
  }

  Future<void> runWorkoutSummaryJob(Map<String, dynamic> payload) async {
    final sessionId = (payload['sessionId'] as num?)?.toInt();
    if (sessionId == null) return;
    final session = await (_db.select(_db.workoutSessions)..where((s) => s.id.equals(sessionId))).getSingleOrNull();
    if (session == null || (session.aiSummary?.trim().isNotEmpty ?? false)) return;
    final lang = await _lang();
    final report = await workoutSessionReport(_db, session, lang: lang);
    if (report == null) return; // no sets logged
    final ctx = await CoachContextBuilder(_db, lang: lang, now: _now()).build();
    final prompt = '''
The user just finished this workout. Write the post-workout summary.
$report
Structure (short bullets, real numbers only):
**What improved** – compared with the previous session.
**What's weak** – stalls, dropped reps, skipped exercises, too-high RPE.
**Target next time** – per main lift. Review the local progression suggestions above: keep them or adjust with a reason.
Max 150 words. ${replyLanguageLine(lang)}''';
    final text = (await ref.read(aiServiceProvider).text(
              feature: AiFeature.workoutSummary,
              system: ctx.systemBlocks,
              prompt: prompt,
              maxTokens: 4000,
            ))
        .trim();
    if (text.isEmpty) return;
    await (_db.update(_db.workoutSessions)..where((s) => s.id.equals(sessionId)))
        .write(WorkoutSessionsCompanion(aiSummary: Value(text)));
    await _repo.addMessage(
      role: 'assistant',
      content: text,
      kind: CoachKinds.workoutSummary,
      meta: {'sessionId': sessionId, 'date': ymd(session.date)},
    );
    await _notify(_l(lang).coachNotifWorkout, text);
  }

  Future<void> runPlateauJob(Map<String, dynamic> payload) async {
    final exId = payload['exerciseId'] as String?;
    if (exId == null) return;
    final exRepo = ExerciseRepository(_db);
    final ex = await exRepo.byId(exId);
    if (ex == null) return;
    final lang = await _lang();
    final history = await exerciseSessionBests(_db, exId, limit: 6);
    final profile = await ProfileRepository(_db).get();
    final alternatives = await exRepo.localAlternatives(ex, limit: 3, location: profile?.location);
    final pe = await _activePlanExercise(exId);
    final ctx = await CoachContextBuilder(_db, lang: lang, now: _now()).build();
    final prompt = '''
Plateau detected (local rule: no e1RM improvement for 3 sessions in a row) on "${ex.nameEn}" (id $exId, ${ex.equipment ?? '-'}).
Recent sessions (oldest first):
${history.map((h) => '- ${ymd(h.date)}: best ${fmtNum(h.top.weightKg)}x${h.top.reps}${h.top.rpe != null ? ' @${fmtNum(h.top.rpe!)}' : ''}, e1RM ${h.bestE1rm.round()}, ${h.sets} working sets').join('\n')}
Alternatives from the library: ${alternatives.isEmpty ? 'none' : alternatives.map((a) => '${a.id} (${a.nameEn}, ${a.equipment ?? '-'})').join('; ')}.
${pe == null ? 'The exercise is not in the active plan.' : 'It is plan exercise pe ${pe.id}.'}

In "message": explain the most likely cause using the numbers in the context (sleep, calories/protein, volume, rep range, RPE, frequency) and give ONE concrete fix: change the rep scheme, switch to an alternative, or deload. Max 120 words. ${replyLanguageLine(lang)}
Set "swapToExerciseId" to one of the alternative ids only if switching is your fix${pe == null ? ' (must be null here because it is not in the plan)' : ''}; otherwise null.''';
    final res = await ref.read(aiServiceProvider).structured(
      feature: AiFeature.plateau,
      system: ctx.systemBlocks,
      prompt: prompt,
      maxTokens: 3000,
      schema: {
        'type': 'object',
        'properties': {
          'message': {'type': 'string'},
          'swapToExerciseId': {
            'type': ['string', 'null'],
          },
        },
        'required': ['message', 'swapToExerciseId'],
      },
    );
    final text = (res['message'] as String).trim();
    if (text.isEmpty) return;
    final l = _l(lang);
    final msgId = await _repo.addMessage(
      role: 'assistant',
      content: text,
      kind: CoachKinds.plateau,
      meta: {'exerciseId': exId},
    );
    final swapTo = res['swapToExerciseId'] as String?;
    final alt = alternatives.where((a) => a.id == swapTo).firstOrNull;
    if (pe != null && alt != null) {
      await _db.into(_db.coachProposals).insert(CoachProposalsCompanion.insert(
            type: ProposalTypes.swapExercise,
            title: l.coachPropSwapTitle(ex.name(lang), alt.name(lang)),
            description: Value(l.coachSwapScopeAlways),
            payloadJson: jsonEncode({
              'planExerciseId': pe.id,
              'oldExerciseId': exId,
              'newExerciseId': alt.id,
              'scope': 'always',
              'date': ymd(_now()),
              'reason': 'plateau',
            }),
            messageId: Value(msgId),
            createdAt: Value(_now()),
          ));
    }
    await _notify(l.coachNotifPlateau(ex.name(lang)), text);
  }

  Future<void> runWeeklyJob(Map<String, dynamic> payload) async {
    final end = DateTime.tryParse(payload['weekEnd'] as String? ?? '');
    if (end == null) return;
    final existing = await (_db.select(_db.coachMessages)..where((m) => m.kind.equals(CoachKinds.weekly))).get();
    if (existing.any((m) => m.meta['weekEnd'] == ymd(end))) return;
    await _generateWeekly(dayOf(end));
  }

  /// "Generate weekly report now" (Reports tab). Throws AI errors to the caller.
  Future<void> generateWeeklyReportNow() => _generateWeekly(dayOf(_now()));

  Future<void> _generateWeekly(DateTime end) async {
    final lang = await _lang();
    final start = DateTime(end.year, end.month, end.day - 6);
    final builder = CoachContextBuilder(_db, lang: lang, now: _now());
    final stable = await builder.buildStable();
    final dyn = await builder.buildDynamic(days: 7, end: end);
    final adherence = await adherenceLine(_db, start, end);
    final prompt = '''
Write the weekly report for ${ymd(start)} → ${ymd(end)}.
Adherence: $adherence
Use these short sections with **bold** titles and bullets, real numbers only:
**Training** (volume, PRs, stalls) · **Food** (average calories/protein vs target, consistency) · **Weight** (trend vs goal) · **Sleep & recovery** · **Adherence** · **Plan suggestions for next week** (concrete: exercises, sets/reps, calories).
End with one line: the single most important focus for next week.
Max 300 words. ${replyLanguageLine(lang)}''';
    final text = (await ref.read(aiServiceProvider).text(
              feature: AiFeature.weeklyReport,
              system: AiService.systemBlocks(stable, dynamic: dyn),
              prompt: prompt,
              maxTokens: 8000,
            ))
        .trim();
    if (text.isEmpty) return;
    await _repo.addMessage(
      role: 'assistant',
      content: text,
      kind: CoachKinds.weekly,
      meta: {'weekStart': ymd(start), 'weekEnd': ymd(end)},
    );
    await _notify(_l(lang).coachNotifWeekly, text);
  }

  // ------------------------------------------------------------ helpers

  /// Exercises in [sessionId] that hit the local plateau rule.
  Future<List<String>> detectPlateaus(int sessionId) async {
    final sets = await (_db.select(_db.setLogs)
          ..where((s) => s.sessionId.equals(sessionId) & s.setType.equals('warmup').not()))
        .get();
    final out = <String>[];
    for (final exId in sets.map((s) => s.exerciseId).toSet()) {
      final bests = await exerciseSessionBests(_db, exId, limit: 8);
      if (PlateauDetector.isPlateau(bests.map((b) => SessionBest(b.date, b.bestE1rm)).toList())) out.add(exId);
    }
    return out;
  }

  Future<PlanExercise?> _activePlanExercise(String exId) async {
    final plan = await (_db.select(_db.workoutPlans)
          ..where((t) => t.isActive.equals(true))
          ..limit(1))
        .getSingleOrNull();
    if (plan == null) return null;
    final days = await (_db.select(_db.planDays)..where((d) => d.planId.equals(plan.id))).get();
    if (days.isEmpty) return null;
    return (_db.select(_db.planExercises)
          ..where((p) => p.exerciseId.equals(exId) & p.planDayId.isIn(days.map((d) => d.id)))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<void> _enqueueOnce(String feature, Map<String, dynamic> payload) async {
    final json = jsonEncode(payload);
    final pending = await (_db.select(_db.aiQueue)
          ..where((q) => q.feature.equals(feature) & q.status.equals('pending') & q.payloadJson.equals(json)))
        .get();
    if (pending.isNotEmpty) {
      unawaited(ref.read(aiQueueProvider).process());
      return;
    }
    await ref.read(aiQueueProvider).enqueue(feature, payload);
  }

  Future<void> _notify(String title, String body) async {
    try {
      await NotificationService.showNow(title: title, body: plainPreview(body), payload: 'coach');
    } catch (e) {
      debugPrint('coach notification failed: $e');
    }
  }
}

// ------------------------------------------------------------------ data helpers

class ExerciseSessionBest {
  final int sessionId;
  final DateTime date;
  final double bestE1rm;
  final SetLog top;
  final int sets;
  const ExerciseSessionBest(this.sessionId, this.date, this.bestE1rm, this.top, this.sets);
}

/// Best e1RM per session for [exerciseId], last [limit] sessions, oldest first.
Future<List<ExerciseSessionBest>> exerciseSessionBests(AppDatabase db, String exerciseId, {int limit = 8}) async {
  final sets = await (db.select(db.setLogs)
        ..where((s) => s.exerciseId.equals(exerciseId) & s.setType.equals('warmup').not()))
      .get();
  if (sets.isEmpty) return [];
  final bySession = <int, List<SetLog>>{};
  for (final s in sets) {
    bySession.putIfAbsent(s.sessionId, () => []).add(s);
  }
  final sessions = await (db.select(db.workoutSessions)..where((s) => s.id.isIn(bySession.keys))).get();
  final out = <ExerciseSessionBest>[];
  for (final ses in sessions) {
    final list = bySession[ses.id]!;
    final top = list.reduce((a, b) => StrengthCalc.epley1Rm(b.weightKg, b.reps) > StrengthCalc.epley1Rm(a.weightKg, a.reps) ? b : a);
    out.add(ExerciseSessionBest(ses.id, ses.date, StrengthCalc.epley1Rm(top.weightKg, top.reps), top, list.length));
  }
  out.sort((a, b) {
    final c = a.date.compareTo(b.date);
    return c != 0 ? c : a.sessionId.compareTo(b.sessionId);
  });
  return out.length > limit ? out.sublist(out.length - limit) : out;
}

/// Text block describing a finished session vs the previous one, with the
/// local double-progression target for next time. Null when no sets.
Future<String?> workoutSessionReport(AppDatabase db, WorkoutSession session, {required String lang}) async {
  final sets = await (db.select(db.setLogs)
        ..where((s) => s.sessionId.equals(session.id))
        ..orderBy([(s) => OrderingTerm.asc(s.setIndex), (s) => OrderingTerm.asc(s.id)]))
      .get();
  final condensed = condenseSets(sets);
  if (condensed.isEmpty) return null;
  final exRepo = ExerciseRepository(db);
  final planExercises = session.planDayId == null
      ? <PlanExercise>[]
      : await (db.select(db.planExercises)..where((p) => p.planDayId.equals(session.planDayId!))).get();
  final b = StringBuffer();
  final mins = session.startedAt != null && session.endedAt != null
      ? session.endedAt!.difference(session.startedAt!).inMinutes
      : null;
  final vol = condensed.fold<double>(0, (a, c) => a + c.volume);
  b.writeln('Session ${ymd(session.date)} "${session.name ?? ''}" status ${session.status}'
      '${mins != null ? ', $mins min' : ''}, volume ${vol.round()} kg${session.isDeload ? ', deload' : ''}.');
  if (session.notes?.trim().isNotEmpty ?? false) b.writeln('User note: ${session.notes!.trim()}');
  final notes = await (db.select(db.sessionExerciseNotes)..where((n) => n.sessionId.equals(session.id))).get();

  for (final c in condensed) {
    final ex = await exRepo.byId(c.exerciseId);
    final name = ex?.nameEn ?? c.exerciseId;
    final pe = planExercises.where((p) => p.exerciseId == c.exerciseId).firstOrNull;
    final repMin = pe?.repMin ?? 8, repMax = pe?.repMax ?? 12;
    final bests = await exerciseSessionBests(db, c.exerciseId, limit: 30);
    final idx = bests.indexWhere((x) => x.sessionId == session.id);
    final prev = idx > 0 ? bests[idx - 1] : null;
    final before = idx > 1 ? bests[idx - 2] : null;
    Future<List<LastSet>> setsOf(int sid) async => (await (db.select(db.setLogs)
              ..where((s) => s.sessionId.equals(sid) & s.exerciseId.equals(c.exerciseId) & s.setType.equals('warmup').not())
              ..orderBy([(s) => OrderingTerm.asc(s.setIndex)]))
            .get())
        .map((s) => LastSet(s.weightKg, s.reps, rpe: s.rpe))
        .toList();
    final current = await setsOf(session.id);
    final sug = Progression.suggest(
      setIndex: 0,
      repMin: repMin,
      repMax: repMax,
      lastSession: current,
      sessionBefore: prev != null ? await setsOf(prev.sessionId) : null,
      planWeightKg: pe?.suggestedWeightKg,
      increment: Progression.incrementFor(ex?.equipment, lowerBody: ex?.isLowerBody ?? false),
    );
    b.writeln('- $name (plan ${pe != null ? '${pe.sets}x$repMin-$repMax' : 'not in plan'}): ${c.describe()}');
    if (prev != null) {
      final delta = idx >= 0 ? bests[idx].bestE1rm - prev.bestE1rm : 0;
      b.writeln('  previous ${ymd(prev.date)}: top ${fmtNum(prev.top.weightKg)}x${prev.top.reps}, '
          'e1RM ${prev.bestE1rm.round()} (now ${delta >= 0 ? '+' : ''}${delta.toStringAsFixed(1)})'
          '${before != null ? '; before that e1RM ${before.bestE1rm.round()}' : ''}');
    } else {
      b.writeln('  first time logged');
    }
    b.writeln('  local next target: ${fmtNum(sug.weightKg)}x${sug.reps} (${sug.reason.name})');
    for (final n in notes.where((n) => n.exerciseId == c.exerciseId)) {
      b.writeln('  note: ${n.note}');
    }
  }
  if (session.planDayId != null) {
    final done = condensed.map((c) => c.exerciseId).toSet();
    final skipped = planExercises.where((p) => !done.contains(p.exerciseId)).toList();
    if (skipped.isNotEmpty) {
      final names = await exRepo.byIds(skipped.map((p) => p.exerciseId));
      b.writeln('Skipped from plan: ${names.map((e) => e.nameEn).join(', ')}');
    }
  }
  return b.toString().trimRight();
}

/// "planned N training days, completed X, partial Y, missed Z".
Future<String> adherenceLine(AppDatabase db, DateTime start, DateTime end) async {
  final plan = await (db.select(db.workoutPlans)
        ..where((t) => t.isActive.equals(true))
        ..limit(1))
      .getSingleOrNull();
  var planned = 0;
  if (plan != null) {
    final days = await (db.select(db.planDays)..where((d) => d.planId.equals(plan.id) & d.isRest.equals(false))).get();
    final weekdays = days.map((d) => d.weekday).whereType<int>().toSet();
    for (var d = start; !d.isAfter(end); d = DateTime(d.year, d.month, d.day + 1)) {
      if (weekdays.contains(d.weekday)) planned++;
    }
  }
  final sessions = await (db.select(db.workoutSessions)..where((s) => s.date.isBetweenValues(start, end))).get();
  int count(String st) => sessions.where((s) => s.status == st).length;
  return 'planned $planned training days, completed ${count('completed')}, partial ${count('partial')}, '
      'missed ${count('missed')}';
}

// ------------------------------------------------------------------ providers

final coachInitiativesProvider = Provider<CoachInitiatives>((ref) => CoachInitiatives(ref));

/// Latest coach message to show on the Today tab (today's morning message preferred).
final latestCoachMessageProvider = StreamProvider<CoachMessage?>((ref) {
  final clock = ref.watch(coachClockProvider);
  return ref.watch(coachRepositoryProvider).watchLatestAssistant().map((l) => pickLatestCoachMessage(l, clock()));
});

/// Registers offline AI-queue handlers owned by the coach.
void registerCoachAiHandlers() {
  AiQueueService.register(coachMemoryJob, (ref, p) async {
    await ref.read(coachMemoryServiceProvider).extract();
  });
  AiQueueService.register(CoachJobs.morning, (ref, p) => ref.read(coachInitiativesProvider).runMorningJob(p));
  AiQueueService.register(
      CoachJobs.workoutSummary, (ref, p) => ref.read(coachInitiativesProvider).runWorkoutSummaryJob(p));
  AiQueueService.register(CoachJobs.plateau, (ref, p) => ref.read(coachInitiativesProvider).runPlateauJob(p));
  AiQueueService.register(CoachJobs.weekly, (ref, p) => ref.read(coachInitiativesProvider).runWeeklyJob(p));
}
