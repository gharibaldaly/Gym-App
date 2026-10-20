/// Small fl_chart wrappers shared by the Progress cards (dark theme, date x-axis).
library;

import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../core/calc/stats.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/context_ext.dart';

const _axisStyle = TextStyle(fontSize: 10, color: AppColors.textMuted);

int _dayIndex(DateTime origin, DateTime d) =>
    DateTime.utc(d.year, d.month, d.day).difference(DateTime.utc(origin.year, origin.month, origin.day)).inDays;

DateTime _fromIndex(DateTime origin, int i) => DateTime(origin.year, origin.month, origin.day + i);

/// "Sat 12 Oct" in the app language with Latin digits.
String chartDayLabel(BuildContext context, DateTime d) =>
    (DateFormat('EEE d MMM', context.lang)..useNativeDigits = false).format(d);

String shortDateLabel(DateTime d) => '${d.day}/${d.month}';

/// Round axis step (1, 2, 2.5, 5 × 10ⁿ) close to [raw].
double niceStep(double raw) {
  if (raw <= 0 || raw.isNaN) return 1;
  final mag = math.pow(10, (math.log(raw) / math.ln10).floor()).toDouble();
  final n = raw / mag;
  return (n <= 1 ? 1 : n <= 2 ? 2 : n <= 2.5 ? 2.5 : n <= 5 ? 5 : 10) * mag;
}

/// One line on a [DateLineChart].
class ChartSeries {
  final String label;
  final List<DatedValue> points;
  final Color color;
  final bool showDots;
  final double width;
  final bool dashed;
  final bool area;
  final bool curved;
  const ChartSeries({
    required this.label,
    required this.points,
    required this.color,
    this.showDots = true,
    this.width = 2.5,
    this.dashed = false,
    this.area = false,
    this.curved = false,
  });
}

/// Line chart with a calendar x-axis (days), always laid out left → right.
class DateLineChart extends StatelessWidget {
  final List<ChartSeries> series;
  final double height;
  final String Function(double) yFormat;
  final double? minY, maxY;
  const DateLineChart({
    super.key,
    required this.series,
    required this.yFormat,
    this.height = 200,
    this.minY,
    this.maxY,
  });

