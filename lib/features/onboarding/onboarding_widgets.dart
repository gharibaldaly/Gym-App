import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/context_ext.dart';
import '../../core/widgets/common.dart';
import 'onboarding_labels.dart';
import 'onboarding_logic.dart';
import 'onboarding_summary.dart';

/// Big icon + title + subtitle shown on top of every question.
class StepHeader extends StatelessWidget {
  final OnbStep step;
  const StepHeader({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.18), blurRadius: 24)],
            ),
            child: Icon(stepIcon(step), color: AppColors.primary, size: 30),
          ),
          const SizedBox(height: 16),
          Text(stepTitle(l, step), style: context.text.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(stepSubtitle(l, step), style: context.text.bodyMedium?.copyWith(color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

/// Small section heading inside a step.
class FieldHeading extends StatelessWidget {
  final String text;
  final Widget? trailing;
  const FieldHeading(this.text, {super.key, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 20, bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(text, style: context.text.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

/// Muted info box with an icon.
class InfoNote extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  const InfoNote(this.text, {super.key, this.icon = Icons.info_outline, this.color = AppColors.info});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: context.text.bodySmall?.copyWith(height: 1.4))),
        ],
      ),
    );
  }
}

/// Vertical list of [ChoiceCard]s (single select).
class OptionCards<T> extends StatelessWidget {
  final List<OnbOption<T>> options;
  final T? selected;
  final ValueChanged<T> onSelect;
  const OptionCards({super.key, required this.options, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final o in options)
          ChoiceCard(
            label: o.label,
            subtitle: o.subtitle,
            icon: o.icon,
            selected: o.code == selected,
            onTap: () {
              HapticFeedback.selectionClick();
              onSelect(o.code);
            },
          ),
      ],
    );
  }
}

/// Two-column grid of toggle tiles (multi or single select).
class ToggleTileGrid<T> extends StatelessWidget {
  final List<OnbOption<T>> options;
  final bool Function(T code) isSelected;
  final ValueChanged<T> onToggle;
  const ToggleTileGrid({super.key, required this.options, required this.isSelected, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final w = (c.maxWidth - 10) / 2;
      return Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          for (final o in options)
            SizedBox(
              width: w,
              child: _ToggleTile(
                label: o.label,
                icon: o.icon,
                selected: isSelected(o.code),
                onTap: () {
                  HapticFeedback.selectionClick();
                  onToggle(o.code);
                },
              ),
            ),
        ],
      );
    });
  }
}

class _ToggleTile extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;
  const _ToggleTile({required this.label, this.icon, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary.withValues(alpha: 0.12) : AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: selected ? AppColors.primary : AppColors.border, width: selected ? 2 : 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20, color: selected ? AppColors.primary : AppColors.textMuted),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(label,
                      style: TextStyle(fontWeight: selected ? FontWeight.w700 : FontWeight.w500, fontSize: 14)),
                ),
                if (selected) const Icon(Icons.check_circle, size: 18, color: AppColors.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Wrap of filter chips (used for foods / allergies / experience).
class ChipChoices<T> extends StatelessWidget {
  final List<OnbOption<T>> options;
  final bool Function(T code) isSelected;
  final ValueChanged<T> onToggle;
  final Color selectedColor;
  const ChipChoices({
    super.key,
    required this.options,
    required this.isSelected,
    required this.onToggle,
    this.selectedColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final o in options)
          FilterChip(
            label: Text(o.label),
            avatar: o.icon == null ? null : Icon(o.icon, size: 18),
            selected: isSelected(o.code),
            selectedColor: selectedColor.withValues(alpha: 0.22),
            checkmarkColor: selectedColor,
            side: BorderSide(color: isSelected(o.code) ? selectedColor : AppColors.border),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            onSelected: (_) {
              HapticFeedback.selectionClick();
              onToggle(o.code);
            },
          ),
      ],
    );
  }
}

/// Row of big round number buttons (days per week, meals per day…).
class NumberPills extends StatelessWidget {
  final List<int> values;
  final int? selected;
  final ValueChanged<int> onSelect;
  const NumberPills({super.key, required this.values, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final v in values)
          _Pill(
            text: '$v',
            selected: v == selected,
            onTap: () {
              HapticFeedback.selectionClick();
              onSelect(v);
            },
          ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;
  static const double size = 56;
  const _Pill({required this.text, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : AppColors.card,
        borderRadius: BorderRadius.circular(size / 2.6),
        border: Border.all(color: selected ? AppColors.primary : AppColors.border),
        boxShadow: selected ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.35), blurRadius: 14)] : null,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(size / 2.6),
        onTap: onTap,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: selected ? AppColors.onPrimary : AppColors.text,
            ),
          ),
        ),
      ),
    );
  }
}

