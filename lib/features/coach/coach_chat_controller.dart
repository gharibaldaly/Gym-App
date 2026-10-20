import 'dart:async';
import 'dart:ui' show Locale;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../ai/ai_service.dart';
import '../../core/providers.dart';
import '../../l10n/gen/app_localizations.dart';
import 'coach_context.dart';
import 'coach_memory.dart';
import 'coach_repository.dart';
import 'coach_tools.dart';

/// How many stored messages are sent as conversation history.
const coachHistoryLength = 20;

/// Max tool-use round trips per user message.
const _maxToolRounds = 6;

/// Builds Messages-API history from stored messages: offline notices are
/// skipped, consecutive same-role messages merged, initiatives labelled, and
/// the list always starts with a user turn.
List<Map<String, dynamic>> buildChatHistory(List<CoachMessage> messages) {
  final out = <Map<String, dynamic>>[];
  for (final m in messages) {
    if (m.kind == CoachKinds.offlineNotice) continue;
    final text = m.content.trim();
    if (text.isEmpty) continue;
    final role = m.role == 'user' ? 'user' : 'assistant';
    final labelled = role == 'assistant' && m.kind != CoachKinds.chat ? '[${m.kind} message]\n$text' : text;
    if (out.isNotEmpty && out.last['role'] == role) {
      out.last['content'] = '${out.last['content']}\n\n$labelled';
    } else {
      out.add({'role': role, 'content': labelled});
    }
  }
  if (out.isNotEmpty && out.first['role'] == 'assistant') {
    out.insert(0, {'role': 'user', 'content': '(Earlier coach messages follow.)'});
  }
  return out;
}

/// Removes client-side bookkeeping keys (e.g. `_invalid_json`) from content blocks
/// while leaving everything the API sent (text, thinking + signature, tool_use) untouched.
List<Map<String, dynamic>> sanitizeAssistantContent(List<Map<String, dynamic>> blocks) => [
      for (final b in blocks) {for (final e in b.entries) if (!e.key.startsWith('_')) e.key: e.value},
    ];

class CoachChatState {
  final bool sending;
  final String streamingText;
  final String? error;
  final bool usingTools;
  const CoachChatState({this.sending = false, this.streamingText = '', this.error, this.usingTools = false});

  CoachChatState copyWith({bool? sending, String? streamingText, String? error, bool clearError = false, bool? usingTools}) =>
      CoachChatState(
        sending: sending ?? this.sending,
        streamingText: streamingText ?? this.streamingText,
        error: clearError ? null : (error ?? this.error),
        usingTools: usingTools ?? this.usingTools,
      );
}

class CoachChatController extends Notifier<CoachChatState> {
  Timer? _memoryTimer;

  @override
  CoachChatState build() {
    ref.onDispose(() => _memoryTimer?.cancel());
    return const CoachChatState();
  }

  CoachRepository get _repo => ref.read(coachRepositoryProvider);

  String get _lang {
    try {
      return ref.read(localeProvider);
    } catch (_) {
      return 'ar';
    }
  }

  AppLocalizations get _l => lookupAppLocalizations(Locale(_lang == 'ar' ? 'ar' : 'en'));

  /// Saves the user message and streams the coach reply.
  Future<void> send(String text) async {
    final t = text.trim();
    if (t.isEmpty || state.sending) return;
    await _repo.addMessage(role: 'user', content: t);
    await _respond();
  }

  /// Re-runs the reply for the latest user message (after offline / error).
  Future<void> retry() async {
    if (state.sending) return;
    await _respond();
  }

  void dismissError() => state = state.copyWith(clearError: true);

  /// Flushes pending memory extraction now (user left the chat).
  void flushMemory() {
    _memoryTimer?.cancel();
    _memoryTimer = null;
    unawaited(ref.read(coachMemoryServiceProvider).scheduleExtraction());
  }

  void _scheduleMemory() {
    _memoryTimer?.cancel();
    _memoryTimer = Timer(const Duration(minutes: 2), flushMemory);
  }

