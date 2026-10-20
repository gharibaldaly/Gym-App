import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../ai/ai_service.dart';
import '../../../core/calc/voice_parser.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/context_ext.dart';
import '../../../core/widgets/common.dart';
import '../workout_logic.dart';
import 'plan_day_editor.dart' show RpeSelector;
import 'workout_widgets.dart';

class VoiceSet {
  final double weightKg;
  final int reps;
  final double? rpe;
  final String setType;
  const VoiceSet(this.weightKg, this.reps, {this.rpe, this.setType = SetType.normal});
}

/// Set type keywords in Egyptian Arabic / English (local, no AI).
String? detectSetType(String text) {
  final t = text.toLowerCase();
  if (RegExp(r'warm|إحماء|احماء|تسخين').hasMatch(t)) return SetType.warmup;
  if (RegExp(r'drop|دروب').hasMatch(t)) return SetType.drop;
  if (RegExp(r'failure|فشل').hasMatch(t)) return SetType.failure;
  return null;
}

const _voiceSchema = {
  'type': 'object',
  'properties': {
    'ok': {'type': 'boolean'},
    'weightKg': {
      'type': ['number', 'null'],
    },
    'reps': {
      'type': ['integer', 'null'],
    },
    'rpe': {
      'type': ['number', 'null'],
    },
    'setType': {
      'type': ['string', 'null'],
    },
  },
  'required': ['ok', 'weightKg', 'reps', 'rpe', 'setType'],
};

List<String> _validateVoice(Map<String, dynamic> j) {
  final e = <String>[];
  if (j['ok'] == true) {
    final w = j['weightKg'], r = j['reps'];
    if (w is! num || w < 0 || w > 700) e.add('weightKg must be 0..700 when ok');
    if (r is! num || r < 1 || r > 100) e.add('reps must be 1..100 when ok');
  }
  final rpe = j['rpe'];
  if (rpe != null && (rpe is! num || rpe < 1 || rpe > 10)) e.add('rpe must be null or 1..10');
  final t = j['setType'];
  if (t != null && !SetType.all.contains(t)) e.add('setType must be one of ${SetType.all} or null');
  return e;
}

/// Claude (Haiku) fallback for transcripts the local regex parser can't read.
Future<VoiceSet?> parseVoiceWithAi(WidgetRef ref, String transcript) async {
  final j = await ref.read(aiServiceProvider).structured(
        feature: AiFeature.voiceParse,
        system: AiService.systemBlocks(
          'You convert a spoken gym set (Egyptian Arabic or English, possibly with speech-recognition errors) '
          'into JSON. weightKg = load in kilograms (0 for bodyweight; convert pounds to kg), reps = repetitions, '
          'rpe = 1-10 if mentioned, setType = normal | warmup | drop | failure if mentioned else null. '
          'Arabic number words like "تمانين" = 80, "ونص" = .5. If you cannot find both weight and reps set ok=false.',
        ),
        prompt: 'Transcript: "$transcript"',
        schema: _voiceSchema,
        extraValidate: _validateVoice,
        maxTokens: 400,
      );
  if (j['ok'] != true) return null;
  return VoiceSet(
    (j['weightKg'] as num).toDouble(),
    (j['reps'] as num).round(),
    rpe: (j['rpe'] as num?)?.toDouble(),
    setType: (j['setType'] as String?) ?? SetType.normal,
  );
}

/// Full voice flow: listen → local parse → (Claude if needed & available) → confirm.
/// Returns the confirmed set or null.
Future<VoiceSet?> captureVoiceSet(BuildContext context, WidgetRef ref) async {
  final l = context.l10n;
  final transcript = await showDialog<String>(
    context: context,
    builder: (_) => _ListeningDialog(localeId: context.isAr ? 'ar_EG' : 'en_US'),
  );
  if (transcript == null || transcript.trim().isEmpty || !context.mounted) return null;

  VoiceSet? parsed;
  final local = VoiceSetParser.parse(transcript);
  if (local != null) {
    parsed = VoiceSet(local.weightKg, local.reps, rpe: local.rpe, setType: detectSetType(transcript) ?? SetType.normal);
  } else if (ref.read(hasApiKeyProvider) && ref.read(isOnlineProvider)) {
    try {
      parsed = await runWithProgress(context, l.woVoiceParsing, () => parseVoiceWithAi(ref, transcript));
    } catch (e) {
      if (context.mounted) context.snack(aiErrorText(e, ar: context.isAr));
    }
  }
  if (!context.mounted) return null;
  if (parsed == null) {
    await showDialog<void>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l.woVoiceNotUnderstood),
        content: Text('"$transcript"\n\n${l.woVoiceHint}'),
        actions: [TextButton(onPressed: () => Navigator.pop(c), child: Text(l.ok))],
      ),
    );
    return null;
  }
  return showDialog<VoiceSet>(
    context: context,
    builder: (_) => _VoiceConfirmDialog(transcript: transcript, initial: parsed!),
  );
}

