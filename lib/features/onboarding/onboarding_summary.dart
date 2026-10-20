import 'package:flutter/material.dart';

import '../../core/providers.dart';
import '../../core/utils/context_ext.dart' show fmtNum;
import '../../data/repositories/profile_repository.dart';
import '../../l10n/gen/app_localizations.dart';
import 'onboarding_labels.dart';
import 'onboarding_logic.dart';

/// One answer row in the summary / profile editor.
class SummaryItem {
  final OnbStep step;
  final String label;
  final String value;
  final IconData icon;

  /// True when the step currently fails validation (shown in red).
  final bool invalid;
  const SummaryItem({
    required this.step,
    required this.label,
    required this.value,
    required this.icon,
    this.invalid = false,
  });
}

class SummarySection {
  final OnbSection section;
  final String title;
  final List<SummaryItem> items;
  const SummarySection(this.section, this.title, this.items);
}

String weekdayShort(AppLocalizations l, int weekday) => switch (weekday) {
      DateTime.monday => l.weekdayMon,
      DateTime.tuesday => l.weekdayTue,
      DateTime.wednesday => l.weekdayWed,
      DateTime.thursday => l.weekdayThu,
      DateTime.friday => l.weekdayFri,
      DateTime.saturday => l.weekdaySat,
      _ => l.weekdaySun,
    };

