import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';

import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/context_ext.dart';
import '../../../core/widgets/common.dart';
import '../../../data/repositories/profile_repository.dart';
import '../onboarding_labels.dart';
import '../onboarding_logic.dart';
import '../onboarding_summary.dart';
import '../onboarding_widgets.dart';
import 'step_types.dart';

/// Step 7 – days per week + the weekdays themselves (Sat → Fri).
class DaysStep extends StatelessWidget {
  final UserProfile profile;
  final ProfilePatch onChanged;
  const DaysStep({super.key, required this.profile, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = profile;
    final days = sortWeekdaysEgypt(p.trainingDays);
    final count = p.daysPerWeek;
    final matches = count != null && days.length == count;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NumberPills(
          values: const [2, 3, 4, 5, 6, 7],
          selected: count,
          onSelect: (n) => onChanged(UserProfilesCompanion(
            daysPerWeek: Value(n),
            // Keep the user's picks when they already match, otherwise suggest a spread.
            trainingDaysJson: days.length == n ? const Value.absent() : Value(jsonEncode(suggestTrainingDays(n))),
          )),
        ),
        if (count != null) ...[
          FieldHeading(
            l.onbPickDays,
            trailing: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                l.onbDaysPicked('${days.length}', '$count'),
                key: ValueKey(days.length),
                style: TextStyle(
                  color: matches ? AppColors.primary : AppColors.warning,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          LayoutBuilder(builder: (context, c) {
            final w = (c.maxWidth - 3 * 8) / 4;
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final d in egyptWeekOrder)
                  SizedBox(
                    width: w,
                    child: DayToggle(
                      label: weekdayShort(l, d),
                      selected: days.contains(d),
                      onTap: () => onChanged(
                        UserProfilesCompanion(trainingDaysJson: Value(jsonEncode(toggleWeekday(days, d)))),
                      ),
                    ),
                  ),
              ],
            );
          }),
          if (!matches)
            InfoNote(l.onbErrDaysMismatch('$count'), icon: Icons.touch_app_outlined, color: AppColors.warning),
        ],
      ],
    );
  }
}

/// Step 8 – session length.
class SessionLengthStep extends StatelessWidget {
  final UserProfile profile;
  final ProfilePatch onChanged;
  const SessionLengthStep({super.key, required this.profile, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    String? sub(int m) => switch (m) {
          30 => l.onbSession30,
          60 => l.onbSession60,
          90 => l.onbSession90,
          _ => null,
        };
    return OptionCards<int>(
      options: [
        for (final m in sessionMinuteOptions)
          OnbOption(m, l.onbMinutesValue('$m'), subtitle: sub(m), icon: Icons.timer_outlined),
      ],
      selected: profile.sessionMinutes,
      onSelect: (m) => onChanged(UserProfilesCompanion(sessionMinutes: Value(m))),
    );
  }
}

/// Step 9 – split preference.
class SplitStep extends StatelessWidget {
  final UserProfile profile;
  final ProfilePatch onChanged;
  const SplitStep({super.key, required this.profile, required this.onChanged});

  @override
  Widget build(BuildContext context) => OptionCards<String>(
        options: splitOptions(context.l10n),
        selected: profile.splitPreference,
        onSelect: (v) => onChanged(UserProfilesCompanion(splitPreference: Value(v))),
      );
}

/// Step 10 – focus muscles (multi-select, optional).
class FocusStep extends StatelessWidget {
  final UserProfile profile;
  final ProfilePatch onChanged;
  const FocusStep({super.key, required this.profile, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final selected = profile.focusMuscles.toSet();
    return ToggleTileGrid<String>(
      options: muscleOptions(context.l10n),
      isSelected: selected.contains,
      onToggle: (c) {
        final next = {...selected};
        if (!next.remove(c)) next.add(c);
        final ordered = focusMuscleCodes.where(next.contains).toList();
        onChanged(UserProfilesCompanion(focusMusclesJson: Value(jsonEncode(ordered))));
      },
    );
  }
}

/// Step 11 – training location.
class LocationStep extends StatelessWidget {
  final UserProfile profile;
  final ProfilePatch onChanged;
  const LocationStep({super.key, required this.profile, required this.onChanged});

