import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../ai/ai_service.dart';
import '../../core/providers.dart';
import '../../data/repositories/profile_repository.dart';
import 'nutrition_logic.dart';
import 'nutrition_repository.dart';

/// Result of a food photo / text analysis.
class FoodAnalysis {
  final String mealNameAr, mealNameEn;
  final List<FoodEntry> items;
  final double confidence;
  final String notes;
  const FoodAnalysis({
    required this.mealNameAr,
    required this.mealNameEn,
    required this.items,
    required this.confidence,
    required this.notes,
  });

  factory FoodAnalysis.fromJson(Map<String, dynamic> j) => FoodAnalysis(
        mealNameAr: (j['mealNameAr'] as String?)?.trim() ?? '',
        mealNameEn: (j['mealNameEn'] as String?)?.trim() ?? '',
        items: ((j['items'] as List?) ?? const [])
            .whereType<Map>()
            .map((m) => FoodEntry.fromJson(m.cast<String, dynamic>()))
            .where((e) => e.grams > 0 || e.calories > 0)
            .toList(),
        confidence: ((j['confidence'] as num?)?.toDouble() ?? 0.5).clamp(0.0, 1.0),
        notes: (j['notes'] as String?)?.trim() ?? '',
      );

  String mealName(String lang) {
    final n = lang == 'ar' ? mealNameAr : mealNameEn;
    if (n.isNotEmpty) return n;
    return items.map((e) => e.name(lang)).take(3).join(' + ');
  }
}

/// One swap alternative for a planned meal.
class MealAlternative {
  final String nameAr, nameEn;
  final List<FoodEntry> items;
  final String notes;
  const MealAlternative({required this.nameAr, required this.nameEn, required this.items, this.notes = ''});
  FoodMacros get totals => sumEntries(items);
}

const _itemSchema = {
  'type': 'object',
  'properties': {
    'nameAr': {'type': 'string', 'description': 'Food name in Egyptian Arabic'},
    'nameEn': {'type': 'string', 'description': 'Food name in English'},
    'grams': {'type': 'number', 'description': 'Edible weight in grams (cooked/ready to eat)'},
    'calories': {'type': 'number'},
    'protein': {'type': 'number', 'description': 'grams'},
    'carbs': {'type': 'number', 'description': 'grams'},
    'fat': {'type': 'number', 'description': 'grams'},
  },
  'required': ['nameAr', 'nameEn', 'grams', 'calories', 'protein', 'carbs', 'fat'],
};

const foodAnalysisSchema = {
  'type': 'object',
  'properties': {
    'mealNameAr': {'type': 'string', 'description': 'Short meal name in Egyptian Arabic'},
    'mealNameEn': {'type': 'string', 'description': 'Short meal name in English'},
    'items': {'type': 'array', 'items': _itemSchema},
    'confidence': {'type': 'number', 'description': '0..1 how sure you are about items and portions'},
    'notes': {'type': 'string', 'description': 'Short note for the user (assumptions, hidden oil…), in the user language'},
  },
  'required': ['mealNameAr', 'mealNameEn', 'items', 'confidence', 'notes'],
};

const mealSwapSchema = {
  'type': 'object',
  'properties': {
    'alternatives': {
      'type': 'array',
      'items': {
        'type': 'object',
        'properties': {
          'nameAr': {'type': 'string'},
          'nameEn': {'type': 'string'},
          'items': {'type': 'array', 'items': _itemSchema},
          'notes': {'type': 'string'},
        },
        'required': ['nameAr', 'nameEn', 'items', 'notes'],
      },
    },
  },
  'required': ['alternatives'],
};

const _foodSystem = '''
You are a precise sports nutritionist for an Egyptian gym-goer. You estimate foods, portion
weights and macros. You know Egyptian home food, street food and restaurant portions very well
(foul, taameya, koshary, molokhia, mahshi, hawawshi, feteer, shawarma, baladi bread ≈ 90 g per loaf,
an egg ≈ 50 g edible, a medium koshary plate ≈ 400 g…). Hidden cooking oil/ghee/tahini counts.
Use realistic per-100 g values (USDA/Egyptian food composition tables). Grams are the edible,
ready-to-eat weight. Each item's calories must be consistent with 4·protein + 4·carbs + 9·fat (±10%).
Give every item a name in Egyptian Arabic (nameAr) and English (nameEn).''';

