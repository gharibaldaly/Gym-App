import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/calc/nutrition_calc.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/context_ext.dart';
import '../../../core/widgets/common.dart';
import '../../../data/repositories/profile_repository.dart';
import '../onboarding_labels.dart';
import '../onboarding_logic.dart';
import '../onboarding_widgets.dart';
import 'step_types.dart';

/// Step 17 – meals per day + their times.
class MealsStep extends StatelessWidget {
  final UserProfile profile;
  final ProfilePatch onChanged;
  const MealsStep({super.key, required this.profile, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = profile;
    final times = p.mealTimes;
    void setTimes(List<String> t) => onChanged(UserProfilesCompanion(mealTimesJson: Value(jsonEncode(t))));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NumberPills(
          values: const [2, 3, 4, 5, 6],
          selected: p.mealsPerDay,
          onSelect: (n) => onChanged(UserProfilesCompanion(
            mealsPerDay: Value(n),
            mealTimesJson: Value(jsonEncode(resizeMealTimes(times, n, wake: p.wakeTime, sleep: p.sleepTime))),
          )),
        ),
        if (p.mealsPerDay != null) ...[
          FieldHeading(
            l.onbMealsSubtitle,
            trailing: TextButton.icon(
              icon: const Icon(Symbols.auto_awesome_rounded, size: 18),
              label: Text(l.onbMealsReset),
              onPressed: () =>
                  setTimes(suggestMealTimes(p.mealsPerDay!, wake: p.wakeTime, sleep: p.sleepTime)),
            ),
          ),
          for (var i = 0; i < times.length; i++)
            TimeTile(
              key: ValueKey('meal$i'),
              label: l.onbMealN('${i + 1}'),
              value: times[i],
              icon: Symbols.restaurant_rounded,
              onChanged: (v) => setTimes([...times]..[i] = v),
            ),
        ],
      ],
    );
  }
}

/// Step 18 – liked / disliked foods + allergies.
class FoodsStep extends StatelessWidget {
  final UserProfile profile;
  final ProfilePatch onChanged;
  const FoodsStep({super.key, required this.profile, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = profile;
    final liked = splitChipText(p.likedFoods, egyptianFoods);
    final disliked = splitChipText(p.dislikedFoods, egyptianFoods);
    final allergies = splitChipText(p.allergies, commonAllergies);

    List<OnbOption<String>> foods() => [for (final f in egyptianFoods) OnbOption(f, foodLabel(l, f))];

    void toggleFood(bool like, String code) {
      final mine = (like ? liked : disliked).codes.toSet();
      final other = (like ? disliked : liked).codes.toSet();
      if (!mine.remove(code)) {
        mine.add(code);
        other.remove(code); // can't both like and dislike the same food
      }
      final likeCodes = like ? mine : other;
      final dislikeCodes = like ? other : mine;
      onChanged(UserProfilesCompanion(
        likedFoods: Value(joinChipText(likeCodes, liked.other, order: egyptianFoods)),
        dislikedFoods: Value(joinChipText(dislikeCodes, disliked.other, order: egyptianFoods)),
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FieldHeading(l.onbFoodsLiked),
        ChipChoices<String>(
          options: foods(),
          isSelected: liked.codes.contains,
          onToggle: (c) => toggleFood(true, c),
        ),
        TextAnswerField(
          label: l.onbFoodsOther,
          value: liked.other,
          icon: Symbols.thumb_up_rounded,
          onChanged: (t) => onChanged(UserProfilesCompanion(
            likedFoods: Value(joinChipText(liked.codes, t, order: egyptianFoods)),
          )),
        ),
        FieldHeading(l.onbFoodsDisliked),
        ChipChoices<String>(
          options: foods(),
          isSelected: disliked.codes.contains,
          selectedColor: AppColors.warning,
          onToggle: (c) => toggleFood(false, c),
        ),
        TextAnswerField(
          label: l.onbFoodsOther,
          value: disliked.other,
          icon: Symbols.thumb_down_rounded,
          onChanged: (t) => onChanged(UserProfilesCompanion(
            dislikedFoods: Value(joinChipText(disliked.codes, t, order: egyptianFoods)),
          )),
        ),
        FieldHeading(l.onbAllergies),
        ChipChoices<String>(
          options: [for (final a in commonAllergies) OnbOption(a, allergyLabel(l, a))],
          isSelected: allergies.codes.contains,
          selectedColor: AppColors.danger,
          onToggle: (c) {
            final next = allergies.codes.toSet();
            if (!next.remove(c)) next.add(c);
            onChanged(UserProfilesCompanion(
              allergies: Value(joinChipText(next, allergies.other, order: commonAllergies)),
            ));
          },
        ),
        TextAnswerField(
          label: l.onbFoodsOther,
          value: allergies.other,
          icon: Symbols.warning_rounded,
          onChanged: (t) => onChanged(UserProfilesCompanion(
            allergies: Value(joinChipText(allergies.codes, t, order: commonAllergies)),
          )),
        ),
      ],
    );
  }
}

/// Step 19 – monthly food budget (level or a number in EGP).
class BudgetStep extends StatefulWidget {
  final UserProfile profile;
  final ProfilePatch onChanged;
  const BudgetStep({super.key, required this.profile, required this.onChanged});

  @override
  State<BudgetStep> createState() => _BudgetStepState();
}

class _BudgetStepState extends State<BudgetStep> {
  late bool _custom = widget.profile.budgetLevel == null && widget.profile.budgetEgp != null;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = widget.profile;
    final selected = _custom ? 'custom' : p.budgetLevel;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OptionCards<String>(
          options: budgetOptions(l),
          selected: selected,
          onSelect: (v) {
            setState(() => _custom = v == 'custom');
            widget.onChanged(v == 'custom'
                ? const UserProfilesCompanion(budgetLevel: Value(null))
                : UserProfilesCompanion(budgetLevel: Value(v), budgetEgp: const Value(null)));
          },
        ),
        if (_custom)
          NumField(
            label: l.onbBudgetAmount,
            value: p.budgetEgp,
            unit: l.onbEgp,
            min: OnbLimits.budgetMin,
            max: OnbLimits.budgetMax,
            icon: Symbols.payments_rounded,
            action: TextInputAction.done,
            onChanged: (v) => widget.onChanged(UserProfilesCompanion(budgetEgp: Value(v?.round()))),
          ),
      ],
    );
  }
}

