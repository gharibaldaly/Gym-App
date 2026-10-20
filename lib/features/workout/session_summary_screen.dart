import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../ai/ai_service.dart';
import '../../core/navigation.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/context_ext.dart';
import '../../core/widgets/common.dart';
import '../coach/coach_initiatives.dart';
import 'live_workout_screen.dart';
import 'post_workout.dart';
import 'widgets/workout_widgets.dart';
import 'workout_logic.dart';
import 'workout_repository.dart';

final _comparisonsProvider = FutureProvider.autoDispose.family<List<ExerciseComparison>, int>((ref, sessionId) async {
  // Recompute when sets change.
  ref.watch(sessionSetsProvider(sessionId));
  final repo = ref.watch(workoutRepositoryProvider);
  final s = await repo.session(sessionId);
  if (s == null) return const [];
  return compareWithPrevious(repo, s);
});

/// Post-workout summary and history detail: duration, volume, sets, PRs, comparison
/// with last time, notes, cardio and the coach's evaluation.
class SessionSummaryScreen extends ConsumerStatefulWidget {
  final int sessionId;

  /// True right after "Finish": triggers the coach summary + plateau checks once.
  final bool justFinished;
  const SessionSummaryScreen({super.key, required this.sessionId, this.justFinished = false});

  @override
  ConsumerState<SessionSummaryScreen> createState() => _SessionSummaryScreenState();
}

class _SessionSummaryScreenState extends ConsumerState<SessionSummaryScreen> {
  bool _requested = false;

