/// Pure (DB- and platform-free) logic for the tracking feature: Health Connect point
/// aggregation, sleep math, recovery inputs, small helpers. Everything here is unit-tested.
library;

import 'dart:math' as math;

import '../../core/calc/recovery.dart';
import '../../core/calc/stats.dart';
import '../../data/db/database.dart';

DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

/// Health Connect type names (same strings as `HealthDataType.<name>.name`).
class HcType {
  static const sleepSession = 'SLEEP_SESSION';
  static const sleepAsleep = 'SLEEP_ASLEEP';
  static const sleepDeep = 'SLEEP_DEEP';
  static const sleepRem = 'SLEEP_REM';
  static const sleepLight = 'SLEEP_LIGHT';
  static const sleepAwake = 'SLEEP_AWAKE';
  static const heartRate = 'HEART_RATE';
  static const restingHeartRate = 'RESTING_HEART_RATE';
  static const hrv = 'HEART_RATE_VARIABILITY_RMSSD';
  static const steps = 'STEPS';
  static const activeEnergy = 'ACTIVE_ENERGY_BURNED';

  static const sleepStages = {sleepAsleep, sleepDeep, sleepRem, sleepLight, sleepAwake};
  static const sleepTypes = {sleepSession, ...sleepStages};

  /// Display order in the "last data pulled" table.
  static const all = [
    sleepSession,
    sleepDeep,
    sleepRem,
    sleepLight,
    sleepAwake,
    sleepAsleep,
    heartRate,
    restingHeartRate,
    hrv,
    steps,
    activeEnergy,
  ];
}

/// Platform-independent copy of a Health Connect data point.
class HcPoint {
  final String type;
  final double value;
  final DateTime from;
  final DateTime to;

  /// Package name of the app that wrote the record (e.g. com.cardoo.app).
  final String source;
  const HcPoint({
    required this.type,
    required this.value,
    required this.from,
    required this.to,
    this.source = '',
  });

  int get minutes => to.difference(from).inSeconds ~/ 60;

  @override
  String toString() => 'HcPoint($type, $value, $from → $to, $source)';
}

/// HRV / resting-HR readings taken in the evening belong to the next morning's recovery.
DateTime recoveryDayOf(DateTime t) => t.hour >= 20 ? _day(t).add(const Duration(days: 1)) : _day(t);

/// The day a point is attributed to in health_daily.
DateTime dayForPoint(HcPoint p) {
  if (HcType.sleepTypes.contains(p.type)) return _day(p.to);
  if (p.type == HcType.hrv || p.type == HcType.restingHeartRate) return recoveryDayOf(p.from);
  return _day(p.from);
}

// ───────────────────────── Sleep ─────────────────────────

/// One night of sleep (attributed to the wake-up day).
class SleepNight {
  final DateTime date;
  final DateTime start;
  final DateTime end;
  final int durationMin;
  final int? deepMin;
  final int? remMin;
  final int? lightMin;
  final int? awakeMin;
  final Set<String> sources;
  const SleepNight({
    required this.date,
    required this.start,
    required this.end,
    required this.durationMin,
    this.deepMin,
    this.remMin,
    this.lightMin,
    this.awakeMin,
    this.sources = const {},
  });

  bool get hasStages => deepMin != null || remMin != null || lightMin != null;

  @override
  String toString() => 'SleepNight(${date.toIso8601String()}, $durationMin min, '
      'deep $deepMin rem $remMin light $lightMin awake $awakeMin)';
}

class _Session {
  final DateTime from;
  DateTime to;
  final Set<String> sources;
  final List<HcPoint> stages = [];
  _Session(this.from, this.to, this.sources);
  int get minutes => to.difference(from).inSeconds ~/ 60;
  int overlapMinutes(DateTime a, DateTime b) {
    final s = from.isAfter(a) ? from : a;
    final e = to.isBefore(b) ? to : b;
    return e.isAfter(s) ? e.difference(s).inSeconds ~/ 60 : 0;
  }
}

