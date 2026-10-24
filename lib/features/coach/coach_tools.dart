import 'dart:convert';
import 'dart:ui' show Locale;

import 'package:drift/drift.dart';

import '../../ai/json_schema.dart';
import '../../core/providers.dart';
import '../../core/utils/context_ext.dart' show dayOf, ymd, fmtNum;
import '../../data/repositories/exercise_repository.dart';
import '../../data/repositories/profile_repository.dart';
import '../../l10n/gen/app_localizations.dart';
import '../onboarding/onboarding_labels.dart';
import 'coach_memory.dart';
import 'coach_proposals.dart';

/// Enum value meaning "keep the current value". The API rejects enums on nullable
/// types, so optional enum fields use this instead of null.
const _unchanged = 'unchanged';

/// Only for scalar types: nullable arrays and nullable enums are rejected by the API,
/// and all tools together may have at most 16 nullable parameters (see
/// test/ai_schema_shape_test.dart); prefer 0 / "" sentinels for optional fields.
Map<String, dynamic> _nullable(String type, String description) => {
      'type': [type, 'null'],
      'description': description,
    };

Map<String, dynamic> _tool(String name, String description, Map<String, dynamic> props, List<String> required) => {
      'name': name,
      'description': description,
      'strict': true,
      'input_schema': strictSchema({
        'type': 'object',
        'properties': props,
        'required': required,
      }),
    };

final Map<String, Map<String, dynamic>> _schemas = {
  for (final t in coachTools) t['name'] as String: (t['input_schema'] as Map).cast<String, dynamic>(),
};

