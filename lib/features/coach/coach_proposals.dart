import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/calc/strength_calc.dart';
import '../../core/providers.dart';
import '../../core/utils/context_ext.dart' show dayOf, ymd;
import '../../data/repositories/profile_repository.dart';
import '../tracking/tracking_repository.dart';
import 'coach_repository.dart';
import 'coach_tools.dart' show scheduleClash;

/// coach_proposals.type values.
class ProposalTypes {
  static const planChange = 'plan_change';
  static const swapExercise = 'swap_exercise';
  static const logMeal = 'log_meal';
  static const logSet = 'log_set';
  static const adjustMacros = 'adjust_macros';
  static const recoveryAdjust = 'recovery_adjust';
  static const deload = 'deload';
  static const changeSchedule = 'change_schedule';
  static const updateProfile = 'update_profile';
  static const regenerateWorkoutPlan = 'regenerate_workout_plan';
  static const regenerateMealPlan = 'regenerate_meal_plan';

  /// Applied by running an AI generator (outside a DB transaction), see CoachProposalRunner.
  static const generated = {regenerateWorkoutPlan, regenerateMealPlan};
}

/// SharedPreferences contracts read by the workout feature.
class CoachPrefKeys {
  /// yyyy-MM-dd of the day the user accepted a deload week (deload lasts 7 days from it).
  static const deloadWeekStart = 'deload_week_start';

  /// JSON {"weightFactor":0.9,"setsDelta":-1} for that day's workout.
  static String recoveryAdjust(DateTime day) => 'recovery_adjust_${ymd(day)}';

  /// JSON `{"planExerciseId": "newExerciseId"}` – swaps for that day only.
  static String swapToday(DateTime day) => 'swap_today_${ymd(day)}';
}

class ProposalApplyException implements Exception {
  final String message;
  ProposalApplyException(this.message);
  @override
  String toString() => message;
}

/// Accept / reject logic. Accepting applies the change to the DB (or prefs)
/// in one transaction and marks the proposal accepted.
class ProposalApplier {
  final AppDatabase db;
  final SharedPreferences prefs;
  final DateTime Function() now;
  ProposalApplier(this.db, this.prefs, {DateTime Function()? now}) : now = now ?? DateTime.now;

  Future<CoachProposal> _load(int id) async {
    final p = await (db.select(db.coachProposals)..where((t) => t.id.equals(id))).getSingleOrNull();
    if (p == null) throw ProposalApplyException('Proposal $id not found');
    if (p.status != 'pending') throw ProposalApplyException('Proposal $id is already ${p.status}');
    return p;
  }

  Future<void> reject(int id) async {
    await _load(id);
    await _mark(id, 'rejected');
  }

  Future<void> accept(int id) async {
    final p = await _load(id);
    final payload = p.payload;
    await db.transaction(() async {
      switch (p.type) {
        case ProposalTypes.planChange:
          await _applyPlanChange(payload);
        case ProposalTypes.swapExercise:
          await _applySwap(payload);
        case ProposalTypes.logMeal:
          await _applyLogMeal(payload);
        case ProposalTypes.logSet:
          await _applyLogSet(payload);
        case ProposalTypes.adjustMacros:
          await _applyMacros(payload);
        case ProposalTypes.changeSchedule:
          await _applySchedule(payload);
        case ProposalTypes.updateProfile:
          await _applyProfile(payload);
        case ProposalTypes.deload:
          await prefs.setString(CoachPrefKeys.deloadWeekStart, ymd(now()));
        case ProposalTypes.recoveryAdjust:
          final day = DateTime.tryParse(payload['date'] as String? ?? '') ?? now();
          await prefs.setString(
            CoachPrefKeys.recoveryAdjust(dayOf(day)),
            jsonEncode({
              'weightFactor': (payload['weightFactor'] as num?)?.toDouble() ?? 0.9,
              'setsDelta': (payload['setsDelta'] as num?)?.toInt() ?? -1,
            }),
          );
        default:
          throw ProposalApplyException('Unknown proposal type ${p.type}');
      }
      await _mark(id, 'accepted');
    });
  }

  /// Marks a proposal accepted after its change was applied elsewhere (AI-generated plans).
  Future<void> markAccepted(int id) async {
    await _load(id);
    await _mark(id, 'accepted');
  }

  Future<void> _mark(int id, String status) => (db.update(db.coachProposals)..where((t) => t.id.equals(id)))
      .write(CoachProposalsCompanion(status: Value(status), resolvedAt: Value(now())));

  // ------------------------------------------------------------ plan change

