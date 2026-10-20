import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/calc/recovery.dart';
import '../../../core/navigation.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/context_ext.dart';
import '../../../core/widgets/common.dart';
import '../../../data/repositories/profile_repository.dart';
import '../health_service.dart';
import '../tracking_logic.dart';
import '../tracking_providers.dart';
import '../widgets/tracking_widgets.dart';
import 'health_connect_screen.dart';

String qualityLabel(BuildContext context, int q) {
  final l = context.l10n;
  return switch (q) {
    1 => l.trkQuality1,
    2 => l.trkQuality2,
    3 => l.trkQuality3,
    4 => l.trkQuality4,
    _ => l.trkQuality5,
  };
}

String recoveryLevelLabel(BuildContext context, RecoveryLevel level) => switch (level) {
      RecoveryLevel.low => context.l10n.trkRecoveryLow,
      RecoveryLevel.moderate => context.l10n.trkRecoveryModerate,
      RecoveryLevel.high => context.l10n.trkRecoveryHigh,
    };

Color recoveryColor(RecoveryLevel? level) => switch (level) {
      RecoveryLevel.low => AppColors.danger,
      RecoveryLevel.moderate => AppColors.warning,
      RecoveryLevel.high => AppColors.primary,
      null => AppColors.textMuted,
    };

/// Runs a Health Connect sync with snackbar feedback.
Future<void> runHealthSync(BuildContext context, WidgetRef ref) async {
  final l = context.l10n;
  context.snack(l.trkSyncing);
  final r = await ref.read(healthServiceProvider).sync();
  ref.invalidate(healthSnapshotProvider);
  ref.invalidate(healthStatusProvider);
  if (!context.mounted) return;
  context.snack(r.outcome == HealthSyncOutcome.ok ? l.trkSyncDone : l.trkSyncFailed);
}

class SleepLogScreen extends ConsumerWidget {
  const SleepLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final hcEnabled = ref.watch(profileProvider).value?.healthConnectEnabled ?? false;
    final logs = ref.watch(sleepLogsProvider);
    final lastNight = ref.watch(lastNightSleepProvider).value;
    final recovery = ref.watch(recoveryBreakdownProvider).value;
    final day = ref.watch(currentDayProvider);
    final profile = ref.watch(profileProvider).value;
    final need = sleepNeedFromProfile(profile?.sleepTime, profile?.wakeTime);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.trkSleepTitle),
        actions: [
          if (hcEnabled)
            IconButton(tooltip: l.trkSyncNow, icon: const Icon(Icons.sync), onPressed: () => runHealthSync(context, ref)),
          IconButton(
            tooltip: l.trkHealthConnectTitle,
            icon: const Icon(Icons.watch_outlined),
            onPressed: () => push(context, const HealthConnectSettingsScreen()),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showSleepEntrySheet(context, ref, existing: lastNight?.source == 'manual' ? lastNight : null),
        icon: const Icon(Icons.bedtime),
        label: Text(l.trkSleepLog),
      ),
      body: logs.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.errorGeneric)),
        data: (list) {
          final week = sleepPerDay(list, day, 7);
          final avg = averageSleep(week);
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            children: [
              if (!hcEnabled)
                InfoBanner(
                  icon: Icons.watch,
                  text: l.trkSleepConnectHint,
                  action: TextButton(
                    onPressed: () => push(context, const HealthConnectSettingsScreen()),
                    child: Text(l.trkHcEnable),
                  ),
                ),
              _LastNightCard(log: lastNight),
              if (recovery?.score != null) _RecoveryRow(b: recovery!),
              SectionCard(
                title: l.trkLast7Days,
                trailing: avg == null
                    ? null
                    : Text(l.trkSleepWeekAvg(fmtSleep(context, avg.round())), style: context.text.bodySmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    WeekBars(
                      values: week.map((m) => m == null ? null : m / 60).toList(),
                      lastDay: day,
                      goal: need / 60,
                      color: SleepStagesBar.deepColor,
                      tooltip: (v) => fmtSleep(context, (v * 60).round()),
                    ),
                    const SizedBox(height: 4),
                    Text(l.trkSleepNeed(fmtSleep(context, need)),
                        style: context.text.bodySmall?.copyWith(color: AppColors.textMuted)),
                  ],
                ),
              ),
              SectionCard(
                title: l.trkHistory,
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                child: list.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(l.trkSleepEmpty, style: const TextStyle(color: AppColors.textMuted)),
                      )
                    : Column(children: [for (final s in list) _SleepTile(log: s)]),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(l.trkSleepManualOverrides,
                    textAlign: TextAlign.center, style: context.text.bodySmall?.copyWith(color: AppColors.textMuted)),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LastNightCard extends StatelessWidget {
  final SleepLog? log;
  const _LastNightCard({this.log});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = log;
    return SectionCard(
      title: l.trkSleepLastNight,
      trailing: s == null ? null : _SourceChip(source: s.source),
      child: s == null
          ? Text(l.trkSleepNoData, style: const TextStyle(color: AppColors.textMuted))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(fmtSleep(context, s.durationMin),
                        style: context.text.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(width: 12),
                    if (s.start != null && s.end != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text('${fmtTime(context, s.start!)} → ${fmtTime(context, s.end!)}',
                            style: const TextStyle(color: AppColors.textMuted)),
                      ),
                  ],
                ),
                if (s.quality != null) ...[
                  const SizedBox(height: 6),
                  _QualityStars(quality: s.quality!),
                ],
                if (s.deepMin != null || s.remMin != null || s.lightMin != null) ...[
                  const SizedBox(height: 12),
                  SleepStagesBar(deep: s.deepMin, rem: s.remMin, light: s.lightMin, awake: s.awakeMin),
                ],
              ],
            ),
    );
  }
}

