import 'dart:convert';

import 'package:drift/drift.dart';

import '../../data/db/database.dart';
import '../../data/repositories/profile_repository.dart';
import 'tracking_logic.dart';

DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);
DateTime _next(DateTime d) => DateTime(d.year, d.month, d.day + 1);

/// All tracking DB access. Needs only an [AppDatabase], so it also works from background
/// isolates (home-widget callback, workmanager).
class TrackingRepository {
  final AppDatabase db;
  TrackingRepository(this.db);

  // ───────────── Water ─────────────

  Future<int> addWater(int ml, {DateTime? at, String source = 'manual'}) {
    return db.into(db.waterLogs).insert(WaterLogsCompanion.insert(
          timestamp: at ?? DateTime.now(),
          amountMl: ml,
          source: Value(source),
        ));
  }

  /// Deletes the most recent water entry of [day] (default today). Returns the removed amount.
  Future<int?> undoLastWater({DateTime? day}) async {
    final d = _day(day ?? DateTime.now());
    final last = await (db.select(db.waterLogs)
          ..where((t) => t.timestamp.isBiggerOrEqualValue(d) & t.timestamp.isSmallerThanValue(_next(d)))
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp), (t) => OrderingTerm.desc(t.id)])
          ..limit(1))
        .getSingleOrNull();
    if (last == null) return null;
    await (db.delete(db.waterLogs)..where((t) => t.id.equals(last.id))).go();
    return last.amountMl;
  }

  Future<void> deleteWater(int id) => (db.delete(db.waterLogs)..where((t) => t.id.equals(id))).go();

  Stream<List<WaterLog>> watchWater(DateTime day) {
    final d = _day(day);
    return (db.select(db.waterLogs)
          ..where((t) => t.timestamp.isBiggerOrEqualValue(d) & t.timestamp.isSmallerThanValue(_next(d)))
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp), (t) => OrderingTerm.desc(t.id)]))
        .watch();
  }

  Expression<int> get _waterSum => db.waterLogs.amountMl.sum();

  Stream<int> watchWaterTotal(DateTime day) {
    final d = _day(day);
    final q = db.selectOnly(db.waterLogs)
      ..addColumns([_waterSum])
      ..where(db.waterLogs.timestamp.isBiggerOrEqualValue(d) & db.waterLogs.timestamp.isSmallerThanValue(_next(d)));
    return q.watchSingle().map((r) => r.read(_waterSum) ?? 0);
  }

  Future<int> waterTotal(DateTime day) async {
    final d = _day(day);
    final q = db.selectOnly(db.waterLogs)
      ..addColumns([_waterSum])
      ..where(db.waterLogs.timestamp.isBiggerOrEqualValue(d) & db.waterLogs.timestamp.isSmallerThanValue(_next(d)));
    return (await q.getSingle()).read(_waterSum) ?? 0;
  }

  /// Daily totals for the [days] days ending at [end] (oldest first).
  Stream<List<int>> watchWaterHistory(DateTime end, int days) {
    final last = _day(end);
    final from = DateTime(last.year, last.month, last.day - days + 1);
    return (db.select(db.waterLogs)
          ..where((t) => t.timestamp.isBiggerOrEqualValue(from) & t.timestamp.isSmallerThanValue(_next(last))))
        .watch()
        .map((rows) {
      final out = List<int>.filled(days, 0);
      for (final r in rows) {
        final i = _day(r.timestamp).difference(from).inHours ~/ 24;
        if (i >= 0 && i < days) out[i] += r.amountMl;
      }
      return out;
    });
  }

  // ───────────── Supplements ─────────────

  Stream<List<Supplement>> watchSupplements() =>
      (db.select(db.supplements)..orderBy([(t) => OrderingTerm.desc(t.active), (t) => OrderingTerm.asc(t.id)])).watch();

  /// Active supplements with whether each was taken on [day].
  Stream<List<(Supplement, bool)>> watchDaySupplements(DateTime day) {
    final d = _day(day);
    final q = db.select(db.supplements).join([
      leftOuterJoin(
        db.supplementLogs,
        db.supplementLogs.supplementId.equalsExp(db.supplements.id) &
            db.supplementLogs.date.isBiggerOrEqualValue(d) &
            db.supplementLogs.date.isSmallerThanValue(_next(d)) &
            db.supplementLogs.taken.equals(true),
      ),
    ])
      ..where(db.supplements.active.equals(true))
      ..orderBy([OrderingTerm.asc(db.supplements.id)]);
    return q.watch().map((rows) {
      final out = <int, (Supplement, bool)>{};
      for (final r in rows) {
        final s = r.readTable(db.supplements);
        final taken = r.readTableOrNull(db.supplementLogs) != null;
        final prev = out[s.id];
        out[s.id] = (s, taken || (prev?.$2 ?? false));
      }
      return out.values.toList();
    });
  }

  /// Toggles the taken ✓ for [supplementId] on [day]. Returns the new state.
  Future<bool> toggleSupplement(int supplementId, {DateTime? day}) {
    final d = _day(day ?? DateTime.now());
    return db.transaction(() async {
      final existing = await (db.select(db.supplementLogs)
            ..where((t) =>
                t.supplementId.equals(supplementId) &
                t.date.isBiggerOrEqualValue(d) &
                t.date.isSmallerThanValue(_next(d))))
          .get();
      if (existing.any((e) => e.taken)) {
        await (db.delete(db.supplementLogs)..where((t) => t.id.isIn(existing.map((e) => e.id)))).go();
        return false;
      }
      await db.into(db.supplementLogs).insert(SupplementLogsCompanion.insert(date: d, supplementId: supplementId));
      return true;
    });
  }

  Future<int> saveSupplement(SupplementsCompanion data) async {
    if (data.id.present) {
      await (db.update(db.supplements)..where((t) => t.id.equals(data.id.value))).write(data);
      return data.id.value;
    }
    return db.into(db.supplements).insert(data);
  }

  Future<void> setSupplementActive(int id, bool active) =>
      (db.update(db.supplements)..where((t) => t.id.equals(id))).write(SupplementsCompanion(active: Value(active)));

  Future<void> deleteSupplement(int id) async {
    await (db.delete(db.supplementLogs)..where((t) => t.supplementId.equals(id))).go();
    await (db.delete(db.supplements)..where((t) => t.id.equals(id))).go();
  }

  /// Creates supplement rows from the onboarding answers ([{name, dose}]); skips existing names.
  Future<int> importSupplementsFromProfile() async {
    final p = await ProfileRepository(db).get();
    if (p == null) return 0;
    final existing = (await db.select(db.supplements).get()).map((s) => s.name.trim().toLowerCase()).toSet();
    var n = 0;
    for (final m in p.supplementsList) {
      final name = '${m['name'] ?? ''}'.trim();
      if (name.isEmpty || existing.contains(name.toLowerCase())) continue;
      final dose = m['dose'] == null ? null : '${m['dose']}'.trim();
      await db.into(db.supplements).insert(SupplementsCompanion.insert(
            name: name,
            dose: Value(dose == null || dose.isEmpty ? null : dose),
          ));
      existing.add(name.toLowerCase());
      n++;
    }
    return n;
  }

  // ───────────── Sleep ─────────────

  Stream<List<SleepLog>> watchSleep({DateTime? since}) {
    final q = db.select(db.sleepLogs)..orderBy([(t) => OrderingTerm.desc(t.date), (t) => OrderingTerm.desc(t.id)]);
    if (since != null) q.where((t) => t.date.isBiggerOrEqualValue(_day(since)));
    return q.watch();
  }

  Future<List<SleepLog>> sleepFor(DateTime day) {
    final d = _day(day);
    return (db.select(db.sleepLogs)..where((t) => t.date.isBiggerOrEqualValue(d) & t.date.isSmallerThanValue(_next(d))))
        .get();
  }

  /// Saves a manual entry for the wake-up [date]; replaces any other entry of that date.
  Future<void> saveManualSleep({
    required DateTime date,
    required int durationMin,
    int? quality,
    DateTime? start,
    DateTime? end,
    int? replaceId,
  }) async {
    final d = _day(date);
    await db.transaction(() async {
      await (db.delete(db.sleepLogs)
            ..where((t) =>
                (t.date.isBiggerOrEqualValue(d) & t.date.isSmallerThanValue(_next(d))) |
                (replaceId == null ? const Constant(false) : t.id.equals(replaceId))))
          .go();
      await db.into(db.sleepLogs).insert(SleepLogsCompanion.insert(
            date: d,
            durationMin: durationMin,
            quality: Value(quality),
            start: Value(start),
            end: Value(end),
            source: const Value('manual'),
          ));
    });
  }

  /// Upserts a Health Connect night. Never overwrites a manual entry of that date.
  /// Returns true when written.
  Future<bool> upsertHcSleep(SleepNight n) {
    final d = _day(n.date);
    return db.transaction(() async {
      final existing = await sleepFor(d);
      if (existing.any((e) => e.source == 'manual')) return false;
      final row = SleepLogsCompanion(
        date: Value(d),
        start: Value(n.start),
        end: Value(n.end),
        durationMin: Value(n.durationMin),
        deepMin: Value(n.deepMin),
        remMin: Value(n.remMin),
        lightMin: Value(n.lightMin),
        awakeMin: Value(n.awakeMin),
        source: const Value('health_connect'),
      );
      if (existing.isEmpty) {
        await db.into(db.sleepLogs).insert(row);
      } else {
        await (db.update(db.sleepLogs)..where((t) => t.id.equals(existing.first.id))).write(row);
        if (existing.length > 1) {
          await (db.delete(db.sleepLogs)..where((t) => t.id.isIn(existing.skip(1).map((e) => e.id)))).go();
        }
      }
      return true;
    });
  }

  Future<void> deleteSleep(int id) => (db.delete(db.sleepLogs)..where((t) => t.id.equals(id))).go();

  // ───────────── Body metrics ─────────────

  Stream<List<BodyMetric>> watchBodyMetrics() =>
      (db.select(db.bodyMetrics)..orderBy([(t) => OrderingTerm.desc(t.date), (t) => OrderingTerm.desc(t.id)])).watch();

  Future<BodyMetric?> _metricFor(DateTime d) => (db.select(db.bodyMetrics)
        ..where((t) => t.date.isBiggerOrEqualValue(d) & t.date.isSmallerThanValue(_next(d)))
        ..orderBy([(t) => OrderingTerm.desc(t.id)])
        ..limit(1))
      .getSingleOrNull();

  Future<void> _upsertMetric(DateTime date, BodyMetricsCompanion data) async {
    final d = _day(date);
    final existing = await _metricFor(d);
    if (existing == null) {
      await db.into(db.bodyMetrics).insert(data.copyWith(date: Value(d)));
    } else {
      await (db.update(db.bodyMetrics)..where((t) => t.id.equals(existing.id))).write(data);
    }
  }

  /// Daily weight (one value per day; a second entry the same day replaces it).
  Future<void> saveWeight(DateTime date, double kg) async {
    await _upsertMetric(date, BodyMetricsCompanion(weightKg: Value(kg)));
    await syncProfileFromMetrics();
  }

  Future<void> saveMeasurements(
    DateTime date, {
    double? waist,
    double? chest,
    double? arm,
    double? thigh,
    double? neck,
    double? hips,
    double? bodyFat,
  }) async {
    await _upsertMetric(
      date,
      BodyMetricsCompanion(
        waistCm: Value(waist),
        chestCm: Value(chest),
        armCm: Value(arm),
        thighCm: Value(thigh),
        neckCm: Value(neck),
        hipsCm: Value(hips),
        bodyFatPct: Value(bodyFat),
      ),
    );
    await syncProfileFromMetrics();
  }

  /// Removes the weight of a row (deletes the row when nothing else is left).
  Future<void> deleteWeight(int id) => _clearFields(id, const BodyMetricsCompanion(weightKg: Value(null)));

  /// Removes the measurements of a row (deletes the row when nothing else is left).
  Future<void> deleteMeasurements(int id) => _clearFields(
        id,
        const BodyMetricsCompanion(
          waistCm: Value(null),
          chestCm: Value(null),
          armCm: Value(null),
          thighCm: Value(null),
          neckCm: Value(null),
          hipsCm: Value(null),
          bodyFatPct: Value(null),
        ),
      );

  Future<void> _clearFields(int id, BodyMetricsCompanion clear) async {
    await (db.update(db.bodyMetrics)..where((t) => t.id.equals(id))).write(clear);
    final row = await (db.select(db.bodyMetrics)..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row != null && row.weightKg == null && !hasMeasurements(row)) {
      await (db.delete(db.bodyMetrics)..where((t) => t.id.equals(id))).go();
    }
    await syncProfileFromMetrics();
  }

  /// Copies the latest weight / measurements / body fat into the profile (if a profile exists).
  Future<void> syncProfileFromMetrics() async {
    final repo = ProfileRepository(db);
    final p = await repo.get();
    if (p == null) return;
    final rows = await (db.select(db.bodyMetrics)..orderBy([(t) => OrderingTerm.desc(t.date), (t) => OrderingTerm.desc(t.id)]))
        .get();
    final latestWeight = rows.where((r) => r.weightKg != null).firstOrNull?.weightKg;
    final latestMeasures = rows.where(hasMeasurements).firstOrNull;
    var update = const UserProfilesCompanion();
    if (latestWeight != null && latestWeight != p.weightKg) update = update.copyWith(weightKg: Value(latestWeight));
    if (latestMeasures != null) {
      final m = Map<String, dynamic>.of(p.measurements);
      void put(String k, double? v) {
        if (v != null) m[k] = v;
      }

      put('waist', latestMeasures.waistCm);
      put('chest', latestMeasures.chestCm);
      put('arm', latestMeasures.armCm);
      put('thigh', latestMeasures.thighCm);
      put('neck', latestMeasures.neckCm);
      put('hips', latestMeasures.hipsCm);
      final json = jsonEncode(m);
      if (json != p.measurementsJson) update = update.copyWith(measurementsJson: Value(json));
      final bf = latestMeasures.bodyFatPct;
      if (bf != null && bf != p.bodyFatPct) {
        update = update.copyWith(bodyFatPct: Value(bf), bodyFatMethod: const Value('number'));
      }
    }
    if (update.weightKg.present || update.measurementsJson.present || update.bodyFatPct.present) {
      await repo.upsert(update);
    }
  }

  // ───────────── Progress photos ─────────────

  Stream<List<ProgressPhoto>> watchPhotos() =>
      (db.select(db.progressPhotos)..orderBy([(t) => OrderingTerm.desc(t.date), (t) => OrderingTerm.asc(t.angle)]))
          .watch();

  /// Inserts a photo; returns the relative paths of photos it replaced (same day + angle).
  Future<List<String>> savePhoto(DateTime date, String angle, String relPath) {
    final d = _day(date);
    return db.transaction(() async {
      final old = await (db.select(db.progressPhotos)
            ..where((t) => t.angle.equals(angle) & t.date.isBiggerOrEqualValue(d) & t.date.isSmallerThanValue(_next(d))))
          .get();
      if (old.isNotEmpty) {
        await (db.delete(db.progressPhotos)..where((t) => t.id.isIn(old.map((e) => e.id)))).go();
      }
      await db.into(db.progressPhotos).insert(ProgressPhotosCompanion.insert(date: d, angle: angle, path: relPath));
      return old.map((e) => e.path).toList();
    });
  }

  Future<void> deletePhoto(int id) => (db.delete(db.progressPhotos)..where((t) => t.id.equals(id))).go();

  // ───────────── Health daily + recovery ─────────────

  Future<HealthDailyData?> healthFor(DateTime day) =>
      (db.select(db.healthDaily)..where((t) => t.date.equals(_day(day)))).getSingleOrNull();

  Stream<List<HealthDailyData>> watchHealth({DateTime? since}) {
    final q = db.select(db.healthDaily)..orderBy([(t) => OrderingTerm.desc(t.date)]);
    if (since != null) q.where((t) => t.date.isBiggerOrEqualValue(_day(since)));
    return q.watch();
  }

  /// Upserts vitals by date; null values keep what is stored. Sources are merged.
  Future<void> upsertDaily(DailyHealth h, {DateTime? syncedAt}) => db.transaction(() => _upsertDaily(h, syncedAt));

  Future<void> _upsertDaily(DailyHealth h, DateTime? syncedAt) async {
    final d = _day(h.date);
    final existing = await healthFor(d);
    final sources = <String>{
      if (existing != null) ..._decodeSources(existing.sourcesJson),
      ...h.sources,
    }.toList()
      ..sort();
    final row = HealthDailyCompanion(
      date: Value(d),
      steps: h.steps != null ? Value(h.steps) : const Value.absent(),
      avgHr: h.avgHr != null ? Value(h.avgHr) : const Value.absent(),
      restingHr: h.restingHr != null ? Value(h.restingHr) : const Value.absent(),
      hrv: h.hrv != null ? Value(h.hrv) : const Value.absent(),
      activeCalories: h.activeCalories != null ? Value(h.activeCalories) : const Value.absent(),
      sourcesJson: Value(jsonEncode(sources)),
      lastSyncedAt: Value(syncedAt ?? DateTime.now()),
    );
    if (existing == null) {
      await db.into(db.healthDaily).insert(row);
    } else {
      await (db.update(db.healthDaily)..where((t) => t.id.equals(existing.id))).write(row);
    }
  }

  static List<String> _decodeSources(String json) {
    try {
      return (jsonDecode(json) as List).map((e) => '$e').toList();
    } catch (_) {
      return const [];
    }
  }

  static List<String> sourcesOf(HealthDailyData h) => _decodeSources(h.sourcesJson);

  /// Computes the recovery score for [day] from sleep + HRV + resting HR vs the 30-day
  /// baseline and stores it in health_daily.recoveryScore (only writes when it changed).
  Future<RecoveryBreakdown> computeAndStoreRecovery([DateTime? day]) =>
      db.transaction(() => _computeAndStoreRecovery(_day(day ?? DateTime.now())));

  Future<RecoveryBreakdown> _computeAndStoreRecovery(DateTime d) async {
    final profile = await ProfileRepository(db).get();
    final sleep = await sleepFor(d);
    final from = d.subtract(const Duration(days: RecoveryBaseline.windowDays));
    final rows = await (db.select(db.healthDaily)
          ..where((t) => t.date.isBiggerOrEqualValue(from) & t.date.isSmallerThanValue(_next(d))))
        .get();
    final todayRow = rows.where((r) => r.date == d).firstOrNull;
    final b = computeRecovery(
      day: d,
      sleep: sleep,
      todayHealth: todayRow,
      history: rows,
      sleepNeedMin: sleepNeedFromProfile(profile?.sleepTime, profile?.wakeTime),
    );
    if (todayRow == null) {
      if (b.score != null) {
        await db.into(db.healthDaily).insert(HealthDailyCompanion.insert(date: d, recoveryScore: Value(b.score)));
      }
    } else if (todayRow.recoveryScore != b.score) {
      await (db.update(db.healthDaily)..where((t) => t.id.equals(todayRow.id)))
          .write(HealthDailyCompanion(recoveryScore: Value(b.score)));
    }
    return b;
  }
}

/// Plain function for the home-widget background callback: logs [ml] of water now.
Future<void> addWaterDb(AppDatabase db, int ml) async {
  if (ml <= 0) return;
  await TrackingRepository(db).addWater(ml);
}