/// Tool definitions for the coach chat (order is fixed so the prefix caches).
final List<Map<String, dynamic>> coachTools = [
  _tool(
    'find_exercises',
    'Search the exercise library (read-only, runs immediately). Use it to get valid exercise ids before '
        'proposing to add/swap/log an exercise. Matches English or Arabic names and optionally a muscle '
        '(e.g. chest, lats, quadriceps, shoulders, biceps, triceps, hamstrings, glutes, calves, abdominals).',
    {
      'query': {'type': 'string', 'description': 'Part of the exercise name, e.g. "bench press" or "سكوات". Empty string to search by muscle only.'},
      'muscle': _nullable('string', 'Primary muscle filter or null.'),
    },
    ['query', 'muscle'],
  ),
  _tool(
    'propose_plan_change',
    'Propose changes to ONE day of the active workout plan (add / remove / modify exercises: sets, reps, '
        'weight, RPE, rest). Nothing changes until the user approves the card. Use planDayId and planExerciseId '
        '("pe" numbers) from the ACTIVE WORKOUT PLAN section. For "add" give exerciseId (from find_exercises); '
        'for "remove"/"modify" give planExerciseId. Fields you do not want to change must be null.',
    {
      'planDayId': {'type': 'integer', 'description': 'Plan day to change.'},
      'summary': {'type': 'string', 'description': 'One short sentence explaining why (shown to the user, in their language).'},
      'changes': {
        'type': 'array',
        'items': {
          'type': 'object',
          'properties': {
            'action': {
              'type': 'string',
              'enum': ['add', 'remove', 'modify'],
            },
            'planExerciseId': _nullable('integer', 'Existing plan exercise id (remove/modify), else null.'),
            'exerciseId': _nullable('string', 'Library exercise id for add (or to replace on modify), else null.'),
            'sets': _nullable('integer', 'Working sets.'),
            'repMin': _nullable('integer', 'Lower bound of the rep range.'),
            'repMax': _nullable('integer', 'Upper bound of the rep range.'),
            'weightKg': _nullable('number', 'Suggested working weight in kg.'),
            'targetRpe': _nullable('number', 'Target RPE 1-10.'),
            'restSeconds': _nullable('integer', 'Rest between sets in seconds.'),
          },
          'required': ['action', 'planExerciseId', 'exerciseId', 'sets', 'repMin', 'repMax', 'weightKg', 'targetRpe', 'restSeconds'],
        },
      },
    },
    ['planDayId', 'summary', 'changes'],
  ),
  _tool(
    'swap_exercise',
    'Propose replacing an exercise of the plan with another one, either for today\'s workout only or '
        'permanently. Needs user approval.',
    {
      'planExerciseId': {'type': 'integer', 'description': 'The "pe" id from the ACTIVE WORKOUT PLAN.'},
      'newExerciseId': {'type': 'string', 'description': 'Library exercise id (from find_exercises).'},
      'scope': {
        'type': 'string',
        'enum': ['today', 'always'],
      },
      'reason': {'type': 'string', 'description': 'Short reason shown to the user, in their language.'},
    },
    ['planExerciseId', 'newExerciseId', 'scope', 'reason'],
  ),
  _tool(
    'log_meal',
    'Propose logging a meal the user ate today, with estimated grams and macros per item '
        '(Egyptian portions when relevant). Needs user approval.',
    {
      'name': {'type': 'string', 'description': 'Meal name in the user\'s language, e.g. "فطار" or "Koshary".'},
      'items': {
        'type': 'array',
        'items': {
          'type': 'object',
          'properties': {
            'name': {'type': 'string'},
            'grams': {'type': 'number'},
            'calories': {'type': 'number'},
            'protein': {'type': 'number'},
            'carbs': {'type': 'number'},
            'fat': {'type': 'number'},
          },
          'required': ['name', 'grams', 'calories', 'protein', 'carbs', 'fat'],
        },
      },
    },
    ['name', 'items'],
  ),
  _tool(
    'log_set',
    'Propose logging one strength set into today\'s workout session. Needs user approval.',
    {
      'exerciseId': {'type': 'string', 'description': 'Library exercise id.'},
      'weightKg': {'type': 'number'},
      'reps': {'type': 'integer'},
      'rpe': _nullable('number', 'RPE 1-10 or null.'),
    },
    ['exerciseId', 'weightKg', 'reps', 'rpe'],
  ),
  _tool(
    'adjust_macros',
    'Propose new daily nutrition targets. Calories must roughly equal 4*protein + 4*carbs + 9*fat. '
        'Needs user approval.',
    {
      'calories': {'type': 'integer'},
      'protein': {'type': 'integer', 'description': 'grams'},
      'carbs': {'type': 'integer', 'description': 'grams'},
      'fat': {'type': 'integer', 'description': 'grams'},
      'reason': {'type': 'string', 'description': 'Short reason based on the logged numbers, in the user\'s language.'},
    },
    ['calories', 'protein', 'carbs', 'fat', 'reason'],
  ),
  _tool(
    'change_schedule',
    'Propose moving days of the active workout plan to other weekdays (e.g. "train Sunday instead of Monday", '
        '"I can only train 4 days now"). Give the planDayId and its new weekday (1=Mon … 7=Sun, Saturday=6), or '
        'null to take the day off the schedule. Days you do not list keep their weekday. Two days may not end up on '
        'the same weekday. The profile\'s training days and the workout reminders follow. Needs user approval.',
    {
      'days': {
        'type': 'array',
        'items': {
          'type': 'object',
          'properties': {
            'planDayId': {'type': 'integer'},
            'weekday': _nullable('integer', 'New weekday 1-7, or null to unschedule the day.'),
          },
          'required': ['planDayId', 'weekday'],
        },
      },
      'reason': {'type': 'string', 'description': 'Short reason shown to the user, in their language.'},
    },
    ['days', 'reason'],
  ),
  _tool(
    'update_profile',
    'Propose updating the user\'s profile: body weight, goal, level, session length, training / wake / sleep '
        'times, meal times, food likes/dislikes, allergies, injuries, water goal, training location. Fields you do '
        'not change: 0 for numbers, "" for text, "$_unchanged" for goal/level/location, [] for mealTimes. Set '
        'recalculateTargets true when weight or goal changes so calories and macros '
        'are recomputed. Reminders follow the new times. Needs user approval.',
    {
      'weightKg': {'type': 'number', 'description': 'Current body weight in kg (also logged as today\'s weigh-in); 0 = unchanged.'},
      'targetWeightKg': {'type': 'number', 'description': 'Goal body weight in kg; 0 = unchanged.'},
      'goal': {
        'type': 'string',
        'enum': [_unchanged, 'bulk', 'cut', 'recomp', 'strength', 'fitness'],
      },
      'level': {
        'type': 'string',
        'enum': [_unchanged, 'beginner', 'intermediate', 'advanced'],
      },
      'sessionMinutes': {'type': 'integer', 'description': 'Planned session length in minutes; 0 = unchanged.'},
      'trainingTime': {'type': 'string', 'description': 'Usual training time "HH:mm" (24h); "" = unchanged.'},
      'wakeTime': {'type': 'string', 'description': '"HH:mm" (24h); "" = unchanged.'},
      'sleepTime': {'type': 'string', 'description': '"HH:mm" (24h); "" = unchanged.'},
      'mealTimes': {
        'type': 'array',
        'items': {'type': 'string'},
        'description': 'All meal times "HH:mm"; sets the number of meals per day. Empty array = unchanged.',
      },
      'likedFoods': {'type': 'string', 'description': 'Free text; "" = unchanged.'},
      'dislikedFoods': {'type': 'string', 'description': 'Free text; "" = unchanged.'},
      'allergies': {'type': 'string', 'description': 'Free text; "" = unchanged.'},
      'injuriesNote': {'type': 'string', 'description': 'Current injuries / limitations, free text; "" = unchanged.'},
      'waterGoalMl': {'type': 'integer', 'description': 'Daily water goal in ml; 0 = unchanged.'},
      'location': {
        'type': 'string',
        'enum': [_unchanged, 'full_gym', 'limited_gym', 'home'],
      },
      'recalculateTargets': {'type': 'boolean'},
      'reason': {'type': 'string', 'description': 'Short reason shown to the user, in their language.'},
    },
    ['weightKg', 'targetWeightKg', 'goal', 'level', 'sessionMinutes', 'trainingTime', 'wakeTime', 'sleepTime',
        'mealTimes', 'likedFoods', 'dislikedFoods', 'allergies', 'injuriesNote', 'waterGoalMl', 'location',
        'recalculateTargets', 'reason'],
  ),
  _tool(
    'regenerate_workout_plan',
    'Propose building a brand-new workout plan, for big changes that propose_plan_change cannot express '
        '(a different split, a new number of days, a full restart, a new focus). Put everything the user asked for '
        'in instructions, and the weekdays in trainingDays if they change. Use update_profile first if goal or level change. After approval '
        'the plan is generated and the user reviews it before it replaces the current one. Needs user approval.',
    {
      'instructions': {'type': 'string', 'description': 'What the new plan must do, in English, specific.'},
      'trainingDays': {
        'type': 'array',
        'items': {'type': 'integer'},
        'description': 'Training weekdays for the new plan (1=Mon … 7=Sun, Saturday=6) when the days or the '
            'number of days change; empty array keeps the current ones.',
      },
      'reason': {'type': 'string', 'description': 'Short summary shown to the user, in their language.'},
    },
    ['instructions', 'trainingDays', 'reason'],
  ),
  _tool(
    'regenerate_meal_plan',
    'Propose building a new meal plan (different foods, budget, meal count, or after new macro targets). Put the '
        'user\'s requests in instructions. After approval it is generated and becomes the active meal plan. '
        'Needs user approval.',
    {
      'instructions': {'type': 'string', 'description': 'What the new meal plan must do, in English, specific.'},
      'reason': {'type': 'string', 'description': 'Short summary shown to the user, in their language.'},
    },
    ['instructions', 'reason'],
  ),
  _tool(
    'save_memory',
    'Save one lasting fact about the user (injury, preference, constraint, circumstance) to long-term coach '
        'memory. Saved immediately. Do not save facts already listed in COACH MEMORY.',
    {
      'fact': {'type': 'string', 'description': 'One short sentence in the user\'s language.'},
    },
    ['fact'],
  ),
];

