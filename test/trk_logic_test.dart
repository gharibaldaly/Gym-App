import 'package:flutter_test/flutter_test.dart';
import 'package:ironmind/core/calc/recovery.dart';
import 'package:ironmind/data/db/database.dart';
import 'package:ironmind/features/tracking/tracking_logic.dart';

HcPoint pt(String type, DateTime from, DateTime to, {double value = 0, String source = 'com.cardoo.ring'}) =>
    HcPoint(type: type, value: value, from: from, to: to, source: source);

HcPoint inst(String type, DateTime at, double value, {String source = 'com.cardoo.ring'}) =>
    HcPoint(type: type, value: value, from: at, to: at, source: source);

SleepLog sleepLog(DateTime date, int min, {int? quality, String source = 'manual', int id = 1}) => SleepLog(
      id: id,
      date: date,
      durationMin: min,
      quality: quality,
      source: source,
    );

HealthDailyData hd(DateTime date, {double? hrv, double? rhr, int id = 0}) => HealthDailyData(
      id: id,
      date: date,
      hrv: hrv,
      restingHr: rhr,
      sourcesJson: '[]',
    );

void main() {
  group('sleep aggregation', () {
    final bed = DateTime(2026, 10, 19, 23, 0);
    final wake = DateTime(2026, 10, 20, 7, 0);

    test('session with stages → asleep = deep + rem + light, wake-day attribution', () {
      final points = [
        pt(HcType.sleepSession, bed, wake, value: 480),
        pt(HcType.sleepLight, bed, bed.add(const Duration(hours: 3))),
        pt(HcType.sleepDeep, bed.add(const Duration(hours: 3)), bed.add(const Duration(hours: 4, minutes: 30))),
        pt(HcType.sleepAwake, bed.add(const Duration(hours: 4, minutes: 30)), bed.add(const Duration(hours: 5))),
        pt(HcType.sleepRem, bed.add(const Duration(hours: 5)), bed.add(const Duration(hours: 6, minutes: 30))),
        pt(HcType.sleepLight, bed.add(const Duration(hours: 6, minutes: 30)), wake),
      ];
      final nights = aggregateSleep(points);
      expect(nights, hasLength(1));
      final n = nights.single;
      expect(n.date, DateTime(2026, 10, 20));
      expect(n.deepMin, 90);
      expect(n.remMin, 90);
      expect(n.lightMin, 180 + 90);
      expect(n.awakeMin, 30);
      expect(n.durationMin, 90 + 90 + 270);
      expect(n.start, bed);
      expect(n.end, wake);
      expect(n.sources, {'com.cardoo.ring'});
    });

    test('session without stages → session length', () {
      final n = aggregateSleep([pt(HcType.sleepSession, bed, wake)]).single;
      expect(n.durationMin, 480);
      expect(n.hasStages, isFalse);
      expect(n.deepMin, isNull);
    });

    test('only awake stages → session minus awake', () {
      final n = aggregateSleep([
        pt(HcType.sleepSession, bed, wake),
        pt(HcType.sleepAwake, bed, bed.add(const Duration(minutes: 40))),
      ]).single;
      expect(n.durationMin, 440);
      expect(n.awakeMin, 40);
    });

    test('duplicate overlapping sessions from two apps are not double counted', () {
      final nights = aggregateSleep([
        pt(HcType.sleepSession, bed, wake, source: 'com.phone'),
        pt(HcType.sleepSession, bed.add(const Duration(minutes: 10)), wake, source: 'com.cardoo.ring'),
        pt(HcType.sleepDeep, bed.add(const Duration(minutes: 10)), bed.add(const Duration(hours: 2)),
            source: 'com.cardoo.ring'),
        pt(HcType.sleepLight, bed.add(const Duration(hours: 2)), wake, source: 'com.cardoo.ring'),
      ]);
      expect(nights, hasLength(1));
      // The session with stages wins: 110 deep + 360 light.
      expect(nights.single.durationMin, 470);
      expect(nights.single.sources, {'com.cardoo.ring'});
      expect(nights.single.deepMin, 110);
    });

    test('nap ending the same day is added; different wake days are separate nights', () {
      final nights = aggregateSleep([
        pt(HcType.sleepSession, bed, wake),
        pt(HcType.sleepSession, DateTime(2026, 10, 20, 14), DateTime(2026, 10, 20, 14, 30)),
        pt(HcType.sleepSession, DateTime(2026, 10, 18, 23), DateTime(2026, 10, 19, 6)),
      ]);
      expect(nights.map((n) => n.date), [DateTime(2026, 10, 19), DateTime(2026, 10, 20)]);
      expect(nights.last.durationMin, 480 + 30);
      expect(nights.first.durationMin, 420);
    });

    test('stage points without a session are clustered into one night', () {
      final n = aggregateSleep([
        pt(HcType.sleepAsleep, bed, bed.add(const Duration(hours: 3))),
        pt(HcType.sleepAsleep, bed.add(const Duration(hours: 3, minutes: 20)), wake),
      ]).single;
      expect(n.date, DateTime(2026, 10, 20));
      expect(n.durationMin, 180 + 280);
    });

    test('bed/wake minutes across midnight', () {
      expect(sleepMinutesBetween(23 * 60 + 30, 7 * 60), 450);
      expect(sleepMinutesBetween(1 * 60, 9 * 60), 480);
    });

    test('sleep need from profile is clamped to 7–9 h', () {
      expect(sleepNeedFromProfile('23:30', '07:00'), 450);
      expect(sleepNeedFromProfile('02:00', '07:00'), 420);
      expect(sleepNeedFromProfile('21:00', '09:00'), 540);
      expect(sleepNeedFromProfile(null, '07:00'), 480);
    });

    test('per-day series and average', () {
      final end = DateTime(2026, 10, 20);
      final s = sleepPerDay([
        sleepLog(DateTime(2026, 10, 20), 420),
        sleepLog(DateTime(2026, 10, 18), 480),
      ], end, 4);
      expect(s, [null, 480, null, 420]);
      expect(averageSleep(s), 450);
    });
  });

  group('daily vitals mapping', () {
    test('steps / calories use the largest source per day (no double counting)', () {
      final d = DateTime(2026, 10, 20, 10);
      final daily = aggregateDaily([
        pt(HcType.steps, d, d.add(const Duration(hours: 1)), value: 3000, source: 'phone'),
        pt(HcType.steps, d.add(const Duration(hours: 2)), d.add(const Duration(hours: 3)), value: 2000, source: 'phone'),
        pt(HcType.steps, d, d.add(const Duration(hours: 3)), value: 4500, source: 'ring'),
        pt(HcType.activeEnergy, d, d.add(const Duration(hours: 1)), value: 120.25, source: 'ring'),
      ]);
      final h = daily[DateTime(2026, 10, 20)]!;
      expect(h.steps, 5000);
      expect(h.activeCalories, closeTo(120.3, 0.06));
      expect(h.sources, {'phone', 'ring'});
    });

    test('step totals from Health Connect override sums', () {
      final d = DateTime(2026, 10, 20, 10);
      final daily = aggregateDaily([
        pt(HcType.steps, d, d.add(const Duration(hours: 1)), value: 3000),
      ], stepsTotals: {DateTime(2026, 10, 20): 7777});
      expect(daily[DateTime(2026, 10, 20)]!.steps, 7777);
    });

    test('HR average, resting HR and HRV; evening readings count for the next morning', () {
      final points = [
        inst(HcType.heartRate, DateTime(2026, 10, 20, 9), 70),
        inst(HcType.heartRate, DateTime(2026, 10, 20, 12), 90),
        inst(HcType.restingHeartRate, DateTime(2026, 10, 20, 4), 55),
        inst(HcType.hrv, DateTime(2026, 10, 20, 3), 60),
        inst(HcType.hrv, DateTime(2026, 10, 20, 5), 50),
        inst(HcType.hrv, DateTime(2026, 10, 19, 23), 40),
      ];
      final daily = aggregateDaily(points);
      final h = daily[DateTime(2026, 10, 20)]!;
      expect(h.avgHr, 80);
      expect(h.restingHr, 55);
      expect(h.hrv, 50); // (60 + 50 + 40) / 3
      expect(daily[DateTime(2026, 10, 19)], isNull);
    });

    test('resting HR falls back to a low percentile of raw HR', () {
      final base = DateTime(2026, 10, 20, 0);
      final points = [
        for (var i = 0; i < 40; i++) inst(HcType.heartRate, base.add(Duration(minutes: i * 30)), 50.0 + i),
      ];
      final h = aggregateDaily(points)[DateTime(2026, 10, 20)]!;
      expect(h.restingHr, 52);
    });

    test('latest point per type for the "last pulled" table', () {
      final latest = latestPerType([
        inst(HcType.hrv, DateTime(2026, 10, 19, 3), 45, source: 'a'),
        inst(HcType.hrv, DateTime(2026, 10, 20, 3), 55, source: 'b'),
        pt(HcType.sleepSession, DateTime(2026, 10, 19, 23), DateTime(2026, 10, 20, 7)),
      ]);
      expect(latest[HcType.hrv]!.value, 55);
      expect(latest[HcType.hrv]!.source, 'b');
      expect(latest[HcType.sleepSession]!.value, 480);
      final round = PulledItem.fromJson(latest[HcType.hrv]!.toJson())!;
      expect(round.at, DateTime(2026, 10, 20, 3));
      expect(round.type, HcType.hrv);
    });
  });

  group('recovery', () {
    final day = DateTime(2026, 10, 20);
    List<HealthDailyData> history(int n, {double hrv = 60, double rhr = 55}) => [
          for (var i = 1; i <= n; i++) hd(day.subtract(Duration(days: i)), hrv: hrv, rhr: rhr, id: i),
        ];

    test('no data → null score', () {
      final b = computeRecovery(day: day);
      expect(b.score, isNull);
      expect(b.level, isNull);
    });

    test('baseline-level vitals and full sleep → matches RecoveryCalc', () {
      final b = computeRecovery(
        day: day,
        sleep: [sleepLog(day, 480, source: 'health_connect')],
        todayHealth: hd(day, hrv: 60, rhr: 55),
        history: history(20),
      );
      expect(b.hrvBaseline, 60);
      expect(b.restingHrBaseline, 55);
      expect(b.baselineDays, 20);
      expect(b.baselineCalibrating, isFalse);
      // sleep 100 × 0.4 + hrv 50 × 0.35 + rhr 50 × 0.25 = 70
      expect(b.score, 70);
      expect(b.level, RecoveryLevel.high);
      expect(b.score, RecoveryCalc.score(b.input));
    });

    test('low HRV + high resting HR + short sleep → low', () {
      final b = computeRecovery(
        day: day,
        sleep: [sleepLog(day, 300)],
        todayHealth: hd(day, hrv: 45, rhr: 62),
        history: history(20),
      );
      expect(b.level, RecoveryLevel.low);
    });

    test('too little history → HRV ignored, sleep only', () {
      final b = computeRecovery(
        day: day,
        sleep: [sleepLog(day, 240, quality: 5)],
        todayHealth: hd(day, hrv: 10, rhr: 90),
        history: history(2),
      );
      expect(b.hrvBaseline, isNull);
      expect(b.baselineCalibrating, isTrue);
      // 50 × 0.7 + 100 × 0.3 = 65
      expect(b.score, 65);
    });

    test('history outside the 30-day window and the day itself are excluded', () {
      final b = computeRecovery(
        day: day,
        todayHealth: hd(day, hrv: 60),
        history: [
          hd(day, hrv: 999),
          ...history(3, hrv: 60),
          hd(day.subtract(const Duration(days: 40)), hrv: 999),
        ],
      );
      expect(b.hrvBaseline, 60);
      expect(b.score, 50);
    });

    test('manual sleep is preferred over Health Connect for the same day', () {
      final b = computeRecovery(day: day, sleep: [
        sleepLog(day, 500, source: 'health_connect', id: 1),
        sleepLog(day, 300, quality: 2, id: 2),
      ]);
      expect(b.sleepMin, 300);
      expect(b.sleepQuality, 2);
    });
  });

  test('measurement reminder after 7 days', () {
    final now = DateTime(2026, 10, 20, 9);
    expect(measurementsDue(null, now), isTrue);
    expect(measurementsDue(DateTime(2026, 10, 13), now), isFalse);
    expect(measurementsDue(DateTime(2026, 10, 12), now), isTrue);
  });

  test('weight series keeps one value per day', () {
    final s = weightSeries([
      BodyMetric(id: 1, date: DateTime(2026, 10, 18), weightKg: 80),
      BodyMetric(id: 2, date: DateTime(2026, 10, 19), weightKg: 79.5),
      BodyMetric(id: 3, date: DateTime(2026, 10, 19), weightKg: 79.8),
      BodyMetric(id: 4, date: DateTime(2026, 10, 20), waistCm: 85),
    ]);
    expect(s.map((e) => e.value), [80, 79.8]);
  });
}
