import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/navigation.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/context_ext.dart';
import '../../core/widgets/common.dart';
import '../../data/repositories/exercise_repository.dart';
import 'add_exercise_screen.dart';
import 'exercise_detail_screen.dart';
import 'exercise_labels.dart';
import 'exercise_providers.dart';
import 'widgets/exercise_images.dart';

/// Library with search/filter/favorites. In [pickMode] tapping an exercise pops its id (String).
class ExerciseLibraryScreen extends ConsumerStatefulWidget {
  final bool pickMode;
  const ExerciseLibraryScreen({super.key, this.pickMode = false});

  @override
  ConsumerState<ExerciseLibraryScreen> createState() => _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState extends ConsumerState<ExerciseLibraryScreen> {
  final _search = TextEditingController();
  Timer? _debounce;
  ExerciseFilter _filter = kNoExerciseFilter;

  /// Last results, shown while a new filter loads (avoids spinner flashes while typing).
  List<Exercise>? _last;

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  void _set(ExerciseFilter f) => setState(() => _filter = f);

  void _onQuery(String q) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 220), () {
      if (!mounted) return;
      final f = _filter;
      _set((query: q, muscle: f.muscle, equipment: f.equipment, favoritesOnly: f.favoritesOnly, customOnly: f.customOnly));
    });
  }

  bool get _hasFilters =>
      _filter.query.isNotEmpty ||
      _filter.muscle != null ||
      _filter.equipment != null ||
      _filter.favoritesOnly ||
      _filter.customOnly;

  void _clear() {
    _search.clear();
    _set(kNoExerciseFilter);
  }

  Future<void> _open(Exercise e) async {
    if (widget.pickMode) {
      Navigator.of(context).pop(e.id);
      return;
    }
    await push(context, ExerciseDetailScreen(exerciseId: e.id));
  }

  Future<void> _add() async {
    final id = await push<String>(context, const AddExerciseScreen());
    if (id == null || !mounted) return;
    if (widget.pickMode) {
      Navigator.of(context).pop(id);
    } else {
      await push(context, ExerciseDetailScreen(exerciseId: id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lang = context.lang;
    var results = ref.watch(exerciseSearchProvider(_filter));
    if (results.hasValue) {
      _last = results.value;
    } else if (results.isLoading && _last != null) {
      results = AsyncData(_last!);
    }
    final f = _filter;

    return Scaffold(
      appBar: AppBar(title: Text(widget.pickMode ? l.exPickTitle : l.exLibraryTitle)),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'ex_add_fab',
        onPressed: _add,
        icon: const Icon(Icons.auto_awesome),
        label: Text(l.exAddWithAi),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 8),
            child: TextField(
              controller: _search,
              onChanged: _onQuery,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: l.exSearchHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _search.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _search.clear();
                          _onQuery('');
                        },
                      ),
              ),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 12),
              children: [
                _ToggleChip(
                  icon: Icons.star_rounded,
                  label: l.exFavoritesOnly,
                  selected: f.favoritesOnly,
                  onTap: () => _set((
                    query: f.query,
                    muscle: f.muscle,
                    equipment: f.equipment,
                    favoritesOnly: !f.favoritesOnly,
                    customOnly: f.customOnly,
                  )),
                ),
                _ToggleChip(
                  icon: Icons.person_outline,
                  label: l.exMyCustom,
                  selected: f.customOnly,
                  onTap: () => _set((
                    query: f.query,
                    muscle: f.muscle,
                    equipment: f.equipment,
                    favoritesOnly: f.favoritesOnly,
                    customOnly: !f.customOnly,
                  )),
                ),
                _MenuChip(
                  icon: Icons.accessibility_new,
                  label: f.muscle == null ? l.exMuscleFilter : muscleShortLabel(f.muscle!, lang),
                  selected: f.muscle != null,
                  options: [for (final m in kMuscles) (m, muscleLabel(m, lang))],
                  allLabel: l.exAllMuscles,
                  onSelected: (m) => _set((
                    query: f.query,
                    muscle: m,
                    equipment: f.equipment,
                    favoritesOnly: f.favoritesOnly,
                    customOnly: f.customOnly,
                  )),
                ),
                _MenuChip(
                  icon: Icons.fitness_center,
                  label: f.equipment == null ? l.exEquipmentFilter : equipmentLabel(f.equipment, lang),
                  selected: f.equipment != null,
                  options: [for (final e in kEquipment) (e, equipmentLabel(e, lang))],
                  allLabel: l.exAllEquipment,
                  onSelected: (e) => _set((
                    query: f.query,
                    muscle: f.muscle,
                    equipment: e,
                    favoritesOnly: f.favoritesOnly,
                    customOnly: f.customOnly,
                  )),
                ),
                if (_hasFilters)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 4),
                    child: TextButton.icon(
                      onPressed: _clear,
                      icon: const Icon(Icons.filter_alt_off, size: 18),
                      label: Text(l.exClearFilters),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: results.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => EmptyState(icon: Icons.error_outline, text: '${l.errorGeneric}\n$e'),
              data: (list) {
                if (list.isEmpty) {
                  return EmptyState(
                    icon: Icons.search_off,
                    text: l.exNoResults,
                    action: Wrap(spacing: 8, alignment: WrapAlignment.center, children: [
                      if (_hasFilters) OutlinedButton(onPressed: _clear, child: Text(l.exClearFilters)),
                      FilledButton.icon(
                        onPressed: _add,
                        icon: const Icon(Icons.auto_awesome),
                        label: Text(l.exAddWithAi),
                      ),
                    ]),
                  );
                }
                return Column(children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 4),
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(l.exResultsCount(list.length),
                          style: context.text.bodySmall?.copyWith(color: AppColors.textMuted)),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsetsDirectional.only(bottom: 96),
                      itemCount: list.length,
                      itemBuilder: (_, i) => ExerciseTile(
                        exercise: list[i],
                        onTap: () => _open(list[i]),
                        trailingInfo: widget.pickMode
                            ? () => push(context, ExerciseDetailScreen(exerciseId: list[i].id))
                            : null,
                      ),
                    ),
                  ),
                ]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _ToggleChip({required this.icon, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 4),
        child: FilterChip(
          avatar: Icon(icon, size: 18, color: selected ? AppColors.onPrimary : AppColors.textMuted),
          label: Text(label),
          selected: selected,
          showCheckmark: false,
          selectedColor: AppColors.primary,
          labelStyle: TextStyle(color: selected ? AppColors.onPrimary : AppColors.text),
          onSelected: (_) => onTap(),
        ),
      );
}

