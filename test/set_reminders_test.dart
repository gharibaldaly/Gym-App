import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:ironmind/l10n/gen/app_localizations.dart';
import 'package:ironmind/services/notifications/reminder_planner.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final l = lookupAppLocalizations(const Locale('en'));
  // Tuesday 20 Oct 2026, 10:00.
  final now = DateTime(2026, 10, 20, 10, 0);

  const profile = ReminderProfile(
    trainingDays: [1, 3, 5], // Mon, Wed, Fri
    trainingTime: '18:00',
    mealTimes: ['08:00', '13:30', '20:00'],
    wakeTime: '07:00',
    sleepTime: '23:30',
    supplementNames: ['Creatine', 'Whey'],
  );

  test('time helpers', () {
    expect(nextDaily(now, '09:00'), DateTime(2026, 10, 21, 9, 0)); // already passed today
    expect(nextDaily(now, '10:00'), DateTime(2026, 10, 21, 10, 0)); // strictly after now
    expect(nextDaily(now, '13:30'), DateTime(2026, 10, 20, 13, 30));
    expect(nextWeekly(now, 1, '17:30'), DateTime(2026, 10, 26, 17, 30)); // next Monday
    expect(nextWeekly(now, 2, '17:30'), DateTime(2026, 10, 20, 17, 30)); // later today
    expect(nextWeekly(now, 2, '08:00'), DateTime(2026, 10, 27, 8, 0)); // passed → next week
    expect(waterReminderTimes('07:00', '23:30', 2), ['09:00', '11:00', '13:00', '15:00', '17:00', '19:00', '21:00', '23:00']);
    expect(waterReminderTimes('10:00', '01:00', 4), ['14:00', '18:00', '22:00']); // sleep after midnight
    expect(waterReminderTimes('22:00', '02:00', 1), ['23:00', '00:00', '01:00']);
    expect(defaultWorkoutReminderTime(profile), '17:30');
    expect(defaultWeightReminderTime(profile), '07:15');
    expect(hmFromMinutes(-15), '23:45');
  });

  test('plans every reminder with default prefs', () {
    final plan = planReminders(profile: profile, prefs: const NotificationPrefs(), now: now, l: l);
    final workout = plan.where((p) => p.type == ReminderType.workout).toList();
    expect(workout.map((p) => p.id), [10001, 10003, 10005]);
    expect(workout.every((p) => p.repeat == ReminderRepeat.weekly), isTrue);
    expect(workout.first.time, DateTime(2026, 10, 26, 17, 30));
    expect(workout[1].time, DateTime(2026, 10, 21, 17, 30));
    expect(workout.first.title, l.setNotifWorkoutTitle);

    final meals = plan.where((p) => p.type == ReminderType.meals).toList();
    expect(meals.map((p) => p.id), [10100, 10101, 10102]);
    expect(meals.map((p) => p.time), [
      DateTime(2026, 10, 21, 8, 0),
      DateTime(2026, 10, 20, 13, 30),
      DateTime(2026, 10, 20, 20, 0),
    ]);
    expect(meals[1].title, l.setNotifMealTitle(2));

    final water = plan.where((p) => p.type == ReminderType.water).toList();
    expect(water.length, 8);
    expect(water.first.id, 10200);
    expect(water.first.time, DateTime(2026, 10, 21, 9, 0));

    final supp = plan.singleWhere((p) => p.type == ReminderType.supplements);
    expect(supp.time, DateTime(2026, 10, 21, 10, 0));
    expect(supp.body, contains('Creatine'));

    final weight = plan.singleWhere((p) => p.type == ReminderType.weight);
    expect(weight.id, NotifIds.weight);
    expect(weight.time, DateTime(2026, 10, 21, 7, 15));

    // All ids unique and inside the reminder range.
    final ids = plan.map((p) => p.id).toList();
    expect(ids.toSet().length, ids.length);
    expect(ids.every(NotifIds.isReminder), isTrue);
  });

  test('respects toggles and overrides', () {
    final prefs = NotificationPrefs(
      enabled: const {ReminderType.water: false, ReminderType.weight: false},
      workoutTime: '06:45',
      mealTimes: const ['12:00'],
      supplementTimes: const ['09:00', '21:00'],
    );
    final plan = planReminders(profile: profile, prefs: prefs, now: now, l: l);
    expect(plan.where((p) => p.type == ReminderType.water), isEmpty);
    expect(plan.where((p) => p.type == ReminderType.weight), isEmpty);
    expect(plan.where((p) => p.type == ReminderType.workout).map((p) => p.time), contains(DateTime(2026, 10, 21, 6, 45)));
    expect(plan.where((p) => p.type == ReminderType.meals).map((p) => p.time), [DateTime(2026, 10, 20, 12, 0)]);
    expect(plan.where((p) => p.type == ReminderType.supplements).length, 2);
  });

  test('no supplements / no training days / no profile', () {
    const bare = ReminderProfile(wakeTime: '07:00', sleepTime: '23:00');
    final plan = planReminders(profile: bare, prefs: const NotificationPrefs(), now: now, l: l);
    expect(plan.where((p) => p.type == ReminderType.workout), isEmpty);
    expect(plan.where((p) => p.type == ReminderType.supplements), isEmpty);
    expect(plan.where((p) => p.type == ReminderType.meals), isEmpty);
    expect(planReminders(profile: null, prefs: const NotificationPrefs(), now: now, l: l), isEmpty);
  });

  test('reads prefs from SharedPreferences', () async {
    SharedPreferences.setMockInitialValues({
      NotificationPrefs.enabledKey(ReminderType.meals): false,
      NotificationPrefs.timeKey(ReminderType.weight): '06:30',
      NotificationPrefs.timeKey(ReminderType.workout): 'bad',
      NotificationPrefs.waterIntervalKey: 3,
      NotificationPrefs.timesKey(ReminderType.supplements): '["08:15","22:00"]',
    });
    final np = NotificationPrefs.fromPrefs(await SharedPreferences.getInstance());
    expect(np.isEnabled(ReminderType.meals), isFalse);
    expect(np.isEnabled(ReminderType.water), isTrue);
    expect(np.weightTime, '06:30');
    expect(np.workoutTime, isNull);
    expect(np.waterIntervalHours, 3);
    expect(np.supplementTimes, ['08:15', '22:00']);
  });

  test('backup reminder due rule', () {
    final t = DateTime(2026, 10, 20);
    expect(isBackupDue(lastBackupAt: t.subtract(const Duration(days: 3)), since: null, now: t), isFalse);
    expect(isBackupDue(lastBackupAt: t.subtract(const Duration(days: 15)), since: null, now: t), isTrue);
    expect(isBackupDue(lastBackupAt: null, since: t.subtract(const Duration(days: 20)), now: t), isTrue);
    expect(isBackupDue(lastBackupAt: null, since: t.subtract(const Duration(days: 2)), now: t), isFalse);
    expect(isBackupDue(lastBackupAt: null, since: null, now: t), isFalse);
    expect(
      isBackupDue(
        lastBackupAt: t.subtract(const Duration(days: 30)),
        since: null,
        now: t,
        lastReminderAt: t.subtract(const Duration(days: 1)),
      ),
      isFalse,
    );
  });
}
