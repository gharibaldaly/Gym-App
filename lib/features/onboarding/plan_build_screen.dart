import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../ai/ai_service.dart';
import '../../core/navigation.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/context_ext.dart';
import '../../data/repositories/profile_repository.dart';
import '../nutrition/meal_plan_generator.dart';
import '../workout/plan_generator.dart';
import '../workout/plan_review_screen.dart';
import 'onboarding_widgets.dart';

// ---------------------------------------------------------------------------
// Shared helpers (onboarding + profile editor)
// ---------------------------------------------------------------------------

enum AiAvailability { ok, noKey, offline }

/// Whether AI generation can run right now (key configured + online).
Future<AiAvailability> checkAiAvailability(WidgetRef ref) async {
  String? key;
  try {
    key = ref.read(apiKeyProvider).value ?? await ref.read(apiKeyProvider.future);
  } catch (_) {
    key = null;
  }
  if (key == null) return AiAvailability.noKey;
  if (!ref.read(isOnlineProvider)) return AiAvailability.offline;
  return AiAvailability.ok;
}

/// User-facing text for a generator failure. AI errors get the specific
/// bilingual message; anything else (e.g. a bug) gets a generic one.
String planErrorText(BuildContext context, Object e) =>
    e is AiException ? aiErrorText(e, ar: context.isAr) : context.l10n.onbGenericError;

class PlanGenResult {
  final int? planId;
  final Object? workoutError;
  final bool mealOk;
  final Object? mealError;
  const PlanGenResult({this.planId, this.workoutError, this.mealOk = false, this.mealError});
}

/// Runs the selected generators in parallel; never throws.
Future<PlanGenResult> runPlanGenerators({WorkoutPlanGenerator? workout, MealPlanGenerator? meals}) async {
  int? planId;
  Object? wErr, mErr;
  var mealOk = false;
  await Future.wait([
    if (workout != null)
      () async {
        try {
          planId = await workout.generateAndSave();
        } catch (e, st) {
          debugPrint('workout plan generation failed: $e\n$st');
          wErr = e;
        }
      }(),
    if (meals != null)
      () async {
        try {
          await meals.generateAndSave();
          mealOk = true;
        } catch (e, st) {
          debugPrint('meal plan generation failed: $e\n$st');
          mErr = e;
        }
      }(),
  ]);
  return PlanGenResult(planId: planId, workoutError: wErr, mealOk: mealOk, mealError: mErr);
}

/// After a profile edit: asks whether to regenerate the workout and/or meal
/// plan with AI, runs the generators and opens the plan review. Handles the
/// no-key / offline / error cases with clear messages.
Future<void> offerPlanRegeneration(
  BuildContext context,
  WidgetRef ref, {
  bool workout = true,
  bool meals = true,
}) async {
  final choice = await showDialog<(bool, bool)>(
    context: context,
    builder: (_) => _RegenerateDialog(workout: workout, meals: meals),
  );
  if (choice == null || (!choice.$1 && !choice.$2) || !context.mounted) return;
  final l = context.l10n;
  final availability = await checkAiAvailability(ref);
  if (!context.mounted) return;
  if (availability != AiAvailability.ok) {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: Icon(availability == AiAvailability.noKey ? Symbols.key_off_rounded : Symbols.wifi_off_rounded, color: AppColors.warning),
        title: Text(l.onbRegenResultTitle),
        content: Text(availability == AiAvailability.noKey ? l.onbRegenNoKey : l.onbRegenOffline),
        actions: [
          if (availability == AiAvailability.noKey)
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                openSettings(context);
              },
              child: Text(l.addApiKey),
            ),
          FilledButton(onPressed: () => Navigator.pop(ctx), child: Text(l.ok)),
        ],
      ),
    );
    return;
  }

  final workoutGen = choice.$1 ? ref.read(workoutPlanGeneratorProvider) : null;
  final mealGen = choice.$2 ? ref.read(mealPlanGeneratorProvider) : null;
  final nav = Navigator.of(context);
  final messenger = ScaffoldMessenger.of(context);
  unawaited(showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => PopScope(
      canPop: false,
      child: AlertDialog(
        content: Row(children: [
          const CircularProgressIndicator(),
          const SizedBox(width: 20),
          Expanded(child: Text(l.onbRegenRunning)),
        ]),
      ),
    ),
  ));
  final r = await runPlanGenerators(workout: workoutGen, meals: mealGen);
  nav.pop(); // progress dialog
  if (!context.mounted) return;

  final lines = <(bool, String)>[
    if (workoutGen != null)
      r.planId != null
          ? (true, l.onbRegenWorkoutDone)
          : (false, '${l.onbBuildWorkout}: ${planErrorText(context, r.workoutError!)}\n${l.onbBuildWorkoutLater}'),
    if (mealGen != null)
      r.mealOk
          ? (true, l.onbRegenMealDone)
          : (false, '${l.onbBuildMeals}: ${planErrorText(context, r.mealError!)}\n${l.onbBuildMealsLater}'),
  ];
  final review = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l.onbRegenResultTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (ok, text) in lines)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(ok ? Symbols.check_circle_rounded : Symbols.error_rounded,
                    color: ok ? AppColors.primary : AppColors.warning),
                const SizedBox(width: 10),
                Expanded(child: Text(text)),
              ]),
            ),
        ],
      ),
      actions: [
        if (r.planId != null) ...[
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.onbSkipReview)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.onbReviewPlan)),
        ] else
          FilledButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.ok)),
      ],
    ),
  );
  if (review == true && r.planId != null && context.mounted) {
    await push<void>(
      context,
      PlanReviewScreen(
        planId: r.planId!,
        // The review screen doesn't pop itself when onApproved is given.
        onApproved: () {
          nav.pop();
          messenger.showSnackBar(SnackBar(content: Text(l.onbPlanActivated)));
        },
      ),
    );
  }
}

