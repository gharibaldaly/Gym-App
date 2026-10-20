import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:ironmind/ai/ai_service.dart';
import 'package:ironmind/core/providers.dart';
import 'package:ironmind/features/coach/coach_initiatives.dart';
import 'package:ironmind/features/coach/coach_repository.dart';

import 'coach_fake_ai.dart';
import 'coach_fixtures.dart';

CoachMessage m(int id, String kind, DateTime at, {String role = 'assistant'}) =>
    CoachMessage(id: id, role: role, content: 'x$id', kind: kind, isRead: false, createdAt: at);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('morning due', () {
    test('after wake time, once per day', () {
      final now = DateTime(2026, 10, 20, 7, 30);
      expect(isMorningDue(now: now, wakeTime: '07:00', lastSent: null), isTrue);
      expect(isMorningDue(now: now, wakeTime: '08:00', lastSent: null), isFalse);
      expect(isMorningDue(now: now, wakeTime: '07:00', lastSent: '2026-10-20'), isFalse);
      expect(isMorningDue(now: now, wakeTime: '07:00', lastSent: '2026-10-19'), isTrue);
    });
    test('defaults to 07:00 for missing/invalid wake time', () {
      expect(isMorningDue(now: DateTime(2026, 10, 20, 6, 59), wakeTime: null, lastSent: null), isFalse);
      expect(isMorningDue(now: DateTime(2026, 10, 20, 7), wakeTime: 'bad', lastSent: null), isTrue);
    });
  });

  group('weekly due', () {
    test('Friday 18:00 or first check after', () {
      // Tuesday → last Friday's report is due if not sent.
      expect(dueWeeklyReportEnd(now: DateTime(2026, 10, 20, 10), lastSent: null), DateTime(2026, 10, 16));
      expect(dueWeeklyReportEnd(now: DateTime(2026, 10, 20, 10), lastSent: '2026-10-16'), isNull);
      // Friday before 18:00 → still the previous week.
      expect(dueWeeklyReportEnd(now: DateTime(2026, 10, 23, 17, 59), lastSent: '2026-10-16'), isNull);
      // Friday evening → this week.
      expect(dueWeeklyReportEnd(now: DateTime(2026, 10, 23, 18), lastSent: '2026-10-16'), DateTime(2026, 10, 23));
      // Saturday after an unsent Friday.
      expect(dueWeeklyReportEnd(now: DateTime(2026, 10, 24, 9), lastSent: '2026-10-16'), DateTime(2026, 10, 23));
    });
  });

  test('recovery proposal rule', () {
    bool r(int? s, {bool training = true, bool already = false, bool done = false}) => shouldProposeRecoveryAdjust(
        recoveryScore: s, isTrainingDay: training, alreadyProposed: already, sessionDone: done);
    expect(r(35), isTrue);
    expect(r(40), isFalse);
    expect(r(null), isFalse);
    expect(r(20, training: false), isFalse);
    expect(r(20, already: true), isFalse);
    expect(r(20, done: true), isFalse);
  });

  test('latest message prefers today\'s morning message', () {
    final list = [
      m(5, 'workout_summary', DateTime(2026, 10, 20, 9)),
      m(4, 'offline_notice', DateTime(2026, 10, 20, 8)),
      m(3, 'morning', DateTime(2026, 10, 20, 7)),
      m(2, 'morning', DateTime(2026, 10, 19, 7)),
    ];
    expect(pickLatestCoachMessage(list, testNow)!.id, 3);
    expect(pickLatestCoachMessage(list.sublist(0, 2), testNow)!.id, 5);
    expect(pickLatestCoachMessage([list[3], list[1]], testNow)!.id, 2);
    expect(pickLatestCoachMessage([list[1]], testNow), isNull);
  });

  test('plainPreview strips markdown', () {
    expect(plainPreview('**Push A** today\n- Bench 80x8\n- Fly'), 'Push A today • Bench 80x8 • Fly');
    expect(plainPreview('a' * 300).length, 180);
  });

  group('with container', () {
    late CoachFixture f;
    setUp(() async => f = await seedCoachDb());
    tearDown(() => f.db.close());

    test('low recovery on a training day → one proposal + message', () async {
      final (c, _, _) = await coachContainer(f.db);
      addTearDown(c.dispose);
      await f.db.into(f.db.healthDaily).insert(HealthDailyCompanion.insert(
            date: DateTime(2026, 10, 20),
            recoveryScore: const Value(32),
          ));
      final ini = c.read(coachInitiativesProvider);
      await ini.checkRecovery();
      await ini.checkRecovery();
      final ps = await f.db.select(f.db.coachProposals).get();
      expect(ps, hasLength(1));
      expect(ps.single.type, 'recovery_adjust');
      expect(ps.single.payload, containsPair('date', '2026-10-20'));
      expect(ps.single.payload, containsPair('weightFactor', 0.9));
      final msgs = await f.db.select(f.db.coachMessages).get();
      expect(msgs.single.kind, 'recovery');
      expect(msgs.single.content, contains('32/100'));
      expect(ps.single.messageId, msgs.single.id);
    });

    test('morning check: no key → not marked; with key → marked + job queued once', () async {
      final (c, ai, prefs) = await coachContainer(f.db);
      addTearDown(c.dispose);
      ai.keyPresent = false;
      final ini = c.read(coachInitiativesProvider);
      await ini.checkMorning();
      expect(prefs.getString(SettingsKeys.lastMorningMessage), isNull);
      ai.keyPresent = true;
      await ini.checkMorning();
      await ini.checkMorning();
      expect(prefs.getString(SettingsKeys.lastMorningMessage), '2026-10-20');
      final jobs = await (f.db.select(f.db.aiQueue)..where((q) => q.feature.equals(CoachJobs.morning))).get();
      expect(jobs, hasLength(1));
    });

    test('morning job writes a morning message (skips stale dates)', () async {
      final (c, ai, _) = await coachContainer(f.db);
      addTearDown(c.dispose);
      ai.textReply = '**Push A** النهارده. بنش 80×8.';
      final ini = c.read(coachInitiativesProvider);
      await ini.runMorningJob({'date': '2026-10-19'});
      expect(await f.db.select(f.db.coachMessages).get(), isEmpty);
      await ini.runMorningJob({'date': '2026-10-20'});
      await ini.runMorningJob({'date': '2026-10-20'}); // idempotent
      final msgs = await f.db.select(f.db.coachMessages).get();
      expect(msgs.single.kind, 'morning');
      expect(ai.features.single, AiFeature.morningMessage);
      expect(ai.prompts.single, contains('Push A'));
      final sub = c.listen(latestCoachMessageProvider, (_, _) {});
      addTearDown(sub.close);
      final latest = await c.read(latestCoachMessageProvider.future);
      expect(latest!.kind, 'morning');
    });

    test('weekly check marks empty weeks without AI, queues weeks with data', () async {
      final empty = await seedCoachDb(withLogs: false);
      addTearDown(empty.db.close);
      final (c1, _, prefs1) = await coachContainer(empty.db);
      addTearDown(c1.dispose);
      await c1.read(coachInitiativesProvider).checkWeekly();
      expect(prefs1.getString(SettingsKeys.lastWeeklyReport), '2026-10-16');
      expect(await empty.db.select(empty.db.aiQueue).get(), isEmpty);

      final (c2, _, prefs2) = await coachContainer(f.db);
      addTearDown(c2.dispose);
      await c2.read(coachInitiativesProvider).checkWeekly();
      expect(prefs2.getString(SettingsKeys.lastWeeklyReport), '2026-10-16');
      final jobs = await f.db.select(f.db.aiQueue).get();
      expect(jobs.single.feature, CoachJobs.weekly);
      expect(jobs.single.payloadJson, '{"weekEnd":"2026-10-16"}');
    });

    test('weekly job uses Opus feature and stores kind weekly once', () async {
      final (c, ai, _) = await coachContainer(f.db);
      addTearDown(c.dispose);
      ai.textReply = '**Training** ...';
      final ini = c.read(coachInitiativesProvider);
      await ini.runWeeklyJob({'weekEnd': '2026-10-16'});
      await ini.runWeeklyJob({'weekEnd': '2026-10-16'});
      final msgs = await f.db.select(f.db.coachMessages).get();
      expect(msgs.single.kind, 'weekly');
      expect(msgs.single.meta['weekStart'], '2026-10-10');
      expect(ai.features, [AiFeature.weeklyReport]);
      expect(ai.prompts.single, contains('Adherence: planned'));
    });

    test('workout summary job writes aiSummary + message with local targets in prompt', () async {
      final (c, ai, _) = await coachContainer(f.db);
      addTearDown(c.dispose);
      ai.textReply = 'تحسن البنش.';
      final session = await (f.db.select(f.db.workoutSessions)..where((s) => s.date.equals(DateTime(2026, 10, 15))))
          .getSingle();
      await c.read(coachInitiativesProvider).runWorkoutSummaryJob({'sessionId': session.id});
      final updated = await (f.db.select(f.db.workoutSessions)..where((s) => s.id.equals(session.id))).getSingle();
      expect(updated.aiSummary, 'تحسن البنش.');
      final msg = (await f.db.select(f.db.coachMessages).get()).single;
      expect(msg.kind, 'workout_summary');
      expect(msg.meta['sessionId'], session.id);
      expect(ai.prompts.single, contains('local next target'));
      expect(ai.prompts.single, contains('previous 2026-10-06'));
      // Second run is a no-op (summary exists).
      await c.read(coachInitiativesProvider).runWorkoutSummaryJob({'sessionId': session.id});
      expect(ai.prompts, hasLength(1));
    });

    test('plateau detection + explainPlateau queues once', () async {
      final (c, ai, _) = await coachContainer(f.db);
      addTearDown(c.dispose);
      ai.keyPresent = false; // keep the job pending
      // Squat: best e1RM first, then three sessions without improvement.
      var lastId = 0;
      for (final (day, w, r) in [(1, 100.0, 6), (3, 100.0, 5), (5, 97.5, 6), (8, 100.0, 5)]) {
        lastId = await f.db.into(f.db.workoutSessions).insert(WorkoutSessionsCompanion.insert(
              date: DateTime(2026, 9, day),
              status: const Value('completed'),
            ));
        await f.db.into(f.db.setLogs).insert(SetLogsCompanion.insert(
              sessionId: lastId,
              exerciseId: 'Barbell_Squat',
              setIndex: 0,
              weightKg: w,
              reps: r,
            ));
      }
      final ini = c.read(coachInitiativesProvider);
      expect(await ini.detectPlateaus(lastId), ['Barbell_Squat']);
      await ini.onWorkoutFinished(lastId);
      await ini.explainPlateau('Barbell_Squat');
      final jobs = await f.db.select(f.db.aiQueue).get();
      expect(jobs.where((j) => j.feature == CoachJobs.plateau), hasLength(1));
      expect(jobs.where((j) => j.feature == CoachJobs.workoutSummary), hasLength(1));
    });

    test('plateau job: message + optional swap proposal for plan exercise', () async {
      final (c, ai, _) = await coachContainer(f.db);
      addTearDown(c.dispose);
      for (final (day, w) in [(1, 82.5), (3, 80.0), (5, 80.0), (8, 80.0)]) {
        final id = await f.db.into(f.db.workoutSessions).insert(WorkoutSessionsCompanion.insert(
              date: DateTime(2026, 9, day),
              status: const Value('completed'),
            ));
        await f.db.into(f.db.setLogs).insert(SetLogsCompanion.insert(
              sessionId: id,
              exerciseId: 'Barbell_Bench_Press',
              setIndex: 0,
              weightKg: w,
              reps: 8,
            ));
      }
      ai.structuredReply = {'message': 'غيّر للدمبل.', 'swapToExerciseId': 'Dumbbell_Bench_Press'};
      await c.read(coachInitiativesProvider).runPlateauJob({'exerciseId': 'Barbell_Bench_Press'});
      final msg = (await f.db.select(f.db.coachMessages).get()).single;
      expect(msg.kind, 'plateau');
      expect(ai.features.single, AiFeature.plateau);
      final p = (await f.db.select(f.db.coachProposals).get()).single;
      expect(p.type, 'swap_exercise');
      expect(p.messageId, msg.id);
      expect(p.payload['planExerciseId'], f.benchPeId);
      expect(p.payload['scope'], 'always');
    });

    test('runScheduledChecks never throws', () async {
      final (c, ai, _) = await coachContainer(f.db);
      addTearDown(c.dispose);
      ai.keyPresent = false;
      await expectLater(c.read(coachInitiativesProvider).runScheduledChecks(), completes);
    });
  });
}