class _ListeningDialog extends StatefulWidget {
  final String localeId;
  const _ListeningDialog({required this.localeId});

  @override
  State<_ListeningDialog> createState() => _ListeningDialogState();
}

class _ListeningDialogState extends State<_ListeningDialog> {
  static final SpeechToText _stt = SpeechToText();
  String _text = '';
  String? _error;
  bool _listening = false;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    try {
      void onError(SpeechRecognitionError e) {
        if (mounted) setState(() => _error = e.errorMsg);
      }

      void onStatus(String s) {
        if (!mounted) return;
        setState(() => _listening = s == SpeechToText.listeningStatus);
        if (s == SpeechToText.doneStatus && _text.isNotEmpty) _finish();
      }

      final ok = await _stt.initialize(onError: onError, onStatus: onStatus);
      // initialize() only registers listeners the first time; rebind for this dialog.
      _stt
        ..errorListener = onError
        ..statusListener = onStatus;
      if (!ok) {
        if (mounted) setState(() => _error = context.l10n.woVoiceUnavailable);
        return;
      }
      await _stt.listen(
        onResult: (r) {
          if (!mounted) return;
          setState(() => _text = r.recognizedWords);
          if (r.finalResult && _text.isNotEmpty) _finish();
        },
        listenOptions: SpeechListenOptions(
          localeId: widget.localeId,
          partialResults: true,
          cancelOnError: true,
          listenFor: const Duration(seconds: 15),
          pauseFor: const Duration(seconds: 3),
          contextualPhrases: const ['kilo', 'kg', 'reps', 'كيلو', 'عدات', 'RPE'],
        ),
      );
    } catch (e) {
      if (mounted) setState(() => _error = context.l10n.woVoiceUnavailable);
    }
  }

  void _finish() {
    if (_done) return;
    _done = true;
    unawaited(_stt.stop());
    Navigator.pop(context, _text);
  }

  @override
  void dispose() {
    if (!_done) unawaited(_stt.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AlertDialog(
      title: Text(l.woVoiceTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_error != null ? Icons.mic_off : Icons.mic,
              size: 56, color: _error != null ? AppColors.danger : (_listening ? AppColors.primary : AppColors.textMuted)),
          const SizedBox(height: 12),
          Text(
            _error ?? (_text.isEmpty ? l.woVoiceExample : _text),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: _text.isEmpty ? AppColors.textMuted : null),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
        if (_error == null) FilledButton(onPressed: _text.isEmpty ? null : _finish, child: Text(l.done)),
      ],
    );
  }
}

class _VoiceConfirmDialog extends StatefulWidget {
  final String transcript;
  final VoiceSet initial;
  const _VoiceConfirmDialog({required this.transcript, required this.initial});

  @override
  State<_VoiceConfirmDialog> createState() => _VoiceConfirmDialogState();
}

class _VoiceConfirmDialogState extends State<_VoiceConfirmDialog> {
  late double _w = widget.initial.weightKg;
  late int _reps = widget.initial.reps;
  late double? _rpe = widget.initial.rpe;
  late String _type = widget.initial.setType;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AlertDialog(
      title: Text(l.woVoiceConfirm),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('"${widget.transcript}"', style: const TextStyle(color: AppColors.textMuted, fontStyle: FontStyle.italic)),
            const SizedBox(height: 12),
            Center(
              child: BigStepper(
                label: l.woWeightKg,
                value: _w,
                step: 2.5,
                decimals: 2,
                onChanged: (v) => setState(() => _w = v),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: BigStepper(
                label: l.woReps,
                value: _reps.toDouble(),
                step: 1,
                min: 1,
                decimals: 0,
                onChanged: (v) => setState(() => _reps = v.round()),
              ),
            ),
            const SizedBox(height: 8),
            Text('RPE', style: context.text.labelLarge),
            RpeSelector(value: _rpe, onChanged: (v) => setState(() => _rpe = v)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              children: [
                for (final t in SetType.all)
                  ChoiceChip(
                    label: Text(setTypeLabel(context, t)),
                    selected: _type == t,
                    onSelected: (_) => setState(() => _type = t),
                  ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
        FilledButton(
          onPressed: () => Navigator.pop(context, VoiceSet(_w, _reps, rpe: _rpe, setType: _type)),
          child: Text(l.woSaveSet),
        ),
      ],
    );
  }
}
