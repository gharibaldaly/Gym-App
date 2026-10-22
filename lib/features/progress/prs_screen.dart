import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/navigation.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/context_ext.dart';
import '../../core/widgets/common.dart';
import '../../data/repositories/exercise_repository.dart';
import '../exercises/exercise_detail_screen.dart';
import '../exercises/exercise_labels.dart';
import 'progress_providers.dart';
import 'widgets/chart_kit.dart';

/// All-time personal records per exercise (heaviest, best e1RM, most reps at each weight).
class PrsScreen extends ConsumerStatefulWidget {
  const PrsScreen({super.key});

  @override
  ConsumerState<PrsScreen> createState() => _PrsScreenState();
}

class _PrsScreenState extends ConsumerState<PrsScreen> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final async = ref.watch(prListProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.progPrsTitle)),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('${l.errorGeneric}\n$e')),
        data: (items) {
          if (items.isEmpty) return EmptyState(icon: Symbols.trophy_rounded, text: l.progNoPrs);
          final q = _q.trim().toLowerCase();
          final shown = q.isEmpty
              ? items
              : items.where((i) {
                  final e = i.exercise;
                  if (e == null) return i.prs.exerciseId.toLowerCase().contains(q);
                  return e.nameEn.toLowerCase().contains(q) || e.nameAr.contains(_q.trim());
                }).toList();
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              TextField(
                decoration: InputDecoration(prefixIcon: const Icon(Symbols.search_rounded), hintText: l.progSearchExercise),
                onChanged: (v) => setState(() => _q = v),
              ),
              const SizedBox(height: 8),
              if (shown.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(l.progNoMatches,
                      textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textMuted)),
                ),
              for (final i in shown) PrCard(item: i),
            ],
          );
        },
      ),
    );
  }
}

class PrCard extends StatelessWidget {
  final PrListItem item;
  const PrCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = item.prs;
    final ex = item.exercise;
    final muscles = ex?.primaryMuscles.map((m) => muscleShortLabel(m, context.lang)).join('، ') ?? '';
    String kg(num v) => '${fmtNum(v)} ${l.kg}';
    return SectionCard(
      onTap: () => push(context, ExerciseDetailScreen(exerciseId: p.exerciseId)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [
            const Icon(Symbols.trophy_rounded, fill: 1, color: AppColors.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(ex?.name(context.lang) ?? l.progUnknownExercise,
                    style: context.text.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                Text(
                  [
                    if (muscles.isNotEmpty) muscles,
                    l.progSetsLogged('${p.workingSets}'),
                    l.progLastTrained(chartDayLabel(context, p.lastDate)),
                  ].join(' · '),
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
              ]),
            ),
            const Icon(Symbols.chevron_right_rounded, color: AppColors.textMuted),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: _RecordBox(
                label: l.progPrHeaviest,
                value: '${kg(p.heaviest.weightKg)} × ${p.heaviest.reps}',
                date: chartDayLabel(context, p.heaviest.date),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _RecordBox(
                label: l.progPrBestE1rm,
                value: kg(double.parse(p.bestE1rm.e1rm.toStringAsFixed(1))),
                sub: '${fmtNum(p.bestE1rm.weightKg)} × ${p.bestE1rm.reps}',
                date: chartDayLabel(context, p.bestE1rm.date),
              ),
            ),
          ]),
          const SizedBox(height: 12),
          Text(l.progPrRepsAtWeight, style: context.text.labelMedium?.copyWith(color: AppColors.textMuted)),
          const SizedBox(height: 4),
          for (final e in p.repsAtWeight.take(6))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(children: [
                SizedBox(width: 90, child: Text(kg(e.weightKg), style: const TextStyle(fontWeight: FontWeight.w700))),
                Expanded(
                  child: Text('× ${e.reps}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                ),
                Text(chartDayLabel(context, e.date), style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
              ]),
            ),
        ],
      ),
    );
  }
}

class _RecordBox extends StatelessWidget {
  final String label, value, date;
  final String? sub;
  const _RecordBox({required this.label, required this.value, required this.date, this.sub});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cardHigh,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.35)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: AppColors.primary)),
          if (sub != null) Text(sub!, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
          const SizedBox(height: 2),
          Text(date, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
        ]),
      );
}
