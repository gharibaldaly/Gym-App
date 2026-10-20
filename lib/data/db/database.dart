import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

export 'tables.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    UserProfiles,
    Exercises,
    WorkoutPlans,
    PlanDays,
    PlanExercises,
    WorkoutSessions,
    SetLogs,
    SessionExerciseNotes,
    CardioLogs,
    MealPlans,
    PlannedMeals,
    MealLogs,
    FoodItems,
    BodyMetrics,
    ProgressPhotos,
    WaterLogs,
    Supplements,
    SupplementLogs,
    SleepLogs,
    HealthDaily,
    CoachMessages,
    CoachMemories,
    CoachProposals,
    AiUsage,
    AiQueue,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  /// File name of the SQLite database inside the app documents directory.
  static const dbName = 'ironmind';

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _createIndexes();
        },
        onUpgrade: (m, from, to) async {
          // Add stepwise migrations here, e.g.
          // if (from < 2) { await m.addColumn(exercises, exercises.someNewColumn); }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  Future<void> _createIndexes() async {
    const stmts = [
      'CREATE INDEX IF NOT EXISTS idx_sessions_date ON workout_sessions(date)',
      'CREATE INDEX IF NOT EXISTS idx_setlogs_exercise ON set_logs(exercise_id)',
      'CREATE INDEX IF NOT EXISTS idx_setlogs_session ON set_logs(session_id)',
      'CREATE INDEX IF NOT EXISTS idx_meallogs_date ON meal_logs(date)',
      'CREATE INDEX IF NOT EXISTS idx_water_ts ON water_logs(timestamp)',
      'CREATE INDEX IF NOT EXISTS idx_body_date ON body_metrics(date)',
      'CREATE INDEX IF NOT EXISTS idx_sleep_date ON sleep_logs(date)',
      'CREATE INDEX IF NOT EXISTS idx_usage_ts ON ai_usage(timestamp)',
    ];
    for (final s in stmts) {
      await customStatement(s);
    }
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(name: dbName);
  }
}