/// Weekday toggles (pill per day) – used by the training-days step.
class DayToggle extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const DayToggle({super.key, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      height: 56,
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: selected ? AppColors.primary : AppColors.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: Center(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: selected ? AppColors.onPrimary : AppColors.text,
            ),
          ),
        ),
      ),
    );
  }
}

/// Numeric text field (keyboard-friendly, accepts Arabic digits) with inline
/// range validation. Reports the parsed value (or null when empty/invalid).
class NumField extends StatefulWidget {
  final String label;
  final num? value;
  final String? unit;
  final num? min;
  final num? max;
  final bool decimal;
  final IconData? icon;
  final ValueChanged<double?> onChanged;
  final TextInputAction action;
  final String? helper;
  const NumField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.unit,
    this.min,
    this.max,
    this.decimal = false,
    this.icon,
    this.action = TextInputAction.next,
    this.helper,
  });

  @override
  State<NumField> createState() => _NumFieldState();
}

class _NumFieldState extends State<NumField> {
  late final TextEditingController _c = TextEditingController(text: _fmt(widget.value));

  String _fmt(num? v) => v == null ? '' : fmtNum(v);

  @override
  void didUpdateWidget(NumField old) {
    super.didUpdateWidget(old);
    // External change (e.g. "use suggestion") → reflect it without fighting the user's typing.
    if (widget.value != old.value && parseNum(_c.text) != widget.value) {
      _c.text = _fmt(widget.value);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  String? _error(BuildContext context) {
    final t = _c.text.trim();
    if (t.isEmpty) return null;
    final v = parseNum(t);
    final min = widget.min, max = widget.max;
    if (v == null || (min != null && v < min) || (max != null && v > max)) {
      return context.l10n.onbErrRange(fmtNum(min ?? 0), fmtNum(max ?? 9999));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: _c,
        keyboardType: TextInputType.numberWithOptions(decimal: widget.decimal),
        textInputAction: widget.action,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(widget.decimal ? r'[0-9٠-٩۰-۹.,٫]' : r'[0-9٠-٩۰-۹]')),
          LengthLimitingTextInputFormatter(8),
        ],
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        decoration: InputDecoration(
          labelText: widget.label,
          prefixIcon: widget.icon == null ? null : Icon(widget.icon),
          suffixText: widget.unit,
          helperText: widget.helper,
          errorText: _error(context),
        ),
        onChanged: (t) {
          setState(() {});
          widget.onChanged(parseNum(t));
        },
      ),
    );
  }
}

/// Free-text answer field that keeps its own controller.
class TextAnswerField extends StatefulWidget {
  final String label;
  final String? value;
  final ValueChanged<String> onChanged;
  final int maxLines;
  final IconData? icon;
  const TextAnswerField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.maxLines = 1,
    this.icon,
  });

  @override
  State<TextAnswerField> createState() => _TextAnswerFieldState();
}

class _TextAnswerFieldState extends State<TextAnswerField> {
  late final TextEditingController _c = TextEditingController(text: widget.value ?? '');

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: _c,
        minLines: 1,
        maxLines: widget.maxLines,
        textInputAction: widget.maxLines > 1 ? TextInputAction.newline : TextInputAction.done,
        decoration: InputDecoration(
          labelText: widget.label,
          prefixIcon: widget.icon == null ? null : Icon(widget.icon),
        ),
        onChanged: widget.onChanged,
      ),
    );
  }
}

/// Card showing a time ("HH:mm"); tapping opens the time picker.
class TimeTile extends StatelessWidget {
  final String label;
  final String? value;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final String fallback;
  const TimeTile({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.icon = Icons.schedule,
    this.fallback = '08:00',
  });

  @override
  Widget build(BuildContext context) {
    final t = parseHm(value);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          final picked = await showTimePicker(context: context, initialTime: t ?? parseHm(fallback)!);
          if (picked != null) onChanged(hm(picked));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(child: Text(label, style: context.text.bodyLarge)),
              Text(
                t == null ? '--:--' : MaterialLocalizations.of(context).formatTimeOfDay(t),
                style: context.text.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.edit_outlined, size: 16, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}

/// A card listing a summary section's answers; each row is tappable.
class SummarySectionCard extends StatelessWidget {
  final SummarySection section;
  final ValueChanged<OnbStep> onTap;
  const SummarySectionCard({super.key, required this.section, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: section.title,
      padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 8, 8),
      child: Column(
        children: [
          for (final item in section.items)
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => onTap(item.step),
              child: Padding(
                padding: const EdgeInsetsDirectional.symmetric(vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(item.invalid ? Icons.error_outline : item.icon,
                        size: 22, color: item.invalid ? AppColors.danger : AppColors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.label,
                              style: context.text.labelMedium?.copyWith(color: AppColors.textMuted)),
                          const SizedBox(height: 2),
                          Text(item.value,
                              style: context.text.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: item.invalid ? AppColors.danger : null,
                              )),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.textMuted),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
