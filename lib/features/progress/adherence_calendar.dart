/// Monthly adherence calendar (week starts Saturday, RTL-aware) + day details sheet.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:material_symbols_icons/symbols.dart';

import '../../core/navigation.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/context_ext.dart';
import '../../core/widgets/common.dart';
import '../../data/repositories/exercise_repository.dart';
import '../exercises/exercise_detail_screen.dart';
import 'progress_providers.dart';

/// Saturday-first weekday order (DateTime.weekday values).
const kSaturdayFirstWeekdays = [6, 7, 1, 2, 3, 4, 5];

/// Number of empty cells before day 1 in a Saturday-first grid.
int leadingBlanks(DateTime month) => (DateTime(month.year, month.month, 1).weekday - DateTime.saturday) % 7;

Color? dayStatusColor(DayStatus s) => switch (s) {
      DayStatus.completed => AppColors.primary,
      DayStatus.partial => AppColors.warning,
      DayStatus.missed => AppColors.danger,
      DayStatus.rest => AppColors.rest,
      _ => null,
    };

String dayStatusLabel(BuildContext context, DayStatus s) {
  final l = context.l10n;
  return switch (s) {
    DayStatus.completed => l.progLegendCompleted,
    DayStatus.partial => l.progLegendPartial,
    DayStatus.missed => l.progLegendMissed,
    DayStatus.rest => l.progStatusRestDay,
    DayStatus.today => l.progStatusToday,
    DayStatus.future => l.progStatusFuture,
    DayStatus.none => l.progStatusNone,
  };
}

class AdherenceCalendarCard extends ConsumerStatefulWidget {
  const AdherenceCalendarCard({super.key});

  @override
  ConsumerState<AdherenceCalendarCard> createState() => _AdherenceCalendarCardState();
}

class _AdherenceCalendarCardState extends ConsumerState<AdherenceCalendarCard> {
  late DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);

  void _shift(int delta) => setState(() => _month = DateTime(_month.year, _month.month + delta));

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final now = DateTime.now();
    final isCurrent = _month.year == now.year && _month.month == now.month;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final async = ref.watch(monthAdherenceProvider(_month));

    return SectionCard(
      title: l.progCalendarTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [
            IconButton(
              tooltip: l.progPrevMonth,
              icon: const Icon(Symbols.chevron_left_rounded), // mirrored automatically in RTL
              onPressed: () => _shift(-1),
            ),
            Expanded(
              child: Text(
                (DateFormat.yMMMM(context.lang)..useNativeDigits = false).format(_month),
                textAlign: TextAlign.center,
                style: context.text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            IconButton(
              tooltip: l.progNextMonth,
              icon: const Icon(Symbols.chevron_right_rounded),
              onPressed: isCurrent ? null : () => _shift(1),
            ),
          ]),
          const SizedBox(height: 4),
          GestureDetector(
            onHorizontalDragEnd: (d) {
              final v = d.primaryVelocity ?? 0;
              if (v.abs() < 200) return;
              // Swipe towards the start edge = next month (mirrored in RTL).
              final next = rtl ? v > 0 : v < 0;
              if (next && !isCurrent) _shift(1);
              if (!next) _shift(-1);
            },
            child: _MonthGrid(month: _month, data: async.value),
          ),
          const SizedBox(height: 12),
          Wrap(spacing: 14, runSpacing: 6, children: [
            for (final s in [DayStatus.completed, DayStatus.partial, DayStatus.missed, DayStatus.rest])
              Row(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(color: dayStatusColor(s), borderRadius: BorderRadius.circular(3)),
                ),
                const SizedBox(width: 6),
                Text(
                  switch (s) {
                    DayStatus.completed => l.progLegendCompleted,
                    DayStatus.partial => l.progLegendPartial,
                    DayStatus.missed => l.progLegendMissed,
                    _ => l.progLegendRest,
                  },
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ]),
          ]),
          const SizedBox(height: 12),
          if (async.value case final m?) _Summary(summary: m.summary),
        ],
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  final AdherenceSummary summary;
  const _Summary({required this.summary});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final pct = summary.percent;
    if (pct == null) {
      return Text(l.progAdherenceNone, style: const TextStyle(color: AppColors.textMuted));
    }
    final color = pct >= 80 ? AppColors.primary : (pct >= 50 ? AppColors.warning : AppColors.danger);
    return Row(children: [
      ProgressRing(
        value: pct,
        max: 100,
        size: 52,
        stroke: 6,
        color: color,
        center: Text('${pct.round()}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l.progAdherencePct('${pct.round()}'),
              style: TextStyle(fontWeight: FontWeight.w800, color: color, fontSize: 16)),
          Text(
            l.progAdherenceCounts('${summary.completed}', '${summary.partial}', '${summary.missed}'),
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
        ]),
      ),
    ]);
  }
}

