import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../ai/ai_service.dart';
import '../../core/navigation.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/context_ext.dart';
import '../../core/widgets/common.dart';
import '../../data/repositories/profile_repository.dart';
import '../../services/backup/backup_service.dart';
import '../../services/lock/app_lock.dart';
import '../../services/notifications/notification_service.dart';
import '../../services/widget/home_widget_service.dart';
import '../coach/coach_memory_screen.dart';
import '../exercises/exercise_offline_download_screen.dart';
import '../onboarding/profile_edit_screen.dart';
import '../tracking/tracking_screens.dart';
import 'about_screen.dart';
import 'ai_cost.dart';
import 'backup_screen.dart';
import 'notification_settings_screen.dart';

/// Bumped whenever a plain SharedPreferences value shown in Settings changes.
final settingsRevisionProvider = NotifierProvider<SettingsRevision, int>(SettingsRevision.new);

class SettingsRevision extends Notifier<int> {
  @override
  int build() => 0;
  void bump() => state++;
}

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    ref.watch(settingsRevisionProvider);
    final prefs = ref.watch(sharedPrefsProvider);
    final profile = ref.watch(profileProvider).value;
    final backupDue = isBackupDue(
      lastBackupAt: lastBackupAt(prefs),
      since: profile?.createdAt,
      now: DateTime.now(),
    );
    return Scaffold(
      appBar: AppBar(title: Text(l.settings)),
      body: ListView(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 32),
        children: [
          if (backupDue && profile?.onboardingComplete == true) const _BackupBanner(),
          _NavTile(
            icon: Symbols.person_rounded,
            title: l.setProfile,
            subtitle: l.setProfileSub,
            onTap: () => push(context, const ProfileEditScreen()),
          ),
          const _LanguageCard(),
          const SizedBox(height: 8),
          _SectionLabel(l.setSectionAi),
          const _ApiKeyCard(),
          const _ModelsCard(),
          const _CostCard(),
          const SizedBox(height: 8),
          _SectionLabel(l.setSectionApp),
          _NavTile(
            icon: Symbols.notifications_rounded,
            title: l.setNotifications,
            subtitle: l.setNotificationsSub,
            onTap: () => push(context, const NotificationSettingsScreen()),
          ),
          _NavTile(
            icon: Symbols.favorite_rounded,
            title: l.setHealthConnect,
            subtitle: l.setHealthConnectSub,
            onTap: () => push(context, const HealthConnectSettingsScreen()),
          ),
          _NavTile(
            icon: Symbols.psychology_rounded,
            title: l.setCoachMemory,
            subtitle: l.setCoachMemorySub,
            onTap: () => push(context, const CoachMemoryScreen()),
          ),
          _NavTile(
            icon: Symbols.backup_rounded,
            title: l.setBackup,
            subtitle: l.setBackupSub,
            onTap: () => push(context, const BackupScreen()),
          ),
          const _LockCard(),
          _NavTile(
            icon: Symbols.image_rounded,
            title: l.setExerciseImages,
            subtitle: l.setExerciseImagesSub,
            onTap: () => push(context, const ExerciseOfflineDownloadScreen()),
          ),
          const SizedBox(height: 8),
          _NavTile(
            icon: Symbols.info_rounded,
            title: l.setAbout,
            subtitle: l.setAboutSub,
            onTap: () => push(context, const AboutScreen()),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(4, 12, 4, 4),
        child: Text(text,
            style: context.text.labelLarge?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
      );
}

class _NavTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  const _NavTile({required this.icon, required this.title, this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          minVerticalPadding: 12,
          leading: Icon(icon, color: AppColors.primary),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: subtitle == null ? null : Text(subtitle!, style: const TextStyle(color: AppColors.textMuted)),
          trailing: Icon(context.isAr ? Symbols.chevron_left_rounded : Symbols.chevron_right_rounded, color: AppColors.textMuted),
          onTap: onTap,
        ),
      );
}

class _BackupBanner extends StatelessWidget {
  const _BackupBanner();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Card(
      color: AppColors.warning.withValues(alpha: 0.12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.warning),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            const Icon(Symbols.warning_rounded, color: AppColors.warning),
            const SizedBox(width: 12),
            Expanded(child: Text(l.setBackupBanner)),
            TextButton(onPressed: () => push(context, const BackupScreen()), child: Text(l.setBackupNow)),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Language

class _LanguageCard extends ConsumerWidget {
  const _LanguageCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final lang = ref.watch(localeProvider);
    return SectionCard(
      title: l.language,
      child: SegmentedButton<String>(
        segments: [
          ButtonSegment(value: 'ar', label: Text(l.arabic)),
          ButtonSegment(value: 'en', label: Text(l.english)),
        ],
        selected: {lang},
        showSelectedIcon: false,
        onSelectionChanged: (s) => changeLanguage(ref, s.first),
      ),
    );
  }
}

/// Switches the UI language, stores it in the profile and refreshes localized
/// notifications / the home widget.
Future<void> changeLanguage(WidgetRef ref, String code) async {
  await ref.read(localeProvider.notifier).set(code);
  final db = ref.read(databaseProvider);
  final prefs = ref.read(sharedPrefsProvider);
  try {
    final repo = ref.read(profileRepositoryProvider);
    if (await repo.get() != null) await repo.upsert(UserProfilesCompanion(language: Value(code)));
  } catch (_) {}
  await NotificationService.rescheduleAll(db, prefs);
  await HomeWidgetService.updateWith(ref.read);
}

// ---------------------------------------------------------------------------
// API key

class _ApiKeyCard extends ConsumerStatefulWidget {
  const _ApiKeyCard();

  @override
  ConsumerState<_ApiKeyCard> createState() => _ApiKeyCardState();
}

enum _TestState { idle, running, ok, failed }

class _ApiKeyCardState extends ConsumerState<_ApiKeyCard> {
  final _ctrl = TextEditingController();
  bool _obscure = true;
  bool _editing = false;
  _TestState _test = _TestState.idle;
  String? _testError;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  static String mask(String k) {
    if (k.length <= 12) return '•' * k.length;
    return '${k.substring(0, 7)}••••••••${k.substring(k.length - 4)}';
  }

  Future<void> _save() async {
    final k = _ctrl.text.trim();
    if (k.isEmpty) return;
    await ref.read(apiKeyProvider.notifier).save(k);
    if (!mounted) return;
    _ctrl.clear();
    setState(() {
      _editing = false;
      _test = _TestState.idle;
    });
    context.snack(context.l10n.setApiKeySaved);
  }

  Future<void> _runTest(String key) async {
    setState(() {
      _test = _TestState.running;
      _testError = null;
    });
    try {
      final ok = await ref.read(aiServiceProvider).testKey(key);
      if (!mounted) return;
      setState(() => _test = ok ? _TestState.ok : _TestState.failed);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _test = _TestState.failed;
        _testError = aiErrorText(e, ar: context.isAr);
      });
    }
  }

  Future<void> _remove() async {
    final l = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l.setApiKeyRemoveTitle),
        content: Text(l.setApiKeyRemoveBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(c, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: Text(l.delete),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(apiKeyProvider.notifier).clear();
    if (mounted) setState(() => _test = _TestState.idle);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final keyAsync = ref.watch(apiKeyProvider);
    final key = keyAsync.value;
    final showField = key == null || _editing;
    return SectionCard(
      title: l.setApiKey,
      trailing: Icon(key != null ? Symbols.check_circle_rounded : Symbols.key_off_rounded,
          color: key != null ? AppColors.primary : AppColors.textMuted),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l.setApiKeyHelp, style: context.text.bodySmall?.copyWith(color: AppColors.textMuted)),
          const SizedBox(height: 12),
          if (keyAsync.isLoading)
            const LinearProgressIndicator()
          else if (!showField) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(color: AppColors.cardHigh, borderRadius: BorderRadius.circular(12)),
              child: Text(mask(key), textDirection: TextDirection.ltr, style: const TextStyle(fontFamily: 'monospace')),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: _test == _TestState.running ? null : () => _runTest(key),
                  icon: const Icon(Symbols.network_check_rounded),
                  label: Text(l.setApiKeyTest),
                ),
                OutlinedButton(onPressed: () => setState(() => _editing = true), child: Text(l.setApiKeyChange)),
                TextButton(
                  onPressed: _remove,
                  style: TextButton.styleFrom(foregroundColor: AppColors.danger),
                  child: Text(l.setApiKeyRemove),
                ),
              ],
            ),
          ] else ...[
            TextField(
              controller: _ctrl,
              obscureText: _obscure,
              autocorrect: false,
              enableSuggestions: false,
              textDirection: TextDirection.ltr,
              decoration: InputDecoration(
                hintText: 'sk-ant-…',
                suffixIcon: IconButton(
                  icon: Icon(_obscure ? Symbols.visibility_rounded : Symbols.visibility_off_rounded),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
              onSubmitted: (_) => _save(),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton(onPressed: _save, child: Text(l.save)),
                OutlinedButton.icon(
                  onPressed: _test == _TestState.running
                      ? null
                      : () {
                          final k = _ctrl.text.trim();
                          if (k.isNotEmpty) _runTest(k);
                        },
                  icon: const Icon(Symbols.network_check_rounded),
                  label: Text(l.setApiKeyTest),
                ),
                if (key != null)
                  TextButton(onPressed: () => setState(() => _editing = false), child: Text(l.cancel)),
              ],
            ),
          ],
          if (_test != _TestState.idle) ...[
            const SizedBox(height: 12),
            _TestResult(state: _test, error: _testError),
          ],
        ],
      ),
    );
  }
}

