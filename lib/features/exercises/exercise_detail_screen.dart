import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../core/navigation.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/context_ext.dart';
import '../../core/widgets/common.dart';
import '../../data/repositories/exercise_repository.dart';
import 'add_exercise_screen.dart';
import 'exercise_history.dart';
import 'exercise_labels.dart';
import 'exercise_library_screen.dart' show MuscleTag;
import 'exercise_providers.dart';
import 'widgets/body_map.dart';
import 'widgets/exercise_images.dart';

class ExerciseDetailScreen extends ConsumerWidget {
  final String exerciseId;
  const ExerciseDetailScreen({super.key, required this.exerciseId});

  Future<void> _delete(BuildContext context, WidgetRef ref, Exercise e) async {
    final l = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.exDeleteConfirm),
        content: Text(e.name(context.lang)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.delete),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    final deleted = await ref.read(exerciseRepositoryProvider).deleteCustom(e.id);
    if (!context.mounted) return;
    if (deleted) {
      context.snack(l.exDeleted);
      Navigator.of(context).pop();
    } else {
      context.snack(l.exDeleteInUse);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final async = ref.watch(exerciseByIdProvider(exerciseId));
    return async.when(
      loading: () => Scaffold(appBar: AppBar(), body: const Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(appBar: AppBar(), body: EmptyState(icon: Icons.error_outline, text: '$e')),
      data: (e) {
        if (e == null) {
          return Scaffold(appBar: AppBar(), body: EmptyState(icon: Icons.search_off, text: l.exNotFound));
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(e.name(context.lang), maxLines: 1, overflow: TextOverflow.ellipsis),
            actions: [
              IconButton(
                tooltip: e.isFavorite ? l.exFavoriteRemove : l.exFavoriteAdd,
                iconSize: 28,
                icon: Icon(
                  e.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: e.isFavorite ? AppColors.warning : null,
                ),
                onPressed: () {
                  HapticFeedback.selectionClick();
                  ref.read(exerciseRepositoryProvider).setFavorite(e.id, !e.isFavorite);
                },
              ),
              if (e.isCustom)
                PopupMenuButton<String>(
                  onSelected: (v) {
                    if (v == 'edit') push(context, AddExerciseScreen(editExerciseId: e.id));
                    if (v == 'delete') _delete(context, ref, e);
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(value: 'edit', child: Text(l.exEdit)),
                    PopupMenuItem(value: 'delete', child: Text(l.exDelete)),
                  ],
                ),
            ],
          ),
          body: _DetailBody(exercise: e),
        );
      },
    );
  }
}

class _DetailBody extends StatelessWidget {
  final Exercise exercise;
  const _DetailBody({required this.exercise});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lang = context.lang;
    final e = exercise;
    final other = lang == 'ar' ? e.nameEn : e.nameAr;
    final steps = e.instructions(lang);
    final mistakes = e.mistakes(lang);

    return ListView(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 32),
      children: [
        ExerciseStepImages(exercise: e),
        const SizedBox(height: 16),
        Text(e.name(lang), style: context.text.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
        if (other.isNotEmpty && other != e.name(lang))
          Text(other, style: context.text.titleSmall?.copyWith(color: AppColors.textMuted)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (e.equipment != null) _InfoChip(icon: Icons.fitness_center, label: equipmentLabel(e.equipment, lang)),
            if (e.movementPattern != null)
              _InfoChip(icon: Icons.swap_vert, label: movementPatternLabel(e.movementPattern, lang)),
            if (e.mechanic != null) _InfoChip(icon: Icons.hub_outlined, label: mechanicLabel(e.mechanic, lang)),
            if (e.level != null) _InfoChip(icon: Icons.signal_cellular_alt, label: levelLabel(e.level, lang)),
            if (e.isCustom) _InfoChip(icon: Icons.person_outline, label: l.exCustomBadge),
          ],
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: l.exMusclesWorked,
          child: Column(
            children: [
              BodyMap(primary: e.primaryMuscles, secondary: e.secondaryMuscles, height: 260, showLabels: true),
              const SizedBox(height: 12),
              const BodyMapLegend(),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                alignment: WrapAlignment.center,
                children: [
                  for (final m in e.primaryMuscles) MuscleTag(label: muscleLabel(m, lang), primary: true),
                  for (final m in e.secondaryMuscles) MuscleTag(label: muscleLabel(m, lang)),
                ],
              ),
            ],
          ),
        ),
        SectionCard(
          title: l.exHowTo,
          child: steps.isEmpty
              ? Text(l.exNoInstructions, style: const TextStyle(color: AppColors.textMuted))
              : Column(
                  children: [
                    for (var i = 0; i < steps.length; i++) _NumberedStep(n: i + 1, text: steps[i]),
                  ],
                ),
        ),
        if (mistakes.isNotEmpty)
          SectionCard(
            title: l.exCommonMistakes,
            child: Column(
              children: [
                for (final m in mistakes)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 20),
                        const SizedBox(width: 10),
                        Expanded(child: Text(m, style: const TextStyle(height: 1.4))),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        _HistorySection(exerciseId: e.id),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ]),
      );
}

