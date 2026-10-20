import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../ai/ai_service.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/context_ext.dart';
import '../../data/repositories/profile_repository.dart';
import 'onboarding_data.dart';
import 'onboarding_labels.dart';
import 'onboarding_logic.dart';
import 'onboarding_widgets.dart';
import 'plan_build_screen.dart';
import 'steps/step_registry.dart';

/// SharedPreferences key holding the step to resume at after an app restart.
const onboardingStepPrefKey = 'onb_current_step';

/// First-run questionnaire (24 steps, spec §2). Every answer is saved to
/// user_profiles as it changes (debounced), so killing the app mid-way keeps
/// the answers and resumes at the same step. "Build my plan" computes targets
/// locally, generates AI plans when possible, then sets onboardingComplete
/// (the app gate switches to the home shell).
class OnboardingFlow extends ConsumerStatefulWidget {
  const OnboardingFlow({super.key});

  @override
  ConsumerState<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends ConsumerState<OnboardingFlow> {
  static final _steps = OnbStep.values;
  static final _summaryIndex = OnbStep.summary.index;

  late final ProfileRepository _repo = ref.read(profileRepositoryProvider);
  late final AppLifecycleListener _life;
  PageController? _pc;
  UserProfile? _p;
  int _index = 0;
  bool _fromSummary = false;
  OnbIssue? _issue;
  Timer? _saveTimer;
  bool _dirty = false;
  bool _busy = false;
  bool _completed = false;
  List<SupplementEntry> _syncedSupps = const [];

  @override
  void initState() {
    super.initState();
    _life = AppLifecycleListener(onInactive: _flush, onPause: _flush, onDetach: _flush);
    _load();
  }

  @override
  void dispose() {
    _saveTimer?.cancel();
    if (!_completed) unawaited(_flush());
    _life.dispose();
    _pc?.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    var p = await OnboardingData.ensureProfile(_repo, ref.read(localeProvider));
    final prefs = ref.read(sharedPrefsProvider);
    final index = (prefs.getInt(onboardingStepPrefKey) ?? 0).clamp(0, _summaryIndex);
    final pre = prefillPatch(_steps[index], p);
    if (pre != null) {
      p = p.copyWithCompanion(pre);
      _dirty = true;
    }
    if (!mounted) return;
    setState(() {
      _p = p;
      _index = index;
      _syncedSupps = parseSupplements(p.supplementsJson);
      _pc = PageController(initialPage: index);
    });
    if (_dirty) unawaited(_flush());
  }

  // ---- persistence ---------------------------------------------------------

  void _patch(UserProfilesCompanion c) {
    setState(() {
      _p = _p!.copyWithCompanion(c);
      _issue = null;
    });
    _dirty = true;
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 400), _flush);
  }

  Future<void> _flush() async {
    _saveTimer?.cancel();
    final p = _p;
    if (!_dirty || p == null || _completed) return;
    _dirty = false;
    try {
      await _repo.upsert(answersCompanion(p));
    } catch (e, st) {
      debugPrint('onboarding save failed: $e\n$st');
      _dirty = true;
    }
  }

  // ---- navigation ----------------------------------------------------------

  void _goTo(int i, {bool fromSummary = false}) {
    FocusScope.of(context).unfocus();
    final pre = prefillPatch(_steps[i], _p!);
    if (pre != null) _patch(pre);
    final distance = (i - _index).abs();
    setState(() {
      _index = i;
      _fromSummary = fromSummary;
      _issue = null;
    });
    if (distance > 1) {
      _pc!.jumpToPage(i);
    } else {
      _pc!.animateToPage(i, duration: const Duration(milliseconds: 380), curve: Curves.easeOutCubic);
    }
    unawaited(ref.read(sharedPrefsProvider).setInt(onboardingStepPrefKey, i));
    unawaited(_flush());
  }

  Future<void> _next() async {
    final step = _steps[_index];
    if (step == OnbStep.summary) return _buildPlan();
    final issue = validateStep(step, _p!);
    if (issue != null) {
      HapticFeedback.mediumImpact();
      setState(() => _issue = issue);
      return;
    }
    await _leaveStep(step);
    if (!mounted) return;
    _goTo(_fromSummary ? _summaryIndex : _index + 1);
  }

  void _back() {
    if (_index == 0) return;
    _goTo(_fromSummary ? _summaryIndex : _index - 1);
  }

  Future<void> _leaveStep(OnbStep step) async {
    if (step != OnbStep.supplements) return;
    final current = parseSupplements(_p!.supplementsJson);
    try {
      await ref.read(onboardingDataProvider).syncSupplements(_syncedSupps, current);
      _syncedSupps = current;
    } catch (e) {
      debugPrint('supplement sync failed: $e');
    }
  }

  // ---- finish --------------------------------------------------------------

  Future<void> _buildPlan() async {
    final bad = firstInvalidStep(_p!);
    if (bad != null) {
      _goTo(bad.index, fromSummary: true);
      setState(() => _issue = validateStep(bad, _p!));
      return;
    }
    setState(() => _busy = true);
    try {
      await _flush();
      final data = ref.read(onboardingDataProvider);
      await data.upsertTodayBodyMetric(_p!);
      final supps = parseSupplements(_p!.supplementsJson);
      await data.syncSupplements(_syncedSupps, supps);
      _syncedSupps = supps;
      await _repo.recomputeTargets();
    } catch (e, st) {
      debugPrint('onboarding finalize failed: $e\n$st');
    }
    if (!mounted) return;
    setState(() => _busy = false);
    final nav = Navigator.of(context);
    await nav.push(MaterialPageRoute<void>(builder: (_) => PlanBuildScreen(onFinished: () => _complete(nav))));
  }

  Future<void> _complete(NavigatorState nav) async {
    if (_completed) return;
    _saveTimer?.cancel();
    await _flush();
    _completed = true;
    nav.popUntil((r) => r.isFirst);
    await ref.read(sharedPrefsProvider).remove(onboardingStepPrefKey);
    await _repo.upsert(const UserProfilesCompanion(onboardingComplete: Value(true)));
  }

  // ---- UI ------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final p = _p, pc = _pc;
    if (p == null || pc == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final l = context.l10n;
    final step = _steps[_index];
    return PopScope(
      canPop: _index == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              _TopBar(index: _index, total: _steps.length, step: step, onBack: _index > 0 ? _back : null),
              Expanded(
                child: PageView.builder(
                  controller: pc,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _steps.length,
                  itemBuilder: (context, i) => _StepPage(
                    step: _steps[i],
                    child: buildStepBody(
                      _steps[i],
                      profile: p,
                      onChanged: _patch,
                      onEditStep: (s) => _goTo(s.index, fromSummary: true),
                    ),
                  ),
                ),
              ),
              _BottomBar(
                issue: _issue == null ? null : issueText(l, _issue!, daysPerWeek: p.daysPerWeek),
                label: switch (step) {
                  OnbStep.summary => l.onbBuildPlan,
                  _ when _fromSummary => l.onbBackToSummary,
                  OnbStep.healthConnect when !p.healthConnectEnabled => l.onbSkip,
                  OnbStep.apiKey when !ref.watch(hasApiKeyProvider) => l.onbSkip,
                  _ => l.onbNext,
                },
                icon: switch (step) {
                  OnbStep.summary => Icons.auto_awesome,
                  _ when _fromSummary => Icons.fact_check_outlined,
                  _ => Icons.arrow_forward,
                },
                outlined: (step == OnbStep.healthConnect && !p.healthConnectEnabled) ||
                    (step == OnbStep.apiKey && !ref.watch(hasApiKeyProvider)),
                busy: _busy,
                onPressed: _next,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final int index;
  final int total;
  final OnbStep step;
  final VoidCallback? onBack;
  const _TopBar({required this.index, required this.total, required this.step, this.onBack});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(4, 8, 20, 4),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            child: AnimatedOpacity(
              opacity: onBack == null ? 0 : 1,
              duration: const Duration(milliseconds: 200),
              child: IconButton(
                tooltip: l.onbBack,
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(children: [
                  Expanded(
                    child: Text(
                      sectionTitle(l, step.section),
                      style: context.text.labelLarge?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Text(l.onbStepOf('${index + 1}', '$total'),
                      style: context.text.labelMedium?.copyWith(color: AppColors.textMuted)),
                ]),
                const SizedBox(height: 6),
                TweenAnimationBuilder<double>(
                  tween: Tween(end: (index + 1) / total),
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  builder: (context, v, _) => ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: v,
                      minHeight: 8,
                      backgroundColor: AppColors.cardHigh,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepPage extends StatelessWidget {
  final OnbStep step;
  final Widget child;
  const _StepPage({required this.step, required this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [StepHeader(step: step), child],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final String? issue;
  final String label;
  final IconData icon;
  final bool outlined;
  final bool busy;
  final VoidCallback onPressed;
  const _BottomBar({
    required this.issue,
    required this.label,
    required this.icon,
    required this.outlined,
    required this.busy,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final content = busy
        ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5))
        : Row(mainAxisSize: MainAxisSize.min, children: [
            Text(label),
            const SizedBox(width: 8),
            Icon(icon, size: 20),
          ]);
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: issue == null
                ? const SizedBox(width: double.infinity)
                : Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.danger.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(children: [
                      const Icon(Icons.error_outline, color: AppColors.danger, size: 20),
                      const SizedBox(width: 8),
                      Expanded(child: Text(issue!, style: const TextStyle(color: AppColors.danger))),
                    ]),
                  ),
          ),
          SizedBox(
            height: 56,
            child: outlined
                ? OutlinedButton(onPressed: busy ? null : onPressed, child: content)
                : FilledButton(onPressed: busy ? null : onPressed, child: content),
          ),
        ],
      ),
    );
  }
}
