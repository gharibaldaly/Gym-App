import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../ai/ai_queue.dart';
import '../../../ai/ai_service.dart';
import '../../../core/navigation.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/context_ext.dart';
import '../../../core/widgets/common.dart';
import '../logging/food_review_screen.dart';
import '../logging/log_actions.dart';
import '../nutrition_logic.dart';
import '../nutrition_providers.dart';
import 'nut_widgets.dart';

/// Sub-tab (a): today's calories ring, macros, planned vs eaten meals, logs, supplements.
class NutritionTodayView extends ConsumerWidget {
  final VoidCallback onOpenPlan;
  const NutritionTodayView({super.key, required this.onOpenPlan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final day = ref.watch(todayNutritionProvider);
    final logs = ref.watch(todayMealLogsProvider).value ?? const <MealLog>[];
    final planned = ref.watch(todayPlannedMealsProvider).value ?? const <PlannedMeal>[];
    final sups = ref.watch(todaySupplementsTakenProvider).value ?? const <TakenSupplement>[];
    final pending = logs.where((x) => x.status == 'pending_ai').toList();

    return day.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('${l.errorGeneric}: $e')),
      data: (d) => ListView(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 96),
        children: [
          _SummaryCard(d: d),
          if (pending.isNotEmpty) _PendingCard(count: pending.length),
          _MealsCard(planned: planned, logs: logs, onOpenPlan: onOpenPlan),
          _LoggedCard(logs: logs),
          _SupplementsCard(sups: sups),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final DayNutrition d;
  const _SummaryCard({required this.d});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final over = d.remainingCalories < 0;
    return SectionCard(
      title: l.nutTodayTitle,
      trailing: Chip(
        visualDensity: VisualDensity.compact,
        avatar: Icon(d.isTrainingDay ? Icons.fitness_center : Icons.self_improvement, size: 16),
        label: Text(d.isTrainingDay ? l.nutTrainingDay : l.nutRestDay),
      ),
      child: !d.hasTargets
          ? Text(l.nutNoTargets, style: const TextStyle(color: AppColors.textMuted))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    ProgressRing(
                      value: d.calories,
                      max: d.targetCalories,
                      size: 130,
                      stroke: 12,
                      color: over ? AppColors.danger : AppColors.primary,
                      center: Column(mainAxisSize: MainAxisSize.min, children: [
                        Text(fmtNum(d.calories.roundToDouble()),
                            style: context.text.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                        Text('/ ${fmtNum(d.targetCalories.roundToDouble())} ${l.kcal}',
                            style: context.text.bodySmall?.copyWith(color: AppColors.textMuted)),
                      ]),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fmtNum(d.remainingCalories.abs().roundToDouble()),
                            style: context.text.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: over ? AppColors.danger : AppColors.primary,
                            ),
                          ),
                          Text(over ? l.nutKcalOver : l.nutKcalLeft),
                          const SizedBox(height: 8),
                          Text(
                            l.nutRemainingMacros(
                              fmtNum(d.remainingProtein.clamp(0, double.infinity).roundToDouble()),
                              fmtNum(d.remainingCarbs.clamp(0, double.infinity).roundToDouble()),
                              fmtNum(d.remainingFat.clamp(0, double.infinity).roundToDouble()),
                            ),
                            style: context.text.bodySmall?.copyWith(color: AppColors.textMuted),
                          ),
                          if (d.supplementCalories > 0 || d.supplementProtein > 0)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                l.nutFromSupplements(fmtNum(d.supplementProtein.roundToDouble()),
                                    fmtNum(d.supplementCalories.roundToDouble())),
                                style: context.text.bodySmall?.copyWith(color: AppColors.textMuted),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                MacroBar(label: l.protein, value: d.protein, target: d.targetProtein, color: AppColors.protein, unit: l.gramsShort),
                MacroBar(label: l.carbs, value: d.carbs, target: d.targetCarbs, color: AppColors.carbs, unit: l.gramsShort),
                MacroBar(label: l.fat, value: d.fat, target: d.targetFat, color: AppColors.fat, unit: l.gramsShort),
              ],
            ),
    );
  }
}

class _PendingCard extends ConsumerWidget {
  final int count;
  const _PendingCard({required this.count});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final hasKey = ref.watch(hasApiKeyProvider);
    final online = ref.watch(isOnlineProvider);
    return Card(
      color: AppColors.cardHigh,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(children: [
          const Icon(Icons.hourglass_top, color: AppColors.warning),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l.nutPendingCount(count), style: const TextStyle(fontWeight: FontWeight.w700)),
              Text(
                !hasKey ? l.nutPendingNoKey : (!online ? l.nutPendingOffline : l.nutPendingWorking),
                style: context.text.bodySmall,
              ),
            ]),
          ),
          if (!hasKey)
            TextButton(onPressed: () => openSettings(context), child: Text(l.addApiKey))
          else if (online)
            TextButton(onPressed: () => ref.read(aiQueueProvider).process(), child: Text(l.retry)),
        ]),
      ),
    );
  }
}

