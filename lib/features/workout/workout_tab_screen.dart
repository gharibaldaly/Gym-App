import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../ai/ai_service.dart';
import '../../core/navigation.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/context_ext.dart';
import '../../core/widgets/common.dart';
import '../exercises/exercise_library_screen.dart';
import 'deload.dart';
import 'live_workout_screen.dart';
import 'plan_day_screen.dart';
import 'plan_generator.dart';
import 'plan_review_screen.dart';
import 'session_summary_screen.dart';
import 'today_workout_provider.dart';
import 'widgets/workout_widgets.dart';
import 'workout_logic.dart';
import 'workout_repository.dart';

/// Selected segment of the Workout tab (0 plan, 1 history, 2 library).
final workoutSegmentProvider = NotifierProvider<WorkoutSegmentNotifier, int>(WorkoutSegmentNotifier.new);

class WorkoutSegmentNotifier extends Notifier<int> {
  @override
  int build() => 0;
  void select(int i) => state = i;
}

class WorkoutTabScreen extends ConsumerWidget {
  const WorkoutTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final seg = ref.watch(workoutSegmentProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.tabWorkout),
        actions: [IconButton(onPressed: () => openSettings(context), icon: const Icon(Symbols.settings_rounded))],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: SizedBox(
              width: double.infinity,
              child: SegmentedButton<int>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(value: 0, label: Text(l.woWeeklyPlan), icon: const Icon(Symbols.calendar_view_week_rounded)),
                  ButtonSegment(value: 1, label: Text(l.woHistory), icon: const Icon(Symbols.history_rounded)),
                  ButtonSegment(value: 2, label: Text(l.woLibrary), icon: const Icon(Symbols.menu_book_rounded)),
                ],
                selected: {seg},
                onSelectionChanged: (s) => ref.read(workoutSegmentProvider.notifier).select(s.first),
              ),
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: seg,
              children: const [_WeeklyPlanView(), _HistoryView(), ExerciseLibraryScreen()],
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// Plan actions (shared by the empty state and the plan tools card)
// ----------------------------------------------------------------------------

Future<void> generatePlanWithAi(BuildContext context, WidgetRef ref, {bool confirm = true}) async {
  final l = context.l10n;
  if (confirm && ref.read(activePlanProvider).value != null) {
    final ok = await confirmDialog(context, title: l.woRegenerateTitle, body: l.woRegenerateBody, confirm: l.woRegenerate);
    if (!ok || !context.mounted) return;
  }
  try {
    final id = await runWithProgress(context, l.woGeneratingPlan, () => ref.read(workoutPlanGeneratorProvider).generateAndSave());
    if (context.mounted) await push(context, PlanReviewScreen(planId: id));
  } catch (e) {
    if (context.mounted) context.snack(aiErrorText(e, ar: context.isAr), kind: ToastKind.error);
  }
}

Future<void> buildTemplatePlan(BuildContext context, WidgetRef ref) async {
  final l = context.l10n;
  if (ref.read(activePlanProvider).value != null) {
    final ok = await confirmDialog(context, title: l.woTemplateTitle, body: l.woTemplateBody, confirm: l.woBuildTemplate);
    if (!ok || !context.mounted) return;
  }
  try {
    final id = await ref.read(workoutPlanGeneratorProvider).buildTemplatePlan();
    if (context.mounted) await push(context, PlanReviewScreen(planId: id));
  } catch (e) {
    if (context.mounted) context.snack('${l.errorGeneric}: $e', kind: ToastKind.error);
  }
}

// ----------------------------------------------------------------------------
// Weekly plan
// ----------------------------------------------------------------------------

class _WeeklyPlanView extends ConsumerWidget {
  const _WeeklyPlanView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final active = ref.watch(activePlanProvider);
    final pending = ref.watch(pendingPlansProvider).value ?? const <WorkoutPlan>[];
    if (active.isLoading) return const Center(child: CircularProgressIndicator());
    final plan = active.value;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      children: [
        if (pending.isNotEmpty)
          Card(
            color: AppColors.primary.withValues(alpha: 0.12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: AppColors.primary),
            ),
            child: ListTile(
              leading: const Icon(Symbols.fact_check_rounded, fill: 1, color: AppColors.primary),
              title: Text(l.woPendingPlan),
              subtitle: Text(pending.first.name),
              trailing: const Icon(Symbols.chevron_right_rounded),
              onTap: () => push(context, PlanReviewScreen(planId: pending.first.id)),
            ),
          ),
        if (plan == null) const _NoPlanCard() else ...[
          const _DeloadCard(),
          const _TodayCard(),
          _WeekDays(plan: plan),
          const SizedBox(height: 8),
          _PlanToolsCard(plan: plan),
        ],
      ],
    );
  }
}

