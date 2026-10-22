import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../ai/ai_service.dart';
import '../providers.dart';
import '../theme/app_theme.dart';
import '../navigation.dart';
import '../utils/context_ext.dart';
import 'motion.dart';

export 'motion.dart';

/// Tinted rounded-square icon holder used as a leading visual in cards and rows.
class IconBadge extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  const IconBadge(this.icon, {super.key, this.color = AppColors.primary, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(size * 0.32),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: size * 0.55, color: color),
    );
  }
}

/// Rounded dark card with optional title row.
class SectionCard extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final Color? iconColor;
  final Widget? trailing;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;
  const SectionCard({
    super.key,
    this.title,
    this.icon,
    this.iconColor,
    this.trailing,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpace.lg),
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Pressable(
      enabled: onTap != null,
      child: Card(
        color: color,
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
                    padding: const EdgeInsets.only(bottom: AppSpace.md),
                    child: Row(
                      children: [
                        if (icon != null) ...[
                          IconBadge(icon!, color: iconColor ?? AppColors.primary, size: 30),
                          const SizedBox(width: AppSpace.sm + 2),
                        ],
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
      ),
    );
  }
}

/// Circular progress ring (calories, water, recovery…). Animates to new values.
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
      child: TweenAnimationBuilder<double>(
        tween: Tween(end: p),
        duration: (MediaQuery.maybeDisableAnimationsOf(context) ?? false) ? Duration.zero : AppMotion.reveal,
        curve: AppMotion.emphasized,
        builder: (context, v, child) => CustomPaint(painter: _RingPainter(v, color, stroke), child: child),
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
      ..color = AppColors.cardHighest
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    canvas.drawArc(rect, 0, 2 * math.pi, false, bg);
    if (progress <= 0) return;
    final sweep = 2 * math.pi * progress;
    final fg = Paint()
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: math.max(sweep, 0.01),
        colors: [Color.lerp(color, Colors.black, 0.25)!, color],
        transform: const GradientRotation(-math.pi / 2),
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = stroke;
    canvas.drawArc(rect, -math.pi / 2, sweep, false, fg);
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.color != color || old.stroke != stroke;
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
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: AppSpace.sm),
            Expanded(child: Text(label, style: context.text.bodyMedium?.copyWith(fontWeight: FontWeight.w600))),
            Text.rich(
              TextSpan(children: [
                TextSpan(text: fmtNum(value), style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.w700)),
                TextSpan(text: ' / ${fmtNum(target)} $unit'),
              ]),
              style: context.text.bodySmall?.copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
            ),
          ]),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: TweenAnimationBuilder<double>(
              tween: Tween(end: p),
              duration: (MediaQuery.maybeDisableAnimationsOf(context) ?? false) ? Duration.zero : AppMotion.reveal,
              curve: AppMotion.emphasized,
              builder: (context, v, _) => LinearProgressIndicator(
                value: v,
                minHeight: 8,
                color: color,
                backgroundColor: AppColors.cardHighest,
              ),
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
            style: IconButton.styleFrom(
              backgroundColor: AppColors.cardHighest,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md + 2)),
            ),
            onPressed: () {
              tick();
              onChanged(math.max(min, value + delta));
            },
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
            btn(Symbols.remove_rounded, -step),
            InkWell(
              onTap: onTapValue,
              child: SizedBox(
                width: 72,
                child: AnimatedSwitcher(
                  duration: AppMotion.fast,
                  transitionBuilder: (c, a) => ScaleTransition(scale: Tween(begin: 0.8, end: 1.0).animate(a), child: FadeTransition(opacity: a, child: c)),
                  child: Text(
                    fmtNum(value, maxDecimals: decimals),
                    key: ValueKey(value),
                    textAlign: TextAlign.center,
                    style: context.text.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ),
            btn(Symbols.add_rounded, step),
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
      child: Reveal(
        child: Padding(
          padding: const EdgeInsets.all(AppSpace.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: AppColors.cardHigh,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border),
                ),
                child: Icon(icon, size: 40, color: AppColors.textMuted),
              ),
              const SizedBox(height: AppSpace.lg),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 300),
                child: Text(text,
                    textAlign: TextAlign.center,
                    style: context.text.bodyMedium?.copyWith(color: AppColors.textMuted)),
              ),
              if (action != null) ...[const SizedBox(height: AppSpace.lg + 4), action!],
            ],
          ),
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
            IconBadge(hasKey ? Symbols.wifi_off_rounded : Symbols.key_off_rounded, color: AppColors.warning),
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
    final fg = selected ? AppColors.primary : AppColors.textMuted;
    return Pressable(
      child: AnimatedContainer(
        duration: AppMotion.base,
        curve: AppMotion.standard,
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withValues(alpha: 0.10) : AppColors.card,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: selected ? AppColors.primary : AppColors.border, width: selected ? 1.5 : 1),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          onTap: () {
            tick();
            onTap();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                if (icon != null) ...[
                  AnimatedContainer(
                    duration: AppMotion.base,
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary.withValues(alpha: 0.16) : AppColors.cardHigh,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: fg, size: 22),
                  ),
                  const SizedBox(width: 14),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      if (subtitle != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(subtitle!, style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
                        ),
                    ],
                  ),
                ),
                AnimatedSwitcher(
                  duration: AppMotion.base,
                  transitionBuilder: (c, a) => ScaleTransition(
                    scale: CurvedAnimation(parent: a, curve: AppMotion.overshoot),
                    child: FadeTransition(opacity: a, child: c),
                  ),
                  child: selected
                      ? const Icon(Symbols.check_circle_rounded, fill: 1, key: ValueKey(true), color: AppColors.primary)
                      : const SizedBox(key: ValueKey(false), width: 24, height: 24),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
