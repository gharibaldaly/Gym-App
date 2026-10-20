import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/providers.dart';
import '../../data/repositories/profile_repository.dart';
import '../../features/nutrition/nutrition_providers.dart';
import '../../features/tracking/tracking_providers.dart';
import '../../features/workout/today_workout_provider.dart';
import '../../l10n/gen/app_localizations.dart';

/// `ref.read`, `WidgetRef.read` and `ProviderContainer.read` all fit this type.
typedef ProviderReader = T Function<T>(ProviderListenable<T> provider);

/// Everything the home-screen widget shows.
class WidgetSnapshot {
  final String? workoutName;
  final bool isRestDay;
  final bool hasPlan;
  final bool workoutDone;
  final int exerciseCount;
  final double? remainingCalories; // null → no target set
  final int waterMl;
  final int waterGoalMl;

  const WidgetSnapshot({
    this.workoutName,
    this.isRestDay = false,
    this.hasPlan = false,
    this.workoutDone = false,
    this.exerciseCount = 0,
    this.remainingCalories,
    this.waterMl = 0,
    this.waterGoalMl = 3000,
  });

  WidgetSnapshot copyWith({int? waterMl, int? waterGoalMl}) => WidgetSnapshot(
        workoutName: workoutName,
        isRestDay: isRestDay,
        hasPlan: hasPlan,
        workoutDone: workoutDone,
        exerciseCount: exerciseCount,
        remainingCalories: remainingCalories,
        waterMl: waterMl ?? this.waterMl,
        waterGoalMl: waterGoalMl ?? this.waterGoalMl,
      );
}

/// Direct DB queries used when providers aren't available (background isolates).
class WidgetDbQueries {
  final AppDatabase db;
  WidgetDbQueries(this.db);

  DateTime get _today {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  Future<int> waterToday() async {
    final start = _today, end = start.add(const Duration(days: 1));
    final sum = db.waterLogs.amountMl.sum();
    final q = db.selectOnly(db.waterLogs)
      ..addColumns([sum])
      ..where(db.waterLogs.timestamp.isBiggerOrEqualValue(start) & db.waterLogs.timestamp.isSmallerThanValue(end));
    return (await q.getSingle()).read(sum) ?? 0;
  }

  Future<int> waterGoal() async {
    final p = await ProfileRepository(db).get();
    return p?.waterGoalMl ?? 3000;
  }

  Future<double?> remainingCalories() async {
    final p = await ProfileRepository(db).get();
    final target = p?.caloriesFor(_today);
    if (target == null || target <= 0) return null;
    final start = _today, end = start.add(const Duration(days: 1));
    final kcal = db.mealLogs.calories.sum();
    final mq = db.selectOnly(db.mealLogs)
      ..addColumns([kcal])
      ..where(db.mealLogs.date.isBiggerOrEqualValue(start) &
          db.mealLogs.date.isSmallerThanValue(end) &
          db.mealLogs.status.equals('done'));
    final meals = (await mq.getSingle()).read(kcal) ?? 0;
    final logs = await (db.select(db.supplementLogs).join([
      innerJoin(db.supplements, db.supplements.id.equalsExp(db.supplementLogs.supplementId)),
    ])
          ..where(db.supplementLogs.date.isBiggerOrEqualValue(start) &
              db.supplementLogs.date.isSmallerThanValue(end) &
              db.supplementLogs.taken.equals(true)))
        .get();
    final supp = logs.fold<double>(0, (a, r) => a + r.readTable(db.supplements).calories);
    return target - meals - supp;
  }

  Future<WidgetSnapshot> workoutPart() async {
    final start = _today, end = start.add(const Duration(days: 1));
    final session = await (db.select(db.workoutSessions)
          ..where((t) => t.date.isBiggerOrEqualValue(start) & t.date.isSmallerThanValue(end) & t.status.isNotValue('missed'))
          ..orderBy([(t) => OrderingTerm.desc(t.id)])
          ..limit(1))
        .getSingleOrNull();
    final plan = await (db.select(db.workoutPlans)..where((t) => t.isActive.equals(true))..limit(1)).getSingleOrNull();
    PlanDay? day;
    if (plan != null) {
      day = await (db.select(db.planDays)
            ..where((t) => t.planId.equals(plan.id) & t.weekday.equals(start.weekday))
            ..limit(1))
          .getSingleOrNull();
    }
    if (session?.planDayId != null && day?.id != session!.planDayId) {
      day = await (db.select(db.planDays)..where((t) => t.id.equals(session.planDayId!))).getSingleOrNull() ?? day;
    }
    var count = 0;
    if (day != null && !day.isRest) {
      final c = db.planExercises.id.count();
      final q = db.selectOnly(db.planExercises)
        ..addColumns([c])
        ..where(db.planExercises.planDayId.equals(day.id));
      count = (await q.getSingle()).read(c) ?? 0;
    }
    final done = session != null && (session.status == 'completed' || session.status == 'partial');
    return WidgetSnapshot(
      workoutName: session?.name ?? day?.name,
      hasPlan: plan != null || session != null,
      isRestDay: session == null && (plan != null && (day == null || day.isRest)),
      workoutDone: done,
      exerciseCount: count,
    );
  }

  Future<WidgetSnapshot> snapshot() async {
    final w = await workoutPart();
    return WidgetSnapshot(
      workoutName: w.workoutName,
      hasPlan: w.hasPlan,
      isRestDay: w.isRestDay,
      workoutDone: w.workoutDone,
      exerciseCount: w.exerciseCount,
      remainingCalories: await remainingCalories(),
      waterMl: await waterToday(),
      waterGoalMl: await waterGoal(),
    );
  }
}

/// Pushes today's workout / remaining calories / water to the Android home widget.
class HomeWidgetService {
  /// Fully-qualified name of the Kotlin AppWidgetProvider.
  static const androidProvider = 'com.ironmind.ironmind.IronMindWidgetProvider';

