import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../../core/settings/app_settings.dart';
import '../../data/db/database.dart';
import '../../data/repositories/profile_repository.dart';
import '../../l10n/gen/app_localizations.dart';
import 'reminder_planner.dart';

export 'reminder_planner.dart';

/// flutter_local_notifications wrapper (all reminders + rest timer + coach initiatives).
class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  static Future<bool>? _initFuture;
  static int _immediateCounter = 0;

  static final StreamController<String?> _taps = StreamController<String?>.broadcast();

  /// Payloads of notifications the user tapped while the app was running.
  static Stream<String?> get taps => _taps.stream;

  static String? _launchPayload;

  /// Payload of the notification that launched the app (consumed once).
  static String? consumeLaunchPayload() {
    final p = _launchPayload;
    _launchPayload = null;
    return p;
  }

  static bool get _supported => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  /// Initializes the plugin, time zones and channels. Safe to call many times.
  /// [requestPermission] also asks for POST_NOTIFICATIONS (Android 13+). By default
  /// the permission is requested by AppLockGate once onboarding is complete.
  static Future<void> init({bool requestPermission = false}) async {
    final ok = await (_initFuture ??= _doInit());
    if (ok && requestPermission) await requestPermissions();
  }

  static Future<bool> _ensureInit() => _initFuture ??= _doInit();

  static Future<bool> _doInit() async {
    if (!_supported) return false;
    try {
      await _initTimeZone();
      const settings = InitializationSettings(
        android: AndroidInitializationSettings('@drawable/ic_stat_ironmind'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      );
      await _plugin.initialize(
        settings: settings,
        onDidReceiveNotificationResponse: (r) => _taps.add(r.payload),
      );
      final launch = await _plugin.getNotificationAppLaunchDetails();
      if (launch?.didNotificationLaunchApp == true) _launchPayload = launch?.notificationResponse?.payload;
      await _createChannels();
      return true;
    } catch (e, st) {
      debugPrint('NotificationService.init failed: $e\n$st');
      _initFuture = null;
      return false;
    }
  }

  static Future<void> _initTimeZone() async {
    tzdata.initializeTimeZones();
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
      return;
    } catch (_) {
      // Fall through to the offset-based fallback.
    }
    final offset = DateTime.now().timeZoneOffset;
    if (offset.inMinutes % 60 == 0) {
      final h = offset.inHours;
      // Etc/GMT zones have inverted signs (Etc/GMT-2 == UTC+2).
      final name = h == 0 ? 'Etc/UTC' : 'Etc/GMT${h > 0 ? '-' : '+'}${h.abs()}';
      try {
        tz.setLocalLocation(tz.getLocation(name));
      } catch (_) {}
    }
  }

  static AndroidFlutterLocalNotificationsPlugin? get _android =>
      _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

  static String _lang(SharedPreferences? p) => p?.getString(SettingsKeys.language) ?? 'ar';

  static AppLocalizations _l10n(SharedPreferences? p) => lookupAppLocalizations(Locale(_lang(p)));

  static Future<void> _createChannels() async {
    final android = _android;
    if (android == null) return;
    SharedPreferences? prefs;
    try {
      prefs = await SharedPreferences.getInstance();
    } catch (_) {}
    final l = _l10n(prefs);
    for (final c in NotifChannel.values) {
      await android.createNotificationChannel(_channel(c, l));
    }
  }

  static String _channelName(NotifChannel c, AppLocalizations l) => switch (c) {
        NotifChannel.workout => l.setChannelWorkout,
        NotifChannel.meals => l.setChannelMeals,
        NotifChannel.water => l.setChannelWater,
        NotifChannel.supplements => l.setChannelSupplements,
        NotifChannel.weight => l.setChannelWeight,
        NotifChannel.coach => l.setChannelCoach,
        NotifChannel.restTimer => l.setChannelRestTimer,
        NotifChannel.backup => l.setChannelBackup,
        NotifChannel.work => l.setChannelWork,
      };

  static final Int64List _restVibration = Int64List.fromList([0, 600, 250, 600, 250, 900]);

  static AndroidNotificationChannel _channel(NotifChannel c, AppLocalizations l) {
    final rest = c == NotifChannel.restTimer;
    final high = rest || c == NotifChannel.workout || c == NotifChannel.coach;
    return AndroidNotificationChannel(
      c.id,
      _channelName(c, l),
      importance: rest ? Importance.max : (high ? Importance.high : Importance.defaultImportance),
      playSound: true,
      enableVibration: true,
      vibrationPattern: rest ? _restVibration : null,
      audioAttributesUsage: rest ? AudioAttributesUsage.alarm : AudioAttributesUsage.notification,
    );
  }

  static NotificationDetails _details(NotifChannel c, AppLocalizations l, {String? body}) {
    final rest = c == NotifChannel.restTimer;
    final high = rest || c == NotifChannel.workout || c == NotifChannel.coach;
    return NotificationDetails(
      android: AndroidNotificationDetails(
        c.id,
        _channelName(c, l),
        importance: rest ? Importance.max : (high ? Importance.high : Importance.defaultImportance),
        priority: high ? Priority.high : Priority.defaultPriority,
        playSound: true,
        enableVibration: true,
        vibrationPattern: rest ? _restVibration : null,
        category: rest ? AndroidNotificationCategory.alarm : AndroidNotificationCategory.reminder,
        audioAttributesUsage: rest ? AudioAttributesUsage.alarm : AudioAttributesUsage.notification,
        color: const Color(0xFF39FF14),
        styleInformation: body != null && body.length > 40 ? BigTextStyleInformation(body) : null,
      ),
      iOS: const DarwinNotificationDetails(presentAlert: true, presentSound: true),
    );
  }

  /// Starts (or updates) the "working…" foreground service so Android doesn't
  /// freeze the app while an AI request runs with the screen off / app in background.
  static Future<void> startWorkService({required String title, required String body}) async {
    if (!Platform.isAndroid || !await _ensureInit()) return;
    try {
      final l = _l10n(await SharedPreferences.getInstance());
      await _android?.startForegroundService(
        id: NotifIds.keepAliveWork,
        title: title,
        body: body,
        notificationDetails: AndroidNotificationDetails(
          NotifChannel.work.id,
          _channelName(NotifChannel.work, l),
          importance: Importance.low,
          priority: Priority.low,
          ongoing: true,
          onlyAlertOnce: true,
          showProgress: true,
          indeterminate: true,
          playSound: false,
          enableVibration: false,
          color: const Color(0xFF39FF14),
        ),
        startType: AndroidServiceStartType.startNotSticky,
        foregroundServiceTypes: {AndroidServiceForegroundType.foregroundServiceTypeDataSync},
      );
    } catch (e) {
      debugPrint('startWorkService failed: $e');
    }
  }

  static Future<void> stopWorkService() async {
    if (!Platform.isAndroid || !await _ensureInit()) return;
    try {
      await _android?.stopForegroundService();
    } catch (e) {
      debugPrint('stopWorkService failed: $e');
    }
  }

  /// Requests the Android 13+ notification permission. Returns whether notifications are allowed.
  static Future<bool> requestPermissions() async {
    if (!await _ensureInit()) return false;
    try {
      final android = _android;
      if (android != null) return await android.requestNotificationsPermission() ?? false;
      final ios = _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      return await ios?.requestPermissions(alert: true, sound: true, badge: true) ?? false;
    } catch (e) {
      debugPrint('requestPermissions failed: $e');
      return false;
    }
  }

  static Future<bool> areNotificationsEnabled() async {
    if (!await _ensureInit()) return false;
    try {
      return await _android?.areNotificationsEnabled() ?? true;
    } catch (_) {
      return true;
    }
  }

  static Future<bool> canScheduleExact() async {
    if (!await _ensureInit()) return false;
    try {
      return await _android?.canScheduleExactNotifications() ?? true;
    } catch (_) {
      return false;
    }
  }

  /// Opens the system "Alarms & reminders" page (only needed without USE_EXACT_ALARM).
  static Future<void> requestExactAlarms() async {
    if (!await _ensureInit()) return;
    try {
      await _android?.requestExactAlarmsPermission();
    } catch (_) {}
  }

  static Future<AndroidScheduleMode> _mode() async {
    final exact = await canScheduleExact();
    return exact ? AndroidScheduleMode.exactAllowWhileIdle : AndroidScheduleMode.inexactAllowWhileIdle;
  }

  /// True unless the user turned off coach notifications.
  static bool coachNotificationsEnabled(SharedPreferences prefs) =>
      prefs.getBool(NotificationPrefs.enabledKey(ReminderType.coach)) ?? true;

  /// Immediate notification (coach initiatives, PR…). Coach-channel notifications
  /// respect the "coach initiatives" toggle.
  static Future<void> showNow({
    required String title,
    required String body,
    String? payload,
    NotifChannel channel = NotifChannel.coach,
  }) async {
    if (!await _ensureInit()) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      if (channel == NotifChannel.coach && !coachNotificationsEnabled(prefs)) return;
      final id = NotifIds.immediateStart + (_immediateCounter++ % 1000) * 1000 + DateTime.now().millisecond;
      await _plugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: _details(channel, _l10n(prefs), body: body),
        payload: payload ?? channel.id,
      );
    } catch (e) {
      debugPrint('showNow failed: $e');
    }
  }

  /// Rest-timer alarm that fires with sound + vibration even when the app is in background.
  static Future<void> scheduleRestTimer(Duration after, {required String title, required String body}) async {
    if (!await _ensureInit()) return;
    try {
      await _plugin.cancel(id: NotifIds.restTimer);
      if (after <= Duration.zero) return;
      final prefs = await SharedPreferences.getInstance();
      await _plugin.zonedSchedule(
        id: NotifIds.restTimer,
        scheduledDate: tz.TZDateTime.now(tz.local).add(after),
        notificationDetails: _details(NotifChannel.restTimer, _l10n(prefs)),
        androidScheduleMode: await _mode(),
        title: title,
        body: body,
        payload: NotifChannel.restTimer.id,
      );
    } catch (e) {
      debugPrint('scheduleRestTimer failed: $e');
    }
  }

  static Future<void> cancelRestTimer() async {
    if (!await _ensureInit()) return;
    try {
      await _plugin.cancel(id: NotifIds.restTimer);
    } catch (_) {}
  }

  /// Builds the reminder inputs from the DB (profile + active supplements).
  static Future<ReminderProfile?> loadReminderProfile(AppDatabase db) async {
    final p = await ProfileRepository(db).get();
    if (p == null || !p.onboardingComplete) return null;
    final supps = await (db.select(db.supplements)..where((t) => t.active.equals(true))).get();
    var names = supps.map((s) => s.name).toList();
    if (names.isEmpty) {
      try {
        names = p.supplementsList.map((m) => (m['name'] ?? '').toString()).where((s) => s.isNotEmpty).toList();
      } catch (_) {}
    }
    List<int> days;
    List<String> meals;
    try {
      days = p.trainingDays;
    } catch (_) {
      days = const [];
    }
    try {
      meals = p.mealTimes;
    } catch (_) {
      meals = const [];
    }
    return ReminderProfile(
      trainingDays: days,
      trainingTime: p.trainingTime,
      trainingTimeOfDay: p.trainingTimeOfDay,
      mealTimes: meals,
      wakeTime: p.wakeTime,
      sleepTime: p.sleepTime,
      supplementNames: names,
    );
  }

  static Future<void>? _rescheduling;

  /// Cancels and reschedules every reminder from the profile + notification settings.
  /// Call on start-up and whenever the profile or the notification settings change.
  static Future<void> rescheduleAll(AppDatabase db, SharedPreferences prefs, {DateTime? now}) async {
    // Serialize concurrent calls (settings screen + bootstrap + background).
    while (_rescheduling != null) {
      await _rescheduling;
    }
    final c = Completer<void>();
    _rescheduling = c.future;
    try {
      await _reschedule(db, prefs, now ?? DateTime.now());
    } catch (e, st) {
      debugPrint('rescheduleAll failed: $e\n$st');
    } finally {
      _rescheduling = null;
      c.complete();
    }
  }

  static Future<void> _reschedule(AppDatabase db, SharedPreferences prefs, DateTime now) async {
    if (!await _ensureInit()) return;
    final pending = await _plugin.pendingNotificationRequests();
    for (final r in pending) {
      if (NotifIds.isReminder(r.id)) await _plugin.cancel(id: r.id);
    }
    final profile = await loadReminderProfile(db);
    final l = _l10n(prefs);
    final plan = planReminders(profile: profile, prefs: NotificationPrefs.fromPrefs(prefs), now: now, l: l);
    if (plan.isEmpty) return;
    final mode = await _mode();
    for (final n in plan) {
      await _plugin.zonedSchedule(
        id: n.id,
        scheduledDate: tz.TZDateTime.from(n.time, tz.local),
        notificationDetails: _details(n.channel, l, body: n.body),
        androidScheduleMode: mode,
        title: n.title,
        body: n.body,
        payload: n.payload,
        matchDateTimeComponents:
            n.repeat == ReminderRepeat.weekly ? DateTimeComponents.dayOfWeekAndTime : DateTimeComponents.time,
      );
    }
  }

  /// Shows the "you haven't backed up in 2 weeks" notification when due.
  static Future<void> checkBackupReminder(AppDatabase db, SharedPreferences prefs, {DateTime? now}) async {
    if (!(prefs.getBool(NotificationPrefs.enabledKey(ReminderType.backup)) ?? true)) return;
    final t = now ?? DateTime.now();
    final last = DateTime.tryParse(prefs.getString(SettingsKeys.lastBackupAt) ?? '');
    final shown = DateTime.tryParse(prefs.getString(NotificationPrefs.backupReminderShownKey) ?? '');
    final profile = await ProfileRepository(db).get();
    if (profile == null || !profile.onboardingComplete) return;
    if (!isBackupDue(lastBackupAt: last, since: profile.createdAt, now: t, lastReminderAt: shown)) return;
    if (!await _ensureInit()) return;
    final l = _l10n(prefs);
    await _plugin.show(
      id: NotifIds.backupReminder,
      title: l.setNotifBackupTitle,
      body: l.setNotifBackupBody,
      notificationDetails: _details(NotifChannel.backup, l),
      payload: 'backup',
    );
    await prefs.setString(NotificationPrefs.backupReminderShownKey, t.toIso8601String());
  }

  /// For tests / debugging.
  @visibleForTesting
  static Future<List<int>> pendingIds() async {
    if (!await _ensureInit()) return const [];
    return (await _plugin.pendingNotificationRequests()).map((e) => e.id).toList();
  }
}
