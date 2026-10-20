import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/calc/progression.dart';
import '../../../core/navigation.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/context_ext.dart';
import '../../../core/widgets/common.dart';
import '../../../data/repositories/exercise_repository.dart';
import '../../exercises/exercise_detail_screen.dart';
import '../workout_logic.dart';
import '../workout_repository.dart';
import '../workout_suggestions.dart';
import 'plan_day_editor.dart' show RpeSelector;
import 'workout_widgets.dart';

typedef SaveSetFn = Future<void> Function(Exercise ex, double weight, int reps, double? rpe, String setType);

/// One exercise in the live workout: last time vs suggestion per set, quick set entry.
class LiveExerciseCard extends ConsumerStatefulWidget {
  final int index;
  final String exerciseId;
  final PlanExercise? planExercise;
  final int? sessionId;
  final List<SetLog> sets;
  final String? note;
  final bool expanded;
  final bool substituted;
  final VoidCallback onExpand;
  final SaveSetFn onSave;
  final void Function(int seconds) onRest;
  final void Function(Exercise ex) onSubstitute;
  final void Function(Exercise ex) onNote;
  /// Voice entry: the parent listens, confirms and saves the set.
  final Future<void> Function(Exercise ex) onVoice;
  final void Function(SetLog set) onDeleteSet;

  const LiveExerciseCard({
    super.key,
    required this.index,
    required this.exerciseId,
    required this.planExercise,
    required this.sessionId,
    required this.sets,
    required this.note,
    required this.expanded,
    required this.substituted,
    required this.onExpand,
    required this.onSave,
    required this.onRest,
    required this.onSubstitute,
    required this.onNote,
    required this.onVoice,
    required this.onDeleteSet,
  });

  @override
  ConsumerState<LiveExerciseCard> createState() => _LiveExerciseCardState();
}

class _LiveExerciseCardState extends ConsumerState<LiveExerciseCard> {
  ExerciseTarget? _target;
  double _weight = 0;
  int _reps = 8;
  double? _rpe;
  String _type = SetType.normal;
  bool _saving = false;

  List<SetLog> get _working => widget.sets.where((s) => isWorkingSet(s.setType)).toList();

  @override
  void initState() {
    super.initState();
    _loadTarget();
  }

  @override
  void didUpdateWidget(LiveExerciseCard old) {
    super.didUpdateWidget(old);
    if (old.exerciseId != widget.exerciseId || old.planExercise?.sets != widget.planExercise?.sets ||
        old.planExercise?.repMin != widget.planExercise?.repMin || old.planExercise?.repMax != widget.planExercise?.repMax) {
      _loadTarget();
    } else if (old.sets.length != widget.sets.length) {
      _prefill();
    }
  }

  Future<void> _loadTarget() async {
    final ex = await ref.read(exerciseRepositoryProvider).byId(widget.exerciseId);
    if (ex == null) return;
    final t = await computeExerciseTarget(
      repo: ref.read(workoutRepositoryProvider),
      prefs: ref.read(sharedPrefsProvider),
      ex: ex,
      pe: widget.planExercise,
      sessionId: widget.sessionId,
    );
    if (!mounted) return;
    setState(() => _target = t);
    _prefill();
  }

  void _prefill() {
    final t = _target;
    if (t == null) return;
    final next = _working.length;
    final s = t.suggestionFor(next);
    final lastLogged = widget.sets.isEmpty ? null : widget.sets.last;
    setState(() {
      if (s.reason == ProgressionReason.firstTime && s.weightKg <= 0 && lastLogged != null) {
        _weight = lastLogged.weightKg;
        _reps = lastLogged.reps;
      } else {
        _weight = s.weightKg;
        _reps = s.reps;
      }
      _type = SetType.normal;
      _rpe = null;
    });
  }

  void _copyLast() {
    final SetLog? src = widget.sets.isNotEmpty ? widget.sets.last : (_target?.lastSets.isNotEmpty == true ? _target!.lastSets[_working.length.clamp(0, _target!.lastSets.length - 1)] : null);
    if (src == null) {
      context.snack(context.l10n.woNothingToCopy);
      return;
    }
    setState(() {
      _weight = src.weightKg;
      _reps = src.reps;
      _rpe = src.rpe;
      _type = src.setType == SetType.warmup ? SetType.normal : src.setType;
    });
  }