/// Validates domain constraints of a food analysis JSON.
List<String> validateFoodAnalysisJson(Map<String, dynamic> j) {
  final errors = <String>[];
  final c = j['confidence'];
  if (c is num && (c < 0 || c > 1)) errors.add('confidence must be between 0 and 1');
  final items = j['items'];
  if (items is List) {
    for (final (i, it) in items.indexed) {
      if (it is! Map) continue;
      for (final k in ['grams', 'calories', 'protein', 'carbs', 'fat']) {
        final v = it[k];
        if (v is num && v < 0) errors.add('items[$i].$k must be >= 0');
      }
    }
  }
  return errors;
}

/// Claude calls for food logging & meal swaps (+ offline queue handlers).
class FoodAi {
  final Ref ref;
  FoodAi(this.ref);

  static const photoQueueKey = 'food_photo';
  static const textQueueKey = 'food_text';

  AiService get _ai => ref.read(aiServiceProvider);

  String get _lang => ref.read(localeProvider);

  String _langLine() =>
      _lang == 'ar' ? 'Write "notes" in Egyptian Arabic.' : 'Write "notes" in English.';

  /// Claude Sonnet vision: photo (JPEG bytes) → items with grams & macros + confidence.
  Future<FoodAnalysis> analyzePhoto(Uint8List jpeg, {String? hint}) async {
    final res = await _ai.structured(
      feature: AiFeature.foodPhoto,
      system: AiService.systemBlocks(_foodSystem),
      extraContent: [
        {
          'type': 'image',
          'source': {'type': 'base64', 'media_type': 'image/jpeg', 'data': base64Encode(jpeg)},
        }
      ],
      prompt: 'Identify every food on this plate/photo, estimate the portion in grams and the macros '
          'of each item. If something is unclear, make the most likely Egyptian assumption and say '
          'so in notes, and lower the confidence. If there is no food, return an empty items list '
          'with confidence 0. ${_langLine()}'
          '${hint != null && hint.trim().isNotEmpty ? '\nUser hint: ${hint.trim()}' : ''}',
      schema: foodAnalysisSchema,
      extraValidate: validateFoodAnalysisJson,
      maxTokens: 4000,
    );
    return FoodAnalysis.fromJson(res);
  }

  /// Claude Haiku: free text / voice ("طبق كشري وسط وبيضتين") → same JSON.
  Future<FoodAnalysis> analyzeText(String text) async {
    final res = await _ai.structured(
      feature: AiFeature.foodText,
      system: AiService.systemBlocks(_foodSystem),
      prompt: 'The user ate: "${text.trim()}"\n'
          'Split it into food items with grams and macros. Interpret Egyptian colloquial quantities '
          '(e.g. "طبق وسط" medium plate, "رغيفين" 2 loaves, "بيضتين" 2 eggs, "معلقة" tablespoon). '
          'Confidence reflects how clear the description is. ${_langLine()}',
      schema: foodAnalysisSchema,
      extraValidate: validateFoodAnalysisJson,
      maxTokens: 3000,
    );
    return FoodAnalysis.fromJson(res);
  }

  /// Claude Sonnet: 2–3 alternatives with roughly the same macros as [meal].
  Future<List<MealAlternative>> swapMeal(PlannedMeal meal) async {
    final profile = await ref.read(profileRepositoryProvider).get();
    final items = decodeItems(meal.itemsJson);
    final target = sumEntries(items);
    final res = await _ai.structured(
      feature: AiFeature.mealSwap,
      system: AiService.systemBlocks(
        '$_foodSystem\nYou suggest swaps for meals in the user\'s plan using Egyptian, '
        'locally-available, budget-appropriate foods.',
        dynamic: profile == null
            ? null
            : 'Preferences: likes=${profile.likedFoods ?? '-'}; dislikes=${profile.dislikedFoods ?? '-'}; '
                'allergies=${profile.allergies ?? '-'}; monthly budget: ${profile.budgetLevel ?? '-'} '
                '${profile.budgetEgp != null ? '${profile.budgetEgp} EGP' : ''}',
      ),
      prompt: 'Current meal "${pickBilingual(meal.name, 'en')}" (${meal.dayType} day, time ${meal.time ?? '-'}):\n'
          '${jsonEncode(items.map((e) => e.toJson()).toList())}\n'
          'Totals: ${target.calories.round()} kcal, P ${target.protein.round()} g, '
          'C ${target.carbs.round()} g, F ${target.fat.round()} g.\n'
          'Give 3 different alternative meals (different main foods than the current one) whose totals '
          'are within ±10% of these numbers. Never use disliked or allergenic foods. '
          'notes: one short line in ${_lang == 'ar' ? 'Egyptian Arabic' : 'English'}.',
      schema: mealSwapSchema,
      extraValidate: (j) => validateSwapJson(j, target),
      maxTokens: 6000,
    );
    return ((res['alternatives'] as List?) ?? const [])
        .whereType<Map>()
        .map((m) {
          final mm = m.cast<String, dynamic>();
          return MealAlternative(
            nameAr: (mm['nameAr'] as String?) ?? '',
            nameEn: (mm['nameEn'] as String?) ?? '',
            items: ((mm['items'] as List?) ?? const [])
                .whereType<Map>()
                .map((e) => FoodEntry.fromJson(e.cast<String, dynamic>()))
                .toList(),
            notes: (mm['notes'] as String?) ?? '',
          );
        })
        .where((a) => a.items.isNotEmpty)
        .toList();
  }