/// Result of running one tool call.
class ToolOutcome {
  final String content;
  final bool isError;
  final int? proposalId;
  const ToolOutcome(this.content, {this.isError = false, this.proposalId});

  Map<String, dynamic> toResultBlock(String toolUseId) => {
        'type': 'tool_result',
        'tool_use_id': toolUseId,
        'content': content,
        if (isError) 'is_error': true,
      };
}

/// Runs coach tools. Everything except find_exercises / save_memory only
/// creates a pending coach_proposals row.
class CoachToolExecutor {
  final AppDatabase db;
  final String lang;
  final DateTime Function() now;
  CoachToolExecutor(this.db, {required this.lang, DateTime Function()? now}) : now = now ?? DateTime.now;

  AppLocalizations get _l => lookupAppLocalizations(Locale(lang == 'ar' ? 'ar' : 'en'));
  ExerciseRepository get _ex => ExerciseRepository(db);

  static const _approvalNote =
      'The user now sees an approve/reject card for it; nothing has changed yet. Tell them briefly that it is waiting for their approval.';

  Future<ToolOutcome> execute(String name, Map<String, dynamic> input) async {
    final schema = _schemas[name];
    if (schema == null) return ToolOutcome('Unknown tool "$name".', isError: true);
    if (input['_invalid_json'] == true) return const ToolOutcome('Tool input was not valid JSON.', isError: true);
    final errors = validateJson(input, schema);
    if (errors.isNotEmpty) return ToolOutcome('Invalid input: ${errors.take(5).join('; ')}', isError: true);
    try {
      return switch (name) {
        'find_exercises' => await _findExercises(input),
        'propose_plan_change' => await _planChange(input),
        'swap_exercise' => await _swap(input),
        'log_meal' => await _logMeal(input),
        'log_set' => await _logSet(input),
        'adjust_macros' => await _macros(input),
        'change_schedule' => await _schedule(input),
        'update_profile' => await _profile(input),
        'regenerate_workout_plan' => await _regenerate(ProposalTypes.regenerateWorkoutPlan, input),
        'regenerate_meal_plan' => await _regenerate(ProposalTypes.regenerateMealPlan, input),
        'save_memory' => await _saveMemory(input),
        _ => ToolOutcome('Unknown tool "$name".', isError: true),
      };
    } catch (e) {
      return ToolOutcome('Tool failed: $e', isError: true);
    }
  }

