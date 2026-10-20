import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../ai/ai_service.dart';
import '../providers.dart';
import '../theme/app_theme.dart';
import '../navigation.dart';
import '../utils/context_ext.dart';

/// Rounded dark card with optional title row.
class SectionCard extends StatelessWidget {
  final String? title;
  final Widget? trailing;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  const SectionCard({
    super.key,
    this.title,
    this.trailing,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null || trailing != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      if (title != null)
                        Expanded(
                          child: Text(title!,
                              style: context.text.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                        ),
                      ?trailing,
                    ],
                  ),
                ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

/// Circular progress ring (calories, water, recovery…).
class ProgressRing extends StatelessWidget {
  final double value;
  final double max;
  final double size;
  final double stroke;
  final Color color;
  final Widget? center;
  const ProgressRing({
    super.key,
    required this.value,
    required this.max,
    this.size = 120,
    this.stroke = 10,
    this.color = AppColors.primary,
    this.center,
  });

  @override
  Widget build(BuildContext context) {
    final p = max <= 0 ? 0.0 : (value / max).clamp(0.0, 1.0);
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(p, color, stroke),
        child: Center(child: center),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double stroke;
  _RingPainter(this.progress, this.color, this.stroke);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset(stroke / 2, stroke / 2) & Size(size.width - stroke, size.height - stroke);
    final bg = Paint()
      ..color = AppColors.cardHigh
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    final fg = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = stroke;
    canvas.drawArc(rect, 0, 2 * math.pi, false, bg);
    if (progress > 0) canvas.drawArc(rect, -math.pi / 2, 2 * math.pi * progress, false, fg);
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress || old.color != color;
}

/// Labeled horizontal bar "Protein 120 / 180 g".
class MacroBar extends StatelessWidget {
  final String label;
  final double value;
  final double target;
  final Color color;
  final String unit;
  const MacroBar({
    super.key,
    required this.label,
    required this.value,
    required this.target,
    required this.color,
    this.unit = 'g',
  });

  @override
  Widget build(BuildContext context) {
    final p = target <= 0 ? 0.0 : (value / target).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [
            Expanded(child: Text(label, style: context.text.bodyMedium)),
            Text('${fmtNum(value)} / ${fmtNum(target)} $unit',
                style: context.text.bodySmall?.copyWith(color: AppColors.textMuted)),
          ]),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: p,
              minHeight: 8,
              color: color,
              backgroundColor: AppColors.cardHigh,
            ),
          ),
        ],
      ),
    );
  }
}

/// Large +/- stepper for sweaty hands in the gym.
class BigStepper extends StatelessWidget {
  final String label;
  final double value;
  final double step;
  final ValueChanged<double> onChanged;
  final double min;
  final int decimals;
  final VoidCallback? onTapValue;
  const BigStepper({
    super.key,
    required this.label,
    required this.value,
    required this.step,
    required this.onChanged,
    this.min = 0,
    this.decimals = 1,
    this.onTapValue,
  });

  @override
  Widget build(BuildContext context) {
    Widget btn(IconData icon, double delta) => SizedBox(
          width: 56,
          height: 56,
          child: IconButton.filledTonal(
            iconSize: 28,
            onPressed: () => onChanged(math.max(min, value + delta)),
            icon: Icon(icon),
          ),
        );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: context.text.labelMedium?.copyWith(color: AppColors.textMuted)),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            btn(Icons.remove, -step),
            InkWell(
              onTap: onTapValue,
              child: SizedBox(
                width: 72,
                child: Text(
                  fmtNum(value, maxDecimals: decimals),
                  textAlign: TextAlign.center,
                  style: context.text.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
            ),
            btn(Icons.add, step),
          ],
        ),
      ],
    );
  }
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String text;
  final Widget? action;
  const EmptyState({super.key, required this.icon, required this.text, this.action});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: AppColors.textMuted),
            const SizedBox(height: 12),
            Text(text, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textMuted)),
            if (action != null) ...[const SizedBox(height: 16), action!],
          ],
        ),
      ),
    );
  }
}

/// Shown in place of an AI feature when no API key is set (or offline).
class AiUnavailableBanner extends ConsumerWidget {
  final VoidCallback? onAddKey;
  const AiUnavailableBanner({super.key, this.onAddKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasKey = ref.watch(hasApiKeyProvider);
    final online = ref.watch(isOnlineProvider);
    if (hasKey && online) return const SizedBox.shrink();
    final l = context.l10n;
    final action = onAddKey ?? () => openSettings(context);
    return Card(
      color: AppColors.cardHigh,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(hasKey ? Icons.wifi_off : Icons.key_off, color: AppColors.warning),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(hasKey ? l.noInternet : l.noApiKeyTitle,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  if (!hasKey) Text(l.noApiKeyBody, style: context.text.bodySmall),
                ],
              ),
            ),
            if (!hasKey) TextButton(onPressed: action, child: Text(l.addApiKey)),
          ],
        ),
      ),
    );
  }
}

/// Selectable card used by onboarding/question screens.
class ChoiceCard extends StatelessWidget {
  final String label;
  final String? subtitle;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;
  const ChoiceCard({
    super.key,
    required this.label,
    this.subtitle,
    this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary.withValues(alpha: 0.12) : AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: selected ? AppColors.primary : AppColors.border, width: selected ? 2 : 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: selected ? AppColors.primary : AppColors.textMuted),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    if (subtitle != null)
                      Text(subtitle!, style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
                  ],
                ),
              ),
              if (selected) const Icon(Icons.check_circle, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}
