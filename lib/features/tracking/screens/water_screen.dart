import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/context_ext.dart';
import '../../../core/widgets/common.dart';
import '../tracking_providers.dart';
import '../widgets/tracking_widgets.dart';

class WaterScreen extends ConsumerWidget {
  const WaterScreen({super.key});

  Future<void> _add(BuildContext context, WidgetRef ref, int ml) async {
    HapticFeedback.lightImpact();
    await addWater(ref, ml);
    if (context.mounted) context.snack(context.l10n.trkWaterAdded(ml), kind: ToastKind.success);
  }

  Future<void> _undo(BuildContext context, WidgetRef ref) async {
    final ml = await undoLastWater(ref);
    if (ml != null && context.mounted) context.snack(context.l10n.trkUndone(ml));
  }

  Future<void> _custom(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    final v = await askNumber(context, title: l.trkAddCustom, label: l.trkAmountMl, min: 1, max: 5000, decimals: false);
    if (v != null && context.mounted) await _add(context, ref, v.round());
  }

  Future<void> _sizes(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    final sizes = ref.read(waterContainersProvider);
    final notifier = ref.read(waterContainersProvider.notifier);
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l.trkWaterSizes, style: ctx.text.titleMedium),
            ListTile(
              leading: const Icon(Symbols.water_full_rounded),
              title: Text(l.trkCupSize),
              trailing: Text('${sizes.cup}'),
              onTap: () async {
                final v = await askNumber(ctx,
                    title: l.trkCupSize, label: l.trkAmountMl, initial: sizes.cup.toDouble(), min: 50, max: 2000, decimals: false);
                if (v != null) await notifier.setCup(v.round());
                if (ctx.mounted) Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: const Icon(Symbols.water_drop_rounded),
              title: Text(l.trkBottleSize),
              trailing: Text('${sizes.bottle}'),
              onTap: () async {
                final v = await askNumber(ctx,
                    title: l.trkBottleSize, label: l.trkAmountMl, initial: sizes.bottle.toDouble(), min: 100, max: 5000, decimals: false);
                if (v != null) await notifier.setBottle(v.round());
                if (ctx.mounted) Navigator.pop(ctx);
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final drunk = ref.watch(todayWaterProvider).value ?? 0;
    final goal = ref.watch(waterGoalProvider);
    final sizes = ref.watch(waterContainersProvider);
    final entries = ref.watch(todayWaterEntriesProvider);
    final week = ref.watch(waterWeekProvider).value;
    final day = ref.watch(currentDayProvider);
    final remaining = goal - drunk;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.trkWaterTitle),
        actions: [
          IconButton(tooltip: l.trkWaterSizes, icon: const Icon(Symbols.tune_rounded), onPressed: () => _sizes(context, ref)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          SectionCard(
            child: Column(
              children: [
                ProgressRing(
                  value: drunk.toDouble(),
                  max: goal.toDouble(),
                  size: 180,
                  stroke: 14,
                  color: AppColors.water,
                  center: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Symbols.water_drop_rounded, fill: 1, color: AppColors.water, size: 28),
                      Text('${goal <= 0 ? 0 : (drunk * 100 / goal).round()}%',
                          style: context.text.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
                      Text(l.trkWaterProgress(drunk, goal),
                          style: context.text.bodySmall?.copyWith(color: AppColors.textMuted)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  remaining > 0 ? l.trkWaterRemaining(remaining) : l.trkWaterGoalReached,
                  style: context.text.titleSmall?.copyWith(color: remaining > 0 ? AppColors.text : AppColors.primary),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(minimumSize: const Size(0, 64)),
                        onPressed: () => _add(context, ref, sizes.cup),
                        icon: const Icon(Symbols.water_full_rounded, fill: 1),
                        label: Text(l.trkAddCup(sizes.cup)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(0, 64),
                          backgroundColor: AppColors.water,
                        ),
                        onPressed: () => _add(context, ref, sizes.bottle),
                        icon: const Icon(Symbols.water_drop_rounded, fill: 1),
                        label: Text(l.trkAddBottle(sizes.bottle)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _custom(context, ref),
                        icon: const Icon(Symbols.edit_rounded, fill: 1),
                        label: Text(l.trkAddCustom),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: drunk > 0 ? () => _undo(context, ref) : null,
                        icon: const Icon(Symbols.undo_rounded),
                        label: Text(l.trkUndoLast),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (week != null)
            SectionCard(
              title: l.trkLast7Days,
              trailing: Text(l.trkGoalLabel(goal), style: context.text.bodySmall),
              child: WeekBars(
                values: week.map((e) => e.toDouble()).toList(),
                lastDay: day,
                goal: goal.toDouble(),
                color: AppColors.water,
                tooltip: (v) => '${v.round()} ${l.mlShort}',
              ),
            ),
          SectionCard(
            title: l.trkTodayEntries,
            child: entries.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text(l.errorGeneric),
              data: (list) => list.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(l.trkNoWaterYet, style: const TextStyle(color: AppColors.textMuted)),
                    )
                  : Column(
                      children: [
                        for (final w in list)
                          Dismissible(
                            key: ValueKey(w.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: AlignmentDirectional.centerEnd,
                              padding: const EdgeInsetsDirectional.only(end: 16),
                              color: AppColors.danger.withValues(alpha: 0.3),
                              child: const Icon(Symbols.delete_rounded, fill: 1),
                            ),
                            onDismissed: (_) => ref.read(trackingRepositoryProvider).deleteWater(w.id),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Symbols.water_drop_rounded, color: AppColors.water),
                              title: Text('${w.amountMl} ${l.mlShort}'),
                              trailing: Text(fmtTime(context, w.timestamp),
                                  style: const TextStyle(color: AppColors.textMuted)),
                            ),
                          ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