  Future<int> _createProposal(String type, String title, String? description, Map<String, dynamic> payload) =>
      db.into(db.coachProposals).insert(CoachProposalsCompanion.insert(
            type: type,
            title: title,
            description: Value(description),
            payloadJson: jsonEncode(payload),
            createdAt: Value(now()),
          ));

  // ------------------------------------------------------------ find

  Future<ToolOutcome> _findExercises(Map<String, dynamic> input) async {
    final query = (input['query'] as String).trim();
    final muscle = (input['muscle'] as String?)?.trim().toLowerCase();
    final q = db.select(db.exercises);
    q.where((t) {
      Expression<bool> e = const Constant(true);
      if (query.isNotEmpty) {
        final words = query.toLowerCase().split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
        for (final w in words) {
          e = e & (t.nameEn.lower().like('%$w%') | t.nameAr.like('%$w%') | t.id.lower().like('%$w%'));
        }
      }
      if (muscle != null && muscle.isNotEmpty) e = e & t.primaryMusclesJson.like('%$muscle%');
      return e;
    });
    q.orderBy([(t) => OrderingTerm.desc(t.isFavorite), (t) => OrderingTerm.asc(t.nameEn)]);
    q.limit(12);
    final rows = await q.get();
    if (rows.isEmpty) return const ToolOutcome('No exercises found. Try a shorter English query or only a muscle.');
    return ToolOutcome(rows
        .map((e) => '${e.id} | ${e.nameEn} | ${e.nameAr} | ${e.equipment ?? '-'} | ${e.primaryMuscles.join(',')}')
        .join('\n'));
  }

  // ------------------------------------------------------------ plan change

  Future<ToolOutcome> _planChange(Map<String, dynamic> input) async {
    final dayId = (input['planDayId'] as num).toInt();
    final day = await (db.select(db.planDays)..where((t) => t.id.equals(dayId))).getSingleOrNull();
    if (day == null) return ToolOutcome('planDayId $dayId does not exist.', isError: true);
    final plan = await (db.select(db.workoutPlans)..where((t) => t.id.equals(day.planId))).getSingle();
    if (!plan.isActive) return ToolOutcome('planDayId $dayId is not part of the active plan.', isError: true);
    final pes = await (db.select(db.planExercises)..where((t) => t.planDayId.equals(dayId))).get();
    final changes = (input['changes'] as List).cast<Map>().map((m) => m.cast<String, dynamic>()).toList();
    if (changes.isEmpty) return const ToolOutcome('changes is empty.', isError: true);

    final lines = <String>[];
    for (final c in changes) {
      final action = c['action'] as String;
      final peId = (c['planExerciseId'] as num?)?.toInt();
      final exId = c['exerciseId'] as String?;
      if (action == 'add') {
        if (exId == null) return const ToolOutcome('"add" needs exerciseId.', isError: true);
        final ex = await _ex.byId(exId);
        if (ex == null) return ToolOutcome('exerciseId "$exId" not found – use find_exercises.', isError: true);
        lines.add(_l.coachChangeAdd(ex.name(lang), _detail(c)));
      } else {
        final pe = pes.where((p) => p.id == peId).firstOrNull;
        if (pe == null) {
          return ToolOutcome('planExerciseId $peId is not in planDayId $dayId. Valid: ${pes.map((p) => p.id).join(', ')}',
              isError: true);
        }
        final ex = await _ex.byId(pe.exerciseId);
        final name = ex?.name(lang) ?? pe.exerciseId;
        if (action == 'remove') {
          lines.add(_l.coachChangeRemove(name));
        } else {
          if (exId != null && await _ex.byId(exId) == null) {
            return ToolOutcome('exerciseId "$exId" not found – use find_exercises.', isError: true);
          }
          final detail = _detail(c);
          final replaced = exId != null ? (await _ex.byId(exId))!.name(lang) : null;
          if (detail.isEmpty && replaced == null) {
            return ToolOutcome('"modify" for $peId changes nothing.', isError: true);
          }
          lines.add(_l.coachChangeModify(name, [?replaced, if (detail.isNotEmpty) detail].join(' · ')));
        }
      }
    }
    final summary = (input['summary'] as String).trim();
    final id = await _createProposal(
      ProposalTypes.planChange,
      _l.coachPropPlanChangeTitle(day.name),
      [if (summary.isNotEmpty) summary, ...lines].join('\n'),
      {'planDayId': dayId, 'summary': summary, 'changes': changes},
    );
    return ToolOutcome('Proposal #$id (plan change for "${day.name}") created. $_approvalNote', proposalId: id);
  }