  @override
  Widget build(BuildContext context) => OptionCards<String>(
        options: locationOptions(context.l10n),
        selected: profile.location,
        onSelect: (v) => onChanged(UserProfilesCompanion(location: Value(v))),
      );
}

/// Step 12 – injuries & health conditions + free text.
class InjuriesStep extends StatelessWidget {
  final UserProfile profile;
  final ProfilePatch onChanged;
  const InjuriesStep({super.key, required this.profile, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final selected = profile.injuries.toSet();
    void toggle(String c) {
      final next = {...selected};
      if (!next.remove(c)) next.add(c);
      final ordered = [...jointInjuryCodes, ...healthConditionCodes].where(next.contains).toList();
      onChanged(UserProfilesCompanion(injuriesJson: Value(jsonEncode(ordered))));
    }

    final serious = selected.contains('heart') || selected.contains('hypertension');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ChoiceCard(
          label: l.onbInjNoneLabel,
          icon: Icons.verified_outlined,
          selected: selected.isEmpty,
          onTap: () => onChanged(const UserProfilesCompanion(injuriesJson: Value('[]'))),
        ),
        FieldHeading(l.onbInjGroupJoints),
        ToggleTileGrid<String>(options: jointInjuryOptions(l), isSelected: selected.contains, onToggle: toggle),
        FieldHeading(l.onbInjGroupHealth),
        ToggleTileGrid<String>(
            options: healthConditionOptions(l), isSelected: selected.contains, onToggle: toggle),
        const SizedBox(height: 12),
        TextAnswerField(
          label: l.onbInjuriesNote,
          value: profile.injuriesNote,
          maxLines: 3,
          icon: Icons.edit_note,
          onChanged: (t) =>
              onChanged(UserProfilesCompanion(injuriesNote: Value(t.trim().isEmpty ? null : t.trim()))),
        ),
        if (serious)
          InfoNote(l.onbInjuriesDoctor, icon: Icons.local_hospital_outlined, color: AppColors.danger),
      ],
    );
  }
}

/// Step 13 – job type + working hours.
class JobStep extends StatelessWidget {
  final UserProfile profile;
  final ProfilePatch onChanged;
  const JobStep({super.key, required this.profile, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final hours = profile.jobHours?.split('-');
    final from = hours != null && hours.length == 2 ? hours[0] : null;
    final to = hours != null && hours.length == 2 ? hours[1] : null;
    void setHours(String? f, String? t) => onChanged(UserProfilesCompanion(
          jobHours: Value(f == null && t == null ? null : '${f ?? '09:00'}-${t ?? '17:00'}'),
        ));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OptionCards<String>(
          options: jobOptions(l),
          selected: profile.jobType,
          onSelect: (v) => onChanged(UserProfilesCompanion(jobType: Value(v))),
        ),
        FieldHeading(
          l.onbJobHours,
          trailing: profile.jobHours == null
              ? null
              : TextButton(onPressed: () => setHours(null, null), child: Text(l.onbClear)),
        ),
        TimeTile(
          label: l.onbJobFrom,
          value: from,
          fallback: '09:00',
          icon: Icons.login,
          onChanged: (v) => setHours(v, to),
        ),
        TimeTile(
          label: l.onbJobTo,
          value: to,
          fallback: '17:00',
          icon: Icons.logout,
          onChanged: (v) => setHours(from, v),
        ),
      ],
    );
  }
}

/// Step 14 – usual bedtime and wake-up time.
class SleepStep extends StatelessWidget {
  final UserProfile profile;
  final ProfilePatch onChanged;
  const SleepStep({super.key, required this.profile, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final h = sleepHours(profile.sleepTime, profile.wakeTime);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TimeTile(
          label: l.onbSleepTime,
          value: profile.sleepTime,
          fallback: defaultSleepTime,
          icon: Icons.bedtime_outlined,
          onChanged: (v) => onChanged(UserProfilesCompanion(sleepTime: Value(v))),
        ),
        TimeTile(
          label: l.onbWakeTime,
          value: profile.wakeTime,
          fallback: defaultWakeTime,
          icon: Icons.wb_sunny_outlined,
          onChanged: (v) => onChanged(UserProfilesCompanion(wakeTime: Value(v))),
        ),
        if (h != null) ...[
          const SizedBox(height: 16),
          Center(
            child: Text(
              l.onbSleepDuration(fmtNum(h)),
              style: context.text.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: h >= 7 ? AppColors.primary : AppColors.warning,
              ),
            ),
          ),
          if (h < 7) InfoNote(l.onbSleepShort, icon: Icons.nightlight_outlined, color: AppColors.warning),
        ],
      ],
    );
  }
}

/// Step 15 – usual training time of day + exact time.
class TrainingTimeStep extends StatelessWidget {
  final UserProfile profile;
  final ProfilePatch onChanged;
  const TrainingTimeStep({super.key, required this.profile, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = profile;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OptionCards<String>(
          options: trainingTimeOptions(l),
          selected: p.trainingTimeOfDay,
          onSelect: (v) {
            // Move the exact time along unless the user already customized it.
            final followsDefault =
                p.trainingTime == null || p.trainingTime == defaultTrainingTime(p.trainingTimeOfDay ?? '');
            onChanged(UserProfilesCompanion(
              trainingTimeOfDay: Value(v),
              trainingTime: followsDefault ? Value(defaultTrainingTime(v)) : const Value.absent(),
            ));
          },
        ),
        if (p.trainingTimeOfDay != null) ...[
          FieldHeading(l.onbExactTime),
          TimeTile(
            label: l.onbExactTime,
            value: p.trainingTime,
            fallback: defaultTrainingTime(p.trainingTimeOfDay!),
            icon: Icons.fitness_center,
            onChanged: (v) => onChanged(UserProfilesCompanion(trainingTime: Value(v))),
          ),
        ],
      ],
    );
  }
}

/// Step 16 – cardio type + times per week.
class CardioStep extends StatelessWidget {
  final UserProfile profile;
  final ProfilePatch onChanged;
  const CardioStep({super.key, required this.profile, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = profile;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ToggleTileGrid<String>(
          options: cardioOptions(l),
          isSelected: (c) => p.cardioType == c,
          onToggle: (c) => onChanged(UserProfilesCompanion(
            cardioType: Value(c),
            cardioPerWeek: c == 'none'
                ? const Value(0)
                : ((p.cardioPerWeek ?? 0) < 1 ? const Value(2) : const Value.absent()),
          )),
        ),
        if (p.cardioType != null && p.cardioType != 'none') ...[
          FieldHeading(l.onbCardioPerWeek),
          NumberPills(
            values: const [1, 2, 3, 4, 5, 6, 7],
            selected: p.cardioPerWeek,
            onSelect: (n) => onChanged(UserProfilesCompanion(cardioPerWeek: Value(n))),
          ),
        ],
      ],
    );
  }
}
