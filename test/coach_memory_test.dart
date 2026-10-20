import 'package:flutter_test/flutter_test.dart';
import 'package:ironmind/ai/ai_service.dart';
import 'package:ironmind/features/coach/coach_memory.dart';
import 'package:ironmind/features/coach/coach_repository.dart';

import 'coach_fake_ai.dart';
import 'coach_fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('dedupe', () {
    test('normalizes Arabic letter forms, diacritics and punctuation', () {
      expect(normalizeFact('الكتفُ الأيسر بيوجع!'), normalizeFact('الكتف الايسر بيوجع'));
      expect(normalizeFact('  Left SHOULDER   hurts. '), 'left shoulder hurts');
    });

    test('detects near duplicates', () {
      expect(isDuplicateFact('Left shoulder hurts on overhead press', 'left shoulder hurts on the overhead press'), isTrue);
      expect(isDuplicateFact('بيتمرن في البيت بدمبل بس', 'بيتمرن في البيت بدمبل بس.'), isTrue);
      expect(isDuplicateFact('Allergic to peanuts', 'Trains at home with dumbbells'), isFalse);
      // Containment of a long fact.
      expect(isDuplicateFact('knee pain on squats', 'has knee pain on squats since 2024'), isTrue);
    });

    test('dedupeFacts filters against existing and within the batch', () {
      final out = dedupeFacts(
        ['Allergic to peanuts', 'allergic to peanuts!', 'Prefers training at night', 'ok', ''],
        ['Prefers training at night.'],
      );
      expect(out, ['Allergic to peanuts']);
    });
  });

  test('insertMemoriesDeduped only stores new facts', () async {
    final f = await seedCoachDb();
    addTearDown(f.db.close);
    final inserted = await insertMemoriesDeduped(f.db, ['الكتف الشمال بيوجع في الـ Overhead Press.', 'مبيحبش السمك']);
    expect(inserted, ['مبيحبش السمك']);
    expect((await f.db.select(f.db.coachMemories).get()).length, 2);
  });

  test('extract: Haiku feature, only new messages, advances the cursor', () async {
    final f = await seedCoachDb();
    addTearDown(f.db.close);
    final (c, ai, prefs) = await coachContainer(f.db);
    addTearDown(c.dispose);
    final repo = CoachRepository(f.db);
    await repo.addMessage(role: 'user', content: 'ركبتي اليمين بتوجعني في السكوات من سنة');
    await repo.addMessage(role: 'assistant', content: 'خف الوزن وروح لدكتور لو الألم حاد.');
    ai.structuredReply = {
      'memories': ['ركبته اليمين بتوجعه في السكوات', 'الكتف الشمال بيوجع في الـ Overhead Press'],
    };
    final svc = c.read(coachMemoryServiceProvider);
    final inserted = await svc.extract();
    expect(inserted, ['ركبته اليمين بتوجعه في السكوات']);
    expect(ai.features.single, AiFeature.memoryExtract);
    expect(ai.prompts.single, contains('ALREADY KNOWN'));
    expect(ai.prompts.single, contains('ركبتي اليمين'));
    expect(prefs.getInt(coachMemoryLastIdKey), isNotNull);

    // Nothing new → no AI call.
    expect(await svc.extract(), isEmpty);
    expect(ai.features, hasLength(1));
  });

  test('scheduleExtraction queues one job only when there are new user messages', () async {
    final f = await seedCoachDb(withLogs: false);
    addTearDown(f.db.close);
    final (c, ai, _) = await coachContainer(f.db);
    addTearDown(c.dispose);
    ai.keyPresent = false; // keep the job pending
    final svc = c.read(coachMemoryServiceProvider);
    await svc.scheduleExtraction();
    expect(await f.db.select(f.db.aiQueue).get(), isEmpty);
    await CoachRepository(f.db).addMessage(role: 'user', content: 'hi');
    await svc.scheduleExtraction();
    await svc.scheduleExtraction();
    final jobs = await f.db.select(f.db.aiQueue).get();
    expect(jobs.single.feature, coachMemoryJob);
  });
}
