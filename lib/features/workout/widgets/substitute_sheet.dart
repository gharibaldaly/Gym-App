import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../ai/ai_service.dart';
import '../../../core/navigation.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/context_ext.dart';
import '../../../core/widgets/common.dart';
import '../../../data/repositories/exercise_repository.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../exercises/exercise_alternatives.dart';
import '../../exercises/exercise_labels.dart';
import '../../exercises/exercise_library_screen.dart';

class SubstituteChoice {
  final String exerciseId;

  /// true → change the plan permanently; false → only this workout.
  final bool always;
  const SubstituteChoice(this.exerciseId, {required this.always});
}

/// Alternatives sheet: 3 local alternatives first, then Claude's picks when online,
/// plus "pick from library". [askScope] shows the "just this workout / always" choice.
Future<SubstituteChoice?> showSubstituteSheet(
  BuildContext context, {
  required Exercise exercise,
  bool askScope = true,
}) {
  return showModalBottomSheet<SubstituteChoice>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _SubstituteSheet(exercise: exercise, askScope: askScope),
  );
}

class _SubstituteSheet extends ConsumerStatefulWidget {
  final Exercise exercise;
  final bool askScope;
  const _SubstituteSheet({required this.exercise, required this.askScope});

  @override
  ConsumerState<_SubstituteSheet> createState() => _SubstituteSheetState();
}

class _SubstituteSheetState extends ConsumerState<_SubstituteSheet> {
  List<Exercise>? _local;
  List<Exercise>? _ai;
  bool _aiLoading = false;
  String? _aiError;
  bool _always = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = ref.read(exerciseRepositoryProvider);
    final location = (await ref.read(profileRepositoryProvider).get())?.location;
    final local = await repo.localAlternatives(widget.exercise, limit: 3, location: location);
    if (!mounted) return;
    setState(() => _local = local);
    if (!ref.read(hasApiKeyProvider) || !ref.read(isOnlineProvider)) return;
    setState(() => _aiLoading = true);
    try {
      final ids = await exerciseAlternativesAi(ref, widget.exercise, location: location);
      final known = local.map((e) => e.id).toSet();
      final rows = await repo.byIds(ids.where((id) => !known.contains(id) && id != widget.exercise.id));
      rows.sort((a, b) => ids.indexOf(a.id).compareTo(ids.indexOf(b.id)));
      if (mounted) setState(() => _ai = rows.take(3).toList());
    } catch (e) {
      if (mounted) setState(() => _aiError = aiErrorText(e, ar: context.isAr));
    } finally {
      if (mounted) setState(() => _aiLoading = false);
    }
  }

  void _pick(String id) => Navigator.pop(context, SubstituteChoice(id, always: _always));

  Widget _tile(Exercise e) {
    final lang = context.lang;
    final sub = [
      e.primaryMuscles.map((m) => muscleShortLabel(m, lang)).join('، '),
      if (e.equipment != null) equipmentLabel(e.equipment, lang),
    ].where((s) => s.isNotEmpty).join(' · ');
    return Card(
      color: AppColors.cardHigh,
      child: ListTile(
        minVerticalPadding: 12,
        title: Text(e.name(lang), style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(sub, style: const TextStyle(color: AppColors.textMuted)),
        trailing: const Icon(Symbols.swap_horiz_rounded, color: AppColors.primary),
        onTap: () => _pick(e.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      builder: (context, scroll) => ListView(
        controller: scroll,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          Text(l.woSubstituteTitle, style: context.text.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
          Text(widget.exercise.name(context.lang), style: const TextStyle(color: AppColors.textMuted)),
          if (widget.askScope) ...[
            const SizedBox(height: 12),
            SegmentedButton<bool>(
              segments: [
                ButtonSegment(value: false, label: Text(l.woSubstituteOnce), icon: const Icon(Symbols.today_rounded, fill: 1)),
                ButtonSegment(value: true, label: Text(l.woSubstituteAlways), icon: const Icon(Symbols.push_pin_rounded, fill: 1)),
              ],
              selected: {_always},
              onSelectionChanged: (s) => setState(() => _always = s.first),
            ),
          ],
          const SizedBox(height: 16),
          Text(l.woSubstituteLocal, style: context.text.titleSmall),
          const SizedBox(height: 4),
          if (_local == null)
            const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator()))
          else if (_local!.isEmpty)
            Text(l.woSubstituteNone, style: const TextStyle(color: AppColors.textMuted))
          else
            ..._local!.map(_tile),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Symbols.auto_awesome_rounded, size: 18, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(l.woSubstituteAi, style: context.text.titleSmall),
            ],
          ),
          const SizedBox(height: 4),
          if (_aiLoading)
            const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator()))
          else if (_ai != null && _ai!.isNotEmpty)
            ..._ai!.map(_tile)
          else if (_aiError != null)
            Text(_aiError!, style: const TextStyle(color: AppColors.textMuted))
          else if (_ai != null)
            Text(l.woSubstituteNone, style: const TextStyle(color: AppColors.textMuted))
          else
            const AiUnavailableBanner(),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            icon: const Icon(Symbols.menu_book_rounded),
            label: Text(l.woPickFromLibrary),
            onPressed: () async {
              final id = await push<String>(context, const ExerciseLibraryScreen(pickMode: true));
              if (id != null && context.mounted) _pick(id);
            },
          ),
        ],
      ),
    );
  }
}
