import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ironmind/ai/json_schema.dart';
import 'package:ironmind/core/providers.dart';
import 'package:ironmind/features/exercises/exercise_ai.dart';
import 'package:ironmind/features/exercises/exercise_alternatives.dart';
import 'package:ironmind/features/exercises/exercise_history.dart';

SetLog _set(int session, int idx, double w, int reps, {String type = 'normal'}) => SetLog(
      id: session * 100 + idx,
      sessionId: session,
      exerciseId: 'x',
      setIndex: idx,
      weightKg: w,
      reps: reps,
      setType: type,
      isPr: false,
      createdAt: DateTime(2026),
    );

Exercise _ex(String id, {List<String> p = const ['chest'], String? pattern = 'push', String? mech = 'compound', String cat = 'strength'}) =>
    Exercise(
      id: id,
      nameEn: id,
      nameAr: id,
      primaryMusclesJson: jsonEncode(p),
      secondaryMusclesJson: '[]',
      equipment: 'barbell',
      force: 'push',
      movementPattern: pattern,
      mechanic: mech,
      category: cat,
      instructionsEnJson: '[]',
      instructionsArJson: '[]',
      mistakesEnJson: '[]',
      mistakesArJson: '[]',
      imagesJson: '[]',
      isCustom: false,
      isFavorite: false,
      createdAt: DateTime(2026),
    );

void main() {
  group('computeExerciseHistory', () {
    test('empty / warm-up only → empty', () {
      expect(computeExerciseHistory([]).isEmpty, isTrue);
      expect(computeExerciseHistory([(set: _set(1, 0, 40, 10, type: 'warmup'), date: DateTime(2026, 1, 1))]).isEmpty,
          isTrue);
    });

    test('groups sessions, finds last performance and PRs', () {
      final d1 = DateTime(2026, 1, 1), d2 = DateTime(2026, 1, 5), d3 = DateTime(2026, 1, 9);
      final h = computeExerciseHistory([
        (set: _set(2, 1, 82.5, 6), date: d2),
        (set: _set(1, 0, 40, 10, type: 'warmup'), date: d1),
        (set: _set(1, 1, 80, 8), date: d1),
        (set: _set(1, 2, 80, 7), date: d1),
        (set: _set(2, 0, 80, 10), date: d2),
        (set: _set(3, 0, 85, 3), date: d3),
        (set: _set(3, 1, 80, 9), date: d3),
      ]);
      expect(h.sessions.map((s) => s.sessionId), [1, 2, 3]);
      expect(h.sessions.first.sets.length, 2, reason: 'warm-up excluded');
      expect(h.last!.date, d3);
      expect(h.last!.sets.map((s) => s.setIndex), [0, 1]);
      expect(h.prs.heaviest!.weightKg, 85);
      // 80×10 → 106.7 beats 82.5×6 (99) and 85×3 (93.5)
      expect(h.prs.bestE1rm!.weightKg, 80);
      expect(h.prs.bestE1rm!.reps, 10);
      expect(h.prs.repRecords.map((r) => (r.weightKg, r.reps)), [(85.0, 3), (82.5, 6), (80.0, 10)]);
      expect(h.sessions[1].topWeight, 82.5);
      expect(h.sessions[0].volume, 80 * 8 + 80 * 7);
    });
  });

  group('AI exercise create', () {
    test('schema accepts a valid answer and rejects bad enums', () {
      final schema = exerciseCreateSchema();
      final ok = {
        'nameEn': 'Chest Press Machine',
        'nameAr': 'تشيست بريس ماكينة',
        'primaryMuscles': ['chest'],
        'secondaryMuscles': ['triceps', 'shoulders'],
        'equipment': 'machine',
        'force': 'push',
        'mechanic': 'none',
        'category': 'strength',
        'instructionsEn': ['Sit', 'Push'],
        'instructionsAr': ['اقعد', 'ادفع'],
        'mistakesEn': ['Bouncing'],
        'mistakesAr': ['النطّ'],
        'similarExistingIds': [],
      };
      expect(validateJson(ok, schema), isEmpty);
      expect(validateJson({...ok, 'primaryMuscles': ['pecs']}, schema), isNotEmpty);
      expect(validateJson({...ok, 'equipment': 'smith'}, schema), isNotEmpty);
    });

    test('"none" for force / mechanic is stored as unknown', () {
      final d = ExerciseDraft.fromAiJson({
        'nameEn': 'Plank',
        'nameAr': 'بلانك',
        'primaryMuscles': ['abdominals'],
        'secondaryMuscles': [],
        'equipment': 'body only',
        'force': 'none',
        'mechanic': 'none',
        'category': 'strength',
        'instructionsEn': ['Hold'],
        'instructionsAr': ['اثبت'],
        'mistakesEn': [],
        'mistakesAr': [],
        'similarExistingIds': [],
      });
      expect(d.force, isNull);
      expect(d.mechanic, isNull);
    });

    test('draft normalizes muscles and builds a custom companion', () {
      final d = ExerciseDraft.fromAiJson({
        'nameEn': ' Pec Deck ',
        'nameAr': 'بيك دك',
        'primaryMuscles': ['chest', 'chest'],
        'secondaryMuscles': ['chest', 'shoulders'],
        'equipment': 'Machine',
        'force': 'push',
        'mechanic': 'isolation',
        'category': 'bogus',
        'instructionsEn': ['a', ' '],
        'instructionsAr': [],
        'mistakesEn': [],
        'mistakesAr': [],
      });
      expect(d.nameEn, 'Pec Deck');
      expect(d.primaryMuscles, ['chest']);
      expect(d.secondaryMuscles, ['shoulders']);
      expect(d.equipment, 'machine');
      expect(d.category, 'strength');
      expect(d.instructionsEn, ['a']);
      final c = d.toCompanion('custom_1');
      expect(c.isCustom.value, isTrue);
      expect(c.movementPattern.value, 'push');
      expect(c.isFavorite.present, isFalse);
    });

    test('prompt lists candidates with ids', () {
      final p = buildExerciseCreatePrompt(description: 'ماكينة صدر', lang: 'ar', candidates: [_ex('Pec_Deck')], hasPhoto: true);
      expect(p, contains('Pec_Deck |'));
      expect(p, contains('photo'));
    });
  });

  group('alternativeCandidates', () {
    test('excludes the exercise, prefers same pattern/mechanic, demotes stretches', () {
      final ex = _ex('bench');
      final list = alternativeCandidates(ex, [
        ex,
        _ex('stretch', pattern: 'stretch', mech: null, cat: 'stretching'),
        _ex('fly', mech: 'isolation'),
        _ex('db_press'),
      ]);
      expect(list.map((e) => e.id), ['db_press', 'fly', 'stretch']);
      expect(buildAlternativesPrompt(ex, list, reason: 'shoulder pain'), contains('shoulder pain'));
    });
  });
}
