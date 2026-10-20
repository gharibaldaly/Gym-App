/// Pure (UI-free) onboarding logic: step model, validation, body-shape → body-fat
/// estimates, Egyptian week ordering, meal-time suggestions, chip text encoding
/// and supplement entries. Everything here is unit-tested in test/onb_*_test.dart.
library;

import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart' show Value;

import '../../core/calc/nutrition_calc.dart';
import '../../core/providers.dart';
import '../../data/repositories/profile_repository.dart';

// ---------------------------------------------------------------------------
// Steps
// ---------------------------------------------------------------------------

/// The 24 questionnaire steps, in order (spec §2).
enum OnbStep {
  language,
  body,
  bodyFat,
  measurements,
  goal,
  level,
  days,
  sessionLength,
  split,
  focus,
  location,
  injuries,
  job,
  sleep,
  trainingTime,
  cardio,
  meals,
  foods,
  budget,
  supplements,
  water,
  healthConnect,
  apiKey,
  summary,
}

/// Groups used by the summary and the profile editor.
enum OnbSection { basics, goals, training, lifestyle, nutrition, connections }

extension OnbStepX on OnbStep {
  OnbSection get section => switch (this) {
        OnbStep.language || OnbStep.body || OnbStep.bodyFat || OnbStep.measurements => OnbSection.basics,
        OnbStep.goal || OnbStep.level => OnbSection.goals,
        OnbStep.days ||
        OnbStep.sessionLength ||
        OnbStep.split ||
        OnbStep.focus ||
        OnbStep.location ||
        OnbStep.trainingTime ||
        OnbStep.cardio =>
          OnbSection.training,
        OnbStep.injuries || OnbStep.job || OnbStep.sleep => OnbSection.lifestyle,
        OnbStep.meals || OnbStep.foods || OnbStep.budget || OnbStep.supplements || OnbStep.water =>
          OnbSection.nutrition,
        OnbStep.healthConnect || OnbStep.apiKey || OnbStep.summary => OnbSection.connections,
      };

  /// Changing this answer makes the current workout plan stale.
  bool get affectsWorkout => const {
        OnbStep.body,
        OnbStep.goal,
        OnbStep.level,
        OnbStep.days,
        OnbStep.sessionLength,
        OnbStep.split,
        OnbStep.focus,
        OnbStep.location,
        OnbStep.injuries,
        OnbStep.trainingTime,
        OnbStep.cardio,
      }.contains(this);

  /// Changing this answer makes the current meal plan stale.
  bool get affectsMeals => const {
        OnbStep.body,
        OnbStep.bodyFat,
        OnbStep.goal,
        OnbStep.days,
        OnbStep.injuries,
        OnbStep.job,
        OnbStep.sleep,
        OnbStep.meals,
        OnbStep.foods,
        OnbStep.budget,
        OnbStep.supplements,
      }.contains(this);

  /// Answers that feed BMR/TDEE/macros (recompute targets after editing).
  bool get affectsTargets => const {
        OnbStep.body,
        OnbStep.bodyFat,
        OnbStep.goal,
        OnbStep.days,
        OnbStep.job,
        OnbStep.water,
      }.contains(this);

  /// Steps that show an explicit "Skip" button.
  bool get skippable => this == OnbStep.healthConnect || this == OnbStep.apiKey;
}

// ---------------------------------------------------------------------------
// Number parsing (Arabic-Indic digits, Arabic decimal separator)
// ---------------------------------------------------------------------------

/// Parses user-typed numbers, accepting Arabic-Indic (٠-٩) and Persian (۰-۹)
/// digits and `,` / `٫` as decimal separators. Returns null when empty/invalid.
double? parseNum(String? input) {
  if (input == null) return null;
  final b = StringBuffer();
  for (final r in input.trim().runes) {
    if (r >= 0x0660 && r <= 0x0669) {
      b.writeCharCode(0x30 + r - 0x0660);
    } else if (r >= 0x06F0 && r <= 0x06F9) {
      b.writeCharCode(0x30 + r - 0x06F0);
    } else if (r == 0x066B || r == 0x2C) {
      b.write('.');
    } else if (r == 0x066C || r == 0x20) {
      // Arabic thousands separator / spaces → ignore
    } else {
      b.writeCharCode(r);
    }
  }
  final s = b.toString();
  if (s.isEmpty) return null;
  return double.tryParse(s);
}

// ---------------------------------------------------------------------------
// Body fat from body shape
// ---------------------------------------------------------------------------