  Future<void> _applyPlanChange(Map<String, dynamic> payload) async {
    final dayId = (payload['planDayId'] as num?)?.toInt();
    if (dayId == null) throw ProposalApplyException('Missing plan day');
    final day = await (db.select(db.planDays)..where((t) => t.id.equals(dayId))).getSingleOrNull();
    if (day == null) throw ProposalApplyException('Plan day no longer exists');
    final changes = (payload['changes'] as List? ?? const []).whereType<Map>().map((m) => m.cast<String, dynamic>());
    var applied = 0;
    for (final c in changes) {
      final action = c['action'] as String?;
      final peId = (c['planExerciseId'] as num?)?.toInt();
      int? i(String k) => (c[k] as num?)?.toInt();
      double? d(String k) => (c[k] as num?)?.toDouble();
      switch (action) {
        case 'remove':
          if (peId == null) continue;
          applied += await (db.delete(db.planExercises)
                ..where((t) => t.id.equals(peId) & t.planDayId.equals(dayId)))
              .go();
        case 'modify':
          if (peId == null) continue;
          final repMin = i('repMin'), repMax = i('repMax');
          final exId = c['exerciseId'] as String?;
          if (exId != null && !await _exerciseExists(exId)) continue;
          applied += await (db.update(db.planExercises)
                ..where((t) => t.id.equals(peId) & t.planDayId.equals(dayId)))
              .write(PlanExercisesCompanion(
            exerciseId: exId == null ? const Value.absent() : Value(exId),
            sets: i('sets') == null ? const Value.absent() : Value(i('sets')!.clamp(1, 12)),
            repMin: repMin == null ? const Value.absent() : Value(repMin),
            repMax: repMax == null ? const Value.absent() : Value(repMax < (repMin ?? 0) ? repMin! : repMax),
            suggestedWeightKg: d('weightKg') == null ? const Value.absent() : Value(d('weightKg')),
            targetRpe: d('targetRpe') == null ? const Value.absent() : Value(d('targetRpe')),
            restSeconds: i('restSeconds') == null ? const Value.absent() : Value(i('restSeconds')!),
          ));
        case 'add':
          final exId = c['exerciseId'] as String?;
          if (exId == null || !await _exerciseExists(exId)) continue;
          final maxOrder = await _maxOrder(dayId);
          final repMin = i('repMin') ?? 8;
          final repMax = i('repMax') ?? (repMin > 12 ? repMin : 12);
          await db.into(db.planExercises).insert(PlanExercisesCompanion.insert(
                planDayId: dayId,
                exerciseId: exId,
                orderIndex: Value(maxOrder + 1),
                sets: Value((i('sets') ?? 3).clamp(1, 12)),
                repMin: Value(repMin),
                repMax: Value(repMax < repMin ? repMin : repMax),
                suggestedWeightKg: Value(d('weightKg')),
                targetRpe: Value(d('targetRpe')),
                restSeconds: Value(i('restSeconds') ?? 90),
              ));
          applied++;
      }
    }
    if (applied == 0) throw ProposalApplyException('Nothing to apply – the plan changed since this proposal');
  }

  Future<int> _maxOrder(int dayId) async {
    final c = db.planExercises.orderIndex.max();
    final r = await (db.selectOnly(db.planExercises)
          ..addColumns([c])
          ..where(db.planExercises.planDayId.equals(dayId)))
        .map((row) => row.read(c))
        .getSingleOrNull();
    return r ?? -1;
  }

  Future<bool> _exerciseExists(String id) async =>
      await (db.select(db.exercises)..where((t) => t.id.equals(id))).getSingleOrNull() != null;

  // ------------------------------------------------------------ swap

  Future<void> _applySwap(Map<String, dynamic> payload) async {
    final peId = (payload['planExerciseId'] as num?)?.toInt();
    final newId = payload['newExerciseId'] as String?;
    if (peId == null || newId == null) throw ProposalApplyException('Invalid swap');
    if (!await _exerciseExists(newId)) throw ProposalApplyException('Exercise not found');
    final pe = await (db.select(db.planExercises)..where((t) => t.id.equals(peId))).getSingleOrNull();
    if (pe == null) throw ProposalApplyException('Plan exercise no longer exists');
    if (payload['scope'] == 'today') {
      final day = DateTime.tryParse(payload['date'] as String? ?? '') ?? now();
      final key = CoachPrefKeys.swapToday(dayOf(day));
      final existing = _decodeMap(prefs.getString(key));
      existing['$peId'] = newId;
      await prefs.setString(key, jsonEncode(existing));
    } else {
      await (db.update(db.planExercises)..where((t) => t.id.equals(peId)))
          .write(PlanExercisesCompanion(exerciseId: Value(newId)));
    }
  }