class _NoPlanCard extends ConsumerWidget {
  const _NoPlanCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final aiReady = ref.watch(hasApiKeyProvider) && ref.watch(isOnlineProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EmptyState(icon: Symbols.calendar_month_rounded, text: l.woNoPlan),
        const AiUnavailableBanner(),
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: aiReady ? () => generatePlanWithAi(context, ref, confirm: false) : null,
          icon: const Icon(Symbols.auto_awesome_rounded),
          label: Text(l.woGenerateWithAi),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => buildTemplatePlan(context, ref),
          icon: const Icon(Symbols.bolt_rounded),
          label: Text(l.woBuildTemplate),
        ),
      ],
    );
  }
}

class _TodayCard extends ConsumerWidget {
  const _TodayCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final t = ref.watch(todayWorkoutProvider).value;
    if (t == null) return const SizedBox.shrink();
    final s = t.session;
    final Widget action;
    if (t.inProgress) {
      action = FilledButton.icon(
        onPressed: () => push(context, LiveWorkoutScreen(sessionId: s!.id, planDayId: s.planDayId)),
        icon: const Icon(Symbols.play_arrow_rounded, fill: 1),
        label: Text(l.woResumeWorkout),
      );
    } else if (t.finished) {
      action = OutlinedButton.icon(
        onPressed: () => push(context, SessionSummaryScreen(sessionId: s.id)),
        icon: Icon(sessionStatusIcon(s!.status)),
        label: Text(l.woViewSummary),
      );
    } else if (t.isRestDay) {
      action = OutlinedButton.icon(
        onPressed: () => push(context, const LiveWorkoutScreen()),
        icon: const Icon(Symbols.add_rounded),
        label: Text(l.woStartEmpty),
      );
    } else {
      action = SizedBox(
        height: 60,
        child: FilledButton.icon(
          onPressed: () => push(context, LiveWorkoutScreen(planDayId: t.planDay?.id)),
          icon: const Icon(Symbols.play_arrow_rounded, fill: 1, size: 28),
          label: Text(l.woStartToday, style: const TextStyle(fontSize: 18)),
        ),
      );
    }
    return SectionCard(
      title: l.woTodayTitle,
      trailing: s == null ? null : Pill(sessionStatusLabel(context, s.status), color: sessionStatusColor(s.status)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            t.isRestDay ? l.woRestDay : (t.planDay?.name ?? ''),
            style: context.text.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          if (!t.isRestDay && t.planDay != null)
            Text(
              [if ((t.planDay!.focus ?? '').isNotEmpty) t.planDay!.focus!, l.woExerciseCount(t.exerciseCount)].join(' · '),
              style: const TextStyle(color: AppColors.textMuted),
            ),
          if (t.isRestDay) Text(l.woRestDayBody, style: const TextStyle(color: AppColors.textMuted)),
          const SizedBox(height: 12),
          action,
        ],
      ),
    );
  }
}

class _WeekDays extends ConsumerWidget {
  final WorkoutPlan plan;
  const _WeekDays({required this.plan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final days = ref.watch(planDaysProvider(plan.id)).value ?? const <PlanDay>[];
    final counts = ref.watch(planExerciseCountsProvider(plan.id)).value ?? const <int, int>{};
    final order = weekOrder(ar: context.isAr);
    final start = displayWeekStart(DateTime.now(), order);
    final weekSessions = ref.watch(weekSessionsProvider(start)).value ?? const <DateTime, WorkoutSession>{};
    final todayWd = DateTime.now().weekday;
    final byWd = {for (final d in days) d.weekday ?? 0: d};

    return SectionCard(
      title: plan.name,
      child: Column(
        children: [
          for (var i = 0; i < order.length; i++)
            if (byWd[order[i]] != null)
              _DayTile(
                day: byWd[order[i]]!,
                date: DateTime(start.year, start.month, start.day + i),
                isToday: order[i] == todayWd,
                count: counts[byWd[order[i]]!.id] ?? 0,
                session: weekSessions[DateTime(start.year, start.month, start.day + i)],
              ),
          if (days.isEmpty) Text(l.woNoExercises),
        ],
      ),
    );
  }
}

class _DayTile extends StatelessWidget {
  final PlanDay day;
  final DateTime date;
  final bool isToday;
  final int count;
  final WorkoutSession? session;
  const _DayTile({required this.day, required this.date, required this.isToday, required this.count, this.session});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final rest = day.isRest;
    final s = session;
    // Material (not a decorated Container) so the ListTile's ink ripple is visible.
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Material(
        color: isToday ? AppColors.primary.withValues(alpha: 0.10) : AppColors.cardHigh,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(color: isToday ? AppColors.primary : AppColors.border, width: isToday ? 1.5 : 1),
        ),
        child: ListTile(
        onTap: () => push(context, PlanDayScreen(dayId: day.id)),
        leading: SizedBox(
          width: 44,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(weekdayName(context, day.weekday ?? 1),
                  style: TextStyle(fontWeight: FontWeight.w800, color: isToday ? AppColors.primary : null)),
              Text(DateFormat.d(context.lang).format(date), style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
            ],
          ),
        ),
        title: Text(rest ? l.woRestDay : day.name,
            style: TextStyle(fontWeight: FontWeight.w700, color: rest ? AppColors.textMuted : null)),
        subtitle: rest
            ? null
            : Text([if ((day.focus ?? '').isNotEmpty) day.focus!, l.woExerciseCount(count)].join(' · '),
                maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: s != null
            ? Icon(sessionStatusIcon(s.status), color: sessionStatusColor(s.status))
            : (rest ? const Icon(Symbols.bedtime_rounded, color: AppColors.rest) : const Icon(Symbols.chevron_right_rounded)),
        ),
      ),
    );
  }
}