/// Builds nights from SLEEP_SESSION + stage points.
///
/// * Stage points are assigned to the session that contains them.
/// * Overlapping sessions from different apps (e.g. ring + phone) are de-duplicated:
///   sessions with stages and longer ones win.
/// * Stage points without any session are clustered (gaps ≤ 90 min) into sessions.
/// * Asleep minutes = deep + rem + light + generic "asleep"; when no stages exist,
///   session length minus awake time.
/// * Several sessions that end on the same day (e.g. a nap) are summed into one night.
List<SleepNight> aggregateSleep(List<HcPoint> points) {
  final sessionPts = points.where((p) => p.type == HcType.sleepSession && p.to.isAfter(p.from)).toList();
  final stagePts = points.where((p) => HcType.sleepStages.contains(p.type) && p.to.isAfter(p.from)).toList()
    ..sort((a, b) => a.from.compareTo(b.from));

  var sessions = [for (final s in sessionPts) _Session(s.from, s.to, {if (s.source.isNotEmpty) s.source})];

  // Attach stages to sessions (≥ half of the stage within the session).
  final orphans = <HcPoint>[];
  for (final st in stagePts) {
    _Session? best;
    var bestOverlap = 0;
    for (final s in sessions) {
      final o = s.overlapMinutes(st.from, st.to);
      // Prefer the session written by the same app on ties.
      final better = o > bestOverlap ||
          (o == bestOverlap && o > 0 && s.sources.contains(st.source) && !(best?.sources.contains(st.source) ?? false));
      if (better) {
        best = s;
        bestOverlap = o;
      }
    }
    if (best != null && bestOverlap * 2 >= math.max(1, st.minutes)) {
      best.stages.add(st);
      if (st.source.isNotEmpty) best.sources.add(st.source);
    } else {
      orphans.add(st);
    }
  }

  // Cluster orphan stage points into pseudo sessions.
  _Session? cur;
  for (final st in orphans) {
    if (cur == null || st.from.difference(cur.to).inMinutes > 90) {
      cur = _Session(st.from, st.to, {});
      sessions.add(cur);
    }
    if (st.to.isAfter(cur.to)) cur.to = st.to;
    cur.stages.add(st);
    if (st.source.isNotEmpty) cur.sources.add(st.source);
  }

  // De-duplicate overlapping sessions written by several apps.
  sessions.sort((a, b) {
    final s = (b.stages.isNotEmpty ? 1 : 0) - (a.stages.isNotEmpty ? 1 : 0);
    return s != 0 ? s : b.minutes.compareTo(a.minutes);
  });
  final accepted = <_Session>[];
  for (final s in sessions) {
    final dup = accepted.any((a) => a.overlapMinutes(s.from, s.to) * 2 > math.max(1, s.minutes));
    if (!dup) accepted.add(s);
  }
  sessions = accepted;

  final byDay = <DateTime, List<_Session>>{};
  for (final s in sessions) {
    byDay.putIfAbsent(_day(s.to), () => []).add(s);
  }

  final nights = <SleepNight>[];
  byDay.forEach((day, list) {
    var total = 0;
    int? deep, rem, light, awake;
    final sources = <String>{};
    for (final s in list) {
      sources.addAll(s.sources);
      int sum(String t) => s.stages.where((p) => p.type == t).fold(0, (a, p) => a + p.minutes);
      final d = sum(HcType.sleepDeep), r = sum(HcType.sleepRem), l = sum(HcType.sleepLight);
      final g = sum(HcType.sleepAsleep), w = sum(HcType.sleepAwake);
      final hasStages = s.stages.any((p) => p.type != HcType.sleepAwake);
      if (s.stages.any((p) => p.type == HcType.sleepDeep)) deep = (deep ?? 0) + d;
      if (s.stages.any((p) => p.type == HcType.sleepRem)) rem = (rem ?? 0) + r;
      if (s.stages.any((p) => p.type == HcType.sleepLight)) light = (light ?? 0) + l;
      if (s.stages.any((p) => p.type == HcType.sleepAwake)) awake = (awake ?? 0) + w;
      final asleep = d + r + l + g;
      total += hasStages && asleep > 0 ? asleep : math.max(0, s.minutes - w);
    }
    list.sort((a, b) => a.from.compareTo(b.from));
    nights.add(SleepNight(
      date: day,
      start: list.first.from,
      end: list.map((s) => s.to).reduce((a, b) => a.isAfter(b) ? a : b),
      durationMin: total,
      deepMin: deep,
      remMin: rem,
      lightMin: light,
      awakeMin: awake,
      sources: sources,
    ));
  });
  nights.sort((a, b) => a.date.compareTo(b.date));
  return nights;
}

