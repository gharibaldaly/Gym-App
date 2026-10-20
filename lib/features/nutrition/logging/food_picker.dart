import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/context_ext.dart';
import '../egyptian_foods.dart';
import '../nutrition_logic.dart';
import '../widgets/nut_widgets.dart';

/// Bottom sheet: search the built-in Egyptian food table, then choose grams.
Future<FoodEntry?> pickBuiltInFood(BuildContext context) async {
  final f = await showModalBottomSheet<EgyptianFood>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => const _FoodSearchSheet(),
  );
  if (f == null || !context.mounted) return null;
  final grams = await askGrams(context, f);
  if (grams == null || grams <= 0) return null;
  return FoodEntry.fromFood(f, grams);
}

/// Grams dialog with natural-unit shortcuts (1 egg, 1 loaf…).
Future<double?> askGrams(BuildContext context, EgyptianFood f, {double? initial}) {
  return showDialog<double>(context: context, builder: (_) => _GramsDialog(food: f, initial: initial));
}

class _FoodSearchSheet extends StatefulWidget {
  const _FoodSearchSheet();
  @override
  State<_FoodSearchSheet> createState() => _FoodSearchSheetState();
}

class _FoodSearchSheetState extends State<_FoodSearchSheet> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final results = searchEgyptianFoods(_q);
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      builder: (context, controller) => Column(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 8),
            child: TextField(
              autofocus: true,
              decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: l.nutSearchFoods),
              onChanged: (v) => setState(() => _q = v),
            ),
          ),
          Expanded(
            child: results.isEmpty
                ? Center(child: Text(l.nutNoFoodsFound, style: const TextStyle(color: AppColors.textMuted)))
                : ListView.builder(
                    controller: controller,
                    itemCount: results.length,
                    itemBuilder: (_, i) {
                      final f = results[i];
                      return ListTile(
                        title: Text(f.name(context.lang)),
                        subtitle: Text(l.nutPer100g(macroLine(context, f.macrosFor(100)))),
                        trailing: const Icon(Icons.add_circle_outline, color: AppColors.primary),
                        onTap: () => Navigator.pop(context, f),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _GramsDialog extends StatefulWidget {
  final EgyptianFood food;
  final double? initial;
  const _GramsDialog({required this.food, this.initial});
  @override
  State<_GramsDialog> createState() => _GramsDialogState();
}

class _GramsDialogState extends State<_GramsDialog> {
  late final TextEditingController _c;

  @override
  void initState() {
    super.initState();
    final init = widget.initial ?? widget.food.unitGrams ?? 100;
    _c = TextEditingController(text: fmtNum(init));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  double get _grams => double.tryParse(_c.text.replaceAll(',', '.')) ?? 0;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final f = widget.food;
    final unit = f.unit(context.lang);
    return AlertDialog(
      title: Text(f.name(context.lang)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _c,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: l.nutGrams, suffixText: l.gramsShort),
            onChanged: (_) => setState(() {}),
          ),
          if (f.unitGrams != null && unit != null) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final n in [0.5, 1.0, 2.0, 3.0, 4.0])
                  ActionChip(
                    label: Text('${fmtNum(n)} $unit'),
                    onPressed: () => setState(() => _c.text = fmtNum(f.unitGrams! * n)),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          MacroSummaryRow(macros: f.macrosFor(_grams), dense: true),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
        FilledButton(
          onPressed: _grams > 0 ? () => Navigator.pop(context, _grams) : null,
          child: Text(l.add),
        ),
      ],
    );
  }
}
