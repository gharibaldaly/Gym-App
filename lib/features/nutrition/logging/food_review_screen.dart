import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/common.dart';
import '../../../core/utils/context_ext.dart';
import '../nutrition_logic.dart';
import '../nutrition_providers.dart';
import '../widgets/nut_widgets.dart';
import 'food_picker.dart';

/// Review/edit the items of a meal before saving (AI results, manual, or an existing log).
class FoodReviewScreen extends ConsumerStatefulWidget {
  final List<FoodEntry> items;
  final String name;

  /// manual / ai_photo / ai_text / saved / plan
  final String source;
  final String? photoPath;
  final double? confidence;
  final String? notes;
  final int? mealIndex;
  final DateTime? day;

  /// When set, saving updates this log instead of creating a new one.
  final MealLog? editLog;

  /// Opens the built-in food picker right away (manual logging).
  final bool openPickerOnStart;

  const FoodReviewScreen({
    super.key,
    this.items = const [],
    this.name = '',
    this.source = 'manual',
    this.photoPath,
    this.confidence,
    this.notes,
    this.mealIndex,
    this.day,
    this.editLog,
    this.openPickerOnStart = false,
  });

  factory FoodReviewScreen.edit(MealLog log, String lang) => FoodReviewScreen(
        items: decodeItems(log.itemsJson),
        name: pickBilingual(log.name, lang),
        source: log.source,
        photoPath: log.photoPath,
        confidence: log.confidence,
        mealIndex: log.mealIndex,
        day: log.date,
        editLog: log,
      );

  @override
  ConsumerState<FoodReviewScreen> createState() => _FoodReviewScreenState();
}

const _noMeal = -1;

class _FoodReviewScreenState extends ConsumerState<FoodReviewScreen> {
  late List<FoodEntry> _items = [...widget.items];
  late final TextEditingController _name = TextEditingController(text: widget.name);
  late int _mealIndex = widget.mealIndex ?? _noMeal;
  late bool _saveToMyFoods = widget.source.startsWith('ai_') && widget.editLog == null;
  bool _saving = false;
  bool _mealGuessed = false;

  @override
  void initState() {
    super.initState();
    if (widget.openPickerOnStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _addFood());
    }
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  bool get _isAi => widget.source.startsWith('ai_');

  /// Picks the planned meal closest to now (±90 min) when none was given.
  void _guessMeal(List<PlannedMeal> meals) {
    if (_mealGuessed || widget.mealIndex != null || widget.editLog != null) return;
    _mealGuessed = true;
    final now = TimeOfDay.now();
    final nowMin = now.hour * 60 + now.minute;
    PlannedMeal? best;
    var bestDiff = 91;
    for (final m in meals) {
      final t = parseHm(m.time);
      if (t == null) continue;
      final d = (t.hour * 60 + t.minute - nowMin).abs();
      if (d < bestDiff) {
        best = m;
        bestDiff = d;
      }
    }
    if (best != null) _mealIndex = best.mealIndex;
  }

  Future<void> _addFood() async {
    final e = await pickBuiltInFood(context);
    if (e == null) return;
    setState(() {
      _items = [..._items, e];
      if (_name.text.trim().isEmpty) _name.text = e.name(context.lang);
    });
  }

