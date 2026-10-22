import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/calc/nutrition_calc.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/context_ext.dart';
import '../../../core/widgets/common.dart';
import '../onboarding_labels.dart';
import '../onboarding_logic.dart';
import '../onboarding_widgets.dart';
import 'step_types.dart';

/// Step 1 – language (switches the app immediately).
class LanguageStep extends ConsumerWidget {
  final UserProfile profile;
  final ProfilePatch onChanged;
  const LanguageStep({super.key, required this.profile, required this.onChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final current = ref.watch(localeProvider);
    void pick(String code) {
      onChanged(UserProfilesCompanion(language: Value(code)));
      ref.read(localeProvider.notifier).set(code);
    }

    return OptionCards<String>(
      options: [
        OnbOption('ar', l.arabic, icon: Symbols.language_rounded),
        OnbOption('en', l.english, icon: Symbols.translate_rounded),
      ],
      selected: current,
      onSelect: pick,
    );
  }
}

/// Step 2 – sex, age, height, weight.
class BodyStatsStep extends StatelessWidget {
  final UserProfile profile;
  final ProfilePatch onChanged;
  const BodyStatsStep({super.key, required this.profile, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = profile;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            for (final (i, o) in sexOptions(l).indexed) ...[
              if (i > 0) const SizedBox(width: 10),
              Expanded(
                child: ChoiceCard(
                  label: o.label,
                  icon: o.icon,
                  selected: p.sex == o.code,
                  onTap: () {
                    final bf = reestimateShapeBodyFat(
                        method: p.bodyFatMethod, pct: p.bodyFatPct, oldSex: p.sex, newSex: o.code);
                    onChanged(UserProfilesCompanion(
                      sex: Value(o.code),
                      bodyFatPct: bf == null ? const Value.absent() : Value(bf),
                    ));
                  },
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        NumField(
          label: l.onbAge,
          value: p.age,
          unit: l.onbYears,
          min: OnbLimits.ageMin,
          max: OnbLimits.ageMax,
          icon: Symbols.cake_rounded,
          onChanged: (v) => onChanged(UserProfilesCompanion(age: Value(v?.round()))),
        ),
        NumField(
          label: l.onbHeight,
          value: p.heightCm,
          unit: l.cm,
          min: OnbLimits.heightMin,
          max: OnbLimits.heightMax,
          decimal: true,
          icon: Symbols.height_rounded,
          onChanged: (v) => onChanged(UserProfilesCompanion(heightCm: Value(v))),
        ),
        NumField(
          label: l.onbWeight,
          value: p.weightKg,
          unit: l.kg,
          min: OnbLimits.weightMin,
          max: OnbLimits.weightMax,
          decimal: true,
          icon: Symbols.monitor_weight_rounded,
          action: TextInputAction.done,
          onChanged: (v) {
            // Keep the water goal in sync while it still equals the old suggestion.
            final old = p.weightKg;
            final followSuggestion =
                p.waterGoalMl != null && old != null && p.waterGoalMl == NutritionCalc.waterGoalMl(old);
            onChanged(UserProfilesCompanion(
              weightKg: Value(v),
              waterGoalMl: followSuggestion && v != null && v >= OnbLimits.weightMin
                  ? Value(NutritionCalc.waterGoalMl(v))
                  : const Value.absent(),
            ));
          },
        ),
      ],
    );
  }
}

/// Step 3 – body fat: number, body shape estimate, or "I don't know".
class BodyFatStep extends StatelessWidget {
  final UserProfile profile;
  final ProfilePatch onChanged;
  const BodyFatStep({super.key, required this.profile, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = profile;
    final method = p.bodyFatMethod;
    final shape = method == 'shape' && p.bodyFatPct != null ? nearestBodyShape(p.bodyFatPct!, p.sex) : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OptionCards<String>(
          options: bodyFatMethodOptions(l),
          selected: method,
          onSelect: (m) {
            if (m == method) return;
            onChanged(UserProfilesCompanion(
              bodyFatMethod: Value(m),
              bodyFatPct: switch (m) {
                'unknown' || 'shape' => const Value(null),
                _ => const Value.absent(),
              },
            ));
          },
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: switch (method) {
            'number' => Padding(
                key: const ValueKey('number'),
                padding: const EdgeInsets.only(top: 12),
                child: NumField(
                  label: l.onbBodyFatPct,
                  value: p.bodyFatPct,
                  unit: '%',
                  min: OnbLimits.bodyFatMin,
                  max: OnbLimits.bodyFatMax,
                  decimal: true,
                  icon: Symbols.percent_rounded,
                  action: TextInputAction.done,
                  onChanged: (v) => onChanged(UserProfilesCompanion(bodyFatPct: Value(v))),
                ),
              ),
            'shape' => Column(
                key: const ValueKey('shape'),
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FieldHeading(l.onbBfShape),
                  for (final o in bodyShapeOptions(l))
                    ChoiceCard(
                      label: o.label,
                      subtitle:
                          '${o.subtitle} · ${l.onbShapeEstimate(fmtNum(bodyFatForShape(o.code, p.sex)))}',
                      icon: Symbols.accessibility_new_rounded,
                      selected: shape == o.code,
                      onTap: () =>
                          onChanged(UserProfilesCompanion(bodyFatPct: Value(bodyFatForShape(o.code, p.sex)))),
                    ),
                ],
              ),
            _ => const SizedBox.shrink(key: ValueKey('none')),
          },
        ),
      ],
    );
  }
}

/// Step 4 – optional body measurements (cm).
class MeasurementsStep extends StatelessWidget {
  final UserProfile profile;
  final ProfilePatch onChanged;
  const MeasurementsStep({super.key, required this.profile, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final m = parseMeasurements(profile.measurementsJson);
    Widget field(String key) => NumField(
          label: measurementLabel(l, key),
          value: m[key],
          unit: l.cm,
          min: OnbLimits.measureMin,
          max: OnbLimits.measureMax,
          decimal: true,
          action: key == measurementKeys.last ? TextInputAction.done : TextInputAction.next,
          onChanged: (v) {
            final next = parseMeasurements(profile.measurementsJson);
            if (v == null) {
              next.remove(key);
            } else {
              next[key] = v;
            }
            onChanged(UserProfilesCompanion(measurementsJson: Value(encodeMeasurements(next))));
          },
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < measurementKeys.length; i += 2)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: field(measurementKeys[i])),
              const SizedBox(width: 10),
              Expanded(child: field(measurementKeys[i + 1])),
            ],
          ),
        InfoNote(l.onbMeasHint, icon: Symbols.straighten_rounded),
      ],
    );
  }
}

