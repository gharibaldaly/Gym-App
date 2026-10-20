import 'dart:async';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderListenable;
import 'package:flutter_test/flutter_test.dart';
import 'package:ironmind/core/providers.dart';
import 'package:ironmind/data/repositories/profile_repository.dart';
import 'package:ironmind/features/tracking/health_service.dart';
import 'package:ironmind/features/tracking/tracking_logic.dart';
import 'package:ironmind/features/tracking/tracking_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

DateTime _today() {
  final n = DateTime.now();
  return DateTime(n.year, n.month, n.day);
}

/// Waits until [provider] has a value matching [test].
Future<T> waitFor<T>(ProviderContainer c, ProviderListenable<AsyncValue<T>> provider, bool Function(T v) test) {
  final completer = Completer<T>();
  final sub = c.listen<AsyncValue<T>>(provider, (_, next) {
    if (next.hasValue && test(next.value as T) && !completer.isCompleted) completer.complete(next.value as T);
  }, fireImmediately: true);
  return completer.future.timeout(const Duration(seconds: 5)).whenComplete(sub.close);
}

void main() {
  late AppDatabase db;
  late ProviderContainer c;
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    db = AppDatabase(NativeDatabase.memory());
    c = ProviderContainer(overrides: [
      databaseProvider.overrideWithValue(db),
      sharedPrefsProvider.overrideWithValue(prefs),
    ]);
  });

  tearDown(() async {
    c.dispose();
    await db.close();
  });

  group('water', () {
    test('add / total / undo and yesterday is ignored', () async {
      final repo = c.read(trackingRepositoryProvider);
      await repo.addWater(500, at: _today().subtract(const Duration(hours: 2)));
      expect(await waitFor<int>(c, todayWaterProvider, (v) => v == 0), 0);

      await addWaterDb(db, 250);
      await addWaterDb(db, 1000);
      await addWaterDb(db, 0); // ignored
      expect(await waitFor<int>(c, todayWaterProvider, (v) => v == 1250), 1250);

      expect(await repo.undoLastWater(), 1000);
      expect(await waitFor<int>(c, todayWaterProvider, (v) => v == 250), 250);
      final entries = await waitFor<List<WaterLog>>(c, todayWaterEntriesProvider, (v) => v.length == 1);
      expect(entries.single.amountMl, 250);

      final week = await waitFor<List<int>>(c, waterWeekProvider, (v) => v.last == 250);
      expect(week, hasLength(7));
      expect(week[5], 500);
    });

    test('goal from profile with default fallback; container sizes in prefs', () async {
      final sub = c.listen(waterGoalProvider, (_, _) {}, fireImmediately: true);
      expect(c.read(waterGoalProvider), defaultWaterGoalMl);
      await ProfileRepository(db).upsert(const UserProfilesCompanion(waterGoalMl: Value(3500)));
      await waitFor(c, profileProvider, (p) => p?.waterGoalMl == 3500);
      expect(c.read(waterGoalProvider), 3500);
      sub.close();

      expect(c.read(waterContainersProvider).cup, 250);
      await c.read(waterContainersProvider.notifier).setBottle(750);
      expect(c.read(waterContainersProvider).bottle, 750);
      expect(prefs.getInt(SettingsKeys.waterBottleMl), 750);
    });
  });

  group('supplements', () {
    test('toggle today ✓ on/off and inactive ones are hidden', () async {
      final repo = c.read(trackingRepositoryProvider);
      final creatine = await repo.saveSupplement(SupplementsCompanion.insert(name: 'Creatine', dose: const Value('5 g')));
      final whey = await repo.saveSupplement(
          SupplementsCompanion.insert(name: 'Whey', proteinG: const Value(24), calories: const Value(120)));
      final old = await repo.saveSupplement(SupplementsCompanion.insert(name: 'Old', active: const Value(false)));

      var list = await waitFor<List<(Supplement, bool)>>(c, todaySupplementsProvider, (v) => v.length == 2);
      expect(list.map((e) => e.$2), [false, false]);
      expect(list.any((e) => e.$1.id == old), isFalse);

      expect(await repo.toggleSupplement(whey), isTrue);
      list = await waitFor(c, todaySupplementsProvider, (v) => v.any((e) => e.$2));
      expect(list.firstWhere((e) => e.$1.id == whey).$2, isTrue);
      expect(list.firstWhere((e) => e.$1.id == creatine).$2, isFalse);

      // A log from yesterday does not count for today.
      await db.into(db.supplementLogs).insert(SupplementLogsCompanion.insert(
          date: _today().subtract(const Duration(days: 1)), supplementId: creatine));
      list = await waitFor(c, todaySupplementsProvider, (v) => v.length == 2);
      expect(list.firstWhere((e) => e.$1.id == creatine).$2, isFalse);

      expect(await repo.toggleSupplement(whey), isFalse);
      list = await waitFor(c, todaySupplementsProvider, (v) => v.every((e) => !e.$2));
      expect(await db.select(db.supplementLogs).get(), hasLength(1)); // only yesterday's
    });

    test('import from onboarding answers skips duplicates', () async {
      await ProfileRepository(db).upsert(const UserProfilesCompanion(
          supplementsJson: Value('[{"name":"Whey","dose":"1 scoop"},{"name":"creatine"},{"name":""}]')));
      final repo = c.read(trackingRepositoryProvider);
      await repo.saveSupplement(SupplementsCompanion.insert(name: 'Creatine'));
      expect(await repo.importSupplementsFromProfile(), 1);
      final all = await db.select(db.supplements).get();
      expect(all.map((s) => s.name), containsAll(['Creatine', 'Whey']));
      expect(all.firstWhere((s) => s.name == 'Whey').dose, '1 scoop');
    });
  });

  group('body', () {
    test('weight upsert per day, 7-day average and profile.weightKg sync', () async {
      await ProfileRepository(db).upsert(const UserProfilesCompanion(weightKg: Value(85)));
      final repo = c.read(trackingRepositoryProvider);
      final t = _today();
      await repo.saveWeight(t.subtract(const Duration(days: 2)), 81);
      await repo.saveWeight(t.subtract(const Duration(days: 1)), 80);
      await repo.saveWeight(t, 79.5);
      await repo.saveWeight(t, 79); // replaces today's

      final w = await waitFor(c, latestWeightProvider, (v) => v.weight == 79);
      expect(w.avg7, closeTo(80, 0.001));
      expect((await ProfileRepository(db).get())!.weightKg, 79);

      // Logging an older date does not override the latest weight in the profile.
      await repo.saveWeight(t.subtract(const Duration(days: 5)), 90);
      expect((await ProfileRepository(db).get())!.weightKg, 79);

      await repo.saveMeasurements(t, waist: 84, bodyFat: 18);
      final rows = await db.select(db.bodyMetrics).get();
      expect(rows.where((r) => r.date == t), hasLength(1));
      final p = (await ProfileRepository(db).get())!;
      expect(p.bodyFatPct, 18);
      expect(p.measurements['waist'], 84);

      final todayRow = rows.firstWhere((r) => r.date == t);
      await repo.deleteWeight(todayRow.id);
      expect((await db.select(db.bodyMetrics).get()).where((r) => r.date == t), hasLength(1));
      await repo.deleteMeasurements(todayRow.id);
      expect((await db.select(db.bodyMetrics).get()).where((r) => r.date == t), isEmpty);
      expect((await ProfileRepository(db).get())!.weightKg, 80);
    });
  });

  group('Health Connect rows', () {
    test('points → sleep_logs + health_daily, manual sleep is never overwritten', () async {
      final t = _today();
      final y = t.subtract(const Duration(days: 1));
      // Manual entry for today must survive.
      await c.read(trackingRepositoryProvider).saveManualSleep(date: t, durationMin: 400, quality: 4);

      final points = [
        HcPoint(type: HcType.sleepSession, value: 0, from: y.subtract(const Duration(hours: 1)), to: y.add(const Duration(hours: 7)), source: 'com.cardoo'),
        HcPoint(type: HcType.sleepDeep, value: 0, from: y.subtract(const Duration(hours: 1)), to: y.add(const Duration(hours: 1)), source: 'com.cardoo'),
        HcPoint(type: HcType.sleepLight, value: 0, from: y.add(const Duration(hours: 1)), to: y.add(const Duration(hours: 7)), source: 'com.cardoo'),
        HcPoint(type: HcType.sleepSession, value: 0, from: t.subtract(const Duration(hours: 1)), to: t.add(const Duration(hours: 6)), source: 'com.cardoo'),
        HcPoint(type: HcType.hrv, value: 52, from: y.add(const Duration(hours: 4)), to: y.add(const Duration(hours: 4)), source: 'com.cardoo'),
        HcPoint(type: HcType.steps, value: 4000, from: y.add(const Duration(hours: 10)), to: y.add(const Duration(hours: 11)), source: 'com.google.android.apps.fitness'),
        // Before firstDay → skipped.
        HcPoint(type: HcType.steps, value: 999, from: t.subtract(const Duration(days: 10)), to: t.subtract(const Duration(days: 10)), source: 'x'),
      ];
      final r = await writeHealthPoints(db, points, firstDay: t.subtract(const Duration(days: 3)));
      expect(r.outcome, HealthSyncOutcome.ok);
      expect(r.nights, 1);

      final sleep = await db.select(db.sleepLogs).get();
      final todaySleep = sleep.where((s) => s.date == t).toList();
      expect(todaySleep.single.source, 'manual');
      expect(todaySleep.single.durationMin, 400);
      final ySleep = sleep.singleWhere((s) => s.date == y);
      expect(ySleep.source, 'health_connect');
      expect(ySleep.deepMin, 120);
      expect(ySleep.lightMin, 360);
      expect(ySleep.durationMin, 480);

      final daily = await db.select(db.healthDaily).get();
      final yRow = daily.singleWhere((d) => d.date == y);
      expect(yRow.hrv, 52);
      expect(yRow.steps, 4000);
      expect(TrackingRepository.sourcesOf(yRow), ['com.cardoo', 'com.google.android.apps.fitness']);
      expect(daily.where((d) => d.steps == 999), isEmpty);

      // Re-sync is an upsert (no duplicates) and keeps fields that did not arrive this time.
      await writeHealthPoints(db, [points[3], points[0], points[1], points[2]], firstDay: t.subtract(const Duration(days: 3)));
      expect((await db.select(db.sleepLogs).get()).where((s) => s.date == y), hasLength(1));
      expect((await db.select(db.healthDaily).get()).singleWhere((d) => d.date == y).steps, 4000);
    });
  });

  group('recovery', () {
    test('integration: score from DB rows, stored and streamed; recomputes on change', () async {
      final t = _today();
      for (var i = 1; i <= 20; i++) {
        await db.into(db.healthDaily).insert(HealthDailyCompanion.insert(
              date: t.subtract(Duration(days: i)),
              hrv: const Value(60),
              restingHr: const Value(55),
            ));
      }
      await ProfileRepository(db).upsert(const UserProfilesCompanion(sleepTime: Value('23:00'), wakeTime: Value('07:00')));

      expect(await waitFor<int?>(c, todayRecoveryProvider, (v) => v == null), isNull);

      await db.into(db.healthDaily).insert(HealthDailyCompanion.insert(
            date: t,
            hrv: const Value(60),
            restingHr: const Value(55),
          ));
      await c.read(trackingRepositoryProvider).saveManualSleep(date: t, durationMin: 480);
      // sleep 100×0.4 + hrv 50×0.35 + rhr 50×0.25 = 70
      expect(await waitFor<int?>(c, todayRecoveryProvider, (v) => v == 70), 70);
      final b = await waitFor<RecoveryBreakdown?>(c, recoveryBreakdownProvider, (v) => v?.score == 70);
      expect(b!.baselineDays, 20);
      expect(b.sleepNeedMin, 480);

      final stored = await (db.select(db.healthDaily)..where((h) => h.date.equals(t))).getSingle();
      expect(stored.recoveryScore, 70);

      // Worse night → lower score, automatically.
      await c.read(trackingRepositoryProvider).saveManualSleep(date: t, durationMin: 240, quality: 1);
      final low = await waitFor<int?>(c, todayRecoveryProvider, (v) => v != null && v < 70);
      expect(low, lessThan(70));
    });

    test('sync with Health Connect disabled still computes recovery from manual sleep', () async {
      final t = _today();
      await ProfileRepository(db).upsert(const UserProfilesCompanion(healthConnectEnabled: Value(false)));
      await c.read(trackingRepositoryProvider).saveManualSleep(date: t, durationMin: 480, quality: 5);
      final r = await c.read(healthServiceProvider).sync();
      expect(r.outcome, HealthSyncOutcome.disabled);
      final row = await (db.select(db.healthDaily)..where((h) => h.date.equals(t))).getSingle();
      expect(row.recoveryScore, 100);
    });

    test('sync on an unsupported platform never throws', () async {
      await ProfileRepository(db).upsert(const UserProfilesCompanion(healthConnectEnabled: Value(true)));
      final r = await c.read(healthServiceProvider).sync();
      expect(r.outcome, HealthSyncOutcome.unavailable);
      final snap = await c.read(healthServiceProvider).lastPulled();
      expect(snap.lastOutcome, HealthSyncOutcome.unavailable);
      await backgroundHealthSync(c);
    });
  });
}
