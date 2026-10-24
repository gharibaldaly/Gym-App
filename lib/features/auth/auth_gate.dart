import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthChangeEvent, AuthState;

import '../../app/app_restarter.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/context_ext.dart';
import '../../core/widgets/brand_mark.dart';
import '../../core/widgets/common.dart';
import '../../services/cloud/cloud_providers.dart';
import 'auth_screen.dart';

/// First thing in the app: sign-in screen when signed out; right after signing in
/// on a device, brings the user's data back from the cloud (or uploads it); then the
/// app itself, kept backed up by [CloudSyncHost]. Without Supabase (tests, or when it
/// failed to start) it shows [child] directly.
class AuthGate extends ConsumerStatefulWidget {
  final Widget child;
  const AuthGate({super.key, required this.child});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  StreamSubscription<AuthState>? _recovery;

  /// Accounts whose cloud check the user skipped (offline) for this run only.
  final _skipped = <String>{};

  @override
  void initState() {
    super.initState();
    if (!ref.read(cloudEnabledProvider)) return;
    // Opening a password-reset link signs the user in and asks for a new password.
    _recovery = CloudRuntime.auth.onAuthStateChange.listen((s) {
      if (s.event == AuthChangeEvent.passwordRecovery && mounted) showNewPasswordDialog(context);
    });
  }

  @override
  void dispose() {
    _recovery?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!ref.watch(cloudEnabledProvider)) return widget.child;
    final user = ref.watch(authUserProvider);
    if (user.isLoading && !user.hasValue) return const BrandSplash();
    final u = user.value;
    if (u == null) return const AuthScreen();
    final sync = ref.watch(cloudSyncProvider)!;
    if (!sync.isResolved(u.id) && !_skipped.contains(u.id)) {
      return _CloudResolveScreen(
        key: ValueKey(u.id),
        uid: u.id,
        onDone: () => setState(() {}),
        onSkip: () => setState(() => _skipped.add(u.id)),
      );
    }
    return CloudSyncHost(key: ValueKey(u.id), uid: u.id, child: widget.child);
  }
}

enum _Phase { checking, choose, working, offline }

/// Runs once per account on each device: restores the cloud backup on a fresh
/// install, uploads local data on first sign-in, or lets the user pick when both exist.
class _CloudResolveScreen extends ConsumerStatefulWidget {
  final String uid;
  final VoidCallback onDone;
  final VoidCallback onSkip;
  const _CloudResolveScreen({super.key, required this.uid, required this.onDone, required this.onSkip});

  @override
  ConsumerState<_CloudResolveScreen> createState() => _CloudResolveScreenState();
}

class _CloudResolveScreenState extends ConsumerState<_CloudResolveScreen> {
  _Phase _phase = _Phase.checking;
  bool _restoring = false;
  double _progress = 0;
  CloudBackupInfo? _remote;