/// Step 5 – goal + optional target weight and duration.
class GoalStep extends StatelessWidget {
  final UserProfile profile;
  final ProfilePatch onChanged;
  const GoalStep({super.key, required this.profile, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = profile;
    final warning = goalWarning(p);
    final suggestedWeeks = suggestGoalWeeks(p.weightKg, p.targetWeightKg);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OptionCards<String>(
          options: goalOptions(l),
          selected: p.goal,
          onSelect: (g) => onChanged(UserProfilesCompanion(goal: Value(g))),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: NumField(
                label: l.onbTargetWeight,
                value: p.targetWeightKg,
                unit: l.kg,
                min: OnbLimits.weightMin,
                max: OnbLimits.weightMax,
                decimal: true,
                onChanged: (v) => onChanged(UserProfilesCompanion(targetWeightKg: Value(v))),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: NumField(
                label: l.onbGoalWeeks,
                value: p.goalWeeks,
                unit: l.onbWeeks,
                min: OnbLimits.weeksMin,
                max: OnbLimits.weeksMax,
                action: TextInputAction.done,
                onChanged: (v) => onChanged(UserProfilesCompanion(goalWeeks: Value(v?.round()))),
              ),
            ),
          ],
        ),
        if (suggestedWeeks != null && p.goalWeeks != suggestedWeeks)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              icon: const Icon(Symbols.auto_awesome_rounded, size: 18),
              label: Text(l.onbGoalWeeksSuggest('$suggestedWeeks')),
              onPressed: () => onChanged(UserProfilesCompanion(goalWeeks: Value(suggestedWeeks))),
            ),
          ),
        if (warning != null)
          InfoNote(
            warning == GoalWarning.cutTargetAbove ? l.onbWarnCutTarget : l.onbWarnBulkTarget,
            icon: Symbols.warning_rounded,
            color: AppColors.warning,
          ),
      ],
    );
  }
}

/// Step 6 – level + training experience.
class LevelStep extends StatelessWidget {
  final UserProfile profile;
  final ProfilePatch onChanged;
  const LevelStep({super.key, required this.profile, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OptionCards<String>(
          options: levelOptions(l),
          selected: profile.level,
          onSelect: (v) => onChanged(UserProfilesCompanion(level: Value(v))),
        ),
        FieldHeading(l.onbExperienceTitle),
        ChipChoices<String>(
          options: experienceOptions(l),
          isSelected: (c) => profile.trainingExperience == c,
          onToggle: (c) => onChanged(UserProfilesCompanion(trainingExperience: Value(c))),
        ),
      ],
    );
  }
}
