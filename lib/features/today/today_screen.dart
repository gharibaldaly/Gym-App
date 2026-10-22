import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:material_symbols_icons/symbols.dart';

import '../../app/home_shell.dart';
import '../../core/calc/recovery.dart';
import '../../core/navigation.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/context_ext.dart';
import '../../core/widgets/common.dart';
import '../coach/coach_initiatives.dart';
import '../nutrition/nutrition_providers.dart';
import '../tracking/tracking_providers.dart';
import '../tracking/tracking_screens.dart';
import '../workout/live_workout_screen.dart';
import '../workout/today_workout_provider.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final now = DateTime.now();
    final dateLabel = DateFormat.MMMMEEEEd(context.lang).format(now);
    final greeting = now.hour < 12
        ? l.todayGreetMorning
        : now.hour < 17
            ? l.todayGreetAfternoon
            : l.todayGreetEvening;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(todayWorkoutProvider);
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(AppSpace.lg, AppSpace.md, AppSpace.lg, AppSpace.xl),
            children: revealAll([
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpace.md),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(dateLabel, style: context.text.labelMedium),
                          const SizedBox(height: 2),
                          Text(greeting, style: context.text.headlineMedium),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: l.settings,
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.card,
                        side: const BorderSide(color: AppColors.border),
                        fixedSize: const Size(48, 48),
                      ),
                      icon: const Icon(Symbols.settings_rounded),
                      onPressed: () => openSettings(context),
                    ),
                  ],
                ),
              ),
              const _WorkoutCard(),
              const _RecoveryCard(),
              const _RingsCard(),
              const _CoachCard(),
              const _SupplementsCard(),
              const _WeightCard(),
            ]),
          ),
        ),
      ),
    );
  }
}

class _CoachCard extends ConsumerWidget {
  const _CoachCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final msg = ref.watch(latestCoachMessageProvider).value;
    final l = context.l10n;
    return SectionCard(
      title: l.todayCoachTitle,
      icon: Symbols.auto_awesome_rounded,
      trailing: const Icon(Symbols.chevron_forward_rounded, color: AppColors.textMuted),
      onTap: () => ref.read(homeTabProvider.notifier).select(3),
      child: msg == null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l.todayCoachEmpty, style: const TextStyle(color: AppColors.textMuted)),
                const SizedBox(height: 8),
                const AiUnavailableBanner(),
              ],
            )
          : Text(
              msg.content,
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
              style: context.text.bodyMedium?.copyWith(height: 1.5),
            ),
    );
  }
}

class _RecoveryCard extends ConsumerWidget {
  const _RecoveryCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final score = ref.watch(todayRecoveryProvider).value;
    final l = context.l10n;
    if (score == null) {
      return SectionCard(
        title: l.todayRecoveryTitle,
        icon: Symbols.bedtime_rounded,
        iconColor: AppColors.info,
        onTap: () => push(context, const SleepLogScreen()),
        child: Text(l.todayRecoveryEmpty, style: const TextStyle(color: AppColors.textMuted)),
      );
    }
    final level = RecoveryCalc.level(score);
    final (color, text) = switch (level) {
      RecoveryLevel.high => (AppColors.primary, l.todayRecoveryHigh),
      RecoveryLevel.moderate => (AppColors.warning, l.todayRecoveryModerate),
      RecoveryLevel.low => (AppColors.danger, l.todayRecoveryLow),
    };
    return SectionCard(
      title: l.todayRecoveryTitle,
      icon: Symbols.bedtime_rounded,
      iconColor: AppColors.info,
      onTap: () => push(context, const SleepLogScreen()),
      child: Row(
        children: [
          ProgressRing(
            value: score.toDouble(),
            max: 100,
            size: 72,
            stroke: 8,
            color: color,
            center: AnimatedNumber(
              value: score.toDouble(),
              format: (v) => '${v.round()}',
              style: context.text.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(text, style: context.text.bodyMedium)),
        ],
      ),
    );
  }
}