class _RegenerateDialog extends StatefulWidget {
  final bool workout;
  final bool meals;
  const _RegenerateDialog({required this.workout, required this.meals});

  @override
  State<_RegenerateDialog> createState() => _RegenerateDialogState();
}

class _RegenerateDialogState extends State<_RegenerateDialog> {
  late bool _workout = widget.workout;
  late bool _meals = widget.meals;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AlertDialog(
      icon: const Icon(Symbols.auto_awesome_rounded, color: AppColors.primary),
      title: Text(l.onbRegenTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l.onbRegenBody),
          const SizedBox(height: 8),
          CheckboxListTile(
            value: _workout,
            onChanged: (v) => setState(() => _workout = v ?? false),
            title: Text(l.onbRegenWorkout),
            secondary: const Icon(Symbols.fitness_center_rounded, fill: 1),
            contentPadding: EdgeInsets.zero,
          ),
          CheckboxListTile(
            value: _meals,
            onChanged: (v) => setState(() => _meals = v ?? false),
            title: Text(l.onbRegenMeals),
            secondary: const Icon(Symbols.restaurant_rounded, fill: 1),
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l.onbRegenSkip)),
        FilledButton(
          onPressed: _workout || _meals ? () => Navigator.pop(context, (_workout, _meals)) : null,
          child: Text(l.onbRegenNow),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Targets card
// ---------------------------------------------------------------------------

/// Daily calories, macros and water from the profile.
class TargetsCard extends StatelessWidget {
  final UserProfile profile;
  final String? title;
  const TargetsCard({super.key, required this.profile, this.title});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = profile;
    Widget tile(String label, String value, Color color, {IconData? icon}) => Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withValues(alpha: 0.35)),
            ),
            child: Column(children: [
              if (icon != null) Icon(icon, color: color, size: 20),
              Text(value,
                  style: context.text.titleMedium?.copyWith(fontWeight: FontWeight.w800, color: color),
                  maxLines: 1),
              Text(label, style: context.text.labelSmall?.copyWith(color: AppColors.textMuted), maxLines: 1),
            ]),
          ),
        );
    final cal = p.calorieTarget;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title ?? l.onbDailyTargets, style: context.text.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(cal == null ? '—' : '$cal',
                        style: context.text.displaySmall
                            ?.copyWith(fontWeight: FontWeight.w900, color: AppColors.primary)),
                  ),
                ),
                const SizedBox(width: 6),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(l.kcal, style: context.text.titleMedium?.copyWith(color: AppColors.textMuted)),
                ),
                const Spacer(),
                if (p.tdee != null)
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text(l.onbTdee, style: context.text.labelSmall?.copyWith(color: AppColors.textMuted)),
                    Text('${p.tdee!.round()} ${l.kcal}', style: const TextStyle(fontWeight: FontWeight.w700)),
                  ]),
              ],
            ),
            const SizedBox(height: 12),
            Row(children: [
              tile(l.protein, '${p.proteinG ?? '—'} ${l.gramsShort}', AppColors.protein),
              const SizedBox(width: 8),
              tile(l.carbs, '${p.carbsG ?? '—'} ${l.gramsShort}', AppColors.carbs),
              const SizedBox(width: 8),
              tile(l.fat, '${p.fatG ?? '—'} ${l.gramsShort}', AppColors.fat),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              tile(l.water, '${p.waterGoalMl ?? '—'} ${l.mlShort}', AppColors.water, icon: Symbols.water_drop_rounded),
              const SizedBox(width: 8),
              tile(l.onbTrainingDayCarbs, '${p.trainingDayCarbsG ?? '—'} ${l.gramsShort}', AppColors.primary,
                  icon: Symbols.fitness_center_rounded),
              const SizedBox(width: 8),
              tile(l.onbRestDayCarbs, '${p.restDayCarbsG ?? '—'} ${l.gramsShort}', AppColors.rest,
                  icon: Symbols.weekend_rounded),
            ]),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// "Build my plan" progress screen