  /// URI host sent by the widget's "+ cup" button.
  static const addWaterHost = 'addwater';

  static bool get _supported => !kIsWeb && Platform.isAndroid;

  static Future<void> init() async {
    if (!_supported) return;
    try {
      await HomeWidget.registerInteractivityCallback(homeWidgetInteractivityCallback);
    } catch (e) {
      debugPrint('HomeWidgetService.init failed: $e');
    }
  }

  static Future<void> update(Ref ref) => updateWith(ref.read);

  /// Reads the feature providers (with a DB fallback per value) and refreshes the widget.
  static Future<void> updateWith(ProviderReader read) async {
    if (!_supported) return;
    try {
      final db = read(databaseProvider);
      final prefs = read(sharedPrefsProvider);
      final q = WidgetDbQueries(db);
      const timeout = Duration(seconds: 4);

      WidgetSnapshot work;
      try {
        final t = await read(todayWorkoutProvider.future).timeout(timeout);
        final done = t.session != null && (t.session!.status == 'completed' || t.session!.status == 'partial');
        work = WidgetSnapshot(
          workoutName: t.session?.name ?? t.planDay?.name,
          hasPlan: t.planDay != null || t.session != null || t.isRestDay,
          isRestDay: t.isRestDay,
          workoutDone: done,
          exerciseCount: t.exerciseCount,
        );
      } catch (_) {
        work = await q.workoutPart();
      }

      double? remaining;
      try {
        final n = await read(todayNutritionProvider.future).timeout(timeout);
        remaining = n.targetCalories > 0 ? n.remainingCalories : await q.remainingCalories();
      } catch (_) {
        remaining = await q.remainingCalories();
      }

      int water;
      try {
        water = await read(todayWaterProvider.future).timeout(timeout);
      } catch (_) {
        water = await q.waterToday();
      }
      int goal;
      try {
        goal = read(waterGoalProvider);
      } catch (_) {
        goal = await q.waterGoal();
      }

      await push(
        WidgetSnapshot(
          workoutName: work.workoutName,
          hasPlan: work.hasPlan,
          isRestDay: work.isRestDay,
          workoutDone: work.workoutDone,
          exerciseCount: work.exerciseCount,
          remainingCalories: remaining,
          waterMl: water,
          waterGoalMl: goal,
        ),
        prefs,
      );
    } catch (e, st) {
      debugPrint('HomeWidgetService.update failed: $e\n$st');
    }
  }