enum BodyShape { lean, athletic, average, soft, heavy }

const _shapeMale = {
  BodyShape.lean: 10.0,
  BodyShape.athletic: 14.0,
  BodyShape.average: 20.0,
  BodyShape.soft: 26.0,
  BodyShape.heavy: 33.0,
};

const _shapeFemale = {
  BodyShape.lean: 18.0,
  BodyShape.athletic: 23.0,
  BodyShape.average: 28.0,
  BodyShape.soft: 34.0,
  BodyShape.heavy: 41.0,
};

/// Approximate body-fat % for a visual body shape. Female ranges are higher
/// (essential fat ≈ 12% vs ≈ 3% for men).
double bodyFatForShape(BodyShape shape, String? sex) =>
    (sex == 'female' ? _shapeFemale : _shapeMale)[shape]!;

/// Closest shape to a stored percentage (used to re-select the card).
BodyShape nearestBodyShape(double pct, String? sex) {
  final table = sex == 'female' ? _shapeFemale : _shapeMale;
  return table.entries.reduce((a, b) => (a.value - pct).abs() <= (b.value - pct).abs() ? a : b).key;
}

/// When the sex changes and the body fat came from a shape, keep the same shape
/// but re-estimate the percentage for the new sex. Returns null when nothing changes.
double? reestimateShapeBodyFat({
  required String? method,
  required double? pct,
  required String? oldSex,
  required String? newSex,
}) {
  if (method != 'shape' || pct == null || oldSex == newSex) return null;
  return bodyFatForShape(nearestBodyShape(pct, oldSex), newSex);
}

// ---------------------------------------------------------------------------
// Training weekdays (DateTime.weekday ints, shown Saturday → Friday for Egypt)
// ---------------------------------------------------------------------------

/// Egyptian week order: Sat, Sun, Mon, Tue, Wed, Thu, Fri.
const egyptWeekOrder = [
  DateTime.saturday,
  DateTime.sunday,
  DateTime.monday,
  DateTime.tuesday,
  DateTime.wednesday,
  DateTime.thursday,
  DateTime.friday,
];

/// Unique weekdays sorted in Egyptian week order (invalid values dropped).
List<int> sortWeekdaysEgypt(Iterable<int> days) =>
    egyptWeekOrder.where(days.toSet().contains).toList();

/// Sensible default spread for N training days (Friday is the last to be used).
List<int> suggestTrainingDays(int count) {
  const s = DateTime.saturday,
      su = DateTime.sunday,
      m = DateTime.monday,
      tu = DateTime.tuesday,
      w = DateTime.wednesday,
      th = DateTime.thursday;
  return switch (count.clamp(1, 7)) {
    1 => [s],
    2 => [s, tu],
    3 => [s, m, w],
    4 => [s, su, tu, w],
    5 => [s, su, m, w, th],
    6 => [s, su, m, tu, w, th],
    _ => List.of(egyptWeekOrder),
  };
}

/// Toggles a weekday, returning the new sorted list.
List<int> toggleWeekday(List<int> days, int weekday) {
  final set = days.toSet();
  if (!set.remove(weekday)) set.add(weekday);
  return sortWeekdaysEgypt(set);
}

// ---------------------------------------------------------------------------
// Meal times
// ---------------------------------------------------------------------------

int? _minutes(String? hm) {
  if (hm == null) return null;
  final p = hm.split(':');
  if (p.length != 2) return null;
  final h = int.tryParse(p[0]), m = int.tryParse(p[1]);
  if (h == null || m == null || h < 0 || h > 23 || m < 0 || m > 59) return null;
  return h * 60 + m;
}

String _fmtMinutes(int minutes) {
  final v = minutes % (24 * 60);
  return '${(v ~/ 60).toString().padLeft(2, '0')}:${(v % 60).toString().padLeft(2, '0')}';
}

/// Evenly spreads [count] meals between ~1 h after waking and ~2.5 h before
/// bed, rounded to 15 minutes. Handles sleep after midnight.
List<String> suggestMealTimes(int count, {String? wake, String? sleep}) {
  if (count <= 0) return const [];
  final w = _minutes(wake) ?? 7 * 60;
  var s = _minutes(sleep) ?? 23 * 60;
  if (s <= w) s += 24 * 60;
  final first = w + 60;
  var last = s - 150;
  if (count == 1) return [_fmtMinutes(first + ((last - first) ~/ 2) ~/ 15 * 15)];
  if (last - first < (count - 1) * 120) last = first + (count - 1) * 120; // min ~2 h apart
  final step = (last - first) / (count - 1);
  return [
    for (var i = 0; i < count; i++) _fmtMinutes(((first + step * i) / 15).round() * 15),
  ];
}

