import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health/health.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/providers.dart';
import '../../data/repositories/profile_repository.dart';
import 'tracking_logic.dart';
import 'tracking_repository.dart';

/// Health Connect availability on this phone.
enum HcAvailability { available, needsUpdate, notInstalled, unsupported }

enum HealthSyncOutcome { ok, disabled, unavailable, noPermission, busy, error }

class HealthSyncResult {
  final HealthSyncOutcome outcome;
  final int points;
  final int nights;
  final int days;
  final String? error;
  const HealthSyncResult(this.outcome, {this.points = 0, this.nights = 0, this.days = 0, this.error});
}

class HealthStatus {
  final HcAvailability availability;

  /// null = unknown (e.g. not available).
  final bool? permissionsGranted;
  final bool backgroundAvailable;
  final bool backgroundAuthorized;
  const HealthStatus({
    required this.availability,
    this.permissionsGranted,
    this.backgroundAvailable = false,
    this.backgroundAuthorized = false,
  });
}

/// What the last syncs pulled from Health Connect (for the "verify your ring" table).
class HealthSnapshot {
  final DateTime? lastSync;
  final HealthSyncOutcome? lastOutcome;
  final String? lastError;
  final int lastPointCount;

  /// Latest point per type (kept across syncs, so a type that stopped arriving shows its last date).
  final Map<String, PulledItem> items;
  const HealthSnapshot({
    this.lastSync,
    this.lastOutcome,
    this.lastError,
    this.lastPointCount = 0,
    this.items = const {},
  });

  bool get hasAnyData => items.isNotEmpty;

  /// Distinct apps that wrote any of the pulled data.
  Set<String> get sources => items.values.map((e) => e.source).where((s) => s.isNotEmpty).toSet();

  Map<String, dynamic> toJson() => {
        'lastOutcome': lastOutcome?.name,
        'lastError': lastError,
        'lastPointCount': lastPointCount,
        'items': items.values.map((e) => e.toJson()).toList(),
      };

  static HealthSnapshot fromPrefs(SharedPreferences prefs) {
    final last = DateTime.tryParse(prefs.getString(SettingsKeys.lastHealthSync) ?? '');
    final raw = prefs.getString(HealthService.snapshotKey);
    if (raw == null) return HealthSnapshot(lastSync: last);
    try {
      final j = jsonDecode(raw) as Map<String, dynamic>;
      final items = <String, PulledItem>{};
      for (final e in (j['items'] as List? ?? const [])) {
        final it = PulledItem.fromJson(e);
        if (it != null) items[it.type] = it;
      }
      return HealthSnapshot(
        lastSync: last,
        lastOutcome: HealthSyncOutcome.values.where((o) => o.name == j['lastOutcome']).firstOrNull,
        lastError: j['lastError'] as String?,
        lastPointCount: (j['lastPointCount'] as num?)?.toInt() ?? 0,
        items: items,
      );
    } catch (_) {
      return HealthSnapshot(lastSync: last);
    }
  }
}

/// Health Connect (smart ring) sync: sleep + stages, HR, resting HR, HRV, steps, active calories.
///
/// Works without a BuildContext (only DB + SharedPreferences), so it can run in the
/// workmanager background isolate via [backgroundHealthSync] / [healthSyncHeadless].
class HealthService {
  final AppDatabase Function() _db;
  final SharedPreferences Function() _prefs;
  final Health _health;
  bool _configured = false;
  Future<HealthSyncResult>? _running;

  HealthService(Ref ref, {Health? health})
      : _db = (() => ref.read(databaseProvider)),
        _prefs = (() => ref.read(sharedPrefsProvider)),
        _health = health ?? Health();

  HealthService.headless(AppDatabase db, SharedPreferences prefs, {Health? health})
      : _db = (() => db),
        _prefs = (() => prefs),
        _health = health ?? Health();

  static const snapshotKey = 'hc_last_pulled';
  static const requestedKey = 'hc_permissions_requested';

