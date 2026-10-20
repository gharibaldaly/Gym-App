import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../../ai/ai_queue.dart';
import '../../app/bootstrap.dart' show registerAiQueueHandlers;
import '../../core/providers.dart';
import '../../features/coach/coach_initiatives.dart';
import '../../features/tracking/health_service.dart';
import '../notifications/notification_service.dart';
import '../widget/home_widget_service.dart';

const periodicTaskName = 'ironmind_periodic';

/// workmanager setup: periodic health sync + coach scheduled checks + reminders.
Future<void> initBackgroundTasks() async {
  if (kIsWeb || !Platform.isAndroid) return;
  await Workmanager().initialize(callbackDispatcher);
  await Workmanager().registerPeriodicTask(
    periodicTaskName,
    periodicTaskName,
    frequency: const Duration(hours: 3),
    flexInterval: const Duration(minutes: 45),
    initialDelay: const Duration(minutes: 20),
    constraints: Constraints(networkType: NetworkType.notRequired, requiresBatteryNotLow: true),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
  );
}

/// Entry point of the workmanager background isolate.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    await runBackgroundWork();
    return true;
  });
}

/// The periodic job. Every step is guarded so one failure doesn't stop the rest.
Future<void> runBackgroundWork() async {
  final prefs = await SharedPreferences.getInstance();
  final container = ProviderContainer(overrides: [sharedPrefsProvider.overrideWithValue(prefs)]);

  Future<void> step(String name, Future<void> Function() f) async {
    try {
      await f().timeout(const Duration(minutes: 3));
    } catch (e, st) {
      debugPrint('background $name failed: $e\n$st');
    }
  }

  try {
    registerAiQueueHandlers();
    final db = container.read(databaseProvider);
    await step('notifications', () => NotificationService.init(requestPermission: false));
    await step('health', () => container.read(healthServiceProvider).sync());
    await step('coach', () => container.read(coachInitiativesProvider).runScheduledChecks());
    await step('ai queue', () => container.read(aiQueueProvider).process());
    await step('reminders', () => NotificationService.rescheduleAll(db, prefs));
    await step('backup reminder', () => NotificationService.checkBackupReminder(db, prefs));
    await step('widget', () => HomeWidgetService.updateWith(container.read));
  } finally {
    container.dispose();
  }
}
