import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart' show TableUpdateQuery;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/calc/stats.dart';
import '../../core/providers.dart';
import '../../data/repositories/profile_repository.dart';
import 'tracking_logic.dart';
import 'tracking_repository.dart';

export 'tracking_logic.dart' show RecoveryBreakdown, SleepNight, Measure, PulledItem, HcType;
export 'tracking_repository.dart' show TrackingRepository, addWaterDb;

final trackingRepositoryProvider = Provider<TrackingRepository>((ref) => TrackingRepository(ref.watch(databaseProvider)));

/// Local midnight of the current day; rolls over at midnight so "today" streams re-subscribe.
class CurrentDayNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    final now = DateTime.now();
    final day = DateTime(now.year, now.month, now.day);
    final next = DateTime(now.year, now.month, now.day + 1);
    final t = Timer(next.difference(now) + const Duration(seconds: 1), ref.invalidateSelf);
    ref.onDispose(t.cancel);
    return day;
  }
}

final currentDayProvider = NotifierProvider<CurrentDayNotifier, DateTime>(CurrentDayNotifier.new);

// ───────────────────────── Water ─────────────────────────

/// ml drunk today.
final todayWaterProvider = StreamProvider<int>((ref) {
  final day = ref.watch(currentDayProvider);
  return ref.watch(trackingRepositoryProvider).watchWaterTotal(day);
});

/// Today's water entries (newest first).
final todayWaterEntriesProvider = StreamProvider<List<WaterLog>>((ref) {
  final day = ref.watch(currentDayProvider);
  return ref.watch(trackingRepositoryProvider).watchWater(day);
});

/// Daily totals of the last 7 days (oldest first, today last).
final waterWeekProvider = StreamProvider<List<int>>((ref) {
  final day = ref.watch(currentDayProvider);
  return ref.watch(trackingRepositoryProvider).watchWaterHistory(day, 7);
});

/// Default goal when the profile has none.
const defaultWaterGoalMl = 3000;

/// Daily water goal in ml.
final waterGoalProvider = Provider<int>((ref) {
  final goal = ref.watch(profileProvider).value?.waterGoalMl;
  return goal != null && goal > 0 ? goal : defaultWaterGoalMl;
});

/// Cup / bottle sizes (ml), stored in SharedPreferences.
class WaterContainersNotifier extends Notifier<({int cup, int bottle})> {
  static const defaultCup = 250;
  static const defaultBottle = 1000;

  @override
  ({int cup, int bottle}) build() {
    final p = ref.watch(sharedPrefsProvider);
    return (
      cup: p.getInt(SettingsKeys.waterCupMl) ?? defaultCup,
      bottle: p.getInt(SettingsKeys.waterBottleMl) ?? defaultBottle,
    );
  }

  Future<void> setCup(int ml) async {
    await ref.read(sharedPrefsProvider).setInt(SettingsKeys.waterCupMl, ml);
    state = (cup: ml, bottle: state.bottle);
  }

  Future<void> setBottle(int ml) async {
    await ref.read(sharedPrefsProvider).setInt(SettingsKeys.waterBottleMl, ml);
    state = (cup: state.cup, bottle: ml);
  }
}

final waterContainersProvider =
    NotifierProvider<WaterContainersNotifier, ({int cup, int bottle})>(WaterContainersNotifier.new);

/// Adds water (one-tap cup/bottle) for now.
Future<void> addWater(WidgetRef ref, int ml) => addWaterDb(ref.read(databaseProvider), ml);

/// Same as [addWater] for code holding a provider [Ref] (services, notifications).
Future<void> addWaterFromRef(Ref ref, int ml) => addWaterDb(ref.read(databaseProvider), ml);

/// Same as [addWater] for a background [ProviderContainer] (home-widget callback).
Future<void> addWaterWithContainer(ProviderContainer container, int ml) =>
    addWaterDb(container.read(databaseProvider), ml);

/// Removes today's most recent water entry; returns the removed ml (null if none).
Future<int?> undoLastWater(WidgetRef ref) => ref.read(trackingRepositoryProvider).undoLastWater();

// ───────────────────────── Supplements ─────────────────────────

/// All supplements (active first).
final supplementsProvider = StreamProvider<List<Supplement>>((ref) {
  return ref.watch(trackingRepositoryProvider).watchSupplements();
});

/// Active supplements with whether each was taken today.
final todaySupplementsProvider = StreamProvider<List<(Supplement, bool)>>((ref) {
  final day = ref.watch(currentDayProvider);
  return ref.watch(trackingRepositoryProvider).watchDaySupplements(day);
});

