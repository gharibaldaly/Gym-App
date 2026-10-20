import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/context_ext.dart';
import '../../../core/widgets/common.dart';
import '../../../data/repositories/profile_repository.dart';
import '../tracking_providers.dart';
import '../widgets/tracking_widgets.dart';

/// Timing keys stored in supplements.timing (free text is also allowed).
const supplementTimings = ['morning', 'pre_workout', 'post_workout', 'with_meal', 'evening', 'bedtime'];

String timingLabel(BuildContext context, String? t) {
  final l = context.l10n;
  return switch (t) {
    'morning' => l.trkTimingMorning,
    'pre_workout' => l.trkTimingPreWorkout,
    'post_workout' => l.trkTimingPostWorkout,
    'with_meal' => l.trkTimingWithMeal,
    'evening' => l.trkTimingEvening,
    'bedtime' => l.trkTimingBedtime,
    _ => t ?? '',
  };
}

String supplementSubtitle(BuildContext context, Supplement s) {
  final parts = [
    if (s.dose != null && s.dose!.isNotEmpty) s.dose!,
    if (s.timing != null && s.timing!.isNotEmpty) timingLabel(context, s.timing),
    if (s.proteinG > 0 || s.calories > 0) context.l10n.trkSuppMacros(fmtNum(s.proteinG), fmtNum(s.calories)),
  ];
  return parts.join(' · ');
}

class SupplementsScreen extends ConsumerWidget {
  const SupplementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final today = ref.watch(todaySupplementsProvider);
    final all = ref.watch(supplementsProvider);
    final profileSupps = ref.watch(profileProvider).value?.supplementsList ?? const [];