class _TestResult extends StatelessWidget {
  final _TestState state;
  final String? error;
  const _TestResult({required this.state, this.error});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final (IconData icon, Color color, String text) = switch (state) {
      _TestState.running => (Symbols.hourglass_top_rounded, AppColors.textMuted, l.setApiKeyTesting),
      _TestState.ok => (Symbols.check_circle_rounded, AppColors.primary, l.setApiKeyValid),
      _ => (Symbols.error_rounded, AppColors.danger, error ?? l.setApiKeyInvalid),
    };
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state == _TestState.running)
          const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
        else
          Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: TextStyle(color: color))),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// AI models

class _ModelsCard extends ConsumerStatefulWidget {
  const _ModelsCard();

  @override
  ConsumerState<_ModelsCard> createState() => _ModelsCardState();
}

class _ModelsCardState extends ConsumerState<_ModelsCard> {
  late final TextEditingController _haiku, _sonnet, _opus;

  @override
  void initState() {
    super.initState();
    final p = ref.read(sharedPrefsProvider);
    _haiku = TextEditingController(text: p.getString(SettingsKeys.modelHaiku) ?? AiDefaults.haiku);
    _sonnet = TextEditingController(text: p.getString(SettingsKeys.modelSonnet) ?? AiDefaults.sonnet);
    _opus = TextEditingController(text: p.getString(SettingsKeys.modelOpus) ?? AiDefaults.opus);
  }