  @override
  Widget build(BuildContext context) {
    final all = [for (final s in series) ...s.points];
    if (all.isEmpty) return SizedBox(height: height);
    final origin = all.map((p) => p.date).reduce((a, b) => a.isBefore(b) ? a : b);
    final last = all.map((p) => _dayIndex(origin, p.date)).reduce(math.max);
    final minX = last == 0 ? -1.0 : 0.0, maxX = last == 0 ? 1.0 : last.toDouble();
    final lo = all.map((p) => p.value).reduce(math.min), hi = all.map((p) => p.value).reduce(math.max);
    final pad = math.max((hi - lo) * 0.12, hi.abs() * 0.02 + 0.5);
    final rawLo = minY ?? math.max(0, lo - pad).toDouble(), rawHi = maxY ?? hi + pad;
    final yStep = niceStep((rawHi - rawLo) / 4);
    final y0 = minY ?? (rawLo / yStep).floorToDouble() * yStep;
    final y1 = maxY ?? (rawHi / yStep).ceilToDouble() * yStep;
    final interval = math.max(1.0, (maxX - minX) / 4).ceilToDouble();

    return Directionality(
      textDirection: TextDirection.ltr,
      child: SizedBox(
        height: height,
        child: LineChart(
          LineChartData(
            minX: minX,
            maxX: maxX,
            minY: y0,
            maxY: y1,
            clipData: const FlClipData.all(),
            gridData: FlGridData(
              drawVerticalLine: false,
              horizontalInterval: yStep,
              getDrawingHorizontalLine: (_) => const FlLine(color: AppColors.border, strokeWidth: 1),
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(),
              rightTitles: const AxisTitles(),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 42,
                  interval: yStep,
                  getTitlesWidget: (v, meta) => SideTitleWidget(meta: meta, child: Text(yFormat(v), style: _axisStyle)),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 26,
                  interval: interval,
                  getTitlesWidget: (v, meta) {
                    if (v < 0 || v > last || v != v.roundToDouble() || (v == meta.max && v % interval != 0)) {
                      return const SizedBox.shrink();
                    }
                    return SideTitleWidget(
                      meta: meta,
                      child: Text(shortDateLabel(_fromIndex(origin, v.toInt())), style: _axisStyle),
                    );
                  },
                ),
              ),
            ),
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (_) => AppColors.cardHigh,
                fitInsideHorizontally: true,
                fitInsideVertically: true,
                maxContentWidth: 180,
                getTooltipItems: (spots) => [
                  for (var i = 0; i < spots.length; i++)
                    LineTooltipItem(
                      '${i == 0 ? '${chartDayLabel(context, _fromIndex(origin, spots[i].x.round()))}\n' : ''}'
                      '${series[spots[i].barIndex].label}: ${yFormat(spots[i].y)}',
                      TextStyle(color: series[spots[i].barIndex].color, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                ],
              ),
            ),
            lineBarsData: [
              for (final s in series)
                LineChartBarData(
                  spots: [for (final p in s.points) FlSpot(_dayIndex(origin, p.date).toDouble(), p.value)],
                  color: s.color,
                  barWidth: s.width,
                  isCurved: s.curved,
                  preventCurveOverShooting: true,
                  dashArray: s.dashed ? [6, 4] : null,
                  dotData: FlDotData(
                    show: s.showDots,
                    getDotPainter: (spot, _, _, _) =>
                        FlDotCirclePainter(radius: 3, color: s.color, strokeWidth: 0, strokeColor: s.color),
                  ),
                  belowBarData: BarAreaData(show: s.area, color: s.color.withValues(alpha: 0.12)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One bar on a [DateBarChart].
class ChartBar {
  final DateTime date;
  final double value;
  final double? target;
  final Color color;
  final String? tooltip;
  const ChartBar({required this.date, required this.value, this.target, this.color = AppColors.primary, this.tooltip});
}

/// Bar chart with one bar per date (days or weeks), optional per-bar target shown
/// as a background bar and an optional horizontal reference line.
class DateBarChart extends StatelessWidget {
  final List<ChartBar> bars;
  final String Function(double) yFormat;
  final double height;
  final double? referenceLine;
  final double? maxY;
  const DateBarChart({
    super.key,
    required this.bars,
    required this.yFormat,
    this.height = 180,
    this.referenceLine,
    this.maxY,
  });

  @override
  Widget build(BuildContext context) {
    if (bars.isEmpty) return SizedBox(height: height);
    final top = maxY ??
        [
              ...bars.map((b) => b.value),
              ...bars.map((b) => b.target ?? 0),
              referenceLine ?? 0,
            ].reduce(math.max) *
            1.12;
    final width = (220 / bars.length).clamp(3.0, 18.0);
    final labelEvery = math.max(1, (bars.length / 5).ceil());

    return Directionality(
      textDirection: TextDirection.ltr,
      child: SizedBox(
        height: height,
        child: BarChart(
          BarChartData(
            maxY: top <= 0 ? 1 : top,
            minY: 0,
            alignment: BarChartAlignment.spaceAround,
            gridData: FlGridData(
              drawVerticalLine: false,
              getDrawingHorizontalLine: (_) => const FlLine(color: AppColors.border, strokeWidth: 1),
            ),
            borderData: FlBorderData(show: false),
            extraLinesData: ExtraLinesData(horizontalLines: [
              if (referenceLine != null)
                HorizontalLine(y: referenceLine!, color: AppColors.danger, strokeWidth: 1.5, dashArray: [6, 4]),
            ]),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(),
              rightTitles: const AxisTitles(),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 42,
                  getTitlesWidget: (v, meta) => v == meta.max
                      ? const SizedBox.shrink()
                      : SideTitleWidget(meta: meta, child: Text(yFormat(v), style: _axisStyle)),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 26,
                  getTitlesWidget: (v, meta) {
                    final i = v.toInt();
                    if (i < 0 || i >= bars.length || (i % labelEvery != 0 && i != bars.length - 1)) {
                      return const SizedBox.shrink();
                    }
                    return SideTitleWidget(meta: meta, child: Text(shortDateLabel(bars[i].date), style: _axisStyle));
                  },
                ),
              ),
            ),
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (_) => AppColors.cardHigh,
                fitInsideHorizontally: true,
                fitInsideVertically: true,
                maxContentWidth: 200,
                getTooltipItem: (group, gi, rod, ri) {
                  final b = bars[group.x];
                  return BarTooltipItem(
                    '${chartDayLabel(context, b.date)}\n${b.tooltip ?? yFormat(b.value)}',
                    const TextStyle(color: AppColors.text, fontSize: 12, fontWeight: FontWeight.w600),
                  );
                },
              ),
            ),
            barGroups: [
              for (var i = 0; i < bars.length; i++)
                BarChartGroupData(x: i, barRods: [
                  BarChartRodData(
                    toY: bars[i].value,
                    color: bars[i].color,
                    width: width,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: bars[i].target != null,
                      toY: bars[i].target ?? 0,
                      color: AppColors.cardHigh,
                    ),
                  ),
                ]),
            ],
          ),
        ),
      ),
    );
  }
}

/// Coloured dot + label for chart legends.
class LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  final bool dashed;
  const LegendDot({super.key, required this.color, required this.label, this.dashed = false});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: dashed ? 14 : 10,
            height: dashed ? 3 : 10,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(dashed ? 1 : 5)),
          ),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
        ],
      );
}

/// Label + big value pair used in card headers.
class StatPill extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  const StatPill({super.key, required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: context.text.labelSmall?.copyWith(color: AppColors.textMuted)),
          const SizedBox(height: 2),
          Text(value,
              style: context.text.titleMedium?.copyWith(fontWeight: FontWeight.w800, color: color ?? AppColors.text)),
        ],
      );
}

/// Muted one-line message inside a card when there is nothing to plot.
class CardEmpty extends StatelessWidget {
  final IconData icon;
  final String text;
  final Widget? action;
  const CardEmpty({super.key, required this.icon, required this.text, this.action});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Icon(icon, size: 36, color: AppColors.textMuted),
            const SizedBox(height: 8),
            Text(text, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textMuted)),
            if (action != null) ...[const SizedBox(height: 8), action!],
          ],
        ),
      );
}
