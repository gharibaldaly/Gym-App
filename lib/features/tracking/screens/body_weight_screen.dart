import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/calc/stats.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/context_ext.dart';
import '../../../core/widgets/common.dart';
import '../../../data/repositories/profile_repository.dart';
import '../tracking_providers.dart';
import '../widgets/tracking_widgets.dart';

/// Quick weight dialog (used by the Today tab). Returns the saved weight or null.
Future<double?> showWeightQuickLog(BuildContext context, WidgetRef ref, {DateTime? date, double? initial}) async {
  final latest = ref.read(latestWeightProvider).value?.weight;
  final start = initial ?? latest ?? ref.read(profileProvider).value?.weightKg ?? 70;
  final result = await showDialog<(DateTime, double)>(
    context: context,
    builder: (_) => _WeightDialog(initial: start, date: date ?? today()),
  );
  if (result == null) return null;
  await ref.read(trackingRepositoryProvider).saveWeight(result.$1, result.$2);
  HapticFeedback.mediumImpact();
  if (context.mounted) context.snack(context.l10n.trkWeightSaved(fmtNum(result.$2)));
  return result.$2;
}

class _WeightDialog extends StatefulWidget {
  final double initial;
  final DateTime date;
  const _WeightDialog({required this.initial, required this.date});

  @override
  State<_WeightDialog> createState() => _WeightDialogState();
}

class _WeightDialogState extends State<_WeightDialog> {
  late double _kg = (widget.initial * 10).round() / 10;
  late DateTime _date = widget.date;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AlertDialog(
      title: Text(l.trkWeightLog),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BigStepper(
            label: l.trkWeightKg,
            value: _kg,
            step: 0.1,
            min: 20,
            onChanged: (v) => setState(() => _kg = (v * 10).round() / 10),
            onTapValue: () async {
              final v = await askNumber(context, title: l.trkWeightLog, label: l.trkWeightKg, initial: _kg, min: 20, max: 400);
              if (v != null) setState(() => _kg = (v * 10).round() / 10);
            },
          ),
          const SizedBox(height: 8),
          DateField(label: l.trkDate, value: _date, onChanged: (d) => setState(() => _date = d)),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
        FilledButton(onPressed: () => Navigator.pop(context, (_date, _kg)), child: Text(l.save)),
      ],
    );
  }
}

enum _Range { m1, m3, y1, all }

class BodyWeightScreen extends ConsumerStatefulWidget {
  const BodyWeightScreen({super.key});

  @override
  ConsumerState<BodyWeightScreen> createState() => _BodyWeightScreenState();
}

class _BodyWeightScreenState extends ConsumerState<BodyWeightScreen> {
  _Range _range = _Range.m3;