  /// How many past days each sync reads (plus today).
  static const syncDays = 3;

  static const _allTypes = [
    HealthDataType.SLEEP_SESSION,
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.SLEEP_DEEP,
    HealthDataType.SLEEP_REM,
    HealthDataType.SLEEP_LIGHT,
    HealthDataType.SLEEP_AWAKE,
    HealthDataType.HEART_RATE,
    HealthDataType.RESTING_HEART_RATE,
    HealthDataType.HEART_RATE_VARIABILITY_RMSSD,
    HealthDataType.STEPS,
    HealthDataType.ACTIVE_ENERGY_BURNED,
  ];

  static bool get _platformSupported => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  /// Types supported on this platform (e.g. RMSSD is Android only).
  List<HealthDataType> get types {
    if (!_platformSupported) return const [];
    return _allTypes.where(_health.isDataTypeAvailable).toList();
  }

  Future<void> _configure() async {
    if (_configured) return;
    await _health.configure();
    _configured = true;
  }

  Future<HcAvailability> availability() async {
    if (!_platformSupported) return HcAvailability.unsupported;
    if (Platform.isIOS) return HcAvailability.available;
    try {
      await _configure();
      final s = await _health.getHealthConnectSdkStatus();
      return switch (s) {
        HealthConnectSdkStatus.sdkAvailable => HcAvailability.available,
        HealthConnectSdkStatus.sdkUnavailableProviderUpdateRequired => HcAvailability.needsUpdate,
        HealthConnectSdkStatus.sdkUnavailable => HcAvailability.notInstalled,
        null => HcAvailability.unsupported,
      };
    } catch (e) {
      debugPrint('HealthService.availability: $e');
      return HcAvailability.unsupported;
    }
  }

  /// Opens the Play Store page of Health Connect.
  Future<void> installHealthConnect() async {
    if (!_platformSupported) return;
    try {
      await _health.installHealthConnect();
    } catch (e) {
      debugPrint('HealthService.installHealthConnect: $e');
    }
  }

  Future<HealthStatus> status() async {
    final a = await availability();
    if (a != HcAvailability.available) return HealthStatus(availability: a);
    bool? granted;
    var bgAvail = false, bgAuth = false;
    try {
      granted = await _health.hasPermissions(types);
    } catch (e) {
      debugPrint('HealthService.hasPermissions: $e');
    }
    try {
      bgAvail = await _health.isHealthDataInBackgroundAvailable();
      if (bgAvail) bgAuth = await _health.isHealthDataInBackgroundAuthorized();
    } catch (e) {
      debugPrint('HealthService.background status: $e');
    }
    return HealthStatus(
      availability: a,
      permissionsGranted: granted,
      backgroundAvailable: bgAvail,
      backgroundAuthorized: bgAuth,
    );
  }

  /// Shows the Health Connect permission sheet (foreground only). Never throws.
  Future<bool> requestPermissions() async {
    if (await availability() != HcAvailability.available) return false;
    try {
      await _prefs().setBool(requestedKey, true);
      final ok = await _health.requestAuthorization(types);
      // Reading in the background (workmanager) needs an extra permission on newer Android.
      try {
        if (ok &&
            await _health.isHealthDataInBackgroundAvailable() &&
            !await _health.isHealthDataInBackgroundAuthorized()) {
          await _health.requestHealthDataInBackgroundAuthorization();
        }
      } catch (e) {
        debugPrint('HealthService background permission: $e');
      }
      return ok;
    } catch (e) {
      debugPrint('HealthService.requestPermissions: $e');
      return false;
    }
  }

  /// Requests only the background-read permission.
  Future<bool> requestBackgroundPermission() async {
    try {
      return await _health.requestHealthDataInBackgroundAuthorization();
    } catch (e) {
      debugPrint('HealthService.requestBackgroundPermission: $e');
      return false;
    }
  }

