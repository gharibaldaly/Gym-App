/// The chart cards of the Progress tab. All of them follow the shared period filter.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/calc/stats.dart';
import '../../../core/navigation.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/context_ext.dart';
import '../../../core/widgets/common.dart';
import '../../../data/repositories/exercise_repository.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../exercises/exercise_detail_screen.dart';
import '../../exercises/exercise_labels.dart';
import '../../tracking/tracking_screens.dart';
import '../progress_providers.dart';
import 'chart_kit.dart';

Widget _loading() => const Padding(
      padding: EdgeInsets.symmetric(vertical: 32),
      child: Center(child: CircularProgressIndicator()),
    );

Widget _error(BuildContext context, Object e) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text('${context.l10n.errorGeneric}\n$e', style: const TextStyle(color: AppColors.danger)),
    );

String _kg(BuildContext context, num v) => '${fmtNum(v)} ${context.l10n.kg}';

String _signed(num v, {int decimals = 1}) => '${v > 0 ? '+' : ''}${fmtNum(v, maxDecimals: decimals)}';

/// Daily points → weekly averages when the span is long (keeps bars readable).
List<DatedValue> _maybeWeekly(List<DatedValue> pts) {
  if (pts.length < 2) return pts;
  final span = pts.last.date.difference(pts.first.date).inDays;
  if (span <= 62) return pts;
  final acc = <DateTime, List<double>>{};
  for (final p in pts) {
    acc.putIfAbsent(weekStartSat(p.date), () => []).add(p.value);
  }
  final keys = acc.keys.toList()..sort();
  return [for (final k in keys) DatedValue(k, Stats.mean(acc[k]!)!)];
}

bool _isWeekly(List<DatedValue> pts) => pts.length >= 2 && pts.last.date.difference(pts.first.date).inDays > 62;

// =============================================================================
// (a) Per-exercise progress
// =============================================================================

class ExerciseProgressCard extends ConsumerWidget {
  const ExerciseProgressCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final logged = ref.watch(loggedExercisesProvider);
    final id = ref.watch(effectiveProgressExerciseProvider);

    return SectionCard(
      title: l.progExerciseTitle,
      trailing: id == null
          ? null
          : IconButton(
              tooltip: l.progOpenExercise,
              icon: const Icon(Icons.open_in_new, size: 20),
              onPressed: () => push(context, ExerciseDetailScreen(exerciseId: id)),
            ),
      child: logged.when(
        loading: _loading,
        error: (e, _) => _error(context, e),
        data: (list) {
          if (list.isEmpty || id == null) {
            return CardEmpty(icon: Icons.show_chart, text: l.progNoExerciseData);
          }
          final current = list.where((e) => e.exercise.id == id).firstOrNull ?? list.first;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ExercisePickerButton(name: current.exercise.name(context.lang), list: list),
              const SizedBox(height: 12),
              _ExerciseChart(exerciseId: current.exercise.id),
            ],
          );
        },
      ),
    );
  }
}

class _ExercisePickerButton extends ConsumerWidget {
  final String name;
  final List<LoggedExercise> list;
  const _ExercisePickerButton({required this.name, required this.list});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: AppColors.cardHigh,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          final picked = await showModalBottomSheet<String>(
            context: context,
            isScrollControlled: true,
            showDragHandle: true,
            builder: (_) => _ExercisePickerSheet(list: list),
          );
          if (picked != null) ref.read(selectedProgressExerciseProvider.notifier).select(picked);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(children: [
            const Icon(Icons.fitness_center, color: AppColors.primary, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            ),
            Text(context.l10n.progChangeExercise, style: const TextStyle(color: AppColors.primary)),
            const Icon(Icons.expand_more, color: AppColors.primary),
          ]),
        ),
      ),
    );
  }
}

class _ExercisePickerSheet extends StatefulWidget {
  final List<LoggedExercise> list;
  const _ExercisePickerSheet({required this.list});

  @override
  State<_ExercisePickerSheet> createState() => _ExercisePickerSheetState();
}

