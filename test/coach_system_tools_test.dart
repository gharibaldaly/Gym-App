import 'dart:convert';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironmind/core/providers.dart';
import 'package:ironmind/data/repositories/profile_repository.dart';
import 'package:ironmind/features/coach/coach_proposal_runner.dart';
import 'package:ironmind/features/coach/coach_proposals.dart';
import 'package:ironmind/features/coach/coach_repository.dart';
import 'package:ironmind/features/coach/coach_tools.dart';
import 'package:ironmind/features/workout/plan_generator.dart';
import 'package:ironmind/features/workout/workout_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'coach_fixtures.dart';
import 'schema_shape.dart';

/// Plan generator double: records the request and saves an empty inactive plan.
class _FakePlanGenerator extends WorkoutPlanGenerator {
  _FakePlanGenerator(super.ref, this.db);
  final AppDatabase db;
  String? instructions;
  List<int>? days;
  bool fail = false;

  @override
  Future<int> generateAndSave({String? instructions, List<int>? trainingDays}) async {
    if (fail) throw StateError('generation failed');
    this.instructions = instructions;
    days = trainingDays;
    return db.into(db.workoutPlans).insert(WorkoutPlansCompanion.insert(name: 'New plan'));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late CoachFixture f;
  late SharedPreferences prefs;
  late CoachToolExecutor exec;
  late ProposalApplier applier;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    f = await seedCoachDb(withLogs: false);
    exec = CoachToolExecutor(f.db, lang: 'ar', now: () => testNow);
    applier = ProposalApplier(f.db, prefs, now: () => testNow);
  });
  tearDown(() => f.db.close());

  Future<CoachProposal> proposal(int id) =>
      (f.db.select(f.db.coachProposals)..where((p) => p.id.equals(id))).getSingle();
  Future<PlanDay> day(int id) => (f.db.select(f.db.planDays)..where((d) => d.id.equals(id))).getSingle();

  test('tool schemas only use shapes the API accepts', () {
    for (final t in coachTools) {
      expectApiSafeSchema(t['input_schema'], t['name'] as String);
    }
  });

  group('change_schedule', () {
    test('moves a day to another weekday; profile training days follow on approval', () async {
      final out = await exec.execute('change_schedule', {
        'days': [
          {'planDayId': f.pushDayId, 'weekday': DateTime.saturday},
        ],
        'reason': 'السبت أنسب ليك',
      });
      expect(out.isError, isFalse, reason: out.content);
      // Nothing changes before approval.
      expect((await day(f.pushDayId)).weekday, DateTime.tuesday);
      expect((await proposal(out.proposalId!)).description, contains('Push A'));

      await applier.accept(out.proposalId!);
      expect((await day(f.pushDayId)).weekday, DateTime.saturday);
      expect((await day(f.restDayId)).weekday, DateTime.wednesday);
      final p = (await ProfileRepository(f.db).get())!;
      expect(p.trainingDays, [DateTime.saturday]);
      expect(p.daysPerWeek, 1);
      expect((await proposal(out.proposalId!)).status, 'accepted');
    });

    test('two days on the same weekday is rejected unless one moves too', () async {
      final clash = await exec.execute('change_schedule', {
        'days': [
          {'planDayId': f.pushDayId, 'weekday': DateTime.wednesday},
        ],
        'reason': '',
      });
      expect(clash.isError, isTrue);
      expect(clash.content, contains('Weekday 3'));

      final swap = await exec.execute('change_schedule', {
        'days': [
          {'planDayId': f.pushDayId, 'weekday': DateTime.wednesday},
          {'planDayId': f.restDayId, 'weekday': DateTime.tuesday},
        ],
        'reason': '',
      });
      expect(swap.isError, isFalse, reason: swap.content);
      await applier.accept(swap.proposalId!);
      expect((await day(f.pushDayId)).weekday, DateTime.wednesday);
      expect((await day(f.restDayId)).weekday, DateTime.tuesday);
    });

    test('unknown day ids are reported back to the model', () async {
      final out = await exec.execute('change_schedule', {
        'days': [
          {'planDayId': 9999, 'weekday': 1},
        ],
        'reason': '',
      });
      expect(out.isError, isTrue);
      expect(out.content, contains('${f.pushDayId}'));
    });
  });

  group('update_profile', () {
    Map<String, dynamic> input(Map<String, dynamic> changes) => {
          'weightKg': 0,
          'targetWeightKg': 0,
          'goal': 'unchanged',
          'level': 'unchanged',
          'sessionMinutes': 0,
          'trainingTime': '',
          'wakeTime': '',
          'sleepTime': '',
          'mealTimes': <String>[],
          'likedFoods': '',
          'dislikedFoods': '',
          'allergies': '',
          'injuriesNote': '',
          'waterGoalMl': 0,
          'location': 'unchanged',
          'recalculateTargets': false,
          'reason': '',
          ...changes,
        };

    test('applies times, goal and weight on approval and recalculates targets', () async {
      final before = (await ProfileRepository(f.db).get())!;
      final out = await exec.execute(
        'update_profile',
        input({
          'weightKg': 90,
          'goal': 'bulk',
          'trainingTime': '7:30',
          'mealTimes': ['14:00', '08:00', '20:00'],
          'injuriesNote': 'ركبة شمال',
          'recalculateTargets': true,
        }),
      );
      expect(out.isError, isFalse, reason: out.content);
      expect((await ProfileRepository(f.db).get())!.goal, 'cut'); // not yet

      await applier.accept(out.proposalId!);
      final p = (await ProfileRepository(f.db).get())!;
      expect(p.goal, 'bulk');
      expect(p.trainingTime, '07:30');
      expect(p.mealTimes, ['08:00', '14:00', '20:00']);
      expect(p.mealsPerDay, 3);
      expect(p.injuriesNote, 'ركبة شمال');
      expect(p.weightKg, 90);
      expect(p.calorieTarget, isNot(before.calorieTarget));
      final metrics = await f.db.select(f.db.bodyMetrics).get();
      expect(metrics.map((m) => m.weightKg), contains(90));
    });

    test('missing or null fields count as unchanged (tools are not strict)', () async {
      final out = await exec.execute('update_profile', {'sleepTime': '23:30', 'weightKg': null, 'reason': 'نوم'});
      expect(out.isError, isFalse, reason: out.content);
      await applier.accept(out.proposalId!);
      final p = (await ProfileRepository(f.db).get())!;
      expect(p.sleepTime, '23:30');
      expect(p.weightKg, 82);
      expect(p.goal, 'cut');
    });

    test('other tools still reject missing fields (no 0 kg set from a missing weight)', () async {
      final out = await exec.execute('log_set', {'exerciseId': 'Barbell_Bench_Press', 'reps': 5, 'rpe': null});
      expect(out.isError, isTrue);
    });

    test('rejects bad values and empty updates', () async {
      expect((await exec.execute('update_profile', input({'wakeTime': '25:00'}))).isError, isTrue);
      expect((await exec.execute('update_profile', input({'weightKg': 5}))).isError, isTrue);
      expect((await exec.execute('update_profile', input({}))).isError, isTrue);
      expect(await f.db.select(f.db.coachProposals).get(), isEmpty);
    });

    test('macros stay as they are unless recalculation is requested', () async {
      final out = await exec.execute('update_profile', input({'sleepTime': '23:00'}));
      await applier.accept(out.proposalId!);
      final p = (await ProfileRepository(f.db).get())!;
      expect(p.sleepTime, '23:00');
      expect(p.calorieTarget, 2400);
    });
  });

  group('regenerate_workout_plan', () {
    late ProviderContainer c;
    late _FakePlanGenerator gen;

    setUp(() {
      c = ProviderContainer(overrides: [
        databaseProvider.overrideWithValue(f.db),
        sharedPrefsProvider.overrideWithValue(prefs),
        coachClockProvider.overrideWithValue(() => testNow),
        workoutPlanGeneratorProvider.overrideWith((ref) => gen = _FakePlanGenerator(ref, f.db)),
      ]);
    });
    tearDown(() => c.dispose());

    test('approval generates a plan for review with the requested days', () async {
      final out = await exec.execute('regenerate_workout_plan', {
        'instructions': 'Upper/lower split, 4 days',
        'trainingDays': [6, 1, 3, 4],
        'reason': 'خطة 4 أيام',
      });
      expect(out.isError, isFalse, reason: out.content);
      final result = await c.read(coachProposalRunnerProvider).accept(await proposal(out.proposalId!));
      expect(gen.instructions, 'Upper/lower split, 4 days');
      expect(gen.days, [1, 3, 4, 6]);
      expect(result.reviewPlanId, isNotNull);
      expect((await proposal(out.proposalId!)).status, 'accepted');
      // The current plan stays active until the new one is reviewed and approved.
      expect((await WorkoutRepository(f.db).activePlan())!.id, f.planId);
    });

    test('a failed generation leaves the proposal pending', () async {
      final out = await exec.execute('regenerate_workout_plan', {
        'instructions': 'x',
        'trainingDays': <int>[],
        'reason': '',
      });
      c.read(workoutPlanGeneratorProvider);
      gen.fail = true;
      await expectLater(c.read(coachProposalRunnerProvider).accept(await proposal(out.proposalId!)), throwsStateError);
      expect((await proposal(out.proposalId!)).status, 'pending');
    });
  });

  test('approving a plan makes the profile training days follow it', () async {
    final repo = WorkoutRepository(f.db);
    final planId = await f.db.into(f.db.workoutPlans).insert(WorkoutPlansCompanion.insert(name: 'Upper Lower'));
    for (final wd in [DateTime.saturday, DateTime.monday, DateTime.wednesday]) {
      await f.db.into(f.db.planDays).insert(PlanDaysCompanion.insert(planId: planId, name: 'D$wd', weekday: Value(wd)));
    }
    await f.db.into(f.db.planDays).insert(
        PlanDaysCompanion.insert(planId: planId, name: 'Rest', weekday: const Value(DateTime.friday), isRest: const Value(true)));
    await repo.approvePlan(planId);
    final p = (await ProfileRepository(f.db).get())!;
    expect(p.trainingDays, [1, 3, 6]);
    expect(p.daysPerWeek, 3);
    expect(jsonDecode(p.trainingDaysJson), [1, 3, 6]);
  });
}