  /// What the previous syncs pulled + last sync time.
  Future<HealthSnapshot> lastPulled() async {
    try {
      return HealthSnapshot.fromPrefs(_prefs());
    } catch (_) {
      return const HealthSnapshot();
    }
  }

  /// Called on app open and from the background task. Never throws.
  /// Also recomputes today's recovery score (from manual sleep when Health Connect is off).
  Future<HealthSyncResult> sync({bool background = false}) {
    final running = _running;
    if (running != null) return running;
    final f = _guardedSync(background).whenComplete(() => _running = null);
    _running = f;
    return f;
  }

  Future<HealthSyncResult> _guardedSync(bool background) async {
    HealthSyncResult result;
    try {
      result = await _sync(background);
    } catch (e, st) {
      debugPrint('HealthService.sync failed: $e\n$st');
      result = HealthSyncResult(HealthSyncOutcome.error, error: '$e');
    }
    try {
      await TrackingRepository(_db()).computeAndStoreRecovery();
    } catch (e) {
      debugPrint('HealthService recovery: $e');
    }
    if (result.outcome != HealthSyncOutcome.disabled) await _saveOutcome(result);
    return result;
  }

  Future<HealthSyncResult> _sync(bool background) async {
    final db = _db();
    final prefs = _prefs();
    final profile = await ProfileRepository(db).get();
    if (profile == null || !profile.healthConnectEnabled) return const HealthSyncResult(HealthSyncOutcome.disabled);
    if (await availability() != HcAvailability.available) {
      return const HealthSyncResult(HealthSyncOutcome.unavailable);
    }

    final t = types;
    bool? granted;
    try {
      granted = await _health.hasPermissions(t);
    } catch (e) {
      debugPrint('HealthService.hasPermissions: $e');
    }
    if (granted != true && !background && !(prefs.getBool(requestedKey) ?? false)) {
      granted = await requestPermissions();
    }

    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, now.day - syncDays);
    // Start 12 h earlier so the night ending on [firstDay] is read completely.
    final start = firstDay.subtract(const Duration(hours: 12));

    final points = <HcPoint>[];
    var failures = 0;
    for (final type in t) {
      try {
        final data = await _health.getHealthDataFromTypes(types: [type], startTime: start, endTime: now);
        points.addAll(data.map(hcPointFrom));
      } catch (e) {
        failures++;
        debugPrint('HealthService read ${type.name}: $e');
      }
    }
    if (points.isEmpty && failures == t.length && granted != true) {
      return const HealthSyncResult(HealthSyncOutcome.noPermission);
    }

    // De-duplicated step totals straight from Health Connect.
    final stepsTotals = <DateTime, int>{};
    if (t.contains(HealthDataType.STEPS)) {
      for (var d = firstDay; !d.isAfter(now); d = DateTime(d.year, d.month, d.day + 1)) {
        try {
          final end = DateTime(d.year, d.month, d.day + 1);
          final v = await _health.getTotalStepsInInterval(d, end.isAfter(now) ? now : end);
          if (v != null) stepsTotals[d] = v;
        } catch (e) {
          debugPrint('HealthService steps total: $e');
        }
      }
    }

