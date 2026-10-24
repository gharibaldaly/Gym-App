import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ironmind/core/providers.dart';
import 'package:ironmind/features/coach/coach_proposals.dart';
import 'package:ironmind/features/coach/coach_tools.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'coach_fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late CoachFixture f;
  late SharedPreferences prefs;
  late CoachToolExecutor exec;
  late ProposalApplier applier;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    f = await seedCoachDb();
    exec = CoachToolExecutor(f.db, lang: 'ar', now: () => testNow);
    applier = ProposalApplier(f.db, prefs, now: () => testNow);
  });
  tearDown(() => f.db.close());

  Future<CoachProposal> proposal(int id) =>
      (f.db.select(f.db.coachProposals)..where((p) => p.id.equals(id))).getSingle();

  test('tool definitions are closed objects and not strict', () {
    for (final t in coachTools) {
      // Strict tools are compiled into one grammar the API rejects as too large for this set.
      expect(t.containsKey('strict'), isFalse, reason: t['name'] as String);
      final schema = t['input_schema'] as Map;
      expect(schema['additionalProperties'], isFalse);
      expect((schema['required'] as List).toSet(), (schema['properties'] as Map).keys.toSet());
    }
    final change = ((coachTools.firstWhere((t) => t['name'] == 'propose_plan_change')['input_schema']
            as Map)['properties']['changes']['items'] as Map);
    expect(change['additionalProperties'], isFalse);
    expect(coachTools.map((t) => t['name']), containsAll(
        ['propose_plan_change', 'swap_exercise', 'log_meal', 'log_set', 'adjust_macros', 'save_memory']));
  });

  test('find_exercises returns ids and changes nothing', () async {
    final out = await exec.execute('find_exercises', {'query': 'bench', 'muscle': null});
    expect(out.isError, isFalse);
    expect(out.content, contains('Barbell_Bench_Press'));
    expect(out.content, contains('Dumbbell_Bench_Press'));
    expect(out.proposalId, isNull);
    expect(await f.db.select(f.db.coachProposals).get(), isEmpty);
  });

  test('invalid input is reported as error', () async {
    final out = await exec.execute('log_set', {'exerciseId': 'Barbell_Bench_Press', 'reps': 5});
    expect(out.isError, isTrue);
    final missing = await exec.execute('log_set', {'exerciseId': 'Nope', 'weightKg': 50, 'reps': 5, 'rpe': null});
    expect(missing.isError, isTrue);
    expect(missing.content, contains('find_exercises'));
    final block = missing.toResultBlock('toolu_1');
    expect(block['type'], 'tool_result');
    expect(block['tool_use_id'], 'toolu_1');
    expect(block['is_error'], isTrue);
  });

  test('plan change → pending proposal → accept edits plan_exercises', () async {
    final out = await exec.execute('propose_plan_change', {
      'planDayId': f.pushDayId,
      'summary': 'زود حجم الصدر',
      'changes': [
        {
          'action': 'modify', 'planExerciseId': f.benchPeId, 'exerciseId': null, 'sets': 4, 'repMin': null,
          'repMax': null, 'weightKg': 82.5, 'targetRpe': null, 'restSeconds': null,
        },
        {
          'action': 'remove', 'planExerciseId': f.flyPeId, 'exerciseId': null, 'sets': null, 'repMin': null,
          'repMax': null, 'weightKg': null, 'targetRpe': null, 'restSeconds': null,
        },
        {
          'action': 'add', 'planExerciseId': null, 'exerciseId': 'Dumbbell_Bench_Press', 'sets': 3, 'repMin': 10,
          'repMax': 12, 'weightKg': 30, 'targetRpe': 8, 'restSeconds': 90,
        },
      ],
    });
    expect(out.isError, isFalse, reason: out.content);
    expect(out.content, contains('approve/reject'));
    final p = await proposal(out.proposalId!);
    expect(p.type, ProposalTypes.planChange);
    expect(p.status, 'pending');
    expect(p.title, contains('Push A'));
    expect(p.description, contains('بنش برس دمبل'));

    // Nothing changed yet.
    var pes = await (f.db.select(f.db.planExercises)..where((t) => t.planDayId.equals(f.pushDayId))).get();
    expect(pes, hasLength(2));

    await applier.accept(p.id);
    pes = await (f.db.select(f.db.planExercises)..where((t) => t.planDayId.equals(f.pushDayId))).get();
    expect(pes.map((e) => e.exerciseId), unorderedEquals(['Barbell_Bench_Press', 'Dumbbell_Bench_Press']));
    final bench = pes.firstWhere((e) => e.id == f.benchPeId);
    expect(bench.sets, 4);
    expect(bench.suggestedWeightKg, 82.5);
    expect(bench.repMin, 6); // untouched
    final added = pes.firstWhere((e) => e.exerciseId == 'Dumbbell_Bench_Press');
    expect([added.sets, added.repMin, added.repMax, added.restSeconds], [3, 10, 12, 90]);
    expect((await proposal(p.id)).status, 'accepted');
    expect((await proposal(p.id)).resolvedAt, testNow);

    // Cannot resolve twice.
    expect(() => applier.reject(p.id), throwsA(isA<ProposalApplyException>()));
  });

  test('plan change validation rejects foreign plan exercise', () async {
    final out = await exec.execute('propose_plan_change', {
      'planDayId': f.restDayId,
      'summary': '',
      'changes': [
        {
          'action': 'remove', 'planExerciseId': f.benchPeId, 'exerciseId': null, 'sets': null, 'repMin': null,
          'repMax': null, 'weightKg': null, 'targetRpe': null, 'restSeconds': null,
        },
      ],
    });
    expect(out.isError, isTrue);
    expect(await f.db.select(f.db.coachProposals).get(), isEmpty);
  });

  test('swap always updates the plan, swap today writes prefs', () async {
    final always = await exec.execute('swap_exercise', {
      'planExerciseId': f.benchPeId,
      'newExerciseId': 'Dumbbell_Bench_Press',
      'scope': 'always',
      'reason': 'الكتف',
    });
    await applier.accept(always.proposalId!);
    final pe = await (f.db.select(f.db.planExercises)..where((t) => t.id.equals(f.benchPeId))).getSingle();
    expect(pe.exerciseId, 'Dumbbell_Bench_Press');

    final today = await exec.execute('swap_exercise', {
      'planExerciseId': f.flyPeId,
      'newExerciseId': 'Barbell_Bench_Press',
      'scope': 'today',
      'reason': '',
    });
    await applier.accept(today.proposalId!);
    expect(jsonDecode(prefs.getString('swap_today_2026-10-20')!), {'${f.flyPeId}': 'Barbell_Bench_Press'});
    final fly = await (f.db.select(f.db.planExercises)..where((t) => t.id.equals(f.flyPeId))).getSingle();
    expect(fly.exerciseId, 'Cable_Fly');
  });

  test('log_meal accept inserts meal_logs with summed macros', () async {
    final out = await exec.execute('log_meal', {
      'name': 'فطار',
      'items': [
        {'name': 'فول', 'grams': 200, 'calories': 220, 'protein': 14, 'carbs': 30, 'fat': 5},
        {'name': 'بيض', 'grams': 100, 'calories': 155, 'protein': 13, 'carbs': 1, 'fat': 11},
      ],
    });
    expect((await proposal(out.proposalId!)).title, contains('375'));
    await applier.accept(out.proposalId!);
    final meal = await (f.db.select(f.db.mealLogs)..where((m) => m.name.equals('فطار'))).getSingle();
    expect(meal.date, DateTime(2026, 10, 20));
    expect([meal.calories, meal.protein, meal.carbs, meal.fat], [375, 27, 31, 16]);
    expect(meal.source, 'ai_text');
    expect(jsonDecode(meal.itemsJson), hasLength(2));
  });

  test('log_set accept creates today session and flags PRs', () async {
    final out = await exec.execute('log_set', {'exerciseId': 'Barbell_Bench_Press', 'weightKg': 85, 'reps': 5, 'rpe': 9});
    await applier.accept(out.proposalId!);
    final session = await (f.db.select(f.db.workoutSessions)..where((s) => s.date.equals(DateTime(2026, 10, 20))))
        .getSingle();
    expect(session.status, 'partial');
    expect(session.totalVolume, 425);
    final set = await (f.db.select(f.db.setLogs)..where((s) => s.sessionId.equals(session.id))).getSingle();
    expect(set.weightKg, 85);
    expect(set.isPr, isTrue);
    expect(set.prTypes, contains('weight'));
    expect(set.setIndex, 0);

    // A second set goes into the same session with the next index.
    final out2 = await exec.execute('log_set', {'exerciseId': 'Barbell_Bench_Press', 'weightKg': 60, 'reps': 5, 'rpe': null});
    await applier.accept(out2.proposalId!);
    final sets = await (f.db.select(f.db.setLogs)..where((s) => s.sessionId.equals(session.id))).get();
    expect(sets.map((s) => s.setIndex), [0, 1]);
    expect(sets.last.isPr, isFalse);
  });

  test('adjust_macros validates energy balance and shifts carb cycling', () async {
    final bad = await exec.execute('adjust_macros', {'calories': 2000, 'protein': 200, 'carbs': 300, 'fat': 80, 'reason': ''});
    expect(bad.isError, isTrue);
    final ok = await exec.execute('adjust_macros', {'calories': 2300, 'protein': 190, 'carbs': 220, 'fat': 68, 'reason': 'الوزن ثابت'});
    expect(ok.isError, isFalse, reason: ok.content);
    await applier.accept(ok.proposalId!);
    final p = await (f.db.select(f.db.userProfiles)).getSingle();
    expect([p.calorieTarget, p.proteinG, p.carbsG, p.fatG], [2300, 190, 220, 68]);
    expect(p.trainingDayCarbsG, 250); // 270 - 20
    expect(p.restDayCarbsG, 190); // 210 - 20
  });

  test('reject marks rejected and changes nothing', () async {
    final out = await exec.execute('log_meal', {
      'name': 'x',
      'items': [
        {'name': 'رز', 'grams': 150, 'calories': 200, 'protein': 4, 'carbs': 44, 'fat': 1},
      ],
    });
    final before = (await f.db.select(f.db.mealLogs).get()).length;
    await applier.reject(out.proposalId!);
    expect((await proposal(out.proposalId!)).status, 'rejected');
    expect((await f.db.select(f.db.mealLogs).get()).length, before);
  });

  test('deload and recovery_adjust proposals write prefs on accept', () async {
    final deload = await f.db.into(f.db.coachProposals).insert(CoachProposalsCompanion.insert(
          type: 'deload',
          title: 'Deload',
          payloadJson: '{}',
        ));
    await applier.accept(deload);
    expect(prefs.getString('deload_week_start'), '2026-10-20');

    final rec = await f.db.into(f.db.coachProposals).insert(CoachProposalsCompanion.insert(
          type: 'recovery_adjust',
          title: 'Recovery',
          payloadJson: jsonEncode({'date': '2026-10-20', 'weightFactor': 0.9, 'setsDelta': -1}),
        ));
    await applier.accept(rec);
    expect(jsonDecode(prefs.getString('recovery_adjust_2026-10-20')!), {'weightFactor': 0.9, 'setsDelta': -1});
  });

  test('save_memory stores immediately and dedupes', () async {
    final a = await exec.execute('save_memory', {'fact': 'بيتمرن في جيم محدود الأجهزة'});
    expect(a.content, 'Saved to memory.');
    final b = await exec.execute('save_memory', {'fact': 'بيتمرن في جيم محدود الأجهزة.'});
    expect(b.content, contains('Already'));
    expect(await f.db.select(f.db.coachProposals).get(), isEmpty);
    expect((await f.db.select(f.db.coachMemories).get()).length, 2); // fixture memory + new one
  });
}
