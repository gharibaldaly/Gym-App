/// Pure nutrition logic (no Flutter, no DB): food entries & macro scaling,
/// plan parsing + totals validation, the offline template plan builder and
/// the weekly grocery aggregation. Everything here is unit-tested.
library;

import 'dart:convert';
import 'dart:math' as math;

import 'egyptian_foods.dart';

export 'egyptian_foods.dart' show FoodMacros;

// ---------------------------------------------------------------------------
// Food entries
// ---------------------------------------------------------------------------

/// One food line inside a meal / log / plan (`itemsJson` element).
class FoodEntry {
  final String nameAr;
  final String nameEn;
  final double grams;
  final double calories, protein, carbs, fat;

  /// Built-in [EgyptianFood.id] when the item came from (or matched) the table.
  final String? foodId;

  const FoodEntry({
    required this.nameAr,
    required this.nameEn,
    required this.grams,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.foodId,
  });

  factory FoodEntry.fromFood(EgyptianFood f, double grams) {
    final m = f.macrosFor(grams);
    return FoodEntry(
      nameAr: f.nameAr,
      nameEn: f.nameEn,
      grams: grams,
      calories: m.calories,
      protein: m.protein,
      carbs: m.carbs,
      fat: m.fat,
      foodId: f.id,
    );
  }