/// Step 20 – current supplements with doses (and macros for protein/gainers).
class SupplementsStep extends StatefulWidget {
  final UserProfile profile;
  final ProfilePatch onChanged;
  const SupplementsStep({super.key, required this.profile, required this.onChanged});

  @override
  State<SupplementsStep> createState() => _SupplementsStepState();
}

class _SupplementsStepState extends State<SupplementsStep> {
  late final List<(int, SupplementEntry)> _rows;
  int _nextId = 0;

  @override
  void initState() {
    super.initState();
    _rows = [for (final e in parseSupplements(widget.profile.supplementsJson)) (_nextId++, e)];
  }

  void _emit() => widget.onChanged(UserProfilesCompanion(
        supplementsJson: Value(encodeSupplements([for (final r in _rows) r.$2])),
      ));

  void _add(SupplementEntry e) {
    setState(() => _rows.add((_nextId++, e)));
    _emit();
  }

  void _update(int id, SupplementEntry e) {
    final i = _rows.indexWhere((r) => r.$1 == id);
    if (i < 0) return;
    _rows[i] = (id, e);
    _emit();
  }

  void _remove(int id) {
    setState(() => _rows.removeWhere((r) => r.$1 == id));
    _emit();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final usedKeys = {for (final r in _rows) r.$2.key};
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final t in supplementTemplates)
              ActionChip(
                avatar: Icon(usedKeys.contains(t.key) ? Symbols.check_rounded : Symbols.add_rounded,
                    size: 18, color: usedKeys.contains(t.key) ? AppColors.primary : null),
                label: Text(supplementName(l, t.key)),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                onPressed: usedKeys.contains(t.key)
                    ? null
                    : () => _add(entryFromTemplate(t,
                        name: supplementName(l, t.key), dose: supplementDefaultDose(l, t))),
              ),
            ActionChip(
              avatar: const Icon(Symbols.add_rounded, size: 18),
              label: Text(l.onbSuppOther),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              onPressed: () => _add(const SupplementEntry(name: '')),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_rows.isEmpty)
          InfoNote(l.onbSuppEmpty, icon: Symbols.check_circle_rounded, color: AppColors.primary)
        else
          for (final r in _rows)
            _SupplementCard(
              key: ValueKey(r.$1),
              entry: r.$2,
              onChanged: (e) => _update(r.$1, e),
              onRemove: () => _remove(r.$1),
            ),
      ],
    );
  }
}

class _SupplementCard extends StatefulWidget {
  final SupplementEntry entry;
  final ValueChanged<SupplementEntry> onChanged;
  final VoidCallback onRemove;
  const _SupplementCard({super.key, required this.entry, required this.onChanged, required this.onRemove});

  @override
  State<_SupplementCard> createState() => _SupplementCardState();
}