class _RecoveryRow extends StatelessWidget {
  final RecoveryBreakdown b;
  const _RecoveryRow({required this.b});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final color = recoveryColor(b.level);
    return SectionCard(
      child: Row(
        children: [
          ProgressRing(
            value: b.score!.toDouble(),
            max: 100,
            size: 56,
            stroke: 6,
            color: color,
            center: Text('${b.score}', style: const TextStyle(fontWeight: FontWeight.w800)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.trkRecoveryToday, style: context.text.titleSmall),
                Text(recoveryLevelLabel(context, b.level!), style: TextStyle(color: color, fontWeight: FontWeight.w700)),
                if ((b.hrv != null || b.restingHr != null) && b.baselineCalibrating)
                  Text(l.trkRecoveryCalibrating(b.baselineDays),
                      style: context.text.bodySmall?.copyWith(color: AppColors.textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QualityStars extends StatelessWidget {
  final int quality;
  const _QualityStars({required this.quality});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 1; i <= 5; i++)
            Icon(i <= quality ? Icons.star_rounded : Icons.star_outline_rounded,
                size: 18, color: i <= quality ? AppColors.warning : AppColors.textMuted),
          const SizedBox(width: 6),
          Text(qualityLabel(context, quality), style: context.text.bodySmall),
        ],
      );
}

class _SourceChip extends StatelessWidget {
  final String source;
  const _SourceChip({required this.source});

  @override
  Widget build(BuildContext context) {
    final hc = source == 'health_connect';
    final l = context.l10n;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: (hc ? AppColors.info : AppColors.textMuted).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(hc ? Icons.watch : Icons.edit, size: 14, color: hc ? AppColors.info : AppColors.textMuted),
        const SizedBox(width: 4),
        Text(hc ? l.trkSourceHealthConnect : l.trkSourceManual, style: context.text.labelSmall),
      ]),
    );
  }
}

class _SleepTile extends ConsumerWidget {
  final SleepLog log;
  const _SleepTile({required this.log});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final s = log;
    final details = <String>[
      if (s.quality != null) qualityLabel(context, s.quality!),
      if (s.deepMin != null) '${l.trkStageDeep} ${fmtSleep(context, s.deepMin!)}',
      if (s.remMin != null) '${l.trkStageRem} ${fmtSleep(context, s.remMin!)}',
    ];
    return Dismissible(
      key: ValueKey('sleep_${s.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        padding: const EdgeInsetsDirectional.only(end: 16),
        color: AppColors.danger.withValues(alpha: 0.3),
        child: const Icon(Icons.delete),
      ),
      confirmDismiss: (_) => confirmDelete(context, l.trkDeleteConfirm(fmtDayLong(context, s.date))),
      onDismissed: (_) => ref.read(trackingRepositoryProvider).deleteSleep(s.id),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 4),
        leading: Icon(s.source == 'health_connect' ? Icons.watch : Icons.bedtime_outlined,
            color: s.source == 'health_connect' ? AppColors.info : AppColors.textMuted),
        title: Text(fmtDayLong(context, s.date)),
        subtitle: details.isEmpty ? null : Text(details.join(' · ')),
        trailing: Text(fmtSleep(context, s.durationMin), style: context.text.titleSmall),
        onTap: () => showSleepEntrySheet(context, ref, existing: s),
      ),
    );
  }
}

/// Manual sleep entry (hours + quality 1–5, optional bed/wake times).
Future<void> showSleepEntrySheet(BuildContext context, WidgetRef ref, {SleepLog? existing}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _SleepEntrySheet(existing: existing),
  );
}

