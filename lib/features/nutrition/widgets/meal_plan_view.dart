import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../ai/ai_service.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/context_ext.dart';
import '../../../core/widgets/common.dart';
import '../../../data/repositories/profile_repository.dart';
import '../food_ai.dart';
import '../meal_plan_generator.dart';
import '../nutrition_logic.dart';
import '../nutrition_providers.dart';
import 'nut_widgets.dart';

/// Whether the plan view shows the training-day (true) or rest-day meals; null = today's type.
final _showTrainingProvider = NotifierProvider<_DayTypeNotifier, bool?>(_DayTypeNotifier.new);

class _DayTypeNotifier extends Notifier<bool?> {
  @override
  bool? build() => null;
  void set(bool v) => state = v;
}

/// Sub-tab (b): the active meal plan with training/rest toggle, swaps and regenerate.
class MealPlanView extends ConsumerWidget {
  const MealPlanView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final plan = ref.watch(activeMealPlanProvider);
    return plan.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('${l.errorGeneric}: $e')),
      data: (p) => p == null ? const _NoPlan() : _PlanBody(plan: p),
    );
  }
}

Future<void> generateMealPlan(BuildContext context, WidgetRef ref, {bool offlineTemplate = false}) async {
  final l = context.l10n;
  final gen = ref.read(mealPlanGeneratorProvider);
  try {
    if (offlineTemplate) {
      await runWithProgress(context, l.nutBuildingPlan, gen.buildTemplateAndSave);
      if (context.mounted) context.snack(l.nutBasicPlanReady);
      return;
    }
    final res = await runWithProgress(context, l.nutGeneratingPlan, () => gen.generate());
    if (!context.mounted) return;
    context.snack(res.usedAi ? l.nutPlanReady : l.nutPlanFallback);
  } catch (e) {
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l.nutPlanFailed),
        content: Text(aiErrorText(e, ar: context.isAr)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: Text(l.close)),
          FilledButton(
            onPressed: () {
              Navigator.pop(c);
              generateMealPlan(context, ref, offlineTemplate: true);
            },
            child: Text(l.nutUseBasicPlan),
          ),
        ],
      ),
    );
  }
}

class _NoPlan extends ConsumerWidget {
  const _NoPlan();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final hasKey = ref.watch(hasApiKeyProvider);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const AiUnavailableBanner(),
        EmptyState(
          icon: Icons.restaurant_menu,
          text: l.nutNoPlan,
          action: Column(children: [
            if (hasKey)
              FilledButton.icon(
                onPressed: () => generateMealPlan(context, ref),
                icon: const Icon(Icons.auto_awesome),
                label: Text(l.nutGeneratePlan),
              ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => generateMealPlan(context, ref, offlineTemplate: true),
              icon: const Icon(Icons.list_alt),
              label: Text(l.nutUseBasicPlan),
            ),
          ]),
        ),
      ],
    );
  }
}

class _PlanBody extends ConsumerWidget {
  final MealPlan plan;
  const _PlanBody({required this.plan});

  bool get _isTemplate {
    try {
      return (jsonDecode(plan.rawJson ?? '{}') as Map)['source'] == 'template';
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final lang = context.lang;
    final profile = ref.watch(profileProvider).value;
    final training = ref.watch(_showTrainingProvider) ?? (profile?.isTrainingDay(DateTime.now()) ?? true);
    final all = ref.watch(activePlannedMealsProvider).value ?? const <PlannedMeal>[];
    final meals = mealsForDayType(all, training: training);
    final totals = meals.fold(
        const FoodMacros(), (a, m) => a + FoodMacros(calories: m.calories, protein: m.protein, carbs: m.carbs, fat: m.fat));
    final target = targetsForDayType(profile, training: training);

    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 96),
      children: [
        SectionCard(
          title: pickBilingual(plan.name, lang),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (plan.notes != null && plan.notes!.isNotEmpty)
                Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(plan.notes!)),
              if (_isTemplate)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(l.nutTemplatePlanNote, style: context.text.bodySmall?.copyWith(color: AppColors.textMuted)),
                ),
              SegmentedButton<bool>(
                segments: [
                  ButtonSegment(value: true, icon: const Icon(Icons.fitness_center), label: Text(l.nutTrainingDay)),
                  ButtonSegment(value: false, icon: const Icon(Icons.self_improvement), label: Text(l.nutRestDay)),
                ],
                selected: {training},
                onSelectionChanged: (s) => ref.read(_showTrainingProvider.notifier).set(s.first),
              ),
              const SizedBox(height: 12),
              Text(l.nutDayTotal, style: context.text.labelLarge),
              const SizedBox(height: 4),
              MacroSummaryRow(macros: totals),
              if (target != null) ...[
                const SizedBox(height: 4),
                Text(
                  l.nutTargetLine(macroLine(
                      context, FoodMacros(calories: target.calories, protein: target.protein, carbs: target.carbs, fat: target.fat))),
                  style: context.text.bodySmall?.copyWith(color: AppColors.textMuted),
                ),
              ],
            ],
          ),
        ),
        if (meals.isEmpty)
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(l.nutNoMealsForDay, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textMuted)),
          ),
        for (final m in meals) _PlannedMealCard(meal: m),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
          onPressed: () async {
            if (await confirmDialog(context, title: l.nutRegenerateTitle, body: l.nutRegenerateBody, confirm: l.nutRegenerate) &&
                context.mounted) {
              await generateMealPlan(context, ref);
            }
          },
          icon: const Icon(Icons.refresh),
          label: Text(l.nutRegenerate),
        ),
      ],
    );
  }
}