class _MealsCard extends ConsumerWidget {
  final List<PlannedMeal> planned;
  final List<MealLog> logs;
  final VoidCallback onOpenPlan;
  const _MealsCard({required this.planned, required this.logs, required this.onOpenPlan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final lang = context.lang;
    if (planned.isEmpty) {
      return SectionCard(
        title: l.nutMealsTitle,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(l.nutNoPlanToday, style: const TextStyle(color: AppColors.textMuted)),
          const SizedBox(height: 8),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: OutlinedButton.icon(onPressed: onOpenPlan, icon: const Icon(Icons.restaurant_menu), label: Text(l.nutOpenPlan)),
          ),
        ]),
      );
    }
    return SectionCard(
      title: l.nutMealsTitle,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        children: [
          for (final m in planned) ...[
            _PlannedMealTile(
              meal: m,
              eaten: logs.where((x) => x.mealIndex == m.mealIndex).toList(),
              lang: lang,
            ),
            if (m != planned.last) const Divider(height: 1),
          ],
        ],
      ),
    );
  }
}

class _PlannedMealTile extends ConsumerWidget {
  final PlannedMeal meal;
  final List<MealLog> eaten;
  final String lang;
  const _PlannedMealTile({required this.meal, required this.eaten, required this.lang});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final done = eaten.where((x) => x.status == 'done').toList();
    final eatenMacros = done.fold(const FoodMacros(), (a, x) => a + FoodMacros(calories: x.calories, protein: x.protein, carbs: x.carbs, fat: x.fat));
    final hasPending = eaten.any((x) => x.status == 'pending_ai');
    final isDone = done.isNotEmpty;
    return InkWell(
      onTap: () => _openMealSheet(context, ref),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isDone ? Icons.check_circle : (hasPending ? Icons.hourglass_top : Icons.radio_button_unchecked),
              color: isDone ? AppColors.primary : (hasPending ? AppColors.warning : AppColors.textMuted),
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(
                      child: Text(pickBilingual(meal.name, lang),
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    ),
                    if (meal.time != null)
                      Text(meal.time!, style: context.text.bodySmall?.copyWith(color: AppColors.textMuted)),
                  ]),
                  const SizedBox(height: 2),
                  Text(
                    l.nutPlannedLine(macroLine(context, FoodMacros(calories: meal.calories, protein: meal.protein, carbs: meal.carbs, fat: meal.fat))),
                    style: context.text.bodySmall?.copyWith(color: AppColors.textMuted),
                  ),
                  if (isDone)
                    Text(l.nutEatenLine(macroLine(context, eatenMacros)),
                        style: context.text.bodySmall?.copyWith(color: AppColors.primary)),
                  if (done.isNotEmpty)
                    Wrap(spacing: 6, children: [
                      for (final x in done)
                        ActionChip(
                          visualDensity: VisualDensity.compact,
                          avatar: Icon(sourceIcon(x.source), size: 16),
                          label: Text(pickBilingual(x.name, lang), overflow: TextOverflow.ellipsis),
                          onPressed: () => _editLog(context, x),
                        ),
                    ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editLog(BuildContext context, MealLog log) async {
    final saved = await push<bool>(context, FoodReviewScreen.edit(log, context.lang));
    if (saved == true && context.mounted) context.snack(context.l10n.nutSaved);
  }

  Future<void> _openMealSheet(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    final items = decodeItems(meal.itemsJson);
    final action = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (c) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(pickBilingual(meal.name, lang), style: c.text.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              if (meal.time != null) Text(meal.time!, style: const TextStyle(color: AppColors.textMuted)),
              const SizedBox(height: 8),
              for (final it in items)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(children: [
                    Expanded(child: Text(it.name(lang))),
                    Text('${fmtNum(it.grams.roundToDouble())} ${l.gramsShort}',
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                  ]),
                ),
              const SizedBox(height: 8),
              MacroSummaryRow(macros: FoodMacros(calories: meal.calories, protein: meal.protein, carbs: meal.carbs, fat: meal.fat)),
              const SizedBox(height: 16),
              FilledButton.icon(
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
                onPressed: () => Navigator.pop(c, 'planned'),
                icon: const Icon(Icons.check),
                label: Text(l.nutAteAsPlanned),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                onPressed: () => Navigator.pop(c, 'half'),
                icon: const Icon(Icons.contrast),
                label: Text(l.nutAteHalf),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                onPressed: () => Navigator.pop(c, 'different'),
                icon: const Icon(Icons.swap_horiz),
                label: Text(l.nutAteDifferent),
              ),
            ],
          ),
        ),
      ),
    );
    if (action == null || !context.mounted) return;
    switch (action) {
      case 'planned':
        await logPlannedMealOneTap(context, ref, meal);
      case 'half':
        await logPlannedMealOneTap(context, ref, meal, portion: 0.5);
      case 'different':
        await showLogFoodSheet(context, ref, mealIndex: meal.mealIndex);
    }
  }
}