  // ------------------------------------------------------------ meal

  Future<void> _applyLogMeal(Map<String, dynamic> payload) async {
    final items = (payload['items'] as List? ?? const []).whereType<Map>().map((m) => m.cast<String, dynamic>()).toList();
    double sum(String k) => items.fold(0.0, (a, it) => a + ((it[k] as num?)?.toDouble() ?? 0));
    final day = DateTime.tryParse(payload['date'] as String? ?? '') ?? now();
    await db.into(db.mealLogs).insert(MealLogsCompanion.insert(
          date: dayOf(day),
          name: (payload['name'] as String?)?.trim().isNotEmpty == true ? payload['name'] as String : 'Meal',
          itemsJson: Value(jsonEncode(items)),
          calories: Value(sum('calories')),
          protein: Value(sum('protein')),
          carbs: Value(sum('carbs')),
          fat: Value(sum('fat')),
          source: const Value('ai_text'),
          loggedAt: Value(now()),
        ));
  }

  // ------------------------------------------------------------ set

  Future<void> _applyLogSet(Map<String, dynamic> payload) async {
    final exId = payload['exerciseId'] as String?;
    final weight = (payload['weightKg'] as num?)?.toDouble();
    final reps = (payload['reps'] as num?)?.toInt();
    if (exId == null || weight == null || reps == null || reps <= 0) throw ProposalApplyException('Invalid set');
    if (!await _exerciseExists(exId)) throw ProposalApplyException('Exercise not found');
    final day = dayOf(DateTime.tryParse(payload['date'] as String? ?? '') ?? now());
    final sessionId = await _sessionFor(day);

    final history = await (db.select(db.setLogs)
          ..where((s) => s.exerciseId.equals(exId) & s.setType.equals('warmup').not()))
        .get();
    final prs = PrDetector.detect(
      weightKg: weight,
      reps: reps,
      history: history.map((h) => HistSet(h.weightKg, h.reps)).toList(),
    );
    final idx = history.where((h) => h.sessionId == sessionId).length;
    await db.into(db.setLogs).insert(SetLogsCompanion.insert(
          sessionId: sessionId,
          exerciseId: exId,
          setIndex: idx,
          weightKg: weight,
          reps: reps,
          rpe: Value((payload['rpe'] as num?)?.toDouble()),
          isPr: Value(prs.isNotEmpty),
          prTypes: Value(prs.isEmpty ? null : prs.map((e) => e.name).join(',')),
          createdAt: Value(now()),
        ));
    final session = await (db.select(db.workoutSessions)..where((s) => s.id.equals(sessionId))).getSingle();
    await (db.update(db.workoutSessions)..where((s) => s.id.equals(sessionId)))
        .write(WorkoutSessionsCompanion(totalVolume: Value((session.totalVolume ?? 0) + weight * reps)));
  }

  /// Today's session (prefer in-progress), or a new one (status partial) for coach-logged sets.
  Future<int> _sessionFor(DateTime day) async {
    final sessions = await (db.select(db.workoutSessions)
          ..where((s) => s.date.equals(day) & s.status.equals('missed').not())
          ..orderBy([(s) => OrderingTerm.desc(s.id)]))
        .get();
    if (sessions.isNotEmpty) {
      return (sessions.where((s) => s.status == 'in_progress').firstOrNull ?? sessions.first).id;
    }
    final t = now();
    return db.into(db.workoutSessions).insert(WorkoutSessionsCompanion.insert(
          date: day,
          startedAt: Value(t),
          endedAt: Value(t),
          status: const Value('partial'),
          totalVolume: const Value(0),
        ));
  }

  // ------------------------------------------------------------ macros

  Future<void> _applyMacros(Map<String, dynamic> payload) async {
    final p = await (db.select(db.userProfiles)..where((t) => t.id.equals(1))).getSingleOrNull();
    if (p == null) throw ProposalApplyException('No profile');
    int? v(String k) => (payload[k] as num?)?.round();
    final carbs = v('carbs');
    final carbDelta = carbs != null && p.carbsG != null ? carbs - p.carbsG! : 0;
    await (db.update(db.userProfiles)..where((t) => t.id.equals(1))).write(UserProfilesCompanion(
      calorieTarget: v('calories') == null ? const Value.absent() : Value(v('calories')),
      proteinG: v('protein') == null ? const Value.absent() : Value(v('protein')),
      carbsG: carbs == null ? const Value.absent() : Value(carbs),
      fatG: v('fat') == null ? const Value.absent() : Value(v('fat')),
      trainingDayCarbsG: p.trainingDayCarbsG == null || carbs == null
          ? const Value.absent()
          : Value((p.trainingDayCarbsG! + carbDelta).clamp(0, 2000)),
      restDayCarbsG: p.restDayCarbsG == null || carbs == null
          ? const Value.absent()
          : Value((p.restDayCarbsG! + carbDelta).clamp(0, 2000)),
      updatedAt: Value(now()),
    ));
  }

