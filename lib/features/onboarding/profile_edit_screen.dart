import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/navigation.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/context_ext.dart';
import '../../core/widgets/common.dart';
import '../../data/repositories/profile_repository.dart';
import 'onboarding_data.dart';
import 'onboarding_labels.dart';
import 'onboarding_logic.dart';
import 'onboarding_summary.dart';
import 'onboarding_widgets.dart';
import 'plan_build_screen.dart';
import 'steps/step_registry.dart';

/// Settings → Profile: every onboarding answer grouped by section. Tapping one
/// opens the same question widget; saving recomputes the targets and offers
/// to regenerate the workout and/or meal plan with AI.
class ProfileEditScreen extends ConsumerWidget {
  const ProfileEditScreen({super.key});

  /// Steps not editable here (the API key lives in Settings → AI).
  static const excluded = {OnbStep.apiKey, OnbStep.summary};

  Future<void> _open(BuildContext context, WidgetRef ref, OnbStep step) async {
    final saved = await push<bool>(context, ProfileQuestionPage(step: step));
    if (saved != true || !context.mounted) return;
    if (step.affectsWorkout || step.affectsMeals) {
      await offerPlanRegeneration(context, ref, workout: step.affectsWorkout, meals: step.affectsMeals);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final profile = ref.watch(profileProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.onbProfileTitle)),
      body: profile.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => EmptyState(icon: Icons.error_outline, text: l.errorGeneric),
        data: (p) {
          if (p == null) return EmptyState(icon: Icons.person_outline, text: l.empty);
          final sections = buildProfileSummary(p, l, exclude: excluded);
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              Text(l.onbProfileSubtitle, style: context.text.bodyMedium?.copyWith(color: AppColors.textMuted)),
              const SizedBox(height: 12),
              TargetsCard(profile: p, title: l.onbProfileTargets),
              for (final s in sections) SummarySectionCard(section: s, onTap: (step) => _open(context, ref, step)),
            ],
          );
        },
      ),
    );
  }
}

/// Edits a single answer with the same widget used during onboarding.
/// Pops `true` when saved.
class ProfileQuestionPage extends ConsumerStatefulWidget {
  final OnbStep step;
  const ProfileQuestionPage({super.key, required this.step});

  @override
  ConsumerState<ProfileQuestionPage> createState() => _ProfileQuestionPageState();
}

class _ProfileQuestionPageState extends ConsumerState<ProfileQuestionPage> {
  UserProfile? _original;
  UserProfile? _draft;
  OnbIssue? _issue;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = ref.read(profileRepositoryProvider);
    final p = await OnboardingData.ensureProfile(repo, ref.read(localeProvider));
    if (!mounted) return;
    final pre = prefillPatch(widget.step, p);
    setState(() {
      _original = p;
      _draft = pre == null ? p : p.copyWithCompanion(pre);
    });
  }

  Future<void> _save() async {
    final draft = _draft!, original = _original!;
    final issue = validateStep(widget.step, draft);
    if (issue != null) {
      HapticFeedback.mediumImpact();
      setState(() => _issue = issue);
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() => _saving = true);
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final repo = ref.read(profileRepositoryProvider);
    final data = ref.read(onboardingDataProvider);
    try {
      await repo.upsert(answersCompanion(draft));
      switch (widget.step) {
        case OnbStep.body || OnbStep.bodyFat || OnbStep.measurements:
          await data.upsertTodayBodyMetric(draft);
        case OnbStep.supplements:
          await data.syncSupplements(
            parseSupplements(original.supplementsJson),
            parseSupplements(draft.supplementsJson),
          );
        default:
          break;
      }
      final recomputed = widget.step.affectsTargets && await repo.recomputeTargets() != null;
      messenger.showSnackBar(SnackBar(content: Text(recomputed ? l.onbSavedTargets : l.onbSaved)));
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        context.snack(l.errorGeneric);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final draft = _draft;
    return Scaffold(
      appBar: AppBar(title: Text(stepShortLabel(l, widget.step))),
      body: draft == null
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          StepHeader(step: widget.step),
                          buildStepBody(
                            widget.step,
                            profile: draft,
                            onChanged: (c) => setState(() {
                              _draft = _draft!.copyWithCompanion(c);
                              _issue = null;
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
                    decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.border))),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_issue != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(children: [
                              const Icon(Icons.error_outline, color: AppColors.danger, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(issueText(l, _issue!, daysPerWeek: draft.daysPerWeek),
                                    style: const TextStyle(color: AppColors.danger)),
                              ),
                            ]),
                          ),
                        SizedBox(
                          height: 56,
                          child: FilledButton.icon(
                            onPressed: _saving ? null : _save,
                            icon: _saving
                                ? const SizedBox(
                                    width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.5))
                                : const Icon(Icons.check),
                            label: Text(l.save),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

/// Convenience for other features: opens the profile editor.
void openProfileEditor(BuildContext context) => push<void>(context, const ProfileEditScreen());
