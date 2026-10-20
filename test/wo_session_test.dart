import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:ironmind/core/calc/progression.dart';
import 'package:ironmind/core/calc/strength_calc.dart';
import 'package:ironmind/core/providers.dart';
import 'package:ironmind/data/repositories/exercise_repository.dart';
import 'package:ironmind/features/workout/deload.dart';
import 'package:ironmind/features/workout/post_workout.dart';
import 'package:ironmind/features/workout/today_workout_provider.dart';
import 'package:ironmind/features/workout/workout_logic.dart';
import 'package:ironmind/features/workout/workout_maintenance.dart';
import 'package:ironmind/features/workout/workout_repository.dart';
import 'package:ironmind/features/workout/workout_suggestions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'wo_helpers.dart';

/// Plan with training days Mon/Wed/Sat, one exercise each.
Future<int> _plan(WorkoutRepository repo, {DateTime? activatedAt, int deloadEvery = 5}) async {
  final id = await repo.savePlanJson({
    'name': 'Test',
    'notes': '',
    'deloadEveryWeeks': deloadEvery,
    'days': [
      for (final wd in [1, 3, 6])
        {
          'weekday': wd,
          'name': 'Day $wd',
          'focus': '',
          'warmup': ['w'],
          'cooldown': ['c'],
          'exercises': [
            {
              'exerciseId': 'Barbell_Bench_Press_-_Medium_Grip',
              'sets': 3,
              'repMin': 8,
              'repMax': 10,
              'suggestedWeightKg': 60,
              'targetRpe': 8,
              'restSeconds': 120,
              'notes': null,
            },
          ],
        },
    ],
  });
  await repo.approvePlan(id);
  if (activatedAt != null) {
    await (repo.db.update(repo.db.workoutPlans)..where((t) => t.id.equals(id)))
        .write(WorkoutPlansCompanion(activatedAt: Value(activatedAt)));
  }
  return id;
}

