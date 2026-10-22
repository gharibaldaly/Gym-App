import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../ai/ai_service.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/context_ext.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../tracking/health_service.dart';
import '../onboarding_logic.dart';
import '../onboarding_summary.dart';
import '../onboarding_widgets.dart';
import 'step_types.dart';

/// Step 22 – Health Connect (smart ring). Enabling stores the flag right away
/// and triggers a sync (the tracking feature requests permissions on sync).
class HealthConnectStep extends ConsumerStatefulWidget {
  final UserProfile profile;
  final ProfilePatch onChanged;
  const HealthConnectStep({super.key, required this.profile, required this.onChanged});

  @override
  ConsumerState<HealthConnectStep> createState() => _HealthConnectStepState();
}

class _HealthConnectStepState extends ConsumerState<HealthConnectStep> {
  bool _busy = false;

  Future<void> _set(bool enabled) async {
    setState(() => _busy = true);
    widget.onChanged(UserProfilesCompanion(healthConnectEnabled: Value(enabled)));
    try {
      await ref.read(profileRepositoryProvider).upsert(UserProfilesCompanion(healthConnectEnabled: Value(enabled)));
      if (enabled) await ref.read(healthServiceProvider).sync();
    } catch (_) {
      // sync() never throws by contract; a DB error just leaves the flag in the draft.
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final enabled = widget.profile.healthConnectEnabled;
    Widget item(IconData icon, String text) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(children: [
            Icon(icon, color: AppColors.primary, size: 22),
            const SizedBox(width: 12),
            Expanded(child: Text(text, style: context.text.bodyLarge)),
          ]),
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              item(Symbols.bedtime_rounded, l.onbHealthItemSleep),
              item(Symbols.monitor_heart_rounded, l.onbHealthItemHeart),
              item(Symbols.directions_walk_rounded, l.onbHealthItemSteps),
            ]),
          ),
        ),
        const SizedBox(height: 16),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: enabled
              ? Container(
                  key: const ValueKey('on'),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary),
                  ),
                  child: Row(children: [
                    const Icon(Symbols.check_circle_rounded, fill: 1, color: AppColors.primary, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(l.onbHealthConnected, style: const TextStyle(fontWeight: FontWeight.w800)),
                        Text(l.onbHealthConnectedSub, style: context.text.bodySmall),
                      ]),
                    ),
                    TextButton(onPressed: _busy ? null : () => _set(false), child: Text(l.onbHealthDisconnect)),
                  ]),
                )
              : FilledButton.icon(
                  key: const ValueKey('off'),
                  onPressed: _busy ? null : () => _set(true),
                  icon: _busy
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Symbols.link_rounded),
                  label: Text(l.onbHealthConnect),
                ),
        ),
        InfoNote(l.onbHealthNote),
      ],
    );
  }
}

/// Step 23 – Claude API key (test + save to secure storage) or skip.
class ApiKeyStep extends ConsumerStatefulWidget {
  const ApiKeyStep({super.key});

  @override
  ConsumerState<ApiKeyStep> createState() => _ApiKeyStepState();
}

enum _KeyStatus { idle, testing, valid, invalid, saved }

class _ApiKeyStepState extends ConsumerState<ApiKeyStep> {
  final _c = TextEditingController();
  bool _obscure = true;
  bool _replacing = false;
  _KeyStatus _status = _KeyStatus.idle;
  String? _message;

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _setStatus(_KeyStatus status, String? message) => setState(() {
        _status = status;
        _message = message;
      });

  Future<void> _test() async {
    final key = _c.text.trim();
    final l = context.l10n;
    final ar = context.isAr;
    if (key.isEmpty) {
      _setStatus(_KeyStatus.invalid, l.onbKeyEmpty);
      return;
    }
    FocusScope.of(context).unfocus();
    _setStatus(_KeyStatus.testing, null);
    try {
      await ref.read(aiServiceProvider).testKey(key);
      if (!mounted) return;
      _setStatus(_KeyStatus.valid, l.onbKeyValid);
    } catch (e) {
      if (!mounted) return;
      _setStatus(_KeyStatus.invalid, l.onbKeyInvalid(aiErrorText(e, ar: ar)));
    }
  }

  Future<void> _save() async {
    final key = _c.text.trim();
    final l = context.l10n;
    if (key.isEmpty) {
      _setStatus(_KeyStatus.invalid, l.onbKeyEmpty);
      return;
    }
    FocusScope.of(context).unfocus();
    await ref.read(apiKeyProvider.notifier).save(key);
    if (!mounted) return;
    _c.clear();
    setState(() {
      _replacing = false;
      _status = _KeyStatus.saved;
      _message = l.onbKeySaved;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final hasKey = ref.watch(hasApiKeyProvider);
    if (hasKey && !_replacing) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary),
            ),
            child: Row(children: [
              const Icon(Symbols.verified_user_rounded, fill: 1, color: AppColors.primary, size: 32),
              const SizedBox(width: 12),
              Expanded(child: Text(l.onbKeySaved, style: const TextStyle(fontWeight: FontWeight.w700))),
            ]),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              icon: const Icon(Symbols.edit_rounded),
              label: Text(l.onbKeyReplace),
              onPressed: () => setState(() {
                _replacing = true;
                _status = _KeyStatus.idle;
                _message = null;
              }),
            ),
          ),
        ],
      );
    }
    final color = switch (_status) {
      _KeyStatus.valid || _KeyStatus.saved => AppColors.primary,
      _KeyStatus.invalid => AppColors.danger,
      _ => AppColors.textMuted,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _c,
          obscureText: _obscure,
          autocorrect: false,
          enableSuggestions: false,
          keyboardType: TextInputType.visiblePassword,
          textDirection: TextDirection.ltr,
          decoration: InputDecoration(
            labelText: l.onbKeyField,
            prefixIcon: const Icon(Symbols.key_rounded),
            suffixIcon: IconButton(
              icon: Icon(_obscure ? Symbols.visibility_rounded : Symbols.visibility_off_rounded),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
          ),
          onChanged: (_) {
            if (_status != _KeyStatus.idle) _setStatus(_KeyStatus.idle, null);
          },
        ),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _status == _KeyStatus.testing ? null : _test,
              icon: _status == _KeyStatus.testing
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Symbols.network_check_rounded),
              label: Text(l.onbKeyTest),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: FilledButton.icon(
              onPressed: _status == _KeyStatus.testing ? null : _save,
              icon: const Icon(Symbols.lock_rounded),
              label: Text(l.onbKeySave),
            ),
          ),
        ]),
        if (_message != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Row(children: [
              Icon(_status == _KeyStatus.invalid ? Symbols.error_rounded : Symbols.check_circle_rounded, color: color),
              const SizedBox(width: 8),
              Expanded(child: Text(_message!, style: TextStyle(color: color))),
            ]),
          ),
        InfoNote(l.onbKeyWhere, icon: Symbols.shield_rounded),
      ],
    );
  }
}

/// Step 24 – summary of every answer; tapping a row jumps back to edit it.
class SummaryStep extends ConsumerWidget {
  final UserProfile profile;
  final ValueChanged<OnbStep> onEdit;
  const SummaryStep({super.key, required this.profile, required this.onEdit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sections = buildProfileSummary(profile, context.l10n, hasApiKey: ref.watch(hasApiKeyProvider));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [for (final s in sections) SummarySectionCard(section: s, onTap: onEdit)],
    );
  }
}