/// Resizes an existing meal-time list to [count], keeping user-chosen times
/// and filling the rest from the suggestion. Result is sorted by time of day
/// starting from the wake-up time.
List<String> resizeMealTimes(List<String> current, int count, {String? wake, String? sleep}) {
  if (current.length == count) return current;
  if (current.length > count) return current.take(count).toList();
  final suggested = suggestMealTimes(count, wake: wake, sleep: sleep);
  final out = List<String>.of(current);
  for (final t in suggested) {
    if (out.length >= count) break;
    if (!out.contains(t)) out.add(t);
  }
  final w = _minutes(wake) ?? 0;
  int key(String t) => ((_minutes(t) ?? 0) - w) % (24 * 60);
  out.sort((a, b) => key(a).compareTo(key(b)));
  return out;
}

/// Sleep duration in hours between bed and wake times (handles midnight).
double? sleepHours(String? sleep, String? wake) {
  final s = _minutes(sleep), w = _minutes(wake);
  if (s == null || w == null) return null;
  var d = w - s;
  if (d <= 0) d += 24 * 60;
  return d / 60;
}

/// Default exact time for a training time-of-day choice.
String defaultTrainingTime(String timeOfDay) => switch (timeOfDay) {
      'morning' => '08:00',
      'after_work' => '18:00',
      _ => '21:00',
    };

// ---------------------------------------------------------------------------
// Chip lists stored in text columns (foods / allergies)
// ---------------------------------------------------------------------------

class ChipSelection {
  final List<String> codes;
  final String other;
  const ChipSelection(this.codes, this.other);
}

final _listSplit = RegExp(r'[,،؛;\n]+');

/// Splits a stored "a, b, free text" value into known chip codes and the rest.
ChipSelection splitChipText(String? text, Iterable<String> known) {
  if (text == null || text.trim().isEmpty) return const ChipSelection([], '');
  final byLower = {for (final k in known) k.toLowerCase(): k};
  final codes = <String>[];
  final other = <String>[];
  for (final part in text.split(_listSplit)) {
    final t = part.trim();
    if (t.isEmpty) continue;
    final k = byLower[t.toLowerCase()];
    if (k != null) {
      if (!codes.contains(k)) codes.add(k);
    } else {
      other.add(t);
    }
  }
  return ChipSelection(codes, other.join(', '));
}

/// Inverse of [splitChipText]. Codes are written in [order] (when given),
/// followed by the free text. Returns null when empty.
String? joinChipText(Iterable<String> codes, String other, {List<String>? order}) {
  final set = codes.toSet();
  final ordered = order == null ? set.toList() : [...order.where(set.contains), ...set.where((c) => !order.contains(c))];
  final extra = other.split(_listSplit).map((e) => e.trim()).where((e) => e.isNotEmpty);
  final all = [...ordered, ...extra];
  return all.isEmpty ? null : all.join(', ');
}

/// Common Egyptian foods (codes are English names – they go into AI prompts).
const egyptianFoods = [
  'ful medames',
  'eggs',
  'chicken',
  'tuna',
  'rice',
  'baladi bread',
  'yogurt',
  'cottage cheese',
  'white cheese',
  'koshari',
  'minced beef',
  'fish',
  'lentils',
  'taameya',
  'oats',
  'pasta',
  'potatoes',
  'sweet potato',
  'milk',
  'peanut butter',
  'bananas',
  'dates',
  'liver',
  'molokhia',
];

const commonAllergies = ['lactose', 'gluten', 'nuts', 'peanuts', 'eggs', 'seafood'];

/// Focus muscle codes.
const focusMuscleCodes = [
  'chest',
  'back',
  'shoulders',
  'biceps',
  'triceps',
  'forearms',
  'abdominals',
  'quadriceps',
  'hamstrings',
  'glutes',
  'calves',
  'traps',
];

const jointInjuryCodes = ['shoulder', 'knee', 'lower_back', 'elbow', 'wrist', 'neck', 'hip', 'ankle'];
const healthConditionCodes = ['hypertension', 'diabetes', 'heart', 'asthma', 'hernia'];

const measurementKeys = ['waist', 'chest', 'arm', 'thigh', 'neck', 'hips'];

