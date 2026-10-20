import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironmind/core/calc/stats.dart';
import 'package:ironmind/core/calc/strength_calc.dart';
import 'package:ironmind/core/providers.dart';
import 'package:ironmind/features/progress/adherence_calendar.dart';
import 'package:ironmind/features/progress/progress_providers.dart';

import 'prog_seed.dart';

SetRow _s(
  DateTime d,
  String ex,
  double w,
  int r, {
  double? rpe,
  String type = 'normal',
  List<String> muscles = const ['chest'],
  int session = 1,
  int idx = 0,
}) =>
    SetRow(
      sessionId: session,
      date: d,
      exerciseId: ex,
      setIndex: idx,
      weightKg: w,
      reps: r,
      rpe: rpe,
      setType: type,
      primaryMuscles: muscles,
    );

void main() {
  group('dates', () {
    test('weeks start on Saturday', () {
      expect(weekStartSat(DateTime(2026, 10, 20)), DateTime(2026, 10, 17)); // Tue → Sat
      expect(weekStartSat(DateTime(2026, 10, 17, 15)), DateTime(2026, 10, 17)); // Sat itself
      expect(weekStartSat(DateTime(2026, 10, 23)), DateTime(2026, 10, 17)); // Fri → previous Sat
      expect(weeksInRange(DateTime(2026, 10, 16), DateTime(2026, 10, 17)), 2);
      expect(weeksInRange(DateTime(2026, 10, 17), DateTime(2026, 10, 23)), 1);
    });

    test('addDays stays on local midnight across month ends', () {
      expect(addDays(DateTime(2026, 10, 30), 3), DateTime(2026, 11, 2));
      expect(addDays(DateTime(2026, 3, 1), -1), DateTime(2026, 2, 28));
    });

    test('period windows are rolling and inclusive', () {
      final t = DateTime(2026, 10, 20, 18);
      expect(ProgressPeriod.week.startFrom(t), DateTime(2026, 10, 14));
      expect(ProgressPeriod.month.startFrom(t), DateTime(2026, 9, 21));
      expect(ProgressPeriod.all.startFrom(t), isNull);
    });

    test('calendar grid blanks for a Saturday-first week', () {
      expect(leadingBlanks(DateTime(2026, 10)), 5); // 1 Oct 2026 is a Thursday
      expect(leadingBlanks(DateTime(2026, 8)), 0); // 1 Aug 2026 is a Saturday
      expect(leadingBlanks(DateTime(2026, 11)), 1); // Sunday
    });
  });

  group('weekly volume per muscle', () {
    final sat = DateTime(2026, 10, 17), mon = DateTime(2026, 10, 19), prevFri = DateTime(2026, 10, 16);
    final sets = [
      _s(sat, 'bench', 40, 10, type: 'warmup'),
      _s(sat, 'bench', 80, 8, rpe: 8),
      _s(sat, 'bench', 80, 8, rpe: 6), // working but not effective
      _s(mon, 'row', 60, 10, muscles: ['lats', 'middle back']), // no RPE → effective
      _s(mon, 'bench', 70, 10, type: 'drop', rpe: 9),
      _s(prevFri, 'bench', 75, 8, rpe: 7),
    ];

    test('warmups excluded, volume = weight × reps, effective sets counted', () {
      final stats = weeklyMuscleStats(sets);
      final chestThisWeek = stats.firstWhere((s) => s.weekStart == sat && s.muscle == 'chest');
      expect(chestThisWeek.volume, 80 * 8 * 2 + 70 * 10);
      expect(chestThisWeek.workingSets, 3);
      expect(chestThisWeek.effectiveSets, 2);
      final lats = stats.firstWhere((s) => s.muscle == 'lats');
      expect(lats.volume, 600);
      expect(lats.effectiveSets, 1);
      expect(stats.firstWhere((s) => s.muscle == 'middle back').volume, 600);
      final chestPrev = stats.firstWhere((s) => s.weekStart == DateTime(2026, 10, 10));
      expect(chestPrev.volume, 600);
    });

    test('summary averages per week and sorts by volume', () {
      final sum = summarizeMuscles(weeklyMuscleStats(sets), weeks: 2);
      expect(sum.first.muscle, 'chest');
      expect(sum.first.totalVolume, 2580);
      expect(sum.first.avgWeeklyVolume, 1290);
      expect(sum.first.avgWeeklyEffectiveSets, 1.5);
    });

    test('buildMuscleVolume uses the period length (min one week) and zero-fills weeks', () {
      final d = buildMuscleVolume(sets, from: DateTime(2026, 10, 7), today: DateTime(2026, 10, 20));
      expect(d.days, 14);
      expect(d.muscles.first.avgWeeklyVolume, closeTo(2580 / 2, 1e-9));
      expect(d.weeklyTotals.map((w) => w.date), [DateTime(2026, 10, 10), DateTime(2026, 10, 17)]);
      expect(d.weeklyTotals.last.value, 80 * 8 * 2 + 70 * 10 + 600);
      final short = buildMuscleVolume(sets, from: DateTime(2026, 10, 19), today: DateTime(2026, 10, 20));
      expect(short.muscles.first.weeks, 1); // never extrapolates above the real total
      expect(buildMuscleVolume(const [], today: DateTime(2026, 10, 20)).isEmpty, isTrue);
    });
  });

  group('exercise progress + PRs', () {
    final d1 = DateTime(2026, 10, 1), d2 = DateTime(2026, 10, 4), d3 = DateTime(2026, 10, 8);
    final sets = [
      _s(d1, 'bench', 60, 10, type: 'warmup', idx: 0),
      _s(d1, 'bench', 80, 8, idx: 1),
      _s(d1, 'bench', 80, 6, idx: 2),
      _s(d2, 'bench', 82.5, 6, idx: 0),
      _s(d2, 'bench', 80, 9, idx: 1),
      _s(d3, 'bench', 85, 3, idx: 0),
      _s(d3, 'bench', 85, 3, idx: 1),
      _s(d1, 'squat', 100, 5, muscles: ['quadriceps']),
    ];

    test('series has one point per day with top set and best e1RM', () {
      final pts = exerciseProgressSeries(sets.where((s) => s.exerciseId == 'bench'));
      expect(pts.map((p) => p.date), [d1, d2, d3]);
      expect(pts[0].topWeight, 80);
      expect(pts[0].topReps, 8);
      expect(pts[0].bestE1rm, closeTo(StrengthCalc.epley1Rm(80, 8), 1e-9));
      expect(pts[1].topWeight, 82.5);
      expect(pts[1].bestE1rm, closeTo(StrengthCalc.epley1Rm(80, 9), 1e-9)); // 104 > 99
      expect(pts[2].volume, 85 * 3 * 2);
    });

    test('all-time records per exercise', () {
      final prs = computeExercisePrs(sets);
      final bench = prs.firstWhere((p) => p.exerciseId == 'bench');
      expect(bench.heaviest.weightKg, 85);
      expect(bench.heaviest.date, d3); // first time reached
      expect(bench.bestE1rm.weightKg, 80);
      expect(bench.bestE1rm.reps, 9);
      expect(bench.bestE1rm.date, d2);
      expect(bench.repsAtWeight.map((e) => (e.weightKg, e.reps)), [(85.0, 3), (82.5, 6), (80.0, 9)]);
      expect(bench.workingSets, 6);
      expect(prs.first.exerciseId, 'bench'); // most recently trained first
    });

    test('PR events replay history like PrDetector (first log is not a PR)', () {
      final events = detectPrEvents(sets);
      expect(events.map((e) => (e.set.date, e.set.weightKg, e.set.reps, e.types)).toList(), [
        (d2, 82.5, 6, {PrType.weight}),
        (d2, 80.0, 9, {PrType.reps, PrType.e1rm}),
        (d3, 85.0, 3, {PrType.weight}),
      ]);
      // Cross-check every event against the shared detector.
      final sorted = sets.where((s) => !s.isWarmup).toList();
      for (final e in events) {
        final history = sorted
            .where((s) => s.exerciseId == e.set.exerciseId && (s.date.isBefore(e.set.date) ||
                (s.date == e.set.date && s.setIndex < e.set.setIndex)))
            .map((s) => HistSet(s.weightKg, s.reps))
            .toList();
        expect(PrDetector.detect(weightKg: e.set.weightKg, reps: e.set.reps, history: history), e.types);
      }
    });
  });

  group('adherence', () {
    final today = DateTime(2026, 10, 20); // Tuesday
    const days = {6, 1, 3}; // Sat, Mon, Wed

    DayStatus st(DateTime d, [List<SessionLite> s = const [], DateTime? start]) =>
        dayStatus(day: d, sessions: s, trainingWeekdays: days, today: today, trackingStart: start);

    test('status rules', () {
      SessionLite s(String status, {int sets = 0}) =>
          SessionLite(id: 1, date: DateTime(2026, 10, 17), status: status, setCount: sets);
      expect(st(DateTime(2026, 10, 17), [s('completed')]), DayStatus.completed);
      expect(st(DateTime(2026, 10, 17), [s('partial')]), DayStatus.partial);
      expect(st(DateTime(2026, 10, 17), [s('in_progress', sets: 3)]), DayStatus.partial);
      expect(st(DateTime(2026, 10, 17), [s('missed'), s('completed')]), DayStatus.completed);
      expect(st(DateTime(2026, 10, 17), [s('missed')]), DayStatus.missed);
      expect(st(DateTime(2026, 10, 19)), DayStatus.missed); // Monday, nothing logged
      expect(st(DateTime(2026, 10, 18)), DayStatus.rest); // Sunday
      expect(st(DateTime(2026, 10, 21)), DayStatus.future);
      expect(st(today), DayStatus.rest); // Tuesday is a rest day
      expect(dayStatus(day: today, sessions: const [], trainingWeekdays: {2}, today: today), DayStatus.today);
      expect(st(DateTime(2026, 9, 28), const [], DateTime(2026, 10, 1)), DayStatus.none);
      expect(st(DateTime(2026, 10, 18), [s('completed')]), DayStatus.completed); // extra session on a rest day
    });

    test('summary percent counts partial as half', () {
      final s = summarizeAdherence([
        DayStatus.completed,
        DayStatus.completed,
        DayStatus.partial,
        DayStatus.missed,
        DayStatus.rest,
        DayStatus.future,
      ]);
      expect(s.planned, 4);
      expect(s.percent, closeTo(62.5, 1e-9));
      expect(const AdherenceSummary().percent, isNull);
    });

    test('month from the DB (sessions, set counts, profile training days)', () async {
      final db = memoryDb();
      addTearDown(db.close);
      await seedFortnight(db);
      final sessions = await sessionsLiteQuery(db, DateTime(2026, 10, 1), DateTime(2026, 10, 31)).get();
      expect(sessions.length, 6);
      expect(sessions.firstWhere((s) => s.date == DateTime(2026, 10, 3)).setCount, 3);
      expect(await loadTrainingWeekdays(db), {6, 1, 3});
      expect(await loadTrackingStart(db), DateTime(2026, 10, 1));
      final map = adherenceForRange(
        from: DateTime(2026, 10, 1),
        to: DateTime(2026, 10, 31),
        sessions: sessions,
        trainingWeekdays: await loadTrainingWeekdays(db),
        today: today,
        trackingStart: await loadTrackingStart(db),
      );
      expect(map[DateTime(2026, 10, 3)], DayStatus.completed);
      expect(map[DateTime(2026, 10, 7)], DayStatus.partial);
      expect(map[DateTime(2026, 10, 12)], DayStatus.missed);
      expect(map[DateTime(2026, 10, 14)], DayStatus.missed);
      expect(map[DateTime(2026, 10, 19)], DayStatus.missed);
      expect(map[DateTime(2026, 10, 2)], DayStatus.rest);
      expect(map[DateTime(2026, 10, 24)], DayStatus.future);
      final sum = summarizeAdherence(map.values);
      expect((sum.completed, sum.partial, sum.missed), (4, 1, 3));
    });

    test('training days fall back to the active plan when the profile has none', () async {
      final db = memoryDb();
      addTearDown(db.close);
      await seedProfile(db, createdAt: DateTime(2026, 10, 1), trainingDays: '[]');
      final plan = await db.into(db.workoutPlans).insert(WorkoutPlansCompanion.insert(name: 'P', isActive: const Value(true)));
      await db.into(db.planDays).insert(PlanDaysCompanion.insert(planId: plan, name: 'A', weekday: const Value(2)));
      await db.into(db.planDays).insert(
          PlanDaysCompanion.insert(planId: plan, name: 'Rest', weekday: const Value(4), isRest: const Value(true)));
      expect(await loadTrainingWeekdays(db), {2});
    });
  });

  group('body, nutrition, sleep', () {
    test('daily weight keeps the last entry of the day + 7-day average', () {
      BodyMetric m(DateTime d, double? w, {double? waist}) =>
          BodyMetric(id: 0, date: d, weightKg: w, waistCm: waist);
      final daily = dailyWeights([
        m(DateTime(2026, 10, 1, 7), 80),
        m(DateTime(2026, 10, 1, 21), 81),
        m(DateTime(2026, 10, 2, 7), null, waist: 84),
        m(DateTime(2026, 10, 3, 7), 79),
      ]);
      expect(daily.map((d) => (d.date, d.value)), [(DateTime(2026, 10, 1), 81.0), (DateTime(2026, 10, 3), 79.0)]);
      expect(Stats.movingAverage(daily).last.value, 80);
      final ms = measurementSeries([m(DateTime(2026, 10, 2, 7), null, waist: 84)]);
      expect(ms.keys, [MeasureKind.waist]);
    });

    test('nutrition per day skips pending AI logs and uses profile targets', () async {
      final db = memoryDb();
      addTearDown(db.close);
      await seedFortnight(db);
      final logs = await db.select(db.mealLogs).get();
      final profile = await (db.select(db.userProfiles)).getSingle();
      final days = nutritionByDay(logs, profile);
      expect(days.length, 3);
      expect(days.last.calories, 2300);
      expect(days.last.protein, 150);
      expect(days.last.calorieTarget, 2500);
      expect(days.last.proteinTarget, 160);
    });

    test('sleep hours joined with recovery', () {
      final s = sleepByDay(
        [
          SleepLog(id: 1, date: DateTime(2026, 10, 1), durationMin: 420, source: 'manual'),
          SleepLog(id: 2, date: DateTime(2026, 10, 1), durationMin: 60, source: 'manual'), // nap
        ],
        [HealthDailyData(id: 1, date: DateTime(2026, 10, 2), recoveryScore: 55, sourcesJson: '[]')],
      );
      expect(s.length, 2);
      expect(s.first.hours, 8);
      expect(s.first.recovery, isNull);
      expect(s.last.hours, isNull);
      expect(s.last.recovery, 55);
    });
  });

  group('DB-backed loaders and providers', () {
    test('day details gather sessions, sets, meals, water, sleep, weight', () async {
      final db = memoryDb();
      addTearDown(db.close);
      await seedFortnight(db);
      final d = await loadDayDetails(db, DateTime(2026, 10, 10), now: DateTime(2026, 10, 20));
      expect(d.status, DayStatus.completed);
      expect(d.sessions.single.exercises.single.sets.length, 2);
      expect(d.sessions.single.volume, 82.5 * 8 + 80 * 9);
      expect(d.calories, 2300);
      expect(d.mealCount, 2);
      expect(d.waterMl, 1250);
      expect(d.sleepHours, 7);
      expect(d.sleepQuality, 4);
      expect(d.recovery, 72);
      expect(d.weightKg, 79.4);
      final empty = await loadDayDetails(db, DateTime(2026, 10, 2), now: DateTime(2026, 10, 20));
      expect(empty.isEmpty, isTrue);
      expect(empty.status, DayStatus.rest);
    });

    test('providers read the overridden DB', () async {
      final db = memoryDb();
      addTearDown(db.close);
      await seedFortnight(db);
      final c = ProviderContainer(overrides: [databaseProvider.overrideWithValue(db)]);
      addTearDown(c.dispose);
      c.read(progressPeriodProvider.notifier).set(ProgressPeriod.all);

      final prs = await c.read(prListProvider.future);
      expect(prs.map((p) => p.prs.exerciseId), ['squat', 'bench', 'row']);
      expect(prs[1].exercise?.nameAr, 'بنش برس بالبار');
      expect(prs[1].prs.heaviest.weightKg, 82.5);

      final logged = await c.read(loggedExercisesProvider.future);
      expect(logged.first.exercise.id, 'squat');
      expect(logged.firstWhere((e) => e.exercise.id == 'bench').sets, 5);

      final rows = await c.read(periodSetRowsProvider.future);
      expect(rows.length, 9);
      final vol = c.read(muscleVolumeProvider);
      expect(vol.requireValue.muscles.map((m) => m.muscle), contains('chest'));

      final month = await c.read(monthAdherenceProvider(DateTime(2026, 10)).future);
      expect(month.days.length, 31);
      expect(month.days[DateTime(2026, 10, 3)], DayStatus.completed);

      final series = await c.read(exerciseProgressProvider('bench').future);
      expect(series.length, 2);
    });
  });
}
