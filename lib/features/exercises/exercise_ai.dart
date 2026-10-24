import 'dart:convert';

import 'package:drift/drift.dart' show Value;

import '../../ai/ai_service.dart';
import '../../core/providers.dart';
import '../../data/repositories/exercise_repository.dart';
import 'exercise_labels.dart';
import 'exercise_seed.dart' show deriveMovementPattern;
import 'exercise_similarity.dart';

/// Editable exercise data used by the AI-create / manual / edit form.
class ExerciseDraft {
  String nameEn;
  String nameAr;
  List<String> primaryMuscles;
  List<String> secondaryMuscles;
  String equipment;
  String? force;
  String? mechanic;
  String category;
  List<String> instructionsEn;
  List<String> instructionsAr;
  List<String> mistakesEn;
  List<String> mistakesAr;

  ExerciseDraft({
    this.nameEn = '',
    this.nameAr = '',
    List<String>? primaryMuscles,
    List<String>? secondaryMuscles,
    this.equipment = 'other',
    this.force,
    this.mechanic,
    this.category = 'strength',
    List<String>? instructionsEn,
    List<String>? instructionsAr,
    List<String>? mistakesEn,
    List<String>? mistakesAr,
  })  : primaryMuscles = primaryMuscles ?? [],
        secondaryMuscles = secondaryMuscles ?? [],
        instructionsEn = instructionsEn ?? [],
        instructionsAr = instructionsAr ?? [],
        mistakesEn = mistakesEn ?? [],
        mistakesAr = mistakesAr ?? [];

  factory ExerciseDraft.fromExercise(Exercise e) => ExerciseDraft(
        nameEn: e.nameEn,
        nameAr: e.nameAr,
        primaryMuscles: [...e.primaryMuscles],
        secondaryMuscles: [...e.secondaryMuscles],
        equipment: normalizeEquipment(e.equipment),
        force: e.force,
        mechanic: e.mechanic,
        category: e.category ?? 'strength',
        instructionsEn: [...e.instructionsEn],
        instructionsAr: [...e.instructionsAr],
        mistakesEn: [...e.mistakesEn],
        mistakesAr: [...e.mistakesAr],
      );

  /// Parses Claude's JSON (already schema-validated), normalising enums defensively.
  factory ExerciseDraft.fromAiJson(Map<String, dynamic> j) {
    List<String> strs(Object? v) =>
        v is List ? v.whereType<String>().map((s) => s.trim()).where((s) => s.isNotEmpty).toList() : [];
    List<String> muscles(Object? v) {
      final out = <String>[];
      for (final m in strs(v)) {
        final id = normalizeMuscle(m);
        if (id != null && !out.contains(id)) out.add(id);
      }
      return out;
    }

    final primary = muscles(j['primaryMuscles']);
    String? pick(Object? v, List<String> allowed) => v is String && allowed.contains(v) ? v : null;
    return ExerciseDraft(
      nameEn: (j['nameEn'] as String? ?? '').trim(),
      nameAr: (j['nameAr'] as String? ?? '').trim(),
      primaryMuscles: primary,
      secondaryMuscles: muscles(j['secondaryMuscles']).where((m) => !primary.contains(m)).toList(),
      equipment: normalizeEquipment(j['equipment'] as String?),
      force: pick(j['force'], kForces),
      mechanic: pick(j['mechanic'], kMechanics),
      category: pick(j['category'], kCategories) ?? 'strength',
      instructionsEn: strs(j['instructionsEn']),
      instructionsAr: strs(j['instructionsAr']),
      mistakesEn: strs(j['mistakesEn']),
      mistakesAr: strs(j['mistakesAr']),
    );
  }

  bool get isValid => (nameEn.trim().isNotEmpty || nameAr.trim().isNotEmpty) && primaryMuscles.isNotEmpty;

  ExercisesCompanion toCompanion(String id, {String? mediaPath, bool keepMedia = false}) {
    final en = nameEn.trim().isEmpty ? nameAr.trim() : nameEn.trim();
    final ar = nameAr.trim().isEmpty ? en : nameAr.trim();
    return ExercisesCompanion(
      id: Value(id),
      nameEn: Value(en),
      nameAr: Value(ar),
      primaryMusclesJson: Value(jsonEncode(primaryMuscles)),
      secondaryMusclesJson: Value(jsonEncode(secondaryMuscles.where((m) => !primaryMuscles.contains(m)).toList())),
      equipment: Value(equipment),
      force: Value(force),
      mechanic: Value(mechanic),
      category: Value(category),
      movementPattern: Value(deriveMovementPattern(
        force: force,
        category: category,
        primary: primaryMuscles,
        secondary: secondaryMuscles,
      )),
      instructionsEnJson: Value(jsonEncode(instructionsEn)),
      instructionsArJson: Value(jsonEncode(instructionsAr)),
      mistakesEnJson: Value(jsonEncode(mistakesEn)),
      mistakesArJson: Value(jsonEncode(mistakesAr)),
      mediaPath: keepMedia ? const Value.absent() : Value(mediaPath),
      isCustom: const Value(true),
    );
  }
}

/// Result of [createExerciseWithAi].
class AiExerciseResult {
  final ExerciseDraft draft;

  /// Ids of existing exercises Claude considers the same/similar (validated against the candidates).
  final List<String> similarExistingIds;
  const AiExerciseResult(this.draft, this.similarExistingIds);
}

