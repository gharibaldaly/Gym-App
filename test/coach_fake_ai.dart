import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ironmind/ai/ai_service.dart';
import 'package:ironmind/core/providers.dart';
import 'package:ironmind/features/coach/coach_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'coach_fixtures.dart';

/// AiService double: scripted streams / text / structured replies, records requests.
class FakeAi extends AiService {
  FakeAi(super.ref);

  bool keyPresent = true;
  final List<List<ClaudeStreamEvent>> streams = [];
  final List<Map<String, dynamic>> bodies = [];
  final List<String> prompts = [];
  final List<AiFeature> features = [];
  String textReply = 'ok';
  Map<String, dynamic> structuredReply = const {};

  @override
  Future<bool> get hasKey async => keyPresent;

  @override
  Stream<ClaudeStreamEvent> stream(AiFeature feature, Map<String, dynamic> body) async* {
    features.add(feature);
    bodies.add(jsonDecode(jsonEncode(body)) as Map<String, dynamic>);
    for (final e in streams.removeAt(0)) {
      yield e;
    }
  }

  @override
  Future<String> text({
    required AiFeature feature,
    required String prompt,
    Object? system,
    List<Map<String, dynamic>>? extraContent,
    int maxTokens = 8000,
  }) async {
    features.add(feature);
    prompts.add(prompt);
    return textReply;
  }

  @override
  Future<Map<String, dynamic>> structured({
    required AiFeature feature,
    required String prompt,
    required Map<String, dynamic> schema,
    Object? system,
    List<Map<String, dynamic>>? extraContent,
    List<String> Function(Map<String, dynamic>)? extraValidate,
    int maxTokens = 16000,
  }) async {
    features.add(feature);
    prompts.add(prompt);
    return structuredReply;
  }
}

ClaudeResponse response(List<Map<String, dynamic>> content, String stop) =>
    ClaudeResponse(model: 'claude-sonnet-5-5', content: content, stopReason: stop, usage: ClaudeUsage());

/// Container wired to an in-memory DB, mock prefs, fixed clock and [FakeAi].
Future<(ProviderContainer, FakeAi, SharedPreferences)> coachContainer(
  AppDatabase db, {
  bool online = true,
  DateTime? now,
  Map<String, Object> prefsValues = const {'language': 'ar'},
}) async {
  SharedPreferences.setMockInitialValues(prefsValues);
  final prefs = await SharedPreferences.getInstance();
  late FakeAi fake;
  final c = ProviderContainer(overrides: [
    databaseProvider.overrideWithValue(db),
    sharedPrefsProvider.overrideWithValue(prefs),
    isOnlineProvider.overrideWithValue(online),
    coachClockProvider.overrideWithValue(() => now ?? testNow),
    aiServiceProvider.overrideWith((ref) => fake = FakeAi(ref)),
  ]);
  c.read(aiServiceProvider);
  return (c, fake, prefs);
}
