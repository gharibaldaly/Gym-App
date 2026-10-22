import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/navigation.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/context_ext.dart';
import '../../core/widgets/common.dart';
import 'live_workout_screen.dart';
import 'widgets/plan_day_editor.dart';
import 'widgets/workout_widgets.dart';
import 'workout_logic.dart';
import 'workout_repository.dart';

/// Detail + edit of one plan day, with a button to start it now.
class PlanDayScreen extends ConsumerWidget {
  final int dayId;
  const PlanDayScreen({super.key, required this.dayId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final day = ref.watch(planDayProvider(dayId)).value;
    if (day == null) {
      return Scaffold(appBar: AppBar(), body: const Center(child: CircularProgressIndicator()));
    }
    final warmup = decodeStringList(day.warmupJson);
    final cooldown = decodeStringList(day.cooldownJson);
    final isToday = day.weekday == DateTime.now().weekday;
    return Scaffold(
      appBar: AppBar(title: Text(day.isRest ? l.woRestDay : day.name)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
        children: [
          Row(
            children: [
              Pill(weekdayName(context, day.weekday ?? 1), icon: Symbols.event_rounded),
              if (isToday) ...[const SizedBox(width: 8), Pill(l.today, color: AppColors.info)],
            ],
          ),
          if ((day.focus ?? '').isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(day.focus!, style: const TextStyle(color: AppColors.textMuted)),
          ],
          const SizedBox(height: 8),
          if (day.isRest)
            EmptyState(icon: Symbols.bedtime_rounded, text: l.woRestDayBody)
          else ...[
            if (warmup.isNotEmpty) SectionCard(title: l.woWarmup, child: StepsList(steps: warmup)),
            SectionCard(title: l.woExercises, child: PlanDayEditor(dayId: dayId)),
            if (cooldown.isNotEmpty) SectionCard(title: l.woCooldown, child: StepsList(steps: cooldown)),
          ],
        ],
      ),
      bottomNavigationBar: day.isRest
          ? null
          : SafeArea(
              minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: FilledButton.icon(
                icon: const Icon(Symbols.play_arrow_rounded, fill: 1),
                label: Text(isToday ? l.woStartToday : l.woStartThisWorkout),
                onPressed: () => push(context, LiveWorkoutScreen(planDayId: dayId)),
              ),
            ),
    );
  }
}
