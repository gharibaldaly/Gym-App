import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/context_ext.dart';
import '../../core/widgets/common.dart';
import 'widgets/plan_day_editor.dart';
import 'widgets/workout_widgets.dart';
import 'workout_logic.dart';
import 'workout_repository.dart';

/// Review/edit a generated plan (remove/add/swap/reorder) then approve (activate).
class PlanReviewScreen extends ConsumerStatefulWidget {
  final int planId;
  final VoidCallback? onApproved;
  const PlanReviewScreen({super.key, required this.planId, this.onApproved});

  @override
  ConsumerState<PlanReviewScreen> createState() => _PlanReviewScreenState();
}

class _PlanReviewScreenState extends ConsumerState<PlanReviewScreen> {
  bool _busy = false;

  Future<void> _approve() async {
    setState(() => _busy = true);
    try {
      await ref.read(workoutRepositoryProvider).approvePlan(widget.planId);
      if (!mounted) return;
      context.snack(context.l10n.woPlanApproved, kind: ToastKind.success);
      if (widget.onApproved != null) {
        widget.onApproved!();
      } else {
        Navigator.of(context).maybePop();
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final plan = ref.watch(planProvider(widget.planId));
    final days = ref.watch(planDaysProvider(widget.planId)).value ?? const <PlanDay>[];
    final p = plan.value;
    final order = weekOrder(ar: context.isAr);
    final sorted = [...days]..sort((a, b) => order.indexOf(a.weekday ?? 1).compareTo(order.indexOf(b.weekday ?? 1)));
    final alreadyActive = p?.isActive ?? false;

    return Scaffold(
      appBar: AppBar(title: Text(alreadyActive ? l.woEditPlan : l.woReviewPlan)),
      body: plan.isLoading
          ? const Center(child: CircularProgressIndicator())
          : p == null
              ? Center(child: Text(l.woPlanNotFound))
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                  children: [
                    SectionCard(
                      title: p.name,
                      trailing: Pill(p.source == 'ai' ? l.woSourceAi : l.woSourceTemplate,
                          icon: p.source == 'ai' ? Symbols.auto_awesome_rounded : Symbols.bolt_rounded),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if ((p.notes ?? '').isNotEmpty) Text(p.notes!),
                          if (p.deloadEveryWeeks != null) ...[
                            const SizedBox(height: 8),
                            Text(l.woDeloadEvery(p.deloadEveryWeeks!), style: const TextStyle(color: AppColors.textMuted)),
                          ],
                          if (!alreadyActive) ...[
                            const SizedBox(height: 8),
                            Text(l.woReviewHint, style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
                          ],
                        ],
                      ),
                    ),
                    for (final d in sorted) _ReviewDayCard(day: d),
                  ],
                ),
      bottomNavigationBar: p == null
          ? null
          : SafeArea(
              minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: FilledButton.icon(
                onPressed: _busy ? null : (alreadyActive ? () => Navigator.of(context).maybePop() : _approve),
                icon: Icon(alreadyActive ? Symbols.check_rounded : Symbols.verified_rounded),
                label: Text(alreadyActive ? l.done : l.woApprovePlan),
              ),
            ),
    );
  }
}

class _ReviewDayCard extends StatelessWidget {
  final PlanDay day;
  const _ReviewDayCard({required this.day});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final wd = weekdayName(context, day.weekday ?? 1);
    if (day.isRest) {
      return Card(
        child: ListTile(
          leading: const Icon(Symbols.bedtime_rounded, color: AppColors.rest),
          title: Text(wd),
          subtitle: Text(l.woRestDay, style: const TextStyle(color: AppColors.textMuted)),
        ),
      );
    }
    final warmup = decodeStringList(day.warmupJson);
    final cooldown = decodeStringList(day.cooldownJson);
    return SectionCard(
      title: '$wd · ${day.name}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if ((day.focus ?? '').isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(day.focus!, style: const TextStyle(color: AppColors.textMuted)),
            ),
          if (warmup.isNotEmpty)
            _StepsExpansion(icon: Symbols.local_fire_department_rounded, title: l.woWarmup, steps: warmup),
          PlanDayEditor(dayId: day.id),
          if (cooldown.isNotEmpty)
            _StepsExpansion(icon: Symbols.self_improvement_rounded, title: l.woCooldown, steps: cooldown),
        ],
      ),
    );
  }
}

class _StepsExpansion extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<String> steps;
  const _StepsExpansion({required this.icon, required this.title, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsetsDirectional.only(start: 8, bottom: 8),
        leading: Icon(icon, color: AppColors.primary),
        title: Text('$title (${steps.length})'),
        children: [StepsList(steps: steps)],
      ),
    );
  }
}