// ---------------------------------------------------------------------------
// Supplements
// ---------------------------------------------------------------------------

/// One row of the "current supplements" answer. Stored in
/// user_profiles.supplementsJson as `{key?, name, dose, timing?, protein_g, calories, carbs_g, fat_g}`
/// (`name`/`dose` are the keys other features rely on) and mirrored into the
/// `supplements` table.
class SupplementEntry {
  final String? key;
  final String name;
  final String dose;
  final String? timing;
  final double proteinG;
  final double calories;
  final double carbsG;
  final double fatG;

  const SupplementEntry({
    this.key,
    required this.name,
    this.dose = '',
    this.timing,
    this.proteinG = 0,
    this.calories = 0,
    this.carbsG = 0,
    this.fatG = 0,
  });

  bool get hasMacros => proteinG > 0 || calories > 0 || carbsG > 0 || fatG > 0;

  SupplementEntry copyWith({
    String? name,
    String? dose,
    String? timing,
    double? proteinG,
    double? calories,
    double? carbsG,
    double? fatG,
  }) =>
      SupplementEntry(
        key: key,
        name: name ?? this.name,
        dose: dose ?? this.dose,
        timing: timing ?? this.timing,
        proteinG: proteinG ?? this.proteinG,
        calories: calories ?? this.calories,
        carbsG: carbsG ?? this.carbsG,
        fatG: fatG ?? this.fatG,
      );

  Map<String, dynamic> toJson() => {
        'key': ?key,
        'name': name,
        'dose': dose,
        if (timing != null && timing!.isNotEmpty) 'timing': timing,
        if (proteinG > 0) 'protein_g': proteinG,
        if (calories > 0) 'calories': calories,
        if (carbsG > 0) 'carbs_g': carbsG,
        if (fatG > 0) 'fat_g': fatG,
      };

  static double _d(Object? v) => v is num ? v.toDouble() : (parseNum(v?.toString()) ?? 0);

  factory SupplementEntry.fromJson(Map<String, dynamic> j) => SupplementEntry(
        key: j['key'] as String?,
        name: (j['name'] ?? '').toString(),
        dose: (j['dose'] ?? '').toString(),
        timing: j['timing'] as String?,
        proteinG: _d(j['protein_g']),
        calories: _d(j['calories']),
        carbsG: _d(j['carbs_g']),
        fatG: _d(j['fat_g']),
      );
}

List<SupplementEntry> parseSupplements(String json) {
  try {
    return (jsonDecode(json) as List)
        .whereType<Map>()
        .map((e) => SupplementEntry.fromJson(e.cast<String, dynamic>()))
        .toList();
  } catch (_) {
    return [];
  }
}

String encodeSupplements(List<SupplementEntry> list) => jsonEncode(list.map((e) => e.toJson()).toList());

/// Template for a common supplement: per-serving macros and default dose kind.
class SupplementTemplate {
  final String key;
  final String doseKind; // scoop / gainer / grams5 / tablet / capsule / serving / mg200
  final double proteinG;
  final double calories;
  final double carbsG;
  final double fatG;
  const SupplementTemplate(this.key, this.doseKind,
      {this.proteinG = 0, this.calories = 0, this.carbsG = 0, this.fatG = 0});

  bool get hasMacros => calories > 0;
}

/// Common supplements. Whey/casein per 30 g scoop, mass gainer per 100 g serving
/// (typical label values – the user can edit them).
const supplementTemplates = [
  SupplementTemplate('whey', 'scoop', proteinG: 24, calories: 120, carbsG: 3, fatG: 1.5),
  SupplementTemplate('creatine', 'grams5'),
  SupplementTemplate('mass_gainer', 'gainer', proteinG: 20, calories: 380, carbsG: 70, fatG: 2),
  SupplementTemplate('casein', 'scoop', proteinG: 24, calories: 117, carbsG: 3, fatG: 1),
  SupplementTemplate('multivitamin', 'tablet'),
  SupplementTemplate('omega3', 'capsule'),
  SupplementTemplate('vitamin_d', 'capsule'),
  SupplementTemplate('zma', 'serving'),
  SupplementTemplate('bcaa', 'grams5'),
  SupplementTemplate('pre_workout', 'scoop_plain'),
  SupplementTemplate('caffeine', 'mg200'),
];

SupplementTemplate? supplementTemplate(String? key) {
  for (final t in supplementTemplates) {
    if (t.key == key) return t;
  }
  return null;
}