  Future<void> _respond() async {
    state = const CoachChatState(sending: true);
    final ai = ref.read(aiServiceProvider);
    final db = ref.read(databaseProvider);
    final now = ref.read(coachClockProvider);
    final buffer = StringBuffer();
    final proposalIds = <int>[];
    try {
      if (!await ai.hasKey) throw AiNoKeyException();
      if (!ref.read(isOnlineProvider)) throw AiOfflineException();

      final lang = _lang;
      final ctx = await CoachContextBuilder(db, lang: lang, now: now()).build();
      final messages = buildChatHistory(await _repo.recentMessages(coachHistoryLength));
      if (messages.isEmpty || messages.last['role'] != 'user') {
        state = const CoachChatState();
        return;
      }
      final executor = CoachToolExecutor(db, lang: lang, now: now);

      for (var round = 0; round < _maxToolRounds; round++) {
        final body = ai.buildBody(
          feature: AiFeature.chat,
          system: ctx.systemBlocks,
          messages: messages,
          tools: coachTools,
          maxTokens: 8000,
        )..['tool_choice'] = {'type': 'auto'};

        if (buffer.isNotEmpty && !buffer.toString().endsWith('\n')) buffer.write('\n\n');
        ClaudeResponse? res;
        await for (final ev in ai.stream(AiFeature.chat, body)) {
          switch (ev) {
            case TextDelta(:final text):
              buffer.write(text);
              state = state.copyWith(streamingText: buffer.toString(), usingTools: false);
            case StreamDone(:final response):
              res = response;
          }
        }
        if (res == null) break;
        if (res.isRefusal) {
          if (buffer.isEmpty) buffer.write(_l.coachRefused);
          break;
        }
        if (res.stopReason != 'tool_use' || res.toolUses.isEmpty) break;

        state = state.copyWith(usingTools: true);
        final results = <Map<String, dynamic>>[];
        for (final call in res.toolUses) {
          final input = (call['input'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};
          final outcome = await executor.execute(call['name'] as String? ?? '', {
            ...input,
            if (call['_invalid_json'] == true) '_invalid_json': true,
          });
          if (outcome.proposalId != null) proposalIds.add(outcome.proposalId!);
          results.add(outcome.toResultBlock(call['id'] as String));
        }
        messages
          ..add({'role': 'assistant', 'content': sanitizeAssistantContent(res.content)})
          ..add({'role': 'user', 'content': results});
      }

      var reply = buffer.toString().trim();
      if (reply.isEmpty && proposalIds.isNotEmpty) reply = _l.coachProposalWaiting;
      if (reply.isNotEmpty) {
        final id = await _repo.addMessage(
          role: 'assistant',
          content: reply,
          meta: proposalIds.isEmpty ? null : {'proposalIds': proposalIds},
          isRead: true,
        );
        await _repo.linkProposalsToMessage(proposalIds, id);
      }
      state = const CoachChatState();
      _scheduleMemory();
    } on AiOfflineException {
      await _savePartial(buffer, proposalIds);
      await _repo.addMessage(
        role: 'assistant',
        content: _l.coachOfflineNotice,
        kind: CoachKinds.offlineNotice,
        isRead: true,
      );
      state = const CoachChatState();
    } catch (e, st) {
      if (e is! AiException) debugPrint('coach chat failed: $e\n$st');
      await _savePartial(buffer, proposalIds);
      state = CoachChatState(error: aiErrorText(e, ar: _lang == 'ar'));
    }
  }

  Future<void> _savePartial(StringBuffer buffer, List<int> proposalIds) async {
    final partial = buffer.toString().trim();
    if (partial.isEmpty && proposalIds.isEmpty) return;
    try {
      final id = await _repo.addMessage(
        role: 'assistant',
        content: partial.isEmpty ? _l.coachProposalWaiting : '$partial …',
        meta: proposalIds.isEmpty ? null : {'proposalIds': proposalIds, 'partial': true},
        isRead: true,
      );
      await _repo.linkProposalsToMessage(proposalIds, id);
    } catch (_) {}
  }
}

final coachChatProvider = NotifierProvider<CoachChatController, CoachChatState>(CoachChatController.new);