/// Duration in minutes between bed and wake times given as minutes-of-day (crosses midnight).
int sleepMinutesBetween(int bedMinuteOfDay, int wakeMinuteOfDay) {
  var d = wakeMinuteOfDay - bedMinuteOfDay;
  if (d <= 0) d += 24 * 60;
  return d;
}

/// Sleep need from the user's habitual bed/wake times ("23:30" / "07:00"), clamped to 7–9 h.
int sleepNeedFromProfile(String? sleepTime, String? wakeTime) {
  int? parse(String? s) {
    if (s == null) return null;
    final p = s.split(':');
    if (p.length != 2) return null;
    final h = int.tryParse(p[0]), m = int.tryParse(p[1]);
    if (h == null || m == null) return null;
    return h * 60 + m;
  }

  final b = parse(sleepTime), w = parse(wakeTime);
  if (b == null || w == null) return 480;
  return sleepMinutesBetween(b, w).clamp(420, 540);
}

/// Duration (minutes) per day for the [n] days ending at [end] (oldest first); null = no entry.
List<int?> sleepPerDay(List<SleepLog> logs, DateTime end, int n) {
  final byDay = <DateTime, int>{};
  for (final l in logs) {
    final d = _day(l.date);
    byDay[d] = math.max(byDay[d] ?? 0, l.durationMin);
  }
  final last = _day(end);
  return [for (var i = n - 1; i >= 0; i--) byDay[DateTime(last.year, last.month, last.day - i)]];
}

/// Average of the non-null values (minutes), or null.
double? averageSleep(List<int?> perDay) {
  final v = perDay.whereType<int>().where((m) => m > 0).map((m) => m.toDouble());
  return Stats.mean(v);
}

// ───────────────────────── Daily vitals ─────────────────────────

class DailyHealth {
  final DateTime date;
  int? steps;
  double? avgHr;
  double? restingHr;
  double? hrv;
  double? activeCalories;
  final Set<String> sources = {};
  DailyHealth(this.date);

  bool get isEmpty => steps == null && avgHr == null && restingHr == null && hrv == null && activeCalories == null;

  @override
  String toString() =>
      'DailyHealth(${date.toIso8601String()}, steps $steps, hr $avgHr, rhr $restingHr, hrv $hrv, kcal $activeCalories, $sources)';
}

/// Sum per (day, source), then take the largest source total per day. This avoids double counting
/// when the phone and the ring both write steps / calories for the same period.
Map<DateTime, double> maxSourceDailySum(Iterable<HcPoint> points) {
  final perDaySource = <DateTime, Map<String, double>>{};
  for (final p in points) {
    final m = perDaySource.putIfAbsent(_day(p.from), () => {});
    m[p.source] = (m[p.source] ?? 0) + p.value;
  }
  return perDaySource.map((d, m) => MapEntry(d, m.values.reduce(math.max)));
}

double _percentile(List<double> values, double pct) {
  final s = [...values]..sort();
  final idx = ((s.length - 1) * pct).round().clamp(0, s.length - 1);
  return s[idx];
}

