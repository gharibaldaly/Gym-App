import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/context_ext.dart';
import '../../../core/widgets/common.dart';
import '../../../data/repositories/profile_repository.dart';
import '../health_service.dart';
import '../tracking_logic.dart';
import '../widgets/tracking_widgets.dart';

String hcTypeLabel(BuildContext context, String type) {
  final l = context.l10n;
  return switch (type) {
    HcType.sleepSession => l.trkHcTypeSleep,
    HcType.sleepDeep => '${l.trkSleepTitle} · ${l.trkStageDeep}',
    HcType.sleepRem => '${l.trkSleepTitle} · ${l.trkStageRem}',
    HcType.sleepLight => '${l.trkSleepTitle} · ${l.trkStageLight}',
    HcType.sleepAwake => '${l.trkSleepTitle} · ${l.trkStageAwake}',
    HcType.sleepAsleep => l.trkHcTypeAsleep,
    HcType.heartRate => l.trkHcTypeHr,
    HcType.restingHeartRate => l.trkHcTypeRhr,
    HcType.hrv => l.trkHcTypeHrv,
    HcType.steps => l.trkHcTypeSteps,
    HcType.activeEnergy => l.trkHcTypeCalories,
    _ => type,
  };
}

String hcValueLabel(BuildContext context, PulledItem it) {
  final l = context.l10n;
  if (HcType.sleepTypes.contains(it.type)) return fmtSleep(context, it.value.round());
  return switch (it.type) {
    HcType.heartRate || HcType.restingHeartRate => '${it.value.round()} ${l.trkUnitBpm}',
    HcType.hrv => '${fmtNum(it.value)} ${l.trkUnitMs}',
    HcType.steps => '${it.value.round()} ${l.trkUnitSteps}',
    HcType.activeEnergy => '${it.value.round()} ${l.kcal}',
    _ => fmtNum(it.value),
  };
}

class HealthConnectSettingsScreen extends ConsumerStatefulWidget {
  const HealthConnectSettingsScreen({super.key});

  @override
  ConsumerState<HealthConnectSettingsScreen> createState() => _HealthConnectSettingsScreenState();
}

class _HealthConnectSettingsScreenState extends ConsumerState<HealthConnectSettingsScreen> with WidgetsBindingObserver {
  bool _syncing = false;
  bool _requesting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Coming back from the Play Store / Health Connect app → refresh the status.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) ref.invalidate(healthStatusProvider);
  }

  void _refresh() {
    ref.invalidate(healthStatusProvider);
    ref.invalidate(healthSnapshotProvider);
  }

  Future<void> _setEnabled(bool v) async {
    final l = context.l10n;
    await ref.read(profileRepositoryProvider).upsert(UserProfilesCompanion(healthConnectEnabled: Value(v)));
    if (!mounted) return;
    context.snack(v ? l.trkHcEnabledToast : l.trkHcDisabledToast);
    if (v) {
      await _grant();
      await _sync();
    }
  }

  Future<void> _grant() async {
    setState(() => _requesting = true);
    await ref.read(healthServiceProvider).requestPermissions();
    if (!mounted) return;
    setState(() => _requesting = false);
    _refresh();
  }

  Future<void> _sync() async {
    final l = context.l10n;
    setState(() => _syncing = true);
    final r = await ref.read(healthServiceProvider).sync();
    if (!mounted) return;
    setState(() => _syncing = false);
    _refresh();
    context.snack(switch (r.outcome) {
      HealthSyncOutcome.ok => l.trkHcOutcomeOk(r.points),
      HealthSyncOutcome.noPermission => l.trkHcOutcomeNoPermission,
      HealthSyncOutcome.unavailable => l.trkHcOutcomeUnavailable,
      HealthSyncOutcome.disabled => l.trkHcDisabledToast,
      _ => l.trkSyncFailed,
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final enabled = ref.watch(profileProvider).value?.healthConnectEnabled ?? false;
    final status = ref.watch(healthStatusProvider);
    final snap = ref.watch(healthSnapshotProvider).value;

    return Scaffold(
      appBar: AppBar(title: Text(l.trkHealthConnectTitle)),
      body: RefreshIndicator(
        onRefresh: () async => _refresh(),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            Card(
              child: SwitchListTile(
                value: enabled,
                onChanged: _setEnabled,
                secondary: const Icon(Icons.watch, color: AppColors.primary),
                title: Text(l.trkHcEnable, style: const TextStyle(fontWeight: FontWeight.w700)),
                subtitle: Text(l.trkHcEnableSub),
              ),
            ),
            SectionCard(
              title: l.trkHcStatus,
              child: status.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text(l.errorGeneric),
                data: (s) => _StatusBody(
                  status: s,
                  enabled: enabled,
                  requesting: _requesting,
                  onInstall: () => ref.read(healthServiceProvider).installHealthConnect(),
                  onGrant: _grant,
                  onBackground: () async {
                    await ref.read(healthServiceProvider).requestBackgroundPermission();
                    _refresh();
                  },
                ),
              ),
            ),
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledButton.icon(
                    onPressed: enabled && !_syncing ? _sync : null,
                    icon: _syncing
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.sync),
                    label: Text(_syncing ? l.trkSyncing : l.trkSyncNow),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    snap?.lastSync == null ? l.trkHcNeverSynced : l.trkHcLastSync(fmtDateTime(context, snap!.lastSync!)),
                    style: context.text.bodySmall,
                  ),
                  if (snap?.lastOutcome != null)
                    Text(
                      switch (snap!.lastOutcome!) {
                        HealthSyncOutcome.ok => l.trkHcOutcomeOk(snap.lastPointCount),
                        HealthSyncOutcome.noPermission => l.trkHcOutcomeNoPermission,
                        HealthSyncOutcome.unavailable => l.trkHcOutcomeUnavailable,
                        _ => l.trkHcOutcomeError,
                      },
                      style: context.text.bodySmall?.copyWith(
                          color: snap.lastOutcome == HealthSyncOutcome.ok ? AppColors.textMuted : AppColors.warning),
                    ),
                ],
              ),
            ),
            SectionCard(
              title: l.trkHcLastPulled,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l.trkHcLastPulledSub, style: context.text.bodySmall?.copyWith(color: AppColors.textMuted)),
                  const SizedBox(height: 8),
                  if (snap != null && snap.sources.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(l.trkHcSources(snap.sources.join(context.isAr ? '، ' : ', ')),
                          style: context.text.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                    ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 16,
                      horizontalMargin: 0,
                      headingRowHeight: 36,
                      dataRowMinHeight: 36,
                      dataRowMaxHeight: 52,
                      columns: [
                        DataColumn(label: Text(l.trkHcColType)),
                        DataColumn(label: Text(l.trkHcColDate)),
                        DataColumn(label: Text(l.trkHcColValue)),
                        DataColumn(label: Text(l.trkHcColSource)),
                      ],
                      rows: [
                        for (final type in HcType.all)
                          _row(context, type, snap?.items[type]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            InfoBanner(icon: Icons.help_outline, text: '${l.trkHcCardooTitle}\n${l.trkHcCardooBody}'),
            InfoBanner(icon: Icons.edit_note, color: AppColors.primary, text: l.trkHcManualFallback),
          ],
        ),
      ),
    );
  }

  DataRow _row(BuildContext context, String type, PulledItem? it) {
    final muted = TextStyle(color: AppColors.textMuted, fontSize: context.text.bodySmall?.fontSize);
    return DataRow(cells: [
      DataCell(Text(hcTypeLabel(context, type))),
      DataCell(Text(it == null ? '—' : fmtDateTime(context, it.at), style: it == null ? muted : null)),
      DataCell(Text(it == null ? context.l10n.trkHcNothing : hcValueLabel(context, it), style: it == null ? muted : null)),
      DataCell(Text(it == null || it.source.isEmpty ? '—' : it.source, style: muted)),
    ]);
  }
}

