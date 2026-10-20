import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/repositories/exercise_repository.dart';

/// Library filters (value type → usable as a family key).
typedef ExerciseFilter = ({
  String query,
  String? muscle,
  String? equipment,
  bool favoritesOnly,
  bool customOnly,
});

const ExerciseFilter kNoExerciseFilter =
    (query: '', muscle: null, equipment: null, favoritesOnly: false, customOnly: false);

final exerciseSearchProvider = StreamProvider.autoDispose.family<List<Exercise>, ExerciseFilter>((ref, f) {
  return ref.watch(exerciseRepositoryProvider).watchSearch(
        query: f.query,
        muscle: f.muscle,
        equipment: f.equipment,
        favoritesOnly: f.favoritesOnly,
        customOnly: f.customOnly,
      );
});

/// Live single exercise (favorite toggles, edits).
final exerciseByIdProvider = StreamProvider.autoDispose.family<Exercise?, String>((ref, id) {
  return ref.watch(exerciseRepositoryProvider).watchById(id);
});