class _MonthGrid extends StatelessWidget {
  final DateTime month;
  final MonthAdherence? data;
  const _MonthGrid({required this.month, required this.data});

  @override
  Widget build(BuildContext context) {
    final blanks = leadingBlanks(month);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final today = DateTime.now();
    final cells = <Widget>[
      for (final wd in kSaturdayFirstWeekdays)
        Center(
          child: Text(weekdayName(context, wd),
              style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w600)),
        ),
      for (var i = 0; i < blanks; i++) const SizedBox.shrink(),
      for (var d = 1; d <= daysInMonth; d++)
        _DayCell(
          day: DateTime(month.year, month.month, d),
          status: data?.days[DateTime(month.year, month.month, d)],
          isToday: today.year == month.year && today.month == month.month && today.day == d,
        ),
    ];
    // GridView lays cells out from the start edge, so Saturday sits on the right in RTL.
    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 6,
      crossAxisSpacing: 6,
      children: cells,
    );
  }
}

class _DayCell extends StatelessWidget {
  final DateTime day;
  final DayStatus? status;
  final bool isToday;
  const _DayCell({required this.day, required this.status, required this.isToday});

  @override
  Widget build(BuildContext context) {
    final color = status == null ? null : dayStatusColor(status!);
    final future = status == DayStatus.future;
    final fg = color == null
        ? (future ? AppColors.textMuted.withValues(alpha: 0.5) : AppColors.text)
        : (color == AppColors.rest ? AppColors.text : AppColors.onPrimary);
    return Semantics(
      button: true,
      label: '${day.day} ${status == null ? '' : dayStatusLabel(context, status!)}',
      child: Material(
        color: color ?? Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: isToday
              ? const BorderSide(color: AppColors.primary, width: 2)
              : (color == null && !future ? const BorderSide(color: AppColors.border) : BorderSide.none),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: future ? null : () => showDayDetailsSheet(context, day),
          child: Center(
            child: Text(
              '${day.day}',
              style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// Day details sheet
// =============================================================================

Future<void> showDayDetailsSheet(BuildContext context, DateTime day) => showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (context, scroll) => DayDetailsView(day: day, controller: scroll),
      ),
    );

class DayDetailsView extends ConsumerWidget {
  final DateTime day;
  final ScrollController? controller;
  const DayDetailsView({super.key, required this.day, this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final async = ref.watch(dayDetailsProvider(DateTime(day.year, day.month, day.day)));
    final title = (DateFormat.yMMMMEEEEd(context.lang)..useNativeDigits = false).format(day);
    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('${l.errorGeneric}\n$e')),
      data: (d) {
        final color = dayStatusColor(d.status);
        return ListView(
          controller: controller,
          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 24),
          children: [
            Row(children: [
              Expanded(
                child: Text(title, style: context.text.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              ),
              Chip(
                label: Text(dayStatusLabel(context, d.status)),
                backgroundColor: (color ?? AppColors.cardHigh).withValues(alpha: color == null ? 1 : 0.2),
                side: BorderSide(color: color ?? AppColors.border),
              ),
            ]),
            const SizedBox(height: 8),
            if (d.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Text(l.progDayNothing,
                    textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textMuted)),
              ),
            for (final s in d.sessions) _SessionTile(s),
            if (d.standaloneCardio.isNotEmpty)
              SectionCard(
                title: l.progDayCardio,
                child: Column(children: [for (final c in d.standaloneCardio) _CardioRow(c)]),
              ),
            if (d.mealCount > 0)
              SectionCard(
                title: l.progDayNutrition,
                trailing: Text(l.progMealsCount('${d.mealCount}'), style: const TextStyle(color: AppColors.textMuted)),
                child: Column(children: [
                  _maybeBar(l.calories, d.calories, d.calorieTarget, AppColors.primary, l.kcal),
                  _maybeBar(l.protein, d.protein, d.proteinTarget, AppColors.protein, l.gramsShort),
                  _kv(l.carbs, '${fmtNum(d.carbs.round())} ${l.gramsShort}'),
                  _kv(l.fat, '${fmtNum(d.fat.round())} ${l.gramsShort}'),
                ]),
              ),
            if (d.waterMl > 0 || d.sleepHours != null || d.weightKg != null || d.recovery != null)
              SectionCard(
                child: Column(children: [
                  if (d.waterMl > 0)
                    _maybeBar(l.progDayWater, d.waterMl.toDouble(), d.waterGoalMl, AppColors.water, l.mlShort),
                  if (d.sleepHours != null)
                    _kv(
                      l.progDaySleep,
                      '${fmtNum(d.sleepHours!, maxDecimals: 1)} ${l.hoursShort}'
                      '${d.sleepQuality == null ? '' : '  ·  ${'★' * d.sleepQuality!}'}',
                      icon: Symbols.bedtime_rounded,
                    ),
                  if (d.recovery != null) _kv(l.progDayRecovery, '${d.recovery}/100', icon: Symbols.favorite_rounded),
                  if (d.weightKg != null)
                    _kv(l.progDayWeight, '${fmtNum(d.weightKg!)} ${l.kg}', icon: Symbols.monitor_weight_rounded),
                ]),
              ),
          ],
        );
      },
    );
  }

  static Widget _kv(String k, String v, {IconData? icon}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [
          if (icon != null) ...[Icon(icon, size: 18, color: AppColors.textMuted), const SizedBox(width: 8)],
          Expanded(child: Text(k)),
          Text(v, style: const TextStyle(fontWeight: FontWeight.w700)),
        ]),
      );

  static Widget _maybeBar(String label, double value, int? target, Color color, String unit) =>
      target == null || target <= 0
          ? _kv(label, '${fmtNum(value.round())} $unit')
          : MacroBar(label: label, value: value.roundToDouble(), target: target.toDouble(), color: color, unit: unit);
}

class _SessionTile extends StatelessWidget {
  final DaySessionDetail s;
  const _SessionTile(this.s);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final session = s.session;
    final mins = session.startedAt != null && session.endedAt != null
        ? session.endedAt!.difference(session.startedAt!).inMinutes
        : null;
    final status = switch (session.status) {
      'completed' => DayStatus.completed,
      'partial' => DayStatus.partial,
      'missed' => DayStatus.missed,
      _ => null,
    };
    return SectionCard(
      title: (session.name?.trim().isNotEmpty ?? false) ? session.name! : l.progDayWorkout,
      trailing: Text(
        status == null ? l.progStatusInProgress : dayStatusLabel(context, status),
        style: TextStyle(color: status == null ? AppColors.info : dayStatusColor(status), fontWeight: FontWeight.w700),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(spacing: 14, runSpacing: 4, children: [
            if (mins != null) _meta(Symbols.timer_rounded, l.progDurationMin('$mins')),
            _meta(Symbols.stacked_bar_chart_rounded, l.progVolumeValue(fmtNum(s.volume.round()))),
            _meta(Symbols.format_list_numbered_rounded, l.progSetsCount('${s.setCount}')),
            if (s.prCount > 0) _meta(Symbols.trophy_rounded, l.progPrsCount('${s.prCount}'), color: AppColors.primary),
          ]),
          if (session.notes?.trim().isNotEmpty ?? false) ...[
            const SizedBox(height: 8),
            Text(session.notes!.trim(), style: const TextStyle(color: AppColors.textMuted, fontStyle: FontStyle.italic)),
          ],
          for (final e in s.exercises) ...[
            const Divider(height: 20),
            InkWell(
              onTap: () => push(context, ExerciseDetailScreen(exerciseId: e.exerciseId)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(children: [
                  Expanded(
                    child: Text(e.exercise?.name(context.lang) ?? l.progUnknownExercise,
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  Text(l.progVolumeValue(fmtNum(e.volume.round())),
                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                ]),
              ),
            ),
            const SizedBox(height: 6),
            Wrap(spacing: 6, runSpacing: 6, children: [for (final set in e.sets) _SetChip(set)]),
          ],
          for (final c in s.cardio) ...[const Divider(height: 20), _CardioRow(c)],
        ],
      ),
    );
  }

  Widget _meta(IconData icon, String text, {Color? color}) => Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 16, color: color ?? AppColors.textMuted),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 13, color: color ?? AppColors.textMuted)),
      ]);
}

