import 'dart:convert';
import 'dart:ui' show Locale;

import 'package:drift/drift.dart';

import '../../ai/json_schema.dart';
import '../../core/providers.dart';
import '../../core/utils/context_ext.dart' show dayOf, ymd, fmtNum;
import '../../data/repositories/exercise_repository.dart';
import '../../l10n/gen/app_localizations.dart';
import 'coach_memory.dart';
import 'coach_proposals.dart';

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

  // ------------------------------------------------------------ memory

  Future<ToolOutcome> _saveMemory(Map<String, dynamic> input) async {
    final fact = (input['fact'] as String).trim();
    if (fact.isEmpty) return const ToolOutcome('fact is empty.', isError: true);
    final inserted = await insertMemoriesDeduped(db, [fact], source: 'chat_tool');
    return ToolOutcome(inserted.isEmpty ? 'Already in memory – nothing saved.' : 'Saved to memory.');
  }
}
