import 'package:flutter/material.dart';

import '../../../core/providers.dart';
import '../onboarding_logic.dart';
import 'step_types.dart';
import 'steps_basics.dart';
import 'steps_connect.dart';
import 'steps_nutrition.dart';
import 'steps_training.dart';

export 'step_types.dart';

/// The reusable question widget for [step]. Used by the onboarding PageView
/// and by the profile editor (Settings → Profile).
Widget buildStepBody(
  OnbStep step, {
  required UserProfile profile,
  required ProfilePatch onChanged,
  ValueChanged<OnbStep>? onEditStep,
}) {
  final p = profile;
  return switch (step) {
    OnbStep.language => LanguageStep(profile: p, onChanged: onChanged),
    OnbStep.body => BodyStatsStep(profile: p, onChanged: onChanged),
    OnbStep.bodyFat => BodyFatStep(profile: p, onChanged: onChanged),
    OnbStep.measurements => MeasurementsStep(profile: p, onChanged: onChanged),
    OnbStep.goal => GoalStep(profile: p, onChanged: onChanged),
    OnbStep.level => LevelStep(profile: p, onChanged: onChanged),
    OnbStep.days => DaysStep(profile: p, onChanged: onChanged),
    OnbStep.sessionLength => SessionLengthStep(profile: p, onChanged: onChanged),
    OnbStep.split => SplitStep(profile: p, onChanged: onChanged),
    OnbStep.focus => FocusStep(profile: p, onChanged: onChanged),
    OnbStep.location => LocationStep(profile: p, onChanged: onChanged),
    OnbStep.injuries => InjuriesStep(profile: p, onChanged: onChanged),
    OnbStep.job => JobStep(profile: p, onChanged: onChanged),
    OnbStep.sleep => SleepStep(profile: p, onChanged: onChanged),
    OnbStep.trainingTime => TrainingTimeStep(profile: p, onChanged: onChanged),
    OnbStep.cardio => CardioStep(profile: p, onChanged: onChanged),
    OnbStep.meals => MealsStep(profile: p, onChanged: onChanged),
    OnbStep.foods => FoodsStep(profile: p, onChanged: onChanged),
    OnbStep.budget => BudgetStep(profile: p, onChanged: onChanged),
    OnbStep.supplements => SupplementsStep(profile: p, onChanged: onChanged),
    OnbStep.water => WaterStep(profile: p, onChanged: onChanged),
    OnbStep.healthConnect => HealthConnectStep(profile: p, onChanged: onChanged),
    OnbStep.apiKey => const ApiKeyStep(),
    OnbStep.summary => SummaryStep(profile: p, onEdit: onEditStep ?? (_) {}),
  };
}
