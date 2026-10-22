import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/settings/app_settings.dart';
import '../../l10n/gen/app_localizations.dart';

/// Android notification channels used by the app.
enum NotifChannel {
  workout('workout'),
  meals('meals'),
  water('water'),
  supplements('supplements'),
  weight('weight'),
  coach('coach'),
  restTimer('rest_timer'),
  backup('backup'),
  work('ai_work');

  final String id;
  const NotifChannel(this.id);
}

/// Reminder types that the user can toggle independently (Settings → Notifications).
enum ReminderType { workout, meals, water, supplements, weight, coach, backup }

enum ReminderRepeat { daily, weekly }

/// Fixed notification ids / id ranges.
class NotifIds {
  static const restTimer = 1;
  static const backupReminder = 2;
  static const keepAliveWork = 3;

  /// Every scheduled reminder lives in [remindersStart, remindersEnd).
  static const remindersStart = 10000;
  static const remindersEnd = 20000;
  static const workoutBase = 10000; // + weekday (1..7)
  static const mealsBase = 10100; // + index
  static const waterBase = 10200; // + index
  static const supplementsBase = 10300; // + index
  static const weight = 10400;

  /// Immediate notifications (coach, PRs…) use ids >= this.
  static const immediateStart = 100000;

  static bool isReminder(int id) => id >= remindersStart && id < remindersEnd;
}

/// User preferences for reminders (stored under [SettingsKeys.notificationPrefix]).
class NotificationPrefs {
  final Map<ReminderType, bool> enabled;

  /// "HH:mm" overrides; null → derived from the profile.
  final String? workoutTime;
  final List<String>? mealTimes;
  final int waterIntervalHours;
  final List<String> supplementTimes;
  final String? weightTime;

  const NotificationPrefs({
    this.enabled = const {},
    this.workoutTime,
    this.mealTimes,
    this.waterIntervalHours = defaultWaterInterval,
    this.supplementTimes = const [defaultSupplementTime],
    this.weightTime,
  });

  static const defaultWaterInterval = 2;
  static const defaultSupplementTime = '10:00';

  static String enabledKey(ReminderType t) => '${SettingsKeys.notificationPrefix}${t.name}_enabled';
  static String timeKey(ReminderType t) => '${SettingsKeys.notificationPrefix}${t.name}_time';
  static String timesKey(ReminderType t) => '${SettingsKeys.notificationPrefix}${t.name}_times';
  static const waterIntervalKey = '${SettingsKeys.notificationPrefix}water_interval_h';

  /// When the last backup reminder notification was shown (ISO-8601).
  static const backupReminderShownKey = '${SettingsKeys.notificationPrefix}backup_reminder_shown_at';

  bool isEnabled(ReminderType t) => enabled[t] ?? true;

  static List<String>? _decodeList(String? raw) {
    if (raw == null) return null;
    try {
      return (jsonDecode(raw) as List).map((e) => e.toString()).where((s) => parseHmPair(s) != null).toList();
    } catch (_) {
      return null;
    }
  }

  factory NotificationPrefs.fromPrefs(SharedPreferences p) {
    return NotificationPrefs(
      enabled: {for (final t in ReminderType.values) t: p.getBool(enabledKey(t)) ?? true},
      workoutTime: _validHm(p.getString(timeKey(ReminderType.workout))),
      mealTimes: _decodeList(p.getString(timesKey(ReminderType.meals))),
      waterIntervalHours: (p.getInt(waterIntervalKey) ?? defaultWaterInterval).clamp(1, 6),
      supplementTimes: _decodeList(p.getString(timesKey(ReminderType.supplements))) ?? const [defaultSupplementTime],
      weightTime: _validHm(p.getString(timeKey(ReminderType.weight))),
    );
  }

  static String? _validHm(String? s) => parseHmPair(s) == null ? null : s;
}

/// The profile fields reminders depend on (decoupled from the DB row for testing).
class ReminderProfile {
  final List<int> trainingDays; // DateTime.weekday
  final String? trainingTime; // "18:00"
  final String? trainingTimeOfDay; // morning / after_work / night
  final List<String> mealTimes;
  final String? wakeTime;
  final String? sleepTime;
  final List<String> supplementNames;