  /// Refresh from the DB only (background isolates without providers).
  static Future<void> updateFromDb(AppDatabase db, SharedPreferences prefs) async {
    if (!_supported) return;
    try {
      await push(await WidgetDbQueries(db).snapshot(), prefs);
    } catch (e) {
      debugPrint('HomeWidgetService.updateFromDb failed: $e');
    }
  }

  /// Writes [s] into the widget storage (localized strings) and redraws the widget.
  static Future<void> push(WidgetSnapshot s, SharedPreferences prefs) async {
    final l = lookupAppLocalizations(Locale(prefs.getString(SettingsKeys.language) ?? 'ar'));
    final String title, sub;
    if (!s.hasPlan) {
      title = l.setWidgetNoPlan;
      sub = l.setWidgetOpenApp;
    } else if (s.workoutDone) {
      title = s.workoutName ?? l.setWidgetWorkout;
      sub = l.setWidgetWorkoutDone;
    } else if (s.isRestDay) {
      title = l.setWidgetRestDay;
      sub = l.setWidgetRestSub;
    } else {
      title = s.workoutName ?? l.setWidgetWorkout;
      sub = s.exerciseCount > 0 ? l.setWidgetExercises(s.exerciseCount) : l.setWidgetWorkout;
    }
    final rem = s.remainingCalories;
    final String kcalText;
    if (rem == null) {
      kcalText = '—';
    } else if (rem >= 0) {
      kcalText = l.setWidgetKcalLeft(rem.round());
    } else {
      kcalText = l.setWidgetKcalOver((-rem).round());
    }
    final pct = s.waterGoalMl <= 0 ? 0 : ((s.waterMl / s.waterGoalMl) * 100).round().clamp(0, 100);
    final cup = prefs.getInt(SettingsKeys.waterCupMl) ?? 250;

    final data = <String, Object>{
      'im_title': l.appName,
      'im_workout_label': l.setWidgetWorkoutLabel,
      'im_workout_title': title,
      'im_workout_sub': sub,
      'im_kcal_label': l.setWidgetCaloriesLabel,
      'im_kcal_text': kcalText,
      'im_water_label': l.setWidgetWaterLabel,
      'im_water_text': l.setWidgetWaterText(s.waterMl, s.waterGoalMl),
      'im_water_pct': pct,
      'im_cup_label': l.setWidgetAddCup(cup),
      'im_rtl': prefs.getString(SettingsKeys.language) != 'en',
    };
    for (final e in data.entries) {
      await HomeWidget.saveWidgetData(e.key, e.value);
    }
    await HomeWidget.updateWidget(qualifiedAndroidName: androidProvider);
  }

  /// Only refreshes the water part (after "+ cup" from the widget).
  static Future<void> pushWater(AppDatabase db, SharedPreferences prefs) async {
    final q = WidgetDbQueries(db);
    final ml = await q.waterToday(), goal = await q.waterGoal();
    final l = lookupAppLocalizations(Locale(prefs.getString(SettingsKeys.language) ?? 'ar'));
    final pct = goal <= 0 ? 0 : ((ml / goal) * 100).round().clamp(0, 100);
    await HomeWidget.saveWidgetData('im_water_text', l.setWidgetWaterText(ml, goal));
    await HomeWidget.saveWidgetData('im_water_pct', pct);
    await HomeWidget.updateWidget(qualifiedAndroidName: androidProvider);
  }
}

/// Runs in a background isolate when the widget's "+ cup" button is tapped.
/// Logs one cup of water without opening the app, then refreshes the widget.
@pragma('vm:entry-point')
Future<void> homeWidgetInteractivityCallback(Uri? uri) async {
  if (uri?.host != HomeWidgetService.addWaterHost) return;
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final cup = prefs.getInt(SettingsKeys.waterCupMl) ?? 250;
  final db = AppDatabase();
  try {
    await db.into(db.waterLogs).insert(WaterLogsCompanion.insert(
          timestamp: DateTime.now(),
          amountMl: cup,
          source: const Value('manual'),
        ));
    await HomeWidgetService.pushWater(db, prefs);
  } catch (e) {
    debugPrint('widget add water failed: $e');
  } finally {
    await db.close();
  }
}