  String _detail(Map<String, dynamic> c) {
    num? n(String k) => c[k] as num?;
    final parts = <String>[];
    final sets = n('sets'), rmin = n('repMin'), rmax = n('repMax');
    if (sets != null || rmin != null || rmax != null) {
      final reps = rmin != null && rmax != null && rmin != rmax
          ? '$rmin-$rmax'
          : '${rmin ?? rmax ?? ''}';
      parts.add([if (sets != null) '$sets', if (reps.isNotEmpty) reps].join('×'));
    }
    if (n('weightKg') != null) parts.add('${fmtNum(n('weightKg')!)} ${_l.kg}');
    if (n('targetRpe') != null) parts.add('RPE ${fmtNum(n('targetRpe')!)}');
    if (n('restSeconds') != null) parts.add(_l.coachRestSeconds(n('restSeconds')!.toInt()));
    return parts.join(' · ');
  }

  // ------------------------------------------------------------ swap

  Future<ToolOutcome> _swap(Map<String, dynamic> input) async {
    final peId = (input['planExerciseId'] as num).toInt();
    final newId = input['newExerciseId'] as String;
    final scope = input['scope'] as String;
    final pe = await (db.select(db.planExercises)..where((t) => t.id.equals(peId))).getSingleOrNull();
    if (pe == null) return ToolOutcome('planExerciseId $peId not found.', isError: true);
    if (pe.exerciseId == newId) return const ToolOutcome('That is already the planned exercise.', isError: true);
    final from = await _ex.byId(pe.exerciseId);
    final to = await _ex.byId(newId);
    if (to == null) return ToolOutcome('newExerciseId "$newId" not found – use find_exercises.', isError: true);
    final reason = (input['reason'] as String).trim();
    final id = await _createProposal(
      ProposalTypes.swapExercise,
      _l.coachPropSwapTitle(from?.name(lang) ?? pe.exerciseId, to.name(lang)),
      [scope == 'today' ? _l.coachSwapScopeToday : _l.coachSwapScopeAlways, if (reason.isNotEmpty) reason].join('\n'),
      {
        'planExerciseId': peId,
        'oldExerciseId': pe.exerciseId,
        'newExerciseId': newId,
        'scope': scope,
        'date': ymd(dayOf(now())),
        'reason': reason,
      },
    );
    return ToolOutcome('Proposal #$id (swap, scope $scope) created. $_approvalNote', proposalId: id);
  }

  // ------------------------------------------------------------ meal

  Future<ToolOutcome> _logMeal(Map<String, dynamic> input) async {
    final items = (input['items'] as List).cast<Map>().map((m) => m.cast<String, dynamic>()).toList();
    if (items.isEmpty) return const ToolOutcome('items is empty.', isError: true);
    double sum(String k) => items.fold(0.0, (a, it) => a + (it[k] as num).toDouble());
    final name = (input['name'] as String).trim();
    final desc = [
      ...items.map((it) => '- ${it['name']} ${fmtNum(it['grams'] as num)}${_l.gramsShort} · ${(it['calories'] as num).round()} ${_l.kcal}'),
      _l.coachMacroLine(sum('protein').round(), sum('carbs').round(), sum('fat').round()),
    ].join('\n');
    final id = await _createProposal(
      ProposalTypes.logMeal,
      _l.coachPropLogMealTitle(name, sum('calories').round()),
      desc,
      {'name': name, 'items': items, 'date': ymd(dayOf(now()))},
    );
    return ToolOutcome(
        'Proposal #$id (log meal "$name", ${sum('calories').round()} kcal) created. $_approvalNote',
        proposalId: id);
  }