  @override
  void dispose() {
    _haiku.dispose();
    _sonnet.dispose();
    _opus.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final p = ref.read(sharedPrefsProvider);
    Future<void> put(String key, String v, String def) async {
      final t = v.trim();
      if (t.isEmpty || t == def) {
        await p.remove(key);
      } else {
        await p.setString(key, t);
      }
    }

    await put(SettingsKeys.modelHaiku, _haiku.text, AiDefaults.haiku);
    await put(SettingsKeys.modelSonnet, _sonnet.text, AiDefaults.sonnet);
    await put(SettingsKeys.modelOpus, _opus.text, AiDefaults.opus);
    if (mounted) context.snack(context.l10n.setModelsSaved);
  }

  Future<void> _reset() async {
    final p = ref.read(sharedPrefsProvider);
    for (final k in [SettingsKeys.modelHaiku, SettingsKeys.modelSonnet, SettingsKeys.modelOpus]) {
      await p.remove(k);
    }
    setState(() {
      _haiku.text = AiDefaults.haiku;
      _sonnet.text = AiDefaults.sonnet;
      _opus.text = AiDefaults.opus;
    });
    if (mounted) context.snack(context.l10n.setModelsResetDone);
  }

  Widget _field(String label, String help, TextEditingController c) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextField(
          controller: c,
          autocorrect: false,
          enableSuggestions: false,
          textDirection: TextDirection.ltr,
          decoration: InputDecoration(labelText: label, helperText: help, helperMaxLines: 2),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final prefs = ref.watch(sharedPrefsProvider);
    ref.watch(settingsRevisionProvider);
    final fallbacks = prefs.getBool(SettingsKeys.useRefusalFallbacks) ?? true;
    return SectionCard(
      title: l.setModels,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _field(l.setModelFast, l.setModelFastHelp, _haiku),
          _field(l.setModelBalanced, l.setModelBalancedHelp, _sonnet),
          _field(l.setModelSmart, l.setModelSmartHelp, _opus),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: fallbacks,
            title: Text(l.setRefusalFallback),
            subtitle: Text(l.setRefusalFallbackSub, style: const TextStyle(color: AppColors.textMuted)),
            onChanged: (v) async {
              await prefs.setBool(SettingsKeys.useRefusalFallbacks, v);
              ref.read(settingsRevisionProvider.notifier).bump();
            },
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: FilledButton(onPressed: _save, child: Text(l.save))),
              const SizedBox(width: 8),
              Expanded(child: OutlinedButton(onPressed: _reset, child: Text(l.setModelsReset))),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// AI cost counter

String aiFeatureLabel(AppLocalizations l, String key) => switch (key) {
      'voice_parse' => l.setFeatVoiceParse,
      'exercise_alternatives' => l.setFeatExerciseAlternatives,
      'memory_extract' => l.setFeatMemoryExtract,
      'food_text' => l.setFeatFoodText,
      'exercise_create' => l.setFeatExerciseCreate,
      'chat' => l.setFeatChat,
      'workout_summary' => l.setFeatWorkoutSummary,
      'food_photo' => l.setFeatFoodPhoto,
      'morning_message' => l.setFeatMorningMessage,
      'plateau' => l.setFeatPlateau,
      'meal_swap' => l.setFeatMealSwap,
      'grocery_list' => l.setFeatGroceryList,
      'initial_plan' => l.setFeatInitialPlan,
      'meal_plan' => l.setFeatMealPlan,
      'weekly_report' => l.setFeatWeeklyReport,
      'key_test' => l.setFeatKeyTest,
      _ => key,
    };

class _CostCard extends ConsumerStatefulWidget {
  const _CostCard();

  @override
  ConsumerState<_CostCard> createState() => _CostCardState();
}

class _CostCardState extends ConsumerState<_CostCard> {
  int _period = 1; // 0 today, 1 month, 2 all time

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final summary = ref.watch(costSummaryProvider);
    return SectionCard(
      title: l.setCost,
      child: summary.when(
        loading: () => const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator())),
        error: (e, _) => Text(l.errorGeneric),
        data: (s) {
          final period = switch (_period) { 0 => s.today, 1 => s.month, _ => s.allTime };
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(child: _CostStat(label: l.setCostToday, totals: s.today.total)),
                  const SizedBox(width: 8),
                  Expanded(child: _CostStat(label: l.setCostMonth, totals: s.month.total)),
                  const SizedBox(width: 8),
                  Expanded(child: _CostStat(label: l.setCostAllTime, totals: s.allTime.total)),
                ],
              ),
              const SizedBox(height: 16),
              Text(l.setCostByFeature, style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              SegmentedButton<int>(
                segments: [
                  ButtonSegment(value: 0, label: Text(l.setCostToday)),
                  ButtonSegment(value: 1, label: Text(l.setCostMonth)),
                  ButtonSegment(value: 2, label: Text(l.setCostAllTime)),
                ],
                selected: {_period},
                showSelectedIcon: false,
                onSelectionChanged: (v) => setState(() => _period = v.first),
              ),
              const SizedBox(height: 8),
              if (period.byFeature.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(l.setCostEmpty, style: const TextStyle(color: AppColors.textMuted)),
                )
              else
                for (final e in period.byFeature)
                  _FeatureCostRow(
                    label: aiFeatureLabel(l, e.key),
                    totals: e.value,
                    share: period.total.costUsd > 0 ? e.value.costUsd / period.total.costUsd : 0,
                  ),
              const SizedBox(height: 8),
              Text(l.setCostNote, style: context.text.bodySmall?.copyWith(color: AppColors.textMuted)),
            ],
          );
        },
      ),
    );
  }
}