class _ExercisePickerSheetState extends State<_ExercisePickerSheet> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final q = _q.trim().toLowerCase();
    final items = q.isEmpty
        ? widget.list
        : widget.list
            .where((e) => e.exercise.nameEn.toLowerCase().contains(q) || e.exercise.nameAr.contains(_q.trim()))
            .toList();
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scroll) => Column(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
            child: Text(l.progPickExercise, style: context.text.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              autofocus: false,
              decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: l.progSearchExercise),
              onChanged: (v) => setState(() => _q = v),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: items.isEmpty
                ? Center(child: Text(l.progNoMatches, style: const TextStyle(color: AppColors.textMuted)))
                : ListView.builder(
                    controller: scroll,
                    itemCount: items.length,
                    itemBuilder: (context, i) {
                      final e = items[i];
                      final muscles = e.exercise.primaryMuscles.map((m) => muscleShortLabel(m, context.lang)).join('، ');
                      return ListTile(
                        minTileHeight: 60,
                        title: Text(e.exercise.name(context.lang)),
                        subtitle: Text(
                          [if (muscles.isNotEmpty) muscles, l.progLastTrained(chartDayLabel(context, e.lastLogged))]
                              .join(' · '),
                          style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                        ),
                        trailing: Text(l.progSetsLogged('${e.sets}'),
                            style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                        onTap: () => Navigator.pop(context, e.exercise.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseChart extends ConsumerWidget {
  final String exerciseId;
  const _ExerciseChart({required this.exerciseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return ref.watch(exerciseProgressProvider(exerciseId)).when(
          loading: _loading,
          error: (e, _) => _error(context, e),
          data: (pts) {
            if (pts.isEmpty) return CardEmpty(icon: Icons.event_busy, text: l.progNoDataInPeriod);
            final bestTop = pts.reduce((a, b) =>
                b.topWeight > a.topWeight || (b.topWeight == a.topWeight && b.topReps > a.topReps) ? b : a);
            final bestE = pts.map((p) => p.bestE1rm).reduce((a, b) => a > b ? a : b);
            final change = pts.length < 2 ? null : pts.last.bestE1rm - pts.first.bestE1rm;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  spacing: 20,
                  runSpacing: 8,
                  children: [
                    StatPill(label: l.progTopSet, value: '${_kg(context, bestTop.topWeight)} × ${bestTop.topReps}'),
                    StatPill(label: '${l.progBest} ${l.progE1rm}', value: _kg(context, bestE.round())),
                    if (change != null)
                      StatPill(
                        label: l.progChange,
                        value: '${_signed(change.round())} ${l.kg}',
                        color: change > 0 ? AppColors.primary : (change < 0 ? AppColors.danger : null),
                      ),
                    StatPill(label: l.progSessionsLabel, value: '${pts.length}'),
                  ],
                ),
                const SizedBox(height: 16),
                DateLineChart(
                  yFormat: (v) => fmtNum(v.round()),
                  series: [
                    ChartSeries(
                      label: l.progE1rm,
                      points: [for (final p in pts) DatedValue(p.date, p.bestE1rm)],
                      color: AppColors.info,
                      dashed: true,
                      showDots: pts.length < 40,
                    ),
                    ChartSeries(
                      label: l.progTopSet,
                      points: [for (final p in pts) DatedValue(p.date, p.topWeight)],
                      color: AppColors.primary,
                      area: true,
                      showDots: pts.length < 40,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(spacing: 16, children: [
                  LegendDot(color: AppColors.primary, label: l.progTopSet),
                  LegendDot(color: AppColors.info, label: l.progE1rm, dashed: true),
                ]),
              ],
            );
          },
        );
  }
}

// =============================================================================
// (b) Weekly volume per muscle + effective sets
// =============================================================================

class MuscleVolumeCard extends ConsumerWidget {
  const MuscleVolumeCard({super.key});

  Color _setsColor(double s) {
    if (s >= 10 && s <= 20) return AppColors.primary;
    if (s > 20) return AppColors.info;
    if (s >= 6) return AppColors.warning;
    return AppColors.textMuted;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return SectionCard(
      title: l.progVolumeTitle,
      child: ref.watch(muscleVolumeProvider).when(
            loading: _loading,
            error: (e, _) => _error(context, e),
            data: (d) {
              if (d.isEmpty) return CardEmpty(icon: Icons.bar_chart, text: l.progNoVolumeData);
              final maxV = d.muscles.map((m) => m.avgWeeklyVolume).fold(0.0, (a, b) => a > b ? a : b);
              final muted = context.text.labelSmall?.copyWith(color: AppColors.textMuted);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l.progAvgPerWeek('${d.days}'), style: muted),
                  const SizedBox(height: 12),
                  Row(children: [
                    SizedBox(width: 92, child: Text(l.progMuscleCol, style: muted)),
                    const Spacer(),
                    SizedBox(width: 72, child: Text(l.progVolumeCol, style: muted, textAlign: TextAlign.end)),
                    SizedBox(width: 64, child: Text(l.progSetsCol, style: muted, textAlign: TextAlign.end)),
                  ]),
                  const SizedBox(height: 6),
                  for (final m in d.muscles)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(children: [
                        SizedBox(
                          width: 92,
                          child: Text(muscleShortLabel(m.muscle, context.lang),
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              height: 14,
                              color: AppColors.cardHigh,
                              alignment: AlignmentDirectional.centerStart,
                              child: FractionallySizedBox(
                                widthFactor: maxV <= 0 ? 0 : (m.avgWeeklyVolume / maxV).clamp(0.0, 1.0),
                                child: Container(color: AppColors.primary),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 72,
                          child: Text(fmtNum(m.avgWeeklyVolume.round()),
                              textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.w600)),
                        ),
                        SizedBox(
                          width: 64,
                          child: Text(
                            fmtNum(m.avgWeeklyEffectiveSets, maxDecimals: 1),
                            textAlign: TextAlign.end,
                            style: TextStyle(fontWeight: FontWeight.w800, color: _setsColor(m.avgWeeklyEffectiveSets)),
                          ),
                        ),
                      ]),
                    ),
                  const SizedBox(height: 8),
                  Text(l.progEffectiveSetsHint, style: muted),
                  if (d.weeklyTotals.length >= 2) ...[
                    const SizedBox(height: 16),
                    Text(l.progWeeklyTotal, style: context.text.titleSmall),
                    const SizedBox(height: 8),
                    DateBarChart(
                      height: 160,
                      yFormat: _compact,
                      bars: [
                        for (final w in d.weeklyTotals)
                          ChartBar(date: w.date, value: w.value, tooltip: '${fmtNum(w.value.round())} ${l.kg}'),
                      ],
                    ),
                  ],
                ],
              );
            },
          ),
    );
  }
}

String _compact(double v) {
  if (v.abs() >= 1000000) return '${fmtNum(v / 1000000)}M';
  if (v.abs() >= 1000) return '${fmtNum(v / 1000)}k';
  return fmtNum(v.round());
}

// =============================================================================
// (c) Body weight + measurements
// =============================================================================

class BodyProgressCard extends ConsumerStatefulWidget {
  const BodyProgressCard({super.key});

  @override
  ConsumerState<BodyProgressCard> createState() => _BodyProgressCardState();
}

class _BodyProgressCardState extends ConsumerState<BodyProgressCard> {
  MeasureKind? _kind;

  String _measureLabel(MeasureKind k) {
    final l = context.l10n;
    return switch (k) {
      MeasureKind.waist => l.progMeasureWaist,
      MeasureKind.chest => l.progMeasureChest,
      MeasureKind.arm => l.progMeasureArm,
      MeasureKind.thigh => l.progMeasureThigh,
      MeasureKind.neck => l.progMeasureNeck,
      MeasureKind.hips => l.progMeasureHips,
      MeasureKind.bodyFat => l.progMeasureBodyFat,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return SectionCard(
      title: l.progBodyTitle,
      trailing: TextButton.icon(
        onPressed: () => push(context, const BodyWeightScreen()),
        icon: const Icon(Icons.add, size: 18),
        label: Text(l.progLogWeight),
      ),
      child: ref.watch(bodyWeightDataProvider).when(
            loading: _loading,
            error: (e, _) => _error(context, e),
            data: (d) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (d.daily.isEmpty)
                  CardEmpty(icon: Icons.monitor_weight_outlined, text: l.progNoWeightData)
                else ...[
                  Wrap(spacing: 20, runSpacing: 8, children: [
                    StatPill(label: l.progLatest, value: _kg(context, d.daily.last.value)),
                    StatPill(label: l.progMovingAvg, value: _kg(context, double.parse(d.avg7.last.value.toStringAsFixed(1)))),
                    if (d.avg7.length >= 2)
                      StatPill(
                        label: l.progChange,
                        value: '${_signed(d.avg7.last.value - d.avg7.first.value)} ${l.kg}',
                      ),
                  ]),
                  const SizedBox(height: 16),
                  DateLineChart(
                    yFormat: (v) => fmtNum(v, maxDecimals: 1),
                    series: [
                      ChartSeries(
                        label: l.progDaily,
                        points: d.daily,
                        color: AppColors.textMuted,
                        width: 1,
                        showDots: d.daily.length < 120,
                      ),
                      ChartSeries(
                        label: l.progMovingAvg,
                        points: d.avg7,
                        color: AppColors.primary,
                        curved: true,
                        showDots: false,
                        width: 3,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(spacing: 16, children: [
                    LegendDot(color: AppColors.textMuted, label: l.progDaily),
                    LegendDot(color: AppColors.primary, label: l.progMovingAvg),
                  ]),
                ],
                const Divider(height: 32),
                Row(children: [
                  Expanded(child: Text(l.progMeasurementsTitle, style: context.text.titleSmall)),
                  TextButton.icon(
                    onPressed: () => push(context, const BodyMeasurementsScreen()),
                    icon: const Icon(Icons.straighten, size: 18),
                    label: Text(l.progLogMeasurements),
                  ),
                ]),
                if (d.measurements.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(l.progNoMeasurementData, style: const TextStyle(color: AppColors.textMuted)),
                  )
                else
                  _measurements(d.measurements),
              ],
            ),
          ),
    );
  }

  Widget _measurements(Map<MeasureKind, List<DatedValue>> m) {
    final l = context.l10n;
    final kind = (_kind != null && m.containsKey(_kind)) ? _kind! : m.keys.first;
    final pts = m[kind]!;
    final unit = kind == MeasureKind.bodyFat ? '%' : l.cm;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            for (final k in m.keys)
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 8),
                child: ChoiceChip(
                  label: Text(_measureLabel(k)),
                  selected: k == kind,
                  onSelected: (_) => setState(() => _kind = k),
                ),
              ),
          ]),
        ),
        const SizedBox(height: 12),
        Wrap(spacing: 20, children: [
          StatPill(label: l.progLatest, value: '${fmtNum(pts.last.value)} $unit'),
          if (pts.length >= 2) StatPill(label: l.progChange, value: '${_signed(pts.last.value - pts.first.value)} $unit'),
        ]),
        const SizedBox(height: 12),
        DateLineChart(
          height: 160,
          yFormat: (v) => fmtNum(v, maxDecimals: 1),
          series: [ChartSeries(label: _measureLabel(kind), points: pts, color: AppColors.info)],
        ),
      ],
    );
  }
}