  // ------------------------------------------------------------ set

  Future<ToolOutcome> _logSet(Map<String, dynamic> input) async {
    final exId = input['exerciseId'] as String;
    final weight = (input['weightKg'] as num).toDouble();
    final reps = (input['reps'] as num).toInt();
    final rpe = (input['rpe'] as num?)?.toDouble();
    final ex = await _ex.byId(exId);
    if (ex == null) return ToolOutcome('exerciseId "$exId" not found – use find_exercises.', isError: true);
    if (reps <= 0 || reps > 100) return const ToolOutcome('reps must be 1-100.', isError: true);
    if (weight < 0 || weight > 600) return const ToolOutcome('weightKg must be 0-600.', isError: true);
    if (rpe != null && (rpe < 1 || rpe > 10)) return const ToolOutcome('rpe must be 1-10 or null.', isError: true);
    final id = await _createProposal(
      ProposalTypes.logSet,
      _l.coachPropLogSetTitle(ex.name(lang), fmtNum(weight), reps),
      rpe != null ? 'RPE ${fmtNum(rpe)}' : null,
      {'exerciseId': exId, 'weightKg': weight, 'reps': reps, 'rpe': rpe, 'date': ymd(dayOf(now()))},
    );
    return ToolOutcome('Proposal #$id (log set) created. $_approvalNote', proposalId: id);
  }

  // ------------------------------------------------------------ macros

  Future<ToolOutcome> _macros(Map<String, dynamic> input) async {
    int v(String k) => (input[k] as num).round();
    final kcal = v('calories'), p = v('protein'), c = v('carbs'), f = v('fat');
    if (kcal < 1000 || kcal > 6000) return const ToolOutcome('calories must be 1000-6000.', isError: true);
    if (p < 0 || c < 0 || f < 0) return const ToolOutcome('macros must be positive.', isError: true);
    final fromMacros = 4 * p + 4 * c + 9 * f;
    if ((fromMacros - kcal).abs() > kcal * 0.12) {
      return ToolOutcome('Macros give $fromMacros kcal but calories is $kcal (>12% apart). Fix and retry.',
          isError: true);
    }
    final reason = (input['reason'] as String).trim();
    final id = await _createProposal(
      ProposalTypes.adjustMacros,
      _l.coachPropMacrosTitle(kcal),
      [_l.coachMacroLine(p, c, f), if (reason.isNotEmpty) reason].join('\n'),
      {'calories': kcal, 'protein': p, 'carbs': c, 'fat': f, 'reason': reason},
    );
    return ToolOutcome('Proposal #$id (new macro targets) created. $_approvalNote', proposalId: id);
  }

  // ------------------------------------------------------------ schedule

  String _weekday(int? wd) => switch (wd) {
        1 => _l.weekdayMon,
        2 => _l.weekdayTue,
        3 => _l.weekdayWed,
        4 => _l.weekdayThu,
        5 => _l.weekdayFri,
        6 => _l.weekdaySat,
        7 => _l.weekdaySun,
        _ => _l.coachScheduleNone,
      };

