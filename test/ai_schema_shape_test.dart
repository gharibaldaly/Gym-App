import 'package:flutter_test/flutter_test.dart';
import 'package:ironmind/ai/json_schema.dart';
import 'package:ironmind/features/coach/coach_tools.dart';
import 'package:ironmind/features/exercises/exercise_ai.dart';
import 'package:ironmind/features/nutrition/food_ai.dart';
import 'package:ironmind/features/nutrition/meal_plan_generator.dart';
import 'package:ironmind/features/workout/workout_logic.dart';

import 'schema_shape.dart';

void main() {
  test('every schema sent to the API uses accepted shapes', () {
    final schemas = <String, Object?>{
      'exerciseCreate': exerciseCreateSchema(),
      'workoutPlan': workoutPlanSchema,
      'mealPlan': mealPlanSchema,
      'foodAnalysis': foodAnalysisSchema,
      'mealSwap': mealSwapSchema,
      for (final t in coachTools) 'tool:${t['name']}': t['input_schema'],
    };
    for (final e in schemas.entries) {
      expectApiSafeSchema(strictSchema((e.value as Map).cast<String, dynamic>()), e.key);
    }
  });

  test('union-typed parameters stay within the API limit', () {
    // All coach tools go out with every chat message, so their total counts.
    final tools = unionParamCount(coachTools.map((t) => t['input_schema']));
    expect(tools, lessThanOrEqualTo(maxUnionParams), reason: 'coach tools have $tools nullable parameters');
    for (final e in {
      'exerciseCreate': exerciseCreateSchema(),
      'workoutPlan': workoutPlanSchema,
      'mealPlan': mealPlanSchema,
      'foodAnalysis': foodAnalysisSchema,
      'mealSwap': mealSwapSchema,
    }.entries) {
      expect(unionParamCount([e.value]), lessThanOrEqualTo(maxUnionParams), reason: e.key);
    }
  });
}