Future<int> _session(AppDatabase db, DateTime day, List<(double, int)> sets, {String ex = 'Barbell_Bench_Press_-_Medium_Grip'}) async {
  final sid = await db.into(db.workoutSessions).insert(WorkoutSessionsCompanion.insert(
        date: DateTime(day.year, day.month, day.day),
        startedAt: Value(day),
        status: const Value('completed'),
      ));
  for (var i = 0; i < sets.length; i++) {
    await db.into(db.setLogs).insert(SetLogsCompanion.insert(
          sessionId: sid,
          exerciseId: ex,
          setIndex: i,
          weightKg: sets[i].$1,
          reps: sets[i].$2,
        ));
  }
  return sid;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late WorkoutRepository repo;
  late SharedPreferences prefs;

  setUp(() async {
    db = await woTestDb();
    repo = WorkoutRepository(db);
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });
  tearDown(() => db.close());

  group('markMissedDays', () {
    test('inserts missed sessions for past training days only, idempotently', () async {
      await _plan(repo, activatedAt: DateTime(2026, 10, 5, 18)); // Monday
      await _session(db, DateTime(2026, 10, 7, 19), [(60, 10)]); // Wed trained
      final now = DateTime(2026, 10, 19, 9); // Monday
      await markMissedDays(db, now: now);
      await markMissedDays(db, now: now);
      final missed = await (db.select(db.workoutSessions)..where((t) => t.status.equals('missed'))).get();
      expect(missed.map((s) => s.date), [DateTime(2026, 10, 10), DateTime(2026, 10, 12), DateTime(2026, 10, 14), DateTime(2026, 10, 17)]);
      expect(missed.every((s) => s.planDayId != null && s.name != null), isTrue);
    });

    test('no active plan → nothing happens', () async {
      await markMissedDays(db, now: DateTime(2026, 10, 19));
      expect(await db.select(db.workoutSessions).get(), isEmpty);
    });
  });

  group('sets, PRs and suggestions', () {
    test('addSet detects PRs vs all previous working sets (warm-ups ignored)', () async {
      await _session(db, DateTime(2026, 10, 10, 18), [(80, 8), (80, 8)]);
      final sid = await repo.startSession();
      final warm = await repo.addSet(sessionId: sid, exerciseId: 'Barbell_Bench_Press_-_Medium_Grip', weightKg: 100, reps: 1, setType: SetType.warmup);
      expect(warm.prs, isEmpty);
      final r1 = await repo.addSet(sessionId: sid, exerciseId: 'Barbell_Bench_Press_-_Medium_Grip', weightKg: 80, reps: 10);
      expect(r1.prs, {PrType.reps, PrType.e1rm});
      final r2 = await repo.addSet(sessionId: sid, exerciseId: 'Barbell_Bench_Press_-_Medium_Grip', weightKg: 80, reps: 10);
      expect(r2.prs, isEmpty);
      final r3 = await repo.addSet(sessionId: sid, exerciseId: 'Barbell_Bench_Press_-_Medium_Grip', weightKg: 85, reps: 6);
      expect(r3.prs, contains(PrType.weight));
      final rows = await repo.sessionSets(sid);
      expect(rows.map((s) => s.setIndex), [0, 1, 2, 3]);
      expect(rows[1].isPr, isTrue);
      expect(rows[1].prTypes, 'reps,e1rm');
    });

    test('suggestion integration: last session at top of range → +2.5 kg', () async {
      final pid = await _plan(repo);
      await _session(db, DateTime(2026, 10, 10, 18), [(60, 10), (60, 10), (60, 10)]);
      final day = (await repo.days(pid)).firstWhere((d) => d.weekday == 1);
      final item = (await repo.dayExercises(day.id)).single;
      final t = await computeExerciseTarget(repo: repo, prefs: prefs, ex: item.ex, pe: item.pe, now: DateTime(2026, 10, 12));
      expect(t.sets, 3);
      expect(t.increment, 2.5);
      expect(t.lastSets.length, 3);
      expect(t.suggestions.map((s) => s.weightKg), [62.5, 62.5, 62.5]);
      expect(t.suggestions.first.reason, ProgressionReason.increaseWeight);
    });

    test('suggestion integration honors deload week and recovery adjustment', () async {
      final pid = await _plan(repo);
      await _session(db, DateTime(2026, 10, 10, 18), [(100, 9), (100, 9), (100, 8)]);
      final day = (await repo.days(pid)).firstWhere((d) => d.weekday == 1);
      final item = (await repo.dayExercises(day.id)).single;
      final now = DateTime(2026, 10, 12, 18);
      await prefs.setString(recoveryAdjustKey(now), '{"weightFactor":0.9,"setsDelta":-1}');
      var t = await computeExerciseTarget(repo: repo, prefs: prefs, ex: item.ex, pe: item.pe, now: now);
      expect(t.sets, 2);
      expect(t.suggestions.first.weightKg, 90);
      await prefs.remove(recoveryAdjustKey(now));
      await prefs.setString(deloadWeekStartKey, '2026-10-10');
      t = await computeExerciseTarget(repo: repo, prefs: prefs, ex: item.ex, pe: item.pe, now: now);
      expect(t.deload, isTrue);
      expect(t.suggestions.first.weightKg, 85);
    });

    test('first time uses the plan weight', () async {
      final pid = await _plan(repo);
      final day = (await repo.days(pid)).firstWhere((d) => d.weekday == 3);
      final item = (await repo.dayExercises(day.id)).single;
      final t = await computeExerciseTarget(repo: repo, prefs: prefs, ex: item.ex, pe: item.pe);
      expect(t.lastSets, isEmpty);
      expect(t.suggestions.first.weightKg, 60);
      expect(t.suggestions.first.reason, ProgressionReason.firstTime);
    });

    test('pastSessions excludes the current session and groups by session', () async {
      await _session(db, DateTime(2026, 10, 3, 18), [(70, 8)]);
      await _session(db, DateTime(2026, 10, 10, 18), [(75, 8), (75, 7)]);
      final current = await _session(db, DateTime(2026, 10, 12, 18), [(80, 5)]);
      final past = await repo.pastSessions('Barbell_Bench_Press_-_Medium_Grip', excludeSessionId: current);
      expect(past.length, 2);
      expect(past.first.sets.map((s) => s.weightKg), [75, 75]);
      expect(past.last.sets.single.weightKg, 70);
    });
  });

  group('finish + comparisons', () {
    test('finishSession stores status and volume; comparison vs last time', () async {
      await _session(db, DateTime(2026, 10, 10, 18), [(80, 8), (80, 8)]);
      final sid = await repo.startSession();
      await repo.addSet(sessionId: sid, exerciseId: 'Barbell_Bench_Press_-_Medium_Grip', weightKg: 40, reps: 10, setType: SetType.warmup);
      await repo.addSet(sessionId: sid, exerciseId: 'Barbell_Bench_Press_-_Medium_Grip', weightKg: 82.5, reps: 8);
      final sets = await repo.sessionSets(sid);
      final vol = sessionVolume(sets.map((s) => (weight: s.weightKg, reps: s.reps, setType: s.setType)));
      expect(vol, 660);
      final status = computeSessionStatus([(planned: 3, done: 1)], anythingLogged: true);
      await repo.finishSession(sid, status: status, volume: vol, notes: ' felt good ');
      final s = (await repo.session(sid))!;
      expect(s.status, SessionStatus.partial);
      expect(s.totalVolume, 660);
      expect(s.notes, 'felt good');
      expect(s.endedAt, isNotNull);
      final comps = await compareWithPrevious(repo, s);
      expect(comps.single.prevVolume, 1280);
      expect(comps.single.bestSet!.weightKg, 82.5);
      expect(comps.single.e1rmDeltaPct, greaterThan(0));
    });

    test('history query counts sets and PRs', () async {
      await _session(db, DateTime(2026, 10, 10, 18), [(80, 8)]);
      final sid = await repo.startSession();
      await repo.addSet(sessionId: sid, exerciseId: 'Barbell_Bench_Press_-_Medium_Grip', weightKg: 90, reps: 5);
      final h = await repo.watchHistory().first;
      expect(h.length, 2);
      final mine = h.firstWhere((x) => x.session.id == sid);
      expect(mine.sets, 1);
      expect(mine.prs, 1);
    });
  });

  group('today + deload', () {
    test('loadTodayWorkout returns the plan day for today and its session', () async {
      await _plan(repo);
      final monday = DateTime(2026, 10, 19, 8);
      var t = await loadTodayWorkout(repo, monday);
      expect(t.planDay?.weekday, 1);
      expect(t.isRestDay, isFalse);
      expect(t.exerciseCount, 1);
      t = await loadTodayWorkout(repo, DateTime(2026, 10, 20, 8)); // Tuesday
      expect(t.isRestDay, isTrue);
    });

    test('deload due by schedule, proposal filed once, deload week makes it inactive', () async {
      final pid = await _plan(repo, activatedAt: DateTime.now().subtract(const Duration(days: 36)), deloadEvery: 5);
      final plan = (await repo.plan(pid))!;
      var st = await computeDeloadStatus(db, plan, prefs: prefs);
      expect(st.due, isTrue);
      expect(st.reason, 'schedule');
      expect(await isDeloadDue(db, plan, prefs: prefs), isTrue);
      await ensureDeloadProposal(db, plan, st, lang: 'ar');
      await ensureDeloadProposal(db, plan, st, lang: 'ar');
      final props = await db.select(db.coachProposals).get();
      expect(props.length, 1);
      expect(props.single.type, 'deload');
      expect(props.single.status, 'pending');
      await startDeloadWeek(db, prefs);
      expect(isDeloadWeekActive(prefs), isTrue);
      st = await computeDeloadStatus(db, plan, prefs: prefs);
      expect(st.active, isTrue);
      expect(st.due, isFalse);
      expect((await db.select(db.coachProposals).getSingle()).status, 'accepted');
    });

    test('deload not due early in the cycle', () async {
      final pid = await _plan(repo, activatedAt: DateTime.now().subtract(const Duration(days: 10)));
      final st = await computeDeloadStatus(db, (await repo.plan(pid))!, prefs: prefs);
      expect(st.due, isFalse);
    });
  });

  test('plateau detection reports once per week', () async {
    // e1RM flat for 4 sessions after an initial best.
    await _session(db, DateTime(2026, 9, 1, 18), [(100, 5)]);
    for (var i = 0; i < 3; i++) {
      await _session(db, DateTime(2026, 9, 8 + i * 7, 18), [(100, 5)]);
    }
    final now = DateTime(2026, 9, 30);
    final ids = ['Barbell_Bench_Press_-_Medium_Grip'];
    expect(await detectNewPlateaus(repo, prefs, ids, now: now), ids);
    expect(await detectNewPlateaus(repo, prefs, ids, now: now.add(const Duration(days: 3))), isEmpty);
    expect(await detectNewPlateaus(repo, prefs, ids, now: now.add(const Duration(days: 8))), ids);
    // Sanity: ExerciseRepository works on the seeded DB.
    expect((await ExerciseRepository(db).byId(ids.first))?.equipment, 'barbell');
  });
}