  Future<ToolOutcome> _schedule(Map<String, dynamic> input) async {
    final plan = await (db.select(db.workoutPlans)..where((t) => t.isActive.equals(true))).getSingleOrNull();
    if (plan == null) return const ToolOutcome('There is no active plan.', isError: true);
    final days = await (db.select(db.planDays)..where((t) => t.planId.equals(plan.id))).get();
    final moves = (input['days'] as List).cast<Map>().map((m) => m.cast<String, dynamic>()).toList();
    if (moves.isEmpty) return const ToolOutcome('days is empty.', isError: true);
    final target = {for (final d in days) d.id: d.weekday};
    for (final m in moves) {
      final id = (m['planDayId'] as num).toInt();
      final wd = (m['weekday'] as num?)?.toInt();
      if (!target.containsKey(id)) {
        return ToolOutcome('planDayId $id is not in the active plan. Valid: ${days.map((d) => d.id).join(', ')}',
            isError: true);
      }
      if (wd != null && (wd < 1 || wd > 7)) return ToolOutcome('weekday $wd must be 1-7 or null.', isError: true);
      target[id] = wd;
    }
    final clash = scheduleClash(target);
    if (clash != null) {
      return ToolOutcome('Weekday ${clash.$1} would be used by planDayIds ${clash.$2.join(' and ')}. '
          'Move or unschedule one of them in the same proposal.', isError: true);
    }
    final lines = <String>[];
    for (final d in days) {
      if (target[d.id] == d.weekday) continue;
      lines.add(_l.coachScheduleMove(d.name, _weekday(d.weekday), _weekday(target[d.id])));
    }
    if (lines.isEmpty) return const ToolOutcome('That is already the schedule – nothing to change.', isError: true);
    final reason = (input['reason'] as String).trim();
    final id = await _createProposal(
      ProposalTypes.changeSchedule,
      _l.coachPropScheduleTitle,
      [if (reason.isNotEmpty) reason, ...lines].join('\n'),
      {
        'planId': plan.id,
        'days': [for (final m in moves) {'planDayId': (m['planDayId'] as num).toInt(), 'weekday': m['weekday']}],
        'reason': reason,
      },
    );
    return ToolOutcome('Proposal #$id (schedule change) created. $_approvalNote', proposalId: id);
  }

  // ------------------------------------------------------------ profile

  static final _hm = RegExp(r'^([01]?\d|2[0-3]):[0-5]\d$');

  Future<ToolOutcome> _profile(Map<String, dynamic> input) async {
    final profile = await ProfileRepository(db).get();
    if (profile == null) return const ToolOutcome('No profile yet.', isError: true);
    // 0 / "" / "unchanged" mean "keep the current value" (nullable fields would push the
    // tool set over the API's limit of 16 union-typed parameters).
    num? n(String k) {
      final v = input[k] as num?;
      return v == null || v == 0 ? null : v;
    }

    String? s(String k) {
      final v = (input[k] as String?)?.trim();
      return v == null || v.isEmpty || v == _unchanged ? null : v;
    }

    final changes = <String, dynamic>{};
    final lines = <String>[];
    void add(String key, Object value, String label, String shown) {
      changes[key] = value;
      lines.add(_l.coachProfileLine(label, shown));
    }

    final w = n('weightKg'), tw = n('targetWeightKg');
    if (w != null) {
      if (w < 30 || w > 300) return const ToolOutcome('weightKg must be 30-300.', isError: true);
      add('weightKg', w.toDouble(), _l.coachFieldWeight, '${fmtNum(w)} ${_l.kg}');
    }
    if (tw != null) {
      if (tw < 30 || tw > 300) return const ToolOutcome('targetWeightKg must be 30-300.', isError: true);
      add('targetWeightKg', tw.toDouble(), _l.coachFieldTargetWeight, '${fmtNum(tw)} ${_l.kg}');
    }
    if (s('goal') != null) add('goal', s('goal')!, _l.coachFieldGoal, labelOf(goalOptions(_l), s('goal')) ?? s('goal')!);
    if (s('level') != null) {
      add('level', s('level')!, _l.coachFieldLevel, labelOf(levelOptions(_l), s('level')) ?? s('level')!);
    }
    final mins = n('sessionMinutes')?.toInt();
    if (mins != null) {
      if (mins < 15 || mins > 240) return const ToolOutcome('sessionMinutes must be 15-240.', isError: true);
      add('sessionMinutes', mins, _l.coachFieldSessionMinutes, _l.coachMinutes(mins));
    }
    for (final (key, label) in [
      ('trainingTime', _l.coachFieldTrainingTime),
      ('wakeTime', _l.coachFieldWakeTime),
      ('sleepTime', _l.coachFieldSleepTime),
    ]) {
      final v = s(key);
      if (v == null) continue;
      if (!_hm.hasMatch(v)) return ToolOutcome('$key must be "HH:mm".', isError: true);
      add(key, _pad(v), label, _pad(v));
    }
    final meals = (input['mealTimes'] as List?)?.cast<String>().map((e) => e.trim()).toList();
    if (meals != null && meals.isNotEmpty) {
      if (meals.length > 8 || meals.any((m) => !_hm.hasMatch(m))) {
        return const ToolOutcome('mealTimes must be 1-8 times "HH:mm".', isError: true);
      }
      final sorted = meals.map(_pad).toList()..sort();
      add('mealTimes', sorted, _l.coachFieldMealTimes, sorted.join(lang == 'ar' ? '، ' : ', '));
    }
    for (final (key, label) in [
      ('likedFoods', _l.coachFieldLikedFoods),
      ('dislikedFoods', _l.coachFieldDislikedFoods),
      ('allergies', _l.coachFieldAllergies),
      ('injuriesNote', _l.coachFieldInjuries),
    ]) {
      final v = s(key);
      if (v != null) add(key, v, label, v);
    }
    final water = n('waterGoalMl')?.toInt();
    if (water != null) {
      if (water < 1000 || water > 8000) return const ToolOutcome('waterGoalMl must be 1000-8000.', isError: true);
      add('waterGoalMl', water, _l.coachFieldWater, '${fmtNum(water / 1000, maxDecimals: 2)} L');
    }
    if (s('location') != null) {
      add('location', s('location')!, _l.coachFieldLocation,
          labelOf(locationOptions(_l), s('location')) ?? s('location')!);
    }
    if (changes.isEmpty) return const ToolOutcome('No field changes – set at least one field.', isError: true);
    final recalc = input['recalculateTargets'] == true;
    final reason = (input['reason'] as String).trim();
    final id = await _createProposal(
      ProposalTypes.updateProfile,
      _l.coachPropProfileTitle,
      [if (reason.isNotEmpty) reason, ...lines, if (recalc) _l.coachRecalcTargets].join('\n'),
      {'changes': changes, 'recalculateTargets': recalc, 'date': ymd(dayOf(now())), 'reason': reason},
    );
    return ToolOutcome('Proposal #$id (profile update) created. $_approvalNote', proposalId: id);
  }

