import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../ai/ai_service.dart';
import '../../core/providers.dart';
import '../../data/repositories/exercise_repository.dart';
import '../../data/repositories/profile_repository.dart';
import 'plan_templates.dart';
import 'workout_logic.dart';
import 'workout_repository.dart';

/// Builds the weekly workout plan with Claude (Opus) from the profile and saves it (inactive until approved).
///
/// Throws [AiNoKeyException] / [AiOfflineException] / [AiException] from the AI layer –
/// callers show `aiErrorText` and may fall back to [ensureNoKeyFallback] / [buildTemplatePlan].
class WorkoutPlanGenerator {
  final Ref ref;
  WorkoutPlanGenerator(this.ref);

  WorkoutRepository get _repo => ref.read(workoutRepositoryProvider);

  /// Returns the new plan id.
  Future<int> generateAndSave() async {
    final profile = await ref.read(profileRepositoryProvider).get();
    if (profile == null) throw StateError('No profile');
    final all = await ref.read(exerciseRepositoryProvider).all();
    final candidates = selectPlanCandidates(all, location: profile.location, level: profile.level);
    if (candidates.strength.isEmpty) throw StateError('Exercise library is empty');
    final knownIds = {...candidates.strength.map((e) => e.id), ...candidates.stretches.map((e) => e.id)};
    final days = trainingDaysOf(profile);
    final lang = profile.language;

    final json = await ref.read(aiServiceProvider).structured(
          feature: AiFeature.initialPlan,
          system: AiService.systemBlocks(planSystemPrompt),
          prompt: buildPlanPrompt(profile: profile, days: days, candidates: candidates, lang: lang),
          schema: workoutPlanSchema,
          extraValidate: (j) => validatePlanJson(j, knownIds: knownIds, trainingDays: days),
          maxTokens: 20000,
        );
    return _repo.savePlanJson(json, source: 'ai', rawJson: jsonEncode(json));
  }

  /// For users without an API key: makes sure there is a plan to use offline.
  /// Returns the active plan, else the newest pending (unapproved) plan, else a newly
  /// built template plan (saved inactive so it goes through review like an AI plan).
  Future<int> ensureNoKeyFallback() async {
    final active = await _repo.activePlan();
    if (active != null) return active.id;
    final pending = await _repo.watchPendingPlans().first;
    if (pending.isNotEmpty) return pending.first.id;
    return buildTemplatePlan();
  }

  /// Always builds a new local template plan (no AI) from the profile. Returns its id.
  Future<int> buildTemplatePlan() async {
    final profile = await ref.read(profileRepositoryProvider).get();
    final all = await ref.read(exerciseRepositoryProvider).all();
    final json = buildTemplatePlanJson(TemplateInput(
      days: profile == null ? const [] : trainingDaysOf(profile),
      split: profile?.splitPreference,
      location: profile?.location,
      level: profile?.level,
      goal: profile?.goal,
      sex: profile?.sex,
      sessionMinutes: profile?.sessionMinutes,
      bodyweightKg: profile?.weightKg,
      lang: profile?.language ?? ref.read(localeProvider),
      available: all.map((e) => e.id).toSet(),
    ));
    return _repo.savePlanJson(json, source: 'template');
  }
}

final workoutPlanGeneratorProvider = Provider<WorkoutPlanGenerator>((ref) => WorkoutPlanGenerator(ref));

/// The user's training weekdays; falls back to a spread derived from days/week.
List<int> trainingDaysOf(UserProfile p) {
  final d = p.trainingDays.where((x) => x >= 1 && x <= 7).toSet().toList()..sort();
  if (d.isNotEmpty) return d;
  return defaultTrainingDays(p.daysPerWeek ?? 3);
}

/// Sensible default weekdays (Egyptian week starts Saturday).
List<int> defaultTrainingDays(int n) => [
      ...switch (n.clamp(1, 7)) {
      1 => const [6],
      2 => const [6, 2],
      3 => const [6, 1, 3],
      4 => const [6, 7, 2, 3],
      5 => const [6, 7, 1, 3, 4],
      6 => const [6, 7, 1, 2, 3, 4],
      _ => const [1, 2, 3, 4, 5, 6, 7],
    }
    ]..sort();

class PlanCandidates {
  final List<Exercise> strength;
  final List<Exercise> stretches;
  const PlanCandidates(this.strength, this.stretches);