/// Chip that opens a bottom-sheet list of options (null = all).
class _MenuChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final List<(String, String)> options;
  final String allLabel;
  final ValueChanged<String?> onSelected;
  const _MenuChip({
    required this.icon,
    required this.label,
    required this.selected,
    required this.options,
    required this.allLabel,
    required this.onSelected,
  });

  Future<void> _pick(BuildContext context) async {
    final res = await showModalBottomSheet<(String?,)>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(ctx).height * 0.7),
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                leading: const Icon(Icons.all_inclusive),
                title: Text(allLabel),
                onTap: () => Navigator.pop(ctx, (null,)),
              ),
              for (final o in options)
                ListTile(
                  title: Text(o.$2),
                  onTap: () => Navigator.pop(ctx, (o.$1,)),
                ),
            ],
          ),
        ),
      ),
    );
    if (res != null) onSelected(res.$1);
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 4),
        child: FilterChip(
          avatar: Icon(icon, size: 18, color: selected ? AppColors.onPrimary : AppColors.textMuted),
          label: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(label),
            Icon(Icons.arrow_drop_down, size: 18, color: selected ? AppColors.onPrimary : AppColors.textMuted),
          ]),
          selected: selected,
          showCheckmark: false,
          selectedColor: AppColors.primary,
          labelStyle: TextStyle(color: selected ? AppColors.onPrimary : AppColors.text),
          onSelected: (_) => _pick(context),
        ),
      );
}

/// List row: thumbnail, name, muscle chips, equipment, favorite star.
class ExerciseTile extends ConsumerWidget {
  final Exercise exercise;
  final VoidCallback onTap;

  /// When set (pick mode), shows an info button that opens the details.
  final VoidCallback? trailingInfo;
  const ExerciseTile({super.key, required this.exercise, required this.onTap, this.trailingInfo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = context.lang;
    final e = exercise;
    final other = lang == 'ar' ? e.nameEn : e.nameAr;
    final name = e.name(lang);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 4, 8),
        child: Row(
          children: [
            ExerciseThumb(exercise: e, size: 64),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  if (other.isNotEmpty && other != name)
                    Text(other,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.text.bodySmall?.copyWith(color: AppColors.textMuted)),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      for (final m in e.primaryMuscles.take(2)) MuscleTag(label: muscleShortLabel(m, lang), primary: true),
                      for (final m in e.secondaryMuscles.take(1)) MuscleTag(label: muscleShortLabel(m, lang)),
                      if (e.equipment != null) MuscleTag(label: equipmentLabel(e.equipment, lang), neutral: true),
                      if (e.isCustom) MuscleTag(label: context.l10n.exCustomBadge, neutral: true),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: e.isFavorite ? context.l10n.exFavoriteRemove : context.l10n.exFavoriteAdd,
              iconSize: 28,
              icon: Icon(
                e.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
                color: e.isFavorite ? AppColors.warning : AppColors.textMuted,
              ),
              onPressed: () {
                HapticFeedback.selectionClick();
                ref.read(exerciseRepositoryProvider).setFavorite(e.id, !e.isFavorite);
              },
            ),
            if (trailingInfo != null)
              IconButton(icon: const Icon(Icons.info_outline), onPressed: trailingInfo, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

/// Tiny rounded tag: primary muscle (dark green), secondary (light green outline) or neutral.
class MuscleTag extends StatelessWidget {
  final String label;
  final bool primary;
  final bool neutral;
  const MuscleTag({super.key, required this.label, this.primary = false, this.neutral = false});

  @override
  Widget build(BuildContext context) {
    final Color bg = neutral
        ? AppColors.cardHigh
        : primary
            ? AppColors.primaryDark
            : AppColors.primaryLight.withValues(alpha: 0.14);
    final Color fg = neutral
        ? AppColors.textMuted
        : primary
            ? Colors.white
            : AppColors.primaryLight;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Text(label, style: TextStyle(color: fg, fontSize: 11.5, fontWeight: FontWeight.w600)),
    );
  }
}
