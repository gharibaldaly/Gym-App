import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';

/// Base URL for free-exercise-db images (public domain / Unlicense).
const exerciseImageBaseUrl = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/';

class ExerciseRepository {
  final AppDatabase db;
  ExerciseRepository(this.db);

  Future<Exercise?> byId(String id) => (db.select(db.exercises)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<Exercise>> byIds(Iterable<String> ids) =>
      (db.select(db.exercises)..where((t) => t.id.isIn(ids.toList()))).get();

  Future<List<Exercise>> all() => (db.select(db.exercises)..orderBy([(t) => OrderingTerm.asc(t.nameEn)])).get();

  Future<int> count() async {
    final c = db.exercises.id.count();
    return (await (db.selectOnly(db.exercises)..addColumns([c])).map((r) => r.read(c)).getSingle()) ?? 0;
  }

  /// Search by name (ar/en), filter by muscle (primary or secondary) and equipment.
  /// Every whitespace-separated word of [query] must match the English or Arabic
  /// name ("db bench" finds "Dumbbell Bench Press" via [expandSearchToken]).
  Stream<List<Exercise>> watchSearch({
    String query = '',
    String? muscle,
    String? equipment,
    bool favoritesOnly = false,
    bool customOnly = false,
  }) {
    final q = db.select(db.exercises);
    q.where((t) {
      Expression<bool> e = const Constant(true);
      for (final token in query.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty)) {
        Expression<bool> any = const Constant(false);
        for (final variant in expandSearchToken(token)) {
          any = any | t.nameEn.lower().like('%${variant.toLowerCase()}%') | t.nameAr.like('%$variant%');
        }
        e = e & any;
      }
      if (muscle != null) {
        e = e & (t.primaryMusclesJson.like('%"$muscle"%') | t.secondaryMusclesJson.like('%"$muscle"%'));
      }
      if (equipment != null) e = e & t.equipment.equals(equipment);
      if (favoritesOnly) e = e & t.isFavorite.equals(true);
      if (customOnly) e = e & t.isCustom.equals(true);
      return e;
    });
    q.orderBy([(t) => OrderingTerm.desc(t.isFavorite), (t) => OrderingTerm.asc(t.nameEn)]);
    return q.watch();
  }

  Stream<Exercise?> watchById(String id) =>
      (db.select(db.exercises)..where((t) => t.id.equals(id))).watchSingleOrNull();

  /// Exercises whose primary muscles include [muscle] (for AI candidate lists).
  Future<List<Exercise>> byPrimaryMuscle(String muscle, {String? excludeId}) => (db.select(db.exercises)
        ..where((t) {
          Expression<bool> e = t.primaryMusclesJson.like('%"$muscle"%');
          if (excludeId != null) e = e & t.id.equals(excludeId).not();
          return e;
        }))
      .get();

  /// Inserts a user-created exercise (id must start with `custom_`).
  Future<void> insertCustom(ExercisesCompanion e) =>
      db.into(db.exercises).insertOnConflictUpdate(e.copyWith(isCustom: const Value(true)));

  /// True when the exercise is referenced by logged sets or plans.
  Future<bool> isInUse(String id) async {
    final s = await (db.select(db.setLogs)
          ..where((t) => t.exerciseId.equals(id))
          ..limit(1))
        .get();
    if (s.isNotEmpty) return true;
    final p = await (db.select(db.planExercises)
          ..where((t) => t.exerciseId.equals(id))
          ..limit(1))
        .get();
    return p.isNotEmpty;
  }

  /// Deletes a custom exercise that is not used anywhere. Returns false when it is in use.
  Future<bool> deleteCustom(String id) async {
    if (!id.startsWith('custom_') || await isInUse(id)) return false;
    await (db.delete(db.exercises)..where((t) => t.id.equals(id) & t.isCustom.equals(true))).go();
    return true;
  }

  Future<void> setFavorite(String id, bool fav) =>
      (db.update(db.exercises)..where((t) => t.id.equals(id))).write(ExercisesCompanion(isFavorite: Value(fav)));

  Future<void> upsert(ExercisesCompanion e) => db.into(db.exercises).insertOnConflictUpdate(e);

