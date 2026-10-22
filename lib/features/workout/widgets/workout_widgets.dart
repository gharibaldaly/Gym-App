import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/calc/strength_calc.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/context_ext.dart';
import '../../../data/repositories/exercise_repository.dart';
import '../workout_logic.dart';

/// Exercise row by id (works for seeded, custom and substituted exercises).
final workoutExerciseProvider = FutureProvider.autoDispose.family<Exercise?, String>(
    (ref, id) => ref.watch(exerciseRepositoryProvider).byId(id));

Color sessionStatusColor(String status) => switch (status) {
      SessionStatus.completed => AppColors.primary,
      SessionStatus.partial => AppColors.warning,
      SessionStatus.missed => AppColors.danger,
      SessionStatus.inProgress => AppColors.info,
      _ => AppColors.rest,
    };

String sessionStatusLabel(BuildContext context, String status) {
  final l = context.l10n;
  return switch (status) {
    SessionStatus.completed => l.woStatusCompleted,
    SessionStatus.partial => l.woStatusPartial,
    SessionStatus.missed => l.woStatusMissed,
    _ => l.woStatusInProgress,
  };
}

IconData sessionStatusIcon(String status) => switch (status) {
      SessionStatus.completed => Symbols.check_circle_rounded,
      SessionStatus.partial => Symbols.timelapse_rounded,
      SessionStatus.missed => Symbols.cancel_rounded,
      _ => Symbols.play_circle_rounded,
    };

String setTypeLabel(BuildContext context, String type) {
  final l = context.l10n;
  return switch (type) {
    SetType.warmup => l.woSetTypeWarmup,
    SetType.drop => l.woSetTypeDrop,
    SetType.failure => l.woSetTypeFailure,
    _ => l.woSetTypeNormal,
  };
}

String prTypeLabel(BuildContext context, String type) {
  final l = context.l10n;
  return switch (type) {
    'weight' => l.woPrWeight,
    'reps' => l.woPrReps,
    _ => l.woPrE1rm,
  };
}

String prTypesLabel(BuildContext context, Iterable<PrType> types) =>
    types.map((t) => prTypeLabel(context, t.name)).join(' · ');

/// "4 × 8–12"
String setsRepsText(int sets, int repMin, int repMax) =>
    repMin == repMax ? '$sets × $repMin' : '$sets × $repMin–$repMax';

/// "1:30"
String restText(int seconds) {
  final m = seconds ~/ 60, s = seconds % 60;
  return '$m:${s.toString().padLeft(2, '0')}';
}

/// "80 kg × 10" (bodyweight → "× 10")
String setText(BuildContext context, double weight, int reps) =>
    weight <= 0 ? '× $reps' : '${fmtNum(weight, maxDecimals: 2)} ${context.l10n.kg} × $reps';

/// Small rounded label.
class Pill extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;
  const Pill(this.text, {super.key, this.color = AppColors.primary, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(8, 3, 8, 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 14, color: color), const SizedBox(width: 4)],
          Text(text, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

/// Bulleted list of warm-up / cool-down steps; checkable when [checked] is given.
class StepsList extends StatelessWidget {
  final List<String> steps;
  final Set<int>? checked;
  final ValueChanged<int>? onToggle;
  const StepsList({super.key, required this.steps, this.checked, this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < steps.length; i++)
          if (checked == null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsetsDirectional.only(top: 7, end: 8),
                    child: Icon(Symbols.circle_rounded, fill: 1, size: 6, color: AppColors.primary),
                  ),
                  Expanded(child: Text(steps[i])),
                ],
              ),
            )
          else
            CheckboxListTile(
              value: checked!.contains(i),
              onChanged: (_) => onToggle?.call(i),
              dense: true,
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                steps[i],
                style: checked!.contains(i)
                    ? const TextStyle(color: AppColors.textMuted, decoration: TextDecoration.lineThrough)
                    : null,
              ),
            ),
      ],
    );
  }
}

/// Simple stat tile used in summaries.
class StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const StatTile({super.key, required this.label, required this.value, required this.icon, this.color = AppColors.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.cardHigh, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(value, style: context.text.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
          Text(label, style: context.text.bodySmall?.copyWith(color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

/// Exercise name resolved by id (localized).
class ExerciseName extends ConsumerWidget {
  final String exerciseId;
  final TextStyle? style;
  final int? maxLines;
  const ExerciseName(this.exerciseId, {super.key, this.style, this.maxLines});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ex = ref.watch(workoutExerciseProvider(exerciseId)).value;
    return Text(
      ex?.name(context.lang) ?? exerciseId.replaceAll('_', ' '),
      style: style,
      maxLines: maxLines,
      overflow: maxLines == null ? null : TextOverflow.ellipsis,
    );
  }
}

Future<bool> confirmDialog(BuildContext context, {required String title, String? body, String? confirm, bool danger = false}) async {
  final l = context.l10n;
  final r = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      title: Text(title),
      content: body == null ? null : Text(body),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l.cancel)),
        FilledButton(
          style: danger ? FilledButton.styleFrom(backgroundColor: AppColors.danger, foregroundColor: AppColors.onDanger) : null,
          onPressed: () => Navigator.pop(c, true),
          child: Text(confirm ?? l.confirm),
        ),
      ],
    ),
  );
  return r ?? false;
}

/// Blocking progress dialog while [task] runs. Returns its result (rethrows errors).
Future<T> runWithProgress<T>(BuildContext context, String message, Future<T> Function() task) async {
  final nav = Navigator.of(context, rootNavigator: true);
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (c) => PopScope(
      canPop: false,
      child: AlertDialog(
        content: Row(
          children: [
            const SizedBox(width: 28, height: 28, child: CircularProgressIndicator(strokeWidth: 3)),
            const SizedBox(width: 16),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    ),
  );
  try {
    return await task();
  } finally {
    nav.pop();
  }
}
