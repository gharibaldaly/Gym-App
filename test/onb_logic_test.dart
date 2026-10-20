import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:ironmind/core/calc/nutrition_calc.dart';
import 'package:ironmind/core/providers.dart';
import 'package:ironmind/features/onboarding/onboarding_logic.dart';

import 'onb_fixtures.dart';

void main() {
  group('parseNum', () {
    test('accepts western, Arabic-Indic and Persian digits', () {
      expect(parseNum('82.5'), 82.5);
      expect(parseNum('٨٢٫٥'), 82.5);
      expect(parseNum('۱۷۸'), 178);
      expect(parseNum('82,5'), 82.5);
    });
    test('empty / invalid → null', () {
      expect(parseNum(''), isNull);
      expect(parseNum(null), isNull);
      expect(parseNum('abc'), isNull);
    });
  });

  group('body shape → body fat', () {
    test('female estimates are higher than male for the same shape', () {
      for (final s in BodyShape.values) {
        expect(bodyFatForShape(s, 'female'), greaterThan(bodyFatForShape(s, 'male')));
      }
    });
    test('estimates increase from lean to heavy', () {
      for (final sex in ['male', 'female']) {
        final values = BodyShape.values.map((s) => bodyFatForShape(s, sex)).toList();
        expect(values, orderedEquals([...values]..sort()));
      }
    });
    test('null sex uses the male table', () {
      expect(bodyFatForShape(BodyShape.average, null), bodyFatForShape(BodyShape.average, 'male'));
    });
    test('nearest shape round-trips and snaps to the closest', () {
      for (final sex in ['male', 'female']) {
        for (final s in BodyShape.values) {
          expect(nearestBodyShape(bodyFatForShape(s, sex), sex), s);
        }
      }
      expect(nearestBodyShape(11, 'male'), BodyShape.lean);
      expect(nearestBodyShape(45, 'female'), BodyShape.heavy);
    });
    test('changing sex keeps the shape but re-estimates the %', () {
      final male = bodyFatForShape(BodyShape.athletic, 'male');
      expect(reestimateShapeBodyFat(method: 'shape', pct: male, oldSex: 'male', newSex: 'female'),
          bodyFatForShape(BodyShape.athletic, 'female'));
      expect(reestimateShapeBodyFat(method: 'number', pct: 15, oldSex: 'male', newSex: 'female'), isNull);
      expect(reestimateShapeBodyFat(method: 'shape', pct: male, oldSex: 'male', newSex: 'male'), isNull);
    });
  });

  group('weekdays (Egypt order)', () {
    test('week starts on Saturday and ends on Friday', () {
      expect(egyptWeekOrder.first, DateTime.saturday);
      expect(egyptWeekOrder.last, DateTime.friday);
      expect(egyptWeekOrder.toSet().length, 7);
    });
    test('sorts, dedupes and drops invalid values', () {
      expect(sortWeekdaysEgypt([1, 6, 5, 7, 1, 9]), [6, 7, 1, 5]);
    });
    test('suggestions have exactly N days, Friday only when 7', () {
      for (var n = 1; n <= 7; n++) {
        final s = suggestTrainingDays(n);
        expect(s.length, n);
        expect(s.toSet().length, n);
        expect(s, sortWeekdaysEgypt(s));
        if (n < 7) expect(s.contains(DateTime.friday), isFalse);
      }
    });
    test('toggle adds/removes and keeps order', () {
      expect(toggleWeekday([6, 1], 7), [6, 7, 1]);
      expect(toggleWeekday([6, 7, 1], 7), [6, 1]);
    });
    test('validation enforces the count', () {
      final p = completeProfile();
      expect(validateStep(OnbStep.days, p), isNull);
      final wrong = p.copyWithCompanion(UserProfilesCompanion(trainingDaysJson: Value(jsonEncode([6, 7, 1]))));
      expect(validateStep(OnbStep.days, wrong), OnbIssue.daysMismatch);
      final none = p.copyWithCompanion(const UserProfilesCompanion(daysPerWeek: Value(null)));
      expect(validateStep(OnbStep.days, none), OnbIssue.daysCountRequired);
    });
  });

  group('meal times', () {
    test('suggests N sorted times between wake and bed', () {
      final t = suggestMealTimes(4, wake: '07:00', sleep: '23:00');
      expect(t, ['08:00', '12:15', '16:15', '20:30']);
    });
    test('handles bedtime after midnight', () {
      final t = suggestMealTimes(3, wake: '10:00', sleep: '02:00');
      expect(t.length, 3);
      expect(t.first, '11:00');
      expect(t.last, '23:30');
    });
    test('always at least ~2 h apart', () {
      final t = suggestMealTimes(6, wake: '07:00', sleep: '15:00');
      int m(String s) => int.parse(s.split(':')[0]) * 60 + int.parse(s.split(':')[1]);
      for (var i = 1; i < t.length; i++) {
        expect((m(t[i]) - m(t[i - 1])) % 1440, greaterThanOrEqualTo(105));
      }
    });
    test('resize keeps user times', () {
      expect(resizeMealTimes(['09:00', '14:00', '21:00'], 2), ['09:00', '14:00']);
      final grown = resizeMealTimes(['09:30'], 3, wake: '07:00', sleep: '23:00');
      expect(grown.length, 3);
      expect(grown.contains('09:30'), isTrue);
    });
    test('sleep hours wraps midnight', () {
      expect(sleepHours('23:30', '07:00'), 7.5);
      expect(sleepHours('01:00', '09:00'), 8);
      expect(sleepHours(null, '09:00'), isNull);
    });
  });

  group('chip text', () {
    test('splits known codes from free text (case-insensitive, Arabic comma)', () {
      final s = splitChipText('Eggs, chicken، mango; koshari\nfeteer', egyptianFoods);
      expect(s.codes, ['eggs', 'chicken', 'koshari']);
      expect(s.other, 'mango, feteer');
    });
    test('join orders codes then appends free text', () {
      expect(joinChipText({'rice', 'eggs'}, 'mango', order: egyptianFoods), 'eggs, rice, mango');
      expect(joinChipText(const [], '  '), isNull);
    });
    test('round trip', () {
      const text = 'ful medames, tuna, homemade pizza';
      final s = splitChipText(text, egyptianFoods);
      expect(joinChipText(s.codes, s.other, order: egyptianFoods), text);
    });
  });

  group('supplements', () {
    test('json round trip keeps name/dose keys other features read', () {
      final list = [
        entryFromTemplate(supplementTemplate('whey')!, name: 'Whey', dose: '1 scoop'),
        const SupplementEntry(name: 'Creatine', dose: '5 g', timing: 'morning'),
      ];
      final json = encodeSupplements(list);
      final raw = (jsonDecode(json) as List).cast<Map<String, dynamic>>();
      expect(raw.first['name'], 'Whey');
      expect(raw.first['dose'], '1 scoop');
      final back = parseSupplements(json);
      expect(back.first.proteinG, 24);
      expect(back.first.key, 'whey');
      expect(back.last.timing, 'morning');
      expect(back.last.hasMacros, isFalse);
    });
    test('protein templates have consistent macros', () {
      for (final key in ['whey', 'casein', 'mass_gainer']) {
        final t = supplementTemplate(key)!;
        final kcal = NutritionCalc.macroCalories(protein: t.proteinG, carbs: t.carbsG, fat: t.fatG);
        expect((kcal - t.calories).abs() / t.calories, lessThan(0.08), reason: key);
      }
    });
    test('invalid json → empty list', () {
      expect(parseSupplements('oops'), isEmpty);
    });
    test('unnamed supplement blocks the step', () {
      final p = completeProfile().copyWithCompanion(UserProfilesCompanion(
        supplementsJson: Value(encodeSupplements([const SupplementEntry(name: ' ')])),
      ));
      expect(validateStep(OnbStep.supplements, p), OnbIssue.suppNameRequired);
    });
  });

  group('validation', () {
    test('complete profile passes every step', () {
      expect(firstInvalidStep(completeProfile()), isNull);
    });
    test('blank profile fails at body stats first', () {
      expect(firstInvalidStep(blankProfile()), OnbStep.body);
      expect(validateStep(OnbStep.body, blankProfile()), OnbIssue.sexRequired);
    });
    test('optional steps pass when empty', () {
      for (final s in [OnbStep.language, OnbStep.measurements, OnbStep.focus, OnbStep.injuries, OnbStep.foods,
        OnbStep.supplements, OnbStep.healthConnect, OnbStep.apiKey]) {
        expect(validateStep(s, blankProfile()), isNull, reason: s.name);
      }
    });
    test('body stat ranges', () {
      UserProfile w(UserProfilesCompanion c) => completeProfile().copyWithCompanion(c);
      expect(validateStep(OnbStep.body, w(const UserProfilesCompanion(age: Value(8)))), OnbIssue.ageRange);
      expect(validateStep(OnbStep.body, w(const UserProfilesCompanion(heightCm: Value(90)))), OnbIssue.heightRange);
      expect(validateStep(OnbStep.body, w(const UserProfilesCompanion(weightKg: Value(400)))), OnbIssue.weightRange);
    });
    test('body fat method rules', () {
      UserProfile w(String? m, double? pct) => completeProfile()
          .copyWithCompanion(UserProfilesCompanion(bodyFatMethod: Value(m), bodyFatPct: Value(pct)));
      expect(validateStep(OnbStep.bodyFat, w(null, null)), OnbIssue.bodyFatChoice);
      expect(validateStep(OnbStep.bodyFat, w('number', null)), OnbIssue.bodyFatRange);
      expect(validateStep(OnbStep.bodyFat, w('number', 18)), isNull);
      expect(validateStep(OnbStep.bodyFat, w('shape', null)), OnbIssue.bodyFatChoice);
      expect(validateStep(OnbStep.bodyFat, w('shape', 20)), isNull);
      expect(validateStep(OnbStep.bodyFat, w('unknown', null)), isNull);
    });
    test('measurements out of range', () {
      final p = completeProfile().copyWithCompanion(
          UserProfilesCompanion(measurementsJson: Value(encodeMeasurements({'waist': 5}))));
      expect(validateStep(OnbStep.measurements, p), OnbIssue.measurementRange);
    });
    test('cardio needs times per week unless none', () {
      final p = completeProfile();
      expect(
          validateStep(OnbStep.cardio, p.copyWithCompanion(const UserProfilesCompanion(cardioPerWeek: Value(0)))),
          OnbIssue.cardioPerWeekRequired);
      expect(
          validateStep(
              OnbStep.cardio,
              p.copyWithCompanion(
                  const UserProfilesCompanion(cardioType: Value('none'), cardioPerWeek: Value(0)))),
          isNull);
    });
    test('meal times must match meal count', () {
      final p = completeProfile().copyWithCompanion(const UserProfilesCompanion(mealsPerDay: Value(5)));
      expect(validateStep(OnbStep.meals, p), OnbIssue.mealTimesMismatch);
    });
    test('budget: level or a sane number', () {
      final p = completeProfile();
      expect(
          validateStep(OnbStep.budget,
              p.copyWithCompanion(const UserProfilesCompanion(budgetLevel: Value(null), budgetEgp: Value(50)))),
          OnbIssue.budgetRange);
      expect(
          validateStep(OnbStep.budget,
              p.copyWithCompanion(const UserProfilesCompanion(budgetLevel: Value(null), budgetEgp: Value(6000)))),
          isNull);
      expect(
          validateStep(OnbStep.budget,
              p.copyWithCompanion(const UserProfilesCompanion(budgetLevel: Value(null), budgetEgp: Value(null)))),
          OnbIssue.choiceRequired);
    });
    test('water range', () {
      expect(
          validateStep(
              OnbStep.water, completeProfile().copyWithCompanion(const UserProfilesCompanion(waterGoalMl: Value(500)))),
          OnbIssue.waterRange);
    });
  });

  group('goal helpers', () {
    test('warning when target goes the wrong way', () {
      final p = completeProfile();
      expect(goalWarning(p.copyWithCompanion(const UserProfilesCompanion(targetWeightKg: Value(90)))),
          GoalWarning.cutTargetAbove);
      expect(
          goalWarning(p.copyWithCompanion(const UserProfilesCompanion(goal: Value('bulk'), targetWeightKg: Value(75)))),
          GoalWarning.bulkTargetBelow);
      expect(goalWarning(p.copyWithCompanion(const UserProfilesCompanion(targetWeightKg: Value(76)))), isNull);
    });
    test('suggested weeks: ~0.5%/week cut, ~0.25%/week bulk', () {
      expect(suggestGoalWeeks(80, 76), 10); // 4 kg / 0.4 kg
      expect(suggestGoalWeeks(80, 84), 20); // 4 kg / 0.2 kg
      expect(suggestGoalWeeks(80, 80.2), isNull);
    });
  });

  group('prefill', () {
    test('sleep and water get defaults only when missing', () {
      final b = blankProfile().copyWithCompanion(const UserProfilesCompanion(weightKg: Value(80)));
      final sleep = prefillPatch(OnbStep.sleep, b)!;
      expect(sleep.sleepTime.value, defaultSleepTime);
      expect(sleep.wakeTime.value, defaultWakeTime);
      expect(prefillPatch(OnbStep.water, b)!.waterGoalMl.value, NutritionCalc.waterGoalMl(80));
      expect(prefillPatch(OnbStep.sleep, completeProfile()), isNull);
      expect(prefillPatch(OnbStep.water, completeProfile()), isNull);
      expect(prefillPatch(OnbStep.goal, b), isNull);
    });
  });

  group('step metadata', () {
    test('24 steps, summary last', () {
      expect(OnbStep.values.length, 24);
      expect(OnbStep.values.last, OnbStep.summary);
    });
    test('only Health Connect and API key are skippable', () {
      expect(OnbStep.values.where((s) => s.skippable), [OnbStep.healthConnect, OnbStep.apiKey]);
    });
  });
}