  // ------------------------------------------------------------- queue

  /// Fills a pending photo log once the device is online with a key.
  static Future<void> handlePhotoJob(Ref ref, Map<String, dynamic> payload) async {
    final repo = ref.read(nutritionRepositoryProvider);
    final id = (payload['logId'] as num).toInt();
    final log = await repo.getLog(id);
    if (log == null || log.status != 'pending_ai' || log.photoPath == null) return;
    final file = File(await resolveAppPath(log.photoPath!));
    if (!await file.exists()) {
      await repo.updateLog(id, name: log.name, items: const [], status: 'done', confidence: 0);
      return;
    }
    final a = await FoodAi(ref).analyzePhoto(await file.readAsBytes(), hint: payload['hint'] as String?);
    await _complete(ref, log, a);
  }

  /// Fills a pending text log (typed/voice while offline).
  static Future<void> handleTextJob(Ref ref, Map<String, dynamic> payload) async {
    final repo = ref.read(nutritionRepositoryProvider);
    final id = (payload['logId'] as num).toInt();
    final log = await repo.getLog(id);
    if (log == null || log.status != 'pending_ai') return;
    final a = await FoodAi(ref).analyzeText((payload['text'] as String?) ?? log.name);
    await _complete(ref, log, a);
  }

  static Future<void> _complete(Ref ref, MealLog log, FoodAnalysis a) async {
    final repo = ref.read(nutritionRepositoryProvider);
    final lang = ref.read(localeProvider);
    final name = a.items.isEmpty ? log.name : joinBilingual(a.mealName('ar'), a.mealName('en'));
    await repo.updateLog(log.id, name: name, items: a.items, confidence: a.confidence, status: 'done');
    if (a.items.isNotEmpty) await repo.saveMyFood(pickBilingual(name, lang), a.items);
  }
}

/// Each alternative must be within ±15% kcal and protein of the original meal.
List<String> validateSwapJson(Map<String, dynamic> j, FoodMacros target) {
  final errors = <String>[];
  final alts = (j['alternatives'] as List?) ?? const [];
  if (alts.length < 2) errors.add('alternatives: give 2–3 alternatives');
  for (final (i, a) in alts.indexed) {
    if (a is! Map) continue;
    final items = ((a['items'] as List?) ?? const [])
        .whereType<Map>()
        .map((e) => FoodEntry.fromJson(e.cast<String, dynamic>()))
        .toList();
    if (items.isEmpty) {
      errors.add('alternatives[$i]: no items');
      continue;
    }
    final t = sumEntries(items);
    if (!withinTolerance(t.calories, target.calories, tolerance: 0.15, minSlack: 40)) {
      errors.add('alternatives[$i]: ${t.calories.round()} kcal, needs ≈${target.calories.round()} (±15%)');
    }
    if (!withinTolerance(t.protein, target.protein, tolerance: 0.15, minSlack: 5)) {
      errors.add('alternatives[$i]: protein ${t.protein.round()} g, needs ≈${target.protein.round()} g (±15%)');
    }
  }
  return errors;
}

final foodAiProvider = Provider<FoodAi>((ref) => FoodAi(ref));