class _NumberedStep extends StatelessWidget {
  final int n;
  final String text;
  const _NumberedStep({required this.n, required this.text});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 26,
              height: 26,
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              child: Text('$n',
                  style: const TextStyle(color: AppColors.onPrimary, fontWeight: FontWeight.w800, fontSize: 13)),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(text, style: const TextStyle(height: 1.45))),
          ],
        ),
      );
}

// ---------------------------------------------------------------------------
// History: last performance, PRs, chart.
// ---------------------------------------------------------------------------

class _HistorySection extends ConsumerWidget {
  final String exerciseId;
  const _HistorySection({required this.exerciseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final async = ref.watch(exerciseHistoryProvider(exerciseId));
    return SectionCard(
      title: l.exYourHistory,
      child: async.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (e, _) => Text('$e'),
        data: (h) {
          if (h.isEmpty) {
            return Row(children: [
              const Icon(Icons.history, color: AppColors.textMuted),
              const SizedBox(width: 10),
              Expanded(child: Text(l.exNoHistory, style: const TextStyle(color: AppColors.textMuted))),
            ]);
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _LastPerformance(perf: h.last!),
              const SizedBox(height: 16),
              _PrGrid(prs: h.prs),
              if (h.prs.repRecords.length > 1) ...[
                const SizedBox(height: 16),
                Text(l.exRepRecords, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                for (final r in h.prs.repRecords)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(children: [
                      Expanded(child: Text(l.exSetLine(fmtNum(r.weightKg), r.reps))),
                      Text(_date(context, r.date), style: context.text.bodySmall?.copyWith(color: AppColors.textMuted)),
                    ]),
                  ),
              ],
              const SizedBox(height: 16),
              Text(l.exProgressChart, style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              _ProgressChart(history: h),
            ],
          );
        },
      ),
    );
  }
}

String _date(BuildContext context, DateTime d) => DateFormat.yMMMd(context.lang).format(d);

class _LastPerformance extends StatelessWidget {
  final SessionPerformance perf;
  const _LastPerformance({required this.perf});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.cardHigh, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text(l.exLastPerformance, style: const TextStyle(fontWeight: FontWeight.w700)),
            const Spacer(),
            Text(_date(context, perf.date), style: context.text.bodySmall?.copyWith(color: AppColors.textMuted)),
          ]),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final s in perf.sets)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: s.isPr ? AppColors.primary : AppColors.border),
                  ),
                  child: Text(
                    l.exSetLine(fmtNum(s.weightKg), s.reps) + (s.rpe != null ? ' @${fmtNum(s.rpe!)}' : ''),
                    style: TextStyle(fontWeight: FontWeight.w600, color: s.isPr ? AppColors.primary : null),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(l.exSessionVolume(fmtNum(perf.volume, maxDecimals: 0)),
              style: context.text.bodySmall?.copyWith(color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

class _PrGrid extends StatelessWidget {
  final ExercisePrs prs;
  const _PrGrid({required this.prs});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    Widget tile(String title, String value, String? sub) => Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Icon(Icons.emoji_events, color: AppColors.primary, size: 16),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.text.labelSmall?.copyWith(color: AppColors.textMuted)),
                  ),
                ]),
                const SizedBox(height: 6),
                Text(value,
                    style: context.text.titleLarge?.copyWith(fontWeight: FontWeight.w800, color: AppColors.primary)),
                if (sub != null)
                  Text(sub, style: context.text.bodySmall?.copyWith(color: AppColors.textMuted), maxLines: 2),
              ],
            ),
          ),
        );
    final h = prs.heaviest;
    final b = prs.bestE1rm;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.exPersonalRecords, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Row(children: [
          tile(
            l.exHeaviest,
            h == null ? '–' : l.exKgValue(fmtNum(h.weightKg)),
            h == null ? null : '${l.exSetLine(fmtNum(h.weightKg), h.reps)}\n${_date(context, h.date)}',
          ),
          const SizedBox(width: 10),
          tile(
            l.exBestE1rm,
            b == null ? '–' : l.exKgValue(fmtNum(b.e1rm)),
            b == null ? null : '${l.exSetLine(fmtNum(b.weightKg), b.reps)}\n${_date(context, b.date)}',
          ),
        ]),
      ],
    );
  }
}