  @override
  void initState() {
    super.initState();
    if (widget.justFinished) {
      _requested = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(runPostWorkout(
          coach: ref.read(coachInitiativesProvider),
          repo: ref.read(workoutRepositoryProvider),
          prefs: ref.read(sharedPrefsProvider),
          sessionId: widget.sessionId,
        ));
      });
    }
  }

  Future<void> _askCoach() async {
    setState(() => _requested = true);
    try {
      await ref.read(coachInitiativesProvider).onWorkoutFinished(widget.sessionId);
    } catch (e) {
      if (mounted) context.snack(aiErrorText(e, ar: context.isAr));
    }
  }

  Future<void> _delete(WorkoutSession s) async {
    final l = context.l10n;
    final ok = await confirmDialog(context, title: l.woDeleteSessionTitle, body: l.woDeleteSessionBody, confirm: l.delete, danger: true);
    if (!ok) return;
    await ref.read(workoutRepositoryProvider).deleteSession(s.id);
    if (mounted) Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final session = ref.watch(sessionProvider(widget.sessionId));
    final s = session.value;
    if (s == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: session.isLoading ? const CircularProgressIndicator() : Text(l.woSessionNotFound)),
      );
    }
    final sets = ref.watch(sessionSetsProvider(s.id)).value ?? const <SetLog>[];
    final cardio = ref.watch(sessionCardioProvider(s.id)).value ?? const <CardioLog>[];
    final notes = ref.watch(sessionNotesProvider(s.id)).value ?? const <SessionExerciseNote>[];
    final comps = ref.watch(_comparisonsProvider(s.id)).value ?? const <ExerciseComparison>[];
    final working = sets.where((x) => isWorkingSet(x.setType)).toList();
    final prs = sets.where((x) => x.isPr).toList();
    final volume = s.totalVolume ??
        sessionVolume(sets.map((x) => (weight: x.weightKg, reps: x.reps, setType: x.setType)));
    final duration = s.startedAt != null && s.endedAt != null ? s.endedAt!.difference(s.startedAt!) : null;
    final isToday = dayOf(s.date) == today();
    final dateText = DateFormat.yMMMMEEEEd(context.lang).format(s.date);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.justFinished ? l.woSummaryTitle : (s.name ?? l.woWorkout)),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'delete') _delete(s);
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'delete',
                child: ListTile(leading: const Icon(Icons.delete_outline, color: AppColors.danger), title: Text(l.woDeleteSession)),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Text(dateText, style: const TextStyle(color: AppColors.textMuted)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              Pill(sessionStatusLabel(context, s.status), color: sessionStatusColor(s.status), icon: sessionStatusIcon(s.status)),
              if (s.isDeload) Pill(l.woDeloadBadge, color: AppColors.info, icon: Icons.south),
              if (s.name != null && widget.justFinished) Pill(s.name!, color: AppColors.textMuted),
            ],
          ),
          if (s.status == SessionStatus.missed) ...[
            const SizedBox(height: 24),
            EmptyState(icon: Icons.event_busy, text: l.woMissedBody),
          ] else ...[
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.9,
              children: [
                StatTile(label: l.woDuration, value: duration == null ? '—' : fmtDuration(duration), icon: Icons.timer_outlined),
                StatTile(label: l.woTotalVolume, value: '${fmtNum(volume, maxDecimals: 0)} ${l.kg}', icon: Icons.stacked_bar_chart),
                StatTile(label: l.woWorkingSets, value: '${working.length}', icon: Icons.format_list_numbered),
                StatTile(label: l.woPrs, value: '${prs.length}', icon: Icons.emoji_events_outlined, color: AppColors.warning),
              ],
            ),
            if (prs.isNotEmpty)
              SectionCard(
                title: l.woNewRecords,
                trailing: const Icon(Icons.emoji_events, color: AppColors.warning),
                child: Column(
                  children: [
                    for (final p in prs)
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: ExerciseName(p.exerciseId),
                        subtitle: Text((p.prTypes ?? '').split(',').where((x) => x.isNotEmpty).map((x) => prTypeLabel(context, x)).join(' · ')),
                        trailing: Text(setText(context, p.weightKg, p.reps), style: const TextStyle(fontWeight: FontWeight.w700)),
                      ),
                  ],
                ),
              ),
            _CoachCard(session: s, requested: _requested, onAsk: _askCoach),
            for (final c in comps) _ExerciseSummaryCard(comparison: c, note: notes.where((n) => n.exerciseId == c.exerciseId).firstOrNull?.note),
            if (cardio.isNotEmpty)
              SectionCard(
                title: l.woCardio,
                child: Column(
                  children: [
                    for (final c in cardio)
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.directions_run, color: AppColors.primary),
                        title: Text(cardioTypeLabel(context, c.type)),
                        subtitle: Text(cardioDetails(context, c)),
                      ),
                  ],
                ),
              ),
            if ((s.notes ?? '').isNotEmpty) SectionCard(title: l.woSessionNotes, child: Text(s.notes!)),
            if (isToday) ...[
              const SizedBox(height: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: Text(l.woContinueWorkout),
                onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => LiveWorkoutScreen(sessionId: s.id, planDayId: s.planDayId)),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _CoachCard extends ConsumerWidget {
  final WorkoutSession session;
  final bool requested;
  final VoidCallback onAsk;
  const _CoachCard({required this.session, required this.requested, required this.onAsk});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final hasKey = ref.watch(hasApiKeyProvider);
    final online = ref.watch(isOnlineProvider);
    Widget body;
    if ((session.aiSummary ?? '').isNotEmpty) {
      body = SelectableText(session.aiSummary!);
    } else if (!hasKey) {
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.woCoachNeedsKey, style: const TextStyle(color: AppColors.textMuted)),
          const SizedBox(height: 8),
          TextButton.icon(onPressed: () => openSettings(context), icon: const Icon(Icons.key), label: Text(l.addApiKey)),
        ],
      );
    } else if (!online) {
      body = Row(
        children: [
          const Icon(Icons.cloud_queue, color: AppColors.warning),
          const SizedBox(width: 8),
          Expanded(child: Text(l.woCoachQueued, style: const TextStyle(color: AppColors.textMuted))),
        ],
      );
    } else if (requested) {
      body = Row(
        children: [
          const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
          const SizedBox(width: 12),
          Expanded(child: Text(l.woCoachReviewing, style: const TextStyle(color: AppColors.textMuted))),
        ],
      );
    } else {
      body = Align(
        alignment: AlignmentDirectional.centerStart,
        child: OutlinedButton.icon(onPressed: onAsk, icon: const Icon(Icons.auto_awesome), label: Text(l.woAskCoach)),
      );
    }
    return SectionCard(
      title: l.woCoachEvaluation,
      trailing: const Icon(Icons.sports, color: AppColors.primary),
      child: body,
    );
  }
}

