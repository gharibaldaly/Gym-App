import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Builds the meal plan (Egyptian food, grams, macros) with Claude (Opus) and saves it as active.
class MealPlanGenerator {
  final Ref ref;
  MealPlanGenerator(this.ref);

  Future<int> generateAndSave() async => throw UnimplementedError();
}

final mealPlanGeneratorProvider = Provider<MealPlanGenerator>((ref) => MealPlanGenerator(ref));
