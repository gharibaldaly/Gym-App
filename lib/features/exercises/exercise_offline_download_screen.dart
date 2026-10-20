import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/context_ext.dart';
import '../../core/widgets/common.dart';
import 'exercise_media.dart';

/// Settings → "Offline exercise images": downloads every step image into the
/// persistent exercise image cache with progress. The download keeps running
/// if the screen is closed (the notifier is app-wide).
class ExerciseOfflineDownloadScreen extends ConsumerStatefulWidget {
  const ExerciseOfflineDownloadScreen({super.key});

  @override
  ConsumerState<ExerciseOfflineDownloadScreen> createState() => _ExerciseOfflineDownloadScreenState();
}

class _ExerciseOfflineDownloadScreenState extends ConsumerState<ExerciseOfflineDownloadScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final s = ref.read(exerciseMediaDownloaderProvider);
      if (!s.running) ref.read(exerciseMediaDownloaderProvider.notifier).refreshStatus();
    });
  }

  Future<void> _confirmClear() async {
    final l = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.exOfflineClear),
        content: Text(l.exOfflineClearConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.delete),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(exerciseMediaDownloaderProvider.notifier).clear();
      if (mounted) context.snack(l.exOfflineCleared);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = ref.watch(exerciseMediaDownloaderProvider);
    final online = ref.watch(isOnlineProvider);
    final n = ref.read(exerciseMediaDownloaderProvider.notifier);
    final checking = s.phase == MediaDownloadPhase.checking;
    final downloading = s.phase == MediaDownloadPhase.downloading;
    final pct = s.total == 0 ? 0.0 : (downloading ? s.progress : s.cached / s.total);

    return Scaffold(
      appBar: AppBar(title: Text(l.exOfflineTitle)),
      body: ListView(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 32),
        children: [
          SectionCard(
            child: Column(
              children: [
                const SizedBox(height: 8),
                ProgressRing(
                  value: pct,
                  max: 1,
                  size: 150,
                  stroke: 12,
                  center: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text('${(pct * 100).floor()}%',
                        style: context.text.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
                    if (s.total > 0)
                      Text(
                        downloading ? l.exOfflineProgress(s.processed, s.total) : l.exOfflineProgress(s.cached, s.total),
                        style: context.text.bodySmall?.copyWith(color: AppColors.textMuted),
                      ),
                  ]),
                ),
                const SizedBox(height: 16),
                Text(
                  checking
                      ? l.exOfflineChecking
                      : s.complete
                          ? l.exOfflineDone
                          : l.exOfflineCached(s.cached, s.total),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: s.complete ? AppColors.primary : AppColors.text,
                  ),
                ),
                if (s.failed > 0 && !s.running)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(l.exOfflineFailed(s.failed), style: const TextStyle(color: AppColors.warning)),
                  ),
                if (downloading) ...[
                  const SizedBox(height: 12),
                  LinearProgressIndicator(value: s.progress, minHeight: 6, borderRadius: BorderRadius.circular(4)),
                ],
                const SizedBox(height: 8),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(l.exOfflineBody(kExerciseMediaApproxMb), style: const TextStyle(height: 1.4)),
          const SizedBox(height: 6),
          Text(l.exOfflineWifiTip, style: const TextStyle(color: AppColors.textMuted)),
          const SizedBox(height: 20),
          if (!online && !s.complete)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(children: [
                const Icon(Icons.wifi_off, color: AppColors.warning),
                const SizedBox(width: 8),
                Expanded(child: Text(l.exOfflineNeedsInternet)),
              ]),
            ),
          SizedBox(
            height: 56,
            child: downloading
                ? OutlinedButton.icon(onPressed: n.cancel, icon: const Icon(Icons.stop), label: Text(l.exOfflineCancel))
                : FilledButton.icon(
                    onPressed: (!online || checking || s.complete) ? null : () => n.start(),
                    icon: const Icon(Icons.download),
                    label: Text(l.exOfflineStart),
                  ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: (s.running || s.cached == 0) ? null : _confirmClear,
            icon: const Icon(Icons.delete_outline),
            label: Text(l.exOfflineClear),
          ),
        ],
      ),
    );
  }
}
