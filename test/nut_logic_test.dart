import 'package:flutter_test/flutter_test.dart';
import 'package:ironmind/core/calc/nutrition_calc.dart';
import 'package:ironmind/features/nutrition/egyptian_foods.dart';
import 'package:ironmind/features/nutrition/food_ai.dart';
import 'package:ironmind/features/nutrition/nutrition_logic.dart';

FoodEntry _e(String id, double g) => FoodEntry.fromFood(food(id), g);

void main() {
  group('built-in food table', () {
    test('macros per grams scale linearly', () {
      final m = food('rice').macrosFor(250);
      expect(m.calories, closeTo(325, 0.01));
      expect(m.carbs, closeTo(70, 0.01));
      expect(m.protein, closeTo(6.75, 0.01));
    });

    test('table values are internally consistent (kcal ≈ 4P + 4C + 9F)', () {
      for (final f in egyptianFoods) {
        final computed = NutritionCalc.macroCalories(protein: f.protein, carbs: f.carbs, fat: f.fat);
        expect((computed - f.kcal).abs(), lessThanOrEqualTo(f.kcal * 0.15 + 8), reason: f.id);
      }
    });

    test('ids are unique and countable foods have units', () {
      expect(egyptianFoodsById.length, egyptianFoods.length);
      for (final f in egyptianFoods.where((f) => f.countable)) {
        expect(f.unitGrams, isNotNull, reason: f.id);
        expect(f.unitAr, isNotNull, reason: f.id);
        expect(f.unitEn, isNotNull, reason: f.id);
      }
    });

    test('matching AI names to the table', () {
      expect(matchEgyptianFood('بيضتين مسلوق', null)?.id, 'egg');
      expect(matchEgyptianFood('بياض بيض', null)?.id, 'egg_white');
      expect(matchEgyptianFood(null, 'Grilled chicken breast')?.id, 'chicken_breast');
      expect(matchEgyptianFood('ورك فراخ مشوي', null)?.id, 'chicken_leg');
      expect(matchEgyptianFood('زيت زيتون', null)?.id, 'olive_oil');
      expect(matchEgyptianFood('طبق كشري وسط', null)?.id, 'koshary');
      expect(matchEgyptianFood('زبدة فول سوداني', null)?.id, 'peanut_butter');
      expect(matchEgyptianFood('Something unknown', 'xyz'), isNull);
    });

    test('search finds Arabic and English', () {
      expect(searchEgyptianFoods('فول').map((f) => f.id), contains('foul'));
      expect(searchEgyptianFoods('tuna').map((f) => f.id), contains('tuna_water'));
      expect(searchEgyptianFoods('').length, egyptianFoods.length);
    });
  });

  group('macro scaling', () {
    test('changing grams scales macros proportionally', () {
      final e = _e('chicken_breast', 200);
      final half = e.withGrams(100);
      expect(half.calories, closeTo(165, 0.01));
      expect(half.protein, closeTo(31, 0.01));
      expect(half.fat, closeTo(3.6, 0.01));
      final big = e.withGrams(300);
      expect(big.calories, closeTo(e.calories * 1.5, 0.01));
    });

    test('AI item with unknown grams keeps its macros', () {
      const e = FoodEntry(nameAr: 'x', nameEn: 'x', grams: 0, calories: 100, protein: 5, carbs: 10, fat: 4);
      final s = e.withGrams(50);
      expect(s.grams, 50);
      expect(s.calories, 100);
    });

    test('scaleMeal and sumEntries', () {
      final meal = [_e('egg', 100), _e('baladi_bread', 90)];
      final half = sumEntries(scaleMeal(meal, 0.5));
      final full = sumEntries(meal);
      expect(half.calories, closeTo(full.calories / 2, 0.001));
      expect(full.calories, closeTo(143 + 229.5, 0.01));
    });

    test('JSON round trip and tolerant parsing', () {
      final items = [_e('egg', 100), _e('foul', 150)];
      final back = decodeItems(encodeItems(items));
      expect(back.length, 2);
      expect(back.first.foodId, 'egg');
      expect(back[1].grams, 150);
      final legacy = FoodEntry.fromJson({'name': 'Rice', 'grams': '200', 'calories': 260});
      expect(legacy.nameAr, 'Rice');
      expect(legacy.grams, 200);
      expect(decodeItems('not json'), isEmpty);
    });

    test('bilingual names', () {
      final s = joinBilingual('الفطار', 'Breakfast');
      expect(pickBilingual(s, 'ar'), 'الفطار');
      expect(pickBilingual(s, 'en'), 'Breakfast');
      expect(pickBilingual('Only one', 'ar'), 'Only one');
    });
  });

  group('totals validation', () {
    const t = MacroTargets(calories: 2500, protein: 180, carbs: 280, fat: 75);

    Map<String, dynamic> planWith(List<FoodEntry> training, List<FoodEntry> rest) => {
          'name': 'x',
          'notes': '',
          'trainingDay': {
            'meals': [
              {'nameAr': 'أ', 'nameEn': 'A', 'time': '09:00', 'items': training.map((e) => e.toJson()).toList()}
            ],
            'totals': {'calories': 0, 'protein': 0, 'carbs': 0, 'fat': 0},
          },
          'restDay': {
            'meals': [
              {'nameAr': 'أ', 'nameEn': 'A', 'time': '09:00', 'items': rest.map((e) => e.toJson()).toList()}
            ],
            'totals': {'calories': 0, 'protein': 0, 'carbs': 0, 'fat': 0},
          },
        };

    FoodEntry exact(MacroTargets m) => FoodEntry(
        nameAr: 'x', nameEn: 'x', grams: 100, calories: m.calories, protein: m.protein, carbs: m.carbs, fat: m.fat);

    test('withinTolerance', () {
      expect(withinTolerance(109, 100), isTrue);
      expect(withinTolerance(111, 100), isFalse);
      expect(withinTolerance(91, 100), isTrue);
      expect(withinTolerance(14, 10, minSlack: 5), isTrue);
    });

    test('plan inside ±10% passes', () {
      final j = planWith([exact(t.scale(1.05))], [exact(t.scale(0.95))]);
      expect(validateMealPlanJson(j, training: t, rest: t), isEmpty);
    });

    test('plan outside ±10% fails with useful errors (totals computed from items)', () {
      final j = planWith([exact(t.scale(1.2))], [exact(t)]);
      final errors = validateMealPlanJson(j, training: t, rest: t);
      expect(errors, isNotEmpty);
      expect(errors.every((e) => e.startsWith('trainingDay')), isTrue);
      expect(errors.join(' '), contains('calories'));
    });

    test('meal count and empty items are enforced', () {
      final j = planWith([exact(t)], [exact(t)]);
      expect(validateMealPlanJson(j, training: t, rest: t, mealsPerDay: 3).length, 2);
      final empty = planWith([], [exact(t)]);
      expect(validateMealPlanJson(empty, training: t, rest: t), isNotEmpty);
    });

    test('carb cycling day targets', () {
      final tr = MacroTargets.forDay(calorieTarget: 2500, proteinG: 180, carbsG: 280, fatG: 75, dayCarbsG: 320);
      expect(tr.carbs, 320);
      expect(tr.calories, 2500 + 160);
      final rest = MacroTargets.forDay(calorieTarget: 2500, proteinG: 180, carbsG: 280, fatG: 75, dayCarbsG: 250);
      expect(rest.calories, 2500 - 120);
    });

    test('food analysis + swap validation', () {
      expect(
          validateFoodAnalysisJson({
            'confidence': 1.4,
            'items': [
              {'grams': -1, 'calories': 10, 'protein': 1, 'carbs': 1, 'fat': 1}
            ]
          }).length,
          2);
      final target = sumEntries([_e('chicken_breast', 200), _e('rice', 250)]);
      final ok = {
        'alternatives': [
          {'items': [_e('tilapia', 240).toJson(), _e('rice', 250).toJson()]},
          {'items': [_e('chicken_breast', 200).toJson(), _e('potato', 380).toJson()]},
        ]
      };
      expect(validateSwapJson(ok, target), isEmpty);
      final bad = {
        'alternatives': [
          {'items': [_e('rice', 100).toJson()]},
        ]
      };
      expect(validateSwapJson(bad, target), isNotEmpty);
    });
  });

  group('template plan', () {
    for (final meals in [2, 3, 4, 5, 6]) {
      test('$meals meals/day hits targets within ±10%', () {
        final tr = MacroTargets.forDay(calorieTarget: 2600, proteinG: 170, carbsG: 300, fatG: 80, dayCarbsG: 345);
        final rest = MacroTargets.forDay(calorieTarget: 2600, proteinG: 170, carbsG: 300, fatG: 80, dayCarbsG: 255);
        final plan = buildTemplatePlan(training: tr, rest: rest, mealsPerDay: meals);
        expect(plan.trainingDay.length, meals);
        expect(plan.restDay.length, meals);
        expect(validateMealPlanJson(plan.toJson(), training: tr, rest: rest, mealsPerDay: meals), isEmpty);
        // training day carries more carbs than rest day
        expect(plan.totalsFor(training: true).carbs, greaterThan(plan.totalsFor(training: false).carbs));
      });
    }

    test('cutting targets for a small person still validate', () {
      final t = NutritionCalc.compute(male: false, weightKg: 58, heightCm: 160, age: 28, goal: 'cut', trainingDays: 3);
      final tr = MacroTargets.forDay(
          calorieTarget: t.calories, proteinG: t.proteinG, carbsG: t.carbsG, fatG: t.fatG, dayCarbsG: t.trainingDayCarbsG);
      final rest = MacroTargets.forDay(
          calorieTarget: t.calories, proteinG: t.proteinG, carbsG: t.carbsG, fatG: t.fatG, dayCarbsG: t.restDayCarbsG);
      final plan = buildTemplatePlan(training: tr, rest: rest, mealsPerDay: 4);
      expect(validateMealPlanJson(plan.toJson(), training: tr, rest: rest), isEmpty);
    });

    test('sweep of realistic profiles validates (all goals, sizes, meal counts)', () {
      final failures = <String>[];
      for (final male in [true, false]) {
        for (final w in [55.0, 70.0, 85.0, 100.0, 120.0]) {
          for (final goal in ['bulk', 'cut', 'recomp', 'strength', 'fitness']) {
            for (final days in [2, 3, 4, 5]) {
              for (final meals in [3, 4, 5]) {
                final t = NutritionCalc.compute(
                    male: male, weightKg: w, heightCm: male ? 178 : 163, age: 30, goal: goal, trainingDays: days);
                final tr = MacroTargets.forDay(
                    calorieTarget: t.calories, proteinG: t.proteinG, carbsG: t.carbsG, fatG: t.fatG,
                    dayCarbsG: t.trainingDayCarbsG);
                final rest = MacroTargets.forDay(
                    calorieTarget: t.calories, proteinG: t.proteinG, carbsG: t.carbsG, fatG: t.fatG,
                    dayCarbsG: t.restDayCarbsG);
                // Keto-level carb targets can't be met by any carb-free Egyptian template.
                if (tr.carbs < 30 || rest.carbs < 30) continue;
                final plan = buildTemplatePlan(training: tr, rest: rest, mealsPerDay: meals);
                final errs = validateMealPlanJson(plan.toJson(), training: tr, rest: rest, mealsPerDay: meals);
                if (errs.isNotEmpty) failures.add('$male $w $goal $days $meals: $errs');
              }
            }
          }
        }
      }
      expect(failures, isEmpty);
    });

    test('respects dislikes/allergies and budget', () {
      const t = MacroTargets(calories: 2500, protein: 170, carbs: 290, fat: 75);
      final plan = buildTemplatePlan(
          training: t, rest: t, mealsPerDay: 4, dislikes: 'تونة، سمك', allergies: 'lactose', lowBudget: true);
      final ids = [...plan.trainingDay, ...plan.restDay].expand((m) => m.items).map((e) => e.foodId).toSet();
      expect(ids, isNot(contains('tuna_water')));
      expect(ids, isNot(contains('tilapia')));
      expect(ids.where((id) => food(id!).category == FoodCategory.dairy), isEmpty);
      expect(ids, isNot(contains('olive_oil')), reason: 'low budget prefers cooking oil');
      expect(validateMealPlanJson(plan.toJson(), training: t, rest: t), isEmpty);
    });

    test('uses profile meal times when they match the meal count', () {
      const t = MacroTargets(calories: 2400, protein: 160, carbs: 270, fat: 75);
      final plan = buildTemplatePlan(training: t, rest: t, mealsPerDay: 3, mealTimes: ['07:00', '13:00', '20:00']);
      expect(plan.trainingDay.map((m) => m.time), ['07:00', '13:00', '20:00']);
    });

    test('eggs come in whole eggs, bread in half loaves', () {
      expect(roundGrams(food('egg'), 130), 150);
      expect(roundGrams(food('baladi_bread'), 100), 90);
      expect(roundGrams(food('baladi_bread'), 30), 45);
      expect(roundGrams(food('rice'), 212), 210);
    });
  });

  group('grocery list', () {
    test('aggregates planned items × training/rest days and groups by food', () {
      final training = [_e('egg', 150), _e('rice', 300), _e('chicken_breast', 200)];
      final rest = [_e('egg', 100), _e('rice', 150), _e('chicken_breast', 200)];
      final list = buildGroceryList(trainingDayItems: training, restDayItems: rest, trainingDays: 4, restDays: 3);
      final byKey = {for (final l in list) l.key: l};
      expect(byKey['egg']!.grams, 150 * 4 + 100 * 3);
      expect(byKey['rice']!.grams, 300 * 4 + 150 * 3);
      expect(byKey['chicken_breast']!.grams, 200 * 7);
      expect(list.length, 3);
    });

    test('AI-named items merge with table foods and unknown items by name', () {
      const a = FoodEntry(nameAr: 'بيض مسلوق', nameEn: 'Boiled eggs', grams: 100, calories: 0, protein: 0, carbs: 0, fat: 0);
      const odd = FoodEntry(nameAr: 'كينوا', nameEn: 'Quinoa', grams: 80, calories: 0, protein: 0, carbs: 0, fat: 0);
      final list = buildGroceryList(
          trainingDayItems: [a, _e('egg', 50), odd], restDayItems: [odd], trainingDays: 2, restDays: 5);
      final byKey = {for (final l in list) l.key: l};
      expect(byKey['egg']!.grams, 300);
      expect(byKey['quinoa']!.grams, 80 * 7);
      expect(byKey['quinoa']!.food, isNull);
    });

    test('nice units', () {
      String fmt(GroceryLine l, String lang) =>
          formatGroceryQty(l, lang, gramUnit: 'g', kgUnit: 'kg', literUnit: 'L');
      final list = buildGroceryList(
        trainingDayItems: [_e('egg', 200), _e('rice', 300), _e('baladi_bread', 135), _e('milk', 250), _e('tahini', 15)],
        restDayItems: const [],
        trainingDays: 7,
        restDays: 0,
      );
      final byKey = {for (final l in list) l.key: l};
      expect(fmt(byKey['egg']!, 'en'), '28 eggs');
      expect(fmt(byKey['egg']!, 'ar'), '28 بيضة');
      expect(fmt(byKey['rice']!, 'en'), '2.25 kg');
      expect(fmt(byKey['baladi_bread']!, 'en'), '11 loaves');
      expect(fmt(byKey['milk']!, 'en'), '1.75 L');
      expect(fmt(byKey['tahini']!, 'en'), '150 g');
    });
  });
}
