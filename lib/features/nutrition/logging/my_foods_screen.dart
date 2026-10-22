import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/context_ext.dart';
import '../../../core/widgets/common.dart';
import '../egyptian_foods.dart';
import '../nutrition_providers.dart';
import '../widgets/nut_widgets.dart';

/// "أكلاتي": saved meals, most used first; one tap logs them (no AI, offline).
class MyFoodsScreen extends ConsumerStatefulWidget {
  final int? mealIndex;
  const MyFoodsScreen({super.key, this.mealIndex});

  @override
  ConsumerState<MyFoodsScreen> createState() => _MyFoodsScreenState();
}

class _MyFoodsScreenState extends ConsumerState<MyFoodsScreen> {
  String _q = '';

  Future<void> _log(FoodItem f) async {
    final l = context.l10n;
    HapticFeedback.mediumImpact();
    final repo = ref.read(nutritionRepositoryProvider);
    final id = await repo.logMyFood(f, today(), mealIndex: widget.mealIndex);
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    Navigator.pop(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(l.nutLoggedMeal(f.name)),
        action: SnackBarAction(label: l.nutUndo, onPressed: () => repo.deleteLog(id)),
      ));
  }

  Future<void> _logPortion(FoodItem f) async {
    final l = context.l10n;
    final portion = await showModalBottomSheet<double>(
      context: context,
      builder: (c) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(title: Text(f.name, style: const TextStyle(fontWeight: FontWeight.w700))),
          for (final (p, label) in [(0.5, l.nutHalfPortion), (1.0, l.nutFullPortion), (1.5, l.nutOneAndHalfPortion), (2.0, l.nutDoublePortion)])
            ListTile(
              title: Text(label),
              subtitle: Text(macroLine(c, FoodMacros(calories: f.calories, protein: f.protein, carbs: f.carbs, fat: f.fat).scale(p))),
              onTap: () => Navigator.pop(c, p),
            ),
          ListTile(
            leading: Icon(Symbols.star_rounded, fill: f.isFavorite ? 1 : 0, color: AppColors.warning),
            title: Text(f.isFavorite ? l.nutUnfavorite : l.nutFavorite),
            onTap: () {
              ref.read(nutritionRepositoryProvider).setMyFoodFavorite(f.id, !f.isFavorite);
              Navigator.pop(c);
            },
          ),
          ListTile(
            leading: const Icon(Symbols.delete_rounded, color: AppColors.danger),
            title: Text(l.delete),
            onTap: () {
              ref.read(nutritionRepositoryProvider).deleteMyFood(f.id);
              Navigator.pop(c);
            },
          ),
        ]),
      ),
    );
    if (portion == null || !mounted) return;
    final repo = ref.read(nutritionRepositoryProvider);
    await repo.logMyFood(f, today(), mealIndex: widget.mealIndex, portion: portion);
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    Navigator.pop(context);
    messenger.showSnackBar(SnackBar(content: Text(l.nutLoggedMeal(f.name))));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final foods = ref.watch(myFoodsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.nutMyFoods)),
      body: foods.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('${l.errorGeneric}: $e')),
        data: (all) {
          if (all.isEmpty) return EmptyState(icon: Symbols.bookmark_rounded, text: l.nutMyFoodsEmpty);
          final q = normalizeFoodName(_q);
          final list = q.isEmpty ? all : all.where((f) => normalizeFoodName(f.name).contains(q)).toList();
          return Column(children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 4),
              child: TextField(
                decoration: InputDecoration(prefixIcon: const Icon(Symbols.search_rounded), hintText: l.search),
                onChanged: (v) => setState(() => _q = v),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 20, 4),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(l.nutMyFoodsTapHint, style: context.text.bodySmall?.copyWith(color: AppColors.textMuted)),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 24),
                itemCount: list.length,
                itemBuilder: (_, i) {
                  final f = list[i];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: ListTile(
                      minVerticalPadding: 12,
                      leading: Icon(f.isFavorite ? Symbols.star_rounded : Symbols.bookmark_rounded,
                          fill: 1,
                          color: f.isFavorite ? AppColors.warning : AppColors.primary),
                      title: Text(f.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          MacroSummaryRow(
                            dense: true,
                            macros: FoodMacros(calories: f.calories, protein: f.protein, carbs: f.carbs, fat: f.fat),
                          ),
                          if (f.useCount > 0)
                            Text(l.nutUsedTimes(f.useCount),
                                style: context.text.bodySmall?.copyWith(color: AppColors.textMuted)),
                        ],
                      ),
                      trailing: IconButton(
                        tooltip: l.nutMore,
                        icon: const Icon(Symbols.more_vert_rounded),
                        onPressed: () => _logPortion(f),
                      ),
                      onTap: () => _log(f),
                      onLongPress: () => _logPortion(f),
                    ),
                  );
                },
              ),
            ),
          ]);
        },
      ),
    );
  }
}
