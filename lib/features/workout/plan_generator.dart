import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Builds the weekly workout plan with Claude (Opus) from the profile and saves it (inactive until approved).
class WorkoutPlanGenerator {
  final Ref ref;
  WorkoutPlanGenerator(this.ref);

  /// Returns the new plan id.
  Future<int> generateAndSave() async => throw UnimplementedError();
}

final workoutPlanGeneratorProvider = Provider<WorkoutPlanGenerator>((ref) => WorkoutPlanGenerator(ref));