    return Scaffold(
      appBar: AppBar(title: Text(l.trkSupplementsTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showSupplementEditor(context, ref),
        icon: const Icon(Icons.add),
        label: Text(l.trkSuppAdd),
      ),
      body: all.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.errorGeneric)),
        data: (supps) {
          if (supps.isEmpty) {
            return EmptyState(
              icon: Icons.medication_outlined,
              text: '${l.trkSuppEmpty}\n\n${l.trkSuppNote}',
              action: profileSupps.isEmpty
                  ? null
                  : OutlinedButton.icon(
                      onPressed: () async {
                        final n = await ref.read(trackingRepositoryProvider).importSupplementsFromProfile();
                        if (context.mounted) context.snack(l.trkSuppImported(n));
                      },
                      icon: const Icon(Icons.download),
                      label: Text(l.trkSuppImport),
                    ),
            );
          }
          final checks = today.value ?? const <(Supplement, bool)>[];
          final taken = checks.where((e) => e.$2).length;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            children: [
              SectionCard(
                title: l.trkSuppToday,
                trailing: checks.isEmpty
                    ? null
                    : Text(l.trkSuppTakenCount(taken, checks.length),
                        style: context.text.bodySmall?.copyWith(
                            color: taken == checks.length ? AppColors.primary : AppColors.textMuted)),
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                child: checks.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(l.trkSuppNoneActive, style: const TextStyle(color: AppColors.textMuted)),
                      )
                    : Column(
                        children: [
                          for (final (s, done) in checks)
                            CheckboxListTile(
                              value: done,
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                              title: Text(s.name,
                                  style: TextStyle(
                                    decoration: done ? TextDecoration.lineThrough : null,
                                    color: done ? AppColors.textMuted : AppColors.text,
                                  )),
                              subtitle: supplementSubtitle(context, s).isEmpty
                                  ? null
                                  : Text(supplementSubtitle(context, s)),
                              onChanged: (_) {
                                HapticFeedback.selectionClick();
                                toggleSupplement(ref, s.id);
                              },
                            ),
                        ],
                      ),
              ),
              SectionCard(
                title: l.trkSuppManage,
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                child: Column(
                  children: [
                    for (final s in supps)
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                        leading: Icon(Icons.medication,
                            color: s.active ? AppColors.primary : AppColors.textMuted),
                        title: Text(s.name),
                        subtitle: Text([
                          s.active ? l.trkSuppActive : l.trkSuppPaused,
                          if (supplementSubtitle(context, s).isNotEmpty) supplementSubtitle(context, s),
                        ].join(' · ')),
                        trailing: Switch(
                          value: s.active,
                          onChanged: (v) => ref.read(trackingRepositoryProvider).setSupplementActive(s.id, v),
                        ),
                        onTap: () => showSupplementEditor(context, ref, existing: s),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(l.trkSuppNote,
                    textAlign: TextAlign.center, style: context.text.bodySmall?.copyWith(color: AppColors.textMuted)),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Add / edit sheet.
Future<void> showSupplementEditor(BuildContext context, WidgetRef ref, {Supplement? existing}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _SupplementEditor(existing: existing),
  );
}

class _SupplementEditor extends ConsumerStatefulWidget {
  final Supplement? existing;
  const _SupplementEditor({this.existing});

  @override
  ConsumerState<_SupplementEditor> createState() => _SupplementEditorState();
}

class _SupplementEditorState extends ConsumerState<_SupplementEditor> {
  late final _name = TextEditingController(text: widget.existing?.name);
  late final _dose = TextEditingController(text: widget.existing?.dose);
  late final _protein = TextEditingController(text: _num(widget.existing?.proteinG));
  late final _cal = TextEditingController(text: _num(widget.existing?.calories));
  late final _carbs = TextEditingController(text: _num(widget.existing?.carbsG));
  late final _fat = TextEditingController(text: _num(widget.existing?.fatG));
  late String? _timing = widget.existing?.timing;
  String? _nameError;

  static String _num(double? v) => v == null || v == 0 ? '' : fmtNum(v);

  @override
  void dispose() {
    for (final c in [_name, _dose, _protein, _cal, _carbs, _fat]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      setState(() => _nameError = context.l10n.trkNameRequired);
      return;
    }
    double n(TextEditingController c) => parseNum(c.text) ?? 0;
    final dose = _dose.text.trim();
    final data = SupplementsCompanion(
      id: widget.existing == null ? const Value.absent() : Value(widget.existing!.id),
      name: Value(name),
      dose: Value(dose.isEmpty ? null : dose),
      timing: Value(_timing),
      proteinG: Value(n(_protein)),
      calories: Value(n(_cal)),
      carbsG: Value(n(_carbs)),
      fatG: Value(n(_fat)),
    );
    await ref.read(trackingRepositoryProvider).saveSupplement(data);
    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    final s = widget.existing!;
    if (!await confirmDelete(context, context.l10n.trkDeleteConfirm(s.name))) return;
    await ref.read(trackingRepositoryProvider).deleteSupplement(s.id);
    if (mounted) Navigator.pop(context);
  }

  Widget _numField(TextEditingController c, String label) => Expanded(
        child: TextField(
          controller: c,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: numberInputFormatters,
          decoration: InputDecoration(labelText: label),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final custom = _timing != null && !supplementTimings.contains(_timing);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.existing == null ? l.trkSuppAdd : l.trkSuppEdit, style: context.text.titleLarge),
            const SizedBox(height: 12),
            TextField(
              controller: _name,
              autofocus: widget.existing == null,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: l.trkSuppName, errorText: _nameError),
            ),
            const SizedBox(height: 10),
            TextField(controller: _dose, decoration: InputDecoration(labelText: l.trkSuppDose)),
            const SizedBox(height: 14),
            Text(l.trkSuppTiming, style: context.text.labelLarge),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final t in supplementTimings)
                  ChoiceChip(
                    label: Text(timingLabel(context, t)),
                    selected: _timing == t,
                    onSelected: (v) => setState(() => _timing = v ? t : null),
                  ),
                if (custom) ChoiceChip(label: Text(_timing!), selected: true, onSelected: (_) => setState(() => _timing = null)),
              ],
            ),
            const SizedBox(height: 16),
            Text(l.trkSuppPerServing, style: context.text.labelLarge),
            const SizedBox(height: 8),
            Row(children: [
              _numField(_protein, l.trkSuppProtein),
              const SizedBox(width: 10),
              _numField(_cal, l.trkSuppCalories),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              _numField(_carbs, l.trkSuppCarbs),
              const SizedBox(width: 10),
              _numField(_fat, l.trkSuppFat),
            ]),
            const SizedBox(height: 20),
            Row(
              children: [
                if (widget.existing != null)
                  IconButton(
                    tooltip: l.delete,
                    onPressed: _delete,
                    icon: const Icon(Icons.delete_outline, color: AppColors.danger),
                  ),
                const Spacer(),
                TextButton(onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
                const SizedBox(width: 8),
                FilledButton(onPressed: _save, child: Text(l.save)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