  const ReminderProfile({
    this.trainingDays = const [],
    this.trainingTime,
    this.trainingTimeOfDay,
    this.mealTimes = const [],
    this.wakeTime,
    this.sleepTime,
    this.supplementNames = const [],
  });

  /// Training time from the profile ("18:00"), or a sensible default for the chosen part of the day.
  String get effectiveTrainingTime {
    if (parseHmPair(trainingTime) != null) return trainingTime!;
    return switch (trainingTimeOfDay) {
      'morning' => '08:00',
      'night' => '21:00',
      _ => '18:00',
    };
  }

  String get effectiveWake => parseHmPair(wakeTime) != null ? wakeTime! : '07:00';
  String get effectiveSleep => parseHmPair(sleepTime) != null ? sleepTime! : '23:00';
}

/// One reminder to schedule. [time] is the next occurrence (local time).
class PlannedNotification {
  final int id;
  final NotifChannel channel;
  final ReminderType type;
  final DateTime time;
  final ReminderRepeat repeat;
  final String title;
  final String body;

  const PlannedNotification({
    required this.id,
    required this.channel,
    required this.type,
    required this.time,
    required this.repeat,
    required this.title,
    required this.body,
  });

  String get payload => type.name;

  @override
  String toString() => 'PlannedNotification($id, ${type.name}, $time, ${repeat.name}, $title)';
}

/// "HH:mm" → (hour, minute) or null.
({int h, int m})? parseHmPair(String? s) {
  if (s == null) return null;
  final p = s.trim().split(':');
  if (p.length != 2) return null;
  final h = int.tryParse(p[0]), m = int.tryParse(p[1]);
  if (h == null || m == null || h < 0 || h > 23 || m < 0 || m > 59) return null;
  return (h: h, m: m);
}

String fmtHm(int h, int m) => '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';

/// Minutes since midnight → "HH:mm" (wraps around 24h).
String hmFromMinutes(int minutes) {
  final t = ((minutes % 1440) + 1440) % 1440;
  return fmtHm(t ~/ 60, t % 60);
}

int? _minutesOf(String? hm) {
  final p = parseHmPair(hm);
  return p == null ? null : p.h * 60 + p.m;
}

/// Next local occurrence of [hm] strictly after [now].
DateTime nextDaily(DateTime now, String hm) {
  final p = parseHmPair(hm)!;
  var t = DateTime(now.year, now.month, now.day, p.h, p.m);
  if (!t.isAfter(now)) t = DateTime(now.year, now.month, now.day + 1, p.h, p.m);
  return t;
}

/// Next local occurrence of [weekday] (1=Mon…7=Sun) at [hm] strictly after [now].
DateTime nextWeekly(DateTime now, int weekday, String hm) {
  final p = parseHmPair(hm)!;
  final delta = (weekday - now.weekday + 7) % 7;
  var t = DateTime(now.year, now.month, now.day + delta, p.h, p.m);
  if (!t.isAfter(now)) t = DateTime(now.year, now.month, now.day + delta + 7, p.h, p.m);
  return t;
}

/// Default workout reminder: 30 min before the training time.
String defaultWorkoutReminderTime(ReminderProfile p) => hmFromMinutes(_minutesOf(p.effectiveTrainingTime)! - 30);

/// Default weigh-in reminder: 15 min after waking up.
String defaultWeightReminderTime(ReminderProfile p) => hmFromMinutes(_minutesOf(p.effectiveWake)! + 15);

/// Water reminder times: every [intervalHours] after waking, strictly before sleep time.
List<String> waterReminderTimes(String wake, String sleep, int intervalHours) {
  final w = _minutesOf(wake), s0 = _minutesOf(sleep);
  if (w == null || s0 == null || intervalHours <= 0) return const [];
  var s = s0;
  if (s <= w) s += 1440; // sleeping after midnight
  final out = <String>[];
  for (var t = w + intervalHours * 60; t < s && out.length < 20; t += intervalHours * 60) {
    out.add(hmFromMinutes(t));
  }
  return out;
}

