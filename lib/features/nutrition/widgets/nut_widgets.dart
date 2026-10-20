import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/context_ext.dart';
import '../nutrition_logic.dart';

/// App documents directory (for resolving relative meal photo paths).
final nutDocsDirProvider = FutureProvider<String>((ref) async => (await getApplicationDocumentsDirectory()).path);

/// "520 kcal · P 40 · C 60 · F 12"
String macroLine(BuildContext context, FoodMacros m) => context.l10n.nutMacroLine(
      fmtNum(m.calories.roundToDouble()),
      fmtNum(m.protein.roundToDouble()),
      fmtNum(m.carbs.roundToDouble()),
      fmtNum(m.fat.roundToDouble()),
    );

/// Small colored P/C/F chips with kcal.
class MacroSummaryRow extends StatelessWidget {
  final FoodMacros macros;
  final bool dense;
  const MacroSummaryRow({super.key, required this.macros, this.dense = false});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final style = (dense ? context.text.bodySmall : context.text.bodyMedium) ?? const TextStyle();
    Widget chip(String label, double v, Color c) => Padding(
          padding: const EdgeInsetsDirectional.only(end: 10),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
            const SizedBox(width: 4),
            Text('$label ${fmtNum(v.roundToDouble())}${l.gramsShort}', style: style),
          ]),
        );
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 4,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 10),
          child: Text('${fmtNum(macros.calories.roundToDouble())} ${l.kcal}',
              style: style.copyWith(fontWeight: FontWeight.w700, color: AppColors.primary)),
        ),
        chip(l.nutProteinShort, macros.protein, AppColors.protein),
        chip(l.nutCarbsShort, macros.carbs, AppColors.carbs),
        chip(l.nutFatShort, macros.fat, AppColors.fat),
      ],
    );
  }
}

/// Thumbnail of a stored (relative) meal photo.
class MealPhotoThumb extends ConsumerWidget {
  final String path;
  final double size;
  const MealPhotoThumb({super.key, required this.path, this.size = 48});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final docs = ref.watch(nutDocsDirProvider).value;
    final placeholder = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: AppColors.cardHigh, borderRadius: BorderRadius.circular(10)),
      child: const Icon(Icons.photo, color: AppColors.textMuted),
    );
    if (docs == null && !p.isAbsolute(path)) return placeholder;
    final full = p.isAbsolute(path) ? path : p.join(docs!, path);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.file(
        File(full),
        width: size,
        height: size,
        fit: BoxFit.cover,
        cacheWidth: (size * 3).round(),
        errorBuilder: (_, _, _) => placeholder,
      ),
    );
  }
}

/// Icon for a meal log source.
IconData sourceIcon(String source) => switch (source) {
      'ai_photo' => Icons.photo_camera,
      'ai_text' => Icons.keyboard_voice,
      'plan' => Icons.event_available,
      'saved' => Icons.bookmark,
      'supplement' => Icons.medication,
      _ => Icons.edit_note,
    };

Future<bool> confirmDialog(BuildContext context, {required String title, String? body, String? confirm}) async {
  final l = context.l10n;
  final ok = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      title: Text(title),
      content: body == null ? null : Text(body),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l.cancel)),
        FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(confirm ?? l.confirm)),
      ],
    ),
  );
  return ok ?? false;
}

/// Modal spinner while [task] runs. Returns its result (rethrows errors).
Future<T> runWithProgress<T>(BuildContext context, String message, Future<T> Function() task) async {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => PopScope(
      canPop: false,
      child: AlertDialog(
        content: Row(children: [
          const SizedBox(width: 28, height: 28, child: CircularProgressIndicator(strokeWidth: 3)),
          const SizedBox(width: 16),
          Expanded(child: Text(message)),
        ]),
      ),
    ),
  );
  try {
    return await task();
  } finally {
    if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
  }
}
