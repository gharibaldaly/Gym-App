import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/context_ext.dart';

/// "7h 25m" / "7س 25د".
String fmtSleep(BuildContext context, int minutes) =>
    context.l10n.trkHoursMinutes(minutes ~/ 60, minutes.remainder(60));

/// Short date ("Oct 20" / "20 أكتوبر").
String fmtDay(BuildContext context, DateTime d) => DateFormat.MMMd(context.lang).format(d);

/// Date with weekday ("Mon, Oct 20").
String fmtDayLong(BuildContext context, DateTime d) => DateFormat.MMMEd(context.lang).format(d);

String fmtTime(BuildContext context, DateTime d) => DateFormat.Hm(context.lang).format(d);

String fmtDateTime(BuildContext context, DateTime d) => DateFormat.MMMd(context.lang).add_Hm().format(d);

/// Parses "82,5" or "82.5" (also Arabic-Indic digits).
double? parseNum(String s) {
  const arabic = '٠١٢٣٤٥٦٧٨٩';
  final buf = StringBuffer();
  for (final ch in s.trim().split('')) {
    final i = arabic.indexOf(ch);
    buf.write(i >= 0 ? '$i' : (ch == ',' || ch == '٫' ? '.' : ch));
  }
  return double.tryParse(buf.toString());
}

final numberInputFormatters = [FilteringTextInputFormatter.allow(RegExp(r'[0-9٠-٩.,٫]'))];

/// Asks for a single number. Returns null when cancelled.
Future<double?> askNumber(
  BuildContext context, {
  required String title,
  required String label,
  double? initial,
  double min = 0,
  double max = 100000,
  bool decimals = true,
}) {
  final ctrl = TextEditingController(text: initial == null ? '' : fmtNum(initial, maxDecimals: 2));
  String? error;
  return showDialog<double>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) {
        void submit() {
          final v = parseNum(ctrl.text);
          if (v == null || v < min || v > max || (!decimals && v != v.roundToDouble())) {
            setState(() => error = ctx.l10n.trkInvalidNumber);
            return;
          }
          Navigator.pop(ctx, v);
        }

        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: ctrl,
            autofocus: true,
            keyboardType: TextInputType.numberWithOptions(decimal: decimals),
            inputFormatters: numberInputFormatters,
            decoration: InputDecoration(labelText: label, errorText: error),
            onSubmitted: (_) => submit(),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text(ctx.l10n.cancel)),
            FilledButton(onPressed: submit, child: Text(ctx.l10n.save)),
          ],
        );
      },
    ),
  ).whenComplete(ctrl.dispose);
}

Future<bool> confirmDelete(BuildContext context, String message) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      content: Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(ctx.l10n.cancel)),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AppColors.danger, foregroundColor: AppColors.onDanger),
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(ctx.l10n.delete),
        ),
      ],
    ),
  );
  return ok ?? false;
}

/// Picks a day (default range: last 2 years → today).
Future<DateTime?> pickDay(BuildContext context, DateTime initial) {
  final now = DateTime.now();
  return showDatePicker(
    context: context,
    initialDate: initial.isAfter(now) ? now : initial,
    firstDate: DateTime(now.year - 3),
    lastDate: now,
  ).then((d) => d == null ? null : DateTime(d.year, d.month, d.day));
}

/// Tappable row showing a date that opens a date picker.
class DateField extends StatelessWidget {
  final String label;
  final DateTime value;
  final ValueChanged<DateTime> onChanged;
  const DateField({super.key, required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Symbols.event_rounded),
      title: Text(label),
      trailing: Text(fmtDayLong(context, value), style: context.text.titleSmall),
      onTap: () async {
        final d = await pickDay(context, value);
        if (d != null) onChanged(d);
      },
    );
  }
}

/// Horizontal stacked bar of sleep stages with legend.
class SleepStagesBar extends StatelessWidget {
  final int? deep;
  final int? rem;
  final int? light;
  final int? awake;
  const SleepStagesBar({super.key, this.deep, this.rem, this.light, this.awake});

