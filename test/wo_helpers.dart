import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:ironmind/core/providers.dart';

/// In-memory DB seeded with the bundled free-exercise-db exercises (FK targets).
Future<AppDatabase> woTestDb({bool seed = true}) async {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  final db = AppDatabase(NativeDatabase.memory());
  if (seed) {
    final list = jsonDecode(File('assets/data/free-exercise-db.json').readAsStringSync()) as List;
    await db.batch((b) {
      for (final raw in list.cast<Map<String, dynamic>>()) {
        b.insert(
          db.exercises,
          ExercisesCompanion.insert(
            id: raw['id'] as String,
            nameEn: raw['name'] as String,
            nameAr: '',
            primaryMusclesJson: Value(jsonEncode(raw['primaryMuscles'] ?? const [])),
            secondaryMusclesJson: Value(jsonEncode(raw['secondaryMuscles'] ?? const [])),
            equipment: Value(raw['equipment'] as String?),
            force: Value(raw['force'] as String?),
            mechanic: Value(raw['mechanic'] as String?),
            category: Value(raw['category'] as String?),
            level: Value(raw['level'] as String?),
          ),
        );
      }
    });
  }
  return db;
}

Set<String> seedExerciseIds() {
  final list = jsonDecode(File('assets/data/free-exercise-db.json').readAsStringSync()) as List;
  return list.map((e) => (e as Map)['id'] as String).toSet();
}