/// Toggles today's ✓ for a supplement. Returns the new state.
Future<bool> toggleSupplement(WidgetRef ref, int id) => ref.read(trackingRepositoryProvider).toggleSupplement(id);

// ───────────────────────── Sleep ─────────────────────────

/// Sleep logs of the last 90 days (newest first).
final sleepLogsProvider = StreamProvider<List<SleepLog>>((ref) {
  final day = ref.watch(currentDayProvider);
  return ref.watch(trackingRepositoryProvider).watchSleep(since: day.subtract(const Duration(days: 90)));
});

/// Last night's sleep (log dated today), preferring manual entries.
final lastNightSleepProvider = Provider<AsyncValue<SleepLog?>>((ref) {
  final day = ref.watch(currentDayProvider);
  return ref.watch(sleepLogsProvider).whenData((logs) {
    final t = logs.where((l) => l.date == day).toList()
      ..sort((a, b) => (b.source == 'manual' ? 1 : 0) - (a.source == 'manual' ? 1 : 0));
    return t.firstOrNull;
  });
});

// ───────────────────────── Body ─────────────────────────

/// All body_metrics rows (newest first).
final bodyMetricsProvider = StreamProvider<List<BodyMetric>>((ref) {
  return ref.watch(trackingRepositoryProvider).watchBodyMetrics();
});

/// Daily weights (oldest first).
final weightSeriesProvider = Provider<AsyncValue<List<DatedValue>>>((ref) {
  return ref.watch(bodyMetricsProvider).whenData(weightSeries);
});

/// Latest logged body weight (kg) and its 7-day moving average.
final latestWeightProvider = StreamProvider<({double? weight, double? avg7})>((ref) {
  return ref.watch(trackingRepositoryProvider).watchBodyMetrics().map((rows) {
    final s = weightSeries(rows);
    if (s.isEmpty) return (weight: null, avg7: null);
    final ma = Stats.movingAverage(s, days: 7);
    return (weight: s.last.value, avg7: ma.last.value);
  });
});

/// Rows that contain measurements (newest first).
final measurementRowsProvider = Provider<AsyncValue<List<BodyMetric>>>((ref) {
  return ref.watch(bodyMetricsProvider).whenData((rows) => rows.where(hasMeasurements).toList());
});

/// Quick log of today's weight (also updates profile.weightKg).
Future<void> logWeight(WidgetRef ref, double kg, {DateTime? date}) =>
    ref.read(trackingRepositoryProvider).saveWeight(date ?? DateTime.now(), kg);

// ───────────────────────── Progress photos ─────────────────────────

final progressPhotosProvider = StreamProvider<List<ProgressPhoto>>((ref) {
  return ref.watch(trackingRepositoryProvider).watchPhotos();
});

/// App documents directory (progress photos are stored relative to it).
final appDocsDirProvider = FutureProvider<Directory>((ref) => getApplicationDocumentsDirectory());

// ───────────────────────── Health daily + recovery ─────────────────────────

/// health_daily rows of the last 90 days (newest first).
final healthDailyProvider = StreamProvider<List<HealthDailyData>>((ref) {
  final day = ref.watch(currentDayProvider);
  return ref.watch(trackingRepositoryProvider).watchHealth(since: day.subtract(const Duration(days: 90)));
});

/// Today's recovery inputs, baseline and level. Recomputed (and stored in
/// health_daily.recoveryScore) whenever sleep logs, health data or the profile change.
final recoveryBreakdownProvider = StreamProvider<RecoveryBreakdown?>((ref) async* {
  final day = ref.watch(currentDayProvider);
  final db = ref.watch(databaseProvider);
  final repo = ref.watch(trackingRepositoryProvider);
  yield await repo.computeAndStoreRecovery(day);
  final updates = db.tableUpdates(TableUpdateQuery.onAllTables([db.sleepLogs, db.healthDaily, db.userProfiles]));
  await for (final _ in updates) {
    yield await repo.computeAndStoreRecovery(day);
  }
});

/// Today's recovery score 0-100 (null when no data).
final todayRecoveryProvider = StreamProvider<int?>((ref) {
  final controller = StreamController<int?>();
  int? last;
  var emitted = false;
  ref.listen<AsyncValue<RecoveryBreakdown?>>(recoveryBreakdownProvider, (_, next) {
    if (next.hasError) {
      controller.addError(next.error!, next.stackTrace);
    } else if (next.hasValue) {
      final s = next.value?.score;
      if (!emitted || s != last) {
        emitted = true;
        last = s;
        controller.add(s);
      }
    }
  }, fireImmediately: true);
  ref.onDispose(controller.close);
  return controller.stream;
});