class _SleepEntrySheet extends ConsumerStatefulWidget {
  final SleepLog? existing;
  const _SleepEntrySheet({this.existing});

  @override
  ConsumerState<_SleepEntrySheet> createState() => _SleepEntrySheetState();
}

class _SleepEntrySheetState extends ConsumerState<_SleepEntrySheet> {
  late DateTime _date;
  late double _hours;
  int? _quality;
  TimeOfDay? _bed;
  TimeOfDay? _wake;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _date = e?.date ?? today();
    _hours = e == null ? 7.5 : (e.durationMin / 60 * 4).round() / 4;
    _quality = e?.quality ?? (e == null ? 3 : null);
    if (e?.start != null) _bed = TimeOfDay.fromDateTime(e!.start!);
    if (e?.end != null) _wake = TimeOfDay.fromDateTime(e!.end!);
    if (e == null) {
      final p = ref.read(profileProvider).value;
      _bed = parseHm(p?.sleepTime);
      _wake = parseHm(p?.wakeTime);
      if (_bed != null && _wake != null) _recalc();
    }
  }

  void _recalc() {
    if (_bed == null || _wake == null) return;
    final m = sleepMinutesBetween(_bed!.hour * 60 + _bed!.minute, _wake!.hour * 60 + _wake!.minute);
    _hours = (m / 60 * 4).round() / 4;
  }

  Future<void> _pickTime(bool bed) async {
    final t = await showTimePicker(
      context: context,
      initialTime: (bed ? _bed : _wake) ?? (bed ? const TimeOfDay(hour: 23, minute: 0) : const TimeOfDay(hour: 7, minute: 0)),
    );
    if (t == null) return;
    setState(() {
      if (bed) {
        _bed = t;
      } else {
        _wake = t;
      }
      _recalc();
    });
  }

  Future<void> _save() async {
    DateTime? start, end;
    if (_bed != null && _wake != null) {
      end = DateTime(_date.year, _date.month, _date.day, _wake!.hour, _wake!.minute);
      final mins = sleepMinutesBetween(_bed!.hour * 60 + _bed!.minute, _wake!.hour * 60 + _wake!.minute);
      start = end.subtract(Duration(minutes: mins));
    }
    await ref.read(trackingRepositoryProvider).saveManualSleep(
          date: _date,
          durationMin: (_hours * 60).round(),
          quality: _quality,
          start: start,
          end: end,
          replaceId: widget.existing?.id,
        );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.existing == null ? l.trkSleepLog : l.trkSleepEdit, style: context.text.titleLarge),
            DateField(label: l.trkSleepDate, value: _date, onChanged: (d) => setState(() => _date = d)),
            const SizedBox(height: 8),
            Center(
              child: BigStepper(
                label: l.trkSleepHours,
                value: _hours,
                step: 0.25,
                decimals: 2,
                onChanged: (v) => setState(() => _hours = v.clamp(0, 24).toDouble()),
                onTapValue: () async {
                  final v = await askNumber(context, title: l.trkSleepHours, label: l.hoursShort, initial: _hours, max: 24);
                  if (v != null) setState(() => _hours = v);
                },
              ),
            ),
            Center(
              child: Text(fmtSleep(context, (_hours * 60).round()),
                  style: context.text.bodySmall?.copyWith(color: AppColors.textMuted)),
            ),
            const SizedBox(height: 16),
            Text(l.trkSleepQuality, style: context.text.labelLarge),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                for (var q = 1; q <= 5; q++)
                  ChoiceChip(
                    label: Text('$q · ${qualityLabel(context, q)}'),
                    selected: _quality == q,
                    onSelected: (v) => setState(() => _quality = v ? q : null),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(l.trkOptionalTimes, style: context.text.labelLarge),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickTime(true),
                    icon: const Icon(Icons.bedtime_outlined),
                    label: Text(_bed == null ? l.trkBedTime : '${l.trkBedTime} ${hm(_bed!)}'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickTime(false),
                    icon: const Icon(Icons.wb_sunny_outlined),
                    label: Text(_wake == null ? l.trkWakeTime : '${l.trkWakeTime} ${hm(_wake!)}'),
                  ),
                ),
              ],
            ),
            if (_bed != null || _wake != null)
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: () => setState(() {
                    _bed = null;
                    _wake = null;
                  }),
                  child: Text(l.trkClear),
                ),
              ),
            const SizedBox(height: 12),
            FilledButton(onPressed: _hours > 0 ? _save : null, child: Text(l.save)),
          ],
        ),
      ),
    );
  }
}
