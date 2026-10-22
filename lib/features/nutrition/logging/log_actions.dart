import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../ai/ai_queue.dart';
import '../../../ai/ai_service.dart';
import '../../../core/navigation.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/context_ext.dart';
import '../food_ai.dart';
import '../nutrition_logic.dart';
import '../nutrition_repository.dart';
import '../photo_utils.dart';
import '../widgets/nut_widgets.dart';
import 'food_review_screen.dart';
import 'food_text_screen.dart';
import 'my_foods_screen.dart';

/// FAB bottom sheet: photo / text-voice / my foods / manual.
Future<void> showLogFoodSheet(BuildContext context, WidgetRef ref, {int? mealIndex}) async {
  final l = context.l10n;
  final choice = await showModalBottomSheet<String>(
    context: context,
    useSafeArea: true,
    builder: (c) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 8),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(l.nutLogFood, style: c.text.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
            ),
          ),
          _OptionTile(icon: Symbols.photo_camera_rounded, title: l.nutLogPhoto, subtitle: l.nutLogPhotoHint, value: 'photo'),
          _OptionTile(icon: Symbols.keyboard_voice_rounded, title: l.nutLogText, subtitle: l.nutLogTextHint, value: 'text'),
          _OptionTile(icon: Symbols.bookmark_rounded, title: l.nutMyFoods, subtitle: l.nutMyFoodsHint, value: 'mine'),
          _OptionTile(icon: Symbols.list_alt_rounded, title: l.nutLogManual, subtitle: l.nutLogManualHint, value: 'manual'),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
  if (choice == null || !context.mounted) return;
  switch (choice) {
    case 'photo':
      await logFromPhoto(context, ref, mealIndex: mealIndex);
    case 'text':
      await _pushAndConfirm(context, FoodTextScreen(mealIndex: mealIndex));
    case 'mine':
      await push<void>(context, MyFoodsScreen(mealIndex: mealIndex));
    case 'manual':
      await _pushAndConfirm(context, FoodReviewScreen(source: 'manual', mealIndex: mealIndex, openPickerOnStart: true));
  }
}

/// Pushes a logging screen and shows "logged" when it pops with `true`.
Future<void> _pushAndConfirm(BuildContext context, Widget page) async {
  final saved = await push<bool>(context, page);
  if (saved == true && context.mounted) context.snack(context.l10n.nutLogged);
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String title, subtitle, value;
  const _OptionTile({required this.icon, required this.title, required this.subtitle, required this.value});

  @override
  Widget build(BuildContext context) => ListTile(
        minVerticalPadding: 12,
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.15),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        onTap: () => Navigator.pop(context, value),
      );
}

/// Photo → compress → (Claude vision → review) or (pending log + offline queue).
Future<void> logFromPhoto(BuildContext context, WidgetRef ref, {int? mealIndex}) async {
  final l = context.l10n;
  final source = await showModalBottomSheet<ImageSource>(
    context: context,
    builder: (c) => SafeArea(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        ListTile(
          leading: const Icon(Symbols.photo_camera_rounded, fill: 1),
          title: Text(l.nutTakePhoto),
          onTap: () => Navigator.pop(c, ImageSource.camera),
        ),
        ListTile(
          leading: const Icon(Symbols.photo_library_rounded, fill: 1),
          title: Text(l.nutFromGallery),
          onTap: () => Navigator.pop(c, ImageSource.gallery),
        ),
      ]),
    ),
  );
  if (source == null || !context.mounted) return;

  final XFile? file;
  try {
    file = await ImagePicker().pickImage(
      source: source,
      maxWidth: mealPhotoMaxSide.toDouble(),
      maxHeight: mealPhotoMaxSide.toDouble(),
      imageQuality: 90,
    );
  } catch (e) {
    if (context.mounted) context.snack(l.nutPhotoError);
    return;
  }
  if (file == null || !context.mounted) return;

  final bytes = await compressMealPhoto(file.path);
  final relPath = await NutritionRepository.savePhoto(bytes);
  if (!context.mounted) return;

  final repo = ref.read(nutritionRepositoryProvider);
  final hasKey = await ref.read(aiServiceProvider).hasKey;
  final online = ref.read(isOnlineProvider);

  Future<void> queueForLater() async {
    final id = await repo.addLog(
      day: today(),
      name: l.nutPhotoMealName,
      items: const [],
      source: 'ai_photo',
      mealIndex: mealIndex,
      photoPath: relPath,
      status: 'pending_ai',
    );
    await ref.read(aiQueueProvider).enqueue(FoodAi.photoQueueKey, {'logId': id});
    if (context.mounted) context.snack(hasKey ? l.aiQueuedOffline : l.nutQueuedNoKey);
  }

  if (!hasKey || !online) {
    await queueForLater();
    return;
  }

  if (!context.mounted) return;
  final FoodAnalysis analysis;
  try {
    analysis = await runWithProgress(context, l.nutAnalyzingPhoto, () => ref.read(foodAiProvider).analyzePhoto(bytes));
  } on AiOfflineException {
    await queueForLater();
    return;
  } catch (e) {
    final isAr = context.mounted && context.isAr;
    if (!context.mounted) return;
    final action = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l.nutAnalysisFailed),
        content: Text(aiErrorText(e, ar: isAr)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, 'manual'), child: Text(l.nutLogManually)),
          FilledButton(onPressed: () => Navigator.pop(c, 'later'), child: Text(l.nutAnalyzeLater)),
        ],
      ),
    );
    if (!context.mounted) return;
    if (action == 'later') {
      await queueForLater();
    } else if (action == 'manual') {
      await _pushAndConfirm(
        context,
        FoodReviewScreen(source: 'manual', photoPath: relPath, mealIndex: mealIndex, openPickerOnStart: true),
      );
    }
    return;
  }
  if (!context.mounted) return;
  await _pushAndConfirm(
    context,
    FoodReviewScreen(
      items: analysis.items,
      name: analysis.mealName(context.lang),
      source: 'ai_photo',
      photoPath: relPath,
      confidence: analysis.confidence,
      notes: analysis.notes,
      mealIndex: mealIndex,
    ),
  );
}

/// Shared entry used by the "Today" meal list: log a planned meal exactly.
Future<void> logPlannedMealOneTap(BuildContext context, WidgetRef ref, PlannedMeal meal, {double portion = 1}) async {
  final l = context.l10n;
  final repo = ref.read(nutritionRepositoryProvider);
  final id = await repo.logPlannedMeal(meal, today(), portion: portion);
  if (!context.mounted) return;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(l.nutLoggedMeal(pickBilingual(meal.name, context.lang))),
      action: SnackBarAction(label: l.nutUndo, onPressed: () => repo.deleteLog(id)),
    ));
}