class _PlannedMealCard extends ConsumerWidget {
  final PlannedMeal meal;
  const _PlannedMealCard({required this.meal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final lang = context.lang;
    final items = decodeItems(meal.itemsJson);
    return SectionCard(
      title: pickBilingual(meal.name, lang),
      trailing: meal.time == null
          ? null
          : Text(meal.time!, style: context.text.bodyMedium?.copyWith(color: AppColors.textMuted)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final it in items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(it.name(lang), style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text(
                        l.nutItemMacros(fmtNum(it.calories.roundToDouble()), fmtNum(it.protein.roundToDouble()),
                            fmtNum(it.carbs.roundToDouble()), fmtNum(it.fat.roundToDouble())),
                        style: context.text.bodySmall?.copyWith(color: AppColors.textMuted),
                      ),
                    ]),
                  ),
                  Text('${fmtNum(it.grams.roundToDouble())} ${l.gramsShort}',
                      style: const TextStyle(fontWeight: FontWeight.w800)),
                ],
              ),
            ),
          const Divider(),
          MacroSummaryRow(macros: FoodMacros(calories: meal.calories, protein: meal.protein, carbs: meal.carbs, fat: meal.fat)),
          const SizedBox(height: 8),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton.icon(
              onPressed: () => _showSwapSheet(context, meal),
              icon: const Icon(Icons.swap_horiz),
              label: Text(l.nutSwapMeal),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _showSwapSheet(BuildContext context, PlannedMeal meal) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _SwapSheet(meal: meal),
  );
}

class _SwapSheet extends ConsumerStatefulWidget {
  final PlannedMeal meal;
  const _SwapSheet({required this.meal});
  @override
  ConsumerState<_SwapSheet> createState() => _SwapSheetState();
}

class _SwapSheetState extends ConsumerState<_SwapSheet> {
  Future<List<MealAlternative>>? _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    final hasKey = ref.read(hasApiKeyProvider);
    final online = ref.read(isOnlineProvider);
    _future = hasKey && online ? ref.read(foodAiProvider).swapMeal(widget.meal) : null;
  }

  Future<void> _use(MealAlternative a) async {
    final l = context.l10n;
    await ref
        .read(nutritionRepositoryProvider)
        .replacePlannedMeal(widget.meal.id, nameAr: a.nameAr, nameEn: a.nameEn, items: a.items);
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    Navigator.pop(context);
    messenger.showSnackBar(SnackBar(content: Text(l.nutMealSwapped)));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lang = context.lang;
    final original = FoodMacros(
        calories: widget.meal.calories, protein: widget.meal.protein, carbs: widget.meal.carbs, fat: widget.meal.fat);
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      maxChildSize: 0.95,
      builder: (context, controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          Text(l.nutSwapTitle(pickBilingual(widget.meal.name, lang)),
              style: context.text.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(l.nutSwapSubtitle(macroLine(context, original)), style: const TextStyle(color: AppColors.textMuted)),
          const SizedBox(height: 12),
          if (_future == null)
            const AiUnavailableBanner()
          else
            FutureBuilder<List<MealAlternative>>(
              future: _future,
              builder: (context, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 12),
                      Text(l.nutFindingAlternatives),
                    ]),
                  );
                }
                if (snap.hasError) {
                  return Column(children: [
                    Text(aiErrorText(snap.error!, ar: context.isAr), style: const TextStyle(color: AppColors.danger)),
                    const SizedBox(height: 8),
                    OutlinedButton(onPressed: () => setState(_load), child: Text(l.retry)),
                  ]);
                }
                final alts = snap.data ?? const [];
                if (alts.isEmpty) return Text(l.nutNoAlternatives);
                return Column(children: [
                  for (final a in alts)
                    Card(
                      color: AppColors.cardHigh,
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(lang == 'ar' ? a.nameAr : a.nameEn,
                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                            if (a.notes.isNotEmpty)
                              Text(a.notes, style: context.text.bodySmall?.copyWith(color: AppColors.textMuted)),
                            const SizedBox(height: 6),
                            for (final it in a.items)
                              Row(children: [
                                Expanded(child: Text(it.name(lang))),
                                Text('${fmtNum(it.grams.roundToDouble())} ${l.gramsShort}'),
                              ]),
                            const SizedBox(height: 6),
                            MacroSummaryRow(macros: a.totals, dense: true),
                            const SizedBox(height: 8),
                            FilledButton(onPressed: () => _use(a), child: Text(l.nutUseThis)),
                          ],
                        ),
                      ),
                    ),
                  TextButton.icon(
                    onPressed: () => setState(_load),
                    icon: const Icon(Icons.refresh),
                    label: Text(l.nutMoreAlternatives),
                  ),
                ]);
              },
            ),
        ],
      ),
    );
  }
}