class _DeloadCard extends ConsumerWidget {
  const _DeloadCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final st = ref.watch(deloadStatusProvider).value;
    if (st == null) return const SizedBox.shrink();
    final db = ref.read(databaseProvider);
    final prefs = ref.read(sharedPrefsProvider);
    if (st.active) {
      final start = st.activeStart ?? today();
      final dayN = today().difference(dayOf(start)).inDays + 1;
      return Card(
        color: AppColors.info.withValues(alpha: 0.12),
        child: ListTile(
          leading: const Icon(Symbols.south_rounded, color: AppColors.info),
          title: Text(l.woDeloadActiveTitle(dayN.clamp(1, 7))),
          subtitle: Text(l.woDeloadActiveBody),
          trailing: TextButton(
            onPressed: () async {
              await endDeloadWeek(prefs);
              ref.invalidate(deloadStatusProvider);
            },
            child: Text(l.woEndDeload),
          ),
        ),
      );
    }
    if (!st.showSuggestion) return const SizedBox.shrink();
    return SectionCard(
      title: l.woDeloadDueTitle,
      trailing: const Icon(Symbols.battery_charging_full_rounded, color: AppColors.info),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(st.reason == 'performance' ? l.woDeloadDuePerformance : l.woDeloadDueSchedule(st.weeksSince)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    await snoozeDeload(db);
                    ref.invalidate(deloadStatusProvider);
                  },
                  child: Text(l.woNotNow),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton(
                  onPressed: () async {
                    await startDeloadWeek(db, prefs);
                    ref.invalidate(deloadStatusProvider);
                  },
                  child: Text(l.woStartDeload),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlanToolsCard extends ConsumerWidget {
  final WorkoutPlan plan;
  const _PlanToolsCard({required this.plan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final aiReady = ref.watch(hasApiKeyProvider) && ref.watch(isOnlineProvider);
    return SectionCard(
      title: l.woPlanTools,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if ((plan.notes ?? '').isNotEmpty) ...[
            Text(plan.notes!, style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
            const SizedBox(height: 12),
          ],
          OutlinedButton.icon(
            onPressed: () => push(context, PlanReviewScreen(planId: plan.id)),
            icon: const Icon(Symbols.edit_calendar_rounded),
            label: Text(l.woEditPlan),
          ),
          const SizedBox(height: 8),
          const AiUnavailableBanner(),
          FilledButton.icon(
            onPressed: aiReady ? () => generatePlanWithAi(context, ref) : null,
            icon: const Icon(Symbols.auto_awesome_rounded),
            label: Text(l.woRegenerate),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () => buildTemplatePlan(context, ref),
            icon: const Icon(Symbols.bolt_rounded),
            label: Text(l.woBuildTemplate),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// History
// ----------------------------------------------------------------------------

class _HistoryView extends ConsumerWidget {
  const _HistoryView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final items = ref.watch(workoutHistoryProvider);
    final list = items.value;
    if (list == null) return const Center(child: CircularProgressIndicator());
    if (list.isEmpty) return EmptyState(icon: Symbols.history_rounded, text: l.woNoHistory);
    final fmt = DateFormat.MMMEd(context.lang);
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      itemCount: list.length,
      itemBuilder: (context, i) {
        final it = list[i];
        final s = it.session;
        final color = sessionStatusColor(s.status);
        final dur = s.startedAt != null && s.endedAt != null ? s.endedAt!.difference(s.startedAt!) : null;
        final details = <String>[
          sessionStatusLabel(context, s.status),
          if (dur != null) fmtDuration(dur),
          if (s.status != SessionStatus.missed && it.sets > 0) l.woSetsCount(it.sets),
          if ((s.totalVolume ?? 0) > 0) '${fmtNum(s.totalVolume!, maxDecimals: 0)} ${l.kg}',
        ];
        return Card(
          child: ListTile(
            onTap: () => push(context, SessionSummaryScreen(sessionId: s.id)),
            leading: Container(
              width: 6,
              height: 40,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
            ),
            title: Text('${fmt.format(s.date)} · ${s.name ?? l.woWorkout}', style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text(details.join(' · '), style: TextStyle(color: s.status == SessionStatus.missed ? color : AppColors.textMuted)),
            trailing: it.prs > 0
                ? Pill('${it.prs} PR', color: AppColors.warning, icon: Symbols.trophy_rounded)
                : Icon(sessionStatusIcon(s.status), color: color),
          ),
        );
      },
    );
  }
}