  Future<void> _save(Exercise ex) async {
    if (_saving || _reps <= 0) return;
    setState(() => _saving = true);
    try {
      await widget.onSave(ex, _weight, _reps, _rpe, _type);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String _reasonText(BuildContext context, SetSuggestion s) {
    final l = context.l10n;
    return switch (s.reason) {
      ProgressionReason.increaseWeight => l.woReasonIncrease,
      ProgressionReason.addReps => l.woReasonAddReps,
      ProgressionReason.reduceWeight => l.woReasonReduce,
      ProgressionReason.deload => l.woReasonDeload,
      ProgressionReason.repeat => l.woReasonRepeat,
      ProgressionReason.firstTime => l.woReasonFirstTime,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final ex = ref.watch(workoutExerciseProvider(widget.exerciseId)).value;
    final t = _target;
    final working = _working;
    final planned = t?.sets ?? widget.planExercise?.sets ?? 3;
    final done = working.length >= planned;
    final pe = widget.planExercise;
    final name = ex?.name(context.lang) ?? widget.exerciseId.replaceAll('_', ' ');

    final targetParts = <String>[
      setsRepsText(planned, t?.repMin ?? pe?.repMin ?? 8, t?.repMax ?? pe?.repMax ?? 12),
      if ((t?.targetRpe ?? pe?.targetRpe) != null) 'RPE ${fmtNum((t?.targetRpe ?? pe?.targetRpe)!)}',
      '${l.woRest} ${restText(t?.restSeconds ?? pe?.restSeconds ?? 90)}',
    ];

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: widget.expanded ? AppColors.primary : (done ? AppColors.primaryDark : AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: widget.onExpand,
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 4, 8),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: done ? AppColors.primary : AppColors.cardHigh,
                    child: done
                        ? const Icon(Icons.check, size: 18, color: AppColors.onPrimary)
                        : Text('${widget.index + 1}', style: const TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => push(context, ExerciseDetailScreen(exerciseId: widget.exerciseId)),
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.textMuted,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(targetParts.join(' · '), style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              Pill('${working.length}/$planned', color: done ? AppColors.primary : AppColors.textMuted),
                              if (widget.substituted) Pill(l.woSubstituted, color: AppColors.info, icon: Icons.swap_horiz),
                              if (t?.deload == true) Pill(l.woDeloadBadge, color: AppColors.info),
                              if (t?.recovery != null && !(t!.recovery!.isNeutral))
                                Pill(l.woRecoveryAdjusted, color: AppColors.warning, icon: Icons.battery_alert),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (ex != null) ...[
                    IconButton(
                      tooltip: l.woSubstitute,
                      icon: const Icon(Icons.swap_horiz),
                      onPressed: () => widget.onSubstitute(ex),
                    ),
                    IconButton(
                      tooltip: l.woExerciseNote,
                      icon: Icon(widget.note == null ? Icons.sticky_note_2_outlined : Icons.sticky_note_2,
                          color: widget.note == null ? null : AppColors.info),
                      onPressed: () => widget.onNote(ex),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (widget.note != null)
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(56, 0, 12, 8),
              child: Text(widget.note!, style: const TextStyle(color: AppColors.info, fontSize: 13)),
            ),
          if (widget.expanded && ex != null) _buildBody(context, ex, t, working, planned),
          if (!widget.expanded && t != null && t.lastSets.isNotEmpty)
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(56, 0, 12, 12),
              child: Text(
                '${l.woLastTime}: ${t.lastSets.map((s) => setText(context, s.weightKg, s.reps)).join(', ')}',
                style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, Exercise ex, ExerciseTarget? t, List<SetLog> working, int planned) {
    final l = context.l10n;
    final rows = <Widget>[];
    var workingIdx = 0;
    for (final s in widget.sets) {
      final isW = isWorkingSet(s.setType);
      final label = isW ? '${++workingIdx}' : 'W';
      rows.add(_SetRow(
        label: label,
        main: setText(context, s.weightKg, s.reps) + (s.rpe != null ? '  @${fmtNum(s.rpe!)}' : ''),
        sub: s.setType == SetType.normal ? null : setTypeLabel(context, s.setType),
        done: true,
        pr: s.isPr,
        onLongPress: () => widget.onDeleteSet(s),
      ));
    }
    if (t != null) {
      for (var i = working.length; i < planned; i++) {
        final last = t.lastFor(i);
        final sug = t.suggestionFor(i);
        rows.add(_SetRow(
          label: '${i + 1}',
          main: sug.weightKg > 0 || sug.reason != ProgressionReason.firstTime
              ? '${l.woTry} ${setText(context, sug.weightKg, sug.reps)}'
              : '${l.woTry} × ${sug.reps}',
          sub: last == null ? null : '${l.woLastTime}: ${setText(context, last.weightKg, last.reps)}${last.rpe != null ? ' @${fmtNum(last.rpe!)}' : ''}',
          done: false,
          highlight: i == working.length,
        ));
      }
    }
    final next = t?.suggestionFor(working.length);
    final step = (t?.increment ?? 2.5) > 0 ? t!.increment : 2.5;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (t == null) const LinearProgressIndicator(),
          ...rows,
          if (next != null && working.length < planned)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  const Icon(Icons.trending_up, size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Expanded(child: Text(_reasonText(context, next), style: const TextStyle(color: AppColors.primary, fontSize: 12))),
                ],
              ),
            ),
          const Divider(height: 20),
          Wrap(
            alignment: WrapAlignment.spaceEvenly,
            spacing: 8,
            runSpacing: 12,
            children: [
              BigStepper(
                label: l.woWeightKg,
                value: _weight,
                step: step,
                decimals: 2,
                onChanged: (v) => setState(() => _weight = v),
                onTapValue: () => _editNumber(context, l.woWeightKg, _weight, (v) => _weight = v),
              ),
              BigStepper(
                label: l.woReps,
                value: _reps.toDouble(),
                step: 1,
                min: 1,
                decimals: 0,
                onChanged: (v) => setState(() => _reps = v.round()),
                onTapValue: () => _editNumber(context, l.woReps, _reps.toDouble(), (v) => _reps = v.round().clamp(1, 100)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text('RPE', style: context.text.labelMedium?.copyWith(color: AppColors.textMuted)),
          RpeSelector(value: _rpe, onChanged: (v) => setState(() => _rpe = v)),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            showSelectedIcon: false,
            segments: [
              for (final s in SetType.all)
                ButtonSegment(value: s, label: Text(setTypeLabel(context, s), style: const TextStyle(fontSize: 12))),
            ],
            selected: {_type},
            onSelectionChanged: (s) => setState(() => _type = s.first),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(onPressed: _copyLast, icon: const Icon(Icons.copy), label: Text(l.woCopyLast)),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 56,
                height: 48,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
                  onPressed: () => widget.onVoice(ex),
                  child: const Icon(Icons.mic),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => widget.onRest(t?.restSeconds ?? widget.planExercise?.restSeconds ?? 90),
                  icon: const Icon(Icons.timer_outlined),
                  label: Text(restText(t?.restSeconds ?? widget.planExercise?.restSeconds ?? 90)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 60,
            child: FilledButton.icon(
              onPressed: _saving ? null : () => _save(ex),
              icon: const Icon(Icons.check_circle, size: 28),
              label: Text(l.woSaveSet, style: const TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _editNumber(BuildContext context, String label, double value, void Function(double) apply) async {
    final c = TextEditingController(text: fmtNum(value, maxDecimals: 2));
    final r = await showDialog<double>(
      context: context,
      builder: (d) => AlertDialog(
        title: Text(label),
        content: TextField(
          controller: c,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onSubmitted: (v) => Navigator.pop(d, double.tryParse(v.replaceAll(',', '.'))),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(d), child: Text(context.l10n.cancel)),
          FilledButton(
            onPressed: () => Navigator.pop(d, double.tryParse(c.text.replaceAll(',', '.'))),
            child: Text(context.l10n.ok),
          ),
        ],
      ),
    );
    c.dispose();
    if (r != null && r >= 0 && mounted) setState(() => apply(r));
  }
}

class _SetRow extends StatelessWidget {
  final String label;
  final String main;
  final String? sub;
  final bool done;
  final bool pr;
  final bool highlight;
  final VoidCallback? onLongPress;
  const _SetRow({
    required this.label,
    required this.main,
    this.sub,
    required this.done,
    this.pr = false,
    this.highlight = false,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: highlight ? AppColors.primary.withValues(alpha: 0.08) : (done ? AppColors.cardHigh : Colors.transparent),
          borderRadius: BorderRadius.circular(10),
          border: highlight ? Border.all(color: AppColors.primary.withValues(alpha: 0.5)) : null,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 26,
              child: Text(label,
                  style: TextStyle(fontWeight: FontWeight.w700, color: done ? AppColors.primary : AppColors.textMuted)),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(main,
                      style: TextStyle(
                        fontWeight: done ? FontWeight.w700 : FontWeight.w500,
                        color: done ? null : (highlight ? AppColors.primary : AppColors.textMuted),
                      )),
                  if (sub != null) Text(sub!, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                ],
              ),
            ),
            if (pr) const Icon(Icons.emoji_events, color: AppColors.warning, size: 20),
            if (done && !pr) const Icon(Icons.check, color: AppColors.primary, size: 18),
          ],
        ),
      ),
    );
  }
}
