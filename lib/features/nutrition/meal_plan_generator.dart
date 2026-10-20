import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../ai/ai_service.dart';
import '../../core/providers.dart';
import '../../data/repositories/profile_repository.dart';
import 'egyptian_foods.dart';
import 'nutrition_logic.dart';
import 'nutrition_providers.dart';

/// Outcome of a plan generation.
class MealPlanResult {
  final int planId;

  /// False when the offline template builder was used (no key / offline).
  final bool usedAi;
  final Object? fallbackReason;
  const MealPlanResult(this.planId, {required this.usedAi, this.fallbackReason});
}

const _mealSchema = {
  'type': 'object',
  'properties': {
    'nameAr': {'type': 'string', 'description': 'Meal name in Egyptian Arabic, e.g. الفطار'},
    'nameEn': {'type': 'string', 'description': 'Meal name in English, e.g. Breakfast'},
    'time': {'type': 'string', 'description': 'HH:mm'},
    'items': {
      'type': 'array',
      'items': {
        'type': 'object',
        'properties': {
          'nameAr': {'type': 'string'},
          'nameEn': {'type': 'string'},
          'grams': {'type': 'number', 'description': 'cooked / ready-to-eat grams'},
          'calories': {'type': 'number'},
          'protein': {'type': 'number'},
          'carbs': {'type': 'number'},
          'fat': {'type': 'number'},
        },
        'required': ['nameAr', 'nameEn', 'grams', 'calories', 'protein', 'carbs', 'fat'],
      },
    },
  },
  'required': ['nameAr', 'nameEn', 'time', 'items'],
};

const _totalsSchema = {
  'type': 'object',
  'properties': {
    'calories': {'type': 'number'},
    'protein': {'type': 'number'},
    'carbs': {'type': 'number'},
    'fat': {'type': 'number'},
  },
  'required': ['calories', 'protein', 'carbs', 'fat'],
};

const _daySchema = {
  'type': 'object',
  'properties': {
    'meals': {'type': 'array', 'items': _mealSchema},
    'totals': _totalsSchema,
  },
  'required': ['meals', 'totals'],
};

const mealPlanSchema = {
  'type': 'object',
  'properties': {
    'name': {'type': 'string', 'description': 'Short plan name in the user language'},
    'notes': {'type': 'string', 'description': '2–5 short practical tips in the user language'},
    'trainingDay': _daySchema,
    'restDay': _daySchema,
  },
  'required': ['name', 'notes', 'trainingDay', 'restDay'],
};

String _foodTableHint() => egyptianFoods
    .where((f) => f.category != FoodCategory.supplement)
    .map((f) => '${f.nameAr}/${f.nameEn}: ${f.kcal.round()} kcal, P${f.protein} C${f.carbs} F${f.fat} per 100g'
        '${f.unitGrams != null ? ' (1 ${f.unitEn} ≈ ${f.unitGrams!.round()} g)' : ''}')
    .join('\n');

const _defaultTargets = MacroTargets(calories: 2200, protein: 150, carbs: 240, fat: 70);

/// Builds the meal plan (Egyptian food, grams, macros) with Claude (Opus) and saves it as active.
class MealPlanGenerator {
  final Ref ref;
  MealPlanGenerator(this.ref);

  /// Generates with Claude (falls back to the local template plan when there's
  /// no API key or no internet) and saves it as the active plan. Returns its id.
  Future<int> generateAndSave() async => (await generate()).planId;

  /// Like [generateAndSave] but tells whether AI was used.
  /// With [allowTemplateFallback] false, AI errors (incl. no key/offline) are rethrown.
  Future<MealPlanResult> generate({bool allowTemplateFallback = true, String? extraInstructions}) async {
    final profileRepo = ref.read(profileRepositoryProvider);
    var p = await profileRepo.get();
    if (p != null && p.calorieTarget == null) {
      await profileRepo.recomputeTargets();
      p = await profileRepo.get();
    }
    try {
      final draft = await _generateWithAi(p, extraInstructions: extraInstructions);
      final id = await ref.read(nutritionRepositoryProvider).savePlan(draft);
      return MealPlanResult(id, usedAi: true);
    } on AiException catch (e) {
      final noAi = e is AiNoKeyException || e is AiOfflineException;
      if (!allowTemplateFallback || !noAi) rethrow;
      return MealPlanResult(await _saveTemplate(p), usedAi: false, fallbackReason: e);
    }
  }