/// New entry from a template with its default macros.
SupplementEntry entryFromTemplate(SupplementTemplate t, {required String name, required String dose}) =>
    SupplementEntry(
      key: t.key,
      name: name,
      dose: dose,
      proteinG: t.proteinG,
      calories: t.calories,
      carbsG: t.carbsG,
      fatG: t.fatG,
    );

// ---------------------------------------------------------------------------
// Measurements
// ---------------------------------------------------------------------------

Map<String, double> parseMeasurements(String json) {
  try {
    final m = jsonDecode(json) as Map<String, dynamic>;
    return {
      for (final e in m.entries)
        if (e.value is num) e.key: (e.value as num).toDouble(),
    };
  } catch (_) {
    return {};
  }
}

String encodeMeasurements(Map<String, double> m) => jsonEncode({
      for (final k in measurementKeys)
        if (m[k] != null) k: m[k],
    });

// ---------------------------------------------------------------------------
// Validation
// ---------------------------------------------------------------------------

enum OnbIssue {
  sexRequired,
  ageRange,
  heightRange,
  weightRange,
  bodyFatChoice,
  bodyFatRange,
  measurementRange,
  goalRequired,
  targetWeightRange,
  goalWeeksRange,
  levelRequired,
  daysCountRequired,
  daysMismatch,
  choiceRequired,
  sleepRequired,
  cardioPerWeekRequired,
  mealTimesMismatch,
  budgetRange,
  suppNameRequired,
  waterRange,
}

/// Input limits (also used by the UI for inline field errors).
class OnbLimits {
  static const ageMin = 12, ageMax = 90;
  static const heightMin = 120.0, heightMax = 230.0;
  static const weightMin = 30.0, weightMax = 300.0;
  static const bodyFatMin = 3.0, bodyFatMax = 60.0;
  static const measureMin = 10.0, measureMax = 250.0;
  static const weeksMin = 1, weeksMax = 104;
  static const budgetMin = 100, budgetMax = 1000000;
  static const waterMin = 1000, waterMax = 8000;
  static const mealsMin = 2, mealsMax = 6;
}

bool _in(num? v, num min, num max) => v != null && v >= min && v <= max;

/// First problem preventing the user from leaving [step], or null if valid.
OnbIssue? validateStep(OnbStep step, UserProfile p) {
  switch (step) {
    case OnbStep.body:
      if (p.sex != 'male' && p.sex != 'female') return OnbIssue.sexRequired;
      if (!_in(p.age, OnbLimits.ageMin, OnbLimits.ageMax)) return OnbIssue.ageRange;
      if (!_in(p.heightCm, OnbLimits.heightMin, OnbLimits.heightMax)) return OnbIssue.heightRange;
      if (!_in(p.weightKg, OnbLimits.weightMin, OnbLimits.weightMax)) return OnbIssue.weightRange;
    case OnbStep.bodyFat:
      switch (p.bodyFatMethod) {
        case 'unknown':
          break;
        case 'number' || 'shape':
          if (!_in(p.bodyFatPct, OnbLimits.bodyFatMin, OnbLimits.bodyFatMax)) {
            return p.bodyFatMethod == 'shape' ? OnbIssue.bodyFatChoice : OnbIssue.bodyFatRange;
          }
        default:
          return OnbIssue.bodyFatChoice;
      }
    case OnbStep.measurements:
      for (final v in parseMeasurements(p.measurementsJson).values) {
        if (!_in(v, OnbLimits.measureMin, OnbLimits.measureMax)) return OnbIssue.measurementRange;
      }
    case OnbStep.goal:
      if (p.goal == null) return OnbIssue.goalRequired;
      if (p.targetWeightKg != null && !_in(p.targetWeightKg, OnbLimits.weightMin, OnbLimits.weightMax)) {
        return OnbIssue.targetWeightRange;
      }
      if (p.goalWeeks != null && !_in(p.goalWeeks, OnbLimits.weeksMin, OnbLimits.weeksMax)) {
        return OnbIssue.goalWeeksRange;
      }
    case OnbStep.level:
      if (p.level == null || p.trainingExperience == null) return OnbIssue.levelRequired;
    case OnbStep.days:
      if (!_in(p.daysPerWeek, 2, 7)) return OnbIssue.daysCountRequired;
      if (sortWeekdaysEgypt(p.trainingDays).length != p.daysPerWeek) return OnbIssue.daysMismatch;
    case OnbStep.sessionLength:
      if (p.sessionMinutes == null) return OnbIssue.choiceRequired;
    case OnbStep.split:
      if (p.splitPreference == null) return OnbIssue.choiceRequired;
    case OnbStep.location:
      if (p.location == null) return OnbIssue.choiceRequired;
    case OnbStep.job:
      if (p.jobType == null) return OnbIssue.choiceRequired;
    case OnbStep.sleep:
      if (p.sleepTime == null || p.wakeTime == null) return OnbIssue.sleepRequired;
    case OnbStep.trainingTime:
      if (p.trainingTimeOfDay == null) return OnbIssue.choiceRequired;
    case OnbStep.cardio:
      if (p.cardioType == null) return OnbIssue.choiceRequired;
      if (p.cardioType != 'none' && !_in(p.cardioPerWeek, 1, 14)) return OnbIssue.cardioPerWeekRequired;
    case OnbStep.meals:
      if (!_in(p.mealsPerDay, OnbLimits.mealsMin, OnbLimits.mealsMax)) return OnbIssue.choiceRequired;
      if (p.mealTimes.length != p.mealsPerDay) return OnbIssue.mealTimesMismatch;
    case OnbStep.budget:
      if (p.budgetLevel == null && p.budgetEgp == null) return OnbIssue.choiceRequired;
      if (p.budgetLevel == null && !_in(p.budgetEgp, OnbLimits.budgetMin, OnbLimits.budgetMax)) {
        return OnbIssue.budgetRange;
      }
    case OnbStep.supplements:
      if (parseSupplements(p.supplementsJson).any((e) => e.name.trim().isEmpty)) {
        return OnbIssue.suppNameRequired;
      }
    case OnbStep.water:
      if (!_in(p.waterGoalMl, OnbLimits.waterMin, OnbLimits.waterMax)) return OnbIssue.waterRange;
    case OnbStep.language ||
          OnbStep.focus ||
          OnbStep.injuries ||
          OnbStep.foods ||
          OnbStep.healthConnect ||
          OnbStep.apiKey ||
          OnbStep.summary:
      break;
  }
  return null;
}

