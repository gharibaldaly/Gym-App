import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/context_ext.dart';
import '../../../core/widgets/common.dart';
import '../../../data/repositories/profile_repository.dart';
import '../egyptian_foods.dart';
import '../nutrition_logic.dart';
import '../nutrition_providers.dart';

/// Checked grocery keys, persisted per plan + week in shared prefs.
class _CheckedNotifier extends Notifier<Set<String>> {
  final String scope;
  _CheckedNotifier(this.scope);

  String get _key => 'nut_grocery_checked_$scope';

  @override
  Set<String> build() {
    try {
      return (ref.read(sharedPrefsProvider).getStringList(_key) ?? const []).toSet();
    } catch (_) {
      return {};
    }
  }

  void toggle(String k) {
    final s = {...state};
    if (!s.remove(k)) s.add(k);
    _set(s);
  }

  void clear() => _set({});

  void _set(Set<String> s) {
    state = s;
    try {
      ref.read(sharedPrefsProvider).setStringList(_key, s.toList());
    } catch (_) {}
  }
}

final _checkedProvider =
    NotifierProvider.family<_CheckedNotifier, Set<String>, String>((scope) => _CheckedNotifier(scope));

/// Sub-tab (c): weekly grocery list built locally from the plan.
class ShoppingListView extends ConsumerWidget {
  const ShoppingListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final lang = context.lang;
    final plan = ref.watch(activeMealPlanProvider).value;
    final all = ref.watch(activePlannedMealsProvider).value ?? const <PlannedMeal>[];
    final profile = ref.watch(profileProvider).value;
    if (plan == null || all.isEmpty) {
      return EmptyState(icon: Icons.shopping_cart_outlined, text: l.nutShoppingNoPlan);
    }
    final trainingDays = (profile?.trainingDays.isNotEmpty ?? false)
        ? profile!.trainingDays.toSet().length.clamp(0, 7)
        : (profile?.daysPerWeek ?? 0).clamp(0, 7);
    final restDays = 7 - trainingDays;
    List<FoodEntry> items(bool training) =>
        mealsForDayType(all, training: training).expand((m) => decodeItems(m.itemsJson)).toList();
    final lines = buildGroceryList(
      trainingDayItems: items(true),
      restDayItems: items(false),
      trainingDays: trainingDays,
      restDays: restDays,
    );
    final week = startOfWeek(DateTime.now());
    final scope = '${plan.id}_${ymd(week)}';
    final checked = ref.watch(_checkedProvider(scope));
    String qty(GroceryLine g) => formatGroceryQty(g, lang, gramUnit: l.gramsShort, kgUnit: l.kg, literUnit: l.nutLiter);

    final groups = <FoodCategory?, List<GroceryLine>>{};
    for (final g in lines) {
      groups.putIfAbsent(g.category, () => []).add(g);
    }

    String shareText() {
      final b = StringBuffer(l.nutShoppingShareTitle(ymd(week)))..writeln();
      for (final e in groups.entries) {
        b
          ..writeln()
          ..writeln('— ${_categoryLabel(context, e.key)} —');
        for (final g in e.value) {
          b.writeln('${checked.contains(g.key) ? '✓' : '•'} ${g.name(lang)}: ${qty(g)}');
        }
      }
      return b.toString();
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 96),
      children: [
        SectionCard(
          title: l.nutShoppingTitle,
          trailing: IconButton(
            tooltip: l.nutShare,
            icon: const Icon(Icons.share),
            onPressed: () => SharePlus.instance.share(ShareParams(text: shareText(), subject: l.nutShoppingTitle)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l.nutShoppingSubtitle(trainingDays, restDays),
                  style: context.text.bodySmall?.copyWith(color: AppColors.textMuted)),
              const SizedBox(height: 6),
              Row(children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: lines.isEmpty ? 0 : checked.where((k) => lines.any((g) => g.key == k)).length / lines.length,
                    minHeight: 6,
                    color: AppColors.primary,
                    backgroundColor: AppColors.cardHigh,
                  ),
                ),
                TextButton(
                  onPressed: checked.isEmpty ? null : () => ref.read(_checkedProvider(scope).notifier).clear(),
                  child: Text(l.nutUncheckAll),
                ),
              ]),
            ],
          ),
        ),
        for (final e in groups.entries)
          SectionCard(
            title: _categoryLabel(context, e.key),
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
            child: Column(children: [
              for (final g in e.value)
                CheckboxListTile(
                  value: checked.contains(g.key),
                  onChanged: (_) => ref.read(_checkedProvider(scope).notifier).toggle(g.key),
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(
                    g.name(lang),
                    style: TextStyle(
                      decoration: checked.contains(g.key) ? TextDecoration.lineThrough : null,
                      color: checked.contains(g.key) ? AppColors.textMuted : null,
                    ),
                  ),
                  secondary: Text(qty(g), style: const TextStyle(fontWeight: FontWeight.w800)),
                ),
            ]),
          ),
      ],
    );
  }
}

String _categoryLabel(BuildContext context, FoodCategory? c) {
  final l = context.l10n;
  return switch (c) {
    FoodCategory.protein => l.nutCatProtein,
    FoodCategory.carb => l.nutCatCarb,
    FoodCategory.dairy => l.nutCatDairy,
    FoodCategory.fat => l.nutCatFat,
    FoodCategory.fruit => l.nutCatFruit,
    FoodCategory.veg => l.nutCatVeg,
    FoodCategory.dish => l.nutCatDish,
    FoodCategory.supplement => l.nutCatSupplement,
    null => l.nutCatOther,
  };
}