    final result = await writeHealthPoints(db, points, firstDay: firstDay, stepsTotals: stepsTotals, now: now);
    await _mergeSnapshot(prefs, points);
    await prefs.setString(SettingsKeys.lastHealthSync, now.toIso8601String());
    return result;
  }

  Future<void> _mergeSnapshot(SharedPreferences prefs, List<HcPoint> points) async {
    final prev = HealthSnapshot.fromPrefs(prefs);
    final items = {...prev.items};
    latestPerType(points).forEach((k, v) {
      final old = items[k];
      if (old == null || !v.at.isBefore(old.at)) items[k] = v;
    });
    final snap = HealthSnapshot(
      lastSync: prev.lastSync,
      lastOutcome: prev.lastOutcome,
      lastError: prev.lastError,
      lastPointCount: points.length,
      items: items,
    );
    await prefs.setString(snapshotKey, jsonEncode(snap.toJson()));
  }

  Future<void> _saveOutcome(HealthSyncResult r) async {
    try {
      final prefs = _prefs();
      final prev = HealthSnapshot.fromPrefs(prefs);
      final snap = HealthSnapshot(
        lastSync: prev.lastSync,
        lastOutcome: r.outcome,
        lastError: r.error,
        lastPointCount: r.outcome == HealthSyncOutcome.ok ? r.points : prev.lastPointCount,
        items: prev.items,
      );
      await prefs.setString(snapshotKey, jsonEncode(snap.toJson()));
    } catch (e) {
      debugPrint('HealthService save outcome: $e');
    }
  }
}

/// Converts a `health` package point to the platform-independent [HcPoint].
HcPoint hcPointFrom(HealthDataPoint p) {
  final v = p.value;
  final num value = v is NumericHealthValue ? v.numericValue : 0;
  final source = p.sourceName.isNotEmpty ? p.sourceName : p.sourceId;
  return HcPoint(type: p.type.name, value: value.toDouble(), from: p.dateFrom, to: p.dateTo, source: source);
}

/// Maps pulled points to rows: sleep_logs (source health_connect, never over a manual entry)
/// and health_daily (upsert by date). Days before [firstDay] (partial reads) are skipped.
Future<HealthSyncResult> writeHealthPoints(
  AppDatabase db,
  List<HcPoint> points, {
  required DateTime firstDay,
  Map<DateTime, int> stepsTotals = const {},
  DateTime? now,
}) async {
  final repo = TrackingRepository(db);
  final syncedAt = now ?? DateTime.now();
  var nights = 0, days = 0;
  for (final n in aggregateSleep(points)) {
    if (n.date.isBefore(firstDay) || n.durationMin <= 0) continue;
    if (await repo.upsertHcSleep(n)) nights++;
  }
  final daily = aggregateDaily(points, stepsTotals: stepsTotals);
  for (final h in daily.values) {
    if (h.date.isBefore(firstDay) || (h.isEmpty && h.sources.isEmpty)) continue;
    await repo.upsertDaily(h, syncedAt: syncedAt);
    days++;
  }
  // Recovery for every synced day so history / charts have scores.
  final last = DateTime(syncedAt.year, syncedAt.month, syncedAt.day);
  for (var d = firstDay; !d.isAfter(last); d = DateTime(d.year, d.month, d.day + 1)) {
    await repo.computeAndStoreRecovery(d);
  }
  return HealthSyncResult(HealthSyncOutcome.ok, points: points.length, nights: nights, days: days);
}

final healthServiceProvider = Provider<HealthService>((ref) => HealthService(ref));

/// Current Health Connect availability + permission state (refresh with ref.invalidate).
final healthStatusProvider = FutureProvider<HealthStatus>((ref) => ref.watch(healthServiceProvider).status());

/// Last pulled snapshot (refresh with ref.invalidate after a sync).
final healthSnapshotProvider = FutureProvider<HealthSnapshot>((ref) => ref.watch(healthServiceProvider).lastPulled());

/// Entry point for the workmanager callback when it builds a [ProviderContainer]
/// (with sharedPrefsProvider overridden). Never throws; never shows permission UI.
Future<void> backgroundHealthSync(ProviderContainer container) async {
  try {
    await container.read(healthServiceProvider).sync(background: true);
  } catch (e) {
    debugPrint('backgroundHealthSync: $e');
  }
}

/// Entry point for a background isolate without Riverpod. Never throws.
Future<void> healthSyncHeadless(AppDatabase db, SharedPreferences prefs) async {
  try {
    await HealthService.headless(db, prefs).sync(background: true);
  } catch (e) {
    debugPrint('healthSyncHeadless: $e');
  }
}