class _SupplementCardState extends State<_SupplementCard> {
  late SupplementEntry _e = widget.entry;
  late bool _showMacros = _e.hasMacros || (supplementTemplate(_e.key)?.hasMacros ?? false);

  void _set(SupplementEntry e) {
    setState(() => _e = e);
    widget.onChanged(e);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final isCustom = _e.key == null;
    return SectionCard(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 4, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Symbols.pill_rounded, color: AppColors.primary),
              const SizedBox(width: 10),
              Expanded(
                child: isCustom
                    ? TextAnswerField(
                        label: l.onbSuppName,
                        value: _e.name,
                        onChanged: (t) => _set(_e.copyWith(name: t)),
                      )
                    : Text(_e.name, style: context.text.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              ),
              IconButton(
                tooltip: l.onbSuppRemove,
                icon: const Icon(Symbols.close_rounded, color: AppColors.textMuted),
                onPressed: widget.onRemove,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextAnswerField(
                    label: l.onbSuppDose,
                    value: _e.dose,
                    onChanged: (t) => _set(_e.copyWith(dose: t)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextAnswerField(
                    label: l.onbSuppTiming,
                    value: _e.timing,
                    onChanged: (t) => _set(_e.copyWith(timing: t)),
                  ),
                ),
              ],
            ),
          ),
          if (!_showMacros)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(
                icon: const Icon(Symbols.add_chart_rounded, size: 18),
                label: Text(l.onbSuppAddMacros),
                onPressed: () => setState(() => _showMacros = true),
              ),
            )
          else
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 12),
              child: _MacroFields(entry: _e, l: l, onChanged: _set),
            ),
        ],
      ),
    );
  }
}

class _MacroFields extends StatelessWidget {
  final SupplementEntry entry;
  final AppLocalizations l;
  final ValueChanged<SupplementEntry> onChanged;
  const _MacroFields({required this.entry, required this.l, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    Widget f(String label, double v, SupplementEntry Function(double) apply) => Expanded(
          child: NumField(
            label: label,
            value: v == 0 ? null : v,
            decimal: true,
            min: 0,
            max: 2000,
            onChanged: (x) => onChanged(apply(x ?? 0)),
          ),
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(top: 8),
          child: Text(l.onbSuppPerServing, style: context.text.labelMedium?.copyWith(color: AppColors.textMuted)),
        ),
        Row(children: [
          f(l.onbSuppProtein, entry.proteinG, (x) => entry.copyWith(proteinG: x)),
          const SizedBox(width: 10),
          f(l.onbSuppCalories, entry.calories, (x) => entry.copyWith(calories: x)),
        ]),
        Row(children: [
          f(l.onbSuppCarbs, entry.carbsG, (x) => entry.copyWith(carbsG: x)),
          const SizedBox(width: 10),
          f(l.onbSuppFat, entry.fatG, (x) => entry.copyWith(fatG: x)),
        ]),
      ],
    );
  }
}

/// Step 21 – daily water goal (suggested from weight).
class WaterStep extends StatelessWidget {
  final UserProfile profile;
  final ProfilePatch onChanged;
  const WaterStep({super.key, required this.profile, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = profile;
    final suggested = p.weightKg == null ? null : NutritionCalc.waterGoalMl(p.weightKg!);
    final ml = (p.waterGoalMl ?? suggested ?? 2500).toDouble();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        Center(
          child: ProgressRing(
            value: ml,
            max: OnbLimits.waterMax.toDouble(),
            size: 170,
            stroke: 12,
            color: AppColors.water,
            center: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Symbols.water_drop_rounded, fill: 1, color: AppColors.water, size: 30),
                Text(l.onbWaterLiters(fmtNum(ml / 1000, maxDecimals: 2)),
                    style: context.text.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: BigStepper(
            label: l.mlShort,
            value: ml,
            step: 250,
            min: OnbLimits.waterMin.toDouble(),
            decimals: 0,
            onChanged: (v) => onChanged(
              UserProfilesCompanion(waterGoalMl: Value(v.clamp(OnbLimits.waterMin, OnbLimits.waterMax).round())),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(l.onbWaterGlasses('${(ml / 250).round()}'),
              style: context.text.bodyMedium?.copyWith(color: AppColors.textMuted)),
        ),
        if (suggested != null) ...[
          const SizedBox(height: 12),
          InfoNote(l.onbWaterSuggested('$suggested'), icon: Symbols.auto_awesome_rounded, color: AppColors.water),
          if (p.waterGoalMl != suggested)
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: () => onChanged(UserProfilesCompanion(waterGoalMl: Value(suggested))),
                child: Text(l.onbWaterUseSuggestion),
              ),
            ),
        ],
      ],
    );
  }
}
