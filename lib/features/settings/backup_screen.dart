import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/context_ext.dart';
import '../../core/widgets/common.dart';
import '../../data/repositories/profile_repository.dart';
import '../../services/backup/backup_service.dart';
import '../../services/notifications/notification_service.dart';

/// Settings → Backup & restore.
class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  bool _exporting = false;
  bool _importing = false;

  String _problemText(BackupProblem? pr) {
    final l = context.l10n;
    return switch (pr) {
      BackupProblem.newerSchema => l.setRestoreNewer,
      BackupProblem.unsupportedFormat => l.setRestoreNewer,
      BackupProblem.missingDatabase => l.setRestoreCorrupt,
      BackupProblem.missingFields => l.setRestoreCorrupt,
      _ => l.setRestoreNotBackup,
    };
  }

  Future<void> _export() async {
    setState(() => _exporting = true);
    try {
      final ok = await ref.read(backupServiceProvider).exportAndShare(subject: context.l10n.setBackupShareSubject);
      if (!mounted) return;
      if (ok) context.snack(context.l10n.setBackupDone);
    } catch (e) {
      if (mounted) context.snack(context.l10n.setBackupFailed(e.toString()));
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  Future<void> _import() async {
    final l = context.l10n;
    final service = ref.read(backupServiceProvider);
    setState(() => _importing = true);
    PreparedRestore? prepared;
    try {
      final picked = await FilePicker.pickFile(dialogTitle: l.setRestorePick);
      if (picked == null) return;
      final tmp = await getTemporaryDirectory();
      final local = p.join(tmp.path, 'picked_backup.zip');
      await picked.xFile.saveTo(local);
      prepared = await service.prepareRestore(local);
    } on BackupException catch (e) {
      if (mounted) context.snack(_problemText(e.problem));
      return;
    } catch (e) {
      if (mounted) context.snack(l.setRestoreNotBackup);
      return;
    } finally {
      if (mounted) setState(() => _importing = false);
    }
    if (!mounted) return;
    final m = prepared.manifest;
    final date = DateFormat.yMMMd(context.lang).add_jm().format(m.createdAt);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l.setRestoreConfirmTitle),
        content: Text(l.setRestoreConfirmBody(date, m.appVersion)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(c, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: Text(l.setRestoreReplace),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      await BackupService.discardPrepared(prepared);
      return;
    }
    if (!mounted) return;
    final restore = prepared;
    // Replace the whole UI so nothing keeps querying the DB while it is swapped.
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => RestoreProgressScreen(service: service, restore: restore)),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final prefs = ref.watch(sharedPrefsProvider);
    final last = lastBackupAt(prefs);
    final profile = ref.watch(profileProvider).value;
    final due = isBackupDue(lastBackupAt: last, since: profile?.createdAt, now: DateTime.now());
    final busy = _exporting || _importing;
    return Scaffold(
      appBar: AppBar(title: Text(l.setBackup)),
      body: ListView(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 32),
        children: [
          SectionCard(
            title: l.setBackupExport,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l.setBackupExportHelp, style: const TextStyle(color: AppColors.textMuted)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(due ? Symbols.warning_rounded : Symbols.check_circle_rounded,
                        color: due ? AppColors.warning : AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(last == null
                          ? l.setBackupNever
                          : l.setBackupLast(DateFormat.yMMMd(context.lang).add_jm().format(last))),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: busy ? null : _export,
                  icon: _exporting
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Symbols.ios_share_rounded),
                  label: Text(_exporting ? l.setBackupWorking : l.setBackupExportButton),
                ),
              ],
            ),
          ),
          SectionCard(
            title: l.setRestore,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l.setRestoreHelp, style: const TextStyle(color: AppColors.textMuted)),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: busy ? null : _import,
                  icon: _importing
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Symbols.restore_rounded),
                  label: Text(l.setRestoreButton),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Symbols.key_rounded, fill: 1, size: 18, color: AppColors.textMuted),
                const SizedBox(width: 8),
                Expanded(child: Text(l.setBackupKeyNote, style: const TextStyle(color: AppColors.textMuted))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Applies a confirmed restore, then asks the user to restart the app.
class RestoreProgressScreen extends StatefulWidget {
  final BackupService service;
  final PreparedRestore restore;
  const RestoreProgressScreen({super.key, required this.service, required this.restore});

  @override
  State<RestoreProgressScreen> createState() => _RestoreProgressScreenState();
}

class _RestoreProgressScreenState extends State<RestoreProgressScreen> {
  bool _done = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _run());
  }

  Future<void> _run() async {
    // Let the removed routes dispose their DB listeners first.
    await Future<void>.delayed(const Duration(milliseconds: 400));
    try {
      await NotificationService.cancelRestTimer();
      await widget.service.applyRestore(widget.restore);
      if (mounted) setState(() => _done = true);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final finished = _done || _error != null;
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!finished) ...[
                    const CircularProgressIndicator(),
                    const SizedBox(height: 24),
                    Text(l.setRestoreWorking, textAlign: TextAlign.center),
                  ] else ...[
                    Icon(_error == null ? Symbols.check_circle_rounded : Symbols.error_rounded,
                        size: 72, color: _error == null ? AppColors.primary : AppColors.danger),
                    const SizedBox(height: 16),
                    Text(
                      _error == null ? l.setRestoreDone : l.setRestoreFailed,
                      textAlign: TextAlign.center,
                      style: context.text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Text(l.setRestoreRestart, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textMuted)),
                    if (_error != null) ...[
                      const SizedBox(height: 8),
                      Text(_error!, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                    ],
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => SystemNavigator.pop(),
                        child: Text(l.setRestoreCloseApp),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