  /// Tolerant parser for AI output and stored JSON (`name` alone is accepted).
  factory FoodEntry.fromJson(Map<String, dynamic> j) {
    double n(Object? v) => v is num ? v.toDouble() : double.tryParse('$v') ?? 0;
    final name = (j['name'] as String?)?.trim() ?? '';
    final ar = (j['nameAr'] as String?)?.trim();
    final en = (j['nameEn'] as String?)?.trim();
    return FoodEntry(
      nameAr: (ar == null || ar.isEmpty) ? name : ar,
      nameEn: (en == null || en.isEmpty) ? name : en,
      grams: math.max(0, n(j['grams'])),
      calories: math.max(0, n(j['calories'])),
      protein: math.max(0, n(j['protein'])),
      carbs: math.max(0, n(j['carbs'])),
      fat: math.max(0, n(j['fat'])),
      foodId: j['foodId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': nameEn.isNotEmpty ? nameEn : nameAr,
        'nameAr': nameAr,
        'nameEn': nameEn,
        'grams': _r1(grams),
        'calories': _r1(calories),
        'protein': _r1(protein),
        'carbs': _r1(carbs),
        'fat': _r1(fat),
        'foodId': ?foodId,
      };

  String name(String lang) {
    if (lang == 'ar') return nameAr.isNotEmpty ? nameAr : nameEn;
    return nameEn.isNotEmpty ? nameEn : nameAr;
  }

  FoodMacros get macros => FoodMacros(calories: calories, protein: protein, carbs: carbs, fat: fat);

  /// Same food at a different weight: macros scale proportionally.
  /// (When the original weight is unknown/0, macros are kept as-is.)
  FoodEntry withGrams(double newGrams) {
    final g = math.max(0.0, newGrams);
    if (grams <= 0) return copyWith(grams: g);
    final f = g / grams;
    return FoodEntry(
      nameAr: nameAr,
      nameEn: nameEn,
      grams: g,
      calories: calories * f,
      protein: protein * f,
      carbs: carbs * f,
      fat: fat * f,
      foodId: foodId,
    );
  }

  FoodEntry copyWith({
    String? nameAr,
    String? nameEn,
    double? grams,
    double? calories,
    double? protein,
    double? carbs,
    double? fat,
  }) =>
      FoodEntry(
        nameAr: nameAr ?? this.nameAr,
        nameEn: nameEn ?? this.nameEn,
        grams: grams ?? this.grams,
        calories: calories ?? this.calories,
        protein: protein ?? this.protein,
        carbs: carbs ?? this.carbs,
        fat: fat ?? this.fat,
        foodId: foodId,
      );

  @override
  String toString() => 'FoodEntry($nameEn ${grams}g, $macros)';
}

double _r1(double v) => (v * 10).roundToDouble() / 10;

FoodMacros sumEntries(Iterable<FoodEntry> items) =>
    items.fold(const FoodMacros(), (a, e) => a + e.macros);

List<FoodEntry> decodeItems(String? json) {
  if (json == null || json.isEmpty) return [];
  try {
    final list = jsonDecode(json);
    if (list is! List) return [];
    return list.whereType<Map>().map((m) => FoodEntry.fromJson(m.cast<String, dynamic>())).toList();
  } catch (_) {
    return [];
  }
}

String encodeItems(Iterable<FoodEntry> items) => jsonEncode(items.map((e) => e.toJson()).toList());

/// Scales a whole meal so its total weight becomes [factor] × the original
/// (e.g. "half portion" = 0.5).
List<FoodEntry> scaleMeal(List<FoodEntry> items, double factor) =>
    items.map((e) => e.withGrams(e.grams * factor)).toList();

// ---------------------------------------------------------------------------
// Bilingual names stored in single text columns ("عربي | English")
// ---------------------------------------------------------------------------

const _sep = ' | ';

String joinBilingual(String ar, String en) {
  final a = ar.trim(), e = en.trim();
  if (a.isEmpty) return e;
  if (e.isEmpty || a == e) return a;
  return '$a$_sep$e';
}

String pickBilingual(String stored, String lang) {
  final i = stored.indexOf(_sep);
  if (i < 0) return stored;
  final ar = stored.substring(0, i).trim(), en = stored.substring(i + _sep.length).trim();
  return lang == 'ar' ? (ar.isEmpty ? en : ar) : (en.isEmpty ? ar : en);
}

// ---------------------------------------------------------------------------
// Targets
// ---------------------------------------------------------------------------

class MacroTargets {
  final double calories, protein, carbs, fat;
  const MacroTargets({required this.calories, required this.protein, required this.carbs, required this.fat});

  /// Same formula as `UserProfileX.caloriesFor`: carb cycling shifts calories by Δcarbs × 4.
  factory MacroTargets.forDay({
    required int calorieTarget,
    required int proteinG,
    required int carbsG,
    required int fatG,
    int? dayCarbsG,
  }) {
    final c = dayCarbsG ?? carbsG;
    return MacroTargets(
      calories: (calorieTarget + (c - carbsG) * 4).toDouble(),
      protein: proteinG.toDouble(),
      carbs: c.toDouble(),
      fat: fatG.toDouble(),
    );
  }

  MacroTargets scale(double f) =>
      MacroTargets(calories: calories * f, protein: protein * f, carbs: carbs * f, fat: fat * f);

  Map<String, dynamic> toJson() => {
        'calories': calories.round(),
        'protein_g': protein.round(),
        'carbs_g': carbs.round(),
        'fat_g': fat.round(),
      };
}

/// True when [actual] is within ±[tolerance] of [target] (with an absolute
/// floor [minSlack] so tiny targets aren't impossible to hit).
bool withinTolerance(double actual, double target, {double tolerance = 0.10, double minSlack = 0}) {
  final slack = math.max(target.abs() * tolerance, minSlack);
  return (actual - target).abs() <= slack;
}

/// Errors (empty = OK) when a day's totals are outside ±[tolerance] of targets.
List<String> validateDayTotals(String label, FoodMacros totals, MacroTargets t, {double tolerance = 0.10}) {
  final errors = <String>[];
  void check(String name, double a, double target, double minSlack) {
    if (target <= 0) return;
    if (!withinTolerance(a, target, tolerance: tolerance, minSlack: minSlack)) {
      errors.add('$label: $name total is ${a.round()} but must be within ±${(tolerance * 100).round()}% '
          'of ${target.round()} (sum of the items).');
    }
  }

  check('calories', totals.calories, t.calories, 50);
  check('protein', totals.protein, t.protein, 5);
  check('carbs', totals.carbs, t.carbs, 5);
  check('fat', totals.fat, t.fat, 5);
  return errors;
}

// ---------------------------------------------------------------------------
// Plan drafts (AI output / template output before saving)
// ---------------------------------------------------------------------------

class PlanMealDraft {
  final String nameAr, nameEn;
  final String? time;
  final List<FoodEntry> items;
  const PlanMealDraft({required this.nameAr, required this.nameEn, this.time, required this.items});

  FoodMacros get totals => sumEntries(items);

  factory PlanMealDraft.fromJson(Map<String, dynamic> j) => PlanMealDraft(
        nameAr: (j['nameAr'] as String?) ?? (j['name'] as String?) ?? '',
        nameEn: (j['nameEn'] as String?) ?? (j['name'] as String?) ?? '',
        time: (j['time'] as String?)?.trim().isEmpty ?? true ? null : (j['time'] as String).trim(),
        items: ((j['items'] as List?) ?? const [])
            .whereType<Map>()
            .map((m) => FoodEntry.fromJson(m.cast<String, dynamic>()))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'nameAr': nameAr,
        'nameEn': nameEn,
        'time': time ?? '',
        'items': items.map((e) => e.toJson()).toList(),
      };
}

class PlanDraft {
  final String name;
  final String notes;
  final List<PlanMealDraft> trainingDay;
  final List<PlanMealDraft> restDay;
  final String source; // ai / template
  const PlanDraft({
    required this.name,
    required this.notes,
    required this.trainingDay,
    required this.restDay,
    this.source = 'ai',
  });

  static List<PlanMealDraft> _meals(Object? day) {
    final meals = day is Map ? day['meals'] : day;
    if (meals is! List) return [];
    return meals.whereType<Map>().map((m) => PlanMealDraft.fromJson(m.cast<String, dynamic>())).toList();
  }

  factory PlanDraft.fromJson(Map<String, dynamic> j, {String source = 'ai'}) => PlanDraft(
        name: (j['name'] as String?) ?? '',
        notes: (j['notes'] as String?) ?? '',
        trainingDay: _meals(j['trainingDay']),
        restDay: _meals(j['restDay']),
        source: (j['source'] as String?) ?? source,
      );

  FoodMacros totalsFor({required bool training}) =>
      (training ? trainingDay : restDay).fold(const FoodMacros(), (a, m) => a + m.totals);

  Map<String, dynamic> toJson() => {
        'name': name,
        'notes': notes,
        'source': source,
        'trainingDay': {
          'meals': trainingDay.map((m) => m.toJson()).toList(),
          'totals': _totalsJson(totalsFor(training: true)),
        },
        'restDay': {
          'meals': restDay.map((m) => m.toJson()).toList(),
          'totals': _totalsJson(totalsFor(training: false)),
        },
      };

  static Map<String, dynamic> _totalsJson(FoodMacros m) => {
        'calories': m.calories.round(),
        'protein': m.protein.round(),
        'carbs': m.carbs.round(),
        'fat': m.fat.round(),
      };
}

/// Domain validation for an AI meal plan JSON: daily totals (computed from the
/// items, not trusted from the model) must be within ±10% of the targets, and
/// each day must have [mealsPerDay] meals when given.
List<String> validateMealPlanJson(
  Map<String, dynamic> json, {
  required MacroTargets training,
  required MacroTargets rest,
  int? mealsPerDay,
  double tolerance = 0.10,
}) {
  final draft = PlanDraft.fromJson(json);
  final errors = <String>[];
  for (final (label, meals, t) in [
    ('trainingDay', draft.trainingDay, training),
    ('restDay', draft.restDay, rest),
  ]) {
    if (meals.isEmpty) {
      errors.add('$label: no meals');
      continue;
    }
    if (mealsPerDay != null && mealsPerDay > 0 && meals.length != mealsPerDay) {
      errors.add('$label: must have exactly $mealsPerDay meals (got ${meals.length}).');
    }
    for (final (i, m) in meals.indexed) {
      if (m.items.isEmpty) errors.add('$label.meals[$i]: no items');
      for (final it in m.items) {
        if (it.grams <= 0) errors.add('$label.meals[$i]: "${it.nameEn}" needs grams > 0');
      }
    }
    final totals = meals.fold(const FoodMacros(), (a, m) => a + m.totals);
    errors.addAll(validateDayTotals(label, totals, t, tolerance: tolerance));
  }
  return errors;
}

// ---------------------------------------------------------------------------
// Offline template meal plan (no API key)
// ---------------------------------------------------------------------------

class _Slot {
  final String nameAr, nameEn;
  final double share;
  final List<String> protein, carb, fat;
  final Map<String, double> fixed;
  const _Slot(this.nameAr, this.nameEn, this.share,
      {required this.protein, required this.carb, this.fat = const [], this.fixed = const {}});
}

const _breakfast = _Slot('الفطار', 'Breakfast', 0.25,
    protein: ['egg', 'areesh', 'egg_white'],
    carb: ['baladi_bread', 'toast', 'oats'],
    fat: ['olive_oil', 'veg_oil', 'tahini'],
    fixed: {'foul': 100, 'salad': 80});
const _lunch = _Slot('الغدا', 'Lunch', 0.35,
    protein: ['chicken_breast', 'chicken_leg', 'tilapia', 'beef', 'liver'],
    carb: ['rice', 'pasta', 'potato'],
    fat: ['olive_oil', 'veg_oil'],
    fixed: {'salad': 150});
const _snack = _Slot('سناك', 'Snack', 0.15,
    protein: ['greek_yogurt', 'areesh', 'yogurt'],
    carb: ['banana', 'oats', 'dates'],
    fat: ['peanut_butter', 'peanuts', 'almonds']);
const _dinner = _Slot('العشا', 'Dinner', 0.25,
    protein: ['tuna_water', 'areesh', 'egg', 'chicken_breast'],
    carb: ['baladi_bread', 'potato', 'sweet_potato'],
    fat: ['olive_oil', 'veg_oil', 'tahini'],
    fixed: {'salad': 100});
const _snack2 = _Slot('سناك قبل النوم', 'Evening snack', 0.12,
    protein: ['areesh', 'greek_yogurt', 'yogurt'],
    carb: ['baladi_bread', 'toast', 'banana'],
    fat: ['tahini', 'peanut_butter', 'olive_oil']);
const _extra = _Slot('وجبة إضافية', 'Extra meal', 0.2,
    protein: ['chicken_breast', 'tuna_water', 'chicken_leg'],
    carb: ['rice', 'potato', 'pasta'],
    fat: ['olive_oil', 'veg_oil'],
    fixed: {'veg_saute': 100});

List<_Slot> _slotsFor(int meals) => switch (meals.clamp(2, 6)) {
      2 => const [_lunch, _dinner],
      3 => const [_breakfast, _lunch, _dinner],
      4 => const [_breakfast, _lunch, _snack, _dinner],
      5 => const [_breakfast, _snack, _lunch, _dinner, _snack2],
      _ => const [_breakfast, _snack, _lunch, _extra, _dinner, _snack2],
    };

const _defaultTimes = {
  2: ['14:00', '21:00'],
  3: ['09:00', '15:00', '21:00'],
  4: ['09:00', '14:00', '17:30', '21:30'],
  5: ['08:30', '11:30', '14:30', '18:30', '22:00'],
  6: ['08:00', '11:00', '14:00', '17:00', '20:00', '22:30'],
};

List<String> _tokens(String? s) => (s ?? '')
    .split(RegExp(r'[,،;\n/]+|\s+و\s*|\s+and\s+'))
    .map(normalizeFoodName)
    .where((t) => t.length >= 2)
    .toList();

/// Foods excluded by free-text dislikes / allergies.
Set<String> excludedFoodIds({String? dislikes, String? allergies}) {
  final toks = [..._tokens(dislikes), ..._tokens(allergies)];
  final out = <String>{};
  bool any(List<String> keys) => toks.any((t) => keys.any((k) => t.contains(k)));
  if (any(['لاكتوز', 'lactose', 'البان', 'dairy', 'لبن', 'milk'])) {
    out.addAll(egyptianFoods.where((f) => f.category == FoodCategory.dairy).map((f) => f.id));
  }
  if (any(['جلوتين', 'gluten', 'قمح', 'wheat'])) {
    out.addAll(['baladi_bread', 'shami_bread', 'toast', 'pasta', 'oats', 'koshary', 'hawawshi']);
  }
  if (any(['مكسرات', 'nuts', 'سوداني', 'peanut'])) out.addAll(['peanuts', 'peanut_butter', 'almonds']);
  if (any(['سمك', 'fish', 'seafood', 'بحري'])) out.addAll(['tilapia', 'tuna_water']);
  if (any(['بيض', 'egg'])) out.addAll(['egg', 'egg_white']);
  if (any(['لحم', 'beef', 'meat', 'red meat'])) out.addAll(['beef', 'ground_beef', 'kofta', 'liver', 'hawawshi']);
  for (final f in egyptianFoods) {
    final names = [normalizeFoodName(f.nameAr), normalizeFoodName(f.nameEn), ...f.aliases.map(normalizeFoodName)];
    if (toks.any((t) => names.any((n) => n == t || (t.length >= 3 && n.contains(t))))) out.add(f.id);
  }
  return out;
}

EgyptianFood? _pick(List<String> ids, Set<String> excluded,
    {bool lowBudget = false, bool lean = false, bool pureFat = false}) {
  var opts = ids.where((id) => !excluded.contains(id)).map(food).toList();
  if (opts.isEmpty) return null;
  if (pureFat) {
    final oils = opts.where((f) => f.carbs == 0 && f.protein == 0).toList();
    if (oils.isNotEmpty) opts = oils;
  }
  if (lean) {
    double ratio(EgyptianFood f) => f.protein <= 0 ? 99 : f.fat / f.protein;
    final sorted = [...opts]..sort((a, b) => ratio(a).compareTo(ratio(b)));
    return sorted.first;
  }
  if (lowBudget) {
    final sorted = [...opts]..sort((a, b) => a.priceTier.compareTo(b.priceTier));
    return sorted.first;
  }
  return opts.first;
}

/// Rounds grams to a natural step: whole units (eggs, cans), half loaves, 5 g otherwise.
double roundGrams(EgyptianFood f, double g) {
  if (g <= 0) return 0;
  final u = f.unitGrams;
  if (f.countable && u != null) {
    final step = f.category == FoodCategory.carb ? u / 2 : u;
    return (g / step).round() * step;
  }
  return (g / 5).round() * 5.0;
}

class _MealSolve {
  final EgyptianFood? p, c, f;
  final Map<EgyptianFood, double> fixed;
  double gp = 0, gc = 0, gf = 0;
  _MealSolve(this.p, this.c, this.f, this.fixed);

  FoodMacros get fixedMacros => fixed.entries.fold(const FoodMacros(), (a, e) => a + e.key.macrosFor(e.value));

  FoodMacros total() {
    var m = fixedMacros;
    if (p != null) m += p!.macrosFor(gp);
    if (c != null) m += c!.macrosFor(gc);
    if (f != null) m += f!.macrosFor(gf);
    return m;
  }

  /// Gauss–Seidel on (protein food→protein, carb food→carbs, fat food→fat).
  void solve(MacroTargets t, {int iterations = 12}) {
    for (var i = 0; i < iterations; i++) {
      if (c != null && c!.carbs > 0) {
        final other = total().carbs - c!.macrosFor(gc).carbs;
        gc = math.max(0, (t.carbs - other) / c!.carbs * 100);
      }
      if (p != null && p!.protein > 0) {
        final other = total().protein - p!.macrosFor(gp).protein;
        gp = math.max(0, (t.protein - other) / p!.protein * 100);
      }
      if (f != null && f!.fat > 0) {
        final other = total().fat - f!.macrosFor(gf).fat;
        gf = math.max(0, (t.fat - other) / f!.fat * 100);
      }
    }
  }

  void round() {
    if (p != null) gp = roundGrams(p!, gp);
    if (c != null) gc = roundGrams(c!, gc);
    if (f != null) gf = roundGrams(f!, gf);
  }

  List<FoodEntry> items() {
    final out = <FoodEntry>[];
    if (p != null && gp > 0) out.add(FoodEntry.fromFood(p!, gp));
    if (c != null && gc > 0) out.add(FoodEntry.fromFood(c!, gc));
    for (final e in fixed.entries) {
      out.add(FoodEntry.fromFood(e.key, e.value));
    }
    if (f != null && gf > 0) out.add(FoodEntry.fromFood(f!, gf));
    return out;
  }
}

/// Sum of relative deviations from the day targets (0 = perfect).
double _planError(FoodMacros t, MacroTargets d) {
  double r(double a, double b) => b <= 0 ? 0 : (a - b).abs() / b;
  return r(t.calories, d.calories) + r(t.protein, d.protein) + r(t.carbs, d.carbs) + r(t.fat, d.fat);
}

List<_MealSolve> _solveDay(
  MacroTargets day,
  List<_Slot> slots,
  Set<String> excluded, {
  required bool lowBudget,
  required bool lean,
  required double fixedFactor,
}) {
  final shareSum = slots.fold(0.0, (a, s) => a + s.share);
  final solves = <_MealSolve>[];
  for (final s in slots) {
    final fixed = <EgyptianFood, double>{
      for (final e in s.fixed.entries)
        if (!excluded.contains(e.key) && fixedFactor > 0) food(e.key): (e.value * fixedFactor / 10).round() * 10.0,
    }..removeWhere((_, g) => g <= 0);
    final m = _MealSolve(
      _pick(s.protein, excluded, lowBudget: lowBudget, lean: lean),
      _pick(s.carb, excluded, lowBudget: lowBudget),
      _pick(s.fat, excluded, lowBudget: lowBudget, pureFat: lean),
      fixed,
    );
    m.solve(day.scale(s.share / shareSum));
    m.round();
    solves.add(m);
  }
  // Correct rounding drift / overshoot: biggest meals absorb the remaining difference.
  final order = [for (var i = 0; i < slots.length; i++) i]..sort((a, b) => slots[b].share.compareTo(slots[a].share));
  for (var pass = 0; pass < 3; pass++) {
    for (final i in order) {
      final m = solves[i];
      final dayTotal = solves.fold(const FoodMacros(), (a, s) => a + s.total());
      final mt = m.total();
      m.solve(MacroTargets(
        calories: mt.calories + day.calories - dayTotal.calories,
        protein: math.max(0, mt.protein + day.protein - dayTotal.protein),
        carbs: math.max(0, mt.carbs + day.carbs - dayTotal.carbs),
        fat: math.max(0, mt.fat + day.fat - dayTotal.fat),
      ));
      m.round();
    }
  }
  return solves;
}

List<PlanMealDraft> _buildDay(
  MacroTargets day,
  List<_Slot> slots,
  List<String> times,
  Set<String> excluded,
  bool lowBudget,
) {
  List<_MealSolve>? best;
  var bestErr = double.infinity;
  // Try the preferred foods first; fall back to leaner proteins / fewer fixed sides.
  for (final (lean, fixedFactor) in [(false, 1.0), (true, 1.0), (false, 0.5), (true, 0.5), (true, 0.0)]) {
    final solves = _solveDay(day, slots, excluded, lowBudget: lowBudget, lean: lean, fixedFactor: fixedFactor);
    final totals = solves.fold(const FoodMacros(), (a, s) => a + s.total());
    final err = _planError(totals, day);
    if (err < bestErr) {
      best = solves;
      bestErr = err;
    }
    if (validateDayTotals('day', totals, day, tolerance: 0.08).isEmpty) {
      best = solves;
      break;
    }
  }
  return [
    for (final (i, s) in slots.indexed)
      PlanMealDraft(nameAr: s.nameAr, nameEn: s.nameEn, time: times[i], items: best![i].items()),
  ];
}

/// Builds a simple Egyptian meal plan from the built-in food table, scaled to
/// the user's training/rest-day macro targets. Used when there's no API key.
PlanDraft buildTemplatePlan({
  required MacroTargets training,
  required MacroTargets rest,
  int mealsPerDay = 4,
  List<String> mealTimes = const [],
  String? dislikes,
  String? allergies,
  bool lowBudget = false,
}) {
  final n = mealsPerDay.clamp(2, 6);
  final slots = _slotsFor(n);
  final times = mealTimes.length == n ? mealTimes : _defaultTimes[n]!;
  final excluded = excludedFoodIds(dislikes: dislikes, allergies: allergies);
  return PlanDraft(
    name: joinBilingual('خطة أكل أساسية', 'Basic meal plan'),
    notes: '',
    trainingDay: _buildDay(training, slots, times, excluded, lowBudget),
    restDay: _buildDay(rest, slots, times, excluded, lowBudget),
    source: 'template',
  );
}

// ---------------------------------------------------------------------------
// Weekly grocery list
// ---------------------------------------------------------------------------

class GroceryLine {
  final String key;
  final String nameAr, nameEn;
  final double grams;
  final EgyptianFood? food;
  const GroceryLine({required this.key, required this.nameAr, required this.nameEn, required this.grams, this.food});

  FoodCategory? get category => food?.category;
  String name(String lang) => lang == 'ar' ? nameAr : nameEn;
}

/// Aggregates planned items × number of training/rest days in the week,
/// grouped by food (built-in match, else normalized name), summing grams.
List<GroceryLine> buildGroceryList({
  required List<FoodEntry> trainingDayItems,
  required List<FoodEntry> restDayItems,
  required int trainingDays,
  required int restDays,
}) {
  final acc = <String, GroceryLine>{};
  void add(FoodEntry e, int times) {
    if (times <= 0 || e.grams <= 0) return;
    final f = (e.foodId != null ? egyptianFoodsById[e.foodId] : null) ?? matchEgyptianFood(e.nameAr, e.nameEn);
    final key = f?.id ?? normalizeFoodName(e.nameEn.isNotEmpty ? e.nameEn : e.nameAr);
    final prev = acc[key];
    acc[key] = GroceryLine(
      key: key,
      nameAr: prev?.nameAr ?? f?.nameAr ?? e.nameAr,
      nameEn: prev?.nameEn ?? f?.nameEn ?? e.nameEn,
      grams: (prev?.grams ?? 0) + e.grams * times,
      food: f,
    );
  }

  for (final e in trainingDayItems) {
    add(e, trainingDays);
  }
  for (final e in restDayItems) {
    add(e, restDays);
  }
  final list = acc.values.toList()
    ..sort((a, b) {
      final ca = a.category?.index ?? 99, cb = b.category?.index ?? 99;
      return ca != cb ? ca.compareTo(cb) : b.grams.compareTo(a.grams);
    });
  return list;
}

/// Human-friendly quantity: "30 eggs" / "7 loaves" / "2.5 kg" / "750 g" / "1.5 L".
String formatGroceryQty(
  GroceryLine line,
  String lang, {
  required String gramUnit,
  required String kgUnit,
  required String literUnit,
}) {
  final f = line.food;
  if (f != null && f.countable && f.unitGrams != null) {
    final count = (line.grams / f.unitGrams! - 1e-9).ceil();
    final unit = lang == 'ar' ? f.unitAr! : _pluralEn(f.unitEn!, count);
    return '$count $unit';
  }
  if (f != null && f.liquid) {
    final l = (line.grams / 1000 / 0.25 - 1e-9).ceil() * 0.25;
    return '${_fmt(math.max(0.25, l))} $literUnit';
  }
  if (line.grams >= 1000) {
    final kg = (line.grams / 1000 / 0.25 - 1e-9).ceil() * 0.25;
    return '${_fmt(kg)} $kgUnit';
  }
  final g = math.max(50, (line.grams / 50 - 1e-9).ceil() * 50);
  return '$g $gramUnit';
}

String _pluralEn(String unit, int n) {
  if (n == 1) return unit;
  if (unit == 'loaf') return 'loaves';
  if (unit.endsWith('h')) return '${unit}es';
  return '${unit}s';
}

String _fmt(double v) => v == v.roundToDouble() ? v.toInt().toString() : v.toStringAsFixed(2).replaceFirst(RegExp(r'0+$'), '');