/// JSON schema for AiFeature.exerciseCreate (muscles/equipment constrained to app enums).
Map<String, dynamic> exerciseCreateSchema() {
  const strList = {
    'type': 'array',
    'items': {'type': 'string'},
  };
  return {
    'type': 'object',
    'properties': {
      'nameEn': {'type': 'string'},
      'nameAr': {'type': 'string'},
      'primaryMuscles': {
        'type': 'array',
        'items': {'type': 'string', 'enum': kMuscles},
        'minItems': 1,
      },
      'secondaryMuscles': {
        'type': 'array',
        'items': {'type': 'string', 'enum': kMuscles},
      },
      'equipment': {'type': 'string', 'enum': kEquipment},
      // "none" instead of null: the API rejects enums on nullable types.
      'force': {
        'type': 'string',
        'enum': [...kForces, 'none'],
      },
      'mechanic': {
        'type': 'string',
        'enum': [...kMechanics, 'none'],
      },
      'category': {'type': 'string', 'enum': kCategories},
      'instructionsEn': strList,
      'instructionsAr': strList,
      'mistakesEn': strList,
      'mistakesAr': strList,
      'similarExistingIds': strList,
    },
    'required': [
      'nameEn',
      'nameAr',
      'primaryMuscles',
      'secondaryMuscles',
      'equipment',
      'force',
      'mechanic',
      'category',
      'instructionsEn',
      'instructionsAr',
      'mistakesEn',
      'mistakesAr',
      'similarExistingIds',
    ],
  };
}

const String _createSystem = '''
You are the exercise librarian of IronMind, a gym app for an Egyptian lifter.
Turn the user's description (text and/or a photo of a gym machine) into ONE well-defined exercise.
Rules:
- Use the standard gym name in English (e.g. "Seated Cable Row"). nameAr = the name Egyptian gym-goers
  actually use, in Arabic script (transliterated English is fine, e.g. "تي بار رو"), short.
- primaryMuscles / secondaryMuscles / equipment / force / mechanic / category must use the given enums ("none" when force or mechanic does not apply).
- instructions: 4–8 short numbered-style steps (no numbering in the text). Arabic = friendly Egyptian colloquial.
- mistakes: 3–5 common technique mistakes, same meaning in both languages.
- similarExistingIds: ids from the candidate list that are the SAME exercise or a near-identical variant
  (most similar first, max 3). Empty if none. Never invent ids.
- If the photo shows a machine, infer the exercise performed on it.''';

/// Builds the user prompt for [createExerciseWithAi] (exposed for tests).
String buildExerciseCreatePrompt({
  required String description,
  required String lang,
  required List<Exercise> candidates,
  bool hasPhoto = false,
}) {
  final b = StringBuffer()
    ..writeln('User description (${lang == 'ar' ? 'Egyptian Arabic' : 'English'}):')
    ..writeln(description.trim().isEmpty ? '(no text – use the photo)' : description.trim());
  if (hasPhoto) b.writeln('A photo of the machine/equipment is attached.');
  b.writeln();
  if (candidates.isEmpty) {
    b.writeln('Candidate existing exercises: (none)');
  } else {
    b.writeln('Candidate existing exercises (id | English | Arabic | primary muscles | equipment):');
    for (final c in candidates) {
      b.writeln('${c.id} | ${c.nameEn} | ${c.nameAr} | ${c.primaryMuscles.join(', ')} | ${c.equipment ?? '-'}');
    }
  }
  b.writeln();
  b.writeln('Return the exercise as JSON.');
  return b.toString();
}

/// Up to [limit] library exercises most similar to [text] (for the prompt and "did you mean").
List<Exercise> similarCandidates(String text, List<Exercise> all, {int limit = 25, double minScore = 0.2}) =>
    rankBySimilarity(text, all, (e) => [e.nameEn, e.nameAr], limit: limit, minScore: minScore)
        .map((m) => m.item)
        .toList();

/// Asks Claude to structure a new exercise. Throws AiNoKeyException / AiOfflineException / AiException.
Future<AiExerciseResult> createExerciseWithAi(
  AiService ai, {
  required String description,
  required String lang,
  required List<Exercise> candidates,
  String? imageBase64,
}) async {
  final json = await ai.structured(
    feature: AiFeature.exerciseCreate,
    system: AiService.systemBlocks(_createSystem),
    prompt: buildExerciseCreatePrompt(
      description: description,
      lang: lang,
      candidates: candidates,
      hasPhoto: imageBase64 != null,
    ),
    schema: exerciseCreateSchema(),
    maxTokens: 4000,
    extraContent: imageBase64 == null
        ? null
        : [
            {
              'type': 'image',
              'source': {'type': 'base64', 'media_type': 'image/jpeg', 'data': imageBase64},
            }
          ],
    extraValidate: (j) => [
      if ((j['nameEn'] as String? ?? '').trim().isEmpty) 'nameEn must not be empty',
      if ((j['primaryMuscles'] as List? ?? const []).isEmpty) 'primaryMuscles must not be empty',
    ],
  );
  final ids = candidates.map((c) => c.id).toSet();
  final similar = (json['similarExistingIds'] as List? ?? const [])
      .whereType<String>()
      .where(ids.contains)
      .toSet()
      .take(3)
      .toList();
  return AiExerciseResult(ExerciseDraft.fromAiJson(json), similar);
}
