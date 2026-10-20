import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/providers.dart';
import '../../core/utils/context_ext.dart' show dayOf, ymd;
import 'workout_logic.dart';
import 'workout_repository.dart';

/// Default deload cadence when the plan doesn't say.
const defaultDeloadEveryWeeks = 5;

DateTime? deloadWeekStart(SharedPreferences prefs) {
  final s = prefs.getString(deloadWeekStartKey);
  return s == null ? null : DateTime.tryParse(s);
}

/// True while today is inside an accepted deload week (7 days from `deload_week_start`).
bool isDeloadWeekActive(SharedPreferences prefs, [DateTime? now]) =>
    deloadActiveOn(deloadWeekStart(prefs), now ?? DateTime.now());

/// Starts a deload week today and resolves any pending deload proposal as accepted.
Future<void> startDeloadWeek(AppDatabase db, SharedPreferences prefs) async {
  await prefs.setString(deloadWeekStartKey, ymd(DateTime.now()));
  await (db.update(db.coachProposals)..where((t) => t.type.equals('deload') & t.status.equals('pending')))
      .write(CoachProposalsCompanion(status: const Value('accepted'), resolvedAt: Value(DateTime.now())));
}

/// Ends an active deload week early (keeps the start as "last deload").
Future<void> endDeloadWeek(SharedPreferences prefs) async {
  final s = deloadWeekStart(prefs);
  if (s == null) return;
  // Move the start back so the 7-day window is over but the anchor stays recent.
  final ended = DateTime(s.year, s.month, s.day);
  final today = dayOf(DateTime.now());
  final back = today.difference(ended).inDays >= 7 ? ended : DateTime(today.year, today.month, today.day - 7);
  await prefs.setString(deloadWeekStartKey, ymd(back));
}

/// Snoozes the deload suggestion (rejects the pending proposal; card hides for 7 days).
Future<void> snoozeDeload(AppDatabase db) =>
    (db.update(db.coachProposals)..where((t) => t.type.equals('deload') & t.status.equals('pending')))
        .write(CoachProposalsCompanion(status: const Value('rejected'), resolvedAt: Value(DateTime.now())));

class DeloadStatus {
  final bool due;
  final bool active;
  final DateTime? activeStart;
  final String? reason; // schedule / performance
  final int weeksSince;
  final int everyWeeks;
  final bool snoozed;
  const DeloadStatus({
    required this.due,
    required this.active,
    this.activeStart,
    this.reason,
    required this.weeksSince,
    required this.everyWeeks,
    this.snoozed = false,
  });

  /// Show the suggestion card.
  bool get showSuggestion => due && !active && !snoozed;
}

/// Weeks since activation (or the last deload) ≥ deloadEveryWeeks, or a ≥3% drop in
/// average e1RM over the last 2 weeks (after at least 3 weeks of training).
Future<DeloadStatus> computeDeloadStatus(
  AppDatabase db,
  WorkoutPlan plan, {
  SharedPreferences? prefs,
  DateTime? now,
}) async {
  final t = now ?? DateTime.now();
  final every = plan.deloadEveryWeeks ?? defaultDeloadEveryWeeks;
  final lastDeload = prefs == null ? null : deloadWeekStart(prefs);
  final active = deloadActiveOn(lastDeload, t);
  final activation = plan.activatedAt ?? plan.createdAt;
  final anchor = lastDeload != null && lastDeload.isAfter(activation) ? lastDeload : activation;
  final weeks = weeksSince(anchor, t);
  if (active) {
    return DeloadStatus(due: false, active: true, activeStart: lastDeload, weeksSince: weeks, everyWeeks: every);
  }

  String? reason;
  if (weeks >= every) {
    reason = 'schedule';
  } else if (weeks >= 3) {
    final repo = WorkoutRepository(db);
    final exIds = <String>{};
    for (final d in await repo.days(plan.id)) {
      exIds.addAll((await repo.dayExercises(d.id)).map((e) => e.pe.exerciseId));
    }
    final since = t.subtract(const Duration(days: 28));
    final bests = <String, List<({DateTime date, double e1rm})>>{};
    for (final id in exIds) {
      bests[id] = await repo.sessionBests(id, since: dayOf(since));
    }
    if (performanceDropped(e1rmTrendRatio(bests, now: t))) reason = 'performance';
  }

  var snoozed = false;
  if (reason != null) {
    final rejected = await (db.select(db.coachProposals)
          ..where((p) =>
              p.type.equals('deload') &
              p.status.equals('rejected') &
              p.resolvedAt.isBiggerOrEqualValue(t.subtract(const Duration(days: 7)))))
        .get();
    snoozed = rejected.isNotEmpty;
  }
  return DeloadStatus(
    due: reason != null,
    active: false,
    reason: reason,
    weeksSince: weeks,
    everyWeeks: every,
    snoozed: snoozed,
  );
}