  List<DatedValue> _filter(List<DatedValue> s) {
    final days = switch (_range) { _Range.m1 => 30, _Range.m3 => 90, _Range.y1 => 365, _Range.all => null };
    if (days == null) return s;
    final from = today().subtract(Duration(days: days));
    return s.where((p) => !p.date.isBefore(from)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final rows = ref.watch(bodyMetricsProvider);
    final series = ref.watch(weightSeriesProvider).value ?? const <DatedValue>[];
    final latest = ref.watch(latestWeightProvider).value;
    final ma = Stats.movingAverage(series, days: 7);

    double? change7;
    if (ma.length >= 2) {
      final ref7 = ma.lastWhere((p) => !p.date.isAfter(ma.last.date.subtract(const Duration(days: 7))),
          orElse: () => ma.first);
      if (ref7.date != ma.last.date) change7 = ma.last.value - ref7.value;
    }

    final shown = _filter(series);
    final shownMa = _filter(ma);

    return Scaffold(
      appBar: AppBar(title: Text(l.trkWeightTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showWeightQuickLog(context, ref),
        icon: const Icon(Icons.monitor_weight),
        label: Text(l.trkWeightLog),
      ),
      body: rows.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.errorGeneric)),
        data: (all) {
          final weightRows = all.where((r) => r.weightKg != null).toList();
          if (weightRows.isEmpty) {
            return EmptyState(
              icon: Icons.monitor_weight_outlined,
              text: l.trkWeightEmpty,
              action: FilledButton(onPressed: () => showWeightQuickLog(context, ref), child: Text(l.trkWeightLog)),
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            children: [
              SectionCard(
                child: Row(
                  children: [
                    _Stat(label: l.trkWeightLatest, value: '${fmtNum(latest?.weight ?? 0)} ${l.kg}', big: true),
                    _Stat(
                      label: l.trkWeightAvg7,
                      value: '${fmtNum(latest?.avg7 ?? 0)} ${l.kg}',
                      color: AppColors.primary,
                    ),
                    if (change7 != null)
                      _Stat(
                        label: l.trkWeightChange7,
                        value: '${change7 > 0 ? '+' : ''}${change7.toStringAsFixed(1)} ${l.kg}',
                        icon: change7.abs() < 0.05
                            ? Icons.trending_flat
                            : (change7 > 0 ? Icons.trending_up : Icons.trending_down),
                      ),
                  ],
                ),
              ),
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SegmentedButton<_Range>(
                      showSelectedIcon: false,
                      segments: [
                        ButtonSegment(value: _Range.m1, label: Text(l.trkRange1M)),
                        ButtonSegment(value: _Range.m3, label: Text(l.trkRange3M)),
                        ButtonSegment(value: _Range.y1, label: Text(l.trkRange1Y)),
                        ButtonSegment(value: _Range.all, label: Text(l.trkRangeAll)),
                      ],
                      selected: {_range},
                      onSelectionChanged: (s) => setState(() => _range = s.first),
                    ),
                    const SizedBox(height: 16),
                    if (shown.length < 2)
                      SizedBox(
                        height: 120,
                        child: Center(
                            child: Text(l.trkNeedTwoPoints, style: const TextStyle(color: AppColors.textMuted))),
                      )
                    else
                      DateLineChart(
                        line: [for (final p in shownMa) (p.date, p.value)],
                        dots: [for (final p in shown) (p.date, p.value)],
                        format: (v) => '${fmtNum(v)} ${l.kg}',
                      ),
                    const SizedBox(height: 8),
                    Wrap(spacing: 16, children: [
                      LegendDot(color: AppColors.textMuted, label: l.trkWeightDaily),
                      LegendDot(color: AppColors.primary, label: l.trkWeightAvg7),
                    ]),
                  ],
                ),
              ),
              SectionCard(
                title: l.trkHistory,
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                child: Column(
                  children: [
                    for (var i = 0; i < weightRows.length; i++)
                      _WeightTile(
                        row: weightRows[i],
                        previous: i + 1 < weightRows.length ? weightRows[i + 1].weightKg : null,
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final bool big;
  final Color? color;
  final IconData? icon;
  const _Stat({required this.label, required this.value, this.big = false, this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: context.text.bodySmall?.copyWith(color: AppColors.textMuted)),
          const SizedBox(height: 4),
          Row(children: [
            if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 4)],
            Flexible(
              child: Text(value,
                  style: (big ? context.text.titleLarge : context.text.titleMedium)
                      ?.copyWith(fontWeight: FontWeight.w800, color: color)),
            ),
          ]),
        ],
      ),
    );
  }
}

class _WeightTile extends ConsumerWidget {
  final BodyMetric row;
  final double? previous;
  const _WeightTile({required this.row, this.previous});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final w = row.weightKg!;
    final delta = previous == null ? null : w - previous!;
    return Dismissible(
      key: ValueKey('w_${row.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        padding: const EdgeInsetsDirectional.only(end: 16),
        color: AppColors.danger.withValues(alpha: 0.3),
        child: const Icon(Icons.delete),
      ),
      confirmDismiss: (_) => confirmDelete(context, l.trkDeleteConfirm('${fmtNum(w)} ${l.kg}')),
      onDismissed: (_) => ref.read(trackingRepositoryProvider).deleteWeight(row.id),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 4),
        title: Text(fmtDayLong(context, row.date)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (delta != null && delta.abs() >= 0.05)
              Text('${delta > 0 ? '+' : ''}${delta.toStringAsFixed(1)}  ',
                  style: TextStyle(color: AppColors.textMuted, fontSize: context.text.bodySmall?.fontSize)),
            Text('${fmtNum(w)} ${l.kg}', style: context.text.titleSmall),
          ],
        ),
        onTap: () => showWeightQuickLog(context, ref, date: row.date, initial: w),
      ),
    );
  }
}
