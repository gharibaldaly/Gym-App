import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../core/providers.dart';
import '../services/keep_alive/keep_alive.dart';
import 'ai_config.dart';
import 'claude_client.dart';
import 'json_schema.dart';

export 'ai_config.dart';
export 'claude_client.dart';

const _keyStorageName = 'claude_api_key';

/// Holds the Claude API key (flutter_secure_storage – never in code, prefs or backups).
class ApiKeyNotifier extends AsyncNotifier<String?> {
  static const _storage = FlutterSecureStorage();

  @override
  Future<String?> build() async {
    try {
      final k = await _storage.read(key: _keyStorageName);
      return (k == null || k.trim().isEmpty) ? null : k.trim();
    } catch (_) {
      return null;
    }
  }

  Future<void> save(String key) async {
    await _storage.write(key: _keyStorageName, value: key.trim());
    state = AsyncData(key.trim());
  }

  Future<void> clear() async {
    await _storage.delete(key: _keyStorageName);
    state = const AsyncData(null);
  }
}

final apiKeyProvider = AsyncNotifierProvider<ApiKeyNotifier, String?>(ApiKeyNotifier.new);

/// True when an API key is configured. Use it to show "add your key" placeholders.
final hasApiKeyProvider = Provider<bool>((ref) => ref.watch(apiKeyProvider).value != null);

final aiServiceProvider = Provider<AiService>((ref) => AiService(ref));

/// Single entry point for every Claude call. Handles model routing, prompt
/// caching, structured outputs + validation (1 retry), usage/cost logging.
class AiService {
  final Ref ref;
  AiService(this.ref);

  AppDatabase get _db => ref.read(databaseProvider);

  Future<String?> _key() async => ref.read(apiKeyProvider).value ?? await ref.read(apiKeyProvider.future);

  Future<bool> get hasKey async => (await _key()) != null;

  /// Model id currently configured for a tier (Settings → AI models).
  String modelFor(ModelTier tier) {
    final prefs = ref.read(sharedPrefsProvider);
    return switch (tier) {
      ModelTier.haiku => prefs.getString(SettingsKeys.modelHaiku) ?? AiDefaults.haiku,
      ModelTier.sonnet => prefs.getString(SettingsKeys.modelSonnet) ?? AiDefaults.sonnet,
      ModelTier.opus => prefs.getString(SettingsKeys.modelOpus) ?? AiDefaults.opus,
    };
  }

  bool get _fallbacksEnabled => ref.read(sharedPrefsProvider).getBool(SettingsKeys.useRefusalFallbacks) ?? true;

  Future<ClaudeClient> _client() async {
    final k = await _key();
    if (k == null) throw AiNoKeyException();
    if (!ref.read(isOnlineProvider)) throw AiOfflineException();
    return ClaudeClient(k, httpClient: debugHttpClientFactory?.call());
  }

  /// Test hook: supplies the HTTP client used for API calls.
  @visibleForTesting
  static http.Client Function()? debugHttpClientFactory;

  /// System prompt as cacheable blocks: [stable] is cached (persona, profile…),
  /// [dynamic] (dates, latest logs) goes after the breakpoint.
  static List<Map<String, dynamic>> systemBlocks(String stable, {String? dynamic}) => [
    {
      'type': 'text',
      'text': stable,
      'cache_control': {'type': 'ephemeral'},
    },
    if (dynamic != null && dynamic.isNotEmpty) {'type': 'text', 'text': dynamic},
  ];

  Map<String, dynamic> buildBody({
    required AiFeature feature,
    required List<Map<String, dynamic>> messages,
    Object? system,
    List<Map<String, dynamic>>? tools,
    Map<String, dynamic>? outputSchema,
    int maxTokens = 16000,
  }) {
    final model = modelFor(feature.tier);
    final supportsFallback = model.contains('opus') || model.contains('sonnet-5-5') || model.contains('fable');
    return {
      'model': model,
      'max_tokens': maxTokens,
      'system': ?system,
      'messages': messages,
      if (tools != null && tools.isNotEmpty) 'tools': tools,
      'output_config': {
        'effort': feature.effort,
        if (outputSchema != null) 'format': {'type': 'json_schema', 'schema': strictSchema(outputSchema)},
      },
      if (supportsFallback && _fallbacksEnabled) 'fallbacks': 'default',
    };
  }

