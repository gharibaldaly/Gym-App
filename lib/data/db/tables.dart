import 'package:drift/drift.dart';

// JSON columns are stored as TEXT and decoded in repositories.
// Dates that represent a "day" are stored as DateTime at local midnight.

/// Single-row table (id = 1) holding every onboarding answer + computed targets.
class UserProfiles extends Table {
  IntColumn get id => integer()();
  TextColumn get language => text().withDefault(const Constant('ar'))();
  TextColumn get sex => text().nullable()(); // male / female
  IntColumn get age => integer().nullable()();
  RealColumn get heightCm => real().nullable()();
  RealColumn get weightKg => real().nullable()();
  RealColumn get bodyFatPct => real().nullable()();
  TextColumn get bodyFatMethod => text().nullable()(); // number / shape / unknown
  TextColumn get measurementsJson => text().withDefault(const Constant('{}'))();
  TextColumn get goal => text().nullable()(); // bulk / cut / recomp / strength / fitness
  RealColumn get targetWeightKg => real().nullable()();
  IntColumn get goalWeeks => integer().nullable()();
  TextColumn get level => text().nullable()(); // beginner / intermediate / advanced
  TextColumn get trainingExperience => text().nullable()(); // free text / months
  IntColumn get daysPerWeek => integer().nullable()();
  TextColumn get trainingDaysJson => text().withDefault(const Constant('[]'))(); // [DateTime.weekday]
  IntColumn get sessionMinutes => integer().nullable()();
  TextColumn get splitPreference => text().nullable()(); // muscle_group / bro / full_body / ppl / upper_lower / ai
  TextColumn get focusMusclesJson => text().withDefault(const Constant('[]'))();
  TextColumn get location => text().nullable()(); // full_gym / limited_gym / home
  TextColumn get injuriesJson => text().withDefault(const Constant('[]'))();
  TextColumn get injuriesNote => text().nullable()();
  TextColumn get jobType => text().nullable()(); // desk / mobile / physical
  TextColumn get jobHours => text().nullable()();
  TextColumn get sleepTime => text().nullable()(); // "23:30"
  TextColumn get wakeTime => text().nullable()(); // "07:00"
  TextColumn get trainingTimeOfDay => text().nullable()(); // morning / after_work / night
  TextColumn get trainingTime => text().nullable()(); // "18:00"
  TextColumn get cardioType => text().nullable()();
  IntColumn get cardioPerWeek => integer().nullable()();
  IntColumn get mealsPerDay => integer().nullable()();
  TextColumn get mealTimesJson => text().withDefault(const Constant('[]'))(); // ["08:00", ...]
  TextColumn get likedFoods => text().nullable()();
  TextColumn get dislikedFoods => text().nullable()();
  TextColumn get allergies => text().nullable()();
  TextColumn get budgetLevel => text().nullable()(); // low / medium / open
  IntColumn get budgetEgp => integer().nullable()();
  TextColumn get supplementsJson => text().withDefault(const Constant('[]'))(); // [{name,dose}]
  IntColumn get waterGoalMl => integer().nullable()();
  BoolColumn get healthConnectEnabled => boolean().withDefault(const Constant(false))();
  // Computed / AI-set targets
  RealColumn get bmr => real().nullable()();
  RealColumn get tdee => real().nullable()();
  IntColumn get calorieTarget => integer().nullable()();
  IntColumn get proteinG => integer().nullable()();
  IntColumn get carbsG => integer().nullable()();
  IntColumn get fatG => integer().nullable()();
  IntColumn get trainingDayCarbsG => integer().nullable()();
  IntColumn get restDayCarbsG => integer().nullable()();
  BoolColumn get onboardingComplete => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Exercises extends Table {
  TextColumn get id => text()(); // seed id or "custom_<uuid>"
  TextColumn get nameEn => text()();
  TextColumn get nameAr => text()();
  TextColumn get primaryMusclesJson => text().withDefault(const Constant('[]'))();
  TextColumn get secondaryMusclesJson => text().withDefault(const Constant('[]'))();
  TextColumn get equipment => text().nullable()(); // barbell / dumbbell / cable / machine / body only / ...
  TextColumn get force => text().nullable()(); // push / pull / static
  TextColumn get movementPattern => text().nullable()(); // push / pull / legs / core / carry / cardio / stretch
  TextColumn get mechanic => text().nullable()(); // compound / isolation
  TextColumn get category => text().nullable()(); // strength / stretching / cardio / ...
  TextColumn get level => text().nullable()();
  TextColumn get instructionsEnJson => text().withDefault(const Constant('[]'))();
  TextColumn get instructionsArJson => text().withDefault(const Constant('[]'))();
  TextColumn get mistakesEnJson => text().withDefault(const Constant('[]'))();
  TextColumn get mistakesArJson => text().withDefault(const Constant('[]'))();
  TextColumn get imagesJson => text().withDefault(const Constant('[]'))(); // remote relative paths
  TextColumn get mediaPath => text().nullable()(); // local file for custom exercise photo
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class WorkoutPlans extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get notes => text().nullable()();
  TextColumn get source => text().withDefault(const Constant('ai'))(); // ai / manual
  BoolColumn get isActive => boolean().withDefault(const Constant(false))();
  IntColumn get deloadEveryWeeks => integer().nullable()();
  TextColumn get rawJson => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get activatedAt => dateTime().nullable()();
}

class PlanDays extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get planId => integer().references(WorkoutPlans, #id, onDelete: KeyAction.cascade)();
  IntColumn get weekday => integer().nullable()(); // DateTime.weekday 1=Mon..7=Sun
  IntColumn get orderIndex => integer().withDefault(const Constant(0))();
  TextColumn get name => text()(); // "Push A"
  TextColumn get focus => text().nullable()();
  TextColumn get warmupJson => text().withDefault(const Constant('[]'))(); // [String]
  TextColumn get cooldownJson => text().withDefault(const Constant('[]'))(); // [String]
  BoolColumn get isRest => boolean().withDefault(const Constant(false))();
}

class PlanExercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get planDayId => integer().references(PlanDays, #id, onDelete: KeyAction.cascade)();
  TextColumn get exerciseId => text().references(Exercises, #id)();
  IntColumn get orderIndex => integer().withDefault(const Constant(0))();
  IntColumn get sets => integer().withDefault(const Constant(3))();
  IntColumn get repMin => integer().withDefault(const Constant(8))();
  IntColumn get repMax => integer().withDefault(const Constant(12))();
  RealColumn get suggestedWeightKg => real().nullable()();
  RealColumn get targetRpe => real().nullable()();
  IntColumn get restSeconds => integer().withDefault(const Constant(90))();
  TextColumn get notes => text().nullable()();
}

class WorkoutSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()(); // local midnight
  IntColumn get planDayId => integer().nullable().references(PlanDays, #id, onDelete: KeyAction.setNull)();
  TextColumn get name => text().nullable()();
  DateTimeColumn get startedAt => dateTime().nullable()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  TextColumn get status => text().withDefault(const Constant('in_progress'))(); // in_progress / completed / partial / missed
  TextColumn get notes => text().nullable()();
  RealColumn get totalVolume => real().nullable()();
  TextColumn get aiSummary => text().nullable()();
  BoolColumn get isDeload => boolean().withDefault(const Constant(false))();
}

class SetLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().references(WorkoutSessions, #id, onDelete: KeyAction.cascade)();
  TextColumn get exerciseId => text().references(Exercises, #id)();
  IntColumn get setIndex => integer()();
  RealColumn get weightKg => real()();
  IntColumn get reps => integer()();
  RealColumn get rpe => real().nullable()();
  TextColumn get setType => text().withDefault(const Constant('normal'))(); // normal / warmup / drop / failure
  BoolColumn get isPr => boolean().withDefault(const Constant(false))();
  TextColumn get prTypes => text().nullable()(); // comma list: weight,reps,e1rm
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class SessionExerciseNotes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().references(WorkoutSessions, #id, onDelete: KeyAction.cascade)();
  TextColumn get exerciseId => text()();
  TextColumn get note => text()();
}

class CardioLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().nullable().references(WorkoutSessions, #id, onDelete: KeyAction.setNull)();
  DateTimeColumn get date => dateTime()();
  TextColumn get type => text()(); // treadmill / bike / elliptical / rowing / walk / run / stairs / jump_rope / swim / other
  RealColumn get durationMin => real()();
  RealColumn get speedKmh => real().nullable()();
  RealColumn get inclinePct => real().nullable()();
  IntColumn get level => integer().nullable()();
  RealColumn get calories => real().nullable()();
  TextColumn get notes => text().nullable()();
}

class MealPlans extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  BoolColumn get isActive => boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().nullable()();
  TextColumn get rawJson => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class PlannedMeals extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get mealPlanId => integer().references(MealPlans, #id, onDelete: KeyAction.cascade)();
  TextColumn get dayType => text().withDefault(const Constant('all'))(); // training / rest / all
  IntColumn get mealIndex => integer()();
  TextColumn get name => text()(); // "Breakfast"
  TextColumn get time => text().nullable()(); // "08:00"
  TextColumn get itemsJson => text().withDefault(const Constant('[]'))(); // [{name,grams,calories,protein,carbs,fat}]
  RealColumn get calories => real().withDefault(const Constant(0))();
  RealColumn get protein => real().withDefault(const Constant(0))();
  RealColumn get carbs => real().withDefault(const Constant(0))();
  RealColumn get fat => real().withDefault(const Constant(0))();
}

class MealLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()(); // local midnight
  DateTimeColumn get loggedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get mealIndex => integer().nullable()();
  IntColumn get plannedMealId => integer().nullable()();
  TextColumn get name => text()();
  TextColumn get itemsJson => text().withDefault(const Constant('[]'))();
  RealColumn get calories => real().withDefault(const Constant(0))();
  RealColumn get protein => real().withDefault(const Constant(0))();
  RealColumn get carbs => real().withDefault(const Constant(0))();
  RealColumn get fat => real().withDefault(const Constant(0))();
  TextColumn get photoPath => text().nullable()();
  TextColumn get source => text().withDefault(const Constant('manual'))(); // ai_photo / ai_text / manual / saved / plan / supplement
  RealColumn get confidence => real().nullable()();
  TextColumn get status => text().withDefault(const Constant('done'))(); // done / pending_ai
}

/// "My foods" – saved meals for one-tap logging without AI.
class FoodItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get itemsJson => text().withDefault(const Constant('[]'))();
  RealColumn get calories => real()();
  RealColumn get protein => real()();
  RealColumn get carbs => real()();
  RealColumn get fat => real()();
  IntColumn get useCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastUsed => dateTime().nullable()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
}

class BodyMetrics extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  RealColumn get weightKg => real().nullable()();
  RealColumn get waistCm => real().nullable()();
  RealColumn get chestCm => real().nullable()();
  RealColumn get armCm => real().nullable()();
  RealColumn get thighCm => real().nullable()();
  RealColumn get neckCm => real().nullable()();
  RealColumn get hipsCm => real().nullable()();
  RealColumn get bodyFatPct => real().nullable()();
}

class ProgressPhotos extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get angle => text()(); // front / side / back
  TextColumn get path => text()(); // relative to app documents dir
}

class WaterLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get timestamp => dateTime()();
  IntColumn get amountMl => integer()();
  TextColumn get source => text().withDefault(const Constant('manual'))();
}

class Supplements extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get dose => text().nullable()();
  TextColumn get timing => text().nullable()();
  RealColumn get proteinG => real().withDefault(const Constant(0))();
  RealColumn get calories => real().withDefault(const Constant(0))();
  RealColumn get carbsG => real().withDefault(const Constant(0))();
  RealColumn get fatG => real().withDefault(const Constant(0))();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
}

class SupplementLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  IntColumn get supplementId => integer().references(Supplements, #id, onDelete: KeyAction.cascade)();
  BoolColumn get taken => boolean().withDefault(const Constant(true))();
  TextColumn get source => text().withDefault(const Constant('manual'))();
}

class SleepLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()(); // date of waking up (local midnight)
  DateTimeColumn get start => dateTime().nullable()();
  DateTimeColumn get end => dateTime().nullable()();
  IntColumn get durationMin => integer()();
  IntColumn get quality => integer().nullable()(); // 1-5
  IntColumn get deepMin => integer().nullable()();
  IntColumn get remMin => integer().nullable()();
  IntColumn get lightMin => integer().nullable()();
  IntColumn get awakeMin => integer().nullable()();
  TextColumn get source => text().withDefault(const Constant('manual'))(); // manual / health_connect
}