class _ExerciseSummaryCard extends StatelessWidget {
  final ExerciseComparison comparison;
  final String? note;
  const _ExerciseSummaryCard({required this.comparison, this.note});

  Widget _delta(BuildContext context, String label, double? pct) {
    if (pct == null) return const SizedBox.shrink();
    final up = pct > 0.5, down = pct < -0.5;
    final color = up ? AppColors.primary : (down ? AppColors.danger : AppColors.textMuted);
    final icon = up ? Icons.arrow_upward : (down ? Icons.arrow_downward : Icons.remove);
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          Text(' $label ${pct >= 0 ? '+' : ''}${pct.toStringAsFixed(1)}%', style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = comparison;
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ExerciseName(c.exerciseId, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final s in c.sets)
                Chip(
                  visualDensity: VisualDensity.compact,
                  avatar: s.isPr ? const Icon(Icons.emoji_events, size: 16, color: AppColors.warning) : null,
                  label: Text(
                    '${setText(context, s.weightKg, s.reps)}${s.rpe != null ? ' @${fmtNum(s.rpe!)}' : ''}'
                    '${s.setType != SetType.normal ? ' (${setTypeLabel(context, s.setType)})' : ''}',
                    style: TextStyle(color: s.setType == SetType.warmup ? AppColors.textMuted : null, fontSize: 13),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text('${l.woVolume}: ${fmtNum(c.volume, maxDecimals: 0)} ${l.kg}', style: const TextStyle(fontSize: 13)),
          if (c.prevVolume != null) ...[
            const SizedBox(height: 4),
            Text(
              l.woVsLastTime(
                c.prevBestSet == null ? '—' : setText(context, c.prevBestSet!.weightKg, c.prevBestSet!.reps),
                fmtNum(c.prevVolume!, maxDecimals: 0),
              ),
              style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Wrap(children: [_delta(context, l.woVolume, c.volumeDeltaPct), _delta(context, '1RM', c.e1rmDeltaPct)]),
          ] else
            Text(l.woFirstTime, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
          if ((note ?? '').isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.sticky_note_2_outlined, size: 16, color: AppColors.info),
                const SizedBox(width: 6),
                Expanded(child: Text(note!, style: const TextStyle(color: AppColors.info, fontSize: 13))),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

String cardioTypeLabel(BuildContext context, String type) {
  final l = context.l10n;
  return switch (type) {
    'treadmill' => l.woCardioTreadmill,
    'bike' => l.woCardioBike,
    'elliptical' => l.woCardioElliptical,
    'rowing' => l.woCardioRowing,
    'walk' => l.woCardioWalk,
    'run' => l.woCardioRun,
    'stairs' => l.woCardioStairs,
    'jump_rope' => l.woCardioJumpRope,
    'swim' => l.woCardioSwim,
    _ => l.woCardioOther,
  };
}

String cardioDetails(BuildContext context, CardioLog c) {
  final l = context.l10n;
  return [
    '${fmtNum(c.durationMin)} ${l.minutesShort}',
    if (c.speedKmh != null) '${fmtNum(c.speedKmh!)} ${l.woKmh}',
    if (c.inclinePct != null) '${l.woIncline} ${fmtNum(c.inclinePct!)}%',
    if (c.level != null) '${l.woLevel} ${c.level}',
    if (c.calories != null) '${fmtNum(c.calories!, maxDecimals: 0)} ${l.kcal}',
  ].join(' · ');
}