class _WorkoutCard extends ConsumerWidget {
  const _WorkoutCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tw = ref.watch(todayWorkoutProvider).value;
    final l = context.l10n;
    if (tw == null || tw.planDay == null && !tw.isRestDay) {
      return SectionCard(
        title: l.todayWorkoutTitle,
        icon: Symbols.fitness_center_rounded,
        onTap: () => ref.read(homeTabProvider.notifier).select(1),
        child: Text(l.todayNoPlan, style: const TextStyle(color: AppColors.textMuted)),
      );
    }
    if (tw.isRestDay) {
      return SectionCard(
        title: l.todayWorkoutTitle,
        icon: Symbols.self_improvement_rounded,
        iconColor: AppColors.info,
        child: Text(l.todayRestDay, style: context.text.bodyMedium?.copyWith(color: AppColors.textMuted)),
      );
    }
    final session = tw.session;
    final status = session?.status;
    final done = status == 'completed' || status == 'partial';
    final day = tw.planDay!;
    // The lead card of the screen: accent-lit surface, display-size day name, one primary action.
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.24)),
        gradient: RadialGradient(
          center: AlignmentDirectional.topEnd.resolve(Directionality.of(context)),
          radius: 1.3,
          colors: [AppColors.primary.withValues(alpha: 0.13), AppColors.card],
        ),
      ),
      padding: const EdgeInsets.all(AppSpace.xl - 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Symbols.fitness_center_rounded, size: 18, color: AppColors.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(l.todayWorkoutTitle,
                    style: context.text.labelLarge?.copyWith(color: AppColors.primary)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.background.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(l.todayExerciseCount(tw.exerciseCount), style: context.text.labelMedium),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.md),
          Text(day.name, style: context.text.displaySmall?.copyWith(fontSize: 34)),
          if (day.focus != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(day.focus!, style: context.text.bodyMedium?.copyWith(color: AppColors.textMuted)),
            ),
          const SizedBox(height: AppSpace.lg + 4),
          if (done)
            Row(
              children: [
                const IconBadge(Symbols.check_circle_rounded),
                const SizedBox(width: 10),
                Text(l.todayWorkoutDone, style: context.text.titleSmall),
              ],
            )
          else
            Pressable(
              child: FilledButton.icon(
                icon: const Icon(Symbols.play_arrow_rounded, fill: 1, size: 28),
                label: Text(status == 'in_progress' ? l.todayResumeWorkout : l.todayStartWorkout),
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  push(
                    context,
                    LiveWorkoutScreen(planDayId: day.id, sessionId: status == 'in_progress' ? session?.id : null),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _RingsCard extends ConsumerWidget {
  const _RingsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final n = ref.watch(todayNutritionProvider).value ?? const DayNutrition();
    final water = ref.watch(todayWaterProvider).value ?? 0;
    final waterGoal = ref.watch(waterGoalProvider);
    final l = context.l10n;
    final remaining = n.remainingCalories;
    return SectionCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () => ref.read(homeTabProvider.notifier).select(2),
                child: Column(
                  children: [
                    ProgressRing(
                      value: n.calories,
                      max: n.targetCalories,
                      size: 128,
                      center: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedNumber(
                            value: remaining.abs().roundToDouble(),
                            format: (v) => fmtNum(v.roundToDouble()),
                            style: context.text.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          Text(
                            remaining >= 0 ? l.todayKcalLeft : l.todayKcalOver,
                            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(l.calories),
                  ],
                ),
              ),
              InkWell(
                onTap: () => push(context, const WaterScreen()),
                child: Column(
                  children: [
                    ProgressRing(
                      value: water.toDouble(),
                      max: waterGoal.toDouble(),
                      size: 128,
                      color: AppColors.water,
                      center: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedNumber(
                            value: water / 1000,
                            format: (v) => fmtNum(v, maxDecimals: 2),
                            style: context.text.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          Text(
                            '/ ${fmtNum(waterGoal / 1000, maxDecimals: 2)} L',
                            textDirection: TextDirection.ltr,
                            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(l.water),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          MacroBar(
            label: l.protein,
            value: n.protein,
            target: n.targetProtein,
            color: AppColors.protein,
            unit: l.gramsShort,
          ),
          MacroBar(label: l.carbs, value: n.carbs, target: n.targetCarbs, color: AppColors.carbs, unit: l.gramsShort),
          MacroBar(label: l.fat, value: n.fat, target: n.targetFat, color: AppColors.fat, unit: l.gramsShort),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Symbols.water_full_rounded),
                  label: Text(l.todayAddCup),
                  onPressed: () async {
                    HapticFeedback.lightImpact();
                    final cup = ref.read(sharedPrefsProvider).getInt(SettingsKeys.waterCupMl) ?? 250;
                    await addWater(ref, cup);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SupplementsCard extends ConsumerWidget {
  const _SupplementsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(todaySupplementsProvider).value ?? const [];
    final l = context.l10n;
    return SectionCard(
      title: l.todaySupplementsTitle,
      icon: Symbols.pill_rounded,
      iconColor: AppColors.warning,
      trailing: IconButton(
        icon: const Icon(Symbols.edit_rounded, size: 20),
        onPressed: () => push(context, const SupplementsScreen()),
      ),
      child: items.isEmpty
          ? Text(l.todaySupplementsEmpty, style: const TextStyle(color: AppColors.textMuted))
          : Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final (s, taken) in items)
                  FilterChip(
                    label: Text(s.dose == null ? s.name : '${s.name} · ${s.dose}'),
                    selected: taken,
                    showCheckmark: true,
                    checkmarkColor: AppColors.primary,
                    onSelected: (_) async {
                      HapticFeedback.selectionClick();
                      await toggleSupplement(ref, s.id);
                    },
                  ),
              ],
            ),
    );
  }
}

class _WeightCard extends ConsumerWidget {
  const _WeightCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = ref.watch(latestWeightProvider).value;
    final l = context.l10n;
    return SectionCard(
      title: l.todayWeightTitle,
      icon: Symbols.monitor_weight_rounded,
      onTap: () => showWeightQuickLog(context, ref),
      trailing: IconButton(
        icon: const Icon(Symbols.show_chart_rounded, color: AppColors.textMuted),
        onPressed: () => push(context, const BodyWeightScreen()),
      ),
      child: w?.weight == null
          ? Text(l.todayWeightEmpty, style: const TextStyle(color: AppColors.textMuted))
          : Row(
              children: [
                Text(
                  '${fmtNum(w!.weight!)} ${l.kg}',
                  style: context.text.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(width: 12),
                if (w.avg7 != null)
                  Text(l.todayWeightAvg(fmtNum(w.avg7!)), style: const TextStyle(color: AppColors.textMuted)),
              ],
            ),
    );
  }
}
