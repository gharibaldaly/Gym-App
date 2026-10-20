import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/context_ext.dart';
import 'body_map_svg.dart';

export 'body_map_svg.dart' show BodyView;

/// Front + back body silhouette; primary muscles dark green, secondary light green.
class BodyMap extends StatelessWidget {
  final List<String> primary;
  final List<String> secondary;
  final double height;

  /// Shows "Front / Back" captions under the figures.
  final bool showLabels;

  /// Draws only one side when set (e.g. compact thumbnails).
  final BodyView? only;

  const BodyMap({
    super.key,
    required this.primary,
    this.secondary = const [],
    this.height = 220,
    this.showLabels = false,
    this.only,
  });

  static const int idleColor = 0xFF3A3A3A;

  int _fill(String muscle) {
    if (primary.contains(muscle)) return AppColors.primaryDark.toARGB32();
    if (secondary.contains(muscle)) return AppColors.primaryLight.toARGB32();
    return idleColor;
  }

  @override
  Widget build(BuildContext context) {
    final views = only == null ? BodyView.values : [only!];
    final figureHeight = showLabels ? height - 22 : height;
    final figureWidth = figureHeight * kBodyViewBoxWidth / kBodyViewBoxHeight;
    return Semantics(
      label: [...primary, ...secondary].join(', '),
      child: SizedBox(
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (final v in views)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: figureWidth * 0.08),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.string(
                      buildBodySvg(v, fillFor: _fill),
                      width: figureWidth,
                      height: figureHeight,
                      // Same picture for identical inputs → cheap rebuilds.
                      key: ValueKey('${v.name}|${primary.join(',')}|${secondary.join(',')}'),
                    ),
                    if (showLabels)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          v == BodyView.front ? context.l10n.exBodyFront : context.l10n.exBodyBack,
                          style: context.text.labelSmall?.copyWith(color: AppColors.textMuted),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Small legend: dark green = primary, light green = secondary.
class BodyMapLegend extends StatelessWidget {
  const BodyMapLegend({super.key});

  @override
  Widget build(BuildContext context) {
    Widget dot(Color c, String label) => Row(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text(label, style: context.text.bodySmall),
        ]);
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 6,
      children: [
        dot(AppColors.primaryDark, context.l10n.exPrimaryMuscles),
        dot(AppColors.primaryLight, context.l10n.exSecondaryMuscles),
      ],
    );
  }
}
