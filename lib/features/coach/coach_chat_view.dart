import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../ai/ai_service.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/context_ext.dart';
import '../../core/widgets/common.dart';
import 'coach_chat_controller.dart';
import 'coach_repository.dart';
import 'widgets/message_bubble.dart';
import 'widgets/proposal_card.dart';

/// Full chat with streaming replies, inline initiative messages and proposal cards.
class CoachChatView extends ConsumerStatefulWidget {
  const CoachChatView({super.key});

  @override
  ConsumerState<CoachChatView> createState() => _CoachChatViewState();
}

class _CoachChatViewState extends ConsumerState<CoachChatView> with AutomaticKeepAliveClientMixin {
  final _input = TextEditingController();
  final _speech = SpeechToText();
  bool _speechReady = false;
  bool _listening = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _input.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    if (_listening) _speech.stop();
    _input.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    if (_listening) await _stopListening();
    if (!mounted) return;
    _input.clear();
    FocusScope.of(context).unfocus();
    await ref.read(coachChatProvider.notifier).send(text);
  }

  Future<void> _toggleVoice() async {
    if (_listening) {
      await _stopListening();
      return;
    }
    final unavailable = context.l10n.coachVoiceUnavailable;
    final localeId = context.isAr ? 'ar_EG' : 'en_US';
    try {
      if (!_speechReady) {
        _speechReady = await _speech.initialize(
          onStatus: (s) {
            if ((s == 'done' || s == 'notListening') && mounted) setState(() => _listening = false);
          },
          onError: (_) {
            if (mounted) setState(() => _listening = false);
          },
        );
      }
      if (!_speechReady) {
        if (mounted) context.snack(unavailable);
        return;
      }
      setState(() => _listening = true);
      await _speech.listen(
        onResult: (r) {
          _input.value = TextEditingValue(
            text: r.recognizedWords,
            selection: TextSelection.collapsed(offset: r.recognizedWords.length),
          );
        },
        listenOptions: SpeechListenOptions(
          localeId: localeId,
          partialResults: true,
          cancelOnError: true,
          listenFor: const Duration(seconds: 45),
          pauseFor: const Duration(seconds: 4),
        ),
      );
    } catch (_) {
      if (mounted) {
        setState(() => _listening = false);
        context.snack(unavailable);
      }
    }
  }

  Future<void> _stopListening() async {
    try {
      await _speech.stop();
    } catch (_) {}
    if (mounted) setState(() => _listening = false);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l = context.l10n;
    final messagesAsync = ref.watch(coachMessagesProvider);
    final proposals = ref.watch(coachProposalsProvider).value ?? const <CoachProposal>[];
    final chat = ref.watch(coachChatProvider);
    final hasKey = ref.watch(hasApiKeyProvider);
    final online = ref.watch(isOnlineProvider);
    final messages = messagesAsync.value ?? const <CoachMessage>[];

    final byMessage = <int, List<CoachProposal>>{};
    for (final p in proposals) {
      if (p.messageId != null) byMessage.putIfAbsent(p.messageId!, () => []).add(p);
    }
    final newestFirst = messages.reversed.toList();
    final itemCount = newestFirst.length + (chat.sending ? 1 : 0);

    return Column(
      children: [
        if (!hasKey || !online)
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: AiUnavailableBanner(),
          ),
        Expanded(
          child: messagesAsync.isLoading && messages.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : itemCount == 0
                  ? EmptyState(icon: Symbols.forum_rounded, text: l.coachEmptyChat)
                  : ListView.builder(
                      reverse: true,
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      itemCount: itemCount,
                      itemBuilder: (context, i) {
                        if (chat.sending && i == 0) {
                          return MessageBubble(
                            role: 'assistant',
                            text: chat.streamingText.isEmpty ? l.coachThinking : chat.streamingText,
                            streaming: true,
                          );
                        }
                        final m = newestFirst[i - (chat.sending ? 1 : 0)];
                        final isNewest = i == (chat.sending ? 1 : 0);
                        final cards = byMessage[m.id] ?? const <CoachProposal>[];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            MessageBubble(
                              role: m.role,
                              text: m.content,
                              kind: m.kind,
                              time: m.createdAt,
                              footer: m.kind == CoachKinds.offlineNotice && isNewest && !chat.sending
                                  ? Align(
                                      alignment: AlignmentDirectional.centerEnd,
                                      child: TextButton.icon(
                                        onPressed: online && hasKey
                                            ? () => ref.read(coachChatProvider.notifier).retry()
                                            : null,
                                        icon: const Icon(Symbols.refresh_rounded),
                                        label: Text(l.coachResend),
                                      ),
                                    )
                                  : null,
                            ),
                            for (final p in cards)
                              Padding(
                                padding: const EdgeInsetsDirectional.only(end: 24),
                                child: ProposalCard(proposal: p),
                              ),
                          ],
                        );
                      },
                    ),
        ),
        if (chat.error != null)
          Container(
            width: double.infinity,
            color: AppColors.danger.withValues(alpha: 0.12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                const Icon(Symbols.error_rounded, color: AppColors.danger),
                const SizedBox(width: 8),
                Expanded(child: Text(chat.error!, style: context.text.bodySmall)),
                TextButton(
                  onPressed: () => ref.read(coachChatProvider.notifier).retry(),
                  child: Text(l.retry),
                ),
                IconButton(
                  onPressed: () => ref.read(coachChatProvider.notifier).dismissError(),
                  icon: const Icon(Symbols.close_rounded, size: 18),
                ),
              ],
            ),
          ),
        _InputBar(
          controller: _input,
          enabled: hasKey,
          sending: chat.sending,
          listening: _listening,
          onSend: _send,
          onVoice: _toggleVoice,
        ),
      ],
    );
  }
}

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final bool sending;
  final bool listening;
  final VoidCallback onSend;
  final VoidCallback onVoice;
  const _InputBar({
    required this.controller,
    required this.enabled,
    required this.sending,
    required this.listening,
    required this.onSend,
    required this.onVoice,
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final canSend = enabled && !sending && controller.text.trim().isNotEmpty;
    return Material(
      color: AppColors.card,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 52,
                height: 52,
                child: IconButton(
                  tooltip: l.coachVoice,
                  onPressed: enabled ? onVoice : null,
                  icon: Icon(listening ? Symbols.stop_circle_rounded : Symbols.mic_none_rounded,
                      color: listening ? AppColors.danger : null, size: 28),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  enabled: enabled,
                  minLines: 1,
                  maxLines: 5,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    hintText: !enabled
                        ? l.coachInputNoKey
                        : listening
                            ? l.coachListening
                            : l.coachInputHint,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              SizedBox(
                width: 52,
                height: 52,
                child: IconButton.filled(
                  tooltip: l.coachSend,
                  onPressed: canSend ? onSend : null,
                  icon: sending
                      ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5))
                      : const Icon(Symbols.send_rounded),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
