import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:ironmind/ai/ai_retry.dart';
import 'package:ironmind/ai/claude_client.dart';

AiRetry _retry({int max = 4}) => AiRetry(maxAttempts: max, backoff: const [], waitUntilUsable: () async {});

String _okBody(String text) => jsonEncode({
      'model': 'm',
      'content': [
        {'type': 'text', 'text': text}
      ],
      'stop_reason': 'end_turn',
      'usage': {'input_tokens': 1, 'output_tokens': 1},
    });

void main() {
  group('AiRetry.shouldRetry', () {
    test('retries dropped connections and temporary server errors', () {
      expect(AiRetry.shouldRetry(AiNetworkException('x')), isTrue);
      expect(AiRetry.shouldRetry(AiException('busy', statusCode: 429)), isTrue);
      expect(AiRetry.shouldRetry(AiException('overloaded', statusCode: 529)), isTrue);
      expect(AiRetry.shouldRetry(AiException('server', statusCode: 500)), isTrue);
    });

    test('does not retry errors a retry cannot fix', () {
      expect(AiRetry.shouldRetry(AiException('bad request', statusCode: 400)), isFalse);
      expect(AiRetry.shouldRetry(AiException('auth', statusCode: 401)), isFalse);
      expect(AiRetry.shouldRetry(AiException('Request timed out')), isFalse);
      expect(AiRetry.shouldRetry(AiOfflineException()), isFalse);
      expect(AiRetry.shouldRetry(AiNoKeyException()), isFalse);
      expect(AiRetry.shouldRetry(StateError('bug')), isFalse);
    });
  });

  group('AiRetry.run', () {
    test('succeeds after the connection drops twice', () async {
      var calls = 0;
      final r = await _retry().run(() async {
        calls++;
        if (calls < 3) throw AiNetworkException('Software caused connection abort');
        return 'ok';
      });
      expect(r, 'ok');
      expect(calls, 3);
    });

    test('gives up after maxAttempts and rethrows the last error', () async {
      var calls = 0;
      await expectLater(
        _retry(max: 3).run<String>(() async {
          calls++;
          throw AiNetworkException('down');
        }),
        throwsA(isA<AiNetworkException>()),
      );
      expect(calls, 3);
    });

    test('rethrows non-retryable errors immediately', () async {
      var calls = 0;
      await expectLater(
        _retry().run<String>(() async {
          calls++;
          throw AiException('bad', statusCode: 400);
        }),
        throwsA(isA<AiException>().having((e) => e.statusCode, 'statusCode', 400)),
      );
      expect(calls, 1);
    });

    test('waits until usable before each retry', () async {
      var waits = 0;
      var calls = 0;
      final retry = AiRetry(backoff: const [], waitUntilUsable: () async => waits++);
      await retry.run(() async {
        if (++calls < 2) throw AiNetworkException('x');
        return 1;
      });
      expect(waits, 1);
    });
  });

  group('ClaudeClient transport errors', () {
    test('a socket error on send is a retryable network error', () async {
      final client = ClaudeClient('k', httpClient: MockClient((_) => throw const SocketException('abort')));
      await expectLater(client.create({'model': 'm'}), throwsA(isA<AiNetworkException>()));
    });

    test('a successful response still parses', () async {
      final client = ClaudeClient('k', httpClient: MockClient((_) async => http.Response(_okBody('hi'), 200)));
      final res = await client.create({'model': 'm'});
      expect(res.text, 'hi');
    });

    test('a connection dropped mid-stream is a retryable network error', () async {
      final client = ClaudeClient('k', httpClient: MockClient.streaming((req, _) async {
        final body = StreamController<List<int>>();
        body.add(utf8.encode('data: {"type":"message_start","message":{"model":"m","usage":{}}}\n'));
        body.add(utf8.encode('data: {"type":"content_block_start","index":0,"content_block":{"type":"text","text":""}}\n'));
        body.add(utf8.encode('data: {"type":"content_block_delta","index":0,"delta":{"type":"text_delta","text":"Hel"}}\n'));
        body.addError(http.ClientException('Connection closed while receiving data'));
        unawaited(body.close());
        return http.StreamedResponse(body.stream, 200);
      }));
      final events = <ClaudeStreamEvent>[];
      await expectLater(
        client.stream({'model': 'm'}).forEach(events.add),
        throwsA(isA<AiNetworkException>()),
      );
      expect(events.whereType<TextDelta>().map((e) => e.text), ['Hel']);
    });

    test('a silent stream times out as a dropped connection', () async {
      final client = ClaudeClient(
        'k',
        streamIdleTimeout: const Duration(milliseconds: 50),
        httpClient: MockClient.streaming((req, _) async {
          final body = StreamController<List<int>>(); // never sends anything
          return http.StreamedResponse(body.stream, 200);
        }),
      );
      await expectLater(client.stream({'model': 'm'}).drain<void>(), throwsA(isA<AiNetworkException>()));
    });
  });
}