  Future<void> _logUsage(AiFeature feature, String model, ClaudeUsage u) async {
    final cost = priceFor(model, feature.tier).cost(
      inTok: u.inputTokens,
      outTok: u.outputTokens,
      cacheReadTok: u.cacheReadTokens,
      cacheWriteTok: u.cacheWriteTokens,
    );
    await _db
        .into(_db.aiUsage)
        .insert(
          AiUsageCompanion.insert(
            feature: feature.key,
            model: model,
            inputTokens: Value(u.inputTokens),
            outputTokens: Value(u.outputTokens),
            cacheReadTokens: Value(u.cacheReadTokens),
            cacheWriteTokens: Value(u.cacheWriteTokens),
            costUsd: Value(cost),
          ),
        );
  }

  /// Raw call with usage logging. Throws [AiException] on refusal.
  ///
  /// Runs under [KeepAlive] so locking the screen / leaving the app doesn't
  /// kill the request, and retries when the connection drops (e.g. the OS
  /// froze the app anyway) once the app is back in the foreground.
  Future<ClaudeResponse> create(AiFeature feature, Map<String, dynamic> body) {
    return KeepAlive.run(() async {
      for (var attempt = 0; ; attempt++) {
        final client = await _client();
        try {
          final res = await client.create(body);
          await _logUsage(feature, res.model, res.usage);
          if (res.isRefusal) throw AiException('The request was declined by the model.');
          return res;
        } catch (e) {
          final err = _asAiException(e);
          if (err == null || !await _shouldRetry(err, attempt)) {
            if (err != null && !identical(err, e)) throw err;
            rethrow;
          }
        } finally {
          client.close();
        }
      }
    });
  }

  static const _maxRetries = 3;

  /// Normalizes errors thrown mid-request (a connection killed while the app
  /// was in the background surfaces as a raw socket/http error).
  static AiException? _asAiException(Object e) {
    if (e is AiException) return e;
    if (e is IOException || e is http.ClientException || e is TimeoutException) {
      return AiException('Network error: $e');
    }
    return null;
  }

  /// Network drops (offline/connection reset/timeout) and 429/5xx/529 are retried:
  /// first wait for the app to be in the foreground, then back off.
  Future<bool> _shouldRetry(AiException e, int attempt) async {
    if (attempt >= _maxRetries || e is AiNoKeyException || e.isAuth || !e.isRetryable) return false;
    await AppForeground.waitUntilForeground();
    await Future<void>.delayed(Duration(seconds: 2 << attempt));
    return true;
  }

  /// Plain text answer.
  Future<String> text({
    required AiFeature feature,
    required String prompt,
    Object? system,
    List<Map<String, dynamic>>? extraContent,
    int maxTokens = 8000,
  }) async {
    final res = await create(
      feature,
      buildBody(
        feature: feature,
        system: system,
        maxTokens: maxTokens,
        messages: [
          {
            'role': 'user',
            'content': [
              ...?extraContent,
              {'type': 'text', 'text': prompt},
            ],
          },
        ],
      ),
    );
    return res.text.trim();
  }

