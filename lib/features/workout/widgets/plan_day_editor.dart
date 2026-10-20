import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/navigation.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/context_ext.dart';
import '../../../core/widgets/common.dart';
import '../../../data/repositories/exercise_repository.dart';
import '../../exercises/exercise_detail_screen.dart';
import '../../exercises/exercise_library_screen.dart';
import '../workout_repository.dart';
import 'substitute_sheet.dart';
import 'workout_widgets.dart';

/// Editable exercise list of one plan day: edit targets, swap, remove, add, drag-reorder.
class PlanDayEditor extends ConsumerStatefulWidget {
  final int dayId;
  const PlanDayEditor({super.key, required this.dayId});

  @override
  ConsumerState<PlanDayEditor> createState() => _PlanDayEditorState();
}

class _PlanDayEditorState extends ConsumerState<PlanDayEditor> {
  /// Optimistic order while the DB write round-trips.
  List<PlanExerciseItem>? _optimistic;

  WorkoutRepository get _repo => ref.read(workoutRepositoryProvider);

  Future<void> _onReorder(List<PlanExerciseItem> items, int oldIndex, int newIndex) async {
    final list = [...items];
    final moved = list.removeAt(oldIndex);
    list.insert(newIndex, moved);
    setState(() => _optimistic = list);
    await _repo.reorder(list.map((e) => e.pe.id).toList());
  }

  Future<void> _add() async {
    final id = await push<String>(context, const ExerciseLibraryScreen(pickMode: true));
    if (id == null) return;
    await _repo.addPlanExercise(widget.dayId, id);
  }

  Future<void> _swap(PlanExerciseItem item) async {
    final c = await showSubstituteSheet(context, exercise: item.ex, askScope: false);
    if (c == null) return;
    await _repo.swapPlanExercise(item.pe.id, c.exerciseId);
  }

  Future<void> _remove(PlanExerciseItem item) async {
    final l = context.l10n;
    final ok = await confirmDialog(
      context,
      title: l.woRemoveExerciseTitle,
      body: item.ex.name(context.lang),
      confirm: l.delete,
      danger: true,
    );
    if (ok) await _repo.removePlanExercise(item.pe.id);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final async = ref.watch(planDayExercisesProvider(widget.dayId));
    final data = async.value;
    if (data == null) {
      return const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator()));
    }
    var items = data;
    final opt = _optimistic;
    if (opt != null) {
      final same = opt.length == data.length && List.generate(data.length, (i) => opt[i].pe.id == data[i].pe.id).every((x) => x);
      if (same) {
        _optimistic = null;
      } else {
        items = opt;
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(l.woNoExercises, style: const TextStyle(color: AppColors.textMuted)),
          ),
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: false,
          itemCount: items.length,
          onReorderItem: (o, n) => _onReorder(items, o, n),
          proxyDecorator: (child, _, _) => Material(color: Colors.transparent, elevation: 6, child: child),
          itemBuilder: (context, i) {
            final it = items[i];
            return _PlanExerciseRow(
              key: ValueKey(it.pe.id),
              index: i,
              item: it,
              onEdit: () => showPlanExerciseEditSheet(context, it),
              onSwap: () => _swap(it),
              onRemove: () => _remove(it),
            );
          },
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(onPressed: _add, icon: const Icon(Icons.add), label: Text(l.woAddExercise)),
      ],
    );
  }
}