class _CostStat extends StatelessWidget {
  final String label;
  final UsageTotals totals;
  const _CostStat({required this.label, required this.totals});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: AppColors.cardHigh, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Text(fmtUsd(totals.costUsd),
                  textDirection: TextDirection.ltr,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppColors.primary)),
            ),
            Text(context.l10n.setCostTokens(fmtTokens(totals.totalTokens)),
                style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
          ],
        ),
      );
}

class _FeatureCostRow extends StatelessWidget {
  final String label;
  final UsageTotals totals;
  final double share;
  const _FeatureCostRow({required this.label, required this.totals, required this.share});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
              Text(fmtUsd(totals.costUsd), textDirection: TextDirection.ltr),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            l.setCostFeatureDetail(totals.requests, fmtTokens(totals.inputTokens), fmtTokens(totals.outputTokens),
                fmtTokens(totals.cacheReadTokens + totals.cacheWriteTokens)),
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: share.clamp(0.0, 1.0),
              minHeight: 5,
              backgroundColor: AppColors.cardHigh,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// App lock

class _LockCard extends ConsumerStatefulWidget {
  const _LockCard();

  @override
  ConsumerState<_LockCard> createState() => _LockCardState();
}

class _LockCardState extends ConsumerState<_LockCard> {
  bool _busy = false;