  /// Local, offline plan from the built-in Egyptian food table.
  Future<int> buildTemplateAndSave() async => _saveTemplate(await ref.read(profileRepositoryProvider).get());

  Future<int> _saveTemplate(UserProfile? p) {
    final draft = buildTemplatePlan(
      training: targetsForDayType(p, training: true) ?? _defaultTargets,
      rest: targetsForDayType(p, training: false) ?? _defaultTargets,
      mealsPerDay: p?.mealsPerDay ?? 4,
      mealTimes: p?.mealTimes ?? const [],
      dislikes: p?.dislikedFoods,
      allergies: p?.allergies,
      lowBudget: p?.budgetLevel == 'low' || ((p?.budgetEgp ?? 99999) < 4000),
    );
    return ref.read(nutritionRepositoryProvider).savePlan(draft);
  }

  Future<PlanDraft> _generateWithAi(UserProfile? p, {String? extraInstructions}) async {
    final training = targetsForDayType(p, training: true) ?? _defaultTargets;
    final rest = targetsForDayType(p, training: false) ?? _defaultTargets;
    final meals = (p?.mealsPerDay ?? 4).clamp(2, 6);
    final lang = p?.language ?? ref.read(localeProvider);
    final times = p?.mealTimes ?? const <String>[];

    const stable = '''
You are an expert sports dietitian in Egypt building a full daily meal plan for a gym-goer.
Rules:
- Use Egyptian, locally-available, affordable foods (فول، بيض، فراخ، تونة، أرز، عيش بلدي، زبادي،
  جبنة قريش، كشري، لحمة مفرومة، بطاطس، شوفان، موز، عدس، سمك بلطي، طحينة…). Home-style Egyptian meals.
- Respect the monthly food budget in EGP (low budget → eggs, foul, lentils, chicken legs, areesh,
  rice, baladi bread; avoid expensive items), likes, dislikes and allergies strictly.
- Exactly the requested number of meals per day, at the requested times.
- Two day types: trainingDay (higher carbs, put more carbs around the workout) and restDay.
- Every item has realistic cooked/ready-to-eat grams and macros from standard tables;
  item calories ≈ 4·protein + 4·carbs + 9·fat.
- Daily totals (sum of all items) MUST be within ±10% of that day's calorie, protein, carb and fat
  targets. Double-check the arithmetic before answering; "totals" must equal the sum of the items.
- Don't list supplements as meals; the user's supplements are counted separately.
- Meal and item names in both Egyptian Arabic (nameAr) and English (nameEn).

Reference values (per 100 g):
''';
    final prompt = StringBuffer()
      ..writeln('User profile (JSON):')
      ..writeln(p?.toPromptSummary() ?? '{}')
      ..writeln()
      ..writeln('Targets — trainingDay: ${training.toJson()}; restDay: ${rest.toJson()}.')
      ..writeln('Meals per day: $meals${times.length == meals ? ' at ${times.join(', ')}' : ''}.')
      ..writeln('Training time of day: ${p?.trainingTimeOfDay ?? '-'} ${p?.trainingTime ?? ''}.')
      ..writeln('Write "name" and "notes" in ${lang == 'ar' ? 'Egyptian Arabic' : 'English'}.');
    if (extraInstructions != null && extraInstructions.trim().isNotEmpty) {
      prompt.writeln('Extra request from the user: ${extraInstructions.trim()}');
    }

    final json = await ref.read(aiServiceProvider).structured(
          feature: AiFeature.mealPlan,
          system: AiService.systemBlocks('$stable${_foodTableHint()}'),
          prompt: prompt.toString(),
          schema: mealPlanSchema,
          extraValidate: (j) => validateMealPlanJson(j, training: training, rest: rest, mealsPerDay: meals),
          maxTokens: 16000,
        );
    return PlanDraft.fromJson(json, source: 'ai');
  }
}

final mealPlanGeneratorProvider = Provider<MealPlanGenerator>((ref) => MealPlanGenerator(ref));
