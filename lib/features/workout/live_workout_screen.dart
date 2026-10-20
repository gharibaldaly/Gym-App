import 'dart:async';
import 'dart:convert';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibration/vibration.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../core/calc/strength_calc.dart';
import '../../core/navigation.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/context_ext.dart';
import '../../core/widgets/common.dart';
import '../../data/repositories/exercise_repository.dart';
import '../exercises/exercise_library_screen.dart';
import 'deload.dart';
import 'session_summary_screen.dart';
import 'widgets/cardio_section.dart';
import 'widgets/live_exercise_card.dart';
import 'widgets/rest_timer.dart';
import 'widgets/substitute_sheet.dart';
import 'widgets/voice_set_input.dart';
import 'widgets/workout_widgets.dart';
import 'workout_logic.dart';
import 'workout_repository.dart';

/// One row of the live workout (a plan exercise, possibly substituted, or an extra).
class LiveEntry {
  final String key;
  final String exerciseId;
  final PlanExercise? pe;
  final bool substituted;
  const LiveEntry(this.key, this.exerciseId, this.pe, {this.substituted = false});
}

/// Plan exercises (with today's swaps) + extras added during the workout + any other
/// exercise that already has sets in this session.
List<LiveEntry> buildLiveEntries({
  required List<PlanExercise> plan,
  required Map<String, String> swaps,
  required List<String> extras,
  required List<String> loggedExerciseIds,
}) {
  final out = <LiveEntry>[];
  final seen = <String>{};
  for (final pe in plan) {
    final sub = swaps['${pe.id}'];
    final id = sub ?? pe.exerciseId;
    out.add(LiveEntry('pe${pe.id}', id, pe, substituted: sub != null && sub != pe.exerciseId));
    seen.add(id);
  }
  for (final id in [...extras, ...loggedExerciseIds]) {
    if (seen.add(id)) out.add(LiveEntry('x$id', id, null));
  }
  return out;
}

String swapTodayKey(DateTime day) => 'swap_today_${ymd(day)}';
String _extrasKey(int sessionId) => 'wo_extra_$sessionId';
String _checksKey(int sessionId) => 'wo_checks_$sessionId';

class LiveWorkoutScreen extends ConsumerStatefulWidget {
  final int? planDayId;
  final int? sessionId;
  const LiveWorkoutScreen({super.key, this.planDayId, this.sessionId});

  @override
  ConsumerState<LiveWorkoutScreen> createState() => _LiveWorkoutScreenState();
}

class _LiveWorkoutScreenState extends ConsumerState<LiveWorkoutScreen> {
  int? _sessionId;
  int? _planDayId;
  bool _resolving = true;
  bool _starting = false;
  bool _finishing = false;
  String? _expandedKey;
  Map<String, String> _swaps = {};
  List<String> _extras = [];
  Set<String> _checks = {};
  final _rest = RestTimerController();
  final _confetti = ConfettiController(duration: const Duration(seconds: 2));
  final _notes = TextEditingController();
  Timer? _notesDebounce;
  String? _prBanner;
  Timer? _prTimer;

  WorkoutRepository get _repo => ref.read(workoutRepositoryProvider);

  @override
  void initState() {
    super.initState();
    unawaited(_safe(WakelockPlus.enable));
    _resolve();
  }

  @override
  void dispose() {
    unawaited(_safe(WakelockPlus.disable));
    _flushNotes();
    _notesDebounce?.cancel();
    _prTimer?.cancel();
    _rest.dispose();
    _confetti.dispose();
    _notes.dispose();
    super.dispose();
  }

  static Future<void> _safe(Future<void> Function() f) async {
    try {
      await f();
    } catch (e) {
      debugPrint('live workout: $e');
    }
  }

  // ------------------------------------------------------------- session

  Future<void> _resolve() async {
    final repo = _repo;
    WorkoutSession? s;
    if (widget.sessionId != null) {
      s = await repo.session(widget.sessionId!);
      _planDayId = s?.planDayId ?? widget.planDayId;
    } else {
      _planDayId = widget.planDayId;
      if (_planDayId == null) {
        final d = await repo.activeDayForWeekday(DateTime.now().weekday);
        if (d != null && !d.isRest) _planDayId = d.id;
      }
      s = await repo.sessionOn(DateTime.now(), planDayId: _planDayId);
    }
    if (s != null && s.status == SessionStatus.missed) s = null;
    if (s != null && s.status != SessionStatus.inProgress && dayOf(s.date) == today()) {
      await repo.reopenSession(s.id);
    }
    if (!mounted) return;
    setState(() {
      _resolving = false;
      if (s != null) _attach(s);
    });
  }

