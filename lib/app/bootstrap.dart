import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../ai/ai_queue.dart';
import '../core/providers.dart';
import '../features/coach/coach_initiatives.dart';
import '../features/exercises/exercise_seed.dart';
import '../features/nutrition/nutrition_providers.dart';
import '../features/tracking/health_service.dart';
import '../features/workout/workout_maintenance.dart';
import '../services/background/background_tasks.dart';
import '../services/notifications/notification_service.dart';
import '../services/widget/home_widget_service.dart';

/// Registers every feature's offline AI-queue handlers (idempotent).
void registerAiQueueHandlers() {
  registerWorkoutAiHandlers();
  registerNutritionAiHandlers();
  registerCoachAiHandlers();
}

/// One-time startup work. Blocking steps are only those the UI needs (DB seed);
/// everything else runs in the background so the first frame isn't delayed.
final bootstrapProvider = FutureProvider<void>((ref) async {
  final db = ref.read(databaseProvider);
  final prefs = ref.read(sharedPrefsProvider);
  registerAiQueueHandlers();
  await seedExercisesIfNeeded(db, prefs);

  Future<void> guard(String name, Future<void> Function() f) async {
    try {
      await f();
    } catch (e, st) {
      debugPrint('bootstrap $name failed: $e\n$st');
    }
  }

  unawaited(() async {
    await guard('notifications', NotificationService.init);
    await guard('home widget', HomeWidgetService.init);
    await guard('background', initBackgroundTasks);
    await guard('missed days', () => markMissedDays(db));
    await guard('health', () => ref.read(healthServiceProvider).sync());
    await guard('ai queue', () => ref.read(aiQueueProvider).process());
    await guard('coach checks', () => ref.read(coachInitiativesProvider).runScheduledChecks());
    await guard('widget update', () => HomeWidgetService.update(ref));
  }());
});