class _LoggedCard extends ConsumerWidget {
  final List<MealLog> logs;
  const _LoggedCard({required this.logs});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return SectionCard(
      title: l.nutLoggedTitle,
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
      child: logs.isEmpty
          ? Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(l.nutNothingLogged, style: const TextStyle(color: AppColors.textMuted)),
            )
          : Column(children: [for (final x in logs) MealLogTile(log: x)]),
    );
  }
}

/// One logged meal with edit / save-to-my-foods / delete.
class MealLogTile extends ConsumerWidget {
  final MealLog log;
  const MealLogTile({super.key, required this.log});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final lang = context.lang;
    final pending = log.status == 'pending_ai';
    final repo = ref.read(nutritionRepositoryProvider);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: log.photoPath != null
          ? MealPhotoThumb(path: log.photoPath!)
          : CircleAvatar(backgroundColor: AppColors.cardHigh, child: Icon(sourceIcon(log.source), color: AppColors.primary)),
      title: Text(pickBilingual(log.name, lang), maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: pending
          ? Row(children: [
              const Icon(Icons.hourglass_top, size: 14, color: AppColors.warning),
              const SizedBox(width: 4),
              Expanded(child: Text(l.nutWaitingForAi, style: const TextStyle(color: AppColors.warning))),
            ])
          : Text(
              [
                macroLine(context, FoodMacros(calories: log.calories, protein: log.protein, carbs: log.carbs, fat: log.fat)),
                if (log.confidence != null && log.source.startsWith('ai_')) l.nutConfidence((log.confidence! * 100).round()),
              ].join('  ·  '),
            ),
      onTap: () => _edit(context),
      trailing: PopupMenuButton<String>(
        onSelected: (v) async {
          switch (v) {
            case 'edit':
              await _edit(context);
            case 'save':
              await repo.saveMyFood(pickBilingual(log.name, lang), decodeItems(log.itemsJson));
              if (context.mounted) context.snack(l.nutSavedToMyFoods);
            case 'analyze':
              await ref.read(aiQueueProvider).process();
            case 'delete':
              final deleted = await repo.deleteLog(log.id, deletePhoto: false);
              if (!context.mounted || deleted == null) return;
              final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();
              final bar = messenger.showSnackBar(SnackBar(
                content: Text(l.nutDeleted),
                action: SnackBarAction(label: l.nutUndo, onPressed: () => repo.restoreLog(deleted)),
              ));
              final photo = deleted.photoPath;
              if (photo != null) {
                bar.closed.then((r) {
                  if (r != SnackBarClosedReason.action) NutritionRepository.deletePhotoFile(photo);
                });
              }
          }
        },
        itemBuilder: (_) => [
          PopupMenuItem(value: 'edit', child: Text(l.edit)),
          if (pending) PopupMenuItem(value: 'analyze', child: Text(l.nutAnalyzeNow)),
          if (!pending) PopupMenuItem(value: 'save', child: Text(l.nutSaveToMyFoods)),
          PopupMenuItem(value: 'delete', child: Text(l.delete)),
        ],
      ),
    );
  }

  Future<void> _edit(BuildContext context) async {
    final saved = await push<bool>(context, FoodReviewScreen.edit(log, context.lang));
    if (saved == true && context.mounted) context.snack(context.l10n.nutSaved);
  }
}

class _SupplementsCard extends StatelessWidget {
  final List<TakenSupplement> sups;
  const _SupplementsCard({required this.sups});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return SectionCard(
      title: l.nutSupplementsTitle,
      child: sups.isEmpty
          ? Text(l.nutNoSupplementsToday, style: const TextStyle(color: AppColors.textMuted))
          : Column(
              children: [
                for (final s in sups)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(children: [
                      const Icon(Icons.medication, color: AppColors.primary, size: 20),
                      const SizedBox(width: 8),
                      Expanded(child: Text(s.count > 1 ? '${s.supplement.name} ×${s.count}' : s.supplement.name)),
                      Text(
                        s.macros.calories > 0 || s.macros.protein > 0
                            ? l.nutSupplementMacros(fmtNum(s.macros.protein.roundToDouble()), fmtNum(s.macros.calories.roundToDouble()))
                            : l.nutNoMacros,
                        style: context.text.bodySmall?.copyWith(color: AppColors.textMuted),
                      ),
                    ]),
                  ),
              ],
            ),
    );
  }
}