  Future<void> _editName(int i) async {
    final l = context.l10n;
    final c = TextEditingController(text: _items[i].name(context.lang));
    final v = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.nutItemName),
        content: TextField(controller: c, autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, c.text.trim()), child: Text(l.save)),
        ],
      ),
    );
    c.dispose();
    if (v == null || v.isEmpty) return;
    setState(() {
      final it = _items[i];
      _items[i] = context.isAr ? it.copyWith(nameAr: v) : it.copyWith(nameEn: v);
    });
  }

  Future<void> _editGrams(int i) async {
    final l = context.l10n;
    final c = TextEditingController(text: fmtNum(_items[i].grams));
    final v = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(_items[i].name(context.lang)),
        content: TextField(
          controller: c,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: l.nutGrams, suffixText: l.gramsShort),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l.cancel)),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, double.tryParse(c.text.replaceAll(',', '.'))),
            child: Text(l.save),
          ),
        ],
      ),
    );
    c.dispose();
    if (v == null || v < 0) return;
    setState(() => _items[i] = _items[i].withGrams(v));
  }

  void _step(int i, double delta) {
    HapticFeedback.selectionClick();
    final g = _items[i].grams;
    final step = g >= 200 ? 25.0 : 10.0;
    setState(() => _items[i] = _items[i].withGrams(math.max(0, g + delta * step)));
  }

  Future<void> _save() async {
    final l = context.l10n;
    if (_items.isEmpty) {
      context.snack(l.nutAddAtLeastOne);
      return;
    }
    setState(() => _saving = true);
    final repo = ref.read(nutritionRepositoryProvider);
    final lang = context.lang;
    var name = _name.text.trim();
    if (name.isEmpty) name = _items.map((e) => e.name(lang)).take(3).join(' + ');
    final meal = _mealIndex == _noMeal ? null : _mealIndex;
    try {
      if (widget.editLog != null) {
        await repo.updateLog(
          widget.editLog!.id,
          name: name,
          items: _items,
          mealIndex: meal,
          clearMealIndex: meal == null,
          status: 'done',
        );
      } else {
        await repo.addLog(
          day: widget.day ?? today(),
          name: name,
          items: _items,
          source: widget.source,
          mealIndex: meal,
          photoPath: widget.photoPath,
          confidence: widget.confidence,
        );
      }
      if (_saveToMyFoods) await repo.saveMyFood(name, _items, countUse: widget.editLog == null);
      HapticFeedback.mediumImpact();
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        context.snack('${l.errorGeneric}: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lang = context.lang;
    final planned = ref.watch(todayPlannedMealsProvider).value ?? const <PlannedMeal>[];
    _guessMeal(planned);
    final totals = sumEntries(_items);
    final mealOptions = {for (final m in planned) m.mealIndex: pickBilingual(m.name, lang)};
    if (_mealIndex != _noMeal && !mealOptions.containsKey(_mealIndex)) {
      mealOptions[_mealIndex] = l.nutMealNumber(_mealIndex + 1);
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.editLog != null ? l.nutEditMeal : l.nutReviewTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
        children: [
          if (widget.photoPath != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Center(child: MealPhotoThumb(path: widget.photoPath!, size: 180)),
            ),
          if (_isAi && widget.confidence != null) _ConfidenceCard(confidence: widget.confidence!, notes: widget.notes),
          TextField(
            controller: _name,
            decoration: InputDecoration(labelText: l.nutMealName),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            key: ValueKey('meal-$_mealIndex-${mealOptions.length}'),
            initialValue: _mealIndex,
            isExpanded: true,
            decoration: InputDecoration(labelText: l.nutWhichMeal),
            items: [
              DropdownMenuItem(value: _noMeal, child: Text(l.nutOtherMeal, overflow: TextOverflow.ellipsis)),
              for (final e in mealOptions.entries)
                DropdownMenuItem(value: e.key, child: Text(e.value, overflow: TextOverflow.ellipsis)),
            ],
            onChanged: (v) => setState(() => _mealIndex = v ?? _noMeal),
          ),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: Text(l.nutItems, style: context.text.titleMedium?.copyWith(fontWeight: FontWeight.w700))),
            TextButton.icon(onPressed: _addFood, icon: const Icon(Icons.add), label: Text(l.nutAddFood)),
          ]),
          if (_items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(_isAi ? l.nutNoItemsDetected : l.nutNoItemsYet,
                  textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textMuted)),
            ),
          for (final (i, it) in _items.indexed)
            Card(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 4, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => _editName(i),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Text(it.name(lang),
                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: l.delete,
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => setState(() => _items = [..._items]..removeAt(i)),
                      ),
                    ]),
                    Row(children: [
                      IconButton.filledTonal(onPressed: () => _step(i, -1), icon: const Icon(Icons.remove)),
                      Expanded(
                        child: InkWell(
                          onTap: () => _editGrams(i),
                          child: Text(
                            '${fmtNum(it.grams.roundToDouble())} ${l.gramsShort}',
                            textAlign: TextAlign.center,
                            style: context.text.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                      IconButton.filledTonal(onPressed: () => _step(i, 1), icon: const Icon(Icons.add)),
                      const SizedBox(width: 8),
                    ]),
                    const SizedBox(height: 6),
                    MacroSummaryRow(macros: it.macros, dense: true),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 12),
          SectionCard(title: l.nutTotal, child: MacroSummaryRow(macros: totals)),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _saveToMyFoods,
            onChanged: (v) => setState(() => _saveToMyFoods = v),
            title: Text(l.nutSaveToMyFoods),
            subtitle: Text(l.nutSaveToMyFoodsHint),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: FilledButton.icon(
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
            onPressed: _saving ? null : _save,
            icon: _saving
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.check),
            label: Text(l.nutSaveMeal),
          ),
        ),
      ),
    );
  }
}

class _ConfidenceCard extends StatelessWidget {
  final double confidence;
  final String? notes;
  const _ConfidenceCard({required this.confidence, this.notes});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final pct = (confidence * 100).round();
    final color = confidence >= 0.75
        ? AppColors.primary
        : confidence >= 0.5
            ? AppColors.warning
            : AppColors.danger;
    return Card(
      color: AppColors.cardHigh,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(Icons.auto_awesome, color: color, size: 20),
              const SizedBox(width: 8),
              Text(l.nutConfidence(pct), style: TextStyle(color: color, fontWeight: FontWeight.w700)),
            ]),
            if (notes != null && notes!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(notes!, style: context.text.bodySmall),
            ],
            const SizedBox(height: 4),
            Text(l.nutReviewHint, style: context.text.bodySmall?.copyWith(color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}
