import 'package:flutter_test/flutter_test.dart';
import 'package:ironmind/ai/ai_service.dart';
import 'package:ironmind/core/providers.dart';
import 'package:ironmind/features/coach/coach_chat_controller.dart';
import 'package:ironmind/features/coach/coach_repository.dart';

import 'coach_fake_ai.dart';
import 'coach_fixtures.dart';

CoachMessage msg(int id, String role, String content, {String kind = 'chat'}) => CoachMessage(
      id: id,
      role: role,
      content: content,
      kind: kind,
      isRead: true,
      createdAt: testNow,
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('buildChatHistory', () {
    test('skips offline notices, merges same-role turns, starts with user', () {
      final h = buildChatHistory([
        msg(1, 'assistant', 'صباح الخير', kind: 'morning'),
        msg(2, 'user', 'ازيك'),
        msg(3, 'assistant', 'مفيش نت', kind: 'offline_notice'),
        msg(4, 'user', 'رد عليا'),
        msg(5, 'assistant', 'تمام'),
      ]);
      expect(h.map((m) => m['role']), ['user', 'assistant', 'user', 'assistant']);
      expect(h[1]['content'], '[morning message]\nصباح الخير');
      expect(h[2]['content'], 'ازيك\n\nرد عليا');
    });

    test('sanitizeAssistantContent keeps API blocks intact', () {
      final blocks = [
        {'type': 'thinking', 'thinking': '', 'signature': 'abc'},
        {'type': 'tool_use', 'id': 't', 'name': 'x', 'input': {}, '_invalid_json': true},
      ];
      expect(sanitizeAssistantContent(blocks), [
        {'type': 'thinking', 'thinking': '', 'signature': 'abc'},
        {'type': 'tool_use', 'id': 't', 'name': 'x', 'input': {}},
      ]);
    });
  });

  test('tool loop: runs all tools, returns one user message with all results, persists reply', () async {
    final f = await seedCoachDb();
    addTearDown(f.db.close);
    final (c, ai, _) = await coachContainer(f.db);
    addTearDown(c.dispose);

    final firstContent = [
      {'type': 'thinking', 'thinking': '', 'signature': 'sig-1'},
      {'type': 'text', 'text': 'هسجلهولك'},
      {
        'type': 'tool_use',
        'id': 'tu_1',
        'name': 'log_meal',
        'input': {
          'name': 'فطار',
          'items': [
            {'name': 'فول', 'grams': 200, 'calories': 220, 'protein': 14, 'carbs': 30, 'fat': 5},
          ],
        },
      },
      {
        'type': 'tool_use',
        'id': 'tu_2',
        'name': 'save_memory',
        'input': {'fact': 'بيفطر فول كل يوم'},
      },
    ];
    ai.streams
      ..add([TextDelta('هسجلهولك'), StreamDone(response(firstContent, 'tool_use'))])
      ..add([
        TextDelta('مستني موافقتك.'),
        StreamDone(response([
          {'type': 'text', 'text': 'مستني موافقتك.'}
        ], 'end_turn')),
      ]);

    await c.read(coachChatProvider.notifier).send('فطرت طبق فول');

    expect(ai.bodies, hasLength(2));
    expect(ai.features, everyElement(AiFeature.chat));
    final first = ai.bodies.first;
    expect(first['tool_choice'], {'type': 'auto'});
    expect((first['tools'] as List).map((t) => t['name']), contains('log_meal'));
    expect((first['system'] as List).first['cache_control'], {'type': 'ephemeral'});
    expect((first['messages'] as List).last, {'role': 'user', 'content': 'فطرت طبق فول'});

    final second = ai.bodies[1]['messages'] as List;
    // Assistant content echoed unchanged (thinking signature included).
    expect(second[second.length - 2], {'role': 'assistant', 'content': firstContent});
    final results = second.last as Map;
    expect(results['role'], 'user');
    expect((results['content'] as List).map((b) => b['tool_use_id']), ['tu_1', 'tu_2']);
    expect((results['content'] as List).every((b) => b['type'] == 'tool_result'), isTrue);

    final messages = await CoachRepository(f.db).recentMessages(10);
    expect(messages.map((m) => m.role), ['user', 'assistant']);
    expect(messages.last.content, 'هسجلهولك\n\nمستني موافقتك.');
    final proposals = await f.db.select(f.db.coachProposals).get();
    expect(proposals, hasLength(1));
    expect(proposals.single.type, 'log_meal');
    expect(proposals.single.status, 'pending');
    expect(proposals.single.messageId, messages.last.id);
    final mems = await f.db.select(f.db.coachMemories).get();
    expect(mems.map((m) => m.content), contains('بيفطر فول كل يوم'));
    // No meal logged until approval.
    expect(await (f.db.select(f.db.mealLogs)..where((m) => m.name.equals('فطار'))).get(), isEmpty);
    expect(c.read(coachChatProvider).sending, isFalse);
  });

  test('offline: user message saved + clear "no internet" notice, no request', () async {
    final f = await seedCoachDb(withLogs: false);
    addTearDown(f.db.close);
    final (c, ai, _) = await coachContainer(f.db, online: false);
    addTearDown(c.dispose);
    await c.read(coachChatProvider.notifier).send('ازيك');
    expect(ai.bodies, isEmpty);
    final messages = await CoachRepository(f.db).recentMessages(10);
    expect(messages.map((m) => m.kind), ['chat', 'offline_notice']);
    expect(messages.last.content, contains('مفيش نت'));
  });

  test('no key: error state, history still stored', () async {
    final f = await seedCoachDb(withLogs: false);
    addTearDown(f.db.close);
    final (c, ai, _) = await coachContainer(f.db);
    addTearDown(c.dispose);
    ai.keyPresent = false;
    await c.read(coachChatProvider.notifier).send('ازيك');
    expect(c.read(coachChatProvider).error, isNotNull);
    expect((await CoachRepository(f.db).recentMessages(10)).single.role, 'user');
  });
}