/// Aggregates vitals per day. [stepsTotals] (from Health Connect's de-duplicated aggregate)
/// override the per-source step sums when provided.
Map<DateTime, DailyHealth> aggregateDaily(List<HcPoint> points, {Map<DateTime, int> stepsTotals = const {}}) {
  final out = <DateTime, DailyHealth>{};
  DailyHealth at(DateTime d) => out.putIfAbsent(_day(d), () => DailyHealth(_day(d)));

  for (final p in points) {
    if (p.source.isNotEmpty) at(dayForPoint(p)).sources.add(p.source);
  }

  maxSourceDailySum(points.where((p) => p.type == HcType.steps)).forEach((d, v) => at(d).steps = v.round());
  stepsTotals.forEach((d, v) {
    if (v > 0) at(d).steps = v;
  });
  maxSourceDailySum(points.where((p) => p.type == HcType.activeEnergy))
      .forEach((d, v) => at(d).activeCalories = double.parse(v.toStringAsFixed(1)));

  final hrByDay = <DateTime, List<double>>{};
  for (final p in points.where((p) => p.type == HcType.heartRate && p.value > 0)) {
    hrByDay.putIfAbsent(_day(p.from), () => []).add(p.value);
  }
  hrByDay.forEach((d, v) => at(d).avgHr = _round1(Stats.mean(v)!));

  final rhrByDay = <DateTime, List<double>>{};
  for (final p in points.where((p) => p.type == HcType.restingHeartRate && p.value > 0)) {
    rhrByDay.putIfAbsent(recoveryDayOf(p.from), () => []).add(p.value);
  }
  rhrByDay.forEach((d, v) => at(d).restingHr = _round1(Stats.mean(v)!));
  // Fallback when the source writes only raw HR: 5th percentile of a day with enough samples.
  hrByDay.forEach((d, v) {
    if (at(d).restingHr == null && v.length >= 30) at(d).restingHr = _round1(_percentile(v, 0.05));
  });

  final hrvByDay = <DateTime, List<double>>{};
  for (final p in points.where((p) => p.type == HcType.hrv && p.value > 0)) {
    hrvByDay.putIfAbsent(recoveryDayOf(p.from), () => []).add(p.value);
  }
  hrvByDay.forEach((d, v) => at(d).hrv = _round1(Stats.mean(v)!));

  return out;
}

double _round1(double v) => (v * 10).round() / 10;

/// One row of the "last data pulled" table.
class PulledItem {
  final String type;
  final DateTime at;
  final double value;
  final String source;
  const PulledItem({required this.type, required this.at, required this.value, required this.source});

  Map<String, dynamic> toJson() => {'type': type, 'at': at.toIso8601String(), 'value': value, 'source': source};

  static PulledItem? fromJson(Object? j) {
    if (j is! Map) return null;
    final at = DateTime.tryParse('${j['at']}');
    if (at == null || j['type'] is! String) return null;
    return PulledItem(
      type: j['type'] as String,
      at: at,
      value: (j['value'] as num?)?.toDouble() ?? 0,
      source: '${j['source'] ?? ''}',
    );
  }
}

/// Latest point per type (by end time). Sleep values are minutes.
Map<String, PulledItem> latestPerType(List<HcPoint> points) {
  final out = <String, PulledItem>{};
  for (final p in points) {
    final prev = out[p.type];
    if (prev == null || p.to.isAfter(prev.at)) {
      final v = HcType.sleepTypes.contains(p.type) ? p.minutes.toDouble() : p.value;
      out[p.type] = PulledItem(type: p.type, at: p.to, value: v, source: p.source);
    }
  }
  return out;
}

// ───────────────────────── Recovery ─────────────────────────

class RecoveryBreakdown {
  final DateTime date;
  final int? score;
  final RecoveryLevel? level;
  final int? sleepMin;
  final int? sleepQuality;
  final int sleepNeedMin;
  final String? sleepSource;
  final double? hrv;
  final double? hrvBaseline;
  final double? restingHr;
  final double? restingHrBaseline;

  /// Number of past days with HRV / resting HR in the baseline window.
  final int baselineDays;
  const RecoveryBreakdown({
    required this.date,
    required this.score,
    required this.level,
    this.sleepMin,
    this.sleepQuality,
    this.sleepNeedMin = 480,
    this.sleepSource,
    this.hrv,
    this.hrvBaseline,
    this.restingHr,
    this.restingHrBaseline,
    this.baselineDays = 0,
  });

  bool get hasData => score != null;

  /// The baseline is considered reliable from 14 days of data.
  bool get baselineCalibrating => baselineDays < RecoveryBaseline.targetDays;

  RecoveryInput get input => RecoveryInput(
        sleepMin: sleepMin,
        sleepQuality: sleepQuality,
        hrv: hrv,
        hrvBaseline: hrvBaseline,
        restingHr: restingHr,
        restingHrBaseline: restingHrBaseline,
        sleepNeedMin: sleepNeedMin,
      );
}

class RecoveryBaseline {
  /// Look-back window (days before the scored day).
  static const windowDays = 30;

  /// Days of history for a "calibrated" baseline.
  static const targetDays = 14;

  /// Minimum days before HRV / resting HR are compared at all.
  static const minDays = 3;
}