  void _attach(WorkoutSession s) {
    final prefs = ref.read(sharedPrefsProvider);
    _sessionId = s.id;
    _swaps = _readMap(prefs.getString(swapTodayKey(s.date)));
    _extras = decodeStringList(prefs.getString(_extrasKey(s.id)));
    _checks = decodeStringList(prefs.getString(_checksKey(s.id))).toSet();
    _notes.text = s.notes ?? '';
  }

  static Map<String, String> _readMap(String? raw) {
    if (raw == null) return {};
    try {
      return (jsonDecode(raw) as Map).map((k, v) => MapEntry('$k', '$v'));
    } catch (_) {
      return {};
    }
  }

  Future<int> _ensureSession() async {
    if (_sessionId != null) return _sessionId!;
    final prefs = ref.read(sharedPrefsProvider);
    final day = _planDayId == null ? null : await _repo.day(_planDayId!);
    final id = await _repo.startSession(
      planDayId: _planDayId,
      name: day?.name,
      isDeload: isDeloadWeekActive(prefs),
    );
    final s = await _repo.session(id);
    if (mounted && s != null) setState(() => _attach(s));
    return id;
  }

  Future<void> _start() async {
    setState(() => _starting = true);
    try {
      await _ensureSession();
      HapticFeedback.mediumImpact();
    } finally {
      if (mounted) setState(() => _starting = false);
    }
  }

  // ------------------------------------------------------------- actions

  Future<void> _saveSet(Exercise ex, double weight, int reps, double? rpe, String type, List<LiveEntry> entries) async {
    final sid = await _ensureSession();
    final r = await _repo.addSet(sessionId: sid, exerciseId: ex.id, weightKg: weight, reps: reps, rpe: rpe, setType: type);
    HapticFeedback.mediumImpact();
    if (r.prs.isNotEmpty) _celebrate(ex, r.prs);
    // Auto-advance to the next unfinished exercise when this one is done.
    if (isWorkingSet(type)) {
      final sets = await _repo.sessionSets(sid);
      final recovery = _recovery();
      int planned(LiveEntry e) => e.pe == null ? 0 : (recovery?.applySets(e.pe!.sets) ?? e.pe!.sets);
      int done(LiveEntry e) => sets.where((s) => s.exerciseId == e.exerciseId && isWorkingSet(s.setType)).length;
      final cur = entries.where((e) => e.exerciseId == ex.id).firstOrNull;
      if (cur != null && planned(cur) > 0 && done(cur) >= planned(cur)) {
        final next = entries.where((e) => e.pe != null && done(e) < planned(e)).firstOrNull;
        if (next != null && mounted) setState(() => _expandedKey = next.key);
      }
    }
  }

  RecoveryAdjust? _recovery() => RecoveryAdjust.parse(ref.read(sharedPrefsProvider).getString(recoveryAdjustKey(today())));

