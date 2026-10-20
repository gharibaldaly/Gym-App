import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ironmind/data/repositories/exercise_repository.dart';
import 'package:ironmind/features/workout/plan_generator.dart';
import 'package:ironmind/features/workout/plan_templates.dart';
import 'package:ironmind/features/workout/workout_logic.dart';
import 'package:ironmind/features/workout/workout_repository.dart';
import 'package:ironmind/ai/json_schema.dart';

import 'wo_helpers.dart';

Map<String, dynamic> _validPlan() => {
      'name': 'Push/Pull/Legs',
      'notes': 'Double progression.',
      'deloadEveryWeeks': 5,
      'days': [
        for (final wd in [1, 3, 5])
          {
            'weekday': wd,
            'name': 'Day $wd',
            'focus': 'x',
            'warmup': ['5 min bike'],
            'cooldown': ['stretch'],
            'exercises': [
              {
                'exerciseId': 'Barbell_Squat',
                'sets': 3,
                'repMin': 6,
                'repMax': 10,
                'suggestedWeightKg': 60,
                'targetRpe': 8,
                'restSeconds': 150,
                'notes': null,
              },
            ],
          },
      ],
    };

void main() {
  group('plan JSON validation', () {
    final known = {'Barbell_Squat', 'Pushups'};

    test('valid plan passes schema and domain checks', () {
      final p = _validPlan();
      expect(validateJson(p, workoutPlanSchema), isEmpty);
      expect(validatePlanJson(p, knownIds: known, trainingDays: [1, 3, 5]), isEmpty);
    });

    test('unknown exercise id is rejected (triggers the AI retry)', () {
      final p = _validPlan();
      ((p['days'] as List).first['exercises'] as List).first['exerciseId'] = 'Made_Up_Press';
      final errors = validatePlanJson(p, knownIds: known, trainingDays: [1, 3, 5]);
      expect(errors.single, contains('Made_Up_Press'));
    });

    test('missing / extra weekdays and bad ranges are rejected', () {
      final p = _validPlan();
      expect(validatePlanJson(p, knownIds: known, trainingDays: [1, 3, 5, 6]).any((e) => e.contains('weekday 6')), isTrue);
      expect(validatePlanJson(p, knownIds: known, trainingDays: [1, 3]).any((e) => e.contains('not one of')), isTrue);
      final ex = ((p['days'] as List).first['exercises'] as List).first as Map;
      ex['repMin'] = 12;
      ex['repMax'] = 8;
      ex['restSeconds'] = 5;
      p['deloadEveryWeeks'] = 9;
      final errors = validatePlanJson(p, knownIds: known, trainingDays: [1, 3, 5]);
      expect(errors.any((e) => e.contains('repMin must be <= repMax')), isTrue);
      expect(errors.any((e) => e.contains('restSeconds')), isTrue);
      expect(errors.any((e) => e.contains('deloadEveryWeeks')), isTrue);
    });

    test('schema rejects wrong types', () {
      final p = _validPlan();
      (p['days'] as List).first['weekday'] = 'Monday';
      expect(validateJson(p, workoutPlanSchema), isNotEmpty);
    });
  });

  group('template plan', () {
    final seed = seedExerciseIds();

    test('every template exercise id exists in the bundled seed', () {
      expect(templateExerciseIds.difference(seed), isEmpty);
    });

    test('all splits × locations × day counts produce valid plans', () {
      for (final split in [null, 'ai', 'full_body', 'upper_lower', 'ppl', 'bro', 'muscle_group']) {
        for (final loc in ['full_gym', 'limited_gym', 'home']) {
          for (var n = 1; n <= 7; n++) {
            final days = defaultTrainingDays(n);
            final json = buildTemplatePlanJson(TemplateInput(
              days: days,
              split: split,
              location: loc,
              level: 'intermediate',
              sessionMinutes: 60,
              bodyweightKg: 80,
              lang: n.isEven ? 'ar' : 'en',
              available: seed,
            ));
            expect(validateJson(json, workoutPlanSchema), isEmpty, reason: '$split/$loc/$n');
            expect(validatePlanJson(json, knownIds: seed, trainingDays: days), isEmpty, reason: '$split/$loc/$n');
          }
        }
      }
    });

    test('home template avoids barbells and machines', () {
      final json = buildTemplatePlanJson(TemplateInput(days: const [1, 3, 5], location: 'home', available: seed));
      final ids = [
        for (final d in json['days'] as List)
          for (final e in d['exercises'] as List) e['exerciseId'] as String,
      ];
      expect(ids, isNot(contains('Barbell_Squat')));
      expect(ids, isNot(contains('Leg_Press')));
      expect(ids, contains('Pushups'));
    });

    test('session length controls exercise count; weights estimated from bodyweight', () {
      int count(int minutes) => ((buildTemplatePlanJson(TemplateInput(days: const [1], sessionMinutes: minutes))['days']
              as List)
          .first['exercises'] as List)
          .length;
      expect(count(30), 4);
      expect(count(90), greaterThan(count(45)));
      final json = buildTemplatePlanJson(const TemplateInput(days: [1], split: 'full_body', bodyweightKg: 80));
      final squat = ((json['days'] as List).first['exercises'] as List).first as Map;
      expect(squat['exerciseId'], 'Barbell_Squat');
      expect(squat['suggestedWeightKg'], 65.0); // 80 × 0.8 → 64 → rounded to 2.5
    });
  });

  group('saving + candidates (in-memory DB)', () {
    test('savePlanJson stores 7 days (rest days filled) as an inactive plan', () async {
      final db = await woTestDb();
      addTearDown(db.close);
      final repo = WorkoutRepository(db);
      final id = await repo.savePlanJson(_validPlan());
      final plan = await repo.plan(id);
      expect(plan!.isActive, isFalse);
      expect(plan.deloadEveryWeeks, 5);
      expect(jsonDecode(plan.rawJson!)['name'], 'Push/Pull/Legs');
      final days = await repo.days(id);
      expect(days.length, 7);
      expect(days.where((d) => d.isRest).map((d) => d.weekday), [2, 4, 6, 7]);
      final monday = days.firstWhere((d) => d.weekday == 1);
      expect(decodeStringList(monday.warmupJson), ['5 min bike']);
      final ex = await repo.dayExercises(monday.id);
      expect(ex.single.pe.suggestedWeightKg, 60);
      expect(ex.single.ex.id, 'Barbell_Squat');
    });

    test('approvePlan activates one plan and deactivates the rest', () async {
      final db = await woTestDb();
      addTearDown(db.close);
      final repo = WorkoutRepository(db);
      final a = await repo.savePlanJson(_validPlan());
      final b = await repo.savePlanJson(_validPlan());
      await repo.approvePlan(a);
      await repo.approvePlan(b);
      expect((await repo.plan(a))!.isActive, isFalse);
      final active = await repo.activePlan();
      expect(active!.id, b);
      expect(active.activatedAt, isNotNull);
    });

    test('reorder / swap / add / remove plan exercises', () async {
      final db = await woTestDb();
      addTearDown(db.close);
      final repo = WorkoutRepository(db);
      final id = await repo.savePlanJson(_validPlan());
      final day = (await repo.days(id)).firstWhere((d) => d.weekday == 1);
      await repo.addPlanExercise(day.id, 'Pushups');
      var items = await repo.dayExercises(day.id);
      expect(items.map((e) => e.ex.id), ['Barbell_Squat', 'Pushups']);
      await repo.reorder(items.reversed.map((e) => e.pe.id).toList());
      items = await repo.dayExercises(day.id);
      expect(items.map((e) => e.ex.id), ['Pushups', 'Barbell_Squat']);
      await repo.swapPlanExercise(items.last.pe.id, 'Leg_Press');
      items = await repo.dayExercises(day.id);
      expect(items.last.ex.id, 'Leg_Press');
      expect(items.last.pe.suggestedWeightKg, isNull);
      await repo.removePlanExercise(items.first.pe.id);
      expect((await repo.dayExercises(day.id)).length, 1);
    });

    test('candidate selection is location aware and covers muscles', () async {
      final db = await woTestDb();
      addTearDown(db.close);
      final all = await ExerciseRepository(db).all();
      final gym = selectPlanCandidates(all, location: 'full_gym', level: 'intermediate');
      expect(gym.strength.length, inInclusiveRange(250, 300));
      expect(gym.stretches, isNotEmpty);
      expect(gym.strength.map((e) => e.id), containsAll(['Barbell_Squat', 'Barbell_Bench_Press_-_Medium_Grip']));
      final muscles = gym.strength.map((e) => e.primaryMuscles.first).toSet();
      expect(muscles, containsAll(['chest', 'lats', 'quadriceps', 'hamstrings', 'shoulders', 'biceps', 'triceps']));
      final home = selectPlanCandidates(all, location: 'home');
      expect(home.strength.any((e) => e.equipment == 'barbell' || e.equipment == 'machine'), isFalse);
      expect(PlanCandidates.line(gym.strength.firstWhere((e) => e.id == 'Barbell_Squat')),
          'Barbell_Squat|Barbell Squat|quadriceps|barbell');
    });

    test('defaultTrainingDays returns sorted, distinct weekdays', () {
      for (var n = 1; n <= 7; n++) {
        final d = defaultTrainingDays(n);
        expect(d.length, n);
        expect(d.toSet().length, n);
        expect([...d]..sort(), d);
      }
    });
  });
}