  static String _pad(String hm) {
    final p = hm.split(':');
    return '${p[0].padLeft(2, '0')}:${p[1]}';
  }

  // ------------------------------------------------------------ regenerate plans

  Future<ToolOutcome> _regenerate(String type, Map<String, dynamic> input) async {
    final instructions = (input['instructions'] as String).trim();
    if (instructions.isEmpty) return const ToolOutcome('instructions is empty.', isError: true);
    final reason = (input['reason'] as String).trim();
    final workout = type == ProposalTypes.regenerateWorkoutPlan;
    final given = (input['trainingDays'] as List?)?.map((e) => (e as num).toInt()).toSet().toList() ?? [];
    final days = given.isEmpty ? null : (given..sort());
    if (days != null && days.any((d) => d < 1 || d > 7)) {
      return const ToolOutcome('trainingDays must be weekdays 1-7 (or an empty array).', isError: true);
    }
    final id = await _createProposal(
      type,
      workout ? _l.coachPropNewWorkoutPlanTitle : _l.coachPropNewMealPlanTitle,
      [
        if (reason.isNotEmpty) reason,
        if (days != null) _l.coachProfileLine(_l.coachFieldTrainingDays, days.map(_weekday).join(lang == 'ar' ? '، ' : ', ')),
        workout ? _l.coachNewWorkoutPlanNote : _l.coachNewMealPlanNote,
      ].join('\n'),
      {'instructions': instructions, 'trainingDays': ?days, 'reason': reason},
    );
    return ToolOutcome('Proposal #$id (${workout ? 'new workout plan' : 'new meal plan'}) created. $_approvalNote',
        proposalId: id);
  }

  // ------------------------------------------------------------ memory

  Future<ToolOutcome> _saveMemory(Map<String, dynamic> input) async {
    final fact = (input['fact'] as String).trim();
    if (fact.isEmpty) return const ToolOutcome('fact is empty.', isError: true);
    final inserted = await insertMemoriesDeduped(db, [fact], source: 'chat_tool');
    return ToolOutcome(inserted.isEmpty ? 'Already in memory – nothing saved.' : 'Saved to memory.');
  }
}

/// First weekday that two plan days would share (weekday, planDayIds), or null.
(int, List<int>)? scheduleClash(Map<int, int?> dayToWeekday) {
  final byWeekday = <int, List<int>>{};
  for (final e in dayToWeekday.entries) {
    if (e.value != null) byWeekday.putIfAbsent(e.value!, () => []).add(e.key);
  }
  for (final e in byWeekday.entries) {
    if (e.value.length > 1) return (e.key, e.value..sort());
  }
  return null;
}
