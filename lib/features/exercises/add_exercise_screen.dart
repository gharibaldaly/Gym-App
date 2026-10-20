import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:speech_to_text/speech_to_text.dart';
import 'package:uuid/uuid.dart';

import '../../ai/ai_service.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/context_ext.dart';
import '../../core/widgets/common.dart';
import '../../data/repositories/exercise_repository.dart';
import 'exercise_ai.dart';
import 'exercise_labels.dart';
import 'exercise_media.dart';
import 'exercise_similarity.dart';
import 'widgets/body_map.dart';
import 'widgets/exercise_images.dart';

enum _Stage { describe, suggestions, loading, review }

/// Add a custom exercise: describe it (text / voice / photo) → local "did you
/// mean…?" → Claude structures it → editable review → save as `custom_<uuid>`.
/// Without an API key or internet the same review form is filled manually.
/// Pops with the new (or chosen existing) exercise id.
///
/// With [editExerciseId] it opens the review form for an existing custom exercise.
class AddExerciseScreen extends ConsumerStatefulWidget {
  final String? editExerciseId;
  final String? initialText;
  const AddExerciseScreen({super.key, this.editExerciseId, this.initialText});

  @override
  ConsumerState<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends ConsumerState<AddExerciseScreen> {
  _Stage _stage = _Stage.describe;
  final _desc = TextEditingController();
  Uint8List? _photo;
  List<Exercise> _all = const [];
  List<Exercise> _suggestions = const [];
  List<Exercise> _aiSimilar = const [];
  Exercise? _editing;
  bool _saving = false;

  // speech
  final SpeechToText _speech = SpeechToText();
  bool _speechReady = false;
  bool _listening = false;

  // form
  final _nameEn = TextEditingController();
  final _nameAr = TextEditingController();
  final _stepsEn = TextEditingController();
  final _stepsAr = TextEditingController();
  final _mistakesEn = TextEditingController();
  final _mistakesAr = TextEditingController();
  List<String> _primary = [];
  List<String> _secondary = [];
  String _equipment = 'other';
  String? _force;
  String? _mechanic;
  String _category = 'strength';

  bool get _isEdit => widget.editExerciseId != null;

  @override
  void initState() {
    super.initState();
    if (widget.initialText != null) _desc.text = widget.initialText!;
    if (_isEdit) _loadForEdit();
  }

  Future<void> _loadForEdit() async {
    final e = await ref.read(exerciseRepositoryProvider).byId(widget.editExerciseId!);
    if (!mounted || e == null) return;
    setState(() {
      _editing = e;
      _fillForm(ExerciseDraft.fromExercise(e));
      _stage = _Stage.review;
    });
  }

  @override
  void dispose() {
    if (_listening) _speech.cancel();
    for (final c in [_desc, _nameEn, _nameAr, _stepsEn, _stepsAr, _mistakesEn, _mistakesAr]) {
      c.dispose();
    }
    super.dispose();
  }

  // ---------------------------------------------------------------- input

  Future<void> _toggleMic() async {
    final l = context.l10n;
    if (_listening) {
      await _speech.stop();
      if (mounted) setState(() => _listening = false);
      return;
    }
    if (!_speechReady) {
      try {
        _speechReady = await _speech.initialize(
          onStatus: (s) {
            if ((s == 'done' || s == 'notListening') && mounted) setState(() => _listening = false);
          },
          onError: (_) {
            if (mounted) setState(() => _listening = false);
          },
        );
      } catch (_) {
        _speechReady = false;
      }
    }
    if (!mounted) return;
    if (!_speechReady) {
      context.snack(l.exVoiceUnavailable);
      return;
    }
    final base = _desc.text.trim();
    await _speech.listen(
      onResult: (r) {
        final words = r.recognizedWords;
        _desc.text = base.isEmpty ? words : '$base $words';
        _desc.selection = TextSelection.collapsed(offset: _desc.text.length);
      },
      listenOptions: SpeechListenOptions(
        localeId: context.lang == 'ar' ? 'ar_EG' : 'en_US',
        partialResults: true,
        listenMode: ListenMode.dictation,
        pauseFor: const Duration(seconds: 4),
        listenFor: const Duration(seconds: 60),
      ),
    );
    if (mounted) setState(() => _listening = true);
  }

  Future<void> _pickPhoto(ImageSource source) async {
    try {
      final x = await ImagePicker().pickImage(source: source, maxWidth: 1024, maxHeight: 1024, imageQuality: 90);
      if (x == null) return;
      Uint8List? bytes;
      try {
        bytes = await FlutterImageCompress.compressWithFile(
          x.path,
          minWidth: 1024,
          minHeight: 1024,
          quality: 80,
          format: CompressFormat.jpeg,
        );
      } catch (_) {
        bytes = null;
      }
      bytes ??= await x.readAsBytes();
      if (mounted) setState(() => _photo = bytes);
    } catch (_) {
      if (mounted) context.snack(context.l10n.exPhotoError);
    }
  }

  Future<List<Exercise>> _library() async {
    if (_all.isEmpty) _all = await ref.read(exerciseRepositoryProvider).all();
    return _all;
  }

  bool get _aiAvailable => ref.read(hasApiKeyProvider) && ref.read(isOnlineProvider);

  Future<void> _continue() async {
    final text = _desc.text.trim();
    if (text.isEmpty && _photo == null) {
      context.snack(context.l10n.exDescribeFirst);
      return;
    }
    if (_listening) await _speech.stop();
    final all = await _library();
    final similar = text.isEmpty
        ? <Exercise>[]
        : rankBySimilarity(text, all, (e) => [e.nameEn, e.nameAr], limit: 5, minScore: 0.55)
            .map((m) => m.item)
            .toList();
    if (!mounted) return;
    if (similar.isNotEmpty) {
      setState(() {
        _suggestions = similar;
        _stage = _Stage.suggestions;
      });
      return;
    }
    await _createNew();
  }

  Future<void> _createNew() async {
    if (!_aiAvailable) {
      _manual();
      return;
    }
    final text = _desc.text.trim();
    final lang = context.lang;
    final isAr = context.isAr;
    setState(() => _stage = _Stage.loading);
    try {
      final all = await _library();
      final candidates = text.isEmpty ? <Exercise>[] : similarCandidates(text, all);
      final res = await createExerciseWithAi(
        ref.read(aiServiceProvider),
        description: text,
        lang: lang,
        candidates: candidates,
        imageBase64: _photo == null ? null : base64Encode(_photo!),
      );
      if (!mounted) return;
      final byId = {for (final e in all) e.id: e};
      setState(() {
        _fillForm(res.draft);
        _aiSimilar = [for (final id in res.similarExistingIds) ?byId[id]];
        _stage = _Stage.review;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _stage = _Stage.describe);
      context.snack(aiErrorText(e, ar: isAr));
    }
  }

  void _manual() {
    final text = _desc.text.trim();
    final short = text.length <= 48 ? text : '';
    _fillForm(ExerciseDraft(
      nameAr: context.isAr ? short : '',
      nameEn: context.isAr ? '' : short,
    ));
    setState(() {
      _aiSimilar = const [];
      _stage = _Stage.review;
    });
  }

  // ---------------------------------------------------------------- form

  void _fillForm(ExerciseDraft d) {
    _nameEn.text = d.nameEn;
    _nameAr.text = d.nameAr;
    _stepsEn.text = d.instructionsEn.join('\n');
    _stepsAr.text = d.instructionsAr.join('\n');
    _mistakesEn.text = d.mistakesEn.join('\n');
    _mistakesAr.text = d.mistakesAr.join('\n');
    _primary = [...d.primaryMuscles];
    _secondary = [...d.secondaryMuscles];
    _equipment = kEquipment.contains(d.equipment) ? d.equipment : 'other';
    _force = d.force;
    _mechanic = d.mechanic;
    _category = kCategories.contains(d.category) ? d.category : 'strength';
  }

  List<String> _lines(TextEditingController c) => c.text
      .split('\n')
      .map((s) => s.trim().replaceFirst(RegExp(r'^(\d+[\.\)\-]|[-•*])\s*'), ''))
      .where((s) => s.isNotEmpty)
      .toList();

  ExerciseDraft _draft() => ExerciseDraft(
        nameEn: _nameEn.text.trim(),
        nameAr: _nameAr.text.trim(),
        primaryMuscles: _primary,
        secondaryMuscles: _secondary,
        equipment: _equipment,
        force: _force,
        mechanic: _mechanic,
        category: _category,
        instructionsEn: _lines(_stepsEn),
        instructionsAr: _lines(_stepsAr),
        mistakesEn: _lines(_mistakesEn),
        mistakesAr: _lines(_mistakesAr),
      );

  Future<void> _save() async {
    final l = context.l10n;
    final d = _draft();
    if (!d.isValid) {
      context.snack(l.exNeedNameAndMuscle);
      return;
    }
    setState(() => _saving = true);
    try {
      final id = widget.editExerciseId ?? 'custom_${const Uuid().v4()}';
      String? mediaPath = _editing?.mediaPath;
      if (_photo != null) {
        final dir = await customExerciseMediaDir();
        final file = File(p.join(dir.path, '${id}_${DateTime.now().millisecondsSinceEpoch}.jpg'));
        await file.writeAsBytes(_photo!, flush: true);
        final old = _editing?.mediaPath;
        if (old != null && old != file.path) {
          try {
            await File(old).delete();
          } catch (_) {}
        }
        mediaPath = file.path;
      }
      await ref.read(exerciseRepositoryProvider).insertCustom(d.toCompanion(id, mediaPath: mediaPath));
      if (!mounted) return;
      context.snack(l.exSaved);
      Navigator.of(context).pop(id);
    } catch (e) {
      if (mounted) context.snack('${l.errorGeneric}: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  // ---------------------------------------------------------------- UI

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final canPop = _isEdit || _stage == _Stage.describe;
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _stage != _Stage.loading) setState(() => _stage = _Stage.describe);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEdit ? l.exEditTitle : (_stage == _Stage.review ? l.exReviewTitle : l.exAddTitle)),
          actions: [
            if (_stage == _Stage.review)
              TextButton(onPressed: _saving ? null : _save, child: Text(l.save)),
          ],
        ),
        body: switch (_stage) {
          _Stage.describe => _describe(context),
          _Stage.suggestions => _suggestionsView(context),
          _Stage.loading => _loadingView(context),
          _Stage.review => _review(context),
        },
      ),
    );
  }

  Widget _describe(BuildContext context) {
    final l = context.l10n;
    final aiOn = ref.watch(hasApiKeyProvider) && ref.watch(isOnlineProvider);
    return ListView(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 32),
      children: [
        const AiUnavailableBanner(),
        if (!aiOn)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(l.exAiOffManual, style: const TextStyle(color: AppColors.textMuted)),
          ),
        Text(l.exDescribeTitle, style: context.text.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        TextField(
          controller: _desc,
          minLines: 3,
          maxLines: 6,
          textInputAction: TextInputAction.newline,
          decoration: InputDecoration(
            hintText: l.exDescribeHint,
            suffixIcon: Padding(
              padding: const EdgeInsetsDirectional.only(end: 4),
              child: IconButton.filledTonal(
                tooltip: _listening ? l.exVoiceListening : l.exVoiceStart,
                iconSize: 28,
                onPressed: _toggleMic,
                icon: Icon(_listening ? Icons.stop : Icons.mic, color: _listening ? AppColors.danger : null),
              ),
            ),
          ),
        ),
        if (_listening)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(children: [
              const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2)),
              const SizedBox(width: 8),
              Text(l.exVoiceListening, style: const TextStyle(color: AppColors.primary)),
            ]),
          ),
        const SizedBox(height: 20),
        Text(l.exPhotoOptional, style: context.text.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        _photoRow(context),
        const SizedBox(height: 28),
        SizedBox(
          height: 56,
          child: FilledButton.icon(
            onPressed: _continue,
            icon: Icon(aiOn ? Icons.auto_awesome : Icons.arrow_forward),
            label: Text(aiOn ? l.exCreateWithAi : l.exContinue),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 52,
          child: OutlinedButton.icon(
            onPressed: _manual,
            icon: const Icon(Icons.edit_note),
            label: Text(l.exFillManually),
          ),
        ),
      ],
    );
  }

  Widget _photoRow(BuildContext context) {
    final l = context.l10n;
    final existing = _editing?.mediaPath;
    Widget? preview;
    if (_photo != null) {
      preview = Image.memory(_photo!, width: 96, height: 96, fit: BoxFit.cover);
    } else if (existing != null && File(existing).existsSync()) {
      preview = Image.file(File(existing), width: 96, height: 96, fit: BoxFit.cover);
    }
    return Row(
      children: [
        if (preview != null) ...[
          Stack(children: [
            ClipRRect(borderRadius: BorderRadius.circular(12), child: preview),
            if (_photo != null)
              PositionedDirectional(
                top: 0,
                end: 0,
                child: IconButton(
                  tooltip: l.exPhotoRemove,
                  visualDensity: VisualDensity.compact,
                  style: IconButton.styleFrom(backgroundColor: Colors.black54),
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => setState(() => _photo = null),
                ),
              ),
          ]),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Wrap(spacing: 8, runSpacing: 8, children: [
            OutlinedButton.icon(
              onPressed: () => _pickPhoto(ImageSource.camera),
              icon: const Icon(Icons.photo_camera_outlined),
              label: Text(l.exPhotoCamera),
            ),
            OutlinedButton.icon(
              onPressed: () => _pickPhoto(ImageSource.gallery),
              icon: const Icon(Icons.photo_library_outlined),
              label: Text(l.exPhotoGallery),
            ),
          ]),
        ),
      ],
    );
  }

  Widget _exerciseOption(Exercise e) {
    final lang = context.lang;
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsetsDirectional.fromSTEB(12, 6, 8, 6),
        leading: ExerciseThumb(exercise: e, size: 52),
        title: Text(e.name(lang), style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(
          [...e.primaryMuscles.map((m) => muscleShortLabel(m, lang)), equipmentLabel(e.equipment, lang)]
              .where((s) => s.isNotEmpty)
              .join(' • '),
        ),
        trailing: FilledButton(
          onPressed: () => Navigator.of(context).pop(e.id),
          child: Text(context.l10n.exUseExisting),
        ),
      ),
    );
  }

  Widget _suggestionsView(BuildContext context) {
    final l = context.l10n;
    return ListView(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 32),
      children: [
        Text(l.exDidYouMean, style: context.text.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text(l.exDidYouMeanBody, style: const TextStyle(color: AppColors.textMuted)),
        const SizedBox(height: 12),
        for (final e in _suggestions) _exerciseOption(e),
        const SizedBox(height: 16),
        SizedBox(
          height: 52,
          child: OutlinedButton.icon(
            onPressed: _createNew,
            icon: const Icon(Icons.add),
            label: Text(l.exCreateNewAnyway),
          ),
        ),
      ],
    );
  }

  Widget _loadingView(BuildContext context) => Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(context.l10n.exAiWorking),
        ]),
      );

  Widget _review(BuildContext context) {
    final l = context.l10n;
    final lang = context.lang;
    InputDecoration deco(String label, {String? hint}) =>
        InputDecoration(labelText: label, hintText: hint, alignLabelWithHint: true);

    Widget muscleChips(List<String> selected, ValueChanged<String> toggle, {required bool primary}) => Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final m in kMuscles)
              FilterChip(
                label: Text(muscleShortLabel(m, lang)),
                selected: selected.contains(m),
                showCheckmark: false,
                selectedColor: primary ? AppColors.primaryDark : AppColors.primaryLight,
                labelStyle: TextStyle(
                  color: selected.contains(m) ? (primary ? Colors.white : AppColors.onPrimary) : AppColors.text,
                ),
                onSelected: (_) => toggle(m),
              ),
          ],
        );

    DropdownButtonFormField<String?> dropdown(
      String label,
      String? value,
      List<String> options,
      String Function(String?, String) labelOf,
      ValueChanged<String?> onChanged, {
      bool nullable = false,
    }) =>
        DropdownButtonFormField<String?>(
          initialValue: value,
          isExpanded: true,
          decoration: deco(label),
          items: [
            if (nullable) DropdownMenuItem<String?>(value: null, child: Text(l.exNone)),
            for (final o in options) DropdownMenuItem<String?>(value: o, child: Text(labelOf(o, lang))),
          ],
          onChanged: onChanged,
        );

    return ListView(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 40),
      children: [
        if (_aiSimilar.isNotEmpty) ...[
          Card(
            color: AppColors.warning.withValues(alpha: 0.12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(children: [
                const Icon(Icons.info_outline, color: AppColors.warning),
                const SizedBox(width: 10),
                Expanded(child: Text(l.exAiSimilarFound, style: const TextStyle(fontWeight: FontWeight.w700))),
              ]),
            ),
          ),
          for (final e in _aiSimilar) _exerciseOption(e),
          const SizedBox(height: 12),
        ],
        TextField(controller: _nameEn, decoration: deco(l.exNameEn), textCapitalization: TextCapitalization.words),
        const SizedBox(height: 12),
        TextField(controller: _nameAr, decoration: deco(l.exNameAr), textDirection: TextDirection.rtl),
        const SizedBox(height: 16),
        BodyMap(primary: _primary, secondary: _secondary, height: 200),
        const SizedBox(height: 12),
        Text(l.exPrimaryMuscles, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        muscleChips(_primary, (m) {
          setState(() {
            if (_primary.contains(m)) {
              _primary.remove(m);
            } else {
              _primary.add(m);
              _secondary.remove(m);
            }
          });
        }, primary: true),
        const SizedBox(height: 14),
        Text(l.exSecondaryMuscles, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        muscleChips(_secondary, (m) {
          setState(() {
            if (_secondary.contains(m)) {
              _secondary.remove(m);
            } else {
              _secondary.add(m);
              _primary.remove(m);
            }
          });
        }, primary: false),
        const SizedBox(height: 18),
        dropdown(l.exFieldEquipment, _equipment, kEquipment, equipmentLabel,
            (v) => setState(() => _equipment = v ?? 'other')),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
            child: dropdown(l.exFieldForce, _force, kForces, forceLabel, (v) => setState(() => _force = v),
                nullable: true),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: dropdown(l.exFieldMechanic, _mechanic, kMechanics, mechanicLabel,
                (v) => setState(() => _mechanic = v),
                nullable: true),
          ),
        ]),
        const SizedBox(height: 12),
        dropdown(l.exFieldCategory, _category, kCategories, categoryLabel,
            (v) => setState(() => _category = v ?? 'strength')),
        const SizedBox(height: 18),
        Text(l.exPhotoOptional, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        _photoRow(context),
        const SizedBox(height: 18),
        TextField(controller: _stepsAr, minLines: 3, maxLines: 10, decoration: deco(l.exStepsAr, hint: l.exOnePerLine)),
        const SizedBox(height: 12),
        TextField(controller: _stepsEn, minLines: 3, maxLines: 10, decoration: deco(l.exStepsEn, hint: l.exOnePerLine)),
        const SizedBox(height: 12),
        TextField(
            controller: _mistakesAr, minLines: 2, maxLines: 8, decoration: deco(l.exMistakesAr, hint: l.exOnePerLine)),
        const SizedBox(height: 12),
        TextField(
            controller: _mistakesEn, minLines: 2, maxLines: 8, decoration: deco(l.exMistakesEn, hint: l.exOnePerLine)),
        const SizedBox(height: 24),
        SizedBox(
          height: 56,
          child: FilledButton.icon(
            onPressed: _saving ? null : _save,
            icon: _saving
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.check),
            label: Text(l.exSave),
          ),
        ),
      ],
    );
  }
}