  CloudSync get _sync => ref.read(cloudSyncProvider)!;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    setState(() => _phase = _Phase.checking);
    try {
      _remote = await _sync.remoteInfo(widget.uid);
      final action = decideLoginSync(hasLocal: await _sync.ops.hasLocalData(), hasCloud: _remote != null);
      switch (action) {
        case LoginSyncAction.none:
          await _finish();
        case LoginSyncAction.upload:
          await _upload();
        case LoginSyncAction.restore:
          await _restore();
        case LoginSyncAction.choose:
          if (mounted) setState(() => _phase = _Phase.choose);
      }
    } catch (e) {
      debugPrint('cloud check failed: $e');
      if (mounted) setState(() => _phase = _Phase.offline);
    }
  }

  Future<void> _finish() async {
    await _sync.markResolved(widget.uid);
    widget.onDone();
  }

  Future<void> _upload() async {
    setState(() {
      _phase = _Phase.working;
      _restoring = false;
      _progress = 0;
    });
    try {
      await _sync.upload(widget.uid, onProgress: (v) => mounted ? setState(() => _progress = v) : null);
      ref.read(cloudLastUploadProvider.notifier).refresh();
    } catch (e) {
      // Not fatal: the data is still on the phone and the next change retries the upload.
      debugPrint('first upload failed: $e');
      await _sync.markDirty();
    }
    await _finish();
  }

  Future<void> _restore() async {
    setState(() {
      _phase = _Phase.working;
      _restoring = true;
      _progress = 0;
    });
    try {
      await _sync.restore(widget.uid, onProgress: (v) => mounted ? setState(() => _progress = v) : null);
      await _sync.markResolved(widget.uid);
      // The database file was replaced: rebuild everything on top of it.
      if (mounted) AppRestarter.restartApp(context);
    } catch (e) {
      debugPrint('restore failed: $e');
      if (mounted) {
        context.snack(context.l10n.authErrGeneric('$e'), kind: ToastKind.error);
        setState(() => _phase = _Phase.offline);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final body = switch (_phase) {
      _Phase.checking => _status(l.cloudChecking, null),
      _Phase.working => _status(
          _restoring ? l.cloudRestoring((_progress * 100).round()) : l.cloudUploading((_progress * 100).round()),
          _progress,
        ),
      _Phase.choose => _choose(l),
      _Phase.offline => _offline(l),
    };
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpace.xl),
            child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 420), child: body),
          ),
        ),
      ),
    );
  }

  Widget _status(String text, double? progress) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BrandMark(size: 96),
          const SizedBox(height: AppSpace.xl),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: LinearProgressIndicator(value: progress, minHeight: 6),
          ),
          const SizedBox(height: AppSpace.md),
          Text(text, textAlign: TextAlign.center, style: context.text.bodyMedium),
        ],
      );

  Widget _choose(AppLocalizations l) {
    final date = _remote == null ? '' : DateFormat.yMMMd(context.lang).add_jm().format(_remote!.createdAt);
    return Reveal(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(child: IconBadge(Symbols.sync_problem_rounded, color: AppColors.warning, size: 64)),
          const SizedBox(height: AppSpace.lg),
          Text(l.cloudChooseTitle, textAlign: TextAlign.center, style: context.text.titleLarge),
          const SizedBox(height: AppSpace.sm),
          Text(l.cloudChooseBody,
              textAlign: TextAlign.center, style: context.text.bodyMedium?.copyWith(color: AppColors.textMuted)),
          const SizedBox(height: AppSpace.xl),
          FilledButton.icon(
            onPressed: _restore,
            icon: const Icon(Symbols.cloud_download_rounded),
            label: Text(l.cloudUseCloud(date), textAlign: TextAlign.center),
          ),
          const SizedBox(height: AppSpace.md),
          OutlinedButton.icon(
            onPressed: _upload,
            icon: const Icon(Symbols.smartphone_rounded),
            label: Text(l.cloudUseDevice),
          ),
        ],
      ),
    );
  }

  Widget _offline(AppLocalizations l) => Reveal(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(child: IconBadge(Symbols.cloud_off_rounded, color: AppColors.warning, size: 64)),
            const SizedBox(height: AppSpace.lg),
            Text(l.cloudOfflineTitle, textAlign: TextAlign.center, style: context.text.titleLarge),
            const SizedBox(height: AppSpace.sm),
            Text(l.cloudOfflineBody,
                textAlign: TextAlign.center, style: context.text.bodyMedium?.copyWith(color: AppColors.textMuted)),
            const SizedBox(height: AppSpace.xl),
            FilledButton.icon(onPressed: _check, icon: const Icon(Symbols.refresh_rounded), label: Text(l.cloudRetry)),
            const SizedBox(height: AppSpace.md),
            // Not marked resolved: the next launch checks the cloud again.
            OutlinedButton(onPressed: widget.onSkip, child: Text(l.cloudContinueOffline)),
          ],
        ),
      );
}