/// Human-readable value of one answer.
String summaryValue(OnbStep step, UserProfile p, AppLocalizations l, {bool hasApiKey = false}) {
  final none = l.onbNone, notSet = l.onbNotSet;
  String join(Iterable<String?> parts) {
    final list = parts.whereType<String>().where((e) => e.isNotEmpty).toList();
    return list.isEmpty ? notSet : list.join(' · ');
  }

  switch (step) {
    case OnbStep.language:
      return p.language == 'en' ? l.english : l.arabic;
    case OnbStep.body:
      return join([
        labelOf(sexOptions(l), p.sex),
        p.age == null ? null : l.onbYearsValue('${p.age}'),
        p.heightCm == null ? null : '${fmtNum(p.heightCm!)} ${l.cm}',
        p.weightKg == null ? null : '${fmtNum(p.weightKg!)} ${l.kg}',
      ]);
    case OnbStep.bodyFat:
      return switch (p.bodyFatMethod) {
        'number' when p.bodyFatPct != null => '${fmtNum(p.bodyFatPct!)}%',
        'shape' when p.bodyFatPct != null => l.onbBodyFatShapeValue(fmtNum(p.bodyFatPct!)),
        'unknown' => l.onbBfUnknown,
        _ => notSet,
      };
    case OnbStep.measurements:
      final m = parseMeasurements(p.measurementsJson);
      if (m.isEmpty) return none;
      return [
        for (final k in measurementKeys)
          if (m[k] != null) '${measurementLabel(l, k)} ${fmtNum(m[k]!)}',
      ].join(' · ');
    case OnbStep.goal:
      return join([
        labelOf(goalOptions(l), p.goal),
        p.targetWeightKg == null ? null : '→ ${fmtNum(p.targetWeightKg!)} ${l.kg}',
        p.goalWeeks == null ? null : l.onbWeeksValue('${p.goalWeeks}'),
      ]);
    case OnbStep.level:
      return join([labelOf(levelOptions(l), p.level), labelOf(experienceOptions(l), p.trainingExperience)]);
    case OnbStep.days:
      final days = sortWeekdaysEgypt(p.trainingDays);
      if (p.daysPerWeek == null) return notSet;
      return days.isEmpty
          ? l.onbPerWeekValue('${p.daysPerWeek}')
          : '${l.onbPerWeekValue('${p.daysPerWeek}')} · ${days.map((d) => weekdayShort(l, d)).join('، ')}';
    case OnbStep.sessionLength:
      return p.sessionMinutes == null ? notSet : l.onbMinutesValue('${p.sessionMinutes}');
    case OnbStep.split:
      return labelOf(splitOptions(l), p.splitPreference) ?? notSet;
    case OnbStep.focus:
      final f = p.focusMuscles;
      return f.isEmpty ? none : f.map((c) => labelOf(muscleOptions(l), c)!).join('، ');
    case OnbStep.location:
      return labelOf(locationOptions(l), p.location) ?? notSet;
    case OnbStep.injuries:
      final all = [...jointInjuryOptions(l), ...healthConditionOptions(l)];
      final parts = [
        ...p.injuries.map((c) => labelOf(all, c)!),
        if (p.injuriesNote != null && p.injuriesNote!.trim().isNotEmpty) p.injuriesNote!.trim(),
      ];
      return parts.isEmpty ? none : parts.join('، ');
    case OnbStep.job:
      return join([labelOf(jobOptions(l), p.jobType), p.jobHours]);
    case OnbStep.sleep:
      if (p.sleepTime == null || p.wakeTime == null) return notSet;
      final h = sleepHours(p.sleepTime, p.wakeTime);
      return '${p.sleepTime} → ${p.wakeTime}${h == null ? '' : ' · ${l.onbSleepDuration(fmtNum(h))}'}';
    case OnbStep.trainingTime:
      return join([labelOf(trainingTimeOptions(l), p.trainingTimeOfDay), p.trainingTime]);
    case OnbStep.cardio:
      if (p.cardioType == null) return notSet;
      if (p.cardioType == 'none') return l.onbCardioNone;
      return join([
        labelOf(cardioOptions(l), p.cardioType),
        p.cardioPerWeek == null ? null : l.onbPerWeekValue('${p.cardioPerWeek}'),
      ]);
    case OnbStep.meals:
      if (p.mealsPerDay == null) return notSet;
      final times = p.mealTimes;
      return times.isEmpty ? '${p.mealsPerDay}' : '${p.mealsPerDay} · ${times.join('، ')}';
    case OnbStep.foods:
      String? list(String? text, List<String> known, String Function(AppLocalizations, String) label) {
        final s = splitChipText(text, known);
        final items = [...s.codes.map((c) => label(l, c)), if (s.other.isNotEmpty) s.other];
        return items.isEmpty ? null : items.join('، ');
      }
      final liked = list(p.likedFoods, egyptianFoods, foodLabel);
      final disliked = list(p.dislikedFoods, egyptianFoods, foodLabel);
      final allergies = list(p.allergies, commonAllergies, allergyLabel);
      final parts = [
        if (liked != null) l.onbLikesValue(liked),
        if (disliked != null) l.onbDislikesValue(disliked),
        if (allergies != null) l.onbAllergiesValue(allergies),
      ];
      return parts.isEmpty ? none : parts.join('\n');
    case OnbStep.budget:
      if (p.budgetLevel != null) return labelOf(budgetOptions(l), p.budgetLevel)!;
      if (p.budgetEgp != null) return '${p.budgetEgp} ${l.onbEgp}';
      return notSet;
    case OnbStep.supplements:
      final s = parseSupplements(p.supplementsJson);
      if (s.isEmpty) return none;
      return s.map((e) => e.dose.trim().isEmpty ? e.name : '${e.name} (${e.dose.trim()})').join('، ');
    case OnbStep.water:
      return p.waterGoalMl == null ? notSet : '${p.waterGoalMl} ${l.mlShort}';
    case OnbStep.healthConnect:
      return p.healthConnectEnabled ? l.onbConnected : l.onbNotConnected;
    case OnbStep.apiKey:
      return hasApiKey ? l.onbKeySet : l.onbKeyNotSet;
    case OnbStep.summary:
      return '';
  }
}

/// All answers grouped by section (summary step + profile editor).
List<SummarySection> buildProfileSummary(
  UserProfile p,
  AppLocalizations l, {
  bool hasApiKey = false,
  Set<OnbStep> exclude = const {},
}) {
  final bySection = <OnbSection, List<SummaryItem>>{};
  for (final step in OnbStep.values) {
    if (step == OnbStep.summary || exclude.contains(step)) continue;
    bySection.putIfAbsent(step.section, () => []).add(SummaryItem(
          step: step,
          label: stepShortLabel(l, step),
          value: summaryValue(step, p, l, hasApiKey: hasApiKey),
          icon: stepIcon(step),
          invalid: validateStep(step, p) != null,
        ));
  }
  return [
    for (final s in OnbSection.values)
      if (bySection[s]?.isNotEmpty ?? false) SummarySection(s, sectionTitle(l, s), bySection[s]!),
  ];
}