/// Contract helper: is a deload week due for [plan]?
Future<bool> isDeloadDue(AppDatabase db, WorkoutPlan plan, {SharedPreferences? prefs, DateTime? now}) async =>
    (await computeDeloadStatus(db, plan, prefs: prefs, now: now)).due;

/// Inserts one pending 'deload' coach proposal per deload cycle (rendered by the coach UI).
Future<void> ensureDeloadProposal(
  AppDatabase db,
  WorkoutPlan plan,
  DeloadStatus status, {
  required String lang,
  DateTime? lastDeload,
}) async {
  if (!status.due) return;
  final activation = plan.activatedAt ?? plan.createdAt;
  final anchor = lastDeload != null && lastDeload.isAfter(activation) ? lastDeload : activation;
  final existing = await (db.select(db.coachProposals)
        ..where((p) => p.type.equals('deload') & p.createdAt.isBiggerOrEqualValue(anchor)))
      .get();
  if (existing.isNotEmpty) return;
  final ar = lang == 'ar';
  final title = ar ? 'أسبوع Deload (تخفيف)' : 'Deload week';
  final description = status.reason == 'performance'
      ? (ar
          ? 'أرقامك نزلت شوية في آخر أسبوعين – ده غالبًا إرهاق متراكم. أسبوع خفيف بأوزان 85% هيرجعك أقوى.'
          : 'Your estimated 1RMs dropped over the last 2 weeks – likely accumulated fatigue. A lighter week at 85% will bring you back stronger.')
      : (ar
          ? 'بقالك ${status.weeksSince} أسابيع تمرين تقيل. أسبوع خفيف بأوزان 85% هيساعد جسمك يستشفى ويكمل تقدم.'
          : "You've trained hard for ${status.weeksSince} weeks. A lighter week at 85% weights helps you recover and keep progressing.");
  await db.into(db.coachProposals).insert(CoachProposalsCompanion.insert(
        type: 'deload',
        title: title,
        description: Value(description),
        payloadJson: jsonEncode({
          'planId': plan.id,
          'reason': status.reason,
          'weeksSince': status.weeksSince,
          'weightFactor': 0.85,
          'days': 7,
        }),
      ));
}

/// Deload state of the active plan; also files the coach proposal once when due.
final deloadStatusProvider = StreamProvider.autoDispose<DeloadStatus?>((ref) {
  final db = ref.watch(databaseProvider);
  final prefs = ref.watch(sharedPrefsProvider);
  final lang = ref.watch(localeProvider);
  final repo = ref.watch(workoutRepositoryProvider);
  return watchTables(db, {db.workoutPlans, db.workoutSessions, db.coachProposals}, () async {
    final plan = await repo.activePlan();
    if (plan == null) return null;
    final status = await computeDeloadStatus(db, plan, prefs: prefs);
    if (status.due) {
      await ensureDeloadProposal(db, plan, status, lang: lang, lastDeload: deloadWeekStart(prefs));
    }
    return status;
  }).distinct((a, b) =>
      a?.due == b?.due && a?.active == b?.active && a?.snoozed == b?.snoozed && a?.weeksSince == b?.weeksSince);
});