/// Computes the recovery breakdown for [day].
///
/// * [sleep]: the sleep log(s) dated [day] (woke up that day); the longest is used.
/// * [todayHealth]: health_daily row of [day] (HRV, resting HR).
/// * [history]: health_daily rows; only the [RecoveryBaseline.windowDays] days before [day] are used.
RecoveryBreakdown computeRecovery({
  required DateTime day,
  List<SleepLog> sleep = const [],
  HealthDailyData? todayHealth,
  List<HealthDailyData> history = const [],
  int sleepNeedMin = 480,
}) {
  final d = _day(day);
  final from = d.subtract(const Duration(days: RecoveryBaseline.windowDays));
  final window = history.where((h) => !h.date.isBefore(from) && h.date.isBefore(d)).toList();

  final hrvHist = window.map((h) => h.hrv).whereType<double>().where((v) => v > 0).toList();
  final rhrHist = window.map((h) => h.restingHr).whereType<double>().where((v) => v > 0).toList();
  final hrvBase = hrvHist.length >= RecoveryBaseline.minDays ? Stats.mean(hrvHist) : null;
  final rhrBase = rhrHist.length >= RecoveryBaseline.minDays ? Stats.mean(rhrHist) : null;

  final todays = sleep.where((s) => _day(s.date) == d).toList()
    ..sort((a, b) {
      // Prefer manual entries (the user corrected the data), then the longest.
      final m = (b.source == 'manual' ? 1 : 0) - (a.source == 'manual' ? 1 : 0);
      return m != 0 ? m : b.durationMin.compareTo(a.durationMin);
    });
  final s = todays.isEmpty ? null : todays.first;

  final input = RecoveryInput(
    sleepMin: s != null && s.durationMin > 0 ? s.durationMin : null,
    sleepQuality: s?.quality,
    hrv: todayHealth?.hrv,
    hrvBaseline: hrvBase,
    restingHr: todayHealth?.restingHr,
    restingHrBaseline: rhrBase,
    sleepNeedMin: sleepNeedMin,
  );
  final score = RecoveryCalc.score(input);
  return RecoveryBreakdown(
    date: d,
    score: score,
    level: score == null ? null : RecoveryCalc.level(score),
    sleepMin: input.sleepMin,
    sleepQuality: input.sleepQuality,
    sleepNeedMin: sleepNeedMin,
    sleepSource: s?.source,
    hrv: input.hrv,
    hrvBaseline: hrvBase,
    restingHr: input.restingHr,
    restingHrBaseline: rhrBase,
    baselineDays: math.max(hrvHist.length, rhrHist.length),
  );
}

// ───────────────────────── Misc ─────────────────────────

/// True when the last measurement entry is older than 7 days (or there is none).
bool measurementsDue(DateTime? lastEntry, DateTime now) =>
    lastEntry == null || _day(now).difference(_day(lastEntry)).inDays > 7;

bool hasMeasurements(BodyMetric m) =>
    m.waistCm != null ||
    m.chestCm != null ||
    m.armCm != null ||
    m.thighCm != null ||
    m.neckCm != null ||
    m.hipsCm != null ||
    m.bodyFatPct != null;

/// Body measurement fields shown in the measurement screens.
enum Measure { waist, chest, arm, thigh, neck, hips, bodyFat }

double? measureValue(BodyMetric m, Measure k) => switch (k) {
      Measure.waist => m.waistCm,
      Measure.chest => m.chestCm,
      Measure.arm => m.armCm,
      Measure.thigh => m.thighCm,
      Measure.neck => m.neckCm,
      Measure.hips => m.hipsCm,
      Measure.bodyFat => m.bodyFatPct,
    };

/// Weight series (one value per day, latest entry wins) sorted by date.
List<DatedValue> weightSeries(List<BodyMetric> rows) {
  final byDay = <DateTime, double>{};
  for (final r in [...rows]..sort((a, b) => a.id.compareTo(b.id))) {
    if (r.weightKg != null) byDay[_day(r.date)] = r.weightKg!;
  }
  final out = byDay.entries.map((e) => DatedValue(e.key, e.value)).toList()
    ..sort((a, b) => a.date.compareTo(b.date));
  return out;
}