// ---------------------------------------------------------------------------

enum _JobState { waiting, running, done, template, failed }

/// Shown after the summary: targets are already computed locally. With a key
/// and internet the workout + meal plans are generated with AI; otherwise (or
/// when AI fails) local template plans are built so every user leaves
/// onboarding with a plan. The workout plan is then reviewed/approved.
/// [onFinished] is called once when the user is done (the onboarding host
/// marks onboarding complete there).
class PlanBuildScreen extends ConsumerStatefulWidget {
  final VoidCallback onFinished;
  const PlanBuildScreen({super.key, required this.onFinished});

  @override
  ConsumerState<PlanBuildScreen> createState() => _PlanBuildScreenState();
}

class _PlanBuildScreenState extends ConsumerState<PlanBuildScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat(reverse: true);
  AiAvailability? _ai;
  var _workout = _JobState.waiting;
  var _meals = _JobState.waiting;
  int? _planId;
  String? _workoutErr;
  String? _mealErr;
  bool _finished = false;
  bool _reviewOpened = false;

  bool get _running => _workout == _JobState.running || _meals == _JobState.running;
  bool get _aiOk => _ai == AiAvailability.ok;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    final ai = await checkAiAvailability(ref);
    if (!mounted) return;
    setState(() => _ai = ai);
    await Future.wait([_runWorkout(), _runMeals()]);
    if (!mounted) return;
    _pulse.stop();
    // Everything generated with AI → go straight to the review.
    if (_planId != null && _workout == _JobState.done && _meals == _JobState.done && !_reviewOpened) {
      await Future<void>.delayed(const Duration(milliseconds: 700));
      if (mounted && !_reviewOpened) _openReview();
    }
  }

  /// AI plan when possible, else the local template (ensureNoKeyFallback).
  Future<void> _runWorkout() async {
    setState(() {
      _workout = _JobState.running;
      _workoutErr = null;
    });
    final gen = ref.read(workoutPlanGeneratorProvider);
    int? id;
    Object? err;
    var usedAi = false;
    if (_aiOk) {
      final r = await runPlanGenerators(workout: gen);
      id = r.planId;
      err = r.workoutError;
      usedAi = id != null;
    }
    if (id == null) {
      try {
        id = await gen.ensureNoKeyFallback();
      } catch (e, st) {
        debugPrint('template workout plan failed: $e\n$st');
        err ??= e;
      }
    }
    if (!mounted) return;
    setState(() {
      if (id != null) _planId = id;
      _workout = id == null ? _JobState.failed : (usedAi ? _JobState.done : _JobState.template);
      _workoutErr = err == null ? null : planErrorText(context, err);
    });
  }

  /// AI meal plan when possible, else the local template plan.
  Future<void> _runMeals() async {
    setState(() {
      _meals = _JobState.running;
      _mealErr = null;
    });
    final gen = ref.read(mealPlanGeneratorProvider);
    Object? err;
    var state = _JobState.failed;
    if (_aiOk) {
      final r = await runPlanGenerators(meals: gen);
      err = r.mealError;
      if (r.mealOk) state = _JobState.done;
    }
    if (state != _JobState.done) {
      try {
        await gen.buildTemplateAndSave();
        state = _JobState.template;
      } catch (e, st) {
        debugPrint('template meal plan failed: $e\n$st');
        err ??= e;
      }
    }
    if (!mounted) return;
    setState(() {
      _meals = state;
      _mealErr = err == null ? null : planErrorText(context, err);
    });
  }

  Future<void> _retry(Future<void> Function() job) async {
    _pulse.repeat(reverse: true);
    await job();
    if (mounted && !_running) _pulse.stop();
  }

  Future<void> _openReview() async {
    _reviewOpened = true;
    final id = _planId!;
    final db = ref.read(databaseProvider);
    await push<void>(context, PlanReviewScreen(planId: id, onApproved: _finish));
    // An already-active plan is closed with "Done" (no onApproved) → finish too.
    if (_finished || !mounted) return;
    final plan = await (db.select(db.workoutPlans)..where((t) => t.id.equals(id))).getSingleOrNull();
    if (plan?.isActive ?? false) _finish();
  }

  /// Deferred to the next frame so a review screen that pops itself right
  /// after calling onApproved finishes its own navigation first.
  void _finish() {
    if (_finished) return;
    _finished = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => widget.onFinished());
  }

  String? _note(String? err, String later) {
    if (err == null) return null;
    return '$err\n$later';
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final profile = ref.watch(profileProvider).value;
    final title = _running || _ai == null ? l.onbBuildingTitle : l.onbBuildReadyTitle;
    return PopScope(
      canPop: !_running,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                  children: [
                    Center(
                      child: ScaleTransition(
                        scale: Tween(begin: 0.92, end: 1.08)
                            .animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut)),
                        child: Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary.withValues(alpha: 0.12),
                            boxShadow: [
                              BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 40),
                            ],
                          ),
                          child: const Icon(Symbols.auto_awesome_rounded, color: AppColors.primary, size: 48),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        title,
                        key: ValueKey(title),
                        textAlign: TextAlign.center,
                        style: context.text.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ),
                    if (_running) ...[
                      const SizedBox(height: 8),
                      Text(l.onbBuildHint,
                          textAlign: TextAlign.center,
                          style: context.text.bodyMedium?.copyWith(color: AppColors.textMuted)),
                    ],
                    const SizedBox(height: 20),
                    _TaskRow(icon: Symbols.calculate_rounded, label: l.onbBuildTargets, state: _JobState.done),
                    _TaskRow(
                      icon: Symbols.fitness_center_rounded,
                      label: l.onbBuildWorkout,
                      state: _workout,
                      note: _note(_workoutErr, l.onbBuildWorkoutLater),
                      onRetry: _aiOk && !_reviewOpened ? () => _retry(_runWorkout) : null,
                    ),
                    _TaskRow(
                      icon: Symbols.restaurant_rounded,
                      label: l.onbBuildMeals,
                      state: _meals,
                      note: _note(_mealErr, l.onbBuildMealsLater),
                      onRetry: _aiOk ? () => _retry(_runMeals) : null,
                    ),
                    if (_ai == AiAvailability.noKey)
                      InfoNote(l.onbBuildNoKey, icon: Symbols.key_off_rounded, color: AppColors.warning),
                    if (_ai == AiAvailability.offline)
                      InfoNote(l.onbBuildOffline, icon: Symbols.wifi_off_rounded, color: AppColors.warning),
                    const SizedBox(height: 12),
                    if (profile != null) TargetsCard(profile: profile),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _ai == null || _running
                      ? const SizedBox(height: 52, key: ValueKey('busy'))
                      : Column(
                          key: const ValueKey('actions'),
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (_planId != null)
                              FilledButton.icon(
                                onPressed: _openReview,
                                icon: const Icon(Symbols.checklist_rounded),
                                label: Text(l.onbReviewPlan),
                              )
                            else
                              FilledButton.icon(
                                onPressed: _finish,
                                icon: const Icon(Symbols.rocket_launch_rounded),
                                label: Text(l.onbStartApp),
                              ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final _JobState state;
  final String? note;
  final VoidCallback? onRetry;
  const _TaskRow({required this.icon, required this.label, required this.state, this.note, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final (status, color) = switch (state) {
      _JobState.waiting => (l.onbStatusWaiting, AppColors.textMuted),
      _JobState.running => (l.onbStatusWorking, AppColors.info),
      _JobState.done => (l.onbStatusDone, AppColors.primary),
      _JobState.template => (l.onbStatusTemplate, AppColors.primary),
      _JobState.failed => (l.onbStatusFailed, AppColors.warning),
    };
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(children: [
              Icon(icon, color: color),
              const SizedBox(width: 12),
              Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16))),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: switch (state) {
                  _JobState.running => const SizedBox(
                      key: ValueKey('r'), width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5)),
                  _JobState.done => const Icon(Symbols.check_circle_rounded, fill: 1, key: ValueKey('d'), color: AppColors.primary),
                  _JobState.template =>
                    const Icon(Symbols.inventory_2_rounded, key: ValueKey('t'), color: AppColors.primary),
                  _JobState.failed =>
                    const Icon(Symbols.error_rounded, key: ValueKey('f'), color: AppColors.warning),
                  _JobState.waiting =>
                    const Icon(Symbols.hourglass_empty_rounded, key: ValueKey('w'), color: AppColors.textMuted),
                },
              ),
            ]),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 36, top: 2),
              child: Text(status, style: TextStyle(color: color, fontSize: 13)),
            ),
            if ((state == _JobState.failed || state == _JobState.template) && note != null) ...[
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 36, top: 6),
                child: Text(note!, style: context.text.bodySmall),
              ),
              if (onRetry != null)
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton.icon(onPressed: onRetry, icon: const Icon(Symbols.refresh_rounded), label: Text(l.retry)),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