  // ------------------------------------------------------------ schedule

  Future<void> _applySchedule(Map<String, dynamic> payload) async {
    final planId = (payload['planId'] as num?)?.toInt();
    final plan = planId == null
        ? null
        : await (db.select(db.workoutPlans)..where((t) => t.id.equals(planId))).getSingleOrNull();
    if (plan == null || !plan.isActive) throw ProposalApplyException('The plan changed since this proposal');
    final days = await (db.select(db.planDays)..where((t) => t.planId.equals(plan.id))).get();
    final target = {for (final d in days) d.id: d.weekday};
    for (final m in (payload['days'] as List? ?? const []).whereType<Map>()) {
      final id = (m['planDayId'] as num?)?.toInt();
      if (id == null || !target.containsKey(id)) throw ProposalApplyException('Plan day no longer exists');
      target[id] = (m['weekday'] as num?)?.toInt();
    }
    if (scheduleClash(target) != null) throw ProposalApplyException('Two days would fall on the same weekday');
    for (final d in days) {
      if (target[d.id] == d.weekday) continue;
      await (db.update(db.planDays)..where((t) => t.id.equals(d.id))).write(PlanDaysCompanion(weekday: Value(target[d.id])));
    }
    // The profile's training days drive reminders and future plans.
    final trainingDays = [
      for (final d in days)
        if (!d.isRest && target[d.id] != null) target[d.id]!,
    ]..sort();
    await (db.update(db.userProfiles)..where((t) => t.id.equals(1))).write(UserProfilesCompanion(
      trainingDaysJson: Value(jsonEncode(trainingDays)),
      daysPerWeek: Value(trainingDays.length),
      updatedAt: Value(now()),
    ));
  }

  // ------------------------------------------------------------ profile

  Future<void> _applyProfile(Map<String, dynamic> payload) async {
    final c = (payload['changes'] as Map?)?.cast<String, dynamic>() ?? const {};
    if (c.isEmpty) throw ProposalApplyException('Nothing to apply');
    if (await ProfileRepository(db).get() == null) throw ProposalApplyException('No profile');
    String? s(String k) => c[k] as String?;
    final meals = (c['mealTimes'] as List?)?.cast<String>();
    Value<T> v<T>(T? x) => x == null ? const Value.absent() : Value(x);
    await (db.update(db.userProfiles)..where((t) => t.id.equals(1))).write(UserProfilesCompanion(
      targetWeightKg: v((c['targetWeightKg'] as num?)?.toDouble()),
      goal: v(s('goal')),
      level: v(s('level')),
      sessionMinutes: v((c['sessionMinutes'] as num?)?.toInt()),
      trainingTime: v(s('trainingTime')),
      wakeTime: v(s('wakeTime')),
      sleepTime: v(s('sleepTime')),
      mealTimesJson: v(meals == null ? null : jsonEncode(meals)),
      mealsPerDay: v(meals?.length),
      likedFoods: v(s('likedFoods')),
      dislikedFoods: v(s('dislikedFoods')),
      allergies: v(s('allergies')),
      injuriesNote: v(s('injuriesNote')),
      waterGoalMl: v((c['waterGoalMl'] as num?)?.toInt()),
      location: v(s('location')),
      updatedAt: Value(now()),
    ));
    final weight = (c['weightKg'] as num?)?.toDouble();
    if (weight != null) {
      // Logged as a weigh-in so the weight chart and the profile agree.
      final day = DateTime.tryParse(payload['date'] as String? ?? '') ?? now();
      await TrackingRepository(db).saveWeight(dayOf(day), weight);
    }
    if (payload['recalculateTargets'] == true) await ProfileRepository(db).recomputeTargets();
  }

  static Map<String, dynamic> _decodeMap(String? s) {
    if (s == null) return {};
    try {
      final v = jsonDecode(s);
      return v is Map<String, dynamic> ? v : {};
    } catch (_) {
      return {};
    }
  }
}

final proposalApplierProvider = Provider<ProposalApplier>((ref) => ProposalApplier(
      ref.watch(databaseProvider),
      ref.watch(sharedPrefsProvider),
      now: ref.watch(coachClockProvider),
    ));
