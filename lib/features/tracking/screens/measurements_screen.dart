import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/context_ext.dart';
import '../../../core/widgets/common.dart';
import '../tracking_logic.dart';
import '../tracking_providers.dart';
import '../widgets/tracking_widgets.dart';

String measureLabel(BuildContext context, Measure m) {
  final l = context.l10n;
  return switch (m) {
    Measure.waist => l.trkMeasureWaist,
    Measure.chest => l.trkMeasureChest,
    Measure.arm => l.trkMeasureArm,
    Measure.thigh => l.trkMeasureThigh,
    Measure.neck => l.trkMeasureNeck,
    Measure.hips => l.trkMeasureHips,
    Measure.bodyFat => l.trkMeasureBodyFat,
  };
}

String measureUnit(BuildContext context, Measure m) => m == Measure.bodyFat ? '%' : context.l10n.cm;

class BodyMeasurementsScreen extends ConsumerStatefulWidget {
  const BodyMeasurementsScreen({super.key});

  @override
  ConsumerState<BodyMeasurementsScreen> createState() => _BodyMeasurementsScreenState();
}

class _BodyMeasurementsScreenState extends ConsumerState<BodyMeasurementsScreen> {
  Measure _selected = Measure.waist;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final rows = ref.watch(measurementRowsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.trkMeasurementsTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showMeasurementsSheet(context, last: rows.value?.firstOrNull),
        icon: const Icon(Symbols.straighten_rounded),
        label: Text(l.trkMeasureNew),
      ),
      body: rows.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.errorGeneric)),
        data: (list) {
          final last = list.firstOrNull;
          final due = measurementsDue(last?.date, DateTime.now());
          final available = Measure.values.where((m) => list.any((r) => measureValue(r, m) != null)).toSet();
          final selected = available.isEmpty || available.contains(_selected) ? _selected : available.first;
          final points = list
              .where((r) => measureValue(r, selected) != null)
              .map((r) => (r.date, measureValue(r, selected)!))
              .toList()
              .reversed
              .toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            children: [
              if (due)
                InfoBanner(
                  icon: Symbols.notifications_active_rounded,
                  color: AppColors.warning,
                  text: last == null ? l.trkMeasureNone : l.trkMeasureDue,
                ),
              if (last != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Text(l.trkLastMeasured(fmtDayLong(context, last.date)),
                      style: context.text.bodySmall?.copyWith(color: AppColors.textMuted)),
                ),
              if (list.isNotEmpty) ...[
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (final m in Measure.values)
                              Padding(
                                padding: const EdgeInsetsDirectional.only(end: 6),
                                child: ChoiceChip(
                                  label: Text(measureLabel(context, m)),
                                  selected: selected == m,
                                  onSelected: available.contains(m) ? (_) => setState(() => _selected = m) : null,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (points.length < 2)
                        SizedBox(
                          height: 120,
                          child: Center(
                            child: Text(
                              points.isEmpty
                                  ? l.trkHcNothing
                                  : '${fmtNum(points.single.$2)} ${measureUnit(context, selected)}',
                              style: const TextStyle(color: AppColors.textMuted),
                            ),
                          ),
                        )
                      else
                        DateLineChart(
                          line: points,
                          color: AppColors.info,
                          format: (v) => '${fmtNum(v)} ${measureUnit(context, selected)}',
                        ),
                    ],
                  ),
                ),
                SectionCard(
                  title: l.trkHistory,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 18,
                      horizontalMargin: 4,
                      showCheckboxColumn: false,
                      columns: [
                        DataColumn(label: Text(l.trkDate)),
                        for (final m in Measure.values) DataColumn(label: Text(measureLabel(context, m)), numeric: true),
                      ],
                      rows: [
                        for (final r in list)
                          DataRow(
                            onSelectChanged: (_) => showMeasurementsSheet(context, existing: r),
                            onLongPress: () async {
                              if (await confirmDelete(context, l.trkDeleteConfirm(fmtDayLong(context, r.date)))) {
                                await ref.read(trackingRepositoryProvider).deleteMeasurements(r.id);
                              }
                            },
                            cells: [
                              DataCell(Text(fmtDay(context, r.date))),
                              for (final m in Measure.values)
                                DataCell(Text(measureValue(r, m) == null ? '—' : fmtNum(measureValue(r, m)!))),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ] else
                Padding(
                  padding: const EdgeInsets.only(top: 48),
                  child: EmptyState(icon: Symbols.straighten_rounded, text: l.trkMeasureTip),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// Weekly measurement entry (prefilled with the last values when adding).
Future<void> showMeasurementsSheet(BuildContext context, {BodyMetric? existing, BodyMetric? last}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _MeasurementsSheet(existing: existing, last: last),
  );
}

class _MeasurementsSheet extends ConsumerStatefulWidget {
  final BodyMetric? existing;
  final BodyMetric? last;
  const _MeasurementsSheet({this.existing, this.last});

  @override
  ConsumerState<_MeasurementsSheet> createState() => _MeasurementsSheetState();
}

class _MeasurementsSheetState extends ConsumerState<_MeasurementsSheet> {
  late DateTime _date = widget.existing?.date ?? today();
  late final Map<Measure, TextEditingController> _ctrl = {
    for (final m in Measure.values)
      m: TextEditingController(text: _initial(m) == null ? '' : fmtNum(_initial(m)!)),
  };
  String? _error;

  double? _initial(Measure m) {
    final src = widget.existing ?? widget.last;
    return src == null ? null : measureValue(src, m);
  }

  @override
  void dispose() {
    for (final c in _ctrl.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final v = {for (final m in Measure.values) m: parseNum(_ctrl[m]!.text)};
    final invalid = v.entries.any((e) =>
        _ctrl[e.key]!.text.trim().isNotEmpty &&
        (e.value == null || e.value! <= 0 || e.value! > (e.key == Measure.bodyFat ? 70 : 300)));
    if (invalid) {
      setState(() => _error = context.l10n.trkInvalidNumber);
      return;
    }
    if (v.values.every((e) => e == null)) {
      setState(() => _error = context.l10n.trkMeasureNeedOne);
      return;
    }
    final repo = ref.read(trackingRepositoryProvider);
    if (widget.existing != null && dayOf(widget.existing!.date) != _date) {
      await repo.deleteMeasurements(widget.existing!.id);
    }
    await repo.saveMeasurements(
      _date,
      waist: v[Measure.waist],
      chest: v[Measure.chest],
      arm: v[Measure.arm],
      thigh: v[Measure.thigh],
      neck: v[Measure.neck],
      hips: v[Measure.hips],
      bodyFat: v[Measure.bodyFat],
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    Widget field(Measure m) => Expanded(
          child: TextField(
            controller: _ctrl[m],
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: numberInputFormatters,
            decoration: InputDecoration(labelText: measureLabel(context, m), suffixText: measureUnit(context, m)),
          ),
        );
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.existing == null ? l.trkMeasureNew : l.trkMeasureEdit, style: context.text.titleLarge),
            const SizedBox(height: 4),
            Text(l.trkMeasureTip, style: context.text.bodySmall?.copyWith(color: AppColors.textMuted)),
            DateField(label: l.trkDate, value: _date, onChanged: (d) => setState(() => _date = d)),
            Row(children: [field(Measure.waist), const SizedBox(width: 10), field(Measure.chest)]),
            const SizedBox(height: 10),
            Row(children: [field(Measure.arm), const SizedBox(width: 10), field(Measure.thigh)]),
            const SizedBox(height: 10),
            Row(children: [field(Measure.neck), const SizedBox(width: 10), field(Measure.hips)]),
            const SizedBox(height: 10),
            Row(children: [field(Measure.bodyFat), const SizedBox(width: 10), const Spacer()]),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(_error!, style: const TextStyle(color: AppColors.danger)),
              ),
            const SizedBox(height: 16),
            FilledButton(onPressed: _save, child: Text(l.save)),
          ],
        ),
      ),
    );
  }
}
