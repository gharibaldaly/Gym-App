import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderListenable;

import '../../ai/ai_service.dart';
import '../../core/providers.dart';
import '../../data/repositories/exercise_repository.dart';

/// Builds the candidate list for AI alternatives: up to [limit] local exercises
/// sharing [ex]'s first primary muscle, best local matches first (same pattern,
/// force, mechanic, muscle overlap). Pure; exposed for tests.
List<Exercise> alternativeCandidates(Exercise ex, List<Exercise> sameMuscle, {int limit = 40}) {
  final primary = ex.primaryMuscles;
  int score(Exercise c) {
    var s = 0;
    if (c.movementPattern != null && c.movementPattern == ex.movementPattern) s += 3;
    if (c.force != null && c.force == ex.force) s += 2;
    if (c.mechanic != null && c.mechanic == ex.mechanic) s += 2;
    if (c.category == ex.category) s += 1;
    s += c.primaryMuscles.where(primary.contains).length * 2;
    s += c.secondaryMuscles.where(ex.secondaryMuscles.contains).length;
    if (c.category == 'stretching' && ex.category != 'stretching') s -= 6;
    if (c.isFavorite) s += 1;
    return s;
  }

  final list = sameMuscle.where((c) => c.id != ex.id).toList()
    ..sort((a, b) {
      final d = score(b).compareTo(score(a));
      return d != 0 ? d : a.nameEn.compareTo(b.nameEn);
    });
  return list.take(limit).toList();
}

String buildAlternativesPrompt(Exercise ex, List<Exercise> candidates, {String? reason, String? location}) {
  final b = StringBuffer()
    ..writeln('Exercise to replace: ${ex.nameEn} (id ${ex.id})')
    ..writeln('Primary: ${ex.primaryMuscles.join(', ')}; secondary: ${ex.secondaryMuscles.join(', ')}; '
        'equipment: ${ex.equipment ?? '-'}; pattern: ${ex.movementPattern ?? '-'}; '
        'force: ${ex.force ?? '-'}; mechanic: ${ex.mechanic ?? '-'}');
  if (reason != null && reason.trim().isNotEmpty) b.writeln('Reason for swapping: ${reason.trim()}');
  if (location != null) b.writeln('Training location: $location');
  b
    ..writeln()
    ..writeln('Candidates (id | name | primary | secondary | equipment | pattern | mechanic):');
  for (final c in candidates) {
    b.writeln('${c.id} | ${c.nameEn} | ${c.primaryMuscles.join(', ')} | ${c.secondaryMuscles.join(', ')} | '
        '${c.equipment ?? '-'} | ${c.movementPattern ?? '-'} | ${c.mechanic ?? '-'}');
  }
  b.writeln('\nPick up to 3 candidate ids that train the same muscles with the same movement, best first.');
  return b.toString();
}

const String _altSystem = 'You are a strength coach choosing exercise substitutions. Prefer exercises that '
    'match the movement pattern and stimulus (compound for compound), respect the stated reason (pain, '
    'busy equipment, home gym) and avoid near-duplicates of each other. Only use ids from the candidate list.';

T _read<T>(Object ref, ProviderListenable<T> p) {
  if (ref is WidgetRef) return ref.read(p);
  if (ref is Ref) return ref.read(p);
  throw ArgumentError('ref must be a Ref or WidgetRef');
}

/// Up to 3 alternative exercise ids for [ex] chosen by Claude (AiFeature.exerciseAlternatives)
/// from ~40 local exercises sharing the primary muscle. [ref] may be a `Ref` or a `WidgetRef`.
///
/// Throws AiNoKeyException / AiOfflineException / AiException – callers should
/// fall back to `ExerciseRepository.localAlternatives`.
Future<List<String>> exerciseAlternativesAi(Object ref, Exercise ex, {String? reason, String? location}) async {
  final repo = _read(ref, exerciseRepositoryProvider);
  final ai = _read(ref, aiServiceProvider);
  final primary = ex.primaryMuscles;
  if (primary.isEmpty) return [];
  final candidates = alternativeCandidates(ex, await repo.byPrimaryMuscle(primary.first, excludeId: ex.id));
  if (candidates.isEmpty) return [];
  final ids = candidates.map((c) => c.id).toList();
  final json = await ai.structured(
    feature: AiFeature.exerciseAlternatives,
    system: AiService.systemBlocks(_altSystem),
    prompt: buildAlternativesPrompt(ex, candidates, reason: reason, location: location),
    schema: {
      'type': 'object',
      'properties': {
        'ids': {
          'type': 'array',
          'items': {'type': 'string', 'enum': ids},
        },
      },
      'required': ['ids'],
    },
    maxTokens: 1000,
  );
  return (json['ids'] as List).whereType<String>().where(ids.contains).toSet().take(3).toList();
}