// =============================================================================
// (d) Calories & macros vs target
// =============================================================================

class NutritionProgressCard extends ConsumerWidget {
  const NutritionProgressCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final profile = ref.watch(profileProvider).value;
    return SectionCard(
      title: l.progNutritionTitle,
      child: ref.watch(nutritionDaysProvider).when(
            loading: _loading,
            error: (e, _) => _error(context, e),
            data: (days) {
              if (days.isEmpty) return CardEmpty(icon: Icons.restaurant, text: l.progNoNutritionData);
              double avg(double Function(NutritionDay) f) => Stats.mean(days.map(f))!;
              final withTarget = days.where((d) => d.calorieTarget != null).toList();
              final onTarget =
                  withTarget.where((d) => (d.calories - d.calorieTarget!).abs() <= d.calorieTarget! * 0.1).length;
              final daily = [for (final d in days) DatedValue(d.date, d.calories)];
              final weekly = _isWeekly(daily);
              final targets = {for (final d in days) d.date: d.calorieTarget};
              final bars = weekly
                  ? [
                      for (final w in _maybeWeekly(daily))
                        ChartBar(
                          date: w.date,
                          value: w.value,
                          target: profile?.calorieTarget?.toDouble(),
                          color: _calColor(w.value, profile?.calorieTarget?.toDouble()),
                          tooltip: '${fmtNum(w.value.round())} ${l.kcal}',
                        ),
                    ]
                  : [
                      for (final d in days)
                        ChartBar(
                          date: d.date,
                          value: d.calories,
                          target: targets[d.date]?.toDouble(),
                          color: _calColor(d.calories, targets[d.date]?.toDouble()),
                          tooltip:
                              '${fmtNum(d.calories.round())}${d.calorieTarget == null ? '' : ' / ${d.calorieTarget}'} ${l.kcal}',
                        ),
                    ];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l.progAvgPerDay('${days.length}'),
                      style: context.text.labelSmall?.copyWith(color: AppColors.textMuted)),
                  const SizedBox(height: 8),
                  _macro(context, l.calories, avg((d) => d.calories), profile?.calorieTarget, AppColors.primary, l.kcal),
                  _macro(context, l.protein, avg((d) => d.protein), profile?.proteinG, AppColors.protein, l.gramsShort),
                  _macro(context, l.carbs, avg((d) => d.carbs), profile?.carbsG, AppColors.carbs, l.gramsShort),
                  _macro(context, l.fat, avg((d) => d.fat), profile?.fatG, AppColors.fat, l.gramsShort),
                  const SizedBox(height: 16),
                  DateBarChart(
                    bars: bars,
                    yFormat: _compact,
                    referenceLine: profile?.calorieTarget?.toDouble(),
                  ),
                  const SizedBox(height: 8),
                  Wrap(spacing: 14, runSpacing: 6, children: [
                    LegendDot(color: AppColors.primary, label: l.progLegendOnTarget),
                    LegendDot(color: AppColors.warning, label: l.progLegendUnder),
                    LegendDot(color: AppColors.danger, label: l.progLegendOver),
                    if (profile?.calorieTarget != null)
                      LegendDot(color: AppColors.danger, label: l.progTarget, dashed: true),
                  ]),
                  if (weekly) ...[
                    const SizedBox(height: 6),
                    Text(l.progWeeklyBarsNote, style: context.text.labelSmall?.copyWith(color: AppColors.textMuted)),
                  ],
                  if (withTarget.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(l.progDaysOnTarget('$onTarget', '${withTarget.length}'), style: context.text.bodySmall),
                  ],
                ],
              );
            },
          ),
    );
  }

  static Color _calColor(double v, double? target) {
    if (target == null || target <= 0) return AppColors.primary;
    if ((v - target).abs() <= target * 0.1) return AppColors.primary;
    return v < target ? AppColors.warning : AppColors.danger;
  }

  Widget _macro(BuildContext context, String label, double value, int? target, Color color, String unit) {
    if (target == null || target <= 0) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(children: [
          Expanded(child: Text(label)),
          Text('${fmtNum(value.round())} $unit', style: const TextStyle(color: AppColors.textMuted)),
        ]),
      );
    }
    return MacroBar(label: label, value: value.roundToDouble(), target: target.toDouble(), color: color, unit: unit);
  }
}