class _PlanExerciseRow extends StatelessWidget {
  final int index;
  final PlanExerciseItem item;
  final VoidCallback onEdit;
  final VoidCallback onSwap;
  final VoidCallback onRemove;
  const _PlanExerciseRow({
    super.key,
    required this.index,
    required this.item,
    required this.onEdit,
    required this.onSwap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final pe = item.pe;
    final parts = <String>[
      setsRepsText(pe.sets, pe.repMin, pe.repMax),
      if (pe.suggestedWeightKg != null && pe.suggestedWeightKg! > 0) '${fmtNum(pe.suggestedWeightKg!, maxDecimals: 2)} ${l.kg}',
      if (pe.targetRpe != null) 'RPE ${fmtNum(pe.targetRpe!)}',
      '${l.woRest} ${restText(pe.restSeconds)}',
    ];
    return Card(
      color: AppColors.cardHigh,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(4, 8, 4, 8),
          child: Row(
            children: [
              ReorderableDragStartListener(
                index: index,
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.drag_indicator, color: AppColors.textMuted),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.ex.name(context.lang), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                    const SizedBox(height: 2),
                    Text(parts.join(' · '), style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
                    if ((pe.notes ?? '').isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(pe.notes!, style: const TextStyle(color: AppColors.info, fontSize: 12)),
                      ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (v) {
                  switch (v) {
                    case 'edit':
                      onEdit();
                    case 'swap':
                      onSwap();
                    case 'remove':
                      onRemove();
                    case 'info':
                      push(context, ExerciseDetailScreen(exerciseId: item.ex.id));
                  }
                },
                itemBuilder: (_) => [
                  PopupMenuItem(value: 'edit', child: ListTile(leading: const Icon(Icons.tune), title: Text(l.edit))),
                  PopupMenuItem(value: 'swap', child: ListTile(leading: const Icon(Icons.swap_horiz), title: Text(l.woSwap))),
                  PopupMenuItem(
                      value: 'info', child: ListTile(leading: const Icon(Icons.info_outline), title: Text(l.woExerciseInfo))),
                  PopupMenuItem(
                    value: 'remove',
                    child: ListTile(
                      leading: const Icon(Icons.delete_outline, color: AppColors.danger),
                      title: Text(l.delete),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Edit sets / rep range / weight / RPE / rest of a plan exercise.
Future<void> showPlanExerciseEditSheet(BuildContext context, PlanExerciseItem item) => showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _PlanExerciseEditSheet(item: item),
    );

class _PlanExerciseEditSheet extends ConsumerStatefulWidget {
  final PlanExerciseItem item;
  const _PlanExerciseEditSheet({required this.item});

  @override
  ConsumerState<_PlanExerciseEditSheet> createState() => _PlanExerciseEditSheetState();
}

class _PlanExerciseEditSheetState extends ConsumerState<_PlanExerciseEditSheet> {
  late int _sets = widget.item.pe.sets;
  late int _repMin = widget.item.pe.repMin;
  late int _repMax = widget.item.pe.repMax;
  late double _weight = widget.item.pe.suggestedWeightKg ?? 0;
  late double? _rpe = widget.item.pe.targetRpe;
  late int _rest = widget.item.pe.restSeconds;
  late final _notes = TextEditingController(text: widget.item.pe.notes ?? '');

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    await ref.read(workoutRepositoryProvider).updatePlanExercise(
          widget.item.pe.id,
          PlanExercisesCompanion(
            sets: Value(_sets),
            repMin: Value(_repMin),
            repMax: Value(_repMax < _repMin ? _repMin : _repMax),
            suggestedWeightKg: Value(_weight > 0 ? _weight : null),
            targetRpe: Value(_rpe),
            restSeconds: Value(_rest),
            notes: Value(_notes.text.trim().isEmpty ? null : _notes.text.trim()),
          ),
        );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.item.ex.name(context.lang), style: context.text.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.spaceEvenly,
              spacing: 12,
              runSpacing: 16,
              children: [
                BigStepper(
                  label: l.woSets,
                  value: _sets.toDouble(),
                  step: 1,
                  min: 1,
                  decimals: 0,
                  onChanged: (v) => setState(() => _sets = v.round().clamp(1, 10)),
                ),
                BigStepper(
                  label: l.woWeightKg,
                  value: _weight,
                  step: 2.5,
                  decimals: 2,
                  onChanged: (v) => setState(() => _weight = v),
                ),
                BigStepper(
                  label: l.woRepMin,
                  value: _repMin.toDouble(),
                  step: 1,
                  min: 1,
                  decimals: 0,
                  onChanged: (v) => setState(() {
                    _repMin = v.round();
                    if (_repMax < _repMin) _repMax = _repMin;
                  }),
                ),
                BigStepper(
                  label: l.woRepMax,
                  value: _repMax.toDouble(),
                  step: 1,
                  min: 1,
                  decimals: 0,
                  onChanged: (v) => setState(() {
                    _repMax = v.round();
                    if (_repMin > _repMax) _repMin = _repMax;
                  }),
                ),
                BigStepper(
                  label: l.woRestSeconds,
                  value: _rest.toDouble(),
                  step: 15,
                  min: 15,
                  decimals: 0,
                  onChanged: (v) => setState(() => _rest = v.round().clamp(15, 600)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(l.woTargetRpe, style: context.text.labelLarge),
            const SizedBox(height: 4),
            RpeSelector(value: _rpe, onChanged: (v) => setState(() => _rpe = v), min: 5),
            const SizedBox(height: 16),
            TextField(
              controller: _notes,
              decoration: InputDecoration(labelText: l.notes),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: _save, child: Text(l.save)),
          ],
        ),
      ),
    );
  }
}

/// Horizontal RPE chips (tap again to clear).
class RpeSelector extends StatelessWidget {
  final double? value;
  final ValueChanged<double?> onChanged;
  final int min;
  const RpeSelector({super.key, required this.value, required this.onChanged, this.min = 1});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = min; i <= 10; i++)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 6),
              child: ChoiceChip(
                label: Text('$i', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                selected: value?.round() == i,
                showCheckmark: false,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                onSelected: (s) => onChanged(s ? i.toDouble() : null),
              ),
            ),
        ],
      ),
    );
  }
}