  static String line(Exercise e) =>
      '${e.id}|${e.nameEn}|${e.primaryMuscles.join('+')}|${e.equipment ?? 'none'}';
}

const _homeEquipment = {null, 'body only', 'dumbbell', 'bands', 'kettlebells', 'exercise ball', 'medicine ball', 'foam roll'};
const _limitedEquipment = {
  null,
  'body only',
  'dumbbell',
  'barbell',
  'cable',
  'machine',
  'bands',
  'kettlebells',
  'e-z curl bar',
  'exercise ball',
  'medicine ball',
  'foam roll',
};

const _commonWords = [
  'bench press',
  'squat',
  'deadlift',
  'row',
  'pulldown',
  'pullup',
  'pull-up',
  'chin',
  'curl',
  'press',
  'raise',
  'extension',
  'fly',
  'flye',
  'lunge',
  'dip',
  'push',
  'leg press',
  'calf',
  'crunch',
  'plank',
  'hip thrust',
  'pushdown',
  'face pull',
  'shrug',
  'crossover',
  'bridge',
];

bool _equipmentOk(String? equipment, String? location) => switch (location) {
      'home' => _homeEquipment.contains(equipment),
      'limited_gym' => _limitedEquipment.contains(equipment),
      _ => true,
    };

/// Picks ~300 realistic strength candidates (balanced across primary muscles) plus
/// stretches for warm-up/cool-down, filtered to the training location.
PlanCandidates selectPlanCandidates(
  List<Exercise> all, {
  String? location,
  String? level,
  int maxStrength = 300,
  int maxStretches = 40,
}) {
  final template = templateExerciseIds;
  final strengthCats = {'strength', 'powerlifting', if (level == 'advanced') 'olympic weightlifting'};

  int score(Exercise e) {
    var s = 0;
    if (e.isCustom) s += 6;
    if (e.isFavorite) s += 3;
    if (template.contains(e.id)) s += 6;
    if (e.mechanic == 'compound') s += 3;
    s += switch (e.level) {
      'beginner' => 2,
      'intermediate' => 1,
      'expert' => level == 'advanced' ? 0 : -3,
      _ => 0,
    };
    final n = e.nameEn.toLowerCase();
    if (_commonWords.any(n.contains)) s += 2;
    if (n.length > 34) s -= 1;
    if (const {'barbell', 'dumbbell', 'cable', 'machine', 'body only'}.contains(e.equipment)) s += 1;
    return s;
  }

  final strength = all
      .where((e) => (e.isCustom || strengthCats.contains(e.category)) && _equipmentOk(e.equipment, location))
      .where((e) => e.primaryMuscles.isNotEmpty)
      .toList();
  // Round-robin across primary muscles so every muscle has options.
  final byMuscle = <String, List<Exercise>>{};
  for (final e in strength) {
    byMuscle.putIfAbsent(e.primaryMuscles.first, () => []).add(e);
  }
  for (final l in byMuscle.values) {
    l.sort((a, b) => score(b).compareTo(score(a)));
  }
  final picked = <Exercise>[];
  final keys = byMuscle.keys.toList()..sort();
  for (var round = 0; picked.length < maxStrength; round++) {
    var added = false;
    for (final k in keys) {
      final l = byMuscle[k]!;
      if (round < l.length && picked.length < maxStrength) {
        picked.add(l[round]);
        added = true;
      }
    }
    if (!added) break;
  }

  final stretches = all
      .where((e) => e.category == 'stretching' && e.equipment != 'machine' && e.equipment != 'cable')
      .toList()
    ..sort((a, b) {
      final la = a.level == 'beginner' ? 0 : 1, lb = b.level == 'beginner' ? 0 : 1;
      return la != lb ? la.compareTo(lb) : a.nameEn.length.compareTo(b.nameEn.length);
    });
  final stretchPick = <Exercise>[];
  final perMuscle = <String, int>{};
  for (final e in stretches) {
    final m = e.primaryMuscles.isEmpty ? '' : e.primaryMuscles.first;
    if ((perMuscle[m] ?? 0) >= 3) continue;
    perMuscle[m] = (perMuscle[m] ?? 0) + 1;
    stretchPick.add(e);
    if (stretchPick.length >= maxStretches) break;
  }
  return PlanCandidates(picked, stretchPick);
}