  Future<void> _toggle(bool v) async {
    final l = context.l10n;
    final prefs = ref.read(sharedPrefsProvider);
    setState(() => _busy = true);
    try {
      if (v && !await AppLockAuth.isSupported()) {
        if (mounted) context.snack(l.setLockUnsupported);
        return;
      }
      // Verify the user both when enabling (proves it works) and before disabling.
      final res = await AppLockAuth.authenticate(v ? l.setLockEnableReason : l.setLockDisableReason);
      if (res != LockAuthResult.success) {
        if (mounted) context.snack(res == LockAuthResult.unavailable ? l.setLockUnsupported : l.setLockFailed);
        return;
      }
      await prefs.setBool(SettingsKeys.lockEnabled, v);
      ref.read(settingsRevisionProvider.notifier).bump();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _timeoutLabel(AppLocalizations l, int s) {
    if (s == 0) return l.setLockImmediately;
    if (s < 60) return l.setLockSeconds(s);
    return l.setLockMinutes(s ~/ 60);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    ref.watch(settingsRevisionProvider);
    final prefs = ref.watch(sharedPrefsProvider);
    final enabled = AppLockPrefs.enabled(prefs);
    final timeout = AppLockPrefs.timeoutSeconds(prefs);
    final options = {...AppLockPrefs.timeoutOptions, timeout}.toList()..sort();
    return Card(
      child: Column(
        children: [
          SwitchListTile(
            secondary: const Icon(Symbols.fingerprint_rounded, color: AppColors.primary),
            title: Text(l.setLock, style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(l.setLockSub, style: const TextStyle(color: AppColors.textMuted)),
            value: enabled,
            onChanged: _busy ? null : _toggle,
          ),
          if (enabled)
            ListTile(
              leading: const Icon(Symbols.timer_rounded, color: AppColors.textMuted),
              title: Text(l.setLockTimeout),
              trailing: DropdownButton<int>(
                value: timeout,
                underline: const SizedBox.shrink(),
                items: [
                  for (final s in options) DropdownMenuItem(value: s, child: Text(_timeoutLabel(l, s))),
                ],
                onChanged: (s) async {
                  if (s == null) return;
                  await prefs.setInt(SettingsKeys.lockAfterSeconds, s);
                  ref.read(settingsRevisionProvider.notifier).bump();
                },
              ),
            ),
        ],
      ),
    );
  }
}