  /// Local alternatives: same primary muscle (+ same force/pattern when known),
  /// excluding [exclude]. Ranked by overlap of muscles and same mechanic.
  Future<List<Exercise>> localAlternatives(Exercise ex, {int limit = 3, String? location}) async {
    final primary = ex.primaryMuscles;
    if (primary.isEmpty) return [];
    final candidates = await (db.select(db.exercises)
          ..where((t) => t.primaryMusclesJson.like('%"${primary.first}"%') & t.id.equals(ex.id).not()))
        .get();
    int scoreOf(Exercise c) {
      var s = 0;
      if (c.force != null && c.force == ex.force) s += 3;
      if (c.mechanic != null && c.mechanic == ex.mechanic) s += 2;
      if (c.category == ex.category) s += 2;
      s += c.primaryMuscles.where(primary.contains).length * 2;
      s += c.secondaryMuscles.where(ex.secondaryMuscles.contains).length;
      if (c.equipment != ex.equipment) s += 1; // a different tool is usually the reason to swap
      if (location == 'home' && !const {'body only', 'dumbbell', 'bands', 'kettlebells'}.contains(c.equipment)) {
        s -= 5;
      }
      if (c.isFavorite) s += 1;
      return s;
    }

    candidates.sort((a, b) => scoreOf(b).compareTo(scoreOf(a)));
    return candidates.take(limit).toList();
  }
}

extension ExerciseX on Exercise {
  List<String> get primaryMuscles => (jsonDecode(primaryMusclesJson) as List).cast<String>();
  List<String> get secondaryMuscles => (jsonDecode(secondaryMusclesJson) as List).cast<String>();
  List<String> get instructionsEn => (jsonDecode(instructionsEnJson) as List).cast<String>();
  List<String> get instructionsAr => (jsonDecode(instructionsArJson) as List).cast<String>();
  List<String> get mistakesEn => (jsonDecode(mistakesEnJson) as List).cast<String>();
  List<String> get mistakesAr => (jsonDecode(mistakesArJson) as List).cast<String>();
  List<String> get imagePaths => (jsonDecode(imagesJson) as List).cast<String>();
  List<String> get imageUrls => imagePaths.map((p) => '$exerciseImageBaseUrl$p').toList();

  String name(String lang) => lang == 'ar' && nameAr.isNotEmpty ? nameAr : nameEn;

  List<String> instructions(String lang) =>
      lang == 'ar' && instructionsAr.isNotEmpty ? instructionsAr : instructionsEn;

  List<String> mistakes(String lang) => lang == 'ar' && mistakesAr.isNotEmpty ? mistakesAr : mistakesEn;

  bool get isLowerBody => primaryMuscles.any(const {
        'quadriceps',
        'hamstrings',
        'glutes',
        'calves',
        'adductors',
        'abductors',
      }.contains);
}

/// Search variants for one query word: common gym abbreviations and Arabic
/// spelling variants (أ/إ/ا, ة/ه, ى/ي).
List<String> expandSearchToken(String token) {
  final t = token.toLowerCase();
  const abbr = {
    'db': 'dumbbell',
    'dumbell': 'dumbbell',
    'bb': 'barbell',
    'kb': 'kettlebell',
    'ez': 'e-z',
    'ohp': 'overhead press',
    'rdl': 'romanian deadlift',
    'pushup': 'push-up',
    'pullup': 'pull-up',
    'chinup': 'chin-up',
    'situp': 'sit-up',
  };
  final out = <String>{token};
  if (abbr.containsKey(t)) out.add(abbr[t]!);
  if (RegExp(r'[\u0600-\u06FF]').hasMatch(token)) {
    final base = token.replaceAll(RegExp('[أإآ]'), 'ا');
    out
      ..add(base)
      ..add(base.replaceAll('ة', 'ه'))
      ..add(base.replaceAll('ه', 'ة'))
      ..add(base.replaceAll('ى', 'ي'))
      ..add(base.replaceAll('ي', 'ى'));
    // Words often written with hamza: "اطالة" ↔ "إطالة".
    if (base.startsWith('ا')) out.add('إ${base.substring(1)}');
    if (base.startsWith('ا')) out.add('أ${base.substring(1)}');
  }
  return out.toList();
}

final exerciseRepositoryProvider =
    Provider<ExerciseRepository>((ref) => ExerciseRepository(ref.watch(databaseProvider)));
