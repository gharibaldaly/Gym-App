import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../ai/ai_queue.dart';
import '../../../ai/ai_service.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/context_ext.dart';
import '../../../core/widgets/common.dart';
import '../food_ai.dart';
import '../nutrition_repository.dart';
import 'food_review_screen.dart';

/// Type or say what you ate → Claude Haiku → review → save. Pops `true` when saved.
class FoodTextScreen extends ConsumerStatefulWidget {
  final int? mealIndex;
  const FoodTextScreen({super.key, this.mealIndex});

  @override
  ConsumerState<FoodTextScreen> createState() => _FoodTextScreenState();
}

class _FoodTextScreenState extends ConsumerState<FoodTextScreen> {
  final _c = TextEditingController();
  final _speech = SpeechToText();
  bool _speechReady = false;
  bool _listening = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _speech.stop();
    _c.dispose();
    super.dispose();
  }

  Future<void> _toggleMic() async {
    final l = context.l10n;
    if (_listening) {
      await _speech.stop();
      setState(() => _listening = false);
      return;
    }
    if (!_speechReady) {
      try {
        _speechReady = await _speech.initialize(
          onStatus: (s) {
            if (mounted && (s == 'done' || s == 'notListening')) setState(() => _listening = false);
          },
          onError: (_) {
            if (mounted) setState(() => _listening = false);
          },
        );
      } catch (_) {
        _speechReady = false;
      }
    }
    if (!_speechReady) {
      if (mounted) context.snack(l.nutSpeechUnavailable);
      return;
    }
    if (!mounted) return;
    final localeId = context.isAr ? 'ar_EG' : 'en_US';
    final base = _c.text.trim();
    setState(() => _listening = true);
    await _speech.listen(
      onResult: (SpeechRecognitionResult r) {
        if (!mounted) return;
        setState(() => _c.text = [if (base.isNotEmpty) base, r.recognizedWords].join(' '));
      },
      listenOptions: SpeechListenOptions(
        localeId: localeId,
        partialResults: true,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 4),
      ),
    );
  }

  Future<void> _saveForLater() async {
    final l = context.l10n;
    final text = _c.text.trim();
    if (text.isEmpty) return;
    final repo = ref.read(nutritionRepositoryProvider);
    final id = await repo.addLog(
      day: today(),
      name: text,
      items: const [],
      source: 'ai_text',
      mealIndex: widget.mealIndex,
      status: 'pending_ai',
    );
    await ref.read(aiQueueProvider).enqueue(FoodAi.textQueueKey, {'logId': id, 'text': text});
    if (!mounted) return;
    final hasKey = ref.read(hasApiKeyProvider);
    context.snack(hasKey ? l.aiQueuedOffline : l.nutQueuedNoKey);
    Navigator.pop(context, false);
  }

  Future<void> _analyze() async {
    final text = _c.text.trim();
    if (text.isEmpty) return;
    if (_listening) await _speech.stop();
    setState(() {
      _busy = true;
      _error = null;
      _listening = false;
    });
    try {
      final a = await ref.read(foodAiProvider).analyzeText(text);
      if (!mounted) return;
      final saved = await Navigator.of(context).push<bool>(MaterialPageRoute(
        builder: (_) => FoodReviewScreen(
          items: a.items,
          name: a.mealName(context.lang),
          source: 'ai_text',
          confidence: a.confidence,
          notes: a.notes,
          mealIndex: widget.mealIndex,
        ),
      ));
      if (!mounted) return;
      if (saved == true) Navigator.pop(context, true);
      setState(() => _busy = false);
    } on AiOfflineException {
      if (mounted) setState(() => _busy = false);
      await _saveForLater();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = aiErrorText(e, ar: context.isAr);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final hasKey = ref.watch(hasApiKeyProvider);
    final online = ref.watch(isOnlineProvider);
    final canAnalyze = hasKey && online;
    return Scaffold(
      appBar: AppBar(title: Text(l.nutLogText)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const AiUnavailableBanner(),
          Text(l.nutTextPrompt, style: context.text.titleMedium),
          const SizedBox(height: 12),
          TextField(
            controller: _c,
            minLines: 3,
            maxLines: 6,
            autofocus: true,
            textInputAction: TextInputAction.newline,
            decoration: InputDecoration(hintText: l.nutTextHintExample),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          Center(
            child: SizedBox(
              width: 88,
              height: 88,
              child: IconButton.filled(
                iconSize: 40,
                style: IconButton.styleFrom(
                  backgroundColor: _listening ? AppColors.danger : AppColors.primary,
                  foregroundColor: _listening ? Colors.white : AppColors.onPrimary,
                ),
                tooltip: _listening ? l.nutStopListening : l.nutSpeak,
                onPressed: _busy ? null : _toggleMic,
                icon: Icon(_listening ? Icons.stop : Icons.mic),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(_listening ? l.nutListening : l.nutTapToSpeak,
              textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textMuted)),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: AppColors.danger)),
          ],
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: canAnalyze
              ? FilledButton.icon(
                  style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
                  onPressed: _busy || _c.text.trim().isEmpty ? null : _analyze,
                  icon: _busy
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.auto_awesome),
                  label: Text(_busy ? l.nutAnalyzing : l.nutAnalyze),
                )
              : OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(56)),
                  onPressed: _c.text.trim().isEmpty ? null : _saveForLater,
                  icon: const Icon(Icons.schedule),
                  label: Text(l.nutAnalyzeLater),
                ),
        ),
      ),
    );
  }
}