  void _celebrate(Exercise ex, Set<PrType> prs) {
    _confetti.play();
    HapticFeedback.heavyImpact();
    unawaited(_safe(() async {
      if (await Vibration.hasVibrator()) await Vibration.vibrate(pattern: const [0, 300, 120, 300, 120, 600]);
    }));
    _prTimer?.cancel();
    setState(() => _prBanner = context.l10n.woPrBanner(ex.name(context.lang), prTypesLabel(context, prs)));
    _prTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) setState(() => _prBanner = null);
    });
  }

  void _startRest(int seconds) {
    final l = context.l10n;
    _rest.start(seconds, title: l.woRestDoneTitle, body: l.woRestDoneBody);
  }

  Future<void> _substitute(LiveEntry e, Exercise ex) async {
    final c = await showSubstituteSheet(context, exercise: ex, askScope: e.pe != null);
    if (c == null || !mounted) return;
    final prefs = ref.read(sharedPrefsProvider);
    final s = _sessionId == null ? null : await _repo.session(_sessionId!);
    final day = s?.date ?? today();
    if (e.pe != null) {
      if (c.always) {
        await _repo.swapPlanExercise(e.pe!.id, c.exerciseId);
        _swaps.remove('${e.pe!.id}');
      } else {
        _swaps['${e.pe!.id}'] = c.exerciseId;
      }
      await prefs.setString(swapTodayKey(day), jsonEncode(_swaps));
    } else {
      final sid = await _ensureSession();
      final i = _extras.indexOf(e.exerciseId);
      if (i >= 0) {
        _extras[i] = c.exerciseId;
      } else {
        _extras.add(c.exerciseId);
      }
      await prefs.setString(_extrasKey(sid), jsonEncode(_extras));
    }
    if (mounted) setState(() {});
  }

  Future<void> _editNote(Exercise ex, String? current) async {
    final l = context.l10n;
    final c = TextEditingController(text: current ?? '');
    final r = await showDialog<String>(
      context: context,
      builder: (d) => AlertDialog(
        title: Text(ex.name(context.lang)),
        content: TextField(
          controller: c,
          autofocus: true,
          maxLines: 3,
          decoration: InputDecoration(hintText: l.woExerciseNoteHint),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(d), child: Text(l.cancel)),
          FilledButton(onPressed: () => Navigator.pop(d, c.text), child: Text(l.save)),
        ],
      ),
    );
    c.dispose();
    if (r == null) return;
    final sid = await _ensureSession();
    await _repo.setExerciseNote(sid, ex.id, r);
  }

  Future<void> _voice(Exercise ex, List<LiveEntry> entries) async {
    final v = await captureVoiceSet(context, ref);
    if (v == null) return;
    await _saveSet(ex, v.weightKg, v.reps, v.rpe, v.setType, entries);
  }

  Future<void> _deleteSet(SetLog s) async {
    final l = context.l10n;
    final ok = await confirmDialog(context,
        title: l.woDeleteSetTitle, body: setText(context, s.weightKg, s.reps), confirm: l.delete, danger: true);
    if (ok) await _repo.deleteSet(s.id);
  }

  Future<void> _addExercise() async {
    final id = await push<String>(context, const ExerciseLibraryScreen(pickMode: true));
    if (id == null) return;
    final sid = await _ensureSession();
    if (!_extras.contains(id)) _extras.add(id);
    await ref.read(sharedPrefsProvider).setString(_extrasKey(sid), jsonEncode(_extras));
    if (mounted) setState(() => _expandedKey = 'x$id');
  }

  void _toggleCheck(String key) {
    final sid = _sessionId;
    setState(() => _checks.contains(key) ? _checks.remove(key) : _checks.add(key));
    if (sid != null) unawaited(ref.read(sharedPrefsProvider).setString(_checksKey(sid), jsonEncode(_checks.toList())));
  }

  void _onNotesChanged(String _) {
    _notesDebounce?.cancel();
    _notesDebounce = Timer(const Duration(milliseconds: 800), _flushNotes);
  }

  void _flushNotes() {
    final sid = _sessionId;
    if (sid == null) return;
    unawaited(_repo.updateSessionNotes(sid, _notes.text));
  }

  Future<void> _finish(List<LiveEntry> entries) async {
    final l = context.l10n;
    final sid = _sessionId;
    if (sid == null) {
      Navigator.of(context).maybePop();
      return;
    }
    setState(() => _finishing = true);
    try {
      final sets = await _repo.sessionSets(sid);
      final cardio = await _repo.watchCardio(sid).first;
      if (sets.isEmpty && cardio.isEmpty) {
        if (!mounted) return;
        final discard = await confirmDialog(context,
            title: l.woNothingLoggedTitle, body: l.woNothingLoggedBody, confirm: l.woDiscard, danger: true);
        if (discard) {
          _rest.skip();
          await _repo.deleteSession(sid);
          if (mounted) Navigator.of(context).maybePop();
        }
        return;
      }
      final recovery = _recovery();
      final progress = <PlannedProgress>[
        for (final e in entries)
          if (e.pe != null)
            (
              planned: recovery?.applySets(e.pe!.sets) ?? e.pe!.sets,
              done: sets.where((s) => s.exerciseId == e.exerciseId && isWorkingSet(s.setType)).length,
            ),
      ];
      final status = computeSessionStatus(progress, anythingLogged: true);
      if (status == SessionStatus.partial && mounted) {
        final ok = await confirmDialog(context, title: l.woFinishPartialTitle, body: l.woFinishPartialBody, confirm: l.woFinish);
        if (!ok) return;
      }
      final volume = sessionVolume(sets.map((s) => (weight: s.weightKg, reps: s.reps, setType: s.setType)));
      _notesDebounce?.cancel();
      await _repo.finishSession(sid, status: status, volume: volume, notes: _notes.text);
      _rest.skip();
      HapticFeedback.heavyImpact();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => SessionSummaryScreen(sessionId: sid, justFinished: true)),
      );
    } finally {
      if (mounted) setState(() => _finishing = false);
    }
  }

  // ------------------------------------------------------------- UI

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    if (_resolving) {
      return Scaffold(appBar: AppBar(), body: const Center(child: CircularProgressIndicator()));
    }
    final day = _planDayId == null ? null : ref.watch(planDayProvider(_planDayId!)).value;
    final plan = _planDayId == null
        ? const <PlanExerciseItem>[]
        : (ref.watch(planDayExercisesProvider(_planDayId!)).value ?? const <PlanExerciseItem>[]);
    final sid = _sessionId;
    final session = sid == null ? null : ref.watch(sessionProvider(sid)).value;
    final sets = sid == null ? const <SetLog>[] : (ref.watch(sessionSetsProvider(sid)).value ?? const <SetLog>[]);
    final notes = sid == null
        ? const <SessionExerciseNote>[]
        : (ref.watch(sessionNotesProvider(sid)).value ?? const <SessionExerciseNote>[]);
    final logged = <String>[];
    for (final s in sets) {
      if (!logged.contains(s.exerciseId)) logged.add(s.exerciseId);
    }
    final entries = buildLiveEntries(
      plan: plan.map((e) => e.pe).toList(),
      swaps: _swaps,
      extras: _extras,
      loggedExerciseIds: logged,
    );
    final prefs = ref.read(sharedPrefsProvider);
    final deload = session?.isDeload == true || isDeloadWeekActive(prefs);
    final recovery = _recovery();
    final title = day?.name ?? session?.name ?? l.woFreeWorkout;

    if (sid == null) return _buildPreStart(context, title, day, plan, deload, recovery);

    final expanded = _expandedKey ??
        entries
            .where((e) =>
                sets.where((s) => s.exerciseId == e.exerciseId && isWorkingSet(s.setType)).length <
                (e.pe == null ? 1 : (recovery?.applySets(e.pe!.sets) ?? e.pe!.sets)))
            .firstOrNull
            ?.key ??
        entries.firstOrNull?.key;
    final warmup = decodeStringList(day?.warmupJson);
    final cooldown = decodeStringList(day?.cooldownJson);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, overflow: TextOverflow.ellipsis),
            if (session?.startedAt != null)
              ElapsedTimerText(
                startedAt: session!.startedAt!,
                style: const TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w700),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: _finishing ? null : () => _finish(entries),
            child: Text(l.woFinish, style: const TextStyle(fontWeight: FontWeight.w800)),
          ),
        ],
      ),
      bottomNavigationBar: RestTimerBar(controller: _rest),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 40),
            children: [
              if (deload || (recovery != null && !recovery.isNeutral))
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      if (deload) Pill(l.woDeloadActiveShort, color: AppColors.info, icon: Icons.south),
                      if (recovery != null && !recovery.isNeutral)
                        Pill(
                          l.woRecoveryPill(((1 - recovery.weightFactor) * 100).round(), -recovery.setsDelta),
                          color: AppColors.warning,
                          icon: Icons.battery_alert,
                        ),
                    ],
                  ),
                ),
              if (warmup.isNotEmpty)
                _ChecklistCard(
                  title: l.woWarmup,
                  icon: Icons.local_fire_department_outlined,
                  steps: warmup,
                  prefix: 'w',
                  checks: _checks,
                  onToggle: _toggleCheck,
                ),
              if (entries.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(l.woFreeWorkoutHint, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textMuted)),
                ),
              for (var i = 0; i < entries.length; i++)
                LiveExerciseCard(
                  key: ValueKey('${entries[i].key}:${entries[i].exerciseId}'),
                  index: i,
                  exerciseId: entries[i].exerciseId,
                  planExercise: entries[i].pe,
                  sessionId: sid,
                  sets: sets.where((s) => s.exerciseId == entries[i].exerciseId).toList(),
                  note: notes.where((n) => n.exerciseId == entries[i].exerciseId).firstOrNull?.note,
                  expanded: expanded == entries[i].key,
                  substituted: entries[i].substituted,
                  onExpand: () => setState(() => _expandedKey = expanded == entries[i].key ? '' : entries[i].key),
                  onSave: (ex, w, r, rpe, t) => _saveSet(ex, w, r, rpe, t, entries),
                  onRest: _startRest,
                  onSubstitute: (ex) => _substitute(entries[i], ex),
                  onNote: (ex) => _editNote(ex, notes.where((n) => n.exerciseId == ex.id).firstOrNull?.note),
                  onVoice: (ex) => _voice(ex, entries),
                  onDeleteSet: _deleteSet,
                ),
              const SizedBox(height: 4),
              OutlinedButton.icon(onPressed: _addExercise, icon: const Icon(Icons.add), label: Text(l.woAddExercise)),
              const SizedBox(height: 8),
              CardioSection(sessionId: sid, ensureSession: _ensureSession),
              if (cooldown.isNotEmpty)
                _ChecklistCard(
                  title: l.woCooldown,
                  icon: Icons.self_improvement,
                  steps: cooldown,
                  prefix: 'c',
                  checks: _checks,
                  onToggle: _toggleCheck,
                ),
              SectionCard(
                title: l.woSessionNotes,
                child: TextField(
                  controller: _notes,
                  maxLines: 3,
                  minLines: 2,
                  decoration: InputDecoration(hintText: l.woSessionNotesHint),
                  onChanged: _onNotesChanged,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 60,
                child: FilledButton.icon(
                  onPressed: _finishing ? null : () => _finish(entries),
                  icon: const Icon(Icons.flag),
                  label: Text(l.woFinishWorkout, style: const TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confetti,
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: 30,
              emissionFrequency: 0.08,
              gravity: 0.25,
              colors: const [AppColors.primary, AppColors.warning, AppColors.info, Colors.white],
            ),
          ),
          PositionedDirectional(
            top: 8,
            start: 12,
            end: 12,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _prBanner == null
                  ? const SizedBox.shrink()
                  : Material(
                      key: ValueKey(_prBanner),
                      color: AppColors.warning,
                      borderRadius: BorderRadius.circular(14),
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            const Icon(Icons.emoji_events, color: Colors.black, size: 32),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(_prBanner!,
                                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 16)),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreStart(
    BuildContext context,
    String title,
    PlanDay? day,
    List<PlanExerciseItem> plan,
    bool deload,
    RecoveryAdjust? recovery,
  ) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
        children: [
          if (deload) Pill(l.woDeloadActiveShort, color: AppColors.info, icon: Icons.south),
          if (recovery != null && !recovery.isNeutral) ...[
            const SizedBox(height: 6),
            Pill(l.woRecoveryPill(((1 - recovery.weightFactor) * 100).round(), -recovery.setsDelta),
                color: AppColors.warning, icon: Icons.battery_alert),
          ],
          if ((day?.focus ?? '').isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(day!.focus!, style: const TextStyle(color: AppColors.textMuted)),
          ],
          const SizedBox(height: 8),
          if (plan.isEmpty)
            EmptyState(icon: Icons.fitness_center, text: l.woFreeWorkoutHint)
          else
            SectionCard(
              title: l.woExercises,
              child: Column(
                children: [
                  for (final it in plan)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(it.ex.name(context.lang)),
                      subtitle: Text(setsRepsText(recovery?.applySets(it.pe.sets) ?? it.pe.sets, it.pe.repMin, it.pe.repMax)),
                      trailing: it.pe.suggestedWeightKg == null || it.pe.suggestedWeightKg == 0
                          ? null
                          : Text('${fmtNum(it.pe.suggestedWeightKg!, maxDecimals: 2)} ${l.kg}'),
                    ),
                ],
              ),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SizedBox(
          height: 64,
          child: FilledButton.icon(
            onPressed: _starting ? null : _start,
            icon: const Icon(Icons.play_arrow, size: 30),
            label: Text(plan.isEmpty ? l.woStartEmpty : l.woStartToday, style: const TextStyle(fontSize: 18)),
          ),
        ),
      ),
    );
  }
}

class _ChecklistCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> steps;
  final String prefix;
  final Set<String> checks;
  final ValueChanged<String> onToggle;
  const _ChecklistCard({
    required this.title,
    required this.icon,
    required this.steps,
    required this.prefix,
    required this.checks,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final checked = {for (var i = 0; i < steps.length; i++) if (checks.contains('$prefix$i')) i};
    final all = checked.length == steps.length;
    return Card(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: !all,
          leading: Icon(all ? Icons.check_circle : icon, color: AppColors.primary),
          title: Text('$title (${checked.length}/${steps.length})', style: const TextStyle(fontWeight: FontWeight.w700)),
          childrenPadding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 8),
          children: [
            StepsList(steps: steps, checked: checked, onToggle: (i) => onToggle('$prefix$i')),
          ],
        ),
      ),
    );
  }
}