class HealthDaily extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime().unique()();
  IntColumn get steps => integer().nullable()();
  RealColumn get restingHr => real().nullable()();
  RealColumn get avgHr => real().nullable()();
  RealColumn get hrv => real().nullable()();
  RealColumn get activeCalories => real().nullable()();
  IntColumn get recoveryScore => integer().nullable()();
  TextColumn get sourcesJson => text().withDefault(const Constant('[]'))(); // app package names that wrote data
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
}

class CoachMessages extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get role => text()(); // user / assistant
  TextColumn get content => text()();
  TextColumn get kind => text().withDefault(const Constant('chat'))(); // chat / morning / workout_summary / plateau / weekly / recovery / offline_notice
  TextColumn get metaJson => text().nullable()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class CoachMemories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get content => text()();
  TextColumn get source => text().withDefault(const Constant('chat'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class CoachProposals extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => text()(); // plan_change / swap_exercise / log_meal / log_set / adjust_macros / recovery_adjust / deload
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get payloadJson => text()();
  TextColumn get status => text().withDefault(const Constant('pending'))(); // pending / accepted / rejected
  IntColumn get messageId => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get resolvedAt => dateTime().nullable()();
}

class AiUsage extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
  TextColumn get feature => text()();
  TextColumn get model => text()();
  IntColumn get inputTokens => integer().withDefault(const Constant(0))();
  IntColumn get outputTokens => integer().withDefault(const Constant(0))();
  IntColumn get cacheReadTokens => integer().withDefault(const Constant(0))();
  IntColumn get cacheWriteTokens => integer().withDefault(const Constant(0))();
  RealColumn get costUsd => real().withDefault(const Constant(0))();
}

class AiQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get feature => text()();
  TextColumn get payloadJson => text()();
  TextColumn get status => text().withDefault(const Constant('pending'))(); // pending / done / failed
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
