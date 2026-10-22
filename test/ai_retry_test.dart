import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:ironmind/ai/ai_service.dart';
import 'package:ironmind/core/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeKey extends ApiKeyNotifier {
  @override
  Future<String?> build() async => 'test-key';
}

void main() {
  late ProviderContainer container;
  late AppDatabase db;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    db = AppDatabase(NativeDatabase.memory());
    container = ProviderContainer(overrides: [
      sharedPrefsProvider.overrideWithValue(await SharedPreferences.getInstance()),
      databaseProvider.overrideWithValue(db),
      apiKeyProvider.overrideWith(_FakeKey.new),
      isOnlineProvider.overrideWithValue(true),
    ]);
  });

  tearDown(() async {
    AiService.debugHttpClientFactory = null;
    container.dispose();
    await db.close();
  });

  String okBody() => jsonEncode({
        'model': 'claude-haiku-5-5',
        'content': [
          {'type': 'text', 'text': 'OK'}
        ],
        'stop_reason': 'end_turn',
        'usage': {'input_tokens': 5, 'output_tokens': 1},
      });

  test('a dropped connection (app frozen in background) is retried', () async {
    var calls = 0;
    AiService.debugHttpClientFactory = () => MockClient((req) async {
          calls++;
          if (calls == 1) throw const SocketException('Software caused connection abort');
          return http.Response(okBody(), 200, headers: {'content-type': 'application/json'});
        });
    final text = await container.read(aiServiceProvider).text(feature: AiFeature.keyTest, prompt: 'hi');
    expect(text, 'OK');
    expect(calls, 2);
  });

  test('auth errors are not retried', () async {
    var calls = 0;
    AiService.debugHttpClientFactory = () => MockClient((req) async {
          calls++;
          return http.Response(jsonEncode({'error': {'message': 'invalid x-api-key'}}), 401);
        });
    await expectLater(
      container.read(aiServiceProvider).text(feature: AiFeature.keyTest, prompt: 'hi'),
      throwsA(isA<AiException>().having((e) => e.isAuth, 'isAuth', true)),
    );
    expect(calls, 1);
  });

  test('a stream that drops before any text is retried', () async {
    var calls = 0;
    AiService.debugHttpClientFactory = () => MockClient.streaming((req, body) async {
          calls++;
          if (calls == 1) throw const SocketException('Connection reset by peer');
          const sse = 'event: message_start\n'
              'data: {"type":"message_start","message":{"model":"claude-sonnet-5-5","usage":{"input_tokens":3}}}\n\n'
              'data: {"type":"content_block_start","index":0,"content_block":{"type":"text","text":""}}\n\n'
              'data: {"type":"content_block_delta","index":0,"delta":{"type":"text_delta","text":"Hi"}}\n\n'
              'data: {"type":"content_block_stop","index":0}\n\n'
              'data: {"type":"message_delta","delta":{"stop_reason":"end_turn"},"usage":{"output_tokens":1}}\n\n';
          return http.StreamedResponse(Stream.value(utf8.encode(sse)), 200);
        });
    final ai = container.read(aiServiceProvider);
    final events = await ai
        .stream(AiFeature.chat, ai.buildBody(feature: AiFeature.chat, messages: [
          {'role': 'user', 'content': 'hi'}
        ]))
        .toList();
    expect(events.whereType<TextDelta>().map((e) => e.text).join(), 'Hi');
    expect(events.last, isA<StreamDone>());
    expect(calls, 2);
  });
}