const planSystemPrompt = '''
You are IronMind's head strength coach. You design safe, effective, evidence-based weekly gym plans
(progressive overload with double progression, sensible weekly volume of ~10–20 hard sets per muscle,
compound lifts first, isolation after). You must output JSON that matches the given schema exactly.

Hard rules:
- Use ONLY exerciseId values copied exactly from the candidate list (format: id|name|primary muscles|equipment).
- Output one entry in "days" for EACH training weekday given (1=Monday … 7=Sunday) and no other weekdays.
- Respect every injury/health issue: avoid exercises that load the injured area or provoke pain; prefer
  machine/supported/neutral-grip variants; mention the adaptation in that exercise's notes.
- Only use equipment available at the user's location.
- Fit the session length: warm-up (~8 min) + all sets with their rest + cool-down (~5 min) must fit the minutes given
  (estimate ~40 s per set plus its rest).
- Follow the split preference; when it is "ai" or missing, choose the best split for the number of days.
- Give focus muscles extra weekly volume (an extra exercise or 1–2 more sets), without neglecting the rest.
- Level: beginner → 4–6 exercises/day, mostly compound, 2–3 sets, targetRpe 7; intermediate → targetRpe 7.5–8.5;
  advanced → more volume/intensity, targetRpe 8–9.
- repMin/repMax: strength goal → 3–6 on main lifts; hypertrophy/cut/recomp → 6–12 compounds, 10–15 isolation.
- restSeconds: 120–180 for heavy compounds, 60–90 for isolation.
- suggestedWeightKg: a conservative starting working weight estimated from sex, bodyweight and level
  (per dumbbell for dumbbell exercises, 0 for pure bodyweight exercises, null only if you truly cannot estimate).
- warmup: 3–5 short steps specific to that day's muscles (light cardio, mobility, ramp-up sets of the first lift).
- cooldown: 3–5 stretch steps for the muscles trained that day (you may name stretches from the STRETCHES list).
- deloadEveryWeeks: 4–6 depending on level and recovery (beginners can go longer).
- notes: 2–4 sentences explaining the plan logic and how to progress (double progression).
''';

String buildPlanPrompt({
  required UserProfile profile,
  required List<int> days,
  required PlanCandidates candidates,
  required String lang,
}) {
  final language = lang == 'ar'
      ? 'Egyptian Arabic (friendly colloquial مصري); exercise names may stay in English'
      : 'English';
  final injuries = [...profile.injuries, if ((profile.injuriesNote ?? '').trim().isNotEmpty) profile.injuriesNote!.trim()];
  final b = StringBuffer()
    ..writeln('Build my weekly training plan.')
    ..writeln()
    ..writeln('USER PROFILE (JSON):')
    ..writeln(profile.toPromptSummary())
    ..writeln()
    ..writeln('KEY CONSTRAINTS:')
    ..writeln('- Training weekdays (1=Mon … 7=Sun): ${days.join(', ')}  → ${days.length} days/week')
    ..writeln('- Session length: ${profile.sessionMinutes ?? 60} minutes')
    ..writeln('- Split preference: ${profile.splitPreference ?? 'ai'}')
    ..writeln('- Focus muscles: ${profile.focusMuscles.isEmpty ? 'none' : profile.focusMuscles.join(', ')}')
    ..writeln('- Location: ${profile.location ?? 'full_gym'}')
    ..writeln('- Level: ${profile.level ?? 'beginner'} (${profile.trainingExperience ?? 'experience not given'})')
    ..writeln('- Goal: ${profile.goal ?? 'fitness'}')
    ..writeln('- Injuries / health: ${injuries.isEmpty ? 'none' : injuries.join('; ')}')
    ..writeln('- Bodyweight: ${profile.weightKg ?? 'unknown'} kg, sex: ${profile.sex ?? 'unknown'}')
    ..writeln('- Write all human-readable text (name, notes, day names like "Push A", focus, warmup, cooldown, '
        'exercise notes) in $language.')
    ..writeln()
    ..writeln('STRENGTH CANDIDATES (id|name|primary|equipment):');
  for (final e in candidates.strength) {
    b.writeln(PlanCandidates.line(e));
  }
  b
    ..writeln()
    ..writeln('STRETCHES (id|name|primary|equipment):');
  for (final e in candidates.stretches) {
    b.writeln(PlanCandidates.line(e));
  }
  return b.toString();
}