class _ProgressChart extends StatelessWidget {
  final ExerciseHistory history;
  const _ProgressChart({required this.history});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final sessions = history.sessions.where((s) => s.topWeight > 0).toList();
    if (sessions.length < 2) {
      return Text(l.exChartNeedMore, style: const TextStyle(color: AppColors.textMuted));
    }
    final first = sessions.first.date;
    double x(DateTime d) => d.difference(first).inHours / 24.0;
    final e1 = [for (final s in sessions) FlSpot(x(s.date), double.parse(s.bestE1rm.toStringAsFixed(1)))];
    final top = [for (final s in sessions) FlSpot(x(s.date), s.topWeight)];
    final maxY = sessions.map((s) => s.bestE1rm).reduce(math.max);
    final minY = sessions.map((s) => s.topWeight).reduce(math.min);
    final span = math.max(1.0, maxY - minY);
    final maxX = math.max(1.0, x(sessions.last.date));
    final fmt = DateFormat('d/M');

    LineChartBarData line(List<FlSpot> spots, Color c, {bool area = false}) => LineChartBarData(
          spots: spots,
          isCurved: true,
          preventCurveOverShooting: true,
          color: c,
          barWidth: 3,
          dotData: FlDotData(show: spots.length <= 20),
          belowBarData: BarAreaData(show: area, color: c.withValues(alpha: 0.10)),
        );

    Widget legend(Color c, String t) => Row(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 14, height: 4, decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 6),
          Text(t, style: context.text.bodySmall),
        ]);

    return Column(
      children: [
        Wrap(spacing: 16, children: [
          legend(AppColors.primary, l.exChartE1rm),
          legend(AppColors.info, l.exChartTopWeight),
        ]),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: maxX,
                minY: math.max(0, (minY - span * 0.15).floorToDouble()),
                maxY: (maxY + span * 0.15).ceilToDouble(),
                gridData: FlGridData(
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => const FlLine(color: AppColors.border, strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      minIncluded: false,
                      maxIncluded: false,
                      getTitlesWidget: (v, meta) => SideTitleWidget(
                        meta: meta,
                        child: Text(fmtNum(v), style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 26,
                      interval: math.max(1.0, maxX / 4),
                      getTitlesWidget: (v, meta) => SideTitleWidget(
                        meta: meta,
                        child: Text(
                          fmt.format(first.add(Duration(hours: (v * 24).round()))),
                          style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                        ),
                      ),
                    ),
                  ),
                ),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) => AppColors.cardHigh,
                    getTooltipItems: (spots) => [
                      for (final s in spots)
                        LineTooltipItem(
                          '${fmt.format(first.add(Duration(hours: (s.x * 24).round())))}  ${fmtNum(s.y)} ${l.kg}',
                          TextStyle(color: s.bar.color, fontWeight: FontWeight.w700, fontSize: 12),
                        ),
                    ],
                  ),
                ),
                lineBarsData: [
                  line(e1, AppColors.primary, area: true),
                  line(top, AppColors.info),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