/// First step (in order) with a validation problem, or null when all answers are valid.
OnbStep? firstInvalidStep(UserProfile p) {
  for (final s in OnbStep.values) {
    if (validateStep(s, p) != null) return s;
  }
  return null;
}

/// Soft (non-blocking) warning: target weight goes the "wrong" way for the goal.
enum GoalWarning { cutTargetAbove, bulkTargetBelow }

GoalWarning? goalWarning(UserProfile p) {
  final w = p.weightKg, t = p.targetWeightKg;
  if (w == null || t == null) return null;
  if (p.goal == 'cut' && t > w) return GoalWarning.cutTargetAbove;
  if (p.goal == 'bulk' && t < w) return GoalWarning.bulkTargetBelow;
  return null;
}

/// Suggested weeks to reach a target (≈0.5 %/week cutting, ≈0.25 %/week bulking).
int? suggestGoalWeeks(double? currentKg, double? targetKg) {
  if (currentKg == null || targetKg == null || currentKg <= 0) return null;
  final diff = (targetKg - currentKg).abs();
  if (diff < 0.5) return null;
  final perWeek = targetKg < currentKg ? currentKg * 0.005 : currentKg * 0.0025;
  return max(1, min(OnbLimits.weeksMax, (diff / perWeek).ceil()));
}

// ---------------------------------------------------------------------------
// Defaults applied when a step is shown with no answer yet
// ---------------------------------------------------------------------------

const defaultSleepTime = '23:00';
const defaultWakeTime = '07:00';

/// Sensible pre-filled answers for steps whose controls need a starting value
/// (time pickers, water stepper). Returns null when nothing needs filling.
UserProfilesCompanion? prefillPatch(OnbStep step, UserProfile p) {
  switch (step) {
    case OnbStep.sleep:
      if (p.sleepTime != null && p.wakeTime != null) return null;
      return UserProfilesCompanion(
        sleepTime: Value(p.sleepTime ?? defaultSleepTime),
        wakeTime: Value(p.wakeTime ?? defaultWakeTime),
      );
    case OnbStep.water:
      if (p.waterGoalMl != null) return null;
      return UserProfilesCompanion(
        waterGoalMl: Value(p.weightKg == null ? 2500 : NutritionCalc.waterGoalMl(p.weightKg!)),
      );
    default:
      return null;
  }
}