// =============================================================================
// (e) Sleep + recovery
// =============================================================================

class SleepRecoveryCard extends ConsumerWidget {
  const SleepRecoveryCard({super.key});

  static Color recoveryColor(num v) {
    if (v >= 67) return AppColors.primary;
    if (v >= 34) return AppColors.warning;
    return AppColors.danger;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return SectionCard(
      title: l.progSleepTitle,
      trailing: IconButton(
        tooltip: l.progDaySleep,
        icon: const Icon(Icons.bedtime_outlined, size: 20),
        onPressed: () => push(context, const SleepLogScreen()),
      ),
      child: ref.watch(sleepDaysProvider).when(
            loading: _loading,
            error: (e, _) => _error(context, e),
            data: (days) {
              final sleep = [for (final d in days) if (d.hours != null) DatedValue(d.date, d.hours!)];
              final rec = [for (final d in days) if (d.recovery != null) DatedValue(d.date, d.recovery!.toDouble())];
              if (sleep.isEmpty && rec.isEmpty) return CardEmpty(icon: Icons.bedtime, text: l.progNoSleepData);
              final avgSleep = Stats.mean(sleep.map((s) => s.value));
              final avgRec = Stats.mean(rec.map((s) => s.value));
              final sleepBars = _maybeWeekly(sleep);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(spacing: 24, runSpacing: 8, children: [
                    if (avgSleep != null)
                      StatPill(label: l.progAvgSleep, value: '${fmtNum(avgSleep, maxDecimals: 1)} ${l.hoursShort}'),
                    if (avgRec != null)
                      StatPill(label: l.progAvgRecovery, value: '${avgRec.round()}', color: recoveryColor(avgRec)),
                  ]),
                  if (sleep.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(l.progSleepHours, style: context.text.titleSmall),
                    const SizedBox(height: 8),
                    DateBarChart(
                      height: 150,
                      yFormat: (v) => fmtNum(v, maxDecimals: 1),
                      bars: [
                        for (final s in sleepBars)
                          ChartBar(
                            date: s.date,
                            value: s.value,
                            color: s.value >= 7 ? AppColors.info : AppColors.warning,
                            tooltip: '${fmtNum(s.value, maxDecimals: 1)} ${l.hoursShort}',
                          ),
                      ],
                    ),
                    if (_isWeekly(sleep))
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(l.progWeeklyBarsNote,
                            style: context.text.labelSmall?.copyWith(color: AppColors.textMuted)),
                      ),
                  ],
                  if (rec.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(l.progRecoveryScore, style: context.text.titleSmall),
                    const SizedBox(height: 8),
                    DateLineChart(
                      height: 150,
                      minY: 0,
                      maxY: 100,
                      yFormat: (v) => fmtNum(v.round()),
                      series: [
                        ChartSeries(
                          label: l.progRecoveryScore,
                          points: rec,
                          color: AppColors.primary,
                          area: true,
                          showDots: rec.length < 60,
                        ),
                      ],
                    ),
                  ],
                ],
              );
            },
          ),
    );
  }
}
