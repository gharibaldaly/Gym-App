/// flutter_local_notifications wrapper (all reminders + rest timer + coach initiatives).
class NotificationService {
  static Future<void> init() async {}

  /// Immediate notification (coach initiatives, PR…).
  static Future<void> showNow({required String title, required String body, String? payload}) async {}

  /// Rest-timer alarm that fires with sound + vibration even when the app is in background.
  static Future<void> scheduleRestTimer(Duration after, {required String title, required String body}) async {}

  static Future<void> cancelRestTimer() async {}
}