/// Computes every reminder that should be scheduled for [profile] + [prefs].
/// Pure (clock injected) so it can be unit-tested.
List<PlannedNotification> planReminders({
  required ReminderProfile? profile,
  required NotificationPrefs prefs,
  required DateTime now,
  required AppLocalizations l,
}) {
  if (profile == null) return const [];
  final out = <PlannedNotification>[];

  if (prefs.isEnabled(ReminderType.workout) && profile.trainingDays.isNotEmpty) {
    final time = prefs.workoutTime ?? defaultWorkoutReminderTime(profile);
    final days = profile.trainingDays.where((d) => d >= 1 && d <= 7).toSet().toList()..sort();
    for (final d in days) {
      out.add(PlannedNotification(
        id: NotifIds.workoutBase + d,
        channel: NotifChannel.workout,
        type: ReminderType.workout,
        time: nextWeekly(now, d, time),
        repeat: ReminderRepeat.weekly,
        title: l.setNotifWorkoutTitle,
        body: l.setNotifWorkoutBody(profile.effectiveTrainingTime),
      ));
    }
  }

  if (prefs.isEnabled(ReminderType.meals)) {
    final times = (prefs.mealTimes ?? profile.mealTimes).where((t) => parseHmPair(t) != null).toList();
    for (var i = 0; i < times.length && i < 10; i++) {
      out.add(PlannedNotification(
        id: NotifIds.mealsBase + i,
        channel: NotifChannel.meals,
        type: ReminderType.meals,
        time: nextDaily(now, times[i]),
        repeat: ReminderRepeat.daily,
        title: l.setNotifMealTitle(i + 1),
        body: l.setNotifMealBody,
      ));
    }
  }

  if (prefs.isEnabled(ReminderType.water)) {
    final times = waterReminderTimes(profile.effectiveWake, profile.effectiveSleep, prefs.waterIntervalHours);
    for (var i = 0; i < times.length; i++) {
      out.add(PlannedNotification(
        id: NotifIds.waterBase + i,
        channel: NotifChannel.water,
        type: ReminderType.water,
        time: nextDaily(now, times[i]),
        repeat: ReminderRepeat.daily,
        title: l.setNotifWaterTitle,
        body: l.setNotifWaterBody,
      ));
    }
  }

  if (prefs.isEnabled(ReminderType.supplements) && profile.supplementNames.isNotEmpty) {
    final times = prefs.supplementTimes.where((t) => parseHmPair(t) != null).toList();
    for (var i = 0; i < times.length && i < 10; i++) {
      out.add(PlannedNotification(
        id: NotifIds.supplementsBase + i,
        channel: NotifChannel.supplements,
        type: ReminderType.supplements,
        time: nextDaily(now, times[i]),
        repeat: ReminderRepeat.daily,
        title: l.setNotifSupplementsTitle,
        body: profile.supplementNames.join('، '),
      ));
    }
  }

  if (prefs.isEnabled(ReminderType.weight)) {
    final time = prefs.weightTime ?? defaultWeightReminderTime(profile);
    out.add(PlannedNotification(
      id: NotifIds.weight,
      channel: NotifChannel.weight,
      type: ReminderType.weight,
      time: nextDaily(now, time),
      repeat: ReminderRepeat.daily,
      title: l.setNotifWeightTitle,
      body: l.setNotifWeightBody,
    ));
  }

  return out;
}

/// True when a backup reminder is due: no backup for [days] days (counting from
/// [since] – e.g. profile creation – when there was never a backup), and the last
/// reminder was shown at least [days] days ago.
bool isBackupDue({
  required DateTime? lastBackupAt,
  required DateTime? since,
  required DateTime now,
  DateTime? lastReminderAt,
  int days = 14,
}) {
  final ref = lastBackupAt ?? since;
  if (ref == null) return false;
  final limit = Duration(days: days);
  if (now.difference(ref) < limit) return false;
  if (lastReminderAt != null && now.difference(lastReminderAt) < limit) return false;
  return true;
}