  static const deepColor = Color(0xFF3D5AFE);
  static const remColor = Color(0xFFB388FF);
  static const lightColor = Color(0xFF64B5F6);
  static const awakeColor = AppColors.warning;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final parts = [
      (l.trkStageDeep, deep ?? 0, deepColor),
      (l.trkStageRem, rem ?? 0, remColor),
      (l.trkStageLight, light ?? 0, lightColor),
      (l.trkStageAwake, awake ?? 0, awakeColor),
    ].where((p) => p.$2 > 0).toList();
    if (parts.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: SizedBox(
            height: 14,
            child: Row(
              children: [
                for (final p in parts) Expanded(flex: p.$2, child: ColoredBox(color: p.$3)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 14,
          runSpacing: 4,
          children: [
            for (final p in parts)
              Row(mainAxisSize: MainAxisSize.min, children: [
                Container(width: 10, height: 10, decoration: BoxDecoration(color: p.$3, shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Text('${p.$1} ${fmtSleep(context, p.$2)}', style: context.text.bodySmall),
              ]),
          ],
        ),
      ],
    );
  }
}

/// Simple 7-day bar chart (values per day, oldest first) with an optional goal line.
class WeekBars extends StatelessWidget {
  final List<double?> values;
  final DateTime lastDay;
  final double? goal;
  final Color color;
  final String Function(double v)? tooltip;
  const WeekBars({
    super.key,
    required this.values,
    required this.lastDay,
    this.goal,
    this.color = AppColors.primary,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final maxV = [...values.whereType<double>(), goal ?? 0].fold(0.0, math.max);
    final top = maxV <= 0 ? 1.0 : maxV * 1.15;
    final n = values.length;
    return SizedBox(
      height: 160,
      child: BarChart(
        BarChartData(
          maxY: top,
          minY: 0,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          extraLinesData: goal == null
              ? null
              : ExtraLinesData(horizontalLines: [
                  HorizontalLine(y: goal!, color: AppColors.textMuted, strokeWidth: 1, dashArray: [4, 4]),
                ]),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                getTitlesWidget: (v, meta) {
                  final i = v.toInt();
                  final d = DateTime(lastDay.year, lastDay.month, lastDay.day - (n - 1 - i));
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(weekdayName(context, d.weekday),
                        style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                  );
                },
              ),
            ),
          ),
          barTouchData: BarTouchData(
            enabled: tooltip != null,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => AppColors.cardHigh,
              getTooltipItem: (group, _, rod, _) =>
                  BarTooltipItem(tooltip?.call(rod.toY) ?? '', const TextStyle(color: AppColors.text, fontSize: 12)),
            ),
          ),
          barGroups: [
            for (var i = 0; i < n; i++)
              BarChartGroupData(x: i, barRods: [
                BarChartRodData(
                  toY: values[i] ?? 0,
                  width: 18,
                  color: goal != null && (values[i] ?? 0) >= goal! ? color : color.withValues(alpha: 0.55),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                ),
              ]),
          ],
        ),
      ),
    );
  }
}

/// Line chart over dates: optional raw points (dots) + a main line.
class DateLineChart extends StatelessWidget {
  final List<(DateTime, double)> line;
  final List<(DateTime, double)> dots;
  final Color color;
  final String Function(double v) format;
  final double height;
  const DateLineChart({
    super.key,
    required this.line,
    this.dots = const [],
    this.color = AppColors.primary,
    required this.format,
    this.height = 220,
  });

  @override
  Widget build(BuildContext context) {
    final all = [...line, ...dots];
    if (all.isEmpty) return SizedBox(height: height);
    final first = all.map((e) => e.$1).reduce((a, b) => a.isBefore(b) ? a : b);
    double x(DateTime d) => d.difference(first).inHours / 24.0;
    var minY = all.map((e) => e.$2).reduce(math.min);
    var maxY = all.map((e) => e.$2).reduce(math.max);
    final pad = math.max((maxY - minY) * 0.15, 0.5);
    minY -= pad;
    maxY += pad;
    final maxX = math.max(1.0, all.map((e) => x(e.$1)).reduce(math.max));
    final lang = context.lang;

    return SizedBox(
      height: height,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: maxX,
            minY: minY,
            maxY: maxY,
            gridData: FlGridData(
              drawVerticalLine: false,
              getDrawingHorizontalLine: (_) => const FlLine(color: AppColors.border, strokeWidth: 1),
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (v, meta) {
                    if (v == meta.min || v == meta.max) return const SizedBox.shrink();
                    return SideTitleWidget(
                      meta: meta,
                      child: Text(fmtNum(v), style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 24,
                  interval: math.max(1.0, (maxX / 4).ceilToDouble()),
                  getTitlesWidget: (v, meta) {
                    if (v == meta.max && v != 0 && maxX > 1) return const SizedBox.shrink();
                    final d = first.add(Duration(hours: (v * 24).round()));
                    return SideTitleWidget(
                      meta: meta,
                      child: Text(DateFormat.Md(lang).format(d),
                          style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                    );
                  },
                ),
              ),
            ),
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (_) => AppColors.cardHigh,
                getTooltipItems: (spots) => [
                  for (final s in spots)
                    LineTooltipItem(
                      '${DateFormat.MMMd(lang).format(first.add(Duration(hours: (s.x * 24).round())))}\n${format(s.y)}',
                      TextStyle(color: s.bar.color ?? AppColors.text, fontSize: 12),
                    ),
                ],
              ),
            ),
            lineBarsData: [
              if (dots.isNotEmpty)
                LineChartBarData(
                  spots: [for (final p in dots) FlSpot(x(p.$1), p.$2)],
                  color: AppColors.textMuted,
                  barWidth: 0,
                  dotData: FlDotData(
                    getDotPainter: (_, _, _, _) =>
                        FlDotCirclePainter(radius: 2.5, color: AppColors.textMuted, strokeWidth: 0),
                  ),
                ),
              LineChartBarData(
                spots: [for (final p in line) FlSpot(x(p.$1), p.$2)],
                color: color,
                barWidth: 3,
                isCurved: line.length > 2,
                preventCurveOverShooting: true,
                dotData: FlDotData(show: line.length < 15),
                belowBarData: BarAreaData(show: true, color: color.withValues(alpha: 0.08)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small colored legend dot + label.
class LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const LegendDot({super.key, required this.color, required this.label});

  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: context.text.bodySmall),
      ]);
}

/// Info banner (tips, reminders).
class InfoBanner extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final Widget? action;
  const InfoBanner({super.key, required this.icon, required this.text, this.color = AppColors.info, this.action});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(14, 12, 8, 12),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Expanded(child: Text(text, style: context.text.bodyMedium)),
            ?action,
          ],
        ),
      ),
    );
  }
}
