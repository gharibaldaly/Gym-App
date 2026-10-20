/// Model names, pricing and per-feature routing for Claude.
/// Model ids can be overridden from Settings → AI models.
library;

enum ModelTier { haiku, sonnet, opus }

class AiDefaults {
  static const apiUrl = 'https://api.anthropic.com/v1/messages';
  static const apiVersion = '2023-06-01';

  static const haiku = 'claude-haiku-5-5';
  static const sonnet = 'claude-sonnet-5-5';
  static const opus = 'claude-opus-5-5';

  /// Beta header for server-side refusal fallbacks (`fallbacks: "default"`).
  static const fallbackBeta = 'server-side-fallback-2026-07-01';
}

/// USD per 1M tokens. Unknown models fall back to the tier price.
class ModelPrice {
  final double input;
  final double output;
  final double cacheRead;
  final double cacheWrite;
  const ModelPrice(this.input, this.output, this.cacheRead, this.cacheWrite);

  double cost({int inTok = 0, int outTok = 0, int cacheReadTok = 0, int cacheWriteTok = 0}) =>
      (inTok * input + outTok * output + cacheReadTok * cacheRead + cacheWriteTok * cacheWrite) /
      1000000.0;
}

const Map<String, ModelPrice> modelPrices = {
  'claude-haiku-5-5': ModelPrice(0.10, 0.50, 0.01, 0.125),
  'claude-sonnet-5-5': ModelPrice(2.00, 10.00, 0.20, 2.50),
  'claude-opus-5-5': ModelPrice(4.00, 20.00, 0.20, 5.00),
  'claude-fable-5-1': ModelPrice(10.00, 50.00, 0.25, 12.50),
  'claude-sonnet-5': ModelPrice(2.00, 10.00, 0.20, 2.50),
  'claude-opus-5': ModelPrice(5.00, 25.00, 0.50, 6.25),
  'claude-haiku-4-5': ModelPrice(1.00, 5.00, 0.10, 1.25),
};

ModelPrice priceFor(String model, ModelTier tier) {
  final p = modelPrices[model];
  if (p != null) return p;
  for (final e in modelPrices.entries) {
    if (model.startsWith(e.key)) return e.value;
  }
  return switch (tier) {
    ModelTier.haiku => modelPrices['claude-haiku-5-5']!,
    ModelTier.sonnet => modelPrices['claude-sonnet-5-5']!,
    ModelTier.opus => modelPrices['claude-opus-5-5']!,
  };
}

/// Every place the app talks to Claude. The tier decides the default model;
/// the key is stored in ai_usage.feature for the cost breakdown.
enum AiFeature {
  voiceParse('voice_parse', ModelTier.haiku, 'low'),
  exerciseAlternatives('exercise_alternatives', ModelTier.haiku, 'low'),
  memoryExtract('memory_extract', ModelTier.haiku, 'low'),
  foodText('food_text', ModelTier.haiku, 'low'),
  exerciseCreate('exercise_create', ModelTier.sonnet, 'low'),
  chat('chat', ModelTier.sonnet, 'low'),
  workoutSummary('workout_summary', ModelTier.sonnet, 'low'),
  foodPhoto('food_photo', ModelTier.sonnet, 'low'),
  morningMessage('morning_message', ModelTier.sonnet, 'low'),
  plateau('plateau', ModelTier.sonnet, 'low'),
  mealSwap('meal_swap', ModelTier.sonnet, 'low'),
  groceryList('grocery_list', ModelTier.sonnet, 'low'),
  initialPlan('initial_plan', ModelTier.opus, 'medium'),
  mealPlan('meal_plan', ModelTier.opus, 'medium'),
  weeklyReport('weekly_report', ModelTier.opus, 'medium'),
  keyTest('key_test', ModelTier.haiku, 'low');

  final String key;
  final ModelTier tier;

  /// output_config.effort sent with the request.
  final String effort;
  const AiFeature(this.key, this.tier, this.effort);
}