class _StatusBody extends StatelessWidget {
  final HealthStatus status;
  final bool enabled;
  final bool requesting;
  final VoidCallback onInstall;
  final VoidCallback onGrant;
  final VoidCallback onBackground;
  const _StatusBody({
    required this.status,
    required this.enabled,
    required this.requesting,
    required this.onInstall,
    required this.onGrant,
    required this.onBackground,
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    Widget line(bool ok, String text, {bool warn = false}) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(children: [
            Icon(ok ? Icons.check_circle : (warn ? Icons.error_outline : Icons.cancel),
                color: ok ? AppColors.primary : (warn ? AppColors.warning : AppColors.danger), size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(text)),
          ]),
        );

    final a = status.availability;
    if (a != HcAvailability.available) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          line(false, switch (a) {
            HcAvailability.needsUpdate => l.trkHcNeedsUpdate,
            HcAvailability.notInstalled => l.trkHcNotInstalled,
            _ => l.trkHcUnsupported,
          }, warn: a == HcAvailability.needsUpdate),
          if (a != HcAvailability.unsupported) ...[
            const SizedBox(height: 6),
            Text(l.trkHcInstallHint, style: context.text.bodySmall?.copyWith(color: AppColors.textMuted)),
            const SizedBox(height: 10),
            OutlinedButton.icon(onPressed: onInstall, icon: const Icon(Icons.download), label: Text(l.trkHcInstall)),
          ],
        ],
      );
    }
    final granted = status.permissionsGranted == true;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        line(true, l.trkHcAvailable),
        line(granted, granted ? l.trkHcPermGranted : l.trkHcPermMissing, warn: !granted),
        if (status.backgroundAvailable)
          line(status.backgroundAuthorized, status.backgroundAuthorized ? l.trkHcBgGranted : l.trkHcBgMissing,
              warn: true),
        const SizedBox(height: 8),
        if (!granted)
          FilledButton.icon(
            onPressed: requesting ? null : onGrant,
            icon: const Icon(Icons.verified_user),
            label: Text(l.trkHcGrant),
          )
        else
          OutlinedButton.icon(
            onPressed: requesting ? null : onGrant,
            icon: const Icon(Icons.verified_user_outlined),
            label: Text(l.trkHcGrant),
          ),
        if (granted && status.backgroundAvailable && !status.backgroundAuthorized) ...[
          const SizedBox(height: 8),
          OutlinedButton.icon(onPressed: onBackground, icon: const Icon(Icons.schedule), label: Text(l.trkHcBgAllow)),
        ],
        if (!enabled)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(l.trkHcEnableSub, style: context.text.bodySmall?.copyWith(color: AppColors.textMuted)),
          ),
      ],
    );
  }
}