class _SetChip extends StatelessWidget {
  final DaySetDetail set;
  const _SetChip(this.set);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final warm = set.setType == 'warmup';
    final tag = switch (set.setType) {
      'warmup' => l.progSetTypeWarmup,
      'drop' => l.progSetTypeDrop,
      'failure' => l.progSetTypeFailure,
      _ => null,
    };
    final text = '${fmtNum(set.weightKg)}×${set.reps}${set.rpe == null ? '' : ' @${fmtNum(set.rpe!)}'}';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: set.isPr ? AppColors.primary.withValues(alpha: 0.15) : AppColors.cardHigh,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: set.isPr ? AppColors.primary : AppColors.border),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Directionality(
          textDirection: TextDirection.ltr,
          child: Text(text,
              style: TextStyle(
                  fontWeight: FontWeight.w700, color: warm ? AppColors.textMuted : AppColors.text, fontSize: 13)),
        ),
        if (tag != null) ...[
          const SizedBox(width: 6),
          Text(tag, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
        ],
        if (set.isPr) ...[
          const SizedBox(width: 6),
          const Icon(Symbols.trophy_rounded, fill: 1, size: 14, color: AppColors.primary),
        ],
      ]),
    );
  }
}

class _CardioRow extends StatelessWidget {
  final CardioLog c;
  const _CardioRow(this.c);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Row(children: [
      const Icon(Symbols.sprint_rounded, size: 18, color: AppColors.info),
      const SizedBox(width: 8),
      Expanded(child: Text(cardioTypeLabel(context, c.type), style: const TextStyle(fontWeight: FontWeight.w600))),
      Text(
        [
          l.progDurationMin(fmtNum(c.durationMin.round())),
          if (c.calories != null) '${fmtNum(c.calories!.round())} ${l.kcal}',
        ].join(' · '),
        style: const TextStyle(color: AppColors.textMuted),
      ),
    ]);
  }
}

String cardioTypeLabel(BuildContext context, String type) {
  final l = context.l10n;
  return switch (type) {
    'treadmill' => l.progCardioTreadmill,
    'bike' => l.progCardioBike,
    'elliptical' => l.progCardioElliptical,
    'rowing' => l.progCardioRowing,
    'walk' => l.progCardioWalk,
    'run' => l.progCardioRun,
    'stairs' => l.progCardioStairs,
    'jump_rope' => l.progCardioJumpRope,
    'swim' => l.progCardioSwim,
    _ => l.progDayCardio,
  };
}