  /// Structured JSON output validated against [schema]; retries once with the
  /// validation errors when parsing/validation fails. [extraValidate] can add
  /// domain checks (return error strings).
  Future<Map<String, dynamic>> structured({
    required AiFeature feature,
    required String prompt,
    required Map<String, dynamic> schema,
    Object? system,
    List<Map<String, dynamic>>? extraContent,
    List<String> Function(Map<String, dynamic>)? extraValidate,
    int maxTokens = 16000,
  }) async {
    final messages = <Map<String, dynamic>>[
      {
        'role': 'user',
        'content': [
          ...?extraContent,
          {'type': 'text', 'text': prompt},
        ],
      },
    ];
    for (var attempt = 0; attempt < 2; attempt++) {
      final res = await create(
        feature,
        buildBody(feature: feature, system: system, messages: messages, outputSchema: schema, maxTokens: maxTokens),
      );
      final raw = res.text.trim();
      List<String> errors;
      Map<String, dynamic>? parsed;
      try {
        parsed = jsonDecode(_stripFences(raw)) as Map<String, dynamic>;
        errors = [...validateJson(parsed, schema), ...?extraValidate?.call(parsed)];
      } catch (e) {
        errors = ['Invalid JSON: $e'];
      }
      if (errors.isEmpty && parsed != null) return parsed;
      if (attempt == 0) {
        messages
          ..add({'role': 'assistant', 'content': raw.isEmpty ? '{}' : raw})
          ..add({
            'role': 'user',
            'content':
                'Your JSON was invalid:\n${errors.take(10).join('\n')}\n'
                'Return the corrected JSON only.',
          });
      } else {
        throw AiException('Invalid structured output: ${errors.take(3).join('; ')}');
      }
    }
    throw AiException('unreachable');
  }

  /// Streaming call (chat). Logs usage when the stream completes. Kept alive in
  /// the background like [create]; retried after a dropped connection as long
  /// as no text has been shown yet (a half-shown answer can't be resumed).
  Stream<ClaudeStreamEvent> stream(AiFeature feature, Map<String, dynamic> body) {
    final controller = StreamController<ClaudeStreamEvent>();
    controller.onListen = () {
      unawaited(
        KeepAlive.run(() async {
          for (var attempt = 0; ; attempt++) {
            var yielded = false;
            final ClaudeClient client;
            try {
              client = await _client(); // no key / offline: fail fast, no retry
            } catch (e, st) {
              controller.addError(e, st);
              break;
            }
            try {
              await for (final ev in client.stream(body)) {
                if (controller.isClosed) return;
                if (ev is StreamDone) await _logUsage(feature, ev.response.model, ev.response.usage);
                if (ev is TextDelta) yielded = true;
                controller.add(ev);
              }
              break;
            } catch (e, st) {
              final err = _asAiException(e);
              if (err == null || yielded || !await _shouldRetry(err, attempt)) {
                controller.addError(err ?? e, st);
                break;
              }
            } finally {
              client.close();
            }
          }
          await controller.close();
        }),
      );
    };
    return controller.stream;
  }

  /// Cheap request used by Settings → "Test key".
  Future<bool> testKey(String key) async {
    final client = ClaudeClient(key, timeout: const Duration(seconds: 30));
    try {
      final res = await client.create({
        'model': modelFor(ModelTier.haiku),
        'max_tokens': 16,
        'messages': [
          {'role': 'user', 'content': 'Reply with OK'},
        ],
      });
      await _logUsage(AiFeature.keyTest, res.model, res.usage);
      return true;
    } finally {
      client.close();
    }
  }

  static String _stripFences(String s) {
    var t = s.trim();
    if (t.startsWith('```')) {
      t = t.replaceFirst(RegExp(r'^```[a-zA-Z]*\s*'), '');
      if (t.endsWith('```')) t = t.substring(0, t.length - 3);
    }
    return t.trim();
  }
}

/// Human-readable message for an AI error (bilingual).
String aiErrorText(Object e, {required bool ar}) {
  if (e is AiNoKeyException) {
    return ar
        ? 'ضيف مفتاح Claude API من الإعدادات عشان الميزة دي تشتغل.'
        : 'Add your Claude API key in Settings to use this feature.';
  }
  if (e is AiOfflineException) {
    return ar ? 'مفيش نت دلوقتي.' : 'No internet connection.';
  }
  if (e is AiException && e.isAuth) {
    return ar ? 'مفتاح الـ API غلط أو منتهي.' : 'Invalid or expired API key.';
  }
  if (e is AiException) return ar ? 'حصل خطأ في الـ AI: ${e.message}' : 'AI error: ${e.message}';
  return ar ? 'حصل خطأ: $e' : 'Error: $e';
}
