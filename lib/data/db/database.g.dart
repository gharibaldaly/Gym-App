// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UserProfilesTable extends UserProfiles
    with TableInfo<$UserProfilesTable, UserProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('ar'),
  );
  static const VerificationMeta _sexMeta = const VerificationMeta('sex');
  @override
  late final GeneratedColumn<String> sex = GeneratedColumn<String>(
    'sex',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
    'age',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heightCmMeta = const VerificationMeta(
    'heightCm',
  );
  @override
  late final GeneratedColumn<double> heightCm = GeneratedColumn<double>(
    'height_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bodyFatPctMeta = const VerificationMeta(
    'bodyFatPct',
  );
  @override
  late final GeneratedColumn<double> bodyFatPct = GeneratedColumn<double>(
    'body_fat_pct',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bodyFatMethodMeta = const VerificationMeta(
    'bodyFatMethod',
  );
  @override
  late final GeneratedColumn<String> bodyFatMethod = GeneratedColumn<String>(
    'body_fat_method',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _measurementsJsonMeta = const VerificationMeta(
    'measurementsJson',
  );
  @override
  late final GeneratedColumn<String> measurementsJson = GeneratedColumn<String>(
    'measurements_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _goalMeta = const VerificationMeta('goal');
  @override
  late final GeneratedColumn<String> goal = GeneratedColumn<String>(
    'goal',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetWeightKgMeta = const VerificationMeta(
    'targetWeightKg',
  );
  @override
  late final GeneratedColumn<double> targetWeightKg = GeneratedColumn<double>(
    'target_weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _goalWeeksMeta = const VerificationMeta(
    'goalWeeks',
  );
  @override
  late final GeneratedColumn<int> goalWeeks = GeneratedColumn<int>(
    'goal_weeks',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
    'level',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trainingExperienceMeta =
      const VerificationMeta('trainingExperience');
  @override
  late final GeneratedColumn<String> trainingExperience =
      GeneratedColumn<String>(
        'training_experience',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _daysPerWeekMeta = const VerificationMeta(
    'daysPerWeek',
  );
  @override
  late final GeneratedColumn<int> daysPerWeek = GeneratedColumn<int>(
    'days_per_week',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trainingDaysJsonMeta = const VerificationMeta(
    'trainingDaysJson',
  );
  @override
  late final GeneratedColumn<String> trainingDaysJson = GeneratedColumn<String>(
    'training_days_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _sessionMinutesMeta = const VerificationMeta(
    'sessionMinutes',
  );
  @override
  late final GeneratedColumn<int> sessionMinutes = GeneratedColumn<int>(
    'session_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _splitPreferenceMeta = const VerificationMeta(
    'splitPreference',
  );
  @override
  late final GeneratedColumn<String> splitPreference = GeneratedColumn<String>(
    'split_preference',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _focusMusclesJsonMeta = const VerificationMeta(
    'focusMusclesJson',
  );
  @override
  late final GeneratedColumn<String> focusMusclesJson = GeneratedColumn<String>(
    'focus_muscles_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _injuriesJsonMeta = const VerificationMeta(
    'injuriesJson',
  );
  @override
  late final GeneratedColumn<String> injuriesJson = GeneratedColumn<String>(
    'injuries_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _injuriesNoteMeta = const VerificationMeta(
    'injuriesNote',
  );
  @override
  late final GeneratedColumn<String> injuriesNote = GeneratedColumn<String>(
    'injuries_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _jobTypeMeta = const VerificationMeta(
    'jobType',
  );
  @override
  late final GeneratedColumn<String> jobType = GeneratedColumn<String>(
    'job_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _jobHoursMeta = const VerificationMeta(
    'jobHours',
  );
  @override
  late final GeneratedColumn<String> jobHours = GeneratedColumn<String>(
    'job_hours',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sleepTimeMeta = const VerificationMeta(
    'sleepTime',
  );
  @override
  late final GeneratedColumn<String> sleepTime = GeneratedColumn<String>(
    'sleep_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _wakeTimeMeta = const VerificationMeta(
    'wakeTime',
  );
  @override
  late final GeneratedColumn<String> wakeTime = GeneratedColumn<String>(
    'wake_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trainingTimeOfDayMeta = const VerificationMeta(
    'trainingTimeOfDay',
  );
  @override
  late final GeneratedColumn<String> trainingTimeOfDay =
      GeneratedColumn<String>(
        'training_time_of_day',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _trainingTimeMeta = const VerificationMeta(
    'trainingTime',
  );
  @override
  late final GeneratedColumn<String> trainingTime = GeneratedColumn<String>(
    'training_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cardioTypeMeta = const VerificationMeta(
    'cardioType',
  );
  @override
  late final GeneratedColumn<String> cardioType = GeneratedColumn<String>(
    'cardio_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cardioPerWeekMeta = const VerificationMeta(
    'cardioPerWeek',
  );
  @override
  late final GeneratedColumn<int> cardioPerWeek = GeneratedColumn<int>(
    'cardio_per_week',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mealsPerDayMeta = const VerificationMeta(
    'mealsPerDay',
  );
  @override
  late final GeneratedColumn<int> mealsPerDay = GeneratedColumn<int>(
    'meals_per_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mealTimesJsonMeta = const VerificationMeta(
    'mealTimesJson',
  );
  @override
  late final GeneratedColumn<String> mealTimesJson = GeneratedColumn<String>(
    'meal_times_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _likedFoodsMeta = const VerificationMeta(
    'likedFoods',
  );
  @override
  late final GeneratedColumn<String> likedFoods = GeneratedColumn<String>(
    'liked_foods',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dislikedFoodsMeta = const VerificationMeta(
    'dislikedFoods',
  );
  @override
  late final GeneratedColumn<String> dislikedFoods = GeneratedColumn<String>(
    'disliked_foods',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _allergiesMeta = const VerificationMeta(
    'allergies',
  );
  @override
  late final GeneratedColumn<String> allergies = GeneratedColumn<String>(
    'allergies',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _budgetLevelMeta = const VerificationMeta(
    'budgetLevel',
  );
  @override
  late final GeneratedColumn<String> budgetLevel = GeneratedColumn<String>(
    'budget_level',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _budgetEgpMeta = const VerificationMeta(
    'budgetEgp',
  );
  @override
  late final GeneratedColumn<int> budgetEgp = GeneratedColumn<int>(
    'budget_egp',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _supplementsJsonMeta = const VerificationMeta(
    'supplementsJson',
  );
  @override
  late final GeneratedColumn<String> supplementsJson = GeneratedColumn<String>(
    'supplements_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _waterGoalMlMeta = const VerificationMeta(
    'waterGoalMl',
  );
  @override
  late final GeneratedColumn<int> waterGoalMl = GeneratedColumn<int>(
    'water_goal_ml',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _healthConnectEnabledMeta =
      const VerificationMeta('healthConnectEnabled');
  @override
  late final GeneratedColumn<bool> healthConnectEnabled = GeneratedColumn<bool>(
    'health_connect_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("health_connect_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _bmrMeta = const VerificationMeta('bmr');
  @override
  late final GeneratedColumn<double> bmr = GeneratedColumn<double>(
    'bmr',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tdeeMeta = const VerificationMeta('tdee');
  @override
  late final GeneratedColumn<double> tdee = GeneratedColumn<double>(
    'tdee',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _calorieTargetMeta = const VerificationMeta(
    'calorieTarget',
  );
  @override
  late final GeneratedColumn<int> calorieTarget = GeneratedColumn<int>(
    'calorie_target',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _proteinGMeta = const VerificationMeta(
    'proteinG',
  );
  @override
  late final GeneratedColumn<int> proteinG = GeneratedColumn<int>(
    'protein_g',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _carbsGMeta = const VerificationMeta('carbsG');
  @override
  late final GeneratedColumn<int> carbsG = GeneratedColumn<int>(
    'carbs_g',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fatGMeta = const VerificationMeta('fatG');
  @override
  late final GeneratedColumn<int> fatG = GeneratedColumn<int>(
    'fat_g',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trainingDayCarbsGMeta = const VerificationMeta(
    'trainingDayCarbsG',
  );
  @override
  late final GeneratedColumn<int> trainingDayCarbsG = GeneratedColumn<int>(
    'training_day_carbs_g',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _restDayCarbsGMeta = const VerificationMeta(
    'restDayCarbsG',
  );
  @override
  late final GeneratedColumn<int> restDayCarbsG = GeneratedColumn<int>(
    'rest_day_carbs_g',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _onboardingCompleteMeta =
      const VerificationMeta('onboardingComplete');
  @override
  late final GeneratedColumn<bool> onboardingComplete = GeneratedColumn<bool>(
    'onboarding_complete',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_complete" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    language,
    sex,
    age,
    heightCm,
    weightKg,
    bodyFatPct,
    bodyFatMethod,
    measurementsJson,
    goal,
    targetWeightKg,
    goalWeeks,
    level,
    trainingExperience,
    daysPerWeek,
    trainingDaysJson,
    sessionMinutes,
    splitPreference,
    focusMusclesJson,
    location,
    injuriesJson,
    injuriesNote,
    jobType,
    jobHours,
    sleepTime,
    wakeTime,
    trainingTimeOfDay,
    trainingTime,
    cardioType,
    cardioPerWeek,
    mealsPerDay,
    mealTimesJson,
    likedFoods,
    dislikedFoods,
    allergies,
    budgetLevel,
    budgetEgp,
    supplementsJson,
    waterGoalMl,
    healthConnectEnabled,
    bmr,
    tdee,
    calorieTarget,
    proteinG,
    carbsG,
    fatG,
    trainingDayCarbsG,
    restDayCarbsG,
    onboardingComplete,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    }
    if (data.containsKey('sex')) {
      context.handle(
        _sexMeta,
        sex.isAcceptableOrUnknown(data['sex']!, _sexMeta),
      );
    }
    if (data.containsKey('age')) {
      context.handle(
        _ageMeta,
        age.isAcceptableOrUnknown(data['age']!, _ageMeta),
      );
    }
    if (data.containsKey('height_cm')) {
      context.handle(
        _heightCmMeta,
        heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta),
      );
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    }
    if (data.containsKey('body_fat_pct')) {
      context.handle(
        _bodyFatPctMeta,
        bodyFatPct.isAcceptableOrUnknown(
          data['body_fat_pct']!,
          _bodyFatPctMeta,
        ),
      );
    }
    if (data.containsKey('body_fat_method')) {
      context.handle(
        _bodyFatMethodMeta,
        bodyFatMethod.isAcceptableOrUnknown(
          data['body_fat_method']!,
          _bodyFatMethodMeta,
        ),
      );
    }
    if (data.containsKey('measurements_json')) {
      context.handle(
        _measurementsJsonMeta,
        measurementsJson.isAcceptableOrUnknown(
          data['measurements_json']!,
          _measurementsJsonMeta,
        ),
      );
    }
    if (data.containsKey('goal')) {
      context.handle(
        _goalMeta,
        goal.isAcceptableOrUnknown(data['goal']!, _goalMeta),
      );
    }
    if (data.containsKey('target_weight_kg')) {
      context.handle(
        _targetWeightKgMeta,
        targetWeightKg.isAcceptableOrUnknown(
          data['target_weight_kg']!,
          _targetWeightKgMeta,
        ),
      );
    }
    if (data.containsKey('goal_weeks')) {
      context.handle(
        _goalWeeksMeta,
        goalWeeks.isAcceptableOrUnknown(data['goal_weeks']!, _goalWeeksMeta),
      );
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    }
    if (data.containsKey('training_experience')) {
      context.handle(
        _trainingExperienceMeta,
        trainingExperience.isAcceptableOrUnknown(
          data['training_experience']!,
          _trainingExperienceMeta,
        ),
      );
    }
    if (data.containsKey('days_per_week')) {
      context.handle(
        _daysPerWeekMeta,
        daysPerWeek.isAcceptableOrUnknown(
          data['days_per_week']!,
          _daysPerWeekMeta,
        ),
      );
    }
    if (data.containsKey('training_days_json')) {
      context.handle(
        _trainingDaysJsonMeta,
        trainingDaysJson.isAcceptableOrUnknown(
          data['training_days_json']!,
          _trainingDaysJsonMeta,
        ),
      );
    }
    if (data.containsKey('session_minutes')) {
      context.handle(
        _sessionMinutesMeta,
        sessionMinutes.isAcceptableOrUnknown(
          data['session_minutes']!,
          _sessionMinutesMeta,
        ),
      );
    }
    if (data.containsKey('split_preference')) {
      context.handle(
        _splitPreferenceMeta,
        splitPreference.isAcceptableOrUnknown(
          data['split_preference']!,
          _splitPreferenceMeta,
        ),
      );
    }
    if (data.containsKey('focus_muscles_json')) {
      context.handle(
        _focusMusclesJsonMeta,
        focusMusclesJson.isAcceptableOrUnknown(
          data['focus_muscles_json']!,
          _focusMusclesJsonMeta,
        ),
      );
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('injuries_json')) {
      context.handle(
        _injuriesJsonMeta,
        injuriesJson.isAcceptableOrUnknown(
          data['injuries_json']!,
          _injuriesJsonMeta,
        ),
      );
    }
    if (data.containsKey('injuries_note')) {
      context.handle(
        _injuriesNoteMeta,
        injuriesNote.isAcceptableOrUnknown(
          data['injuries_note']!,
          _injuriesNoteMeta,
        ),
      );
    }
    if (data.containsKey('job_type')) {
      context.handle(
        _jobTypeMeta,
        jobType.isAcceptableOrUnknown(data['job_type']!, _jobTypeMeta),
      );
    }
    if (data.containsKey('job_hours')) {
      context.handle(
        _jobHoursMeta,
        jobHours.isAcceptableOrUnknown(data['job_hours']!, _jobHoursMeta),
      );
    }
    if (data.containsKey('sleep_time')) {
      context.handle(
        _sleepTimeMeta,
        sleepTime.isAcceptableOrUnknown(data['sleep_time']!, _sleepTimeMeta),
      );
    }
    if (data.containsKey('wake_time')) {
      context.handle(
        _wakeTimeMeta,
        wakeTime.isAcceptableOrUnknown(data['wake_time']!, _wakeTimeMeta),
      );
    }
    if (data.containsKey('training_time_of_day')) {
      context.handle(
        _trainingTimeOfDayMeta,
        trainingTimeOfDay.isAcceptableOrUnknown(
          data['training_time_of_day']!,
          _trainingTimeOfDayMeta,
        ),
      );
    }
    if (data.containsKey('training_time')) {
      context.handle(
        _trainingTimeMeta,
        trainingTime.isAcceptableOrUnknown(
          data['training_time']!,
          _trainingTimeMeta,
        ),
      );
    }
    if (data.containsKey('cardio_type')) {
      context.handle(
        _cardioTypeMeta,
        cardioType.isAcceptableOrUnknown(data['cardio_type']!, _cardioTypeMeta),
      );
    }
    if (data.containsKey('cardio_per_week')) {
      context.handle(
        _cardioPerWeekMeta,
        cardioPerWeek.isAcceptableOrUnknown(
          data['cardio_per_week']!,
          _cardioPerWeekMeta,
        ),
      );
    }
    if (data.containsKey('meals_per_day')) {
      context.handle(
        _mealsPerDayMeta,
        mealsPerDay.isAcceptableOrUnknown(
          data['meals_per_day']!,
          _mealsPerDayMeta,
        ),
      );
    }
    if (data.containsKey('meal_times_json')) {
      context.handle(
        _mealTimesJsonMeta,
        mealTimesJson.isAcceptableOrUnknown(
          data['meal_times_json']!,
          _mealTimesJsonMeta,
        ),
      );
    }
    if (data.containsKey('liked_foods')) {
      context.handle(
        _likedFoodsMeta,
        likedFoods.isAcceptableOrUnknown(data['liked_foods']!, _likedFoodsMeta),
      );
    }
    if (data.containsKey('disliked_foods')) {
      context.handle(
        _dislikedFoodsMeta,
        dislikedFoods.isAcceptableOrUnknown(
          data['disliked_foods']!,
          _dislikedFoodsMeta,
        ),
      );
    }
    if (data.containsKey('allergies')) {
      context.handle(
        _allergiesMeta,
        allergies.isAcceptableOrUnknown(data['allergies']!, _allergiesMeta),
      );
    }
    if (data.containsKey('budget_level')) {
      context.handle(
        _budgetLevelMeta,
        budgetLevel.isAcceptableOrUnknown(
          data['budget_level']!,
          _budgetLevelMeta,
        ),
      );
    }
    if (data.containsKey('budget_egp')) {
      context.handle(
        _budgetEgpMeta,
        budgetEgp.isAcceptableOrUnknown(data['budget_egp']!, _budgetEgpMeta),
      );
    }
    if (data.containsKey('supplements_json')) {
      context.handle(
        _supplementsJsonMeta,
        supplementsJson.isAcceptableOrUnknown(
          data['supplements_json']!,
          _supplementsJsonMeta,
        ),
      );
    }
    if (data.containsKey('water_goal_ml')) {
      context.handle(
        _waterGoalMlMeta,
        waterGoalMl.isAcceptableOrUnknown(
          data['water_goal_ml']!,
          _waterGoalMlMeta,
        ),
      );
    }
    if (data.containsKey('health_connect_enabled')) {
      context.handle(
        _healthConnectEnabledMeta,
        healthConnectEnabled.isAcceptableOrUnknown(
          data['health_connect_enabled']!,
          _healthConnectEnabledMeta,
        ),
      );
    }
    if (data.containsKey('bmr')) {
      context.handle(
        _bmrMeta,
        bmr.isAcceptableOrUnknown(data['bmr']!, _bmrMeta),
      );
    }
    if (data.containsKey('tdee')) {
      context.handle(
        _tdeeMeta,
        tdee.isAcceptableOrUnknown(data['tdee']!, _tdeeMeta),
      );
    }
    if (data.containsKey('calorie_target')) {
      context.handle(
        _calorieTargetMeta,
        calorieTarget.isAcceptableOrUnknown(
          data['calorie_target']!,
          _calorieTargetMeta,
        ),
      );
    }
    if (data.containsKey('protein_g')) {
      context.handle(
        _proteinGMeta,
        proteinG.isAcceptableOrUnknown(data['protein_g']!, _proteinGMeta),
      );
    }
    if (data.containsKey('carbs_g')) {
      context.handle(
        _carbsGMeta,
        carbsG.isAcceptableOrUnknown(data['carbs_g']!, _carbsGMeta),
      );
    }
    if (data.containsKey('fat_g')) {
      context.handle(
        _fatGMeta,
        fatG.isAcceptableOrUnknown(data['fat_g']!, _fatGMeta),
      );
    }
    if (data.containsKey('training_day_carbs_g')) {
      context.handle(
        _trainingDayCarbsGMeta,
        trainingDayCarbsG.isAcceptableOrUnknown(
          data['training_day_carbs_g']!,
          _trainingDayCarbsGMeta,
        ),
      );
    }
    if (data.containsKey('rest_day_carbs_g')) {
      context.handle(
        _restDayCarbsGMeta,
        restDayCarbsG.isAcceptableOrUnknown(
          data['rest_day_carbs_g']!,
          _restDayCarbsGMeta,
        ),
      );
    }
    if (data.containsKey('onboarding_complete')) {
      context.handle(
        _onboardingCompleteMeta,
        onboardingComplete.isAcceptableOrUnknown(
          data['onboarding_complete']!,
          _onboardingCompleteMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      sex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sex'],
      ),
      age: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age'],
      ),
      heightCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height_cm'],
      ),
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      ),
      bodyFatPct: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}body_fat_pct'],
      ),
      bodyFatMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body_fat_method'],
      ),
      measurementsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}measurements_json'],
      )!,
      goal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal'],
      ),
      targetWeightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_weight_kg'],
      ),
      goalWeeks: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}goal_weeks'],
      ),
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}level'],
      ),
      trainingExperience: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}training_experience'],
      ),
      daysPerWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}days_per_week'],
      ),
      trainingDaysJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}training_days_json'],
      )!,
      sessionMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_minutes'],
      ),
      splitPreference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}split_preference'],
      ),
      focusMusclesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}focus_muscles_json'],
      )!,
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      injuriesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}injuries_json'],
      )!,
      injuriesNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}injuries_note'],
      ),
      jobType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}job_type'],
      ),
      jobHours: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}job_hours'],
      ),
      sleepTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sleep_time'],
      ),
      wakeTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wake_time'],
      ),
      trainingTimeOfDay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}training_time_of_day'],
      ),
      trainingTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}training_time'],
      ),
      cardioType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cardio_type'],
      ),
      cardioPerWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cardio_per_week'],
      ),
      mealsPerDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}meals_per_day'],
      ),
      mealTimesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_times_json'],
      )!,
      likedFoods: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}liked_foods'],
      ),
      dislikedFoods: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}disliked_foods'],
      ),
      allergies: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}allergies'],
      ),
      budgetLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_level'],
      ),
      budgetEgp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}budget_egp'],
      ),
      supplementsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplements_json'],
      )!,
      waterGoalMl: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}water_goal_ml'],
      ),
      healthConnectEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}health_connect_enabled'],
      )!,
      bmr: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}bmr'],
      ),
      tdee: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tdee'],
      ),
      calorieTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}calorie_target'],
      ),
      proteinG: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}protein_g'],
      ),
      carbsG: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}carbs_g'],
      ),
      fatG: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fat_g'],
      ),
      trainingDayCarbsG: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}training_day_carbs_g'],
      ),
      restDayCarbsG: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest_day_carbs_g'],
      ),
      onboardingComplete: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarding_complete'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UserProfilesTable createAlias(String alias) {
    return $UserProfilesTable(attachedDatabase, alias);
  }
}

class UserProfile extends DataClass implements Insertable<UserProfile> {
  final int id;
  final String language;
  final String? sex;
  final int? age;
  final double? heightCm;
  final double? weightKg;
  final double? bodyFatPct;
  final String? bodyFatMethod;
  final String measurementsJson;
  final String? goal;
  final double? targetWeightKg;
  final int? goalWeeks;
  final String? level;
  final String? trainingExperience;
  final int? daysPerWeek;
  final String trainingDaysJson;
  final int? sessionMinutes;
  final String? splitPreference;
  final String focusMusclesJson;
  final String? location;
  final String injuriesJson;
  final String? injuriesNote;
  final String? jobType;
  final String? jobHours;
  final String? sleepTime;
  final String? wakeTime;
  final String? trainingTimeOfDay;
  final String? trainingTime;
  final String? cardioType;
  final int? cardioPerWeek;
  final int? mealsPerDay;
  final String mealTimesJson;
  final String? likedFoods;
  final String? dislikedFoods;
  final String? allergies;
  final String? budgetLevel;
  final int? budgetEgp;
  final String supplementsJson;
  final int? waterGoalMl;
  final bool healthConnectEnabled;
  final double? bmr;
  final double? tdee;
  final int? calorieTarget;
  final int? proteinG;
  final int? carbsG;
  final int? fatG;
  final int? trainingDayCarbsG;
  final int? restDayCarbsG;
  final bool onboardingComplete;
  final DateTime createdAt;
  final DateTime updatedAt;
  const UserProfile({
    required this.id,
    required this.language,
    this.sex,
    this.age,
    this.heightCm,
    this.weightKg,
    this.bodyFatPct,
    this.bodyFatMethod,
    required this.measurementsJson,
    this.goal,
    this.targetWeightKg,
    this.goalWeeks,
    this.level,
    this.trainingExperience,
    this.daysPerWeek,
    required this.trainingDaysJson,
    this.sessionMinutes,
    this.splitPreference,
    required this.focusMusclesJson,
    this.location,
    required this.injuriesJson,
    this.injuriesNote,
    this.jobType,
    this.jobHours,
    this.sleepTime,
    this.wakeTime,
    this.trainingTimeOfDay,
    this.trainingTime,
    this.cardioType,
    this.cardioPerWeek,
    this.mealsPerDay,
    required this.mealTimesJson,
    this.likedFoods,
    this.dislikedFoods,
    this.allergies,
    this.budgetLevel,
    this.budgetEgp,
    required this.supplementsJson,
    this.waterGoalMl,
    required this.healthConnectEnabled,
    this.bmr,
    this.tdee,
    this.calorieTarget,
    this.proteinG,
    this.carbsG,
    this.fatG,
    this.trainingDayCarbsG,
    this.restDayCarbsG,
    required this.onboardingComplete,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['language'] = Variable<String>(language);
    if (!nullToAbsent || sex != null) {
      map['sex'] = Variable<String>(sex);
    }
    if (!nullToAbsent || age != null) {
      map['age'] = Variable<int>(age);
    }
    if (!nullToAbsent || heightCm != null) {
      map['height_cm'] = Variable<double>(heightCm);
    }
    if (!nullToAbsent || weightKg != null) {
      map['weight_kg'] = Variable<double>(weightKg);
    }
    if (!nullToAbsent || bodyFatPct != null) {
      map['body_fat_pct'] = Variable<double>(bodyFatPct);
    }
    if (!nullToAbsent || bodyFatMethod != null) {
      map['body_fat_method'] = Variable<String>(bodyFatMethod);
    }
    map['measurements_json'] = Variable<String>(measurementsJson);
    if (!nullToAbsent || goal != null) {
      map['goal'] = Variable<String>(goal);
    }
    if (!nullToAbsent || targetWeightKg != null) {
      map['target_weight_kg'] = Variable<double>(targetWeightKg);
    }
    if (!nullToAbsent || goalWeeks != null) {
      map['goal_weeks'] = Variable<int>(goalWeeks);
    }
    if (!nullToAbsent || level != null) {
      map['level'] = Variable<String>(level);
    }
    if (!nullToAbsent || trainingExperience != null) {
      map['training_experience'] = Variable<String>(trainingExperience);
    }
    if (!nullToAbsent || daysPerWeek != null) {
      map['days_per_week'] = Variable<int>(daysPerWeek);
    }
    map['training_days_json'] = Variable<String>(trainingDaysJson);
    if (!nullToAbsent || sessionMinutes != null) {
      map['session_minutes'] = Variable<int>(sessionMinutes);
    }
    if (!nullToAbsent || splitPreference != null) {
      map['split_preference'] = Variable<String>(splitPreference);
    }
    map['focus_muscles_json'] = Variable<String>(focusMusclesJson);
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    map['injuries_json'] = Variable<String>(injuriesJson);
    if (!nullToAbsent || injuriesNote != null) {
      map['injuries_note'] = Variable<String>(injuriesNote);
    }
    if (!nullToAbsent || jobType != null) {
      map['job_type'] = Variable<String>(jobType);
    }
    if (!nullToAbsent || jobHours != null) {
      map['job_hours'] = Variable<String>(jobHours);
    }
    if (!nullToAbsent || sleepTime != null) {
      map['sleep_time'] = Variable<String>(sleepTime);
    }
    if (!nullToAbsent || wakeTime != null) {
      map['wake_time'] = Variable<String>(wakeTime);
    }
    if (!nullToAbsent || trainingTimeOfDay != null) {
      map['training_time_of_day'] = Variable<String>(trainingTimeOfDay);
    }
    if (!nullToAbsent || trainingTime != null) {
      map['training_time'] = Variable<String>(trainingTime);
    }
    if (!nullToAbsent || cardioType != null) {
      map['cardio_type'] = Variable<String>(cardioType);
    }
    if (!nullToAbsent || cardioPerWeek != null) {
      map['cardio_per_week'] = Variable<int>(cardioPerWeek);
    }
    if (!nullToAbsent || mealsPerDay != null) {
      map['meals_per_day'] = Variable<int>(mealsPerDay);
    }
    map['meal_times_json'] = Variable<String>(mealTimesJson);
    if (!nullToAbsent || likedFoods != null) {
      map['liked_foods'] = Variable<String>(likedFoods);
    }
    if (!nullToAbsent || dislikedFoods != null) {
      map['disliked_foods'] = Variable<String>(dislikedFoods);
    }
    if (!nullToAbsent || allergies != null) {
      map['allergies'] = Variable<String>(allergies);
    }
    if (!nullToAbsent || budgetLevel != null) {
      map['budget_level'] = Variable<String>(budgetLevel);
    }
    if (!nullToAbsent || budgetEgp != null) {
      map['budget_egp'] = Variable<int>(budgetEgp);
    }
    map['supplements_json'] = Variable<String>(supplementsJson);
    if (!nullToAbsent || waterGoalMl != null) {
      map['water_goal_ml'] = Variable<int>(waterGoalMl);
    }
    map['health_connect_enabled'] = Variable<bool>(healthConnectEnabled);
    if (!nullToAbsent || bmr != null) {
      map['bmr'] = Variable<double>(bmr);
    }
    if (!nullToAbsent || tdee != null) {
      map['tdee'] = Variable<double>(tdee);
    }
    if (!nullToAbsent || calorieTarget != null) {
      map['calorie_target'] = Variable<int>(calorieTarget);
    }
    if (!nullToAbsent || proteinG != null) {
      map['protein_g'] = Variable<int>(proteinG);
    }
    if (!nullToAbsent || carbsG != null) {
      map['carbs_g'] = Variable<int>(carbsG);
    }
    if (!nullToAbsent || fatG != null) {
      map['fat_g'] = Variable<int>(fatG);
    }
    if (!nullToAbsent || trainingDayCarbsG != null) {
      map['training_day_carbs_g'] = Variable<int>(trainingDayCarbsG);
    }
    if (!nullToAbsent || restDayCarbsG != null) {
      map['rest_day_carbs_g'] = Variable<int>(restDayCarbsG);
    }
    map['onboarding_complete'] = Variable<bool>(onboardingComplete);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(
      id: Value(id),
      language: Value(language),
      sex: sex == null && nullToAbsent ? const Value.absent() : Value(sex),
      age: age == null && nullToAbsent ? const Value.absent() : Value(age),
      heightCm: heightCm == null && nullToAbsent
          ? const Value.absent()
          : Value(heightCm),
      weightKg: weightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(weightKg),
      bodyFatPct: bodyFatPct == null && nullToAbsent
          ? const Value.absent()
          : Value(bodyFatPct),
      bodyFatMethod: bodyFatMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(bodyFatMethod),
      measurementsJson: Value(measurementsJson),
      goal: goal == null && nullToAbsent ? const Value.absent() : Value(goal),
      targetWeightKg: targetWeightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(targetWeightKg),
      goalWeeks: goalWeeks == null && nullToAbsent
          ? const Value.absent()
          : Value(goalWeeks),
      level: level == null && nullToAbsent
          ? const Value.absent()
          : Value(level),
      trainingExperience: trainingExperience == null && nullToAbsent
          ? const Value.absent()
          : Value(trainingExperience),
      daysPerWeek: daysPerWeek == null && nullToAbsent
          ? const Value.absent()
          : Value(daysPerWeek),
      trainingDaysJson: Value(trainingDaysJson),
      sessionMinutes: sessionMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionMinutes),
      splitPreference: splitPreference == null && nullToAbsent
          ? const Value.absent()
          : Value(splitPreference),
      focusMusclesJson: Value(focusMusclesJson),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      injuriesJson: Value(injuriesJson),
      injuriesNote: injuriesNote == null && nullToAbsent
          ? const Value.absent()
          : Value(injuriesNote),
      jobType: jobType == null && nullToAbsent
          ? const Value.absent()
          : Value(jobType),
      jobHours: jobHours == null && nullToAbsent
          ? const Value.absent()
          : Value(jobHours),
      sleepTime: sleepTime == null && nullToAbsent
          ? const Value.absent()
          : Value(sleepTime),
      wakeTime: wakeTime == null && nullToAbsent
          ? const Value.absent()
          : Value(wakeTime),
      trainingTimeOfDay: trainingTimeOfDay == null && nullToAbsent
          ? const Value.absent()
          : Value(trainingTimeOfDay),
      trainingTime: trainingTime == null && nullToAbsent
          ? const Value.absent()
          : Value(trainingTime),
      cardioType: cardioType == null && nullToAbsent
          ? const Value.absent()
          : Value(cardioType),
      cardioPerWeek: cardioPerWeek == null && nullToAbsent
          ? const Value.absent()
          : Value(cardioPerWeek),
      mealsPerDay: mealsPerDay == null && nullToAbsent
          ? const Value.absent()
          : Value(mealsPerDay),
      mealTimesJson: Value(mealTimesJson),
      likedFoods: likedFoods == null && nullToAbsent
          ? const Value.absent()
          : Value(likedFoods),
      dislikedFoods: dislikedFoods == null && nullToAbsent
          ? const Value.absent()
          : Value(dislikedFoods),
      allergies: allergies == null && nullToAbsent
          ? const Value.absent()
          : Value(allergies),
      budgetLevel: budgetLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(budgetLevel),
      budgetEgp: budgetEgp == null && nullToAbsent
          ? const Value.absent()
          : Value(budgetEgp),
      supplementsJson: Value(supplementsJson),
      waterGoalMl: waterGoalMl == null && nullToAbsent
          ? const Value.absent()
          : Value(waterGoalMl),
      healthConnectEnabled: Value(healthConnectEnabled),
      bmr: bmr == null && nullToAbsent ? const Value.absent() : Value(bmr),
      tdee: tdee == null && nullToAbsent ? const Value.absent() : Value(tdee),
      calorieTarget: calorieTarget == null && nullToAbsent
          ? const Value.absent()
          : Value(calorieTarget),
      proteinG: proteinG == null && nullToAbsent
          ? const Value.absent()
          : Value(proteinG),
      carbsG: carbsG == null && nullToAbsent
          ? const Value.absent()
          : Value(carbsG),
      fatG: fatG == null && nullToAbsent ? const Value.absent() : Value(fatG),
      trainingDayCarbsG: trainingDayCarbsG == null && nullToAbsent
          ? const Value.absent()
          : Value(trainingDayCarbsG),
      restDayCarbsG: restDayCarbsG == null && nullToAbsent
          ? const Value.absent()
          : Value(restDayCarbsG),
      onboardingComplete: Value(onboardingComplete),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfile(
      id: serializer.fromJson<int>(json['id']),
      language: serializer.fromJson<String>(json['language']),
      sex: serializer.fromJson<String?>(json['sex']),
      age: serializer.fromJson<int?>(json['age']),
      heightCm: serializer.fromJson<double?>(json['heightCm']),
      weightKg: serializer.fromJson<double?>(json['weightKg']),
      bodyFatPct: serializer.fromJson<double?>(json['bodyFatPct']),
      bodyFatMethod: serializer.fromJson<String?>(json['bodyFatMethod']),
      measurementsJson: serializer.fromJson<String>(json['measurementsJson']),
      goal: serializer.fromJson<String?>(json['goal']),
      targetWeightKg: serializer.fromJson<double?>(json['targetWeightKg']),
      goalWeeks: serializer.fromJson<int?>(json['goalWeeks']),
      level: serializer.fromJson<String?>(json['level']),
      trainingExperience: serializer.fromJson<String?>(
        json['trainingExperience'],
      ),
      daysPerWeek: serializer.fromJson<int?>(json['daysPerWeek']),
      trainingDaysJson: serializer.fromJson<String>(json['trainingDaysJson']),
      sessionMinutes: serializer.fromJson<int?>(json['sessionMinutes']),
      splitPreference: serializer.fromJson<String?>(json['splitPreference']),
      focusMusclesJson: serializer.fromJson<String>(json['focusMusclesJson']),
      location: serializer.fromJson<String?>(json['location']),
      injuriesJson: serializer.fromJson<String>(json['injuriesJson']),
      injuriesNote: serializer.fromJson<String?>(json['injuriesNote']),
      jobType: serializer.fromJson<String?>(json['jobType']),
      jobHours: serializer.fromJson<String?>(json['jobHours']),
      sleepTime: serializer.fromJson<String?>(json['sleepTime']),
      wakeTime: serializer.fromJson<String?>(json['wakeTime']),
      trainingTimeOfDay: serializer.fromJson<String?>(
        json['trainingTimeOfDay'],
      ),
      trainingTime: serializer.fromJson<String?>(json['trainingTime']),
      cardioType: serializer.fromJson<String?>(json['cardioType']),
      cardioPerWeek: serializer.fromJson<int?>(json['cardioPerWeek']),
      mealsPerDay: serializer.fromJson<int?>(json['mealsPerDay']),
      mealTimesJson: serializer.fromJson<String>(json['mealTimesJson']),
      likedFoods: serializer.fromJson<String?>(json['likedFoods']),
      dislikedFoods: serializer.fromJson<String?>(json['dislikedFoods']),
      allergies: serializer.fromJson<String?>(json['allergies']),
      budgetLevel: serializer.fromJson<String?>(json['budgetLevel']),
      budgetEgp: serializer.fromJson<int?>(json['budgetEgp']),
      supplementsJson: serializer.fromJson<String>(json['supplementsJson']),
      waterGoalMl: serializer.fromJson<int?>(json['waterGoalMl']),
      healthConnectEnabled: serializer.fromJson<bool>(
        json['healthConnectEnabled'],
      ),
      bmr: serializer.fromJson<double?>(json['bmr']),
      tdee: serializer.fromJson<double?>(json['tdee']),
      calorieTarget: serializer.fromJson<int?>(json['calorieTarget']),
      proteinG: serializer.fromJson<int?>(json['proteinG']),
      carbsG: serializer.fromJson<int?>(json['carbsG']),
      fatG: serializer.fromJson<int?>(json['fatG']),
      trainingDayCarbsG: serializer.fromJson<int?>(json['trainingDayCarbsG']),
      restDayCarbsG: serializer.fromJson<int?>(json['restDayCarbsG']),
      onboardingComplete: serializer.fromJson<bool>(json['onboardingComplete']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'language': serializer.toJson<String>(language),
      'sex': serializer.toJson<String?>(sex),
      'age': serializer.toJson<int?>(age),
      'heightCm': serializer.toJson<double?>(heightCm),
      'weightKg': serializer.toJson<double?>(weightKg),
      'bodyFatPct': serializer.toJson<double?>(bodyFatPct),
      'bodyFatMethod': serializer.toJson<String?>(bodyFatMethod),
      'measurementsJson': serializer.toJson<String>(measurementsJson),
      'goal': serializer.toJson<String?>(goal),
      'targetWeightKg': serializer.toJson<double?>(targetWeightKg),
      'goalWeeks': serializer.toJson<int?>(goalWeeks),
      'level': serializer.toJson<String?>(level),
      'trainingExperience': serializer.toJson<String?>(trainingExperience),
      'daysPerWeek': serializer.toJson<int?>(daysPerWeek),
      'trainingDaysJson': serializer.toJson<String>(trainingDaysJson),
      'sessionMinutes': serializer.toJson<int?>(sessionMinutes),
      'splitPreference': serializer.toJson<String?>(splitPreference),
      'focusMusclesJson': serializer.toJson<String>(focusMusclesJson),
      'location': serializer.toJson<String?>(location),
      'injuriesJson': serializer.toJson<String>(injuriesJson),
      'injuriesNote': serializer.toJson<String?>(injuriesNote),
      'jobType': serializer.toJson<String?>(jobType),
      'jobHours': serializer.toJson<String?>(jobHours),
      'sleepTime': serializer.toJson<String?>(sleepTime),
      'wakeTime': serializer.toJson<String?>(wakeTime),
      'trainingTimeOfDay': serializer.toJson<String?>(trainingTimeOfDay),
      'trainingTime': serializer.toJson<String?>(trainingTime),
      'cardioType': serializer.toJson<String?>(cardioType),
      'cardioPerWeek': serializer.toJson<int?>(cardioPerWeek),
      'mealsPerDay': serializer.toJson<int?>(mealsPerDay),
      'mealTimesJson': serializer.toJson<String>(mealTimesJson),
      'likedFoods': serializer.toJson<String?>(likedFoods),
      'dislikedFoods': serializer.toJson<String?>(dislikedFoods),
      'allergies': serializer.toJson<String?>(allergies),
      'budgetLevel': serializer.toJson<String?>(budgetLevel),
      'budgetEgp': serializer.toJson<int?>(budgetEgp),
      'supplementsJson': serializer.toJson<String>(supplementsJson),
      'waterGoalMl': serializer.toJson<int?>(waterGoalMl),
      'healthConnectEnabled': serializer.toJson<bool>(healthConnectEnabled),
      'bmr': serializer.toJson<double?>(bmr),
      'tdee': serializer.toJson<double?>(tdee),
      'calorieTarget': serializer.toJson<int?>(calorieTarget),
      'proteinG': serializer.toJson<int?>(proteinG),
      'carbsG': serializer.toJson<int?>(carbsG),
      'fatG': serializer.toJson<int?>(fatG),
      'trainingDayCarbsG': serializer.toJson<int?>(trainingDayCarbsG),
      'restDayCarbsG': serializer.toJson<int?>(restDayCarbsG),
      'onboardingComplete': serializer.toJson<bool>(onboardingComplete),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserProfile copyWith({
    int? id,
    String? language,
    Value<String?> sex = const Value.absent(),
    Value<int?> age = const Value.absent(),
    Value<double?> heightCm = const Value.absent(),
    Value<double?> weightKg = const Value.absent(),
    Value<double?> bodyFatPct = const Value.absent(),
    Value<String?> bodyFatMethod = const Value.absent(),
    String? measurementsJson,
    Value<String?> goal = const Value.absent(),
    Value<double?> targetWeightKg = const Value.absent(),
    Value<int?> goalWeeks = const Value.absent(),
    Value<String?> level = const Value.absent(),
    Value<String?> trainingExperience = const Value.absent(),
    Value<int?> daysPerWeek = const Value.absent(),
    String? trainingDaysJson,
    Value<int?> sessionMinutes = const Value.absent(),
    Value<String?> splitPreference = const Value.absent(),
    String? focusMusclesJson,
    Value<String?> location = const Value.absent(),
    String? injuriesJson,
    Value<String?> injuriesNote = const Value.absent(),
    Value<String?> jobType = const Value.absent(),
    Value<String?> jobHours = const Value.absent(),
    Value<String?> sleepTime = const Value.absent(),
    Value<String?> wakeTime = const Value.absent(),
    Value<String?> trainingTimeOfDay = const Value.absent(),
    Value<String?> trainingTime = const Value.absent(),
    Value<String?> cardioType = const Value.absent(),
    Value<int?> cardioPerWeek = const Value.absent(),
    Value<int?> mealsPerDay = const Value.absent(),
    String? mealTimesJson,
    Value<String?> likedFoods = const Value.absent(),
    Value<String?> dislikedFoods = const Value.absent(),
    Value<String?> allergies = const Value.absent(),
    Value<String?> budgetLevel = const Value.absent(),
    Value<int?> budgetEgp = const Value.absent(),
    String? supplementsJson,
    Value<int?> waterGoalMl = const Value.absent(),
    bool? healthConnectEnabled,
    Value<double?> bmr = const Value.absent(),
    Value<double?> tdee = const Value.absent(),
    Value<int?> calorieTarget = const Value.absent(),
    Value<int?> proteinG = const Value.absent(),
    Value<int?> carbsG = const Value.absent(),
    Value<int?> fatG = const Value.absent(),
    Value<int?> trainingDayCarbsG = const Value.absent(),
    Value<int?> restDayCarbsG = const Value.absent(),
    bool? onboardingComplete,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => UserProfile(
    id: id ?? this.id,
    language: language ?? this.language,
    sex: sex.present ? sex.value : this.sex,
    age: age.present ? age.value : this.age,
    heightCm: heightCm.present ? heightCm.value : this.heightCm,
    weightKg: weightKg.present ? weightKg.value : this.weightKg,
    bodyFatPct: bodyFatPct.present ? bodyFatPct.value : this.bodyFatPct,
    bodyFatMethod: bodyFatMethod.present
        ? bodyFatMethod.value
        : this.bodyFatMethod,
    measurementsJson: measurementsJson ?? this.measurementsJson,
    goal: goal.present ? goal.value : this.goal,
    targetWeightKg: targetWeightKg.present
        ? targetWeightKg.value
        : this.targetWeightKg,
    goalWeeks: goalWeeks.present ? goalWeeks.value : this.goalWeeks,
    level: level.present ? level.value : this.level,
    trainingExperience: trainingExperience.present
        ? trainingExperience.value
        : this.trainingExperience,
    daysPerWeek: daysPerWeek.present ? daysPerWeek.value : this.daysPerWeek,
    trainingDaysJson: trainingDaysJson ?? this.trainingDaysJson,
    sessionMinutes: sessionMinutes.present
        ? sessionMinutes.value
        : this.sessionMinutes,
    splitPreference: splitPreference.present
        ? splitPreference.value
        : this.splitPreference,
    focusMusclesJson: focusMusclesJson ?? this.focusMusclesJson,
    location: location.present ? location.value : this.location,
    injuriesJson: injuriesJson ?? this.injuriesJson,
    injuriesNote: injuriesNote.present ? injuriesNote.value : this.injuriesNote,
    jobType: jobType.present ? jobType.value : this.jobType,
    jobHours: jobHours.present ? jobHours.value : this.jobHours,
    sleepTime: sleepTime.present ? sleepTime.value : this.sleepTime,
    wakeTime: wakeTime.present ? wakeTime.value : this.wakeTime,
    trainingTimeOfDay: trainingTimeOfDay.present
        ? trainingTimeOfDay.value
        : this.trainingTimeOfDay,
    trainingTime: trainingTime.present ? trainingTime.value : this.trainingTime,
    cardioType: cardioType.present ? cardioType.value : this.cardioType,
    cardioPerWeek: cardioPerWeek.present
        ? cardioPerWeek.value
        : this.cardioPerWeek,
    mealsPerDay: mealsPerDay.present ? mealsPerDay.value : this.mealsPerDay,
    mealTimesJson: mealTimesJson ?? this.mealTimesJson,
    likedFoods: likedFoods.present ? likedFoods.value : this.likedFoods,
    dislikedFoods: dislikedFoods.present
        ? dislikedFoods.value
        : this.dislikedFoods,
    allergies: allergies.present ? allergies.value : this.allergies,
    budgetLevel: budgetLevel.present ? budgetLevel.value : this.budgetLevel,
    budgetEgp: budgetEgp.present ? budgetEgp.value : this.budgetEgp,
    supplementsJson: supplementsJson ?? this.supplementsJson,
    waterGoalMl: waterGoalMl.present ? waterGoalMl.value : this.waterGoalMl,
    healthConnectEnabled: healthConnectEnabled ?? this.healthConnectEnabled,
    bmr: bmr.present ? bmr.value : this.bmr,
    tdee: tdee.present ? tdee.value : this.tdee,
    calorieTarget: calorieTarget.present
        ? calorieTarget.value
        : this.calorieTarget,
    proteinG: proteinG.present ? proteinG.value : this.proteinG,
    carbsG: carbsG.present ? carbsG.value : this.carbsG,
    fatG: fatG.present ? fatG.value : this.fatG,
    trainingDayCarbsG: trainingDayCarbsG.present
        ? trainingDayCarbsG.value
        : this.trainingDayCarbsG,
    restDayCarbsG: restDayCarbsG.present
        ? restDayCarbsG.value
        : this.restDayCarbsG,
    onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UserProfile copyWithCompanion(UserProfilesCompanion data) {
    return UserProfile(
      id: data.id.present ? data.id.value : this.id,
      language: data.language.present ? data.language.value : this.language,
      sex: data.sex.present ? data.sex.value : this.sex,
      age: data.age.present ? data.age.value : this.age,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      bodyFatPct: data.bodyFatPct.present
          ? data.bodyFatPct.value
          : this.bodyFatPct,
      bodyFatMethod: data.bodyFatMethod.present
          ? data.bodyFatMethod.value
          : this.bodyFatMethod,
      measurementsJson: data.measurementsJson.present
          ? data.measurementsJson.value
          : this.measurementsJson,
      goal: data.goal.present ? data.goal.value : this.goal,
      targetWeightKg: data.targetWeightKg.present
          ? data.targetWeightKg.value
          : this.targetWeightKg,
      goalWeeks: data.goalWeeks.present ? data.goalWeeks.value : this.goalWeeks,
      level: data.level.present ? data.level.value : this.level,
      trainingExperience: data.trainingExperience.present
          ? data.trainingExperience.value
          : this.trainingExperience,
      daysPerWeek: data.daysPerWeek.present
          ? data.daysPerWeek.value
          : this.daysPerWeek,
      trainingDaysJson: data.trainingDaysJson.present
          ? data.trainingDaysJson.value
          : this.trainingDaysJson,
      sessionMinutes: data.sessionMinutes.present
          ? data.sessionMinutes.value
          : this.sessionMinutes,
      splitPreference: data.splitPreference.present
          ? data.splitPreference.value
          : this.splitPreference,
      focusMusclesJson: data.focusMusclesJson.present
          ? data.focusMusclesJson.value
          : this.focusMusclesJson,
      location: data.location.present ? data.location.value : this.location,
      injuriesJson: data.injuriesJson.present
          ? data.injuriesJson.value
          : this.injuriesJson,
      injuriesNote: data.injuriesNote.present
          ? data.injuriesNote.value
          : this.injuriesNote,
      jobType: data.jobType.present ? data.jobType.value : this.jobType,
      jobHours: data.jobHours.present ? data.jobHours.value : this.jobHours,
      sleepTime: data.sleepTime.present ? data.sleepTime.value : this.sleepTime,
      wakeTime: data.wakeTime.present ? data.wakeTime.value : this.wakeTime,
      trainingTimeOfDay: data.trainingTimeOfDay.present
          ? data.trainingTimeOfDay.value
          : this.trainingTimeOfDay,
      trainingTime: data.trainingTime.present
          ? data.trainingTime.value
          : this.trainingTime,
      cardioType: data.cardioType.present
          ? data.cardioType.value
          : this.cardioType,
      cardioPerWeek: data.cardioPerWeek.present
          ? data.cardioPerWeek.value
          : this.cardioPerWeek,
      mealsPerDay: data.mealsPerDay.present
          ? data.mealsPerDay.value
          : this.mealsPerDay,
      mealTimesJson: data.mealTimesJson.present
          ? data.mealTimesJson.value
          : this.mealTimesJson,
      likedFoods: data.likedFoods.present
          ? data.likedFoods.value
          : this.likedFoods,
      dislikedFoods: data.dislikedFoods.present
          ? data.dislikedFoods.value
          : this.dislikedFoods,
      allergies: data.allergies.present ? data.allergies.value : this.allergies,
      budgetLevel: data.budgetLevel.present
          ? data.budgetLevel.value
          : this.budgetLevel,
      budgetEgp: data.budgetEgp.present ? data.budgetEgp.value : this.budgetEgp,
      supplementsJson: data.supplementsJson.present
          ? data.supplementsJson.value
          : this.supplementsJson,
      waterGoalMl: data.waterGoalMl.present
          ? data.waterGoalMl.value
          : this.waterGoalMl,
      healthConnectEnabled: data.healthConnectEnabled.present
          ? data.healthConnectEnabled.value
          : this.healthConnectEnabled,
      bmr: data.bmr.present ? data.bmr.value : this.bmr,
      tdee: data.tdee.present ? data.tdee.value : this.tdee,
      calorieTarget: data.calorieTarget.present
          ? data.calorieTarget.value
          : this.calorieTarget,
      proteinG: data.proteinG.present ? data.proteinG.value : this.proteinG,
      carbsG: data.carbsG.present ? data.carbsG.value : this.carbsG,
      fatG: data.fatG.present ? data.fatG.value : this.fatG,
      trainingDayCarbsG: data.trainingDayCarbsG.present
          ? data.trainingDayCarbsG.value
          : this.trainingDayCarbsG,
      restDayCarbsG: data.restDayCarbsG.present
          ? data.restDayCarbsG.value
          : this.restDayCarbsG,
      onboardingComplete: data.onboardingComplete.present
          ? data.onboardingComplete.value
          : this.onboardingComplete,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfile(')
          ..write('id: $id, ')
          ..write('language: $language, ')
          ..write('sex: $sex, ')
          ..write('age: $age, ')
          ..write('heightCm: $heightCm, ')
          ..write('weightKg: $weightKg, ')
          ..write('bodyFatPct: $bodyFatPct, ')
          ..write('bodyFatMethod: $bodyFatMethod, ')
          ..write('measurementsJson: $measurementsJson, ')
          ..write('goal: $goal, ')
          ..write('targetWeightKg: $targetWeightKg, ')
          ..write('goalWeeks: $goalWeeks, ')
          ..write('level: $level, ')
          ..write('trainingExperience: $trainingExperience, ')
          ..write('daysPerWeek: $daysPerWeek, ')
          ..write('trainingDaysJson: $trainingDaysJson, ')
          ..write('sessionMinutes: $sessionMinutes, ')
          ..write('splitPreference: $splitPreference, ')
          ..write('focusMusclesJson: $focusMusclesJson, ')
          ..write('location: $location, ')
          ..write('injuriesJson: $injuriesJson, ')
          ..write('injuriesNote: $injuriesNote, ')
          ..write('jobType: $jobType, ')
          ..write('jobHours: $jobHours, ')
          ..write('sleepTime: $sleepTime, ')
          ..write('wakeTime: $wakeTime, ')
          ..write('trainingTimeOfDay: $trainingTimeOfDay, ')
          ..write('trainingTime: $trainingTime, ')
          ..write('cardioType: $cardioType, ')
          ..write('cardioPerWeek: $cardioPerWeek, ')
          ..write('mealsPerDay: $mealsPerDay, ')
          ..write('mealTimesJson: $mealTimesJson, ')
          ..write('likedFoods: $likedFoods, ')
          ..write('dislikedFoods: $dislikedFoods, ')
          ..write('allergies: $allergies, ')
          ..write('budgetLevel: $budgetLevel, ')
          ..write('budgetEgp: $budgetEgp, ')
          ..write('supplementsJson: $supplementsJson, ')
          ..write('waterGoalMl: $waterGoalMl, ')
          ..write('healthConnectEnabled: $healthConnectEnabled, ')
          ..write('bmr: $bmr, ')
          ..write('tdee: $tdee, ')
          ..write('calorieTarget: $calorieTarget, ')
          ..write('proteinG: $proteinG, ')
          ..write('carbsG: $carbsG, ')
          ..write('fatG: $fatG, ')
          ..write('trainingDayCarbsG: $trainingDayCarbsG, ')
          ..write('restDayCarbsG: $restDayCarbsG, ')
          ..write('onboardingComplete: $onboardingComplete, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    language,
    sex,
    age,
    heightCm,
    weightKg,
    bodyFatPct,
    bodyFatMethod,
    measurementsJson,
    goal,
    targetWeightKg,
    goalWeeks,
    level,
    trainingExperience,
    daysPerWeek,
    trainingDaysJson,
    sessionMinutes,
    splitPreference,
    focusMusclesJson,
    location,
    injuriesJson,
    injuriesNote,
    jobType,
    jobHours,
    sleepTime,
    wakeTime,
    trainingTimeOfDay,
    trainingTime,
    cardioType,
    cardioPerWeek,
    mealsPerDay,
    mealTimesJson,
    likedFoods,
    dislikedFoods,
    allergies,
    budgetLevel,
    budgetEgp,
    supplementsJson,
    waterGoalMl,
    healthConnectEnabled,
    bmr,
    tdee,
    calorieTarget,
    proteinG,
    carbsG,
    fatG,
    trainingDayCarbsG,
    restDayCarbsG,
    onboardingComplete,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfile &&
          other.id == this.id &&
          other.language == this.language &&
          other.sex == this.sex &&
          other.age == this.age &&
          other.heightCm == this.heightCm &&
          other.weightKg == this.weightKg &&
          other.bodyFatPct == this.bodyFatPct &&
          other.bodyFatMethod == this.bodyFatMethod &&
          other.measurementsJson == this.measurementsJson &&
          other.goal == this.goal &&
          other.targetWeightKg == this.targetWeightKg &&
          other.goalWeeks == this.goalWeeks &&
          other.level == this.level &&
          other.trainingExperience == this.trainingExperience &&
          other.daysPerWeek == this.daysPerWeek &&
          other.trainingDaysJson == this.trainingDaysJson &&
          other.sessionMinutes == this.sessionMinutes &&
          other.splitPreference == this.splitPreference &&
          other.focusMusclesJson == this.focusMusclesJson &&
          other.location == this.location &&
          other.injuriesJson == this.injuriesJson &&
          other.injuriesNote == this.injuriesNote &&
          other.jobType == this.jobType &&
          other.jobHours == this.jobHours &&
          other.sleepTime == this.sleepTime &&
          other.wakeTime == this.wakeTime &&
          other.trainingTimeOfDay == this.trainingTimeOfDay &&
          other.trainingTime == this.trainingTime &&
          other.cardioType == this.cardioType &&
          other.cardioPerWeek == this.cardioPerWeek &&
          other.mealsPerDay == this.mealsPerDay &&
          other.mealTimesJson == this.mealTimesJson &&
          other.likedFoods == this.likedFoods &&
          other.dislikedFoods == this.dislikedFoods &&
          other.allergies == this.allergies &&
          other.budgetLevel == this.budgetLevel &&
          other.budgetEgp == this.budgetEgp &&
          other.supplementsJson == this.supplementsJson &&
          other.waterGoalMl == this.waterGoalMl &&
          other.healthConnectEnabled == this.healthConnectEnabled &&
          other.bmr == this.bmr &&
          other.tdee == this.tdee &&
          other.calorieTarget == this.calorieTarget &&
          other.proteinG == this.proteinG &&
          other.carbsG == this.carbsG &&
          other.fatG == this.fatG &&
          other.trainingDayCarbsG == this.trainingDayCarbsG &&
          other.restDayCarbsG == this.restDayCarbsG &&
          other.onboardingComplete == this.onboardingComplete &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UserProfilesCompanion extends UpdateCompanion<UserProfile> {
  final Value<int> id;
  final Value<String> language;
  final Value<String?> sex;
  final Value<int?> age;
  final Value<double?> heightCm;
  final Value<double?> weightKg;
  final Value<double?> bodyFatPct;
  final Value<String?> bodyFatMethod;
  final Value<String> measurementsJson;
  final Value<String?> goal;
  final Value<double?> targetWeightKg;
  final Value<int?> goalWeeks;
  final Value<String?> level;
  final Value<String?> trainingExperience;
  final Value<int?> daysPerWeek;
  final Value<String> trainingDaysJson;
  final Value<int?> sessionMinutes;
  final Value<String?> splitPreference;
  final Value<String> focusMusclesJson;
  final Value<String?> location;
  final Value<String> injuriesJson;
  final Value<String?> injuriesNote;
  final Value<String?> jobType;
  final Value<String?> jobHours;
  final Value<String?> sleepTime;
  final Value<String?> wakeTime;
  final Value<String?> trainingTimeOfDay;
  final Value<String?> trainingTime;
  final Value<String?> cardioType;
  final Value<int?> cardioPerWeek;
  final Value<int?> mealsPerDay;
  final Value<String> mealTimesJson;
  final Value<String?> likedFoods;
  final Value<String?> dislikedFoods;
  final Value<String?> allergies;
  final Value<String?> budgetLevel;
  final Value<int?> budgetEgp;
  final Value<String> supplementsJson;
  final Value<int?> waterGoalMl;
  final Value<bool> healthConnectEnabled;
  final Value<double?> bmr;
  final Value<double?> tdee;
  final Value<int?> calorieTarget;
  final Value<int?> proteinG;
  final Value<int?> carbsG;
  final Value<int?> fatG;
  final Value<int?> trainingDayCarbsG;
  final Value<int?> restDayCarbsG;
  final Value<bool> onboardingComplete;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const UserProfilesCompanion({
    this.id = const Value.absent(),
    this.language = const Value.absent(),
    this.sex = const Value.absent(),
    this.age = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.bodyFatPct = const Value.absent(),
    this.bodyFatMethod = const Value.absent(),
    this.measurementsJson = const Value.absent(),
    this.goal = const Value.absent(),
    this.targetWeightKg = const Value.absent(),
    this.goalWeeks = const Value.absent(),
    this.level = const Value.absent(),
    this.trainingExperience = const Value.absent(),
    this.daysPerWeek = const Value.absent(),
    this.trainingDaysJson = const Value.absent(),
    this.sessionMinutes = const Value.absent(),
    this.splitPreference = const Value.absent(),
    this.focusMusclesJson = const Value.absent(),
    this.location = const Value.absent(),
    this.injuriesJson = const Value.absent(),
    this.injuriesNote = const Value.absent(),
    this.jobType = const Value.absent(),
    this.jobHours = const Value.absent(),
    this.sleepTime = const Value.absent(),
    this.wakeTime = const Value.absent(),
    this.trainingTimeOfDay = const Value.absent(),
    this.trainingTime = const Value.absent(),
    this.cardioType = const Value.absent(),
    this.cardioPerWeek = const Value.absent(),
    this.mealsPerDay = const Value.absent(),
    this.mealTimesJson = const Value.absent(),
    this.likedFoods = const Value.absent(),
    this.dislikedFoods = const Value.absent(),
    this.allergies = const Value.absent(),
    this.budgetLevel = const Value.absent(),
    this.budgetEgp = const Value.absent(),
    this.supplementsJson = const Value.absent(),
    this.waterGoalMl = const Value.absent(),
    this.healthConnectEnabled = const Value.absent(),
    this.bmr = const Value.absent(),
    this.tdee = const Value.absent(),
    this.calorieTarget = const Value.absent(),
    this.proteinG = const Value.absent(),
    this.carbsG = const Value.absent(),
    this.fatG = const Value.absent(),
    this.trainingDayCarbsG = const Value.absent(),
    this.restDayCarbsG = const Value.absent(),
    this.onboardingComplete = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UserProfilesCompanion.insert({
    this.id = const Value.absent(),
    this.language = const Value.absent(),
    this.sex = const Value.absent(),
    this.age = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.bodyFatPct = const Value.absent(),
    this.bodyFatMethod = const Value.absent(),
    this.measurementsJson = const Value.absent(),
    this.goal = const Value.absent(),
    this.targetWeightKg = const Value.absent(),
    this.goalWeeks = const Value.absent(),
    this.level = const Value.absent(),
    this.trainingExperience = const Value.absent(),
    this.daysPerWeek = const Value.absent(),
    this.trainingDaysJson = const Value.absent(),
    this.sessionMinutes = const Value.absent(),
    this.splitPreference = const Value.absent(),
    this.focusMusclesJson = const Value.absent(),
    this.location = const Value.absent(),
    this.injuriesJson = const Value.absent(),
    this.injuriesNote = const Value.absent(),
    this.jobType = const Value.absent(),
    this.jobHours = const Value.absent(),
    this.sleepTime = const Value.absent(),
    this.wakeTime = const Value.absent(),
    this.trainingTimeOfDay = const Value.absent(),
    this.trainingTime = const Value.absent(),
    this.cardioType = const Value.absent(),
    this.cardioPerWeek = const Value.absent(),
    this.mealsPerDay = const Value.absent(),
    this.mealTimesJson = const Value.absent(),
    this.likedFoods = const Value.absent(),
    this.dislikedFoods = const Value.absent(),
    this.allergies = const Value.absent(),
    this.budgetLevel = const Value.absent(),
    this.budgetEgp = const Value.absent(),
    this.supplementsJson = const Value.absent(),
    this.waterGoalMl = const Value.absent(),
    this.healthConnectEnabled = const Value.absent(),
    this.bmr = const Value.absent(),
    this.tdee = const Value.absent(),
    this.calorieTarget = const Value.absent(),
    this.proteinG = const Value.absent(),
    this.carbsG = const Value.absent(),
    this.fatG = const Value.absent(),
    this.trainingDayCarbsG = const Value.absent(),
    this.restDayCarbsG = const Value.absent(),
    this.onboardingComplete = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<UserProfile> custom({
    Expression<int>? id,
    Expression<String>? language,
    Expression<String>? sex,
    Expression<int>? age,
    Expression<double>? heightCm,
    Expression<double>? weightKg,
    Expression<double>? bodyFatPct,
    Expression<String>? bodyFatMethod,
    Expression<String>? measurementsJson,
    Expression<String>? goal,
    Expression<double>? targetWeightKg,
    Expression<int>? goalWeeks,
    Expression<String>? level,
    Expression<String>? trainingExperience,
    Expression<int>? daysPerWeek,
    Expression<String>? trainingDaysJson,
    Expression<int>? sessionMinutes,
    Expression<String>? splitPreference,
    Expression<String>? focusMusclesJson,
    Expression<String>? location,
    Expression<String>? injuriesJson,
    Expression<String>? injuriesNote,
    Expression<String>? jobType,
    Expression<String>? jobHours,
    Expression<String>? sleepTime,
    Expression<String>? wakeTime,
    Expression<String>? trainingTimeOfDay,
    Expression<String>? trainingTime,
    Expression<String>? cardioType,
    Expression<int>? cardioPerWeek,
    Expression<int>? mealsPerDay,
    Expression<String>? mealTimesJson,
    Expression<String>? likedFoods,
    Expression<String>? dislikedFoods,
    Expression<String>? allergies,
    Expression<String>? budgetLevel,
    Expression<int>? budgetEgp,
    Expression<String>? supplementsJson,
    Expression<int>? waterGoalMl,
    Expression<bool>? healthConnectEnabled,
    Expression<double>? bmr,
    Expression<double>? tdee,
    Expression<int>? calorieTarget,
    Expression<int>? proteinG,
    Expression<int>? carbsG,
    Expression<int>? fatG,
    Expression<int>? trainingDayCarbsG,
    Expression<int>? restDayCarbsG,
    Expression<bool>? onboardingComplete,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (language != null) 'language': language,
      if (sex != null) 'sex': sex,
      if (age != null) 'age': age,
      if (heightCm != null) 'height_cm': heightCm,
      if (weightKg != null) 'weight_kg': weightKg,
      if (bodyFatPct != null) 'body_fat_pct': bodyFatPct,
      if (bodyFatMethod != null) 'body_fat_method': bodyFatMethod,
      if (measurementsJson != null) 'measurements_json': measurementsJson,
      if (goal != null) 'goal': goal,
      if (targetWeightKg != null) 'target_weight_kg': targetWeightKg,
      if (goalWeeks != null) 'goal_weeks': goalWeeks,
      if (level != null) 'level': level,
      if (trainingExperience != null) 'training_experience': trainingExperience,
      if (daysPerWeek != null) 'days_per_week': daysPerWeek,
      if (trainingDaysJson != null) 'training_days_json': trainingDaysJson,
      if (sessionMinutes != null) 'session_minutes': sessionMinutes,
      if (splitPreference != null) 'split_preference': splitPreference,
      if (focusMusclesJson != null) 'focus_muscles_json': focusMusclesJson,
      if (location != null) 'location': location,
      if (injuriesJson != null) 'injuries_json': injuriesJson,
      if (injuriesNote != null) 'injuries_note': injuriesNote,
      if (jobType != null) 'job_type': jobType,
      if (jobHours != null) 'job_hours': jobHours,
      if (sleepTime != null) 'sleep_time': sleepTime,
      if (wakeTime != null) 'wake_time': wakeTime,
      if (trainingTimeOfDay != null) 'training_time_of_day': trainingTimeOfDay,
      if (trainingTime != null) 'training_time': trainingTime,
      if (cardioType != null) 'cardio_type': cardioType,
      if (cardioPerWeek != null) 'cardio_per_week': cardioPerWeek,
      if (mealsPerDay != null) 'meals_per_day': mealsPerDay,
      if (mealTimesJson != null) 'meal_times_json': mealTimesJson,
      if (likedFoods != null) 'liked_foods': likedFoods,
      if (dislikedFoods != null) 'disliked_foods': dislikedFoods,
      if (allergies != null) 'allergies': allergies,
      if (budgetLevel != null) 'budget_level': budgetLevel,
      if (budgetEgp != null) 'budget_egp': budgetEgp,
      if (supplementsJson != null) 'supplements_json': supplementsJson,
      if (waterGoalMl != null) 'water_goal_ml': waterGoalMl,
      if (healthConnectEnabled != null)
        'health_connect_enabled': healthConnectEnabled,
      if (bmr != null) 'bmr': bmr,
      if (tdee != null) 'tdee': tdee,
      if (calorieTarget != null) 'calorie_target': calorieTarget,
      if (proteinG != null) 'protein_g': proteinG,
      if (carbsG != null) 'carbs_g': carbsG,
      if (fatG != null) 'fat_g': fatG,
      if (trainingDayCarbsG != null) 'training_day_carbs_g': trainingDayCarbsG,
      if (restDayCarbsG != null) 'rest_day_carbs_g': restDayCarbsG,
      if (onboardingComplete != null) 'onboarding_complete': onboardingComplete,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UserProfilesCompanion copyWith({
    Value<int>? id,
    Value<String>? language,
    Value<String?>? sex,
    Value<int?>? age,
    Value<double?>? heightCm,
    Value<double?>? weightKg,
    Value<double?>? bodyFatPct,
    Value<String?>? bodyFatMethod,
    Value<String>? measurementsJson,
    Value<String?>? goal,
    Value<double?>? targetWeightKg,
    Value<int?>? goalWeeks,
    Value<String?>? level,
    Value<String?>? trainingExperience,
    Value<int?>? daysPerWeek,
    Value<String>? trainingDaysJson,
    Value<int?>? sessionMinutes,
    Value<String?>? splitPreference,
    Value<String>? focusMusclesJson,
    Value<String?>? location,
    Value<String>? injuriesJson,
    Value<String?>? injuriesNote,
    Value<String?>? jobType,
    Value<String?>? jobHours,
    Value<String?>? sleepTime,
    Value<String?>? wakeTime,
    Value<String?>? trainingTimeOfDay,
    Value<String?>? trainingTime,
    Value<String?>? cardioType,
    Value<int?>? cardioPerWeek,
    Value<int?>? mealsPerDay,
    Value<String>? mealTimesJson,
    Value<String?>? likedFoods,
    Value<String?>? dislikedFoods,
    Value<String?>? allergies,
    Value<String?>? budgetLevel,
    Value<int?>? budgetEgp,
    Value<String>? supplementsJson,
    Value<int?>? waterGoalMl,
    Value<bool>? healthConnectEnabled,
    Value<double?>? bmr,
    Value<double?>? tdee,
    Value<int?>? calorieTarget,
    Value<int?>? proteinG,
    Value<int?>? carbsG,
    Value<int?>? fatG,
    Value<int?>? trainingDayCarbsG,
    Value<int?>? restDayCarbsG,
    Value<bool>? onboardingComplete,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return UserProfilesCompanion(
      id: id ?? this.id,
      language: language ?? this.language,
      sex: sex ?? this.sex,
      age: age ?? this.age,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      bodyFatPct: bodyFatPct ?? this.bodyFatPct,
      bodyFatMethod: bodyFatMethod ?? this.bodyFatMethod,
      measurementsJson: measurementsJson ?? this.measurementsJson,
      goal: goal ?? this.goal,
      targetWeightKg: targetWeightKg ?? this.targetWeightKg,
      goalWeeks: goalWeeks ?? this.goalWeeks,
      level: level ?? this.level,
      trainingExperience: trainingExperience ?? this.trainingExperience,
      daysPerWeek: daysPerWeek ?? this.daysPerWeek,
      trainingDaysJson: trainingDaysJson ?? this.trainingDaysJson,
      sessionMinutes: sessionMinutes ?? this.sessionMinutes,
      splitPreference: splitPreference ?? this.splitPreference,
      focusMusclesJson: focusMusclesJson ?? this.focusMusclesJson,
      location: location ?? this.location,
      injuriesJson: injuriesJson ?? this.injuriesJson,
      injuriesNote: injuriesNote ?? this.injuriesNote,
      jobType: jobType ?? this.jobType,
      jobHours: jobHours ?? this.jobHours,
      sleepTime: sleepTime ?? this.sleepTime,
      wakeTime: wakeTime ?? this.wakeTime,
      trainingTimeOfDay: trainingTimeOfDay ?? this.trainingTimeOfDay,
      trainingTime: trainingTime ?? this.trainingTime,
      cardioType: cardioType ?? this.cardioType,
      cardioPerWeek: cardioPerWeek ?? this.cardioPerWeek,
      mealsPerDay: mealsPerDay ?? this.mealsPerDay,
      mealTimesJson: mealTimesJson ?? this.mealTimesJson,
      likedFoods: likedFoods ?? this.likedFoods,
      dislikedFoods: dislikedFoods ?? this.dislikedFoods,
      allergies: allergies ?? this.allergies,
      budgetLevel: budgetLevel ?? this.budgetLevel,
      budgetEgp: budgetEgp ?? this.budgetEgp,
      supplementsJson: supplementsJson ?? this.supplementsJson,
      waterGoalMl: waterGoalMl ?? this.waterGoalMl,
      healthConnectEnabled: healthConnectEnabled ?? this.healthConnectEnabled,
      bmr: bmr ?? this.bmr,
      tdee: tdee ?? this.tdee,
      calorieTarget: calorieTarget ?? this.calorieTarget,
      proteinG: proteinG ?? this.proteinG,
      carbsG: carbsG ?? this.carbsG,
      fatG: fatG ?? this.fatG,
      trainingDayCarbsG: trainingDayCarbsG ?? this.trainingDayCarbsG,
      restDayCarbsG: restDayCarbsG ?? this.restDayCarbsG,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (sex.present) {
      map['sex'] = Variable<String>(sex.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (heightCm.present) {
      map['height_cm'] = Variable<double>(heightCm.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (bodyFatPct.present) {
      map['body_fat_pct'] = Variable<double>(bodyFatPct.value);
    }
    if (bodyFatMethod.present) {
      map['body_fat_method'] = Variable<String>(bodyFatMethod.value);
    }
    if (measurementsJson.present) {
      map['measurements_json'] = Variable<String>(measurementsJson.value);
    }
    if (goal.present) {
      map['goal'] = Variable<String>(goal.value);
    }
    if (targetWeightKg.present) {
      map['target_weight_kg'] = Variable<double>(targetWeightKg.value);
    }
    if (goalWeeks.present) {
      map['goal_weeks'] = Variable<int>(goalWeeks.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (trainingExperience.present) {
      map['training_experience'] = Variable<String>(trainingExperience.value);
    }
    if (daysPerWeek.present) {
      map['days_per_week'] = Variable<int>(daysPerWeek.value);
    }
    if (trainingDaysJson.present) {
      map['training_days_json'] = Variable<String>(trainingDaysJson.value);
    }
    if (sessionMinutes.present) {
      map['session_minutes'] = Variable<int>(sessionMinutes.value);
    }
    if (splitPreference.present) {
      map['split_preference'] = Variable<String>(splitPreference.value);
    }
    if (focusMusclesJson.present) {
      map['focus_muscles_json'] = Variable<String>(focusMusclesJson.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (injuriesJson.present) {
      map['injuries_json'] = Variable<String>(injuriesJson.value);
    }
    if (injuriesNote.present) {
      map['injuries_note'] = Variable<String>(injuriesNote.value);
    }
    if (jobType.present) {
      map['job_type'] = Variable<String>(jobType.value);
    }
    if (jobHours.present) {
      map['job_hours'] = Variable<String>(jobHours.value);
    }
    if (sleepTime.present) {
      map['sleep_time'] = Variable<String>(sleepTime.value);
    }
    if (wakeTime.present) {
      map['wake_time'] = Variable<String>(wakeTime.value);
    }
    if (trainingTimeOfDay.present) {
      map['training_time_of_day'] = Variable<String>(trainingTimeOfDay.value);
    }
    if (trainingTime.present) {
      map['training_time'] = Variable<String>(trainingTime.value);
    }
    if (cardioType.present) {
      map['cardio_type'] = Variable<String>(cardioType.value);
    }
    if (cardioPerWeek.present) {
      map['cardio_per_week'] = Variable<int>(cardioPerWeek.value);
    }
    if (mealsPerDay.present) {
      map['meals_per_day'] = Variable<int>(mealsPerDay.value);
    }
    if (mealTimesJson.present) {
      map['meal_times_json'] = Variable<String>(mealTimesJson.value);
    }
    if (likedFoods.present) {
      map['liked_foods'] = Variable<String>(likedFoods.value);
    }
    if (dislikedFoods.present) {
      map['disliked_foods'] = Variable<String>(dislikedFoods.value);
    }
    if (allergies.present) {
      map['allergies'] = Variable<String>(allergies.value);
    }
    if (budgetLevel.present) {
      map['budget_level'] = Variable<String>(budgetLevel.value);
    }
    if (budgetEgp.present) {
      map['budget_egp'] = Variable<int>(budgetEgp.value);
    }
    if (supplementsJson.present) {
      map['supplements_json'] = Variable<String>(supplementsJson.value);
    }
    if (waterGoalMl.present) {
      map['water_goal_ml'] = Variable<int>(waterGoalMl.value);
    }
    if (healthConnectEnabled.present) {
      map['health_connect_enabled'] = Variable<bool>(
        healthConnectEnabled.value,
      );
    }
    if (bmr.present) {
      map['bmr'] = Variable<double>(bmr.value);
    }
    if (tdee.present) {
      map['tdee'] = Variable<double>(tdee.value);
    }
    if (calorieTarget.present) {
      map['calorie_target'] = Variable<int>(calorieTarget.value);
    }
    if (proteinG.present) {
      map['protein_g'] = Variable<int>(proteinG.value);
    }
    if (carbsG.present) {
      map['carbs_g'] = Variable<int>(carbsG.value);
    }
    if (fatG.present) {
      map['fat_g'] = Variable<int>(fatG.value);
    }
    if (trainingDayCarbsG.present) {
      map['training_day_carbs_g'] = Variable<int>(trainingDayCarbsG.value);
    }
    if (restDayCarbsG.present) {
      map['rest_day_carbs_g'] = Variable<int>(restDayCarbsG.value);
    }
    if (onboardingComplete.present) {
      map['onboarding_complete'] = Variable<bool>(onboardingComplete.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesCompanion(')
          ..write('id: $id, ')
          ..write('language: $language, ')
          ..write('sex: $sex, ')
          ..write('age: $age, ')
          ..write('heightCm: $heightCm, ')
          ..write('weightKg: $weightKg, ')
          ..write('bodyFatPct: $bodyFatPct, ')
          ..write('bodyFatMethod: $bodyFatMethod, ')
          ..write('measurementsJson: $measurementsJson, ')
          ..write('goal: $goal, ')
          ..write('targetWeightKg: $targetWeightKg, ')
          ..write('goalWeeks: $goalWeeks, ')
          ..write('level: $level, ')
          ..write('trainingExperience: $trainingExperience, ')
          ..write('daysPerWeek: $daysPerWeek, ')
          ..write('trainingDaysJson: $trainingDaysJson, ')
          ..write('sessionMinutes: $sessionMinutes, ')
          ..write('splitPreference: $splitPreference, ')
          ..write('focusMusclesJson: $focusMusclesJson, ')
          ..write('location: $location, ')
          ..write('injuriesJson: $injuriesJson, ')
          ..write('injuriesNote: $injuriesNote, ')
          ..write('jobType: $jobType, ')
          ..write('jobHours: $jobHours, ')
          ..write('sleepTime: $sleepTime, ')
          ..write('wakeTime: $wakeTime, ')
          ..write('trainingTimeOfDay: $trainingTimeOfDay, ')
          ..write('trainingTime: $trainingTime, ')
          ..write('cardioType: $cardioType, ')
          ..write('cardioPerWeek: $cardioPerWeek, ')
          ..write('mealsPerDay: $mealsPerDay, ')
          ..write('mealTimesJson: $mealTimesJson, ')
          ..write('likedFoods: $likedFoods, ')
          ..write('dislikedFoods: $dislikedFoods, ')
          ..write('allergies: $allergies, ')
          ..write('budgetLevel: $budgetLevel, ')
          ..write('budgetEgp: $budgetEgp, ')
          ..write('supplementsJson: $supplementsJson, ')
          ..write('waterGoalMl: $waterGoalMl, ')
          ..write('healthConnectEnabled: $healthConnectEnabled, ')
          ..write('bmr: $bmr, ')
          ..write('tdee: $tdee, ')
          ..write('calorieTarget: $calorieTarget, ')
          ..write('proteinG: $proteinG, ')
          ..write('carbsG: $carbsG, ')
          ..write('fatG: $fatG, ')
          ..write('trainingDayCarbsG: $trainingDayCarbsG, ')
          ..write('restDayCarbsG: $restDayCarbsG, ')
          ..write('onboardingComplete: $onboardingComplete, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ExercisesTable extends Exercises
    with TableInfo<$ExercisesTable, Exercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
    'name_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _primaryMusclesJsonMeta =
      const VerificationMeta('primaryMusclesJson');
  @override
  late final GeneratedColumn<String> primaryMusclesJson =
      GeneratedColumn<String>(
        'primary_muscles_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _secondaryMusclesJsonMeta =
      const VerificationMeta('secondaryMusclesJson');
  @override
  late final GeneratedColumn<String> secondaryMusclesJson =
      GeneratedColumn<String>(
        'secondary_muscles_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _equipmentMeta = const VerificationMeta(
    'equipment',
  );
  @override
  late final GeneratedColumn<String> equipment = GeneratedColumn<String>(
    'equipment',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _forceMeta = const VerificationMeta('force');
  @override
  late final GeneratedColumn<String> force = GeneratedColumn<String>(
    'force',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _movementPatternMeta = const VerificationMeta(
    'movementPattern',
  );
  @override
  late final GeneratedColumn<String> movementPattern = GeneratedColumn<String>(
    'movement_pattern',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mechanicMeta = const VerificationMeta(
    'mechanic',
  );
  @override
  late final GeneratedColumn<String> mechanic = GeneratedColumn<String>(
    'mechanic',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
    'level',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _instructionsEnJsonMeta =
      const VerificationMeta('instructionsEnJson');
  @override
  late final GeneratedColumn<String> instructionsEnJson =
      GeneratedColumn<String>(
        'instructions_en_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _instructionsArJsonMeta =
      const VerificationMeta('instructionsArJson');
  @override
  late final GeneratedColumn<String> instructionsArJson =
      GeneratedColumn<String>(
        'instructions_ar_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _mistakesEnJsonMeta = const VerificationMeta(
    'mistakesEnJson',
  );
  @override
  late final GeneratedColumn<String> mistakesEnJson = GeneratedColumn<String>(
    'mistakes_en_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _mistakesArJsonMeta = const VerificationMeta(
    'mistakesArJson',
  );
  @override
  late final GeneratedColumn<String> mistakesArJson = GeneratedColumn<String>(
    'mistakes_ar_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _imagesJsonMeta = const VerificationMeta(
    'imagesJson',
  );
  @override
  late final GeneratedColumn<String> imagesJson = GeneratedColumn<String>(
    'images_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _mediaPathMeta = const VerificationMeta(
    'mediaPath',
  );
  @override
  late final GeneratedColumn<String> mediaPath = GeneratedColumn<String>(
    'media_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCustomMeta = const VerificationMeta(
    'isCustom',
  );
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
    'is_custom',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_custom" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nameEn,
    nameAr,
    primaryMusclesJson,
    secondaryMusclesJson,
    equipment,
    force,
    movementPattern,
    mechanic,
    category,
    level,
    instructionsEnJson,
    instructionsArJson,
    mistakesEnJson,
    mistakesArJson,
    imagesJson,
    mediaPath,
    isCustom,
    isFavorite,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<Exercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('name_ar')) {
      context.handle(
        _nameArMeta,
        nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta),
      );
    } else if (isInserting) {
      context.missing(_nameArMeta);
    }
    if (data.containsKey('primary_muscles_json')) {
      context.handle(
        _primaryMusclesJsonMeta,
        primaryMusclesJson.isAcceptableOrUnknown(
          data['primary_muscles_json']!,
          _primaryMusclesJsonMeta,
        ),
      );
    }
    if (data.containsKey('secondary_muscles_json')) {
      context.handle(
        _secondaryMusclesJsonMeta,
        secondaryMusclesJson.isAcceptableOrUnknown(
          data['secondary_muscles_json']!,
          _secondaryMusclesJsonMeta,
        ),
      );
    }
    if (data.containsKey('equipment')) {
      context.handle(
        _equipmentMeta,
        equipment.isAcceptableOrUnknown(data['equipment']!, _equipmentMeta),
      );
    }
    if (data.containsKey('force')) {
      context.handle(
        _forceMeta,
        force.isAcceptableOrUnknown(data['force']!, _forceMeta),
      );
    }
    if (data.containsKey('movement_pattern')) {
      context.handle(
        _movementPatternMeta,
        movementPattern.isAcceptableOrUnknown(
          data['movement_pattern']!,
          _movementPatternMeta,
        ),
      );
    }
    if (data.containsKey('mechanic')) {
      context.handle(
        _mechanicMeta,
        mechanic.isAcceptableOrUnknown(data['mechanic']!, _mechanicMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    }
    if (data.containsKey('instructions_en_json')) {
      context.handle(
        _instructionsEnJsonMeta,
        instructionsEnJson.isAcceptableOrUnknown(
          data['instructions_en_json']!,
          _instructionsEnJsonMeta,
        ),
      );
    }
    if (data.containsKey('instructions_ar_json')) {
      context.handle(
        _instructionsArJsonMeta,
        instructionsArJson.isAcceptableOrUnknown(
          data['instructions_ar_json']!,
          _instructionsArJsonMeta,
        ),
      );
    }
    if (data.containsKey('mistakes_en_json')) {
      context.handle(
        _mistakesEnJsonMeta,
        mistakesEnJson.isAcceptableOrUnknown(
          data['mistakes_en_json']!,
          _mistakesEnJsonMeta,
        ),
      );
    }
    if (data.containsKey('mistakes_ar_json')) {
      context.handle(
        _mistakesArJsonMeta,
        mistakesArJson.isAcceptableOrUnknown(
          data['mistakes_ar_json']!,
          _mistakesArJsonMeta,
        ),
      );
    }
    if (data.containsKey('images_json')) {
      context.handle(
        _imagesJsonMeta,
        imagesJson.isAcceptableOrUnknown(data['images_json']!, _imagesJsonMeta),
      );
    }
    if (data.containsKey('media_path')) {
      context.handle(
        _mediaPathMeta,
        mediaPath.isAcceptableOrUnknown(data['media_path']!, _mediaPathMeta),
      );
    }
    if (data.containsKey('is_custom')) {
      context.handle(
        _isCustomMeta,
        isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Exercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Exercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      )!,
      nameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ar'],
      )!,
      primaryMusclesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}primary_muscles_json'],
      )!,
      secondaryMusclesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}secondary_muscles_json'],
      )!,
      equipment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}equipment'],
      ),
      force: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}force'],
      ),
      movementPattern: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}movement_pattern'],
      ),
      mechanic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mechanic'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}level'],
      ),
      instructionsEnJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}instructions_en_json'],
      )!,
      instructionsArJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}instructions_ar_json'],
      )!,
      mistakesEnJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mistakes_en_json'],
      )!,
      mistakesArJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mistakes_ar_json'],
      )!,
      imagesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}images_json'],
      )!,
      mediaPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_path'],
      ),
      isCustom: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_custom'],
      )!,
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ExercisesTable createAlias(String alias) {
    return $ExercisesTable(attachedDatabase, alias);
  }
}

class Exercise extends DataClass implements Insertable<Exercise> {
  final String id;
  final String nameEn;
  final String nameAr;
  final String primaryMusclesJson;
  final String secondaryMusclesJson;
  final String? equipment;
  final String? force;
  final String? movementPattern;
  final String? mechanic;
  final String? category;
  final String? level;
  final String instructionsEnJson;
  final String instructionsArJson;
  final String mistakesEnJson;
  final String mistakesArJson;
  final String imagesJson;
  final String? mediaPath;
  final bool isCustom;
  final bool isFavorite;
  final DateTime createdAt;
  const Exercise({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.primaryMusclesJson,
    required this.secondaryMusclesJson,
    this.equipment,
    this.force,
    this.movementPattern,
    this.mechanic,
    this.category,
    this.level,
    required this.instructionsEnJson,
    required this.instructionsArJson,
    required this.mistakesEnJson,
    required this.mistakesArJson,
    required this.imagesJson,
    this.mediaPath,
    required this.isCustom,
    required this.isFavorite,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name_en'] = Variable<String>(nameEn);
    map['name_ar'] = Variable<String>(nameAr);
    map['primary_muscles_json'] = Variable<String>(primaryMusclesJson);
    map['secondary_muscles_json'] = Variable<String>(secondaryMusclesJson);
    if (!nullToAbsent || equipment != null) {
      map['equipment'] = Variable<String>(equipment);
    }
    if (!nullToAbsent || force != null) {
      map['force'] = Variable<String>(force);
    }
    if (!nullToAbsent || movementPattern != null) {
      map['movement_pattern'] = Variable<String>(movementPattern);
    }
    if (!nullToAbsent || mechanic != null) {
      map['mechanic'] = Variable<String>(mechanic);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || level != null) {
      map['level'] = Variable<String>(level);
    }
    map['instructions_en_json'] = Variable<String>(instructionsEnJson);
    map['instructions_ar_json'] = Variable<String>(instructionsArJson);
    map['mistakes_en_json'] = Variable<String>(mistakesEnJson);
    map['mistakes_ar_json'] = Variable<String>(mistakesArJson);
    map['images_json'] = Variable<String>(imagesJson);
    if (!nullToAbsent || mediaPath != null) {
      map['media_path'] = Variable<String>(mediaPath);
    }
    map['is_custom'] = Variable<bool>(isCustom);
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ExercisesCompanion toCompanion(bool nullToAbsent) {
    return ExercisesCompanion(
      id: Value(id),
      nameEn: Value(nameEn),
      nameAr: Value(nameAr),
      primaryMusclesJson: Value(primaryMusclesJson),
      secondaryMusclesJson: Value(secondaryMusclesJson),
      equipment: equipment == null && nullToAbsent
          ? const Value.absent()
          : Value(equipment),
      force: force == null && nullToAbsent
          ? const Value.absent()
          : Value(force),
      movementPattern: movementPattern == null && nullToAbsent
          ? const Value.absent()
          : Value(movementPattern),
      mechanic: mechanic == null && nullToAbsent
          ? const Value.absent()
          : Value(mechanic),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      level: level == null && nullToAbsent
          ? const Value.absent()
          : Value(level),
      instructionsEnJson: Value(instructionsEnJson),
      instructionsArJson: Value(instructionsArJson),
      mistakesEnJson: Value(mistakesEnJson),
      mistakesArJson: Value(mistakesArJson),
      imagesJson: Value(imagesJson),
      mediaPath: mediaPath == null && nullToAbsent
          ? const Value.absent()
          : Value(mediaPath),
      isCustom: Value(isCustom),
      isFavorite: Value(isFavorite),
      createdAt: Value(createdAt),
    );
  }

  factory Exercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Exercise(
      id: serializer.fromJson<String>(json['id']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
      nameAr: serializer.fromJson<String>(json['nameAr']),
      primaryMusclesJson: serializer.fromJson<String>(
        json['primaryMusclesJson'],
      ),
      secondaryMusclesJson: serializer.fromJson<String>(
        json['secondaryMusclesJson'],
      ),
      equipment: serializer.fromJson<String?>(json['equipment']),
      force: serializer.fromJson<String?>(json['force']),
      movementPattern: serializer.fromJson<String?>(json['movementPattern']),
      mechanic: serializer.fromJson<String?>(json['mechanic']),
      category: serializer.fromJson<String?>(json['category']),
      level: serializer.fromJson<String?>(json['level']),
      instructionsEnJson: serializer.fromJson<String>(
        json['instructionsEnJson'],
      ),
      instructionsArJson: serializer.fromJson<String>(
        json['instructionsArJson'],
      ),
      mistakesEnJson: serializer.fromJson<String>(json['mistakesEnJson']),
      mistakesArJson: serializer.fromJson<String>(json['mistakesArJson']),
      imagesJson: serializer.fromJson<String>(json['imagesJson']),
      mediaPath: serializer.fromJson<String?>(json['mediaPath']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nameEn': serializer.toJson<String>(nameEn),
      'nameAr': serializer.toJson<String>(nameAr),
      'primaryMusclesJson': serializer.toJson<String>(primaryMusclesJson),
      'secondaryMusclesJson': serializer.toJson<String>(secondaryMusclesJson),
      'equipment': serializer.toJson<String?>(equipment),
      'force': serializer.toJson<String?>(force),
      'movementPattern': serializer.toJson<String?>(movementPattern),
      'mechanic': serializer.toJson<String?>(mechanic),
      'category': serializer.toJson<String?>(category),
      'level': serializer.toJson<String?>(level),
      'instructionsEnJson': serializer.toJson<String>(instructionsEnJson),
      'instructionsArJson': serializer.toJson<String>(instructionsArJson),
      'mistakesEnJson': serializer.toJson<String>(mistakesEnJson),
      'mistakesArJson': serializer.toJson<String>(mistakesArJson),
      'imagesJson': serializer.toJson<String>(imagesJson),
      'mediaPath': serializer.toJson<String?>(mediaPath),
      'isCustom': serializer.toJson<bool>(isCustom),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Exercise copyWith({
    String? id,
    String? nameEn,
    String? nameAr,
    String? primaryMusclesJson,
    String? secondaryMusclesJson,
    Value<String?> equipment = const Value.absent(),
    Value<String?> force = const Value.absent(),
    Value<String?> movementPattern = const Value.absent(),
    Value<String?> mechanic = const Value.absent(),
    Value<String?> category = const Value.absent(),
    Value<String?> level = const Value.absent(),
    String? instructionsEnJson,
    String? instructionsArJson,
    String? mistakesEnJson,
    String? mistakesArJson,
    String? imagesJson,
    Value<String?> mediaPath = const Value.absent(),
    bool? isCustom,
    bool? isFavorite,
    DateTime? createdAt,
  }) => Exercise(
    id: id ?? this.id,
    nameEn: nameEn ?? this.nameEn,
    nameAr: nameAr ?? this.nameAr,
    primaryMusclesJson: primaryMusclesJson ?? this.primaryMusclesJson,
    secondaryMusclesJson: secondaryMusclesJson ?? this.secondaryMusclesJson,
    equipment: equipment.present ? equipment.value : this.equipment,
    force: force.present ? force.value : this.force,
    movementPattern: movementPattern.present
        ? movementPattern.value
        : this.movementPattern,
    mechanic: mechanic.present ? mechanic.value : this.mechanic,
    category: category.present ? category.value : this.category,
    level: level.present ? level.value : this.level,
    instructionsEnJson: instructionsEnJson ?? this.instructionsEnJson,
    instructionsArJson: instructionsArJson ?? this.instructionsArJson,
    mistakesEnJson: mistakesEnJson ?? this.mistakesEnJson,
    mistakesArJson: mistakesArJson ?? this.mistakesArJson,
    imagesJson: imagesJson ?? this.imagesJson,
    mediaPath: mediaPath.present ? mediaPath.value : this.mediaPath,
    isCustom: isCustom ?? this.isCustom,
    isFavorite: isFavorite ?? this.isFavorite,
    createdAt: createdAt ?? this.createdAt,
  );
  Exercise copyWithCompanion(ExercisesCompanion data) {
    return Exercise(
      id: data.id.present ? data.id.value : this.id,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      primaryMusclesJson: data.primaryMusclesJson.present
          ? data.primaryMusclesJson.value
          : this.primaryMusclesJson,
      secondaryMusclesJson: data.secondaryMusclesJson.present
          ? data.secondaryMusclesJson.value
          : this.secondaryMusclesJson,
      equipment: data.equipment.present ? data.equipment.value : this.equipment,
      force: data.force.present ? data.force.value : this.force,
      movementPattern: data.movementPattern.present
          ? data.movementPattern.value
          : this.movementPattern,
      mechanic: data.mechanic.present ? data.mechanic.value : this.mechanic,
      category: data.category.present ? data.category.value : this.category,
      level: data.level.present ? data.level.value : this.level,
      instructionsEnJson: data.instructionsEnJson.present
          ? data.instructionsEnJson.value
          : this.instructionsEnJson,
      instructionsArJson: data.instructionsArJson.present
          ? data.instructionsArJson.value
          : this.instructionsArJson,
      mistakesEnJson: data.mistakesEnJson.present
          ? data.mistakesEnJson.value
          : this.mistakesEnJson,
      mistakesArJson: data.mistakesArJson.present
          ? data.mistakesArJson.value
          : this.mistakesArJson,
      imagesJson: data.imagesJson.present
          ? data.imagesJson.value
          : this.imagesJson,
      mediaPath: data.mediaPath.present ? data.mediaPath.value : this.mediaPath,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Exercise(')
          ..write('id: $id, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameAr: $nameAr, ')
          ..write('primaryMusclesJson: $primaryMusclesJson, ')
          ..write('secondaryMusclesJson: $secondaryMusclesJson, ')
          ..write('equipment: $equipment, ')
          ..write('force: $force, ')
          ..write('movementPattern: $movementPattern, ')
          ..write('mechanic: $mechanic, ')
          ..write('category: $category, ')
          ..write('level: $level, ')
          ..write('instructionsEnJson: $instructionsEnJson, ')
          ..write('instructionsArJson: $instructionsArJson, ')
          ..write('mistakesEnJson: $mistakesEnJson, ')
          ..write('mistakesArJson: $mistakesArJson, ')
          ..write('imagesJson: $imagesJson, ')
          ..write('mediaPath: $mediaPath, ')
          ..write('isCustom: $isCustom, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nameEn,
    nameAr,
    primaryMusclesJson,
    secondaryMusclesJson,
    equipment,
    force,
    movementPattern,
    mechanic,
    category,
    level,
    instructionsEnJson,
    instructionsArJson,
    mistakesEnJson,
    mistakesArJson,
    imagesJson,
    mediaPath,
    isCustom,
    isFavorite,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Exercise &&
          other.id == this.id &&
          other.nameEn == this.nameEn &&
          other.nameAr == this.nameAr &&
          other.primaryMusclesJson == this.primaryMusclesJson &&
          other.secondaryMusclesJson == this.secondaryMusclesJson &&
          other.equipment == this.equipment &&
          other.force == this.force &&
          other.movementPattern == this.movementPattern &&
          other.mechanic == this.mechanic &&
          other.category == this.category &&
          other.level == this.level &&
          other.instructionsEnJson == this.instructionsEnJson &&
          other.instructionsArJson == this.instructionsArJson &&
          other.mistakesEnJson == this.mistakesEnJson &&
          other.mistakesArJson == this.mistakesArJson &&
          other.imagesJson == this.imagesJson &&
          other.mediaPath == this.mediaPath &&
          other.isCustom == this.isCustom &&
          other.isFavorite == this.isFavorite &&
          other.createdAt == this.createdAt);
}

class ExercisesCompanion extends UpdateCompanion<Exercise> {
  final Value<String> id;
  final Value<String> nameEn;
  final Value<String> nameAr;
  final Value<String> primaryMusclesJson;
  final Value<String> secondaryMusclesJson;
  final Value<String?> equipment;
  final Value<String?> force;
  final Value<String?> movementPattern;
  final Value<String?> mechanic;
  final Value<String?> category;
  final Value<String?> level;
  final Value<String> instructionsEnJson;
  final Value<String> instructionsArJson;
  final Value<String> mistakesEnJson;
  final Value<String> mistakesArJson;
  final Value<String> imagesJson;
  final Value<String?> mediaPath;
  final Value<bool> isCustom;
  final Value<bool> isFavorite;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ExercisesCompanion({
    this.id = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.primaryMusclesJson = const Value.absent(),
    this.secondaryMusclesJson = const Value.absent(),
    this.equipment = const Value.absent(),
    this.force = const Value.absent(),
    this.movementPattern = const Value.absent(),
    this.mechanic = const Value.absent(),
    this.category = const Value.absent(),
    this.level = const Value.absent(),
    this.instructionsEnJson = const Value.absent(),
    this.instructionsArJson = const Value.absent(),
    this.mistakesEnJson = const Value.absent(),
    this.mistakesArJson = const Value.absent(),
    this.imagesJson = const Value.absent(),
    this.mediaPath = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExercisesCompanion.insert({
    required String id,
    required String nameEn,
    required String nameAr,
    this.primaryMusclesJson = const Value.absent(),
    this.secondaryMusclesJson = const Value.absent(),
    this.equipment = const Value.absent(),
    this.force = const Value.absent(),
    this.movementPattern = const Value.absent(),
    this.mechanic = const Value.absent(),
    this.category = const Value.absent(),
    this.level = const Value.absent(),
    this.instructionsEnJson = const Value.absent(),
    this.instructionsArJson = const Value.absent(),
    this.mistakesEnJson = const Value.absent(),
    this.mistakesArJson = const Value.absent(),
    this.imagesJson = const Value.absent(),
    this.mediaPath = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nameEn = Value(nameEn),
       nameAr = Value(nameAr);
  static Insertable<Exercise> custom({
    Expression<String>? id,
    Expression<String>? nameEn,
    Expression<String>? nameAr,
    Expression<String>? primaryMusclesJson,
    Expression<String>? secondaryMusclesJson,
    Expression<String>? equipment,
    Expression<String>? force,
    Expression<String>? movementPattern,
    Expression<String>? mechanic,
    Expression<String>? category,
    Expression<String>? level,
    Expression<String>? instructionsEnJson,
    Expression<String>? instructionsArJson,
    Expression<String>? mistakesEnJson,
    Expression<String>? mistakesArJson,
    Expression<String>? imagesJson,
    Expression<String>? mediaPath,
    Expression<bool>? isCustom,
    Expression<bool>? isFavorite,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameEn != null) 'name_en': nameEn,
      if (nameAr != null) 'name_ar': nameAr,
      if (primaryMusclesJson != null)
        'primary_muscles_json': primaryMusclesJson,
      if (secondaryMusclesJson != null)
        'secondary_muscles_json': secondaryMusclesJson,
      if (equipment != null) 'equipment': equipment,
      if (force != null) 'force': force,
      if (movementPattern != null) 'movement_pattern': movementPattern,
      if (mechanic != null) 'mechanic': mechanic,
      if (category != null) 'category': category,
      if (level != null) 'level': level,
      if (instructionsEnJson != null)
        'instructions_en_json': instructionsEnJson,
      if (instructionsArJson != null)
        'instructions_ar_json': instructionsArJson,
      if (mistakesEnJson != null) 'mistakes_en_json': mistakesEnJson,
      if (mistakesArJson != null) 'mistakes_ar_json': mistakesArJson,
      if (imagesJson != null) 'images_json': imagesJson,
      if (mediaPath != null) 'media_path': mediaPath,
      if (isCustom != null) 'is_custom': isCustom,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExercisesCompanion copyWith({
    Value<String>? id,
    Value<String>? nameEn,
    Value<String>? nameAr,
    Value<String>? primaryMusclesJson,
    Value<String>? secondaryMusclesJson,
    Value<String?>? equipment,
    Value<String?>? force,
    Value<String?>? movementPattern,
    Value<String?>? mechanic,
    Value<String?>? category,
    Value<String?>? level,
    Value<String>? instructionsEnJson,
    Value<String>? instructionsArJson,
    Value<String>? mistakesEnJson,
    Value<String>? mistakesArJson,
    Value<String>? imagesJson,
    Value<String?>? mediaPath,
    Value<bool>? isCustom,
    Value<bool>? isFavorite,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ExercisesCompanion(
      id: id ?? this.id,
      nameEn: nameEn ?? this.nameEn,
      nameAr: nameAr ?? this.nameAr,
      primaryMusclesJson: primaryMusclesJson ?? this.primaryMusclesJson,
      secondaryMusclesJson: secondaryMusclesJson ?? this.secondaryMusclesJson,
      equipment: equipment ?? this.equipment,
      force: force ?? this.force,
      movementPattern: movementPattern ?? this.movementPattern,
      mechanic: mechanic ?? this.mechanic,
      category: category ?? this.category,
      level: level ?? this.level,
      instructionsEnJson: instructionsEnJson ?? this.instructionsEnJson,
      instructionsArJson: instructionsArJson ?? this.instructionsArJson,
      mistakesEnJson: mistakesEnJson ?? this.mistakesEnJson,
      mistakesArJson: mistakesArJson ?? this.mistakesArJson,
      imagesJson: imagesJson ?? this.imagesJson,
      mediaPath: mediaPath ?? this.mediaPath,
      isCustom: isCustom ?? this.isCustom,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (primaryMusclesJson.present) {
      map['primary_muscles_json'] = Variable<String>(primaryMusclesJson.value);
    }
    if (secondaryMusclesJson.present) {
      map['secondary_muscles_json'] = Variable<String>(
        secondaryMusclesJson.value,
      );
    }
    if (equipment.present) {
      map['equipment'] = Variable<String>(equipment.value);
    }
    if (force.present) {
      map['force'] = Variable<String>(force.value);
    }
    if (movementPattern.present) {
      map['movement_pattern'] = Variable<String>(movementPattern.value);
    }
    if (mechanic.present) {
      map['mechanic'] = Variable<String>(mechanic.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (instructionsEnJson.present) {
      map['instructions_en_json'] = Variable<String>(instructionsEnJson.value);
    }
    if (instructionsArJson.present) {
      map['instructions_ar_json'] = Variable<String>(instructionsArJson.value);
    }
    if (mistakesEnJson.present) {
      map['mistakes_en_json'] = Variable<String>(mistakesEnJson.value);
    }
    if (mistakesArJson.present) {
      map['mistakes_ar_json'] = Variable<String>(mistakesArJson.value);
    }
    if (imagesJson.present) {
      map['images_json'] = Variable<String>(imagesJson.value);
    }
    if (mediaPath.present) {
      map['media_path'] = Variable<String>(mediaPath.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExercisesCompanion(')
          ..write('id: $id, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameAr: $nameAr, ')
          ..write('primaryMusclesJson: $primaryMusclesJson, ')
          ..write('secondaryMusclesJson: $secondaryMusclesJson, ')
          ..write('equipment: $equipment, ')
          ..write('force: $force, ')
          ..write('movementPattern: $movementPattern, ')
          ..write('mechanic: $mechanic, ')
          ..write('category: $category, ')
          ..write('level: $level, ')
          ..write('instructionsEnJson: $instructionsEnJson, ')
          ..write('instructionsArJson: $instructionsArJson, ')
          ..write('mistakesEnJson: $mistakesEnJson, ')
          ..write('mistakesArJson: $mistakesArJson, ')
          ..write('imagesJson: $imagesJson, ')
          ..write('mediaPath: $mediaPath, ')
          ..write('isCustom: $isCustom, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutPlansTable extends WorkoutPlans
    with TableInfo<$WorkoutPlansTable, WorkoutPlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutPlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('ai'),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deloadEveryWeeksMeta = const VerificationMeta(
    'deloadEveryWeeks',
  );
  @override
  late final GeneratedColumn<int> deloadEveryWeeks = GeneratedColumn<int>(
    'deload_every_weeks',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rawJsonMeta = const VerificationMeta(
    'rawJson',
  );
  @override
  late final GeneratedColumn<String> rawJson = GeneratedColumn<String>(
    'raw_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _activatedAtMeta = const VerificationMeta(
    'activatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> activatedAt = GeneratedColumn<DateTime>(
    'activated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    notes,
    source,
    isActive,
    deloadEveryWeeks,
    rawJson,
    createdAt,
    activatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutPlan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('deload_every_weeks')) {
      context.handle(
        _deloadEveryWeeksMeta,
        deloadEveryWeeks.isAcceptableOrUnknown(
          data['deload_every_weeks']!,
          _deloadEveryWeeksMeta,
        ),
      );
    }
    if (data.containsKey('raw_json')) {
      context.handle(
        _rawJsonMeta,
        rawJson.isAcceptableOrUnknown(data['raw_json']!, _rawJsonMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('activated_at')) {
      context.handle(
        _activatedAtMeta,
        activatedAt.isAcceptableOrUnknown(
          data['activated_at']!,
          _activatedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutPlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutPlan(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      deloadEveryWeeks: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deload_every_weeks'],
      ),
      rawJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_json'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      activatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}activated_at'],
      ),
    );
  }

  @override
  $WorkoutPlansTable createAlias(String alias) {
    return $WorkoutPlansTable(attachedDatabase, alias);
  }
}

class WorkoutPlan extends DataClass implements Insertable<WorkoutPlan> {
  final int id;
  final String name;
  final String? notes;
  final String source;
  final bool isActive;
  final int? deloadEveryWeeks;
  final String? rawJson;
  final DateTime createdAt;
  final DateTime? activatedAt;
  const WorkoutPlan({
    required this.id,
    required this.name,
    this.notes,
    required this.source,
    required this.isActive,
    this.deloadEveryWeeks,
    this.rawJson,
    required this.createdAt,
    this.activatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['source'] = Variable<String>(source);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || deloadEveryWeeks != null) {
      map['deload_every_weeks'] = Variable<int>(deloadEveryWeeks);
    }
    if (!nullToAbsent || rawJson != null) {
      map['raw_json'] = Variable<String>(rawJson);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || activatedAt != null) {
      map['activated_at'] = Variable<DateTime>(activatedAt);
    }
    return map;
  }

  WorkoutPlansCompanion toCompanion(bool nullToAbsent) {
    return WorkoutPlansCompanion(
      id: Value(id),
      name: Value(name),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      source: Value(source),
      isActive: Value(isActive),
      deloadEveryWeeks: deloadEveryWeeks == null && nullToAbsent
          ? const Value.absent()
          : Value(deloadEveryWeeks),
      rawJson: rawJson == null && nullToAbsent
          ? const Value.absent()
          : Value(rawJson),
      createdAt: Value(createdAt),
      activatedAt: activatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(activatedAt),
    );
  }

  factory WorkoutPlan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutPlan(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      notes: serializer.fromJson<String?>(json['notes']),
      source: serializer.fromJson<String>(json['source']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      deloadEveryWeeks: serializer.fromJson<int?>(json['deloadEveryWeeks']),
      rawJson: serializer.fromJson<String?>(json['rawJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      activatedAt: serializer.fromJson<DateTime?>(json['activatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'notes': serializer.toJson<String?>(notes),
      'source': serializer.toJson<String>(source),
      'isActive': serializer.toJson<bool>(isActive),
      'deloadEveryWeeks': serializer.toJson<int?>(deloadEveryWeeks),
      'rawJson': serializer.toJson<String?>(rawJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'activatedAt': serializer.toJson<DateTime?>(activatedAt),
    };
  }

  WorkoutPlan copyWith({
    int? id,
    String? name,
    Value<String?> notes = const Value.absent(),
    String? source,
    bool? isActive,
    Value<int?> deloadEveryWeeks = const Value.absent(),
    Value<String?> rawJson = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> activatedAt = const Value.absent(),
  }) => WorkoutPlan(
    id: id ?? this.id,
    name: name ?? this.name,
    notes: notes.present ? notes.value : this.notes,
    source: source ?? this.source,
    isActive: isActive ?? this.isActive,
    deloadEveryWeeks: deloadEveryWeeks.present
        ? deloadEveryWeeks.value
        : this.deloadEveryWeeks,
    rawJson: rawJson.present ? rawJson.value : this.rawJson,
    createdAt: createdAt ?? this.createdAt,
    activatedAt: activatedAt.present ? activatedAt.value : this.activatedAt,
  );
  WorkoutPlan copyWithCompanion(WorkoutPlansCompanion data) {
    return WorkoutPlan(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      notes: data.notes.present ? data.notes.value : this.notes,
      source: data.source.present ? data.source.value : this.source,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      deloadEveryWeeks: data.deloadEveryWeeks.present
          ? data.deloadEveryWeeks.value
          : this.deloadEveryWeeks,
      rawJson: data.rawJson.present ? data.rawJson.value : this.rawJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      activatedAt: data.activatedAt.present
          ? data.activatedAt.value
          : this.activatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutPlan(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('notes: $notes, ')
          ..write('source: $source, ')
          ..write('isActive: $isActive, ')
          ..write('deloadEveryWeeks: $deloadEveryWeeks, ')
          ..write('rawJson: $rawJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('activatedAt: $activatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    notes,
    source,
    isActive,
    deloadEveryWeeks,
    rawJson,
    createdAt,
    activatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutPlan &&
          other.id == this.id &&
          other.name == this.name &&
          other.notes == this.notes &&
          other.source == this.source &&
          other.isActive == this.isActive &&
          other.deloadEveryWeeks == this.deloadEveryWeeks &&
          other.rawJson == this.rawJson &&
          other.createdAt == this.createdAt &&
          other.activatedAt == this.activatedAt);
}

class WorkoutPlansCompanion extends UpdateCompanion<WorkoutPlan> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> notes;
  final Value<String> source;
  final Value<bool> isActive;
  final Value<int?> deloadEveryWeeks;
  final Value<String?> rawJson;
  final Value<DateTime> createdAt;
  final Value<DateTime?> activatedAt;
  const WorkoutPlansCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.notes = const Value.absent(),
    this.source = const Value.absent(),
    this.isActive = const Value.absent(),
    this.deloadEveryWeeks = const Value.absent(),
    this.rawJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.activatedAt = const Value.absent(),
  });
  WorkoutPlansCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.notes = const Value.absent(),
    this.source = const Value.absent(),
    this.isActive = const Value.absent(),
    this.deloadEveryWeeks = const Value.absent(),
    this.rawJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.activatedAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<WorkoutPlan> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? notes,
    Expression<String>? source,
    Expression<bool>? isActive,
    Expression<int>? deloadEveryWeeks,
    Expression<String>? rawJson,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? activatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (notes != null) 'notes': notes,
      if (source != null) 'source': source,
      if (isActive != null) 'is_active': isActive,
      if (deloadEveryWeeks != null) 'deload_every_weeks': deloadEveryWeeks,
      if (rawJson != null) 'raw_json': rawJson,
      if (createdAt != null) 'created_at': createdAt,
      if (activatedAt != null) 'activated_at': activatedAt,
    });
  }

  WorkoutPlansCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? notes,
    Value<String>? source,
    Value<bool>? isActive,
    Value<int?>? deloadEveryWeeks,
    Value<String?>? rawJson,
    Value<DateTime>? createdAt,
    Value<DateTime?>? activatedAt,
  }) {
    return WorkoutPlansCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      notes: notes ?? this.notes,
      source: source ?? this.source,
      isActive: isActive ?? this.isActive,
      deloadEveryWeeks: deloadEveryWeeks ?? this.deloadEveryWeeks,
      rawJson: rawJson ?? this.rawJson,
      createdAt: createdAt ?? this.createdAt,
      activatedAt: activatedAt ?? this.activatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (deloadEveryWeeks.present) {
      map['deload_every_weeks'] = Variable<int>(deloadEveryWeeks.value);
    }
    if (rawJson.present) {
      map['raw_json'] = Variable<String>(rawJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (activatedAt.present) {
      map['activated_at'] = Variable<DateTime>(activatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutPlansCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('notes: $notes, ')
          ..write('source: $source, ')
          ..write('isActive: $isActive, ')
          ..write('deloadEveryWeeks: $deloadEveryWeeks, ')
          ..write('rawJson: $rawJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('activatedAt: $activatedAt')
          ..write(')'))
        .toString();
  }
}

class $PlanDaysTable extends PlanDays with TableInfo<$PlanDaysTable, PlanDay> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlanDaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<int> planId = GeneratedColumn<int>(
    'plan_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_plans (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _weekdayMeta = const VerificationMeta(
    'weekday',
  );
  @override
  late final GeneratedColumn<int> weekday = GeneratedColumn<int>(
    'weekday',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _focusMeta = const VerificationMeta('focus');
  @override
  late final GeneratedColumn<String> focus = GeneratedColumn<String>(
    'focus',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _warmupJsonMeta = const VerificationMeta(
    'warmupJson',
  );
  @override
  late final GeneratedColumn<String> warmupJson = GeneratedColumn<String>(
    'warmup_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _cooldownJsonMeta = const VerificationMeta(
    'cooldownJson',
  );
  @override
  late final GeneratedColumn<String> cooldownJson = GeneratedColumn<String>(
    'cooldown_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _isRestMeta = const VerificationMeta('isRest');
  @override
  late final GeneratedColumn<bool> isRest = GeneratedColumn<bool>(
    'is_rest',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_rest" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    planId,
    weekday,
    orderIndex,
    name,
    focus,
    warmupJson,
    cooldownJson,
    isRest,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plan_days';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlanDay> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('plan_id')) {
      context.handle(
        _planIdMeta,
        planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta),
      );
    } else if (isInserting) {
      context.missing(_planIdMeta);
    }
    if (data.containsKey('weekday')) {
      context.handle(
        _weekdayMeta,
        weekday.isAcceptableOrUnknown(data['weekday']!, _weekdayMeta),
      );
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('focus')) {
      context.handle(
        _focusMeta,
        focus.isAcceptableOrUnknown(data['focus']!, _focusMeta),
      );
    }
    if (data.containsKey('warmup_json')) {
      context.handle(
        _warmupJsonMeta,
        warmupJson.isAcceptableOrUnknown(data['warmup_json']!, _warmupJsonMeta),
      );
    }
    if (data.containsKey('cooldown_json')) {
      context.handle(
        _cooldownJsonMeta,
        cooldownJson.isAcceptableOrUnknown(
          data['cooldown_json']!,
          _cooldownJsonMeta,
        ),
      );
    }
    if (data.containsKey('is_rest')) {
      context.handle(
        _isRestMeta,
        isRest.isAcceptableOrUnknown(data['is_rest']!, _isRestMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlanDay map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlanDay(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      planId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}plan_id'],
      )!,
      weekday: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekday'],
      ),
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      focus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}focus'],
      ),
      warmupJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}warmup_json'],
      )!,
      cooldownJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cooldown_json'],
      )!,
      isRest: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_rest'],
      )!,
    );
  }

  @override
  $PlanDaysTable createAlias(String alias) {
    return $PlanDaysTable(attachedDatabase, alias);
  }
}

class PlanDay extends DataClass implements Insertable<PlanDay> {
  final int id;
  final int planId;
  final int? weekday;
  final int orderIndex;
  final String name;
  final String? focus;
  final String warmupJson;
  final String cooldownJson;
  final bool isRest;
  const PlanDay({
    required this.id,
    required this.planId,
    this.weekday,
    required this.orderIndex,
    required this.name,
    this.focus,
    required this.warmupJson,
    required this.cooldownJson,
    required this.isRest,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['plan_id'] = Variable<int>(planId);
    if (!nullToAbsent || weekday != null) {
      map['weekday'] = Variable<int>(weekday);
    }
    map['order_index'] = Variable<int>(orderIndex);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || focus != null) {
      map['focus'] = Variable<String>(focus);
    }
    map['warmup_json'] = Variable<String>(warmupJson);
    map['cooldown_json'] = Variable<String>(cooldownJson);
    map['is_rest'] = Variable<bool>(isRest);
    return map;
  }

  PlanDaysCompanion toCompanion(bool nullToAbsent) {
    return PlanDaysCompanion(
      id: Value(id),
      planId: Value(planId),
      weekday: weekday == null && nullToAbsent
          ? const Value.absent()
          : Value(weekday),
      orderIndex: Value(orderIndex),
      name: Value(name),
      focus: focus == null && nullToAbsent
          ? const Value.absent()
          : Value(focus),
      warmupJson: Value(warmupJson),
      cooldownJson: Value(cooldownJson),
      isRest: Value(isRest),
    );
  }

  factory PlanDay.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlanDay(
      id: serializer.fromJson<int>(json['id']),
      planId: serializer.fromJson<int>(json['planId']),
      weekday: serializer.fromJson<int?>(json['weekday']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      name: serializer.fromJson<String>(json['name']),
      focus: serializer.fromJson<String?>(json['focus']),
      warmupJson: serializer.fromJson<String>(json['warmupJson']),
      cooldownJson: serializer.fromJson<String>(json['cooldownJson']),
      isRest: serializer.fromJson<bool>(json['isRest']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'planId': serializer.toJson<int>(planId),
      'weekday': serializer.toJson<int?>(weekday),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'name': serializer.toJson<String>(name),
      'focus': serializer.toJson<String?>(focus),
      'warmupJson': serializer.toJson<String>(warmupJson),
      'cooldownJson': serializer.toJson<String>(cooldownJson),
      'isRest': serializer.toJson<bool>(isRest),
    };
  }

  PlanDay copyWith({
    int? id,
    int? planId,
    Value<int?> weekday = const Value.absent(),
    int? orderIndex,
    String? name,
    Value<String?> focus = const Value.absent(),
    String? warmupJson,
    String? cooldownJson,
    bool? isRest,
  }) => PlanDay(
    id: id ?? this.id,
    planId: planId ?? this.planId,
    weekday: weekday.present ? weekday.value : this.weekday,
    orderIndex: orderIndex ?? this.orderIndex,
    name: name ?? this.name,
    focus: focus.present ? focus.value : this.focus,
    warmupJson: warmupJson ?? this.warmupJson,
    cooldownJson: cooldownJson ?? this.cooldownJson,
    isRest: isRest ?? this.isRest,
  );
  PlanDay copyWithCompanion(PlanDaysCompanion data) {
    return PlanDay(
      id: data.id.present ? data.id.value : this.id,
      planId: data.planId.present ? data.planId.value : this.planId,
      weekday: data.weekday.present ? data.weekday.value : this.weekday,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      name: data.name.present ? data.name.value : this.name,
      focus: data.focus.present ? data.focus.value : this.focus,
      warmupJson: data.warmupJson.present
          ? data.warmupJson.value
          : this.warmupJson,
      cooldownJson: data.cooldownJson.present
          ? data.cooldownJson.value
          : this.cooldownJson,
      isRest: data.isRest.present ? data.isRest.value : this.isRest,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlanDay(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('weekday: $weekday, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('name: $name, ')
          ..write('focus: $focus, ')
          ..write('warmupJson: $warmupJson, ')
          ..write('cooldownJson: $cooldownJson, ')
          ..write('isRest: $isRest')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    planId,
    weekday,
    orderIndex,
    name,
    focus,
    warmupJson,
    cooldownJson,
    isRest,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlanDay &&
          other.id == this.id &&
          other.planId == this.planId &&
          other.weekday == this.weekday &&
          other.orderIndex == this.orderIndex &&
          other.name == this.name &&
          other.focus == this.focus &&
          other.warmupJson == this.warmupJson &&
          other.cooldownJson == this.cooldownJson &&
          other.isRest == this.isRest);
}

class PlanDaysCompanion extends UpdateCompanion<PlanDay> {
  final Value<int> id;
  final Value<int> planId;
  final Value<int?> weekday;
  final Value<int> orderIndex;
  final Value<String> name;
  final Value<String?> focus;
  final Value<String> warmupJson;
  final Value<String> cooldownJson;
  final Value<bool> isRest;
  const PlanDaysCompanion({
    this.id = const Value.absent(),
    this.planId = const Value.absent(),
    this.weekday = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.name = const Value.absent(),
    this.focus = const Value.absent(),
    this.warmupJson = const Value.absent(),
    this.cooldownJson = const Value.absent(),
    this.isRest = const Value.absent(),
  });
  PlanDaysCompanion.insert({
    this.id = const Value.absent(),
    required int planId,
    this.weekday = const Value.absent(),
    this.orderIndex = const Value.absent(),
    required String name,
    this.focus = const Value.absent(),
    this.warmupJson = const Value.absent(),
    this.cooldownJson = const Value.absent(),
    this.isRest = const Value.absent(),
  }) : planId = Value(planId),
       name = Value(name);
  static Insertable<PlanDay> custom({
    Expression<int>? id,
    Expression<int>? planId,
    Expression<int>? weekday,
    Expression<int>? orderIndex,
    Expression<String>? name,
    Expression<String>? focus,
    Expression<String>? warmupJson,
    Expression<String>? cooldownJson,
    Expression<bool>? isRest,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (planId != null) 'plan_id': planId,
      if (weekday != null) 'weekday': weekday,
      if (orderIndex != null) 'order_index': orderIndex,
      if (name != null) 'name': name,
      if (focus != null) 'focus': focus,
      if (warmupJson != null) 'warmup_json': warmupJson,
      if (cooldownJson != null) 'cooldown_json': cooldownJson,
      if (isRest != null) 'is_rest': isRest,
    });
  }

  PlanDaysCompanion copyWith({
    Value<int>? id,
    Value<int>? planId,
    Value<int?>? weekday,
    Value<int>? orderIndex,
    Value<String>? name,
    Value<String?>? focus,
    Value<String>? warmupJson,
    Value<String>? cooldownJson,
    Value<bool>? isRest,
  }) {
    return PlanDaysCompanion(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      weekday: weekday ?? this.weekday,
      orderIndex: orderIndex ?? this.orderIndex,
      name: name ?? this.name,
      focus: focus ?? this.focus,
      warmupJson: warmupJson ?? this.warmupJson,
      cooldownJson: cooldownJson ?? this.cooldownJson,
      isRest: isRest ?? this.isRest,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<int>(planId.value);
    }
    if (weekday.present) {
      map['weekday'] = Variable<int>(weekday.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (focus.present) {
      map['focus'] = Variable<String>(focus.value);
    }
    if (warmupJson.present) {
      map['warmup_json'] = Variable<String>(warmupJson.value);
    }
    if (cooldownJson.present) {
      map['cooldown_json'] = Variable<String>(cooldownJson.value);
    }
    if (isRest.present) {
      map['is_rest'] = Variable<bool>(isRest.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlanDaysCompanion(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('weekday: $weekday, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('name: $name, ')
          ..write('focus: $focus, ')
          ..write('warmupJson: $warmupJson, ')
          ..write('cooldownJson: $cooldownJson, ')
          ..write('isRest: $isRest')
          ..write(')'))
        .toString();
  }
}

class $PlanExercisesTable extends PlanExercises
    with TableInfo<$PlanExercisesTable, PlanExercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlanExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _planDayIdMeta = const VerificationMeta(
    'planDayId',
  );
  @override
  late final GeneratedColumn<int> planDayId = GeneratedColumn<int>(
    'plan_day_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES plan_days (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercises (id)',
    ),
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _setsMeta = const VerificationMeta('sets');
  @override
  late final GeneratedColumn<int> sets = GeneratedColumn<int>(
    'sets',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _repMinMeta = const VerificationMeta('repMin');
  @override
  late final GeneratedColumn<int> repMin = GeneratedColumn<int>(
    'rep_min',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(8),
  );
  static const VerificationMeta _repMaxMeta = const VerificationMeta('repMax');
  @override
  late final GeneratedColumn<int> repMax = GeneratedColumn<int>(
    'rep_max',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(12),
  );
  static const VerificationMeta _suggestedWeightKgMeta = const VerificationMeta(
    'suggestedWeightKg',
  );
  @override
  late final GeneratedColumn<double> suggestedWeightKg =
      GeneratedColumn<double>(
        'suggested_weight_kg',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _targetRpeMeta = const VerificationMeta(
    'targetRpe',
  );
  @override
  late final GeneratedColumn<double> targetRpe = GeneratedColumn<double>(
    'target_rpe',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _restSecondsMeta = const VerificationMeta(
    'restSeconds',
  );
  @override
  late final GeneratedColumn<int> restSeconds = GeneratedColumn<int>(
    'rest_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(90),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    planDayId,
    exerciseId,
    orderIndex,
    sets,
    repMin,
    repMax,
    suggestedWeightKg,
    targetRpe,
    restSeconds,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plan_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlanExercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('plan_day_id')) {
      context.handle(
        _planDayIdMeta,
        planDayId.isAcceptableOrUnknown(data['plan_day_id']!, _planDayIdMeta),
      );
    } else if (isInserting) {
      context.missing(_planDayIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    }
    if (data.containsKey('sets')) {
      context.handle(
        _setsMeta,
        sets.isAcceptableOrUnknown(data['sets']!, _setsMeta),
      );
    }
    if (data.containsKey('rep_min')) {
      context.handle(
        _repMinMeta,
        repMin.isAcceptableOrUnknown(data['rep_min']!, _repMinMeta),
      );
    }
    if (data.containsKey('rep_max')) {
      context.handle(
        _repMaxMeta,
        repMax.isAcceptableOrUnknown(data['rep_max']!, _repMaxMeta),
      );
    }
    if (data.containsKey('suggested_weight_kg')) {
      context.handle(
        _suggestedWeightKgMeta,
        suggestedWeightKg.isAcceptableOrUnknown(
          data['suggested_weight_kg']!,
          _suggestedWeightKgMeta,
        ),
      );
    }
    if (data.containsKey('target_rpe')) {
      context.handle(
        _targetRpeMeta,
        targetRpe.isAcceptableOrUnknown(data['target_rpe']!, _targetRpeMeta),
      );
    }
    if (data.containsKey('rest_seconds')) {
      context.handle(
        _restSecondsMeta,
        restSeconds.isAcceptableOrUnknown(
          data['rest_seconds']!,
          _restSecondsMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlanExercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlanExercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      planDayId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}plan_day_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      sets: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sets'],
      )!,
      repMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rep_min'],
      )!,
      repMax: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rep_max'],
      )!,
      suggestedWeightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}suggested_weight_kg'],
      ),
      targetRpe: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_rpe'],
      ),
      restSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest_seconds'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $PlanExercisesTable createAlias(String alias) {
    return $PlanExercisesTable(attachedDatabase, alias);
  }
}

class PlanExercise extends DataClass implements Insertable<PlanExercise> {
  final int id;
  final int planDayId;
  final String exerciseId;
  final int orderIndex;
  final int sets;
  final int repMin;
  final int repMax;
  final double? suggestedWeightKg;
  final double? targetRpe;
  final int restSeconds;
  final String? notes;
  const PlanExercise({
    required this.id,
    required this.planDayId,
    required this.exerciseId,
    required this.orderIndex,
    required this.sets,
    required this.repMin,
    required this.repMax,
    this.suggestedWeightKg,
    this.targetRpe,
    required this.restSeconds,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['plan_day_id'] = Variable<int>(planDayId);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['order_index'] = Variable<int>(orderIndex);
    map['sets'] = Variable<int>(sets);
    map['rep_min'] = Variable<int>(repMin);
    map['rep_max'] = Variable<int>(repMax);
    if (!nullToAbsent || suggestedWeightKg != null) {
      map['suggested_weight_kg'] = Variable<double>(suggestedWeightKg);
    }
    if (!nullToAbsent || targetRpe != null) {
      map['target_rpe'] = Variable<double>(targetRpe);
    }
    map['rest_seconds'] = Variable<int>(restSeconds);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  PlanExercisesCompanion toCompanion(bool nullToAbsent) {
    return PlanExercisesCompanion(
      id: Value(id),
      planDayId: Value(planDayId),
      exerciseId: Value(exerciseId),
      orderIndex: Value(orderIndex),
      sets: Value(sets),
      repMin: Value(repMin),
      repMax: Value(repMax),
      suggestedWeightKg: suggestedWeightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(suggestedWeightKg),
      targetRpe: targetRpe == null && nullToAbsent
          ? const Value.absent()
          : Value(targetRpe),
      restSeconds: Value(restSeconds),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory PlanExercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlanExercise(
      id: serializer.fromJson<int>(json['id']),
      planDayId: serializer.fromJson<int>(json['planDayId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      sets: serializer.fromJson<int>(json['sets']),
      repMin: serializer.fromJson<int>(json['repMin']),
      repMax: serializer.fromJson<int>(json['repMax']),
      suggestedWeightKg: serializer.fromJson<double?>(
        json['suggestedWeightKg'],
      ),
      targetRpe: serializer.fromJson<double?>(json['targetRpe']),
      restSeconds: serializer.fromJson<int>(json['restSeconds']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'planDayId': serializer.toJson<int>(planDayId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'sets': serializer.toJson<int>(sets),
      'repMin': serializer.toJson<int>(repMin),
      'repMax': serializer.toJson<int>(repMax),
      'suggestedWeightKg': serializer.toJson<double?>(suggestedWeightKg),
      'targetRpe': serializer.toJson<double?>(targetRpe),
      'restSeconds': serializer.toJson<int>(restSeconds),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  PlanExercise copyWith({
    int? id,
    int? planDayId,
    String? exerciseId,
    int? orderIndex,
    int? sets,
    int? repMin,
    int? repMax,
    Value<double?> suggestedWeightKg = const Value.absent(),
    Value<double?> targetRpe = const Value.absent(),
    int? restSeconds,
    Value<String?> notes = const Value.absent(),
  }) => PlanExercise(
    id: id ?? this.id,
    planDayId: planDayId ?? this.planDayId,
    exerciseId: exerciseId ?? this.exerciseId,
    orderIndex: orderIndex ?? this.orderIndex,
    sets: sets ?? this.sets,
    repMin: repMin ?? this.repMin,
    repMax: repMax ?? this.repMax,
    suggestedWeightKg: suggestedWeightKg.present
        ? suggestedWeightKg.value
        : this.suggestedWeightKg,
    targetRpe: targetRpe.present ? targetRpe.value : this.targetRpe,
    restSeconds: restSeconds ?? this.restSeconds,
    notes: notes.present ? notes.value : this.notes,
  );
  PlanExercise copyWithCompanion(PlanExercisesCompanion data) {
    return PlanExercise(
      id: data.id.present ? data.id.value : this.id,
      planDayId: data.planDayId.present ? data.planDayId.value : this.planDayId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      sets: data.sets.present ? data.sets.value : this.sets,
      repMin: data.repMin.present ? data.repMin.value : this.repMin,
      repMax: data.repMax.present ? data.repMax.value : this.repMax,
      suggestedWeightKg: data.suggestedWeightKg.present
          ? data.suggestedWeightKg.value
          : this.suggestedWeightKg,
      targetRpe: data.targetRpe.present ? data.targetRpe.value : this.targetRpe,
      restSeconds: data.restSeconds.present
          ? data.restSeconds.value
          : this.restSeconds,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlanExercise(')
          ..write('id: $id, ')
          ..write('planDayId: $planDayId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('sets: $sets, ')
          ..write('repMin: $repMin, ')
          ..write('repMax: $repMax, ')
          ..write('suggestedWeightKg: $suggestedWeightKg, ')
          ..write('targetRpe: $targetRpe, ')
          ..write('restSeconds: $restSeconds, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    planDayId,
    exerciseId,
    orderIndex,
    sets,
    repMin,
    repMax,
    suggestedWeightKg,
    targetRpe,
    restSeconds,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlanExercise &&
          other.id == this.id &&
          other.planDayId == this.planDayId &&
          other.exerciseId == this.exerciseId &&
          other.orderIndex == this.orderIndex &&
          other.sets == this.sets &&
          other.repMin == this.repMin &&
          other.repMax == this.repMax &&
          other.suggestedWeightKg == this.suggestedWeightKg &&
          other.targetRpe == this.targetRpe &&
          other.restSeconds == this.restSeconds &&
          other.notes == this.notes);
}

class PlanExercisesCompanion extends UpdateCompanion<PlanExercise> {
  final Value<int> id;
  final Value<int> planDayId;
  final Value<String> exerciseId;
  final Value<int> orderIndex;
  final Value<int> sets;
  final Value<int> repMin;
  final Value<int> repMax;
  final Value<double?> suggestedWeightKg;
  final Value<double?> targetRpe;
  final Value<int> restSeconds;
  final Value<String?> notes;
  const PlanExercisesCompanion({
    this.id = const Value.absent(),
    this.planDayId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.sets = const Value.absent(),
    this.repMin = const Value.absent(),
    this.repMax = const Value.absent(),
    this.suggestedWeightKg = const Value.absent(),
    this.targetRpe = const Value.absent(),
    this.restSeconds = const Value.absent(),
    this.notes = const Value.absent(),
  });
  PlanExercisesCompanion.insert({
    this.id = const Value.absent(),
    required int planDayId,
    required String exerciseId,
    this.orderIndex = const Value.absent(),
    this.sets = const Value.absent(),
    this.repMin = const Value.absent(),
    this.repMax = const Value.absent(),
    this.suggestedWeightKg = const Value.absent(),
    this.targetRpe = const Value.absent(),
    this.restSeconds = const Value.absent(),
    this.notes = const Value.absent(),
  }) : planDayId = Value(planDayId),
       exerciseId = Value(exerciseId);
  static Insertable<PlanExercise> custom({
    Expression<int>? id,
    Expression<int>? planDayId,
    Expression<String>? exerciseId,
    Expression<int>? orderIndex,
    Expression<int>? sets,
    Expression<int>? repMin,
    Expression<int>? repMax,
    Expression<double>? suggestedWeightKg,
    Expression<double>? targetRpe,
    Expression<int>? restSeconds,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (planDayId != null) 'plan_day_id': planDayId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (orderIndex != null) 'order_index': orderIndex,
      if (sets != null) 'sets': sets,
      if (repMin != null) 'rep_min': repMin,
      if (repMax != null) 'rep_max': repMax,
      if (suggestedWeightKg != null) 'suggested_weight_kg': suggestedWeightKg,
      if (targetRpe != null) 'target_rpe': targetRpe,
      if (restSeconds != null) 'rest_seconds': restSeconds,
      if (notes != null) 'notes': notes,
    });
  }

  PlanExercisesCompanion copyWith({
    Value<int>? id,
    Value<int>? planDayId,
    Value<String>? exerciseId,
    Value<int>? orderIndex,
    Value<int>? sets,
    Value<int>? repMin,
    Value<int>? repMax,
    Value<double?>? suggestedWeightKg,
    Value<double?>? targetRpe,
    Value<int>? restSeconds,
    Value<String?>? notes,
  }) {
    return PlanExercisesCompanion(
      id: id ?? this.id,
      planDayId: planDayId ?? this.planDayId,
      exerciseId: exerciseId ?? this.exerciseId,
      orderIndex: orderIndex ?? this.orderIndex,
      sets: sets ?? this.sets,
      repMin: repMin ?? this.repMin,
      repMax: repMax ?? this.repMax,
      suggestedWeightKg: suggestedWeightKg ?? this.suggestedWeightKg,
      targetRpe: targetRpe ?? this.targetRpe,
      restSeconds: restSeconds ?? this.restSeconds,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (planDayId.present) {
      map['plan_day_id'] = Variable<int>(planDayId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (sets.present) {
      map['sets'] = Variable<int>(sets.value);
    }
    if (repMin.present) {
      map['rep_min'] = Variable<int>(repMin.value);
    }
    if (repMax.present) {
      map['rep_max'] = Variable<int>(repMax.value);
    }
    if (suggestedWeightKg.present) {
      map['suggested_weight_kg'] = Variable<double>(suggestedWeightKg.value);
    }
    if (targetRpe.present) {
      map['target_rpe'] = Variable<double>(targetRpe.value);
    }
    if (restSeconds.present) {
      map['rest_seconds'] = Variable<int>(restSeconds.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlanExercisesCompanion(')
          ..write('id: $id, ')
          ..write('planDayId: $planDayId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('sets: $sets, ')
          ..write('repMin: $repMin, ')
          ..write('repMax: $repMax, ')
          ..write('suggestedWeightKg: $suggestedWeightKg, ')
          ..write('targetRpe: $targetRpe, ')
          ..write('restSeconds: $restSeconds, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSessionsTable extends WorkoutSessions
    with TableInfo<$WorkoutSessionsTable, WorkoutSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _planDayIdMeta = const VerificationMeta(
    'planDayId',
  );
  @override
  late final GeneratedColumn<int> planDayId = GeneratedColumn<int>(
    'plan_day_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES plan_days (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('in_progress'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalVolumeMeta = const VerificationMeta(
    'totalVolume',
  );
  @override
  late final GeneratedColumn<double> totalVolume = GeneratedColumn<double>(
    'total_volume',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _aiSummaryMeta = const VerificationMeta(
    'aiSummary',
  );
  @override
  late final GeneratedColumn<String> aiSummary = GeneratedColumn<String>(
    'ai_summary',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDeloadMeta = const VerificationMeta(
    'isDeload',
  );
  @override
  late final GeneratedColumn<bool> isDeload = GeneratedColumn<bool>(
    'is_deload',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deload" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    planDayId,
    name,
    startedAt,
    endedAt,
    status,
    notes,
    totalVolume,
    aiSummary,
    isDeload,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('plan_day_id')) {
      context.handle(
        _planDayIdMeta,
        planDayId.isAcceptableOrUnknown(data['plan_day_id']!, _planDayIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('total_volume')) {
      context.handle(
        _totalVolumeMeta,
        totalVolume.isAcceptableOrUnknown(
          data['total_volume']!,
          _totalVolumeMeta,
        ),
      );
    }
    if (data.containsKey('ai_summary')) {
      context.handle(
        _aiSummaryMeta,
        aiSummary.isAcceptableOrUnknown(data['ai_summary']!, _aiSummaryMeta),
      );
    }
    if (data.containsKey('is_deload')) {
      context.handle(
        _isDeloadMeta,
        isDeload.isAcceptableOrUnknown(data['is_deload']!, _isDeloadMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      planDayId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}plan_day_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      ),
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      totalVolume: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_volume'],
      ),
      aiSummary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ai_summary'],
      ),
      isDeload: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deload'],
      )!,
    );
  }

  @override
  $WorkoutSessionsTable createAlias(String alias) {
    return $WorkoutSessionsTable(attachedDatabase, alias);
  }
}

class WorkoutSession extends DataClass implements Insertable<WorkoutSession> {
  final int id;
  final DateTime date;
  final int? planDayId;
  final String? name;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final String status;
  final String? notes;
  final double? totalVolume;
  final String? aiSummary;
  final bool isDeload;
  const WorkoutSession({
    required this.id,
    required this.date,
    this.planDayId,
    this.name,
    this.startedAt,
    this.endedAt,
    required this.status,
    this.notes,
    this.totalVolume,
    this.aiSummary,
    required this.isDeload,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || planDayId != null) {
      map['plan_day_id'] = Variable<int>(planDayId);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<DateTime>(startedAt);
    }
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || totalVolume != null) {
      map['total_volume'] = Variable<double>(totalVolume);
    }
    if (!nullToAbsent || aiSummary != null) {
      map['ai_summary'] = Variable<String>(aiSummary);
    }
    map['is_deload'] = Variable<bool>(isDeload);
    return map;
  }

  WorkoutSessionsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSessionsCompanion(
      id: Value(id),
      date: Value(date),
      planDayId: planDayId == null && nullToAbsent
          ? const Value.absent()
          : Value(planDayId),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      status: Value(status),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      totalVolume: totalVolume == null && nullToAbsent
          ? const Value.absent()
          : Value(totalVolume),
      aiSummary: aiSummary == null && nullToAbsent
          ? const Value.absent()
          : Value(aiSummary),
      isDeload: Value(isDeload),
    );
  }

  factory WorkoutSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSession(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      planDayId: serializer.fromJson<int?>(json['planDayId']),
      name: serializer.fromJson<String?>(json['name']),
      startedAt: serializer.fromJson<DateTime?>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
      totalVolume: serializer.fromJson<double?>(json['totalVolume']),
      aiSummary: serializer.fromJson<String?>(json['aiSummary']),
      isDeload: serializer.fromJson<bool>(json['isDeload']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'planDayId': serializer.toJson<int?>(planDayId),
      'name': serializer.toJson<String?>(name),
      'startedAt': serializer.toJson<DateTime?>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String?>(notes),
      'totalVolume': serializer.toJson<double?>(totalVolume),
      'aiSummary': serializer.toJson<String?>(aiSummary),
      'isDeload': serializer.toJson<bool>(isDeload),
    };
  }

  WorkoutSession copyWith({
    int? id,
    DateTime? date,
    Value<int?> planDayId = const Value.absent(),
    Value<String?> name = const Value.absent(),
    Value<DateTime?> startedAt = const Value.absent(),
    Value<DateTime?> endedAt = const Value.absent(),
    String? status,
    Value<String?> notes = const Value.absent(),
    Value<double?> totalVolume = const Value.absent(),
    Value<String?> aiSummary = const Value.absent(),
    bool? isDeload,
  }) => WorkoutSession(
    id: id ?? this.id,
    date: date ?? this.date,
    planDayId: planDayId.present ? planDayId.value : this.planDayId,
    name: name.present ? name.value : this.name,
    startedAt: startedAt.present ? startedAt.value : this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    status: status ?? this.status,
    notes: notes.present ? notes.value : this.notes,
    totalVolume: totalVolume.present ? totalVolume.value : this.totalVolume,
    aiSummary: aiSummary.present ? aiSummary.value : this.aiSummary,
    isDeload: isDeload ?? this.isDeload,
  );
  WorkoutSession copyWithCompanion(WorkoutSessionsCompanion data) {
    return WorkoutSession(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      planDayId: data.planDayId.present ? data.planDayId.value : this.planDayId,
      name: data.name.present ? data.name.value : this.name,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      totalVolume: data.totalVolume.present
          ? data.totalVolume.value
          : this.totalVolume,
      aiSummary: data.aiSummary.present ? data.aiSummary.value : this.aiSummary,
      isDeload: data.isDeload.present ? data.isDeload.value : this.isDeload,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSession(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('planDayId: $planDayId, ')
          ..write('name: $name, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('totalVolume: $totalVolume, ')
          ..write('aiSummary: $aiSummary, ')
          ..write('isDeload: $isDeload')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    planDayId,
    name,
    startedAt,
    endedAt,
    status,
    notes,
    totalVolume,
    aiSummary,
    isDeload,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSession &&
          other.id == this.id &&
          other.date == this.date &&
          other.planDayId == this.planDayId &&
          other.name == this.name &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.totalVolume == this.totalVolume &&
          other.aiSummary == this.aiSummary &&
          other.isDeload == this.isDeload);
}

class WorkoutSessionsCompanion extends UpdateCompanion<WorkoutSession> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<int?> planDayId;
  final Value<String?> name;
  final Value<DateTime?> startedAt;
  final Value<DateTime?> endedAt;
  final Value<String> status;
  final Value<String?> notes;
  final Value<double?> totalVolume;
  final Value<String?> aiSummary;
  final Value<bool> isDeload;
  const WorkoutSessionsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.planDayId = const Value.absent(),
    this.name = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.totalVolume = const Value.absent(),
    this.aiSummary = const Value.absent(),
    this.isDeload = const Value.absent(),
  });
  WorkoutSessionsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    this.planDayId = const Value.absent(),
    this.name = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.totalVolume = const Value.absent(),
    this.aiSummary = const Value.absent(),
    this.isDeload = const Value.absent(),
  }) : date = Value(date);
  static Insertable<WorkoutSession> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<int>? planDayId,
    Expression<String>? name,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<double>? totalVolume,
    Expression<String>? aiSummary,
    Expression<bool>? isDeload,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (planDayId != null) 'plan_day_id': planDayId,
      if (name != null) 'name': name,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (totalVolume != null) 'total_volume': totalVolume,
      if (aiSummary != null) 'ai_summary': aiSummary,
      if (isDeload != null) 'is_deload': isDeload,
    });
  }

  WorkoutSessionsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<int?>? planDayId,
    Value<String?>? name,
    Value<DateTime?>? startedAt,
    Value<DateTime?>? endedAt,
    Value<String>? status,
    Value<String?>? notes,
    Value<double?>? totalVolume,
    Value<String?>? aiSummary,
    Value<bool>? isDeload,
  }) {
    return WorkoutSessionsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      planDayId: planDayId ?? this.planDayId,
      name: name ?? this.name,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      totalVolume: totalVolume ?? this.totalVolume,
      aiSummary: aiSummary ?? this.aiSummary,
      isDeload: isDeload ?? this.isDeload,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (planDayId.present) {
      map['plan_day_id'] = Variable<int>(planDayId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (totalVolume.present) {
      map['total_volume'] = Variable<double>(totalVolume.value);
    }
    if (aiSummary.present) {
      map['ai_summary'] = Variable<String>(aiSummary.value);
    }
    if (isDeload.present) {
      map['is_deload'] = Variable<bool>(isDeload.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSessionsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('planDayId: $planDayId, ')
          ..write('name: $name, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('totalVolume: $totalVolume, ')
          ..write('aiSummary: $aiSummary, ')
          ..write('isDeload: $isDeload')
          ..write(')'))
        .toString();
  }
}

class $SetLogsTable extends SetLogs with TableInfo<$SetLogsTable, SetLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SetLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_sessions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercises (id)',
    ),
  );
  static const VerificationMeta _setIndexMeta = const VerificationMeta(
    'setIndex',
  );
  @override
  late final GeneratedColumn<int> setIndex = GeneratedColumn<int>(
    'set_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rpeMeta = const VerificationMeta('rpe');
  @override
  late final GeneratedColumn<double> rpe = GeneratedColumn<double>(
    'rpe',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _setTypeMeta = const VerificationMeta(
    'setType',
  );
  @override
  late final GeneratedColumn<String> setType = GeneratedColumn<String>(
    'set_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('normal'),
  );
  static const VerificationMeta _isPrMeta = const VerificationMeta('isPr');
  @override
  late final GeneratedColumn<bool> isPr = GeneratedColumn<bool>(
    'is_pr',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_pr" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _prTypesMeta = const VerificationMeta(
    'prTypes',
  );
  @override
  late final GeneratedColumn<String> prTypes = GeneratedColumn<String>(
    'pr_types',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    exerciseId,
    setIndex,
    weightKg,
    reps,
    rpe,
    setType,
    isPr,
    prTypes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'set_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<SetLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('set_index')) {
      context.handle(
        _setIndexMeta,
        setIndex.isAcceptableOrUnknown(data['set_index']!, _setIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_setIndexMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    } else if (isInserting) {
      context.missing(_repsMeta);
    }
    if (data.containsKey('rpe')) {
      context.handle(
        _rpeMeta,
        rpe.isAcceptableOrUnknown(data['rpe']!, _rpeMeta),
      );
    }
    if (data.containsKey('set_type')) {
      context.handle(
        _setTypeMeta,
        setType.isAcceptableOrUnknown(data['set_type']!, _setTypeMeta),
      );
    }
    if (data.containsKey('is_pr')) {
      context.handle(
        _isPrMeta,
        isPr.isAcceptableOrUnknown(data['is_pr']!, _isPrMeta),
      );
    }
    if (data.containsKey('pr_types')) {
      context.handle(
        _prTypesMeta,
        prTypes.isAcceptableOrUnknown(data['pr_types']!, _prTypesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SetLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SetLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      setIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}set_index'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      )!,
      rpe: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rpe'],
      ),
      setType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}set_type'],
      )!,
      isPr: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_pr'],
      )!,
      prTypes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pr_types'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SetLogsTable createAlias(String alias) {
    return $SetLogsTable(attachedDatabase, alias);
  }
}

class SetLog extends DataClass implements Insertable<SetLog> {
  final int id;
  final int sessionId;
  final String exerciseId;
  final int setIndex;
  final double weightKg;
  final int reps;
  final double? rpe;
  final String setType;
  final bool isPr;
  final String? prTypes;
  final DateTime createdAt;
  const SetLog({
    required this.id,
    required this.sessionId,
    required this.exerciseId,
    required this.setIndex,
    required this.weightKg,
    required this.reps,
    this.rpe,
    required this.setType,
    required this.isPr,
    this.prTypes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['set_index'] = Variable<int>(setIndex);
    map['weight_kg'] = Variable<double>(weightKg);
    map['reps'] = Variable<int>(reps);
    if (!nullToAbsent || rpe != null) {
      map['rpe'] = Variable<double>(rpe);
    }
    map['set_type'] = Variable<String>(setType);
    map['is_pr'] = Variable<bool>(isPr);
    if (!nullToAbsent || prTypes != null) {
      map['pr_types'] = Variable<String>(prTypes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SetLogsCompanion toCompanion(bool nullToAbsent) {
    return SetLogsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      exerciseId: Value(exerciseId),
      setIndex: Value(setIndex),
      weightKg: Value(weightKg),
      reps: Value(reps),
      rpe: rpe == null && nullToAbsent ? const Value.absent() : Value(rpe),
      setType: Value(setType),
      isPr: Value(isPr),
      prTypes: prTypes == null && nullToAbsent
          ? const Value.absent()
          : Value(prTypes),
      createdAt: Value(createdAt),
    );
  }

  factory SetLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SetLog(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      setIndex: serializer.fromJson<int>(json['setIndex']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      reps: serializer.fromJson<int>(json['reps']),
      rpe: serializer.fromJson<double?>(json['rpe']),
      setType: serializer.fromJson<String>(json['setType']),
      isPr: serializer.fromJson<bool>(json['isPr']),
      prTypes: serializer.fromJson<String?>(json['prTypes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'setIndex': serializer.toJson<int>(setIndex),
      'weightKg': serializer.toJson<double>(weightKg),
      'reps': serializer.toJson<int>(reps),
      'rpe': serializer.toJson<double?>(rpe),
      'setType': serializer.toJson<String>(setType),
      'isPr': serializer.toJson<bool>(isPr),
      'prTypes': serializer.toJson<String?>(prTypes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SetLog copyWith({
    int? id,
    int? sessionId,
    String? exerciseId,
    int? setIndex,
    double? weightKg,
    int? reps,
    Value<double?> rpe = const Value.absent(),
    String? setType,
    bool? isPr,
    Value<String?> prTypes = const Value.absent(),
    DateTime? createdAt,
  }) => SetLog(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    exerciseId: exerciseId ?? this.exerciseId,
    setIndex: setIndex ?? this.setIndex,
    weightKg: weightKg ?? this.weightKg,
    reps: reps ?? this.reps,
    rpe: rpe.present ? rpe.value : this.rpe,
    setType: setType ?? this.setType,
    isPr: isPr ?? this.isPr,
    prTypes: prTypes.present ? prTypes.value : this.prTypes,
    createdAt: createdAt ?? this.createdAt,
  );
  SetLog copyWithCompanion(SetLogsCompanion data) {
    return SetLog(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      setIndex: data.setIndex.present ? data.setIndex.value : this.setIndex,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      reps: data.reps.present ? data.reps.value : this.reps,
      rpe: data.rpe.present ? data.rpe.value : this.rpe,
      setType: data.setType.present ? data.setType.value : this.setType,
      isPr: data.isPr.present ? data.isPr.value : this.isPr,
      prTypes: data.prTypes.present ? data.prTypes.value : this.prTypes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SetLog(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('setIndex: $setIndex, ')
          ..write('weightKg: $weightKg, ')
          ..write('reps: $reps, ')
          ..write('rpe: $rpe, ')
          ..write('setType: $setType, ')
          ..write('isPr: $isPr, ')
          ..write('prTypes: $prTypes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    exerciseId,
    setIndex,
    weightKg,
    reps,
    rpe,
    setType,
    isPr,
    prTypes,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SetLog &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.exerciseId == this.exerciseId &&
          other.setIndex == this.setIndex &&
          other.weightKg == this.weightKg &&
          other.reps == this.reps &&
          other.rpe == this.rpe &&
          other.setType == this.setType &&
          other.isPr == this.isPr &&
          other.prTypes == this.prTypes &&
          other.createdAt == this.createdAt);
}

class SetLogsCompanion extends UpdateCompanion<SetLog> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<String> exerciseId;
  final Value<int> setIndex;
  final Value<double> weightKg;
  final Value<int> reps;
  final Value<double?> rpe;
  final Value<String> setType;
  final Value<bool> isPr;
  final Value<String?> prTypes;
  final Value<DateTime> createdAt;
  const SetLogsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.setIndex = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.reps = const Value.absent(),
    this.rpe = const Value.absent(),
    this.setType = const Value.absent(),
    this.isPr = const Value.absent(),
    this.prTypes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SetLogsCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required String exerciseId,
    required int setIndex,
    required double weightKg,
    required int reps,
    this.rpe = const Value.absent(),
    this.setType = const Value.absent(),
    this.isPr = const Value.absent(),
    this.prTypes = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : sessionId = Value(sessionId),
       exerciseId = Value(exerciseId),
       setIndex = Value(setIndex),
       weightKg = Value(weightKg),
       reps = Value(reps);
  static Insertable<SetLog> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<String>? exerciseId,
    Expression<int>? setIndex,
    Expression<double>? weightKg,
    Expression<int>? reps,
    Expression<double>? rpe,
    Expression<String>? setType,
    Expression<bool>? isPr,
    Expression<String>? prTypes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (setIndex != null) 'set_index': setIndex,
      if (weightKg != null) 'weight_kg': weightKg,
      if (reps != null) 'reps': reps,
      if (rpe != null) 'rpe': rpe,
      if (setType != null) 'set_type': setType,
      if (isPr != null) 'is_pr': isPr,
      if (prTypes != null) 'pr_types': prTypes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SetLogsCompanion copyWith({
    Value<int>? id,
    Value<int>? sessionId,
    Value<String>? exerciseId,
    Value<int>? setIndex,
    Value<double>? weightKg,
    Value<int>? reps,
    Value<double?>? rpe,
    Value<String>? setType,
    Value<bool>? isPr,
    Value<String?>? prTypes,
    Value<DateTime>? createdAt,
  }) {
    return SetLogsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      exerciseId: exerciseId ?? this.exerciseId,
      setIndex: setIndex ?? this.setIndex,
      weightKg: weightKg ?? this.weightKg,
      reps: reps ?? this.reps,
      rpe: rpe ?? this.rpe,
      setType: setType ?? this.setType,
      isPr: isPr ?? this.isPr,
      prTypes: prTypes ?? this.prTypes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (setIndex.present) {
      map['set_index'] = Variable<int>(setIndex.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (rpe.present) {
      map['rpe'] = Variable<double>(rpe.value);
    }
    if (setType.present) {
      map['set_type'] = Variable<String>(setType.value);
    }
    if (isPr.present) {
      map['is_pr'] = Variable<bool>(isPr.value);
    }
    if (prTypes.present) {
      map['pr_types'] = Variable<String>(prTypes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SetLogsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('setIndex: $setIndex, ')
          ..write('weightKg: $weightKg, ')
          ..write('reps: $reps, ')
          ..write('rpe: $rpe, ')
          ..write('setType: $setType, ')
          ..write('isPr: $isPr, ')
          ..write('prTypes: $prTypes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SessionExerciseNotesTable extends SessionExerciseNotes
    with TableInfo<$SessionExerciseNotesTable, SessionExerciseNote> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionExerciseNotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_sessions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, sessionId, exerciseId, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session_exercise_notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionExerciseNote> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    } else if (isInserting) {
      context.missing(_noteMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionExerciseNote map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionExerciseNote(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
    );
  }

  @override
  $SessionExerciseNotesTable createAlias(String alias) {
    return $SessionExerciseNotesTable(attachedDatabase, alias);
  }
}

class SessionExerciseNote extends DataClass
    implements Insertable<SessionExerciseNote> {
  final int id;
  final int sessionId;
  final String exerciseId;
  final String note;
  const SessionExerciseNote({
    required this.id,
    required this.sessionId,
    required this.exerciseId,
    required this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['note'] = Variable<String>(note);
    return map;
  }

  SessionExerciseNotesCompanion toCompanion(bool nullToAbsent) {
    return SessionExerciseNotesCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      exerciseId: Value(exerciseId),
      note: Value(note),
    );
  }

  factory SessionExerciseNote.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionExerciseNote(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      note: serializer.fromJson<String>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'note': serializer.toJson<String>(note),
    };
  }

  SessionExerciseNote copyWith({
    int? id,
    int? sessionId,
    String? exerciseId,
    String? note,
  }) => SessionExerciseNote(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    exerciseId: exerciseId ?? this.exerciseId,
    note: note ?? this.note,
  );
  SessionExerciseNote copyWithCompanion(SessionExerciseNotesCompanion data) {
    return SessionExerciseNote(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionExerciseNote(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sessionId, exerciseId, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionExerciseNote &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.exerciseId == this.exerciseId &&
          other.note == this.note);
}

class SessionExerciseNotesCompanion
    extends UpdateCompanion<SessionExerciseNote> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<String> exerciseId;
  final Value<String> note;
  const SessionExerciseNotesCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.note = const Value.absent(),
  });
  SessionExerciseNotesCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required String exerciseId,
    required String note,
  }) : sessionId = Value(sessionId),
       exerciseId = Value(exerciseId),
       note = Value(note);
  static Insertable<SessionExerciseNote> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<String>? exerciseId,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (note != null) 'note': note,
    });
  }

  SessionExerciseNotesCompanion copyWith({
    Value<int>? id,
    Value<int>? sessionId,
    Value<String>? exerciseId,
    Value<String>? note,
  }) {
    return SessionExerciseNotesCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      exerciseId: exerciseId ?? this.exerciseId,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionExerciseNotesCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $CardioLogsTable extends CardioLogs
    with TableInfo<$CardioLogsTable, CardioLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardioLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'session_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_sessions (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMinMeta = const VerificationMeta(
    'durationMin',
  );
  @override
  late final GeneratedColumn<double> durationMin = GeneratedColumn<double>(
    'duration_min',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _speedKmhMeta = const VerificationMeta(
    'speedKmh',
  );
  @override
  late final GeneratedColumn<double> speedKmh = GeneratedColumn<double>(
    'speed_kmh',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _inclinePctMeta = const VerificationMeta(
    'inclinePct',
  );
  @override
  late final GeneratedColumn<double> inclinePct = GeneratedColumn<double>(
    'incline_pct',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _caloriesMeta = const VerificationMeta(
    'calories',
  );
  @override
  late final GeneratedColumn<double> calories = GeneratedColumn<double>(
    'calories',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    date,
    type,
    durationMin,
    speedKmh,
    inclinePct,
    level,
    calories,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cardio_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<CardioLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('duration_min')) {
      context.handle(
        _durationMinMeta,
        durationMin.isAcceptableOrUnknown(
          data['duration_min']!,
          _durationMinMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationMinMeta);
    }
    if (data.containsKey('speed_kmh')) {
      context.handle(
        _speedKmhMeta,
        speedKmh.isAcceptableOrUnknown(data['speed_kmh']!, _speedKmhMeta),
      );
    }
    if (data.containsKey('incline_pct')) {
      context.handle(
        _inclinePctMeta,
        inclinePct.isAcceptableOrUnknown(data['incline_pct']!, _inclinePctMeta),
      );
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CardioLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardioLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_id'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      durationMin: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}duration_min'],
      )!,
      speedKmh: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}speed_kmh'],
      ),
      inclinePct: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}incline_pct'],
      ),
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level'],
      ),
      calories: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calories'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $CardioLogsTable createAlias(String alias) {
    return $CardioLogsTable(attachedDatabase, alias);
  }
}

class CardioLog extends DataClass implements Insertable<CardioLog> {
  final int id;
  final int? sessionId;
  final DateTime date;
  final String type;
  final double durationMin;
  final double? speedKmh;
  final double? inclinePct;
  final int? level;
  final double? calories;
  final String? notes;
  const CardioLog({
    required this.id,
    this.sessionId,
    required this.date,
    required this.type,
    required this.durationMin,
    this.speedKmh,
    this.inclinePct,
    this.level,
    this.calories,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || sessionId != null) {
      map['session_id'] = Variable<int>(sessionId);
    }
    map['date'] = Variable<DateTime>(date);
    map['type'] = Variable<String>(type);
    map['duration_min'] = Variable<double>(durationMin);
    if (!nullToAbsent || speedKmh != null) {
      map['speed_kmh'] = Variable<double>(speedKmh);
    }
    if (!nullToAbsent || inclinePct != null) {
      map['incline_pct'] = Variable<double>(inclinePct);
    }
    if (!nullToAbsent || level != null) {
      map['level'] = Variable<int>(level);
    }
    if (!nullToAbsent || calories != null) {
      map['calories'] = Variable<double>(calories);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  CardioLogsCompanion toCompanion(bool nullToAbsent) {
    return CardioLogsCompanion(
      id: Value(id),
      sessionId: sessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionId),
      date: Value(date),
      type: Value(type),
      durationMin: Value(durationMin),
      speedKmh: speedKmh == null && nullToAbsent
          ? const Value.absent()
          : Value(speedKmh),
      inclinePct: inclinePct == null && nullToAbsent
          ? const Value.absent()
          : Value(inclinePct),
      level: level == null && nullToAbsent
          ? const Value.absent()
          : Value(level),
      calories: calories == null && nullToAbsent
          ? const Value.absent()
          : Value(calories),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory CardioLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardioLog(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int?>(json['sessionId']),
      date: serializer.fromJson<DateTime>(json['date']),
      type: serializer.fromJson<String>(json['type']),
      durationMin: serializer.fromJson<double>(json['durationMin']),
      speedKmh: serializer.fromJson<double?>(json['speedKmh']),
      inclinePct: serializer.fromJson<double?>(json['inclinePct']),
      level: serializer.fromJson<int?>(json['level']),
      calories: serializer.fromJson<double?>(json['calories']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int?>(sessionId),
      'date': serializer.toJson<DateTime>(date),
      'type': serializer.toJson<String>(type),
      'durationMin': serializer.toJson<double>(durationMin),
      'speedKmh': serializer.toJson<double?>(speedKmh),
      'inclinePct': serializer.toJson<double?>(inclinePct),
      'level': serializer.toJson<int?>(level),
      'calories': serializer.toJson<double?>(calories),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  CardioLog copyWith({
    int? id,
    Value<int?> sessionId = const Value.absent(),
    DateTime? date,
    String? type,
    double? durationMin,
    Value<double?> speedKmh = const Value.absent(),
    Value<double?> inclinePct = const Value.absent(),
    Value<int?> level = const Value.absent(),
    Value<double?> calories = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => CardioLog(
    id: id ?? this.id,
    sessionId: sessionId.present ? sessionId.value : this.sessionId,
    date: date ?? this.date,
    type: type ?? this.type,
    durationMin: durationMin ?? this.durationMin,
    speedKmh: speedKmh.present ? speedKmh.value : this.speedKmh,
    inclinePct: inclinePct.present ? inclinePct.value : this.inclinePct,
    level: level.present ? level.value : this.level,
    calories: calories.present ? calories.value : this.calories,
    notes: notes.present ? notes.value : this.notes,
  );
  CardioLog copyWithCompanion(CardioLogsCompanion data) {
    return CardioLog(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      date: data.date.present ? data.date.value : this.date,
      type: data.type.present ? data.type.value : this.type,
      durationMin: data.durationMin.present
          ? data.durationMin.value
          : this.durationMin,
      speedKmh: data.speedKmh.present ? data.speedKmh.value : this.speedKmh,
      inclinePct: data.inclinePct.present
          ? data.inclinePct.value
          : this.inclinePct,
      level: data.level.present ? data.level.value : this.level,
      calories: data.calories.present ? data.calories.value : this.calories,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardioLog(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('durationMin: $durationMin, ')
          ..write('speedKmh: $speedKmh, ')
          ..write('inclinePct: $inclinePct, ')
          ..write('level: $level, ')
          ..write('calories: $calories, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    date,
    type,
    durationMin,
    speedKmh,
    inclinePct,
    level,
    calories,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardioLog &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.date == this.date &&
          other.type == this.type &&
          other.durationMin == this.durationMin &&
          other.speedKmh == this.speedKmh &&
          other.inclinePct == this.inclinePct &&
          other.level == this.level &&
          other.calories == this.calories &&
          other.notes == this.notes);
}

class CardioLogsCompanion extends UpdateCompanion<CardioLog> {
  final Value<int> id;
  final Value<int?> sessionId;
  final Value<DateTime> date;
  final Value<String> type;
  final Value<double> durationMin;
  final Value<double?> speedKmh;
  final Value<double?> inclinePct;
  final Value<int?> level;
  final Value<double?> calories;
  final Value<String?> notes;
  const CardioLogsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.date = const Value.absent(),
    this.type = const Value.absent(),
    this.durationMin = const Value.absent(),
    this.speedKmh = const Value.absent(),
    this.inclinePct = const Value.absent(),
    this.level = const Value.absent(),
    this.calories = const Value.absent(),
    this.notes = const Value.absent(),
  });
  CardioLogsCompanion.insert({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    required DateTime date,
    required String type,
    required double durationMin,
    this.speedKmh = const Value.absent(),
    this.inclinePct = const Value.absent(),
    this.level = const Value.absent(),
    this.calories = const Value.absent(),
    this.notes = const Value.absent(),
  }) : date = Value(date),
       type = Value(type),
       durationMin = Value(durationMin);
  static Insertable<CardioLog> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<DateTime>? date,
    Expression<String>? type,
    Expression<double>? durationMin,
    Expression<double>? speedKmh,
    Expression<double>? inclinePct,
    Expression<int>? level,
    Expression<double>? calories,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (date != null) 'date': date,
      if (type != null) 'type': type,
      if (durationMin != null) 'duration_min': durationMin,
      if (speedKmh != null) 'speed_kmh': speedKmh,
      if (inclinePct != null) 'incline_pct': inclinePct,
      if (level != null) 'level': level,
      if (calories != null) 'calories': calories,
      if (notes != null) 'notes': notes,
    });
  }

  CardioLogsCompanion copyWith({
    Value<int>? id,
    Value<int?>? sessionId,
    Value<DateTime>? date,
    Value<String>? type,
    Value<double>? durationMin,
    Value<double?>? speedKmh,
    Value<double?>? inclinePct,
    Value<int?>? level,
    Value<double?>? calories,
    Value<String?>? notes,
  }) {
    return CardioLogsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      date: date ?? this.date,
      type: type ?? this.type,
      durationMin: durationMin ?? this.durationMin,
      speedKmh: speedKmh ?? this.speedKmh,
      inclinePct: inclinePct ?? this.inclinePct,
      level: level ?? this.level,
      calories: calories ?? this.calories,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (durationMin.present) {
      map['duration_min'] = Variable<double>(durationMin.value);
    }
    if (speedKmh.present) {
      map['speed_kmh'] = Variable<double>(speedKmh.value);
    }
    if (inclinePct.present) {
      map['incline_pct'] = Variable<double>(inclinePct.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (calories.present) {
      map['calories'] = Variable<double>(calories.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardioLogsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('durationMin: $durationMin, ')
          ..write('speedKmh: $speedKmh, ')
          ..write('inclinePct: $inclinePct, ')
          ..write('level: $level, ')
          ..write('calories: $calories, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $MealPlansTable extends MealPlans
    with TableInfo<$MealPlansTable, MealPlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealPlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rawJsonMeta = const VerificationMeta(
    'rawJson',
  );
  @override
  late final GeneratedColumn<String> rawJson = GeneratedColumn<String>(
    'raw_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    isActive,
    notes,
    rawJson,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<MealPlan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('raw_json')) {
      context.handle(
        _rawJsonMeta,
        rawJson.isAcceptableOrUnknown(data['raw_json']!, _rawJsonMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealPlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealPlan(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      rawJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_json'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MealPlansTable createAlias(String alias) {
    return $MealPlansTable(attachedDatabase, alias);
  }
}

class MealPlan extends DataClass implements Insertable<MealPlan> {
  final int id;
  final String name;
  final bool isActive;
  final String? notes;
  final String? rawJson;
  final DateTime createdAt;
  const MealPlan({
    required this.id,
    required this.name,
    required this.isActive,
    this.notes,
    this.rawJson,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || rawJson != null) {
      map['raw_json'] = Variable<String>(rawJson);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MealPlansCompanion toCompanion(bool nullToAbsent) {
    return MealPlansCompanion(
      id: Value(id),
      name: Value(name),
      isActive: Value(isActive),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      rawJson: rawJson == null && nullToAbsent
          ? const Value.absent()
          : Value(rawJson),
      createdAt: Value(createdAt),
    );
  }

  factory MealPlan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealPlan(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      notes: serializer.fromJson<String?>(json['notes']),
      rawJson: serializer.fromJson<String?>(json['rawJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'isActive': serializer.toJson<bool>(isActive),
      'notes': serializer.toJson<String?>(notes),
      'rawJson': serializer.toJson<String?>(rawJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MealPlan copyWith({
    int? id,
    String? name,
    bool? isActive,
    Value<String?> notes = const Value.absent(),
    Value<String?> rawJson = const Value.absent(),
    DateTime? createdAt,
  }) => MealPlan(
    id: id ?? this.id,
    name: name ?? this.name,
    isActive: isActive ?? this.isActive,
    notes: notes.present ? notes.value : this.notes,
    rawJson: rawJson.present ? rawJson.value : this.rawJson,
    createdAt: createdAt ?? this.createdAt,
  );
  MealPlan copyWithCompanion(MealPlansCompanion data) {
    return MealPlan(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      notes: data.notes.present ? data.notes.value : this.notes,
      rawJson: data.rawJson.present ? data.rawJson.value : this.rawJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealPlan(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive, ')
          ..write('notes: $notes, ')
          ..write('rawJson: $rawJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, isActive, notes, rawJson, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealPlan &&
          other.id == this.id &&
          other.name == this.name &&
          other.isActive == this.isActive &&
          other.notes == this.notes &&
          other.rawJson == this.rawJson &&
          other.createdAt == this.createdAt);
}

class MealPlansCompanion extends UpdateCompanion<MealPlan> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> isActive;
  final Value<String?> notes;
  final Value<String?> rawJson;
  final Value<DateTime> createdAt;
  const MealPlansCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isActive = const Value.absent(),
    this.notes = const Value.absent(),
    this.rawJson = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MealPlansCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.isActive = const Value.absent(),
    this.notes = const Value.absent(),
    this.rawJson = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<MealPlan> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<bool>? isActive,
    Expression<String>? notes,
    Expression<String>? rawJson,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isActive != null) 'is_active': isActive,
      if (notes != null) 'notes': notes,
      if (rawJson != null) 'raw_json': rawJson,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MealPlansCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<bool>? isActive,
    Value<String?>? notes,
    Value<String?>? rawJson,
    Value<DateTime>? createdAt,
  }) {
    return MealPlansCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
      rawJson: rawJson ?? this.rawJson,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rawJson.present) {
      map['raw_json'] = Variable<String>(rawJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealPlansCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive, ')
          ..write('notes: $notes, ')
          ..write('rawJson: $rawJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PlannedMealsTable extends PlannedMeals
    with TableInfo<$PlannedMealsTable, PlannedMeal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlannedMealsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _mealPlanIdMeta = const VerificationMeta(
    'mealPlanId',
  );
  @override
  late final GeneratedColumn<int> mealPlanId = GeneratedColumn<int>(
    'meal_plan_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES meal_plans (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _dayTypeMeta = const VerificationMeta(
    'dayType',
  );
  @override
  late final GeneratedColumn<String> dayType = GeneratedColumn<String>(
    'day_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('all'),
  );
  static const VerificationMeta _mealIndexMeta = const VerificationMeta(
    'mealIndex',
  );
  @override
  late final GeneratedColumn<int> mealIndex = GeneratedColumn<int>(
    'meal_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<String> time = GeneratedColumn<String>(
    'time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _itemsJsonMeta = const VerificationMeta(
    'itemsJson',
  );
  @override
  late final GeneratedColumn<String> itemsJson = GeneratedColumn<String>(
    'items_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _caloriesMeta = const VerificationMeta(
    'calories',
  );
  @override
  late final GeneratedColumn<double> calories = GeneratedColumn<double>(
    'calories',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _proteinMeta = const VerificationMeta(
    'protein',
  );
  @override
  late final GeneratedColumn<double> protein = GeneratedColumn<double>(
    'protein',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _carbsMeta = const VerificationMeta('carbs');
  @override
  late final GeneratedColumn<double> carbs = GeneratedColumn<double>(
    'carbs',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _fatMeta = const VerificationMeta('fat');
  @override
  late final GeneratedColumn<double> fat = GeneratedColumn<double>(
    'fat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    mealPlanId,
    dayType,
    mealIndex,
    name,
    time,
    itemsJson,
    calories,
    protein,
    carbs,
    fat,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'planned_meals';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlannedMeal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('meal_plan_id')) {
      context.handle(
        _mealPlanIdMeta,
        mealPlanId.isAcceptableOrUnknown(
          data['meal_plan_id']!,
          _mealPlanIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_mealPlanIdMeta);
    }
    if (data.containsKey('day_type')) {
      context.handle(
        _dayTypeMeta,
        dayType.isAcceptableOrUnknown(data['day_type']!, _dayTypeMeta),
      );
    }
    if (data.containsKey('meal_index')) {
      context.handle(
        _mealIndexMeta,
        mealIndex.isAcceptableOrUnknown(data['meal_index']!, _mealIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_mealIndexMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('time')) {
      context.handle(
        _timeMeta,
        time.isAcceptableOrUnknown(data['time']!, _timeMeta),
      );
    }
    if (data.containsKey('items_json')) {
      context.handle(
        _itemsJsonMeta,
        itemsJson.isAcceptableOrUnknown(data['items_json']!, _itemsJsonMeta),
      );
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    }
    if (data.containsKey('protein')) {
      context.handle(
        _proteinMeta,
        protein.isAcceptableOrUnknown(data['protein']!, _proteinMeta),
      );
    }
    if (data.containsKey('carbs')) {
      context.handle(
        _carbsMeta,
        carbs.isAcceptableOrUnknown(data['carbs']!, _carbsMeta),
      );
    }
    if (data.containsKey('fat')) {
      context.handle(
        _fatMeta,
        fat.isAcceptableOrUnknown(data['fat']!, _fatMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlannedMeal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlannedMeal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      mealPlanId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}meal_plan_id'],
      )!,
      dayType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_type'],
      )!,
      mealIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}meal_index'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      time: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time'],
      ),
      itemsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}items_json'],
      )!,
      calories: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calories'],
      )!,
      protein: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein'],
      )!,
      carbs: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs'],
      )!,
      fat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat'],
      )!,
    );
  }

  @override
  $PlannedMealsTable createAlias(String alias) {
    return $PlannedMealsTable(attachedDatabase, alias);
  }
}

class PlannedMeal extends DataClass implements Insertable<PlannedMeal> {
  final int id;
  final int mealPlanId;
  final String dayType;
  final int mealIndex;
  final String name;
  final String? time;
  final String itemsJson;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  const PlannedMeal({
    required this.id,
    required this.mealPlanId,
    required this.dayType,
    required this.mealIndex,
    required this.name,
    this.time,
    required this.itemsJson,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['meal_plan_id'] = Variable<int>(mealPlanId);
    map['day_type'] = Variable<String>(dayType);
    map['meal_index'] = Variable<int>(mealIndex);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || time != null) {
      map['time'] = Variable<String>(time);
    }
    map['items_json'] = Variable<String>(itemsJson);
    map['calories'] = Variable<double>(calories);
    map['protein'] = Variable<double>(protein);
    map['carbs'] = Variable<double>(carbs);
    map['fat'] = Variable<double>(fat);
    return map;
  }

  PlannedMealsCompanion toCompanion(bool nullToAbsent) {
    return PlannedMealsCompanion(
      id: Value(id),
      mealPlanId: Value(mealPlanId),
      dayType: Value(dayType),
      mealIndex: Value(mealIndex),
      name: Value(name),
      time: time == null && nullToAbsent ? const Value.absent() : Value(time),
      itemsJson: Value(itemsJson),
      calories: Value(calories),
      protein: Value(protein),
      carbs: Value(carbs),
      fat: Value(fat),
    );
  }

  factory PlannedMeal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlannedMeal(
      id: serializer.fromJson<int>(json['id']),
      mealPlanId: serializer.fromJson<int>(json['mealPlanId']),
      dayType: serializer.fromJson<String>(json['dayType']),
      mealIndex: serializer.fromJson<int>(json['mealIndex']),
      name: serializer.fromJson<String>(json['name']),
      time: serializer.fromJson<String?>(json['time']),
      itemsJson: serializer.fromJson<String>(json['itemsJson']),
      calories: serializer.fromJson<double>(json['calories']),
      protein: serializer.fromJson<double>(json['protein']),
      carbs: serializer.fromJson<double>(json['carbs']),
      fat: serializer.fromJson<double>(json['fat']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mealPlanId': serializer.toJson<int>(mealPlanId),
      'dayType': serializer.toJson<String>(dayType),
      'mealIndex': serializer.toJson<int>(mealIndex),
      'name': serializer.toJson<String>(name),
      'time': serializer.toJson<String?>(time),
      'itemsJson': serializer.toJson<String>(itemsJson),
      'calories': serializer.toJson<double>(calories),
      'protein': serializer.toJson<double>(protein),
      'carbs': serializer.toJson<double>(carbs),
      'fat': serializer.toJson<double>(fat),
    };
  }

  PlannedMeal copyWith({
    int? id,
    int? mealPlanId,
    String? dayType,
    int? mealIndex,
    String? name,
    Value<String?> time = const Value.absent(),
    String? itemsJson,
    double? calories,
    double? protein,
    double? carbs,
    double? fat,
  }) => PlannedMeal(
    id: id ?? this.id,
    mealPlanId: mealPlanId ?? this.mealPlanId,
    dayType: dayType ?? this.dayType,
    mealIndex: mealIndex ?? this.mealIndex,
    name: name ?? this.name,
    time: time.present ? time.value : this.time,
    itemsJson: itemsJson ?? this.itemsJson,
    calories: calories ?? this.calories,
    protein: protein ?? this.protein,
    carbs: carbs ?? this.carbs,
    fat: fat ?? this.fat,
  );
  PlannedMeal copyWithCompanion(PlannedMealsCompanion data) {
    return PlannedMeal(
      id: data.id.present ? data.id.value : this.id,
      mealPlanId: data.mealPlanId.present
          ? data.mealPlanId.value
          : this.mealPlanId,
      dayType: data.dayType.present ? data.dayType.value : this.dayType,
      mealIndex: data.mealIndex.present ? data.mealIndex.value : this.mealIndex,
      name: data.name.present ? data.name.value : this.name,
      time: data.time.present ? data.time.value : this.time,
      itemsJson: data.itemsJson.present ? data.itemsJson.value : this.itemsJson,
      calories: data.calories.present ? data.calories.value : this.calories,
      protein: data.protein.present ? data.protein.value : this.protein,
      carbs: data.carbs.present ? data.carbs.value : this.carbs,
      fat: data.fat.present ? data.fat.value : this.fat,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlannedMeal(')
          ..write('id: $id, ')
          ..write('mealPlanId: $mealPlanId, ')
          ..write('dayType: $dayType, ')
          ..write('mealIndex: $mealIndex, ')
          ..write('name: $name, ')
          ..write('time: $time, ')
          ..write('itemsJson: $itemsJson, ')
          ..write('calories: $calories, ')
          ..write('protein: $protein, ')
          ..write('carbs: $carbs, ')
          ..write('fat: $fat')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    mealPlanId,
    dayType,
    mealIndex,
    name,
    time,
    itemsJson,
    calories,
    protein,
    carbs,
    fat,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlannedMeal &&
          other.id == this.id &&
          other.mealPlanId == this.mealPlanId &&
          other.dayType == this.dayType &&
          other.mealIndex == this.mealIndex &&
          other.name == this.name &&
          other.time == this.time &&
          other.itemsJson == this.itemsJson &&
          other.calories == this.calories &&
          other.protein == this.protein &&
          other.carbs == this.carbs &&
          other.fat == this.fat);
}

class PlannedMealsCompanion extends UpdateCompanion<PlannedMeal> {
  final Value<int> id;
  final Value<int> mealPlanId;
  final Value<String> dayType;
  final Value<int> mealIndex;
  final Value<String> name;
  final Value<String?> time;
  final Value<String> itemsJson;
  final Value<double> calories;
  final Value<double> protein;
  final Value<double> carbs;
  final Value<double> fat;
  const PlannedMealsCompanion({
    this.id = const Value.absent(),
    this.mealPlanId = const Value.absent(),
    this.dayType = const Value.absent(),
    this.mealIndex = const Value.absent(),
    this.name = const Value.absent(),
    this.time = const Value.absent(),
    this.itemsJson = const Value.absent(),
    this.calories = const Value.absent(),
    this.protein = const Value.absent(),
    this.carbs = const Value.absent(),
    this.fat = const Value.absent(),
  });
  PlannedMealsCompanion.insert({
    this.id = const Value.absent(),
    required int mealPlanId,
    this.dayType = const Value.absent(),
    required int mealIndex,
    required String name,
    this.time = const Value.absent(),
    this.itemsJson = const Value.absent(),
    this.calories = const Value.absent(),
    this.protein = const Value.absent(),
    this.carbs = const Value.absent(),
    this.fat = const Value.absent(),
  }) : mealPlanId = Value(mealPlanId),
       mealIndex = Value(mealIndex),
       name = Value(name);
  static Insertable<PlannedMeal> custom({
    Expression<int>? id,
    Expression<int>? mealPlanId,
    Expression<String>? dayType,
    Expression<int>? mealIndex,
    Expression<String>? name,
    Expression<String>? time,
    Expression<String>? itemsJson,
    Expression<double>? calories,
    Expression<double>? protein,
    Expression<double>? carbs,
    Expression<double>? fat,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mealPlanId != null) 'meal_plan_id': mealPlanId,
      if (dayType != null) 'day_type': dayType,
      if (mealIndex != null) 'meal_index': mealIndex,
      if (name != null) 'name': name,
      if (time != null) 'time': time,
      if (itemsJson != null) 'items_json': itemsJson,
      if (calories != null) 'calories': calories,
      if (protein != null) 'protein': protein,
      if (carbs != null) 'carbs': carbs,
      if (fat != null) 'fat': fat,
    });
  }

  PlannedMealsCompanion copyWith({
    Value<int>? id,
    Value<int>? mealPlanId,
    Value<String>? dayType,
    Value<int>? mealIndex,
    Value<String>? name,
    Value<String?>? time,
    Value<String>? itemsJson,
    Value<double>? calories,
    Value<double>? protein,
    Value<double>? carbs,
    Value<double>? fat,
  }) {
    return PlannedMealsCompanion(
      id: id ?? this.id,
      mealPlanId: mealPlanId ?? this.mealPlanId,
      dayType: dayType ?? this.dayType,
      mealIndex: mealIndex ?? this.mealIndex,
      name: name ?? this.name,
      time: time ?? this.time,
      itemsJson: itemsJson ?? this.itemsJson,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mealPlanId.present) {
      map['meal_plan_id'] = Variable<int>(mealPlanId.value);
    }
    if (dayType.present) {
      map['day_type'] = Variable<String>(dayType.value);
    }
    if (mealIndex.present) {
      map['meal_index'] = Variable<int>(mealIndex.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (time.present) {
      map['time'] = Variable<String>(time.value);
    }
    if (itemsJson.present) {
      map['items_json'] = Variable<String>(itemsJson.value);
    }
    if (calories.present) {
      map['calories'] = Variable<double>(calories.value);
    }
    if (protein.present) {
      map['protein'] = Variable<double>(protein.value);
    }
    if (carbs.present) {
      map['carbs'] = Variable<double>(carbs.value);
    }
    if (fat.present) {
      map['fat'] = Variable<double>(fat.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlannedMealsCompanion(')
          ..write('id: $id, ')
          ..write('mealPlanId: $mealPlanId, ')
          ..write('dayType: $dayType, ')
          ..write('mealIndex: $mealIndex, ')
          ..write('name: $name, ')
          ..write('time: $time, ')
          ..write('itemsJson: $itemsJson, ')
          ..write('calories: $calories, ')
          ..write('protein: $protein, ')
          ..write('carbs: $carbs, ')
          ..write('fat: $fat')
          ..write(')'))
        .toString();
  }
}

class $MealLogsTable extends MealLogs with TableInfo<$MealLogsTable, MealLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _loggedAtMeta = const VerificationMeta(
    'loggedAt',
  );
  @override
  late final GeneratedColumn<DateTime> loggedAt = GeneratedColumn<DateTime>(
    'logged_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _mealIndexMeta = const VerificationMeta(
    'mealIndex',
  );
  @override
  late final GeneratedColumn<int> mealIndex = GeneratedColumn<int>(
    'meal_index',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _plannedMealIdMeta = const VerificationMeta(
    'plannedMealId',
  );
  @override
  late final GeneratedColumn<int> plannedMealId = GeneratedColumn<int>(
    'planned_meal_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemsJsonMeta = const VerificationMeta(
    'itemsJson',
  );
  @override
  late final GeneratedColumn<String> itemsJson = GeneratedColumn<String>(
    'items_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _caloriesMeta = const VerificationMeta(
    'calories',
  );
  @override
  late final GeneratedColumn<double> calories = GeneratedColumn<double>(
    'calories',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _proteinMeta = const VerificationMeta(
    'protein',
  );
  @override
  late final GeneratedColumn<double> protein = GeneratedColumn<double>(
    'protein',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _carbsMeta = const VerificationMeta('carbs');
  @override
  late final GeneratedColumn<double> carbs = GeneratedColumn<double>(
    'carbs',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _fatMeta = const VerificationMeta('fat');
  @override
  late final GeneratedColumn<double> fat = GeneratedColumn<double>(
    'fat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('manual'),
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
    'confidence',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('done'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    loggedAt,
    mealIndex,
    plannedMealId,
    name,
    itemsJson,
    calories,
    protein,
    carbs,
    fat,
    photoPath,
    source,
    confidence,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<MealLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('logged_at')) {
      context.handle(
        _loggedAtMeta,
        loggedAt.isAcceptableOrUnknown(data['logged_at']!, _loggedAtMeta),
      );
    }
    if (data.containsKey('meal_index')) {
      context.handle(
        _mealIndexMeta,
        mealIndex.isAcceptableOrUnknown(data['meal_index']!, _mealIndexMeta),
      );
    }
    if (data.containsKey('planned_meal_id')) {
      context.handle(
        _plannedMealIdMeta,
        plannedMealId.isAcceptableOrUnknown(
          data['planned_meal_id']!,
          _plannedMealIdMeta,
        ),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('items_json')) {
      context.handle(
        _itemsJsonMeta,
        itemsJson.isAcceptableOrUnknown(data['items_json']!, _itemsJsonMeta),
      );
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    }
    if (data.containsKey('protein')) {
      context.handle(
        _proteinMeta,
        protein.isAcceptableOrUnknown(data['protein']!, _proteinMeta),
      );
    }
    if (data.containsKey('carbs')) {
      context.handle(
        _carbsMeta,
        carbs.isAcceptableOrUnknown(data['carbs']!, _carbsMeta),
      );
    }
    if (data.containsKey('fat')) {
      context.handle(
        _fatMeta,
        fat.isAcceptableOrUnknown(data['fat']!, _fatMeta),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      loggedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}logged_at'],
      )!,
      mealIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}meal_index'],
      ),
      plannedMealId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_meal_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      itemsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}items_json'],
      )!,
      calories: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calories'],
      )!,
      protein: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein'],
      )!,
      carbs: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs'],
      )!,
      fat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat'],
      )!,
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}confidence'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $MealLogsTable createAlias(String alias) {
    return $MealLogsTable(attachedDatabase, alias);
  }
}

class MealLog extends DataClass implements Insertable<MealLog> {
  final int id;
  final DateTime date;
  final DateTime loggedAt;
  final int? mealIndex;
  final int? plannedMealId;
  final String name;
  final String itemsJson;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final String? photoPath;
  final String source;
  final double? confidence;
  final String status;
  const MealLog({
    required this.id,
    required this.date,
    required this.loggedAt,
    this.mealIndex,
    this.plannedMealId,
    required this.name,
    required this.itemsJson,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.photoPath,
    required this.source,
    this.confidence,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['logged_at'] = Variable<DateTime>(loggedAt);
    if (!nullToAbsent || mealIndex != null) {
      map['meal_index'] = Variable<int>(mealIndex);
    }
    if (!nullToAbsent || plannedMealId != null) {
      map['planned_meal_id'] = Variable<int>(plannedMealId);
    }
    map['name'] = Variable<String>(name);
    map['items_json'] = Variable<String>(itemsJson);
    map['calories'] = Variable<double>(calories);
    map['protein'] = Variable<double>(protein);
    map['carbs'] = Variable<double>(carbs);
    map['fat'] = Variable<double>(fat);
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || confidence != null) {
      map['confidence'] = Variable<double>(confidence);
    }
    map['status'] = Variable<String>(status);
    return map;
  }

  MealLogsCompanion toCompanion(bool nullToAbsent) {
    return MealLogsCompanion(
      id: Value(id),
      date: Value(date),
      loggedAt: Value(loggedAt),
      mealIndex: mealIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(mealIndex),
      plannedMealId: plannedMealId == null && nullToAbsent
          ? const Value.absent()
          : Value(plannedMealId),
      name: Value(name),
      itemsJson: Value(itemsJson),
      calories: Value(calories),
      protein: Value(protein),
      carbs: Value(carbs),
      fat: Value(fat),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      source: Value(source),
      confidence: confidence == null && nullToAbsent
          ? const Value.absent()
          : Value(confidence),
      status: Value(status),
    );
  }

  factory MealLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealLog(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      loggedAt: serializer.fromJson<DateTime>(json['loggedAt']),
      mealIndex: serializer.fromJson<int?>(json['mealIndex']),
      plannedMealId: serializer.fromJson<int?>(json['plannedMealId']),
      name: serializer.fromJson<String>(json['name']),
      itemsJson: serializer.fromJson<String>(json['itemsJson']),
      calories: serializer.fromJson<double>(json['calories']),
      protein: serializer.fromJson<double>(json['protein']),
      carbs: serializer.fromJson<double>(json['carbs']),
      fat: serializer.fromJson<double>(json['fat']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      source: serializer.fromJson<String>(json['source']),
      confidence: serializer.fromJson<double?>(json['confidence']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'loggedAt': serializer.toJson<DateTime>(loggedAt),
      'mealIndex': serializer.toJson<int?>(mealIndex),
      'plannedMealId': serializer.toJson<int?>(plannedMealId),
      'name': serializer.toJson<String>(name),
      'itemsJson': serializer.toJson<String>(itemsJson),
      'calories': serializer.toJson<double>(calories),
      'protein': serializer.toJson<double>(protein),
      'carbs': serializer.toJson<double>(carbs),
      'fat': serializer.toJson<double>(fat),
      'photoPath': serializer.toJson<String?>(photoPath),
      'source': serializer.toJson<String>(source),
      'confidence': serializer.toJson<double?>(confidence),
      'status': serializer.toJson<String>(status),
    };
  }

  MealLog copyWith({
    int? id,
    DateTime? date,
    DateTime? loggedAt,
    Value<int?> mealIndex = const Value.absent(),
    Value<int?> plannedMealId = const Value.absent(),
    String? name,
    String? itemsJson,
    double? calories,
    double? protein,
    double? carbs,
    double? fat,
    Value<String?> photoPath = const Value.absent(),
    String? source,
    Value<double?> confidence = const Value.absent(),
    String? status,
  }) => MealLog(
    id: id ?? this.id,
    date: date ?? this.date,
    loggedAt: loggedAt ?? this.loggedAt,
    mealIndex: mealIndex.present ? mealIndex.value : this.mealIndex,
    plannedMealId: plannedMealId.present
        ? plannedMealId.value
        : this.plannedMealId,
    name: name ?? this.name,
    itemsJson: itemsJson ?? this.itemsJson,
    calories: calories ?? this.calories,
    protein: protein ?? this.protein,
    carbs: carbs ?? this.carbs,
    fat: fat ?? this.fat,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    source: source ?? this.source,
    confidence: confidence.present ? confidence.value : this.confidence,
    status: status ?? this.status,
  );
  MealLog copyWithCompanion(MealLogsCompanion data) {
    return MealLog(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      loggedAt: data.loggedAt.present ? data.loggedAt.value : this.loggedAt,
      mealIndex: data.mealIndex.present ? data.mealIndex.value : this.mealIndex,
      plannedMealId: data.plannedMealId.present
          ? data.plannedMealId.value
          : this.plannedMealId,
      name: data.name.present ? data.name.value : this.name,
      itemsJson: data.itemsJson.present ? data.itemsJson.value : this.itemsJson,
      calories: data.calories.present ? data.calories.value : this.calories,
      protein: data.protein.present ? data.protein.value : this.protein,
      carbs: data.carbs.present ? data.carbs.value : this.carbs,
      fat: data.fat.present ? data.fat.value : this.fat,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      source: data.source.present ? data.source.value : this.source,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealLog(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('mealIndex: $mealIndex, ')
          ..write('plannedMealId: $plannedMealId, ')
          ..write('name: $name, ')
          ..write('itemsJson: $itemsJson, ')
          ..write('calories: $calories, ')
          ..write('protein: $protein, ')
          ..write('carbs: $carbs, ')
          ..write('fat: $fat, ')
          ..write('photoPath: $photoPath, ')
          ..write('source: $source, ')
          ..write('confidence: $confidence, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    loggedAt,
    mealIndex,
    plannedMealId,
    name,
    itemsJson,
    calories,
    protein,
    carbs,
    fat,
    photoPath,
    source,
    confidence,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealLog &&
          other.id == this.id &&
          other.date == this.date &&
          other.loggedAt == this.loggedAt &&
          other.mealIndex == this.mealIndex &&
          other.plannedMealId == this.plannedMealId &&
          other.name == this.name &&
          other.itemsJson == this.itemsJson &&
          other.calories == this.calories &&
          other.protein == this.protein &&
          other.carbs == this.carbs &&
          other.fat == this.fat &&
          other.photoPath == this.photoPath &&
          other.source == this.source &&
          other.confidence == this.confidence &&
          other.status == this.status);
}

class MealLogsCompanion extends UpdateCompanion<MealLog> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<DateTime> loggedAt;
  final Value<int?> mealIndex;
  final Value<int?> plannedMealId;
  final Value<String> name;
  final Value<String> itemsJson;
  final Value<double> calories;
  final Value<double> protein;
  final Value<double> carbs;
  final Value<double> fat;
  final Value<String?> photoPath;
  final Value<String> source;
  final Value<double?> confidence;
  final Value<String> status;
  const MealLogsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.loggedAt = const Value.absent(),
    this.mealIndex = const Value.absent(),
    this.plannedMealId = const Value.absent(),
    this.name = const Value.absent(),
    this.itemsJson = const Value.absent(),
    this.calories = const Value.absent(),
    this.protein = const Value.absent(),
    this.carbs = const Value.absent(),
    this.fat = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.source = const Value.absent(),
    this.confidence = const Value.absent(),
    this.status = const Value.absent(),
  });
  MealLogsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    this.loggedAt = const Value.absent(),
    this.mealIndex = const Value.absent(),
    this.plannedMealId = const Value.absent(),
    required String name,
    this.itemsJson = const Value.absent(),
    this.calories = const Value.absent(),
    this.protein = const Value.absent(),
    this.carbs = const Value.absent(),
    this.fat = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.source = const Value.absent(),
    this.confidence = const Value.absent(),
    this.status = const Value.absent(),
  }) : date = Value(date),
       name = Value(name);
  static Insertable<MealLog> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<DateTime>? loggedAt,
    Expression<int>? mealIndex,
    Expression<int>? plannedMealId,
    Expression<String>? name,
    Expression<String>? itemsJson,
    Expression<double>? calories,
    Expression<double>? protein,
    Expression<double>? carbs,
    Expression<double>? fat,
    Expression<String>? photoPath,
    Expression<String>? source,
    Expression<double>? confidence,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (loggedAt != null) 'logged_at': loggedAt,
      if (mealIndex != null) 'meal_index': mealIndex,
      if (plannedMealId != null) 'planned_meal_id': plannedMealId,
      if (name != null) 'name': name,
      if (itemsJson != null) 'items_json': itemsJson,
      if (calories != null) 'calories': calories,
      if (protein != null) 'protein': protein,
      if (carbs != null) 'carbs': carbs,
      if (fat != null) 'fat': fat,
      if (photoPath != null) 'photo_path': photoPath,
      if (source != null) 'source': source,
      if (confidence != null) 'confidence': confidence,
      if (status != null) 'status': status,
    });
  }

  MealLogsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<DateTime>? loggedAt,
    Value<int?>? mealIndex,
    Value<int?>? plannedMealId,
    Value<String>? name,
    Value<String>? itemsJson,
    Value<double>? calories,
    Value<double>? protein,
    Value<double>? carbs,
    Value<double>? fat,
    Value<String?>? photoPath,
    Value<String>? source,
    Value<double?>? confidence,
    Value<String>? status,
  }) {
    return MealLogsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      loggedAt: loggedAt ?? this.loggedAt,
      mealIndex: mealIndex ?? this.mealIndex,
      plannedMealId: plannedMealId ?? this.plannedMealId,
      name: name ?? this.name,
      itemsJson: itemsJson ?? this.itemsJson,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      photoPath: photoPath ?? this.photoPath,
      source: source ?? this.source,
      confidence: confidence ?? this.confidence,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (loggedAt.present) {
      map['logged_at'] = Variable<DateTime>(loggedAt.value);
    }
    if (mealIndex.present) {
      map['meal_index'] = Variable<int>(mealIndex.value);
    }
    if (plannedMealId.present) {
      map['planned_meal_id'] = Variable<int>(plannedMealId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (itemsJson.present) {
      map['items_json'] = Variable<String>(itemsJson.value);
    }
    if (calories.present) {
      map['calories'] = Variable<double>(calories.value);
    }
    if (protein.present) {
      map['protein'] = Variable<double>(protein.value);
    }
    if (carbs.present) {
      map['carbs'] = Variable<double>(carbs.value);
    }
    if (fat.present) {
      map['fat'] = Variable<double>(fat.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealLogsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('mealIndex: $mealIndex, ')
          ..write('plannedMealId: $plannedMealId, ')
          ..write('name: $name, ')
          ..write('itemsJson: $itemsJson, ')
          ..write('calories: $calories, ')
          ..write('protein: $protein, ')
          ..write('carbs: $carbs, ')
          ..write('fat: $fat, ')
          ..write('photoPath: $photoPath, ')
          ..write('source: $source, ')
          ..write('confidence: $confidence, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $FoodItemsTable extends FoodItems
    with TableInfo<$FoodItemsTable, FoodItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoodItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemsJsonMeta = const VerificationMeta(
    'itemsJson',
  );
  @override
  late final GeneratedColumn<String> itemsJson = GeneratedColumn<String>(
    'items_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _caloriesMeta = const VerificationMeta(
    'calories',
  );
  @override
  late final GeneratedColumn<double> calories = GeneratedColumn<double>(
    'calories',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proteinMeta = const VerificationMeta(
    'protein',
  );
  @override
  late final GeneratedColumn<double> protein = GeneratedColumn<double>(
    'protein',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carbsMeta = const VerificationMeta('carbs');
  @override
  late final GeneratedColumn<double> carbs = GeneratedColumn<double>(
    'carbs',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fatMeta = const VerificationMeta('fat');
  @override
  late final GeneratedColumn<double> fat = GeneratedColumn<double>(
    'fat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _useCountMeta = const VerificationMeta(
    'useCount',
  );
  @override
  late final GeneratedColumn<int> useCount = GeneratedColumn<int>(
    'use_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastUsedMeta = const VerificationMeta(
    'lastUsed',
  );
  @override
  late final GeneratedColumn<DateTime> lastUsed = GeneratedColumn<DateTime>(
    'last_used',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    itemsJson,
    calories,
    protein,
    carbs,
    fat,
    useCount,
    lastUsed,
    isFavorite,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'food_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<FoodItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('items_json')) {
      context.handle(
        _itemsJsonMeta,
        itemsJson.isAcceptableOrUnknown(data['items_json']!, _itemsJsonMeta),
      );
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    } else if (isInserting) {
      context.missing(_caloriesMeta);
    }
    if (data.containsKey('protein')) {
      context.handle(
        _proteinMeta,
        protein.isAcceptableOrUnknown(data['protein']!, _proteinMeta),
      );
    } else if (isInserting) {
      context.missing(_proteinMeta);
    }
    if (data.containsKey('carbs')) {
      context.handle(
        _carbsMeta,
        carbs.isAcceptableOrUnknown(data['carbs']!, _carbsMeta),
      );
    } else if (isInserting) {
      context.missing(_carbsMeta);
    }
    if (data.containsKey('fat')) {
      context.handle(
        _fatMeta,
        fat.isAcceptableOrUnknown(data['fat']!, _fatMeta),
      );
    } else if (isInserting) {
      context.missing(_fatMeta);
    }
    if (data.containsKey('use_count')) {
      context.handle(
        _useCountMeta,
        useCount.isAcceptableOrUnknown(data['use_count']!, _useCountMeta),
      );
    }
    if (data.containsKey('last_used')) {
      context.handle(
        _lastUsedMeta,
        lastUsed.isAcceptableOrUnknown(data['last_used']!, _lastUsedMeta),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FoodItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FoodItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      itemsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}items_json'],
      )!,
      calories: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calories'],
      )!,
      protein: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein'],
      )!,
      carbs: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs'],
      )!,
      fat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat'],
      )!,
      useCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}use_count'],
      )!,
      lastUsed: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_used'],
      ),
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
    );
  }

  @override
  $FoodItemsTable createAlias(String alias) {
    return $FoodItemsTable(attachedDatabase, alias);
  }
}

class FoodItem extends DataClass implements Insertable<FoodItem> {
  final int id;
  final String name;
  final String itemsJson;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final int useCount;
  final DateTime? lastUsed;
  final bool isFavorite;
  const FoodItem({
    required this.id,
    required this.name,
    required this.itemsJson,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.useCount,
    this.lastUsed,
    required this.isFavorite,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['items_json'] = Variable<String>(itemsJson);
    map['calories'] = Variable<double>(calories);
    map['protein'] = Variable<double>(protein);
    map['carbs'] = Variable<double>(carbs);
    map['fat'] = Variable<double>(fat);
    map['use_count'] = Variable<int>(useCount);
    if (!nullToAbsent || lastUsed != null) {
      map['last_used'] = Variable<DateTime>(lastUsed);
    }
    map['is_favorite'] = Variable<bool>(isFavorite);
    return map;
  }

  FoodItemsCompanion toCompanion(bool nullToAbsent) {
    return FoodItemsCompanion(
      id: Value(id),
      name: Value(name),
      itemsJson: Value(itemsJson),
      calories: Value(calories),
      protein: Value(protein),
      carbs: Value(carbs),
      fat: Value(fat),
      useCount: Value(useCount),
      lastUsed: lastUsed == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUsed),
      isFavorite: Value(isFavorite),
    );
  }

  factory FoodItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FoodItem(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      itemsJson: serializer.fromJson<String>(json['itemsJson']),
      calories: serializer.fromJson<double>(json['calories']),
      protein: serializer.fromJson<double>(json['protein']),
      carbs: serializer.fromJson<double>(json['carbs']),
      fat: serializer.fromJson<double>(json['fat']),
      useCount: serializer.fromJson<int>(json['useCount']),
      lastUsed: serializer.fromJson<DateTime?>(json['lastUsed']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'itemsJson': serializer.toJson<String>(itemsJson),
      'calories': serializer.toJson<double>(calories),
      'protein': serializer.toJson<double>(protein),
      'carbs': serializer.toJson<double>(carbs),
      'fat': serializer.toJson<double>(fat),
      'useCount': serializer.toJson<int>(useCount),
      'lastUsed': serializer.toJson<DateTime?>(lastUsed),
      'isFavorite': serializer.toJson<bool>(isFavorite),
    };
  }

  FoodItem copyWith({
    int? id,
    String? name,
    String? itemsJson,
    double? calories,
    double? protein,
    double? carbs,
    double? fat,
    int? useCount,
    Value<DateTime?> lastUsed = const Value.absent(),
    bool? isFavorite,
  }) => FoodItem(
    id: id ?? this.id,
    name: name ?? this.name,
    itemsJson: itemsJson ?? this.itemsJson,
    calories: calories ?? this.calories,
    protein: protein ?? this.protein,
    carbs: carbs ?? this.carbs,
    fat: fat ?? this.fat,
    useCount: useCount ?? this.useCount,
    lastUsed: lastUsed.present ? lastUsed.value : this.lastUsed,
    isFavorite: isFavorite ?? this.isFavorite,
  );
  FoodItem copyWithCompanion(FoodItemsCompanion data) {
    return FoodItem(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      itemsJson: data.itemsJson.present ? data.itemsJson.value : this.itemsJson,
      calories: data.calories.present ? data.calories.value : this.calories,
      protein: data.protein.present ? data.protein.value : this.protein,
      carbs: data.carbs.present ? data.carbs.value : this.carbs,
      fat: data.fat.present ? data.fat.value : this.fat,
      useCount: data.useCount.present ? data.useCount.value : this.useCount,
      lastUsed: data.lastUsed.present ? data.lastUsed.value : this.lastUsed,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FoodItem(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('itemsJson: $itemsJson, ')
          ..write('calories: $calories, ')
          ..write('protein: $protein, ')
          ..write('carbs: $carbs, ')
          ..write('fat: $fat, ')
          ..write('useCount: $useCount, ')
          ..write('lastUsed: $lastUsed, ')
          ..write('isFavorite: $isFavorite')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    itemsJson,
    calories,
    protein,
    carbs,
    fat,
    useCount,
    lastUsed,
    isFavorite,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FoodItem &&
          other.id == this.id &&
          other.name == this.name &&
          other.itemsJson == this.itemsJson &&
          other.calories == this.calories &&
          other.protein == this.protein &&
          other.carbs == this.carbs &&
          other.fat == this.fat &&
          other.useCount == this.useCount &&
          other.lastUsed == this.lastUsed &&
          other.isFavorite == this.isFavorite);
}

class FoodItemsCompanion extends UpdateCompanion<FoodItem> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> itemsJson;
  final Value<double> calories;
  final Value<double> protein;
  final Value<double> carbs;
  final Value<double> fat;
  final Value<int> useCount;
  final Value<DateTime?> lastUsed;
  final Value<bool> isFavorite;
  const FoodItemsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.itemsJson = const Value.absent(),
    this.calories = const Value.absent(),
    this.protein = const Value.absent(),
    this.carbs = const Value.absent(),
    this.fat = const Value.absent(),
    this.useCount = const Value.absent(),
    this.lastUsed = const Value.absent(),
    this.isFavorite = const Value.absent(),
  });
  FoodItemsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.itemsJson = const Value.absent(),
    required double calories,
    required double protein,
    required double carbs,
    required double fat,
    this.useCount = const Value.absent(),
    this.lastUsed = const Value.absent(),
    this.isFavorite = const Value.absent(),
  }) : name = Value(name),
       calories = Value(calories),
       protein = Value(protein),
       carbs = Value(carbs),
       fat = Value(fat);
  static Insertable<FoodItem> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? itemsJson,
    Expression<double>? calories,
    Expression<double>? protein,
    Expression<double>? carbs,
    Expression<double>? fat,
    Expression<int>? useCount,
    Expression<DateTime>? lastUsed,
    Expression<bool>? isFavorite,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (itemsJson != null) 'items_json': itemsJson,
      if (calories != null) 'calories': calories,
      if (protein != null) 'protein': protein,
      if (carbs != null) 'carbs': carbs,
      if (fat != null) 'fat': fat,
      if (useCount != null) 'use_count': useCount,
      if (lastUsed != null) 'last_used': lastUsed,
      if (isFavorite != null) 'is_favorite': isFavorite,
    });
  }

  FoodItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? itemsJson,
    Value<double>? calories,
    Value<double>? protein,
    Value<double>? carbs,
    Value<double>? fat,
    Value<int>? useCount,
    Value<DateTime?>? lastUsed,
    Value<bool>? isFavorite,
  }) {
    return FoodItemsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      itemsJson: itemsJson ?? this.itemsJson,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      useCount: useCount ?? this.useCount,
      lastUsed: lastUsed ?? this.lastUsed,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (itemsJson.present) {
      map['items_json'] = Variable<String>(itemsJson.value);
    }
    if (calories.present) {
      map['calories'] = Variable<double>(calories.value);
    }
    if (protein.present) {
      map['protein'] = Variable<double>(protein.value);
    }
    if (carbs.present) {
      map['carbs'] = Variable<double>(carbs.value);
    }
    if (fat.present) {
      map['fat'] = Variable<double>(fat.value);
    }
    if (useCount.present) {
      map['use_count'] = Variable<int>(useCount.value);
    }
    if (lastUsed.present) {
      map['last_used'] = Variable<DateTime>(lastUsed.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoodItemsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('itemsJson: $itemsJson, ')
          ..write('calories: $calories, ')
          ..write('protein: $protein, ')
          ..write('carbs: $carbs, ')
          ..write('fat: $fat, ')
          ..write('useCount: $useCount, ')
          ..write('lastUsed: $lastUsed, ')
          ..write('isFavorite: $isFavorite')
          ..write(')'))
        .toString();
  }
}

class $BodyMetricsTable extends BodyMetrics
    with TableInfo<$BodyMetricsTable, BodyMetric> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BodyMetricsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _waistCmMeta = const VerificationMeta(
    'waistCm',
  );
  @override
  late final GeneratedColumn<double> waistCm = GeneratedColumn<double>(
    'waist_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _chestCmMeta = const VerificationMeta(
    'chestCm',
  );
  @override
  late final GeneratedColumn<double> chestCm = GeneratedColumn<double>(
    'chest_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _armCmMeta = const VerificationMeta('armCm');
  @override
  late final GeneratedColumn<double> armCm = GeneratedColumn<double>(
    'arm_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _thighCmMeta = const VerificationMeta(
    'thighCm',
  );
  @override
  late final GeneratedColumn<double> thighCm = GeneratedColumn<double>(
    'thigh_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _neckCmMeta = const VerificationMeta('neckCm');
  @override
  late final GeneratedColumn<double> neckCm = GeneratedColumn<double>(
    'neck_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hipsCmMeta = const VerificationMeta('hipsCm');
  @override
  late final GeneratedColumn<double> hipsCm = GeneratedColumn<double>(
    'hips_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bodyFatPctMeta = const VerificationMeta(
    'bodyFatPct',
  );
  @override
  late final GeneratedColumn<double> bodyFatPct = GeneratedColumn<double>(
    'body_fat_pct',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    weightKg,
    waistCm,
    chestCm,
    armCm,
    thighCm,
    neckCm,
    hipsCm,
    bodyFatPct,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'body_metrics';
  @override
  VerificationContext validateIntegrity(
    Insertable<BodyMetric> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    }
    if (data.containsKey('waist_cm')) {
      context.handle(
        _waistCmMeta,
        waistCm.isAcceptableOrUnknown(data['waist_cm']!, _waistCmMeta),
      );
    }
    if (data.containsKey('chest_cm')) {
      context.handle(
        _chestCmMeta,
        chestCm.isAcceptableOrUnknown(data['chest_cm']!, _chestCmMeta),
      );
    }
    if (data.containsKey('arm_cm')) {
      context.handle(
        _armCmMeta,
        armCm.isAcceptableOrUnknown(data['arm_cm']!, _armCmMeta),
      );
    }
    if (data.containsKey('thigh_cm')) {
      context.handle(
        _thighCmMeta,
        thighCm.isAcceptableOrUnknown(data['thigh_cm']!, _thighCmMeta),
      );
    }
    if (data.containsKey('neck_cm')) {
      context.handle(
        _neckCmMeta,
        neckCm.isAcceptableOrUnknown(data['neck_cm']!, _neckCmMeta),
      );
    }
    if (data.containsKey('hips_cm')) {
      context.handle(
        _hipsCmMeta,
        hipsCm.isAcceptableOrUnknown(data['hips_cm']!, _hipsCmMeta),
      );
    }
    if (data.containsKey('body_fat_pct')) {
      context.handle(
        _bodyFatPctMeta,
        bodyFatPct.isAcceptableOrUnknown(
          data['body_fat_pct']!,
          _bodyFatPctMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BodyMetric map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BodyMetric(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      ),
      waistCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}waist_cm'],
      ),
      chestCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}chest_cm'],
      ),
      armCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}arm_cm'],
      ),
      thighCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}thigh_cm'],
      ),
      neckCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}neck_cm'],
      ),
      hipsCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}hips_cm'],
      ),
      bodyFatPct: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}body_fat_pct'],
      ),
    );
  }

  @override
  $BodyMetricsTable createAlias(String alias) {
    return $BodyMetricsTable(attachedDatabase, alias);
  }
}

class BodyMetric extends DataClass implements Insertable<BodyMetric> {
  final int id;
  final DateTime date;
  final double? weightKg;
  final double? waistCm;
  final double? chestCm;
  final double? armCm;
  final double? thighCm;
  final double? neckCm;
  final double? hipsCm;
  final double? bodyFatPct;
  const BodyMetric({
    required this.id,
    required this.date,
    this.weightKg,
    this.waistCm,
    this.chestCm,
    this.armCm,
    this.thighCm,
    this.neckCm,
    this.hipsCm,
    this.bodyFatPct,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || weightKg != null) {
      map['weight_kg'] = Variable<double>(weightKg);
    }
    if (!nullToAbsent || waistCm != null) {
      map['waist_cm'] = Variable<double>(waistCm);
    }
    if (!nullToAbsent || chestCm != null) {
      map['chest_cm'] = Variable<double>(chestCm);
    }
    if (!nullToAbsent || armCm != null) {
      map['arm_cm'] = Variable<double>(armCm);
    }
    if (!nullToAbsent || thighCm != null) {
      map['thigh_cm'] = Variable<double>(thighCm);
    }
    if (!nullToAbsent || neckCm != null) {
      map['neck_cm'] = Variable<double>(neckCm);
    }
    if (!nullToAbsent || hipsCm != null) {
      map['hips_cm'] = Variable<double>(hipsCm);
    }
    if (!nullToAbsent || bodyFatPct != null) {
      map['body_fat_pct'] = Variable<double>(bodyFatPct);
    }
    return map;
  }

  BodyMetricsCompanion toCompanion(bool nullToAbsent) {
    return BodyMetricsCompanion(
      id: Value(id),
      date: Value(date),
      weightKg: weightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(weightKg),
      waistCm: waistCm == null && nullToAbsent
          ? const Value.absent()
          : Value(waistCm),
      chestCm: chestCm == null && nullToAbsent
          ? const Value.absent()
          : Value(chestCm),
      armCm: armCm == null && nullToAbsent
          ? const Value.absent()
          : Value(armCm),
      thighCm: thighCm == null && nullToAbsent
          ? const Value.absent()
          : Value(thighCm),
      neckCm: neckCm == null && nullToAbsent
          ? const Value.absent()
          : Value(neckCm),
      hipsCm: hipsCm == null && nullToAbsent
          ? const Value.absent()
          : Value(hipsCm),
      bodyFatPct: bodyFatPct == null && nullToAbsent
          ? const Value.absent()
          : Value(bodyFatPct),
    );
  }

  factory BodyMetric.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BodyMetric(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      weightKg: serializer.fromJson<double?>(json['weightKg']),
      waistCm: serializer.fromJson<double?>(json['waistCm']),
      chestCm: serializer.fromJson<double?>(json['chestCm']),
      armCm: serializer.fromJson<double?>(json['armCm']),
      thighCm: serializer.fromJson<double?>(json['thighCm']),
      neckCm: serializer.fromJson<double?>(json['neckCm']),
      hipsCm: serializer.fromJson<double?>(json['hipsCm']),
      bodyFatPct: serializer.fromJson<double?>(json['bodyFatPct']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'weightKg': serializer.toJson<double?>(weightKg),
      'waistCm': serializer.toJson<double?>(waistCm),
      'chestCm': serializer.toJson<double?>(chestCm),
      'armCm': serializer.toJson<double?>(armCm),
      'thighCm': serializer.toJson<double?>(thighCm),
      'neckCm': serializer.toJson<double?>(neckCm),
      'hipsCm': serializer.toJson<double?>(hipsCm),
      'bodyFatPct': serializer.toJson<double?>(bodyFatPct),
    };
  }

  BodyMetric copyWith({
    int? id,
    DateTime? date,
    Value<double?> weightKg = const Value.absent(),
    Value<double?> waistCm = const Value.absent(),
    Value<double?> chestCm = const Value.absent(),
    Value<double?> armCm = const Value.absent(),
    Value<double?> thighCm = const Value.absent(),
    Value<double?> neckCm = const Value.absent(),
    Value<double?> hipsCm = const Value.absent(),
    Value<double?> bodyFatPct = const Value.absent(),
  }) => BodyMetric(
    id: id ?? this.id,
    date: date ?? this.date,
    weightKg: weightKg.present ? weightKg.value : this.weightKg,
    waistCm: waistCm.present ? waistCm.value : this.waistCm,
    chestCm: chestCm.present ? chestCm.value : this.chestCm,
    armCm: armCm.present ? armCm.value : this.armCm,
    thighCm: thighCm.present ? thighCm.value : this.thighCm,
    neckCm: neckCm.present ? neckCm.value : this.neckCm,
    hipsCm: hipsCm.present ? hipsCm.value : this.hipsCm,
    bodyFatPct: bodyFatPct.present ? bodyFatPct.value : this.bodyFatPct,
  );
  BodyMetric copyWithCompanion(BodyMetricsCompanion data) {
    return BodyMetric(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      waistCm: data.waistCm.present ? data.waistCm.value : this.waistCm,
      chestCm: data.chestCm.present ? data.chestCm.value : this.chestCm,
      armCm: data.armCm.present ? data.armCm.value : this.armCm,
      thighCm: data.thighCm.present ? data.thighCm.value : this.thighCm,
      neckCm: data.neckCm.present ? data.neckCm.value : this.neckCm,
      hipsCm: data.hipsCm.present ? data.hipsCm.value : this.hipsCm,
      bodyFatPct: data.bodyFatPct.present
          ? data.bodyFatPct.value
          : this.bodyFatPct,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BodyMetric(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('weightKg: $weightKg, ')
          ..write('waistCm: $waistCm, ')
          ..write('chestCm: $chestCm, ')
          ..write('armCm: $armCm, ')
          ..write('thighCm: $thighCm, ')
          ..write('neckCm: $neckCm, ')
          ..write('hipsCm: $hipsCm, ')
          ..write('bodyFatPct: $bodyFatPct')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    weightKg,
    waistCm,
    chestCm,
    armCm,
    thighCm,
    neckCm,
    hipsCm,
    bodyFatPct,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BodyMetric &&
          other.id == this.id &&
          other.date == this.date &&
          other.weightKg == this.weightKg &&
          other.waistCm == this.waistCm &&
          other.chestCm == this.chestCm &&
          other.armCm == this.armCm &&
          other.thighCm == this.thighCm &&
          other.neckCm == this.neckCm &&
          other.hipsCm == this.hipsCm &&
          other.bodyFatPct == this.bodyFatPct);
}

class BodyMetricsCompanion extends UpdateCompanion<BodyMetric> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<double?> weightKg;
  final Value<double?> waistCm;
  final Value<double?> chestCm;
  final Value<double?> armCm;
  final Value<double?> thighCm;
  final Value<double?> neckCm;
  final Value<double?> hipsCm;
  final Value<double?> bodyFatPct;
  const BodyMetricsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.waistCm = const Value.absent(),
    this.chestCm = const Value.absent(),
    this.armCm = const Value.absent(),
    this.thighCm = const Value.absent(),
    this.neckCm = const Value.absent(),
    this.hipsCm = const Value.absent(),
    this.bodyFatPct = const Value.absent(),
  });
  BodyMetricsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    this.weightKg = const Value.absent(),
    this.waistCm = const Value.absent(),
    this.chestCm = const Value.absent(),
    this.armCm = const Value.absent(),
    this.thighCm = const Value.absent(),
    this.neckCm = const Value.absent(),
    this.hipsCm = const Value.absent(),
    this.bodyFatPct = const Value.absent(),
  }) : date = Value(date);
  static Insertable<BodyMetric> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<double>? weightKg,
    Expression<double>? waistCm,
    Expression<double>? chestCm,
    Expression<double>? armCm,
    Expression<double>? thighCm,
    Expression<double>? neckCm,
    Expression<double>? hipsCm,
    Expression<double>? bodyFatPct,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (weightKg != null) 'weight_kg': weightKg,
      if (waistCm != null) 'waist_cm': waistCm,
      if (chestCm != null) 'chest_cm': chestCm,
      if (armCm != null) 'arm_cm': armCm,
      if (thighCm != null) 'thigh_cm': thighCm,
      if (neckCm != null) 'neck_cm': neckCm,
      if (hipsCm != null) 'hips_cm': hipsCm,
      if (bodyFatPct != null) 'body_fat_pct': bodyFatPct,
    });
  }

  BodyMetricsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<double?>? weightKg,
    Value<double?>? waistCm,
    Value<double?>? chestCm,
    Value<double?>? armCm,
    Value<double?>? thighCm,
    Value<double?>? neckCm,
    Value<double?>? hipsCm,
    Value<double?>? bodyFatPct,
  }) {
    return BodyMetricsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      weightKg: weightKg ?? this.weightKg,
      waistCm: waistCm ?? this.waistCm,
      chestCm: chestCm ?? this.chestCm,
      armCm: armCm ?? this.armCm,
      thighCm: thighCm ?? this.thighCm,
      neckCm: neckCm ?? this.neckCm,
      hipsCm: hipsCm ?? this.hipsCm,
      bodyFatPct: bodyFatPct ?? this.bodyFatPct,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (waistCm.present) {
      map['waist_cm'] = Variable<double>(waistCm.value);
    }
    if (chestCm.present) {
      map['chest_cm'] = Variable<double>(chestCm.value);
    }
    if (armCm.present) {
      map['arm_cm'] = Variable<double>(armCm.value);
    }
    if (thighCm.present) {
      map['thigh_cm'] = Variable<double>(thighCm.value);
    }
    if (neckCm.present) {
      map['neck_cm'] = Variable<double>(neckCm.value);
    }
    if (hipsCm.present) {
      map['hips_cm'] = Variable<double>(hipsCm.value);
    }
    if (bodyFatPct.present) {
      map['body_fat_pct'] = Variable<double>(bodyFatPct.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BodyMetricsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('weightKg: $weightKg, ')
          ..write('waistCm: $waistCm, ')
          ..write('chestCm: $chestCm, ')
          ..write('armCm: $armCm, ')
          ..write('thighCm: $thighCm, ')
          ..write('neckCm: $neckCm, ')
          ..write('hipsCm: $hipsCm, ')
          ..write('bodyFatPct: $bodyFatPct')
          ..write(')'))
        .toString();
  }
}

class $ProgressPhotosTable extends ProgressPhotos
    with TableInfo<$ProgressPhotosTable, ProgressPhoto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgressPhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _angleMeta = const VerificationMeta('angle');
  @override
  late final GeneratedColumn<String> angle = GeneratedColumn<String>(
    'angle',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, date, angle, path];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'progress_photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProgressPhoto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('angle')) {
      context.handle(
        _angleMeta,
        angle.isAcceptableOrUnknown(data['angle']!, _angleMeta),
      );
    } else if (isInserting) {
      context.missing(_angleMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProgressPhoto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProgressPhoto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      angle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}angle'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
    );
  }

  @override
  $ProgressPhotosTable createAlias(String alias) {
    return $ProgressPhotosTable(attachedDatabase, alias);
  }
}

class ProgressPhoto extends DataClass implements Insertable<ProgressPhoto> {
  final int id;
  final DateTime date;
  final String angle;
  final String path;
  const ProgressPhoto({
    required this.id,
    required this.date,
    required this.angle,
    required this.path,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['angle'] = Variable<String>(angle);
    map['path'] = Variable<String>(path);
    return map;
  }

  ProgressPhotosCompanion toCompanion(bool nullToAbsent) {
    return ProgressPhotosCompanion(
      id: Value(id),
      date: Value(date),
      angle: Value(angle),
      path: Value(path),
    );
  }

  factory ProgressPhoto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProgressPhoto(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      angle: serializer.fromJson<String>(json['angle']),
      path: serializer.fromJson<String>(json['path']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'angle': serializer.toJson<String>(angle),
      'path': serializer.toJson<String>(path),
    };
  }

  ProgressPhoto copyWith({
    int? id,
    DateTime? date,
    String? angle,
    String? path,
  }) => ProgressPhoto(
    id: id ?? this.id,
    date: date ?? this.date,
    angle: angle ?? this.angle,
    path: path ?? this.path,
  );
  ProgressPhoto copyWithCompanion(ProgressPhotosCompanion data) {
    return ProgressPhoto(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      angle: data.angle.present ? data.angle.value : this.angle,
      path: data.path.present ? data.path.value : this.path,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProgressPhoto(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('angle: $angle, ')
          ..write('path: $path')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, angle, path);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProgressPhoto &&
          other.id == this.id &&
          other.date == this.date &&
          other.angle == this.angle &&
          other.path == this.path);
}

class ProgressPhotosCompanion extends UpdateCompanion<ProgressPhoto> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String> angle;
  final Value<String> path;
  const ProgressPhotosCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.angle = const Value.absent(),
    this.path = const Value.absent(),
  });
  ProgressPhotosCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required String angle,
    required String path,
  }) : date = Value(date),
       angle = Value(angle),
       path = Value(path);
  static Insertable<ProgressPhoto> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? angle,
    Expression<String>? path,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (angle != null) 'angle': angle,
      if (path != null) 'path': path,
    });
  }

  ProgressPhotosCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<String>? angle,
    Value<String>? path,
  }) {
    return ProgressPhotosCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      angle: angle ?? this.angle,
      path: path ?? this.path,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (angle.present) {
      map['angle'] = Variable<String>(angle.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgressPhotosCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('angle: $angle, ')
          ..write('path: $path')
          ..write(')'))
        .toString();
  }
}

class $WaterLogsTable extends WaterLogs
    with TableInfo<$WaterLogsTable, WaterLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WaterLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMlMeta = const VerificationMeta(
    'amountMl',
  );
  @override
  late final GeneratedColumn<int> amountMl = GeneratedColumn<int>(
    'amount_ml',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('manual'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, timestamp, amountMl, source];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'water_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<WaterLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('amount_ml')) {
      context.handle(
        _amountMlMeta,
        amountMl.isAcceptableOrUnknown(data['amount_ml']!, _amountMlMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMlMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WaterLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WaterLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      amountMl: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_ml'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
    );
  }

  @override
  $WaterLogsTable createAlias(String alias) {
    return $WaterLogsTable(attachedDatabase, alias);
  }
}

class WaterLog extends DataClass implements Insertable<WaterLog> {
  final int id;
  final DateTime timestamp;
  final int amountMl;
  final String source;
  const WaterLog({
    required this.id,
    required this.timestamp,
    required this.amountMl,
    required this.source,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['amount_ml'] = Variable<int>(amountMl);
    map['source'] = Variable<String>(source);
    return map;
  }

  WaterLogsCompanion toCompanion(bool nullToAbsent) {
    return WaterLogsCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      amountMl: Value(amountMl),
      source: Value(source),
    );
  }

  factory WaterLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WaterLog(
      id: serializer.fromJson<int>(json['id']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      amountMl: serializer.fromJson<int>(json['amountMl']),
      source: serializer.fromJson<String>(json['source']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'amountMl': serializer.toJson<int>(amountMl),
      'source': serializer.toJson<String>(source),
    };
  }

  WaterLog copyWith({
    int? id,
    DateTime? timestamp,
    int? amountMl,
    String? source,
  }) => WaterLog(
    id: id ?? this.id,
    timestamp: timestamp ?? this.timestamp,
    amountMl: amountMl ?? this.amountMl,
    source: source ?? this.source,
  );
  WaterLog copyWithCompanion(WaterLogsCompanion data) {
    return WaterLog(
      id: data.id.present ? data.id.value : this.id,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      amountMl: data.amountMl.present ? data.amountMl.value : this.amountMl,
      source: data.source.present ? data.source.value : this.source,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WaterLog(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('amountMl: $amountMl, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, timestamp, amountMl, source);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WaterLog &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.amountMl == this.amountMl &&
          other.source == this.source);
}

class WaterLogsCompanion extends UpdateCompanion<WaterLog> {
  final Value<int> id;
  final Value<DateTime> timestamp;
  final Value<int> amountMl;
  final Value<String> source;
  const WaterLogsCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.amountMl = const Value.absent(),
    this.source = const Value.absent(),
  });
  WaterLogsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime timestamp,
    required int amountMl,
    this.source = const Value.absent(),
  }) : timestamp = Value(timestamp),
       amountMl = Value(amountMl);
  static Insertable<WaterLog> custom({
    Expression<int>? id,
    Expression<DateTime>? timestamp,
    Expression<int>? amountMl,
    Expression<String>? source,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (amountMl != null) 'amount_ml': amountMl,
      if (source != null) 'source': source,
    });
  }

  WaterLogsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? timestamp,
    Value<int>? amountMl,
    Value<String>? source,
  }) {
    return WaterLogsCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      amountMl: amountMl ?? this.amountMl,
      source: source ?? this.source,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (amountMl.present) {
      map['amount_ml'] = Variable<int>(amountMl.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WaterLogsCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('amountMl: $amountMl, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }
}

class $SupplementsTable extends Supplements
    with TableInfo<$SupplementsTable, Supplement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SupplementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doseMeta = const VerificationMeta('dose');
  @override
  late final GeneratedColumn<String> dose = GeneratedColumn<String>(
    'dose',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timingMeta = const VerificationMeta('timing');
  @override
  late final GeneratedColumn<String> timing = GeneratedColumn<String>(
    'timing',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _proteinGMeta = const VerificationMeta(
    'proteinG',
  );
  @override
  late final GeneratedColumn<double> proteinG = GeneratedColumn<double>(
    'protein_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _caloriesMeta = const VerificationMeta(
    'calories',
  );
  @override
  late final GeneratedColumn<double> calories = GeneratedColumn<double>(
    'calories',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _carbsGMeta = const VerificationMeta('carbsG');
  @override
  late final GeneratedColumn<double> carbsG = GeneratedColumn<double>(
    'carbs_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _fatGMeta = const VerificationMeta('fatG');
  @override
  late final GeneratedColumn<double> fatG = GeneratedColumn<double>(
    'fat_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    dose,
    timing,
    proteinG,
    calories,
    carbsG,
    fatG,
    active,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'supplements';
  @override
  VerificationContext validateIntegrity(
    Insertable<Supplement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('dose')) {
      context.handle(
        _doseMeta,
        dose.isAcceptableOrUnknown(data['dose']!, _doseMeta),
      );
    }
    if (data.containsKey('timing')) {
      context.handle(
        _timingMeta,
        timing.isAcceptableOrUnknown(data['timing']!, _timingMeta),
      );
    }
    if (data.containsKey('protein_g')) {
      context.handle(
        _proteinGMeta,
        proteinG.isAcceptableOrUnknown(data['protein_g']!, _proteinGMeta),
      );
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    }
    if (data.containsKey('carbs_g')) {
      context.handle(
        _carbsGMeta,
        carbsG.isAcceptableOrUnknown(data['carbs_g']!, _carbsGMeta),
      );
    }
    if (data.containsKey('fat_g')) {
      context.handle(
        _fatGMeta,
        fatG.isAcceptableOrUnknown(data['fat_g']!, _fatGMeta),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Supplement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Supplement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      dose: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dose'],
      ),
      timing: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timing'],
      ),
      proteinG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein_g'],
      )!,
      calories: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calories'],
      )!,
      carbsG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs_g'],
      )!,
      fatG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat_g'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $SupplementsTable createAlias(String alias) {
    return $SupplementsTable(attachedDatabase, alias);
  }
}

class Supplement extends DataClass implements Insertable<Supplement> {
  final int id;
  final String name;
  final String? dose;
  final String? timing;
  final double proteinG;
  final double calories;
  final double carbsG;
  final double fatG;
  final bool active;
  const Supplement({
    required this.id,
    required this.name,
    this.dose,
    this.timing,
    required this.proteinG,
    required this.calories,
    required this.carbsG,
    required this.fatG,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || dose != null) {
      map['dose'] = Variable<String>(dose);
    }
    if (!nullToAbsent || timing != null) {
      map['timing'] = Variable<String>(timing);
    }
    map['protein_g'] = Variable<double>(proteinG);
    map['calories'] = Variable<double>(calories);
    map['carbs_g'] = Variable<double>(carbsG);
    map['fat_g'] = Variable<double>(fatG);
    map['active'] = Variable<bool>(active);
    return map;
  }

  SupplementsCompanion toCompanion(bool nullToAbsent) {
    return SupplementsCompanion(
      id: Value(id),
      name: Value(name),
      dose: dose == null && nullToAbsent ? const Value.absent() : Value(dose),
      timing: timing == null && nullToAbsent
          ? const Value.absent()
          : Value(timing),
      proteinG: Value(proteinG),
      calories: Value(calories),
      carbsG: Value(carbsG),
      fatG: Value(fatG),
      active: Value(active),
    );
  }

  factory Supplement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Supplement(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      dose: serializer.fromJson<String?>(json['dose']),
      timing: serializer.fromJson<String?>(json['timing']),
      proteinG: serializer.fromJson<double>(json['proteinG']),
      calories: serializer.fromJson<double>(json['calories']),
      carbsG: serializer.fromJson<double>(json['carbsG']),
      fatG: serializer.fromJson<double>(json['fatG']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'dose': serializer.toJson<String?>(dose),
      'timing': serializer.toJson<String?>(timing),
      'proteinG': serializer.toJson<double>(proteinG),
      'calories': serializer.toJson<double>(calories),
      'carbsG': serializer.toJson<double>(carbsG),
      'fatG': serializer.toJson<double>(fatG),
      'active': serializer.toJson<bool>(active),
    };
  }

  Supplement copyWith({
    int? id,
    String? name,
    Value<String?> dose = const Value.absent(),
    Value<String?> timing = const Value.absent(),
    double? proteinG,
    double? calories,
    double? carbsG,
    double? fatG,
    bool? active,
  }) => Supplement(
    id: id ?? this.id,
    name: name ?? this.name,
    dose: dose.present ? dose.value : this.dose,
    timing: timing.present ? timing.value : this.timing,
    proteinG: proteinG ?? this.proteinG,
    calories: calories ?? this.calories,
    carbsG: carbsG ?? this.carbsG,
    fatG: fatG ?? this.fatG,
    active: active ?? this.active,
  );
  Supplement copyWithCompanion(SupplementsCompanion data) {
    return Supplement(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      dose: data.dose.present ? data.dose.value : this.dose,
      timing: data.timing.present ? data.timing.value : this.timing,
      proteinG: data.proteinG.present ? data.proteinG.value : this.proteinG,
      calories: data.calories.present ? data.calories.value : this.calories,
      carbsG: data.carbsG.present ? data.carbsG.value : this.carbsG,
      fatG: data.fatG.present ? data.fatG.value : this.fatG,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Supplement(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dose: $dose, ')
          ..write('timing: $timing, ')
          ..write('proteinG: $proteinG, ')
          ..write('calories: $calories, ')
          ..write('carbsG: $carbsG, ')
          ..write('fatG: $fatG, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    dose,
    timing,
    proteinG,
    calories,
    carbsG,
    fatG,
    active,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Supplement &&
          other.id == this.id &&
          other.name == this.name &&
          other.dose == this.dose &&
          other.timing == this.timing &&
          other.proteinG == this.proteinG &&
          other.calories == this.calories &&
          other.carbsG == this.carbsG &&
          other.fatG == this.fatG &&
          other.active == this.active);
}

class SupplementsCompanion extends UpdateCompanion<Supplement> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> dose;
  final Value<String?> timing;
  final Value<double> proteinG;
  final Value<double> calories;
  final Value<double> carbsG;
  final Value<double> fatG;
  final Value<bool> active;
  const SupplementsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.dose = const Value.absent(),
    this.timing = const Value.absent(),
    this.proteinG = const Value.absent(),
    this.calories = const Value.absent(),
    this.carbsG = const Value.absent(),
    this.fatG = const Value.absent(),
    this.active = const Value.absent(),
  });
  SupplementsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.dose = const Value.absent(),
    this.timing = const Value.absent(),
    this.proteinG = const Value.absent(),
    this.calories = const Value.absent(),
    this.carbsG = const Value.absent(),
    this.fatG = const Value.absent(),
    this.active = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Supplement> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? dose,
    Expression<String>? timing,
    Expression<double>? proteinG,
    Expression<double>? calories,
    Expression<double>? carbsG,
    Expression<double>? fatG,
    Expression<bool>? active,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (dose != null) 'dose': dose,
      if (timing != null) 'timing': timing,
      if (proteinG != null) 'protein_g': proteinG,
      if (calories != null) 'calories': calories,
      if (carbsG != null) 'carbs_g': carbsG,
      if (fatG != null) 'fat_g': fatG,
      if (active != null) 'active': active,
    });
  }

  SupplementsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? dose,
    Value<String?>? timing,
    Value<double>? proteinG,
    Value<double>? calories,
    Value<double>? carbsG,
    Value<double>? fatG,
    Value<bool>? active,
  }) {
    return SupplementsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      dose: dose ?? this.dose,
      timing: timing ?? this.timing,
      proteinG: proteinG ?? this.proteinG,
      calories: calories ?? this.calories,
      carbsG: carbsG ?? this.carbsG,
      fatG: fatG ?? this.fatG,
      active: active ?? this.active,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (dose.present) {
      map['dose'] = Variable<String>(dose.value);
    }
    if (timing.present) {
      map['timing'] = Variable<String>(timing.value);
    }
    if (proteinG.present) {
      map['protein_g'] = Variable<double>(proteinG.value);
    }
    if (calories.present) {
      map['calories'] = Variable<double>(calories.value);
    }
    if (carbsG.present) {
      map['carbs_g'] = Variable<double>(carbsG.value);
    }
    if (fatG.present) {
      map['fat_g'] = Variable<double>(fatG.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SupplementsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dose: $dose, ')
          ..write('timing: $timing, ')
          ..write('proteinG: $proteinG, ')
          ..write('calories: $calories, ')
          ..write('carbsG: $carbsG, ')
          ..write('fatG: $fatG, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }
}

class $SupplementLogsTable extends SupplementLogs
    with TableInfo<$SupplementLogsTable, SupplementLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SupplementLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _supplementIdMeta = const VerificationMeta(
    'supplementId',
  );
  @override
  late final GeneratedColumn<int> supplementId = GeneratedColumn<int>(
    'supplement_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES supplements (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _takenMeta = const VerificationMeta('taken');
  @override
  late final GeneratedColumn<bool> taken = GeneratedColumn<bool>(
    'taken',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("taken" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('manual'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, date, supplementId, taken, source];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'supplement_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<SupplementLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('supplement_id')) {
      context.handle(
        _supplementIdMeta,
        supplementId.isAcceptableOrUnknown(
          data['supplement_id']!,
          _supplementIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_supplementIdMeta);
    }
    if (data.containsKey('taken')) {
      context.handle(
        _takenMeta,
        taken.isAcceptableOrUnknown(data['taken']!, _takenMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SupplementLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SupplementLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      supplementId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}supplement_id'],
      )!,
      taken: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}taken'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
    );
  }

  @override
  $SupplementLogsTable createAlias(String alias) {
    return $SupplementLogsTable(attachedDatabase, alias);
  }
}

class SupplementLog extends DataClass implements Insertable<SupplementLog> {
  final int id;
  final DateTime date;
  final int supplementId;
  final bool taken;
  final String source;
  const SupplementLog({
    required this.id,
    required this.date,
    required this.supplementId,
    required this.taken,
    required this.source,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['supplement_id'] = Variable<int>(supplementId);
    map['taken'] = Variable<bool>(taken);
    map['source'] = Variable<String>(source);
    return map;
  }

  SupplementLogsCompanion toCompanion(bool nullToAbsent) {
    return SupplementLogsCompanion(
      id: Value(id),
      date: Value(date),
      supplementId: Value(supplementId),
      taken: Value(taken),
      source: Value(source),
    );
  }

  factory SupplementLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SupplementLog(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      supplementId: serializer.fromJson<int>(json['supplementId']),
      taken: serializer.fromJson<bool>(json['taken']),
      source: serializer.fromJson<String>(json['source']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'supplementId': serializer.toJson<int>(supplementId),
      'taken': serializer.toJson<bool>(taken),
      'source': serializer.toJson<String>(source),
    };
  }

  SupplementLog copyWith({
    int? id,
    DateTime? date,
    int? supplementId,
    bool? taken,
    String? source,
  }) => SupplementLog(
    id: id ?? this.id,
    date: date ?? this.date,
    supplementId: supplementId ?? this.supplementId,
    taken: taken ?? this.taken,
    source: source ?? this.source,
  );
  SupplementLog copyWithCompanion(SupplementLogsCompanion data) {
    return SupplementLog(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      supplementId: data.supplementId.present
          ? data.supplementId.value
          : this.supplementId,
      taken: data.taken.present ? data.taken.value : this.taken,
      source: data.source.present ? data.source.value : this.source,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SupplementLog(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('supplementId: $supplementId, ')
          ..write('taken: $taken, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, supplementId, taken, source);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SupplementLog &&
          other.id == this.id &&
          other.date == this.date &&
          other.supplementId == this.supplementId &&
          other.taken == this.taken &&
          other.source == this.source);
}

class SupplementLogsCompanion extends UpdateCompanion<SupplementLog> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<int> supplementId;
  final Value<bool> taken;
  final Value<String> source;
  const SupplementLogsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.supplementId = const Value.absent(),
    this.taken = const Value.absent(),
    this.source = const Value.absent(),
  });
  SupplementLogsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required int supplementId,
    this.taken = const Value.absent(),
    this.source = const Value.absent(),
  }) : date = Value(date),
       supplementId = Value(supplementId);
  static Insertable<SupplementLog> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<int>? supplementId,
    Expression<bool>? taken,
    Expression<String>? source,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (supplementId != null) 'supplement_id': supplementId,
      if (taken != null) 'taken': taken,
      if (source != null) 'source': source,
    });
  }

  SupplementLogsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<int>? supplementId,
    Value<bool>? taken,
    Value<String>? source,
  }) {
    return SupplementLogsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      supplementId: supplementId ?? this.supplementId,
      taken: taken ?? this.taken,
      source: source ?? this.source,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (supplementId.present) {
      map['supplement_id'] = Variable<int>(supplementId.value);
    }
    if (taken.present) {
      map['taken'] = Variable<bool>(taken.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SupplementLogsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('supplementId: $supplementId, ')
          ..write('taken: $taken, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }
}

class $SleepLogsTable extends SleepLogs
    with TableInfo<$SleepLogsTable, SleepLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SleepLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startMeta = const VerificationMeta('start');
  @override
  late final GeneratedColumn<DateTime> start = GeneratedColumn<DateTime>(
    'start',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endMeta = const VerificationMeta('end');
  @override
  late final GeneratedColumn<DateTime> end = GeneratedColumn<DateTime>(
    'end',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMinMeta = const VerificationMeta(
    'durationMin',
  );
  @override
  late final GeneratedColumn<int> durationMin = GeneratedColumn<int>(
    'duration_min',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qualityMeta = const VerificationMeta(
    'quality',
  );
  @override
  late final GeneratedColumn<int> quality = GeneratedColumn<int>(
    'quality',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deepMinMeta = const VerificationMeta(
    'deepMin',
  );
  @override
  late final GeneratedColumn<int> deepMin = GeneratedColumn<int>(
    'deep_min',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remMinMeta = const VerificationMeta('remMin');
  @override
  late final GeneratedColumn<int> remMin = GeneratedColumn<int>(
    'rem_min',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lightMinMeta = const VerificationMeta(
    'lightMin',
  );
  @override
  late final GeneratedColumn<int> lightMin = GeneratedColumn<int>(
    'light_min',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _awakeMinMeta = const VerificationMeta(
    'awakeMin',
  );
  @override
  late final GeneratedColumn<int> awakeMin = GeneratedColumn<int>(
    'awake_min',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('manual'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    start,
    end,
    durationMin,
    quality,
    deepMin,
    remMin,
    lightMin,
    awakeMin,
    source,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sleep_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<SleepLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('start')) {
      context.handle(
        _startMeta,
        start.isAcceptableOrUnknown(data['start']!, _startMeta),
      );
    }
    if (data.containsKey('end')) {
      context.handle(
        _endMeta,
        end.isAcceptableOrUnknown(data['end']!, _endMeta),
      );
    }
    if (data.containsKey('duration_min')) {
      context.handle(
        _durationMinMeta,
        durationMin.isAcceptableOrUnknown(
          data['duration_min']!,
          _durationMinMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationMinMeta);
    }
    if (data.containsKey('quality')) {
      context.handle(
        _qualityMeta,
        quality.isAcceptableOrUnknown(data['quality']!, _qualityMeta),
      );
    }
    if (data.containsKey('deep_min')) {
      context.handle(
        _deepMinMeta,
        deepMin.isAcceptableOrUnknown(data['deep_min']!, _deepMinMeta),
      );
    }
    if (data.containsKey('rem_min')) {
      context.handle(
        _remMinMeta,
        remMin.isAcceptableOrUnknown(data['rem_min']!, _remMinMeta),
      );
    }
    if (data.containsKey('light_min')) {
      context.handle(
        _lightMinMeta,
        lightMin.isAcceptableOrUnknown(data['light_min']!, _lightMinMeta),
      );
    }
    if (data.containsKey('awake_min')) {
      context.handle(
        _awakeMinMeta,
        awakeMin.isAcceptableOrUnknown(data['awake_min']!, _awakeMinMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SleepLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SleepLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      start: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start'],
      ),
      end: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end'],
      ),
      durationMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_min'],
      )!,
      quality: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quality'],
      ),
      deepMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deep_min'],
      ),
      remMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rem_min'],
      ),
      lightMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}light_min'],
      ),
      awakeMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}awake_min'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
    );
  }

  @override
  $SleepLogsTable createAlias(String alias) {
    return $SleepLogsTable(attachedDatabase, alias);
  }
}

class SleepLog extends DataClass implements Insertable<SleepLog> {
  final int id;
  final DateTime date;
  final DateTime? start;
  final DateTime? end;
  final int durationMin;
  final int? quality;
  final int? deepMin;
  final int? remMin;
  final int? lightMin;
  final int? awakeMin;
  final String source;
  const SleepLog({
    required this.id,
    required this.date,
    this.start,
    this.end,
    required this.durationMin,
    this.quality,
    this.deepMin,
    this.remMin,
    this.lightMin,
    this.awakeMin,
    required this.source,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || start != null) {
      map['start'] = Variable<DateTime>(start);
    }
    if (!nullToAbsent || end != null) {
      map['end'] = Variable<DateTime>(end);
    }
    map['duration_min'] = Variable<int>(durationMin);
    if (!nullToAbsent || quality != null) {
      map['quality'] = Variable<int>(quality);
    }
    if (!nullToAbsent || deepMin != null) {
      map['deep_min'] = Variable<int>(deepMin);
    }
    if (!nullToAbsent || remMin != null) {
      map['rem_min'] = Variable<int>(remMin);
    }
    if (!nullToAbsent || lightMin != null) {
      map['light_min'] = Variable<int>(lightMin);
    }
    if (!nullToAbsent || awakeMin != null) {
      map['awake_min'] = Variable<int>(awakeMin);
    }
    map['source'] = Variable<String>(source);
    return map;
  }

  SleepLogsCompanion toCompanion(bool nullToAbsent) {
    return SleepLogsCompanion(
      id: Value(id),
      date: Value(date),
      start: start == null && nullToAbsent
          ? const Value.absent()
          : Value(start),
      end: end == null && nullToAbsent ? const Value.absent() : Value(end),
      durationMin: Value(durationMin),
      quality: quality == null && nullToAbsent
          ? const Value.absent()
          : Value(quality),
      deepMin: deepMin == null && nullToAbsent
          ? const Value.absent()
          : Value(deepMin),
      remMin: remMin == null && nullToAbsent
          ? const Value.absent()
          : Value(remMin),
      lightMin: lightMin == null && nullToAbsent
          ? const Value.absent()
          : Value(lightMin),
      awakeMin: awakeMin == null && nullToAbsent
          ? const Value.absent()
          : Value(awakeMin),
      source: Value(source),
    );
  }

  factory SleepLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SleepLog(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      start: serializer.fromJson<DateTime?>(json['start']),
      end: serializer.fromJson<DateTime?>(json['end']),
      durationMin: serializer.fromJson<int>(json['durationMin']),
      quality: serializer.fromJson<int?>(json['quality']),
      deepMin: serializer.fromJson<int?>(json['deepMin']),
      remMin: serializer.fromJson<int?>(json['remMin']),
      lightMin: serializer.fromJson<int?>(json['lightMin']),
      awakeMin: serializer.fromJson<int?>(json['awakeMin']),
      source: serializer.fromJson<String>(json['source']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'start': serializer.toJson<DateTime?>(start),
      'end': serializer.toJson<DateTime?>(end),
      'durationMin': serializer.toJson<int>(durationMin),
      'quality': serializer.toJson<int?>(quality),
      'deepMin': serializer.toJson<int?>(deepMin),
      'remMin': serializer.toJson<int?>(remMin),
      'lightMin': serializer.toJson<int?>(lightMin),
      'awakeMin': serializer.toJson<int?>(awakeMin),
      'source': serializer.toJson<String>(source),
    };
  }

  SleepLog copyWith({
    int? id,
    DateTime? date,
    Value<DateTime?> start = const Value.absent(),
    Value<DateTime?> end = const Value.absent(),
    int? durationMin,
    Value<int?> quality = const Value.absent(),
    Value<int?> deepMin = const Value.absent(),
    Value<int?> remMin = const Value.absent(),
    Value<int?> lightMin = const Value.absent(),
    Value<int?> awakeMin = const Value.absent(),
    String? source,
  }) => SleepLog(
    id: id ?? this.id,
    date: date ?? this.date,
    start: start.present ? start.value : this.start,
    end: end.present ? end.value : this.end,
    durationMin: durationMin ?? this.durationMin,
    quality: quality.present ? quality.value : this.quality,
    deepMin: deepMin.present ? deepMin.value : this.deepMin,
    remMin: remMin.present ? remMin.value : this.remMin,
    lightMin: lightMin.present ? lightMin.value : this.lightMin,
    awakeMin: awakeMin.present ? awakeMin.value : this.awakeMin,
    source: source ?? this.source,
  );
  SleepLog copyWithCompanion(SleepLogsCompanion data) {
    return SleepLog(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      start: data.start.present ? data.start.value : this.start,
      end: data.end.present ? data.end.value : this.end,
      durationMin: data.durationMin.present
          ? data.durationMin.value
          : this.durationMin,
      quality: data.quality.present ? data.quality.value : this.quality,
      deepMin: data.deepMin.present ? data.deepMin.value : this.deepMin,
      remMin: data.remMin.present ? data.remMin.value : this.remMin,
      lightMin: data.lightMin.present ? data.lightMin.value : this.lightMin,
      awakeMin: data.awakeMin.present ? data.awakeMin.value : this.awakeMin,
      source: data.source.present ? data.source.value : this.source,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SleepLog(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('start: $start, ')
          ..write('end: $end, ')
          ..write('durationMin: $durationMin, ')
          ..write('quality: $quality, ')
          ..write('deepMin: $deepMin, ')
          ..write('remMin: $remMin, ')
          ..write('lightMin: $lightMin, ')
          ..write('awakeMin: $awakeMin, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    start,
    end,
    durationMin,
    quality,
    deepMin,
    remMin,
    lightMin,
    awakeMin,
    source,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SleepLog &&
          other.id == this.id &&
          other.date == this.date &&
          other.start == this.start &&
          other.end == this.end &&
          other.durationMin == this.durationMin &&
          other.quality == this.quality &&
          other.deepMin == this.deepMin &&
          other.remMin == this.remMin &&
          other.lightMin == this.lightMin &&
          other.awakeMin == this.awakeMin &&
          other.source == this.source);
}

class SleepLogsCompanion extends UpdateCompanion<SleepLog> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<DateTime?> start;
  final Value<DateTime?> end;
  final Value<int> durationMin;
  final Value<int?> quality;
  final Value<int?> deepMin;
  final Value<int?> remMin;
  final Value<int?> lightMin;
  final Value<int?> awakeMin;
  final Value<String> source;
  const SleepLogsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.start = const Value.absent(),
    this.end = const Value.absent(),
    this.durationMin = const Value.absent(),
    this.quality = const Value.absent(),
    this.deepMin = const Value.absent(),
    this.remMin = const Value.absent(),
    this.lightMin = const Value.absent(),
    this.awakeMin = const Value.absent(),
    this.source = const Value.absent(),
  });
  SleepLogsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    this.start = const Value.absent(),
    this.end = const Value.absent(),
    required int durationMin,
    this.quality = const Value.absent(),
    this.deepMin = const Value.absent(),
    this.remMin = const Value.absent(),
    this.lightMin = const Value.absent(),
    this.awakeMin = const Value.absent(),
    this.source = const Value.absent(),
  }) : date = Value(date),
       durationMin = Value(durationMin);
  static Insertable<SleepLog> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<DateTime>? start,
    Expression<DateTime>? end,
    Expression<int>? durationMin,
    Expression<int>? quality,
    Expression<int>? deepMin,
    Expression<int>? remMin,
    Expression<int>? lightMin,
    Expression<int>? awakeMin,
    Expression<String>? source,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (start != null) 'start': start,
      if (end != null) 'end': end,
      if (durationMin != null) 'duration_min': durationMin,
      if (quality != null) 'quality': quality,
      if (deepMin != null) 'deep_min': deepMin,
      if (remMin != null) 'rem_min': remMin,
      if (lightMin != null) 'light_min': lightMin,
      if (awakeMin != null) 'awake_min': awakeMin,
      if (source != null) 'source': source,
    });
  }

  SleepLogsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<DateTime?>? start,
    Value<DateTime?>? end,
    Value<int>? durationMin,
    Value<int?>? quality,
    Value<int?>? deepMin,
    Value<int?>? remMin,
    Value<int?>? lightMin,
    Value<int?>? awakeMin,
    Value<String>? source,
  }) {
    return SleepLogsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      start: start ?? this.start,
      end: end ?? this.end,
      durationMin: durationMin ?? this.durationMin,
      quality: quality ?? this.quality,
      deepMin: deepMin ?? this.deepMin,
      remMin: remMin ?? this.remMin,
      lightMin: lightMin ?? this.lightMin,
      awakeMin: awakeMin ?? this.awakeMin,
      source: source ?? this.source,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (start.present) {
      map['start'] = Variable<DateTime>(start.value);
    }
    if (end.present) {
      map['end'] = Variable<DateTime>(end.value);
    }
    if (durationMin.present) {
      map['duration_min'] = Variable<int>(durationMin.value);
    }
    if (quality.present) {
      map['quality'] = Variable<int>(quality.value);
    }
    if (deepMin.present) {
      map['deep_min'] = Variable<int>(deepMin.value);
    }
    if (remMin.present) {
      map['rem_min'] = Variable<int>(remMin.value);
    }
    if (lightMin.present) {
      map['light_min'] = Variable<int>(lightMin.value);
    }
    if (awakeMin.present) {
      map['awake_min'] = Variable<int>(awakeMin.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SleepLogsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('start: $start, ')
          ..write('end: $end, ')
          ..write('durationMin: $durationMin, ')
          ..write('quality: $quality, ')
          ..write('deepMin: $deepMin, ')
          ..write('remMin: $remMin, ')
          ..write('lightMin: $lightMin, ')
          ..write('awakeMin: $awakeMin, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }
}

class $HealthDailyTable extends HealthDaily
    with TableInfo<$HealthDailyTable, HealthDailyData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HealthDailyTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _stepsMeta = const VerificationMeta('steps');
  @override
  late final GeneratedColumn<int> steps = GeneratedColumn<int>(
    'steps',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _restingHrMeta = const VerificationMeta(
    'restingHr',
  );
  @override
  late final GeneratedColumn<double> restingHr = GeneratedColumn<double>(
    'resting_hr',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avgHrMeta = const VerificationMeta('avgHr');
  @override
  late final GeneratedColumn<double> avgHr = GeneratedColumn<double>(
    'avg_hr',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hrvMeta = const VerificationMeta('hrv');
  @override
  late final GeneratedColumn<double> hrv = GeneratedColumn<double>(
    'hrv',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activeCaloriesMeta = const VerificationMeta(
    'activeCalories',
  );
  @override
  late final GeneratedColumn<double> activeCalories = GeneratedColumn<double>(
    'active_calories',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recoveryScoreMeta = const VerificationMeta(
    'recoveryScore',
  );
  @override
  late final GeneratedColumn<int> recoveryScore = GeneratedColumn<int>(
    'recovery_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourcesJsonMeta = const VerificationMeta(
    'sourcesJson',
  );
  @override
  late final GeneratedColumn<String> sourcesJson = GeneratedColumn<String>(
    'sources_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    steps,
    restingHr,
    avgHr,
    hrv,
    activeCalories,
    recoveryScore,
    sourcesJson,
    lastSyncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'health_daily';
  @override
  VerificationContext validateIntegrity(
    Insertable<HealthDailyData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('steps')) {
      context.handle(
        _stepsMeta,
        steps.isAcceptableOrUnknown(data['steps']!, _stepsMeta),
      );
    }
    if (data.containsKey('resting_hr')) {
      context.handle(
        _restingHrMeta,
        restingHr.isAcceptableOrUnknown(data['resting_hr']!, _restingHrMeta),
      );
    }
    if (data.containsKey('avg_hr')) {
      context.handle(
        _avgHrMeta,
        avgHr.isAcceptableOrUnknown(data['avg_hr']!, _avgHrMeta),
      );
    }
    if (data.containsKey('hrv')) {
      context.handle(
        _hrvMeta,
        hrv.isAcceptableOrUnknown(data['hrv']!, _hrvMeta),
      );
    }
    if (data.containsKey('active_calories')) {
      context.handle(
        _activeCaloriesMeta,
        activeCalories.isAcceptableOrUnknown(
          data['active_calories']!,
          _activeCaloriesMeta,
        ),
      );
    }
    if (data.containsKey('recovery_score')) {
      context.handle(
        _recoveryScoreMeta,
        recoveryScore.isAcceptableOrUnknown(
          data['recovery_score']!,
          _recoveryScoreMeta,
        ),
      );
    }
    if (data.containsKey('sources_json')) {
      context.handle(
        _sourcesJsonMeta,
        sourcesJson.isAcceptableOrUnknown(
          data['sources_json']!,
          _sourcesJsonMeta,
        ),
      );
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HealthDailyData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HealthDailyData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      steps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}steps'],
      ),
      restingHr: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}resting_hr'],
      ),
      avgHr: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}avg_hr'],
      ),
      hrv: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}hrv'],
      ),
      activeCalories: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}active_calories'],
      ),
      recoveryScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recovery_score'],
      ),
      sourcesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sources_json'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
    );
  }

  @override
  $HealthDailyTable createAlias(String alias) {
    return $HealthDailyTable(attachedDatabase, alias);
  }
}

class HealthDailyData extends DataClass implements Insertable<HealthDailyData> {
  final int id;
  final DateTime date;
  final int? steps;
  final double? restingHr;
  final double? avgHr;
  final double? hrv;
  final double? activeCalories;
  final int? recoveryScore;
  final String sourcesJson;
  final DateTime? lastSyncedAt;
  const HealthDailyData({
    required this.id,
    required this.date,
    this.steps,
    this.restingHr,
    this.avgHr,
    this.hrv,
    this.activeCalories,
    this.recoveryScore,
    required this.sourcesJson,
    this.lastSyncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || steps != null) {
      map['steps'] = Variable<int>(steps);
    }
    if (!nullToAbsent || restingHr != null) {
      map['resting_hr'] = Variable<double>(restingHr);
    }
    if (!nullToAbsent || avgHr != null) {
      map['avg_hr'] = Variable<double>(avgHr);
    }
    if (!nullToAbsent || hrv != null) {
      map['hrv'] = Variable<double>(hrv);
    }
    if (!nullToAbsent || activeCalories != null) {
      map['active_calories'] = Variable<double>(activeCalories);
    }
    if (!nullToAbsent || recoveryScore != null) {
      map['recovery_score'] = Variable<int>(recoveryScore);
    }
    map['sources_json'] = Variable<String>(sourcesJson);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    return map;
  }

  HealthDailyCompanion toCompanion(bool nullToAbsent) {
    return HealthDailyCompanion(
      id: Value(id),
      date: Value(date),
      steps: steps == null && nullToAbsent
          ? const Value.absent()
          : Value(steps),
      restingHr: restingHr == null && nullToAbsent
          ? const Value.absent()
          : Value(restingHr),
      avgHr: avgHr == null && nullToAbsent
          ? const Value.absent()
          : Value(avgHr),
      hrv: hrv == null && nullToAbsent ? const Value.absent() : Value(hrv),
      activeCalories: activeCalories == null && nullToAbsent
          ? const Value.absent()
          : Value(activeCalories),
      recoveryScore: recoveryScore == null && nullToAbsent
          ? const Value.absent()
          : Value(recoveryScore),
      sourcesJson: Value(sourcesJson),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
    );
  }

  factory HealthDailyData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HealthDailyData(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      steps: serializer.fromJson<int?>(json['steps']),
      restingHr: serializer.fromJson<double?>(json['restingHr']),
      avgHr: serializer.fromJson<double?>(json['avgHr']),
      hrv: serializer.fromJson<double?>(json['hrv']),
      activeCalories: serializer.fromJson<double?>(json['activeCalories']),
      recoveryScore: serializer.fromJson<int?>(json['recoveryScore']),
      sourcesJson: serializer.fromJson<String>(json['sourcesJson']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'steps': serializer.toJson<int?>(steps),
      'restingHr': serializer.toJson<double?>(restingHr),
      'avgHr': serializer.toJson<double?>(avgHr),
      'hrv': serializer.toJson<double?>(hrv),
      'activeCalories': serializer.toJson<double?>(activeCalories),
      'recoveryScore': serializer.toJson<int?>(recoveryScore),
      'sourcesJson': serializer.toJson<String>(sourcesJson),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
    };
  }

  HealthDailyData copyWith({
    int? id,
    DateTime? date,
    Value<int?> steps = const Value.absent(),
    Value<double?> restingHr = const Value.absent(),
    Value<double?> avgHr = const Value.absent(),
    Value<double?> hrv = const Value.absent(),
    Value<double?> activeCalories = const Value.absent(),
    Value<int?> recoveryScore = const Value.absent(),
    String? sourcesJson,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
  }) => HealthDailyData(
    id: id ?? this.id,
    date: date ?? this.date,
    steps: steps.present ? steps.value : this.steps,
    restingHr: restingHr.present ? restingHr.value : this.restingHr,
    avgHr: avgHr.present ? avgHr.value : this.avgHr,
    hrv: hrv.present ? hrv.value : this.hrv,
    activeCalories: activeCalories.present
        ? activeCalories.value
        : this.activeCalories,
    recoveryScore: recoveryScore.present
        ? recoveryScore.value
        : this.recoveryScore,
    sourcesJson: sourcesJson ?? this.sourcesJson,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
  );
  HealthDailyData copyWithCompanion(HealthDailyCompanion data) {
    return HealthDailyData(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      steps: data.steps.present ? data.steps.value : this.steps,
      restingHr: data.restingHr.present ? data.restingHr.value : this.restingHr,
      avgHr: data.avgHr.present ? data.avgHr.value : this.avgHr,
      hrv: data.hrv.present ? data.hrv.value : this.hrv,
      activeCalories: data.activeCalories.present
          ? data.activeCalories.value
          : this.activeCalories,
      recoveryScore: data.recoveryScore.present
          ? data.recoveryScore.value
          : this.recoveryScore,
      sourcesJson: data.sourcesJson.present
          ? data.sourcesJson.value
          : this.sourcesJson,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HealthDailyData(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('steps: $steps, ')
          ..write('restingHr: $restingHr, ')
          ..write('avgHr: $avgHr, ')
          ..write('hrv: $hrv, ')
          ..write('activeCalories: $activeCalories, ')
          ..write('recoveryScore: $recoveryScore, ')
          ..write('sourcesJson: $sourcesJson, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    steps,
    restingHr,
    avgHr,
    hrv,
    activeCalories,
    recoveryScore,
    sourcesJson,
    lastSyncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HealthDailyData &&
          other.id == this.id &&
          other.date == this.date &&
          other.steps == this.steps &&
          other.restingHr == this.restingHr &&
          other.avgHr == this.avgHr &&
          other.hrv == this.hrv &&
          other.activeCalories == this.activeCalories &&
          other.recoveryScore == this.recoveryScore &&
          other.sourcesJson == this.sourcesJson &&
          other.lastSyncedAt == this.lastSyncedAt);
}

class HealthDailyCompanion extends UpdateCompanion<HealthDailyData> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<int?> steps;
  final Value<double?> restingHr;
  final Value<double?> avgHr;
  final Value<double?> hrv;
  final Value<double?> activeCalories;
  final Value<int?> recoveryScore;
  final Value<String> sourcesJson;
  final Value<DateTime?> lastSyncedAt;
  const HealthDailyCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.steps = const Value.absent(),
    this.restingHr = const Value.absent(),
    this.avgHr = const Value.absent(),
    this.hrv = const Value.absent(),
    this.activeCalories = const Value.absent(),
    this.recoveryScore = const Value.absent(),
    this.sourcesJson = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
  });
  HealthDailyCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    this.steps = const Value.absent(),
    this.restingHr = const Value.absent(),
    this.avgHr = const Value.absent(),
    this.hrv = const Value.absent(),
    this.activeCalories = const Value.absent(),
    this.recoveryScore = const Value.absent(),
    this.sourcesJson = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
  }) : date = Value(date);
  static Insertable<HealthDailyData> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<int>? steps,
    Expression<double>? restingHr,
    Expression<double>? avgHr,
    Expression<double>? hrv,
    Expression<double>? activeCalories,
    Expression<int>? recoveryScore,
    Expression<String>? sourcesJson,
    Expression<DateTime>? lastSyncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (steps != null) 'steps': steps,
      if (restingHr != null) 'resting_hr': restingHr,
      if (avgHr != null) 'avg_hr': avgHr,
      if (hrv != null) 'hrv': hrv,
      if (activeCalories != null) 'active_calories': activeCalories,
      if (recoveryScore != null) 'recovery_score': recoveryScore,
      if (sourcesJson != null) 'sources_json': sourcesJson,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
    });
  }

  HealthDailyCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<int?>? steps,
    Value<double?>? restingHr,
    Value<double?>? avgHr,
    Value<double?>? hrv,
    Value<double?>? activeCalories,
    Value<int?>? recoveryScore,
    Value<String>? sourcesJson,
    Value<DateTime?>? lastSyncedAt,
  }) {
    return HealthDailyCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      steps: steps ?? this.steps,
      restingHr: restingHr ?? this.restingHr,
      avgHr: avgHr ?? this.avgHr,
      hrv: hrv ?? this.hrv,
      activeCalories: activeCalories ?? this.activeCalories,
      recoveryScore: recoveryScore ?? this.recoveryScore,
      sourcesJson: sourcesJson ?? this.sourcesJson,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (steps.present) {
      map['steps'] = Variable<int>(steps.value);
    }
    if (restingHr.present) {
      map['resting_hr'] = Variable<double>(restingHr.value);
    }
    if (avgHr.present) {
      map['avg_hr'] = Variable<double>(avgHr.value);
    }
    if (hrv.present) {
      map['hrv'] = Variable<double>(hrv.value);
    }
    if (activeCalories.present) {
      map['active_calories'] = Variable<double>(activeCalories.value);
    }
    if (recoveryScore.present) {
      map['recovery_score'] = Variable<int>(recoveryScore.value);
    }
    if (sourcesJson.present) {
      map['sources_json'] = Variable<String>(sourcesJson.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HealthDailyCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('steps: $steps, ')
          ..write('restingHr: $restingHr, ')
          ..write('avgHr: $avgHr, ')
          ..write('hrv: $hrv, ')
          ..write('activeCalories: $activeCalories, ')
          ..write('recoveryScore: $recoveryScore, ')
          ..write('sourcesJson: $sourcesJson, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }
}

class $CoachMessagesTable extends CoachMessages
    with TableInfo<$CoachMessagesTable, CoachMessage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CoachMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('chat'),
  );
  static const VerificationMeta _metaJsonMeta = const VerificationMeta(
    'metaJson',
  );
  @override
  late final GeneratedColumn<String> metaJson = GeneratedColumn<String>(
    'meta_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  @override
  late final GeneratedColumn<bool> isRead = GeneratedColumn<bool>(
    'is_read',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_read" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    role,
    content,
    kind,
    metaJson,
    isRead,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'coach_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<CoachMessage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    }
    if (data.containsKey('meta_json')) {
      context.handle(
        _metaJsonMeta,
        metaJson.isAcceptableOrUnknown(data['meta_json']!, _metaJsonMeta),
      );
    }
    if (data.containsKey('is_read')) {
      context.handle(
        _isReadMeta,
        isRead.isAcceptableOrUnknown(data['is_read']!, _isReadMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CoachMessage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CoachMessage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      metaJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meta_json'],
      ),
      isRead: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_read'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CoachMessagesTable createAlias(String alias) {
    return $CoachMessagesTable(attachedDatabase, alias);
  }
}

class CoachMessage extends DataClass implements Insertable<CoachMessage> {
  final int id;
  final String role;
  final String content;
  final String kind;
  final String? metaJson;
  final bool isRead;
  final DateTime createdAt;
  const CoachMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.kind,
    this.metaJson,
    required this.isRead,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['role'] = Variable<String>(role);
    map['content'] = Variable<String>(content);
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || metaJson != null) {
      map['meta_json'] = Variable<String>(metaJson);
    }
    map['is_read'] = Variable<bool>(isRead);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CoachMessagesCompanion toCompanion(bool nullToAbsent) {
    return CoachMessagesCompanion(
      id: Value(id),
      role: Value(role),
      content: Value(content),
      kind: Value(kind),
      metaJson: metaJson == null && nullToAbsent
          ? const Value.absent()
          : Value(metaJson),
      isRead: Value(isRead),
      createdAt: Value(createdAt),
    );
  }

  factory CoachMessage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CoachMessage(
      id: serializer.fromJson<int>(json['id']),
      role: serializer.fromJson<String>(json['role']),
      content: serializer.fromJson<String>(json['content']),
      kind: serializer.fromJson<String>(json['kind']),
      metaJson: serializer.fromJson<String?>(json['metaJson']),
      isRead: serializer.fromJson<bool>(json['isRead']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'role': serializer.toJson<String>(role),
      'content': serializer.toJson<String>(content),
      'kind': serializer.toJson<String>(kind),
      'metaJson': serializer.toJson<String?>(metaJson),
      'isRead': serializer.toJson<bool>(isRead),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CoachMessage copyWith({
    int? id,
    String? role,
    String? content,
    String? kind,
    Value<String?> metaJson = const Value.absent(),
    bool? isRead,
    DateTime? createdAt,
  }) => CoachMessage(
    id: id ?? this.id,
    role: role ?? this.role,
    content: content ?? this.content,
    kind: kind ?? this.kind,
    metaJson: metaJson.present ? metaJson.value : this.metaJson,
    isRead: isRead ?? this.isRead,
    createdAt: createdAt ?? this.createdAt,
  );
  CoachMessage copyWithCompanion(CoachMessagesCompanion data) {
    return CoachMessage(
      id: data.id.present ? data.id.value : this.id,
      role: data.role.present ? data.role.value : this.role,
      content: data.content.present ? data.content.value : this.content,
      kind: data.kind.present ? data.kind.value : this.kind,
      metaJson: data.metaJson.present ? data.metaJson.value : this.metaJson,
      isRead: data.isRead.present ? data.isRead.value : this.isRead,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CoachMessage(')
          ..write('id: $id, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('kind: $kind, ')
          ..write('metaJson: $metaJson, ')
          ..write('isRead: $isRead, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, role, content, kind, metaJson, isRead, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CoachMessage &&
          other.id == this.id &&
          other.role == this.role &&
          other.content == this.content &&
          other.kind == this.kind &&
          other.metaJson == this.metaJson &&
          other.isRead == this.isRead &&
          other.createdAt == this.createdAt);
}

class CoachMessagesCompanion extends UpdateCompanion<CoachMessage> {
  final Value<int> id;
  final Value<String> role;
  final Value<String> content;
  final Value<String> kind;
  final Value<String?> metaJson;
  final Value<bool> isRead;
  final Value<DateTime> createdAt;
  const CoachMessagesCompanion({
    this.id = const Value.absent(),
    this.role = const Value.absent(),
    this.content = const Value.absent(),
    this.kind = const Value.absent(),
    this.metaJson = const Value.absent(),
    this.isRead = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CoachMessagesCompanion.insert({
    this.id = const Value.absent(),
    required String role,
    required String content,
    this.kind = const Value.absent(),
    this.metaJson = const Value.absent(),
    this.isRead = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : role = Value(role),
       content = Value(content);
  static Insertable<CoachMessage> custom({
    Expression<int>? id,
    Expression<String>? role,
    Expression<String>? content,
    Expression<String>? kind,
    Expression<String>? metaJson,
    Expression<bool>? isRead,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (role != null) 'role': role,
      if (content != null) 'content': content,
      if (kind != null) 'kind': kind,
      if (metaJson != null) 'meta_json': metaJson,
      if (isRead != null) 'is_read': isRead,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CoachMessagesCompanion copyWith({
    Value<int>? id,
    Value<String>? role,
    Value<String>? content,
    Value<String>? kind,
    Value<String?>? metaJson,
    Value<bool>? isRead,
    Value<DateTime>? createdAt,
  }) {
    return CoachMessagesCompanion(
      id: id ?? this.id,
      role: role ?? this.role,
      content: content ?? this.content,
      kind: kind ?? this.kind,
      metaJson: metaJson ?? this.metaJson,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (metaJson.present) {
      map['meta_json'] = Variable<String>(metaJson.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<bool>(isRead.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CoachMessagesCompanion(')
          ..write('id: $id, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('kind: $kind, ')
          ..write('metaJson: $metaJson, ')
          ..write('isRead: $isRead, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CoachMemoriesTable extends CoachMemories
    with TableInfo<$CoachMemoriesTable, CoachMemory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CoachMemoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('chat'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, content, source, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'coach_memories';
  @override
  VerificationContext validateIntegrity(
    Insertable<CoachMemory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CoachMemory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CoachMemory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CoachMemoriesTable createAlias(String alias) {
    return $CoachMemoriesTable(attachedDatabase, alias);
  }
}

class CoachMemory extends DataClass implements Insertable<CoachMemory> {
  final int id;
  final String content;
  final String source;
  final DateTime createdAt;
  const CoachMemory({
    required this.id,
    required this.content,
    required this.source,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['content'] = Variable<String>(content);
    map['source'] = Variable<String>(source);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CoachMemoriesCompanion toCompanion(bool nullToAbsent) {
    return CoachMemoriesCompanion(
      id: Value(id),
      content: Value(content),
      source: Value(source),
      createdAt: Value(createdAt),
    );
  }

  factory CoachMemory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CoachMemory(
      id: serializer.fromJson<int>(json['id']),
      content: serializer.fromJson<String>(json['content']),
      source: serializer.fromJson<String>(json['source']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'content': serializer.toJson<String>(content),
      'source': serializer.toJson<String>(source),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CoachMemory copyWith({
    int? id,
    String? content,
    String? source,
    DateTime? createdAt,
  }) => CoachMemory(
    id: id ?? this.id,
    content: content ?? this.content,
    source: source ?? this.source,
    createdAt: createdAt ?? this.createdAt,
  );
  CoachMemory copyWithCompanion(CoachMemoriesCompanion data) {
    return CoachMemory(
      id: data.id.present ? data.id.value : this.id,
      content: data.content.present ? data.content.value : this.content,
      source: data.source.present ? data.source.value : this.source,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CoachMemory(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, content, source, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CoachMemory &&
          other.id == this.id &&
          other.content == this.content &&
          other.source == this.source &&
          other.createdAt == this.createdAt);
}

class CoachMemoriesCompanion extends UpdateCompanion<CoachMemory> {
  final Value<int> id;
  final Value<String> content;
  final Value<String> source;
  final Value<DateTime> createdAt;
  const CoachMemoriesCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CoachMemoriesCompanion.insert({
    this.id = const Value.absent(),
    required String content,
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : content = Value(content);
  static Insertable<CoachMemory> custom({
    Expression<int>? id,
    Expression<String>? content,
    Expression<String>? source,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (content != null) 'content': content,
      if (source != null) 'source': source,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CoachMemoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? content,
    Value<String>? source,
    Value<DateTime>? createdAt,
  }) {
    return CoachMemoriesCompanion(
      id: id ?? this.id,
      content: content ?? this.content,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CoachMemoriesCompanion(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CoachProposalsTable extends CoachProposals
    with TableInfo<$CoachProposalsTable, CoachProposal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CoachProposalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _messageIdMeta = const VerificationMeta(
    'messageId',
  );
  @override
  late final GeneratedColumn<int> messageId = GeneratedColumn<int>(
    'message_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _resolvedAtMeta = const VerificationMeta(
    'resolvedAt',
  );
  @override
  late final GeneratedColumn<DateTime> resolvedAt = GeneratedColumn<DateTime>(
    'resolved_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    title,
    description,
    payloadJson,
    status,
    messageId,
    createdAt,
    resolvedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'coach_proposals';
  @override
  VerificationContext validateIntegrity(
    Insertable<CoachProposal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('message_id')) {
      context.handle(
        _messageIdMeta,
        messageId.isAcceptableOrUnknown(data['message_id']!, _messageIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('resolved_at')) {
      context.handle(
        _resolvedAtMeta,
        resolvedAt.isAcceptableOrUnknown(data['resolved_at']!, _resolvedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CoachProposal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CoachProposal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      messageId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}message_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      resolvedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}resolved_at'],
      ),
    );
  }

  @override
  $CoachProposalsTable createAlias(String alias) {
    return $CoachProposalsTable(attachedDatabase, alias);
  }
}

class CoachProposal extends DataClass implements Insertable<CoachProposal> {
  final int id;
  final String type;
  final String title;
  final String? description;
  final String payloadJson;
  final String status;
  final int? messageId;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  const CoachProposal({
    required this.id,
    required this.type,
    required this.title,
    this.description,
    required this.payloadJson,
    required this.status,
    this.messageId,
    required this.createdAt,
    this.resolvedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['payload_json'] = Variable<String>(payloadJson);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || messageId != null) {
      map['message_id'] = Variable<int>(messageId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || resolvedAt != null) {
      map['resolved_at'] = Variable<DateTime>(resolvedAt);
    }
    return map;
  }

  CoachProposalsCompanion toCompanion(bool nullToAbsent) {
    return CoachProposalsCompanion(
      id: Value(id),
      type: Value(type),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      payloadJson: Value(payloadJson),
      status: Value(status),
      messageId: messageId == null && nullToAbsent
          ? const Value.absent()
          : Value(messageId),
      createdAt: Value(createdAt),
      resolvedAt: resolvedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(resolvedAt),
    );
  }

  factory CoachProposal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CoachProposal(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      status: serializer.fromJson<String>(json['status']),
      messageId: serializer.fromJson<int?>(json['messageId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      resolvedAt: serializer.fromJson<DateTime?>(json['resolvedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'status': serializer.toJson<String>(status),
      'messageId': serializer.toJson<int?>(messageId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'resolvedAt': serializer.toJson<DateTime?>(resolvedAt),
    };
  }

  CoachProposal copyWith({
    int? id,
    String? type,
    String? title,
    Value<String?> description = const Value.absent(),
    String? payloadJson,
    String? status,
    Value<int?> messageId = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> resolvedAt = const Value.absent(),
  }) => CoachProposal(
    id: id ?? this.id,
    type: type ?? this.type,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    payloadJson: payloadJson ?? this.payloadJson,
    status: status ?? this.status,
    messageId: messageId.present ? messageId.value : this.messageId,
    createdAt: createdAt ?? this.createdAt,
    resolvedAt: resolvedAt.present ? resolvedAt.value : this.resolvedAt,
  );
  CoachProposal copyWithCompanion(CoachProposalsCompanion data) {
    return CoachProposal(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      status: data.status.present ? data.status.value : this.status,
      messageId: data.messageId.present ? data.messageId.value : this.messageId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      resolvedAt: data.resolvedAt.present
          ? data.resolvedAt.value
          : this.resolvedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CoachProposal(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('status: $status, ')
          ..write('messageId: $messageId, ')
          ..write('createdAt: $createdAt, ')
          ..write('resolvedAt: $resolvedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    title,
    description,
    payloadJson,
    status,
    messageId,
    createdAt,
    resolvedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CoachProposal &&
          other.id == this.id &&
          other.type == this.type &&
          other.title == this.title &&
          other.description == this.description &&
          other.payloadJson == this.payloadJson &&
          other.status == this.status &&
          other.messageId == this.messageId &&
          other.createdAt == this.createdAt &&
          other.resolvedAt == this.resolvedAt);
}

class CoachProposalsCompanion extends UpdateCompanion<CoachProposal> {
  final Value<int> id;
  final Value<String> type;
  final Value<String> title;
  final Value<String?> description;
  final Value<String> payloadJson;
  final Value<String> status;
  final Value<int?> messageId;
  final Value<DateTime> createdAt;
  final Value<DateTime?> resolvedAt;
  const CoachProposalsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.status = const Value.absent(),
    this.messageId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.resolvedAt = const Value.absent(),
  });
  CoachProposalsCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    required String title,
    this.description = const Value.absent(),
    required String payloadJson,
    this.status = const Value.absent(),
    this.messageId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.resolvedAt = const Value.absent(),
  }) : type = Value(type),
       title = Value(title),
       payloadJson = Value(payloadJson);
  static Insertable<CoachProposal> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? payloadJson,
    Expression<String>? status,
    Expression<int>? messageId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? resolvedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (status != null) 'status': status,
      if (messageId != null) 'message_id': messageId,
      if (createdAt != null) 'created_at': createdAt,
      if (resolvedAt != null) 'resolved_at': resolvedAt,
    });
  }

  CoachProposalsCompanion copyWith({
    Value<int>? id,
    Value<String>? type,
    Value<String>? title,
    Value<String?>? description,
    Value<String>? payloadJson,
    Value<String>? status,
    Value<int?>? messageId,
    Value<DateTime>? createdAt,
    Value<DateTime?>? resolvedAt,
  }) {
    return CoachProposalsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      payloadJson: payloadJson ?? this.payloadJson,
      status: status ?? this.status,
      messageId: messageId ?? this.messageId,
      createdAt: createdAt ?? this.createdAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (messageId.present) {
      map['message_id'] = Variable<int>(messageId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (resolvedAt.present) {
      map['resolved_at'] = Variable<DateTime>(resolvedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CoachProposalsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('status: $status, ')
          ..write('messageId: $messageId, ')
          ..write('createdAt: $createdAt, ')
          ..write('resolvedAt: $resolvedAt')
          ..write(')'))
        .toString();
  }
}

class $AiUsageTable extends AiUsage with TableInfo<$AiUsageTable, AiUsageData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiUsageTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _featureMeta = const VerificationMeta(
    'feature',
  );
  @override
  late final GeneratedColumn<String> feature = GeneratedColumn<String>(
    'feature',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _inputTokensMeta = const VerificationMeta(
    'inputTokens',
  );
  @override
  late final GeneratedColumn<int> inputTokens = GeneratedColumn<int>(
    'input_tokens',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _outputTokensMeta = const VerificationMeta(
    'outputTokens',
  );
  @override
  late final GeneratedColumn<int> outputTokens = GeneratedColumn<int>(
    'output_tokens',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _cacheReadTokensMeta = const VerificationMeta(
    'cacheReadTokens',
  );
  @override
  late final GeneratedColumn<int> cacheReadTokens = GeneratedColumn<int>(
    'cache_read_tokens',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _cacheWriteTokensMeta = const VerificationMeta(
    'cacheWriteTokens',
  );
  @override
  late final GeneratedColumn<int> cacheWriteTokens = GeneratedColumn<int>(
    'cache_write_tokens',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _costUsdMeta = const VerificationMeta(
    'costUsd',
  );
  @override
  late final GeneratedColumn<double> costUsd = GeneratedColumn<double>(
    'cost_usd',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    timestamp,
    feature,
    model,
    inputTokens,
    outputTokens,
    cacheReadTokens,
    cacheWriteTokens,
    costUsd,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_usage';
  @override
  VerificationContext validateIntegrity(
    Insertable<AiUsageData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    }
    if (data.containsKey('feature')) {
      context.handle(
        _featureMeta,
        feature.isAcceptableOrUnknown(data['feature']!, _featureMeta),
      );
    } else if (isInserting) {
      context.missing(_featureMeta);
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    } else if (isInserting) {
      context.missing(_modelMeta);
    }
    if (data.containsKey('input_tokens')) {
      context.handle(
        _inputTokensMeta,
        inputTokens.isAcceptableOrUnknown(
          data['input_tokens']!,
          _inputTokensMeta,
        ),
      );
    }
    if (data.containsKey('output_tokens')) {
      context.handle(
        _outputTokensMeta,
        outputTokens.isAcceptableOrUnknown(
          data['output_tokens']!,
          _outputTokensMeta,
        ),
      );
    }
    if (data.containsKey('cache_read_tokens')) {
      context.handle(
        _cacheReadTokensMeta,
        cacheReadTokens.isAcceptableOrUnknown(
          data['cache_read_tokens']!,
          _cacheReadTokensMeta,
        ),
      );
    }
    if (data.containsKey('cache_write_tokens')) {
      context.handle(
        _cacheWriteTokensMeta,
        cacheWriteTokens.isAcceptableOrUnknown(
          data['cache_write_tokens']!,
          _cacheWriteTokensMeta,
        ),
      );
    }
    if (data.containsKey('cost_usd')) {
      context.handle(
        _costUsdMeta,
        costUsd.isAcceptableOrUnknown(data['cost_usd']!, _costUsdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AiUsageData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiUsageData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      feature: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}feature'],
      )!,
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      )!,
      inputTokens: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}input_tokens'],
      )!,
      outputTokens: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}output_tokens'],
      )!,
      cacheReadTokens: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cache_read_tokens'],
      )!,
      cacheWriteTokens: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cache_write_tokens'],
      )!,
      costUsd: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cost_usd'],
      )!,
    );
  }

  @override
  $AiUsageTable createAlias(String alias) {
    return $AiUsageTable(attachedDatabase, alias);
  }
}

class AiUsageData extends DataClass implements Insertable<AiUsageData> {
  final int id;
  final DateTime timestamp;
  final String feature;
  final String model;
  final int inputTokens;
  final int outputTokens;
  final int cacheReadTokens;
  final int cacheWriteTokens;
  final double costUsd;
  const AiUsageData({
    required this.id,
    required this.timestamp,
    required this.feature,
    required this.model,
    required this.inputTokens,
    required this.outputTokens,
    required this.cacheReadTokens,
    required this.cacheWriteTokens,
    required this.costUsd,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['feature'] = Variable<String>(feature);
    map['model'] = Variable<String>(model);
    map['input_tokens'] = Variable<int>(inputTokens);
    map['output_tokens'] = Variable<int>(outputTokens);
    map['cache_read_tokens'] = Variable<int>(cacheReadTokens);
    map['cache_write_tokens'] = Variable<int>(cacheWriteTokens);
    map['cost_usd'] = Variable<double>(costUsd);
    return map;
  }

  AiUsageCompanion toCompanion(bool nullToAbsent) {
    return AiUsageCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      feature: Value(feature),
      model: Value(model),
      inputTokens: Value(inputTokens),
      outputTokens: Value(outputTokens),
      cacheReadTokens: Value(cacheReadTokens),
      cacheWriteTokens: Value(cacheWriteTokens),
      costUsd: Value(costUsd),
    );
  }

  factory AiUsageData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiUsageData(
      id: serializer.fromJson<int>(json['id']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      feature: serializer.fromJson<String>(json['feature']),
      model: serializer.fromJson<String>(json['model']),
      inputTokens: serializer.fromJson<int>(json['inputTokens']),
      outputTokens: serializer.fromJson<int>(json['outputTokens']),
      cacheReadTokens: serializer.fromJson<int>(json['cacheReadTokens']),
      cacheWriteTokens: serializer.fromJson<int>(json['cacheWriteTokens']),
      costUsd: serializer.fromJson<double>(json['costUsd']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'feature': serializer.toJson<String>(feature),
      'model': serializer.toJson<String>(model),
      'inputTokens': serializer.toJson<int>(inputTokens),
      'outputTokens': serializer.toJson<int>(outputTokens),
      'cacheReadTokens': serializer.toJson<int>(cacheReadTokens),
      'cacheWriteTokens': serializer.toJson<int>(cacheWriteTokens),
      'costUsd': serializer.toJson<double>(costUsd),
    };
  }

  AiUsageData copyWith({
    int? id,
    DateTime? timestamp,
    String? feature,
    String? model,
    int? inputTokens,
    int? outputTokens,
    int? cacheReadTokens,
    int? cacheWriteTokens,
    double? costUsd,
  }) => AiUsageData(
    id: id ?? this.id,
    timestamp: timestamp ?? this.timestamp,
    feature: feature ?? this.feature,
    model: model ?? this.model,
    inputTokens: inputTokens ?? this.inputTokens,
    outputTokens: outputTokens ?? this.outputTokens,
    cacheReadTokens: cacheReadTokens ?? this.cacheReadTokens,
    cacheWriteTokens: cacheWriteTokens ?? this.cacheWriteTokens,
    costUsd: costUsd ?? this.costUsd,
  );
  AiUsageData copyWithCompanion(AiUsageCompanion data) {
    return AiUsageData(
      id: data.id.present ? data.id.value : this.id,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      feature: data.feature.present ? data.feature.value : this.feature,
      model: data.model.present ? data.model.value : this.model,
      inputTokens: data.inputTokens.present
          ? data.inputTokens.value
          : this.inputTokens,
      outputTokens: data.outputTokens.present
          ? data.outputTokens.value
          : this.outputTokens,
      cacheReadTokens: data.cacheReadTokens.present
          ? data.cacheReadTokens.value
          : this.cacheReadTokens,
      cacheWriteTokens: data.cacheWriteTokens.present
          ? data.cacheWriteTokens.value
          : this.cacheWriteTokens,
      costUsd: data.costUsd.present ? data.costUsd.value : this.costUsd,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiUsageData(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('feature: $feature, ')
          ..write('model: $model, ')
          ..write('inputTokens: $inputTokens, ')
          ..write('outputTokens: $outputTokens, ')
          ..write('cacheReadTokens: $cacheReadTokens, ')
          ..write('cacheWriteTokens: $cacheWriteTokens, ')
          ..write('costUsd: $costUsd')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    timestamp,
    feature,
    model,
    inputTokens,
    outputTokens,
    cacheReadTokens,
    cacheWriteTokens,
    costUsd,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiUsageData &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.feature == this.feature &&
          other.model == this.model &&
          other.inputTokens == this.inputTokens &&
          other.outputTokens == this.outputTokens &&
          other.cacheReadTokens == this.cacheReadTokens &&
          other.cacheWriteTokens == this.cacheWriteTokens &&
          other.costUsd == this.costUsd);
}

class AiUsageCompanion extends UpdateCompanion<AiUsageData> {
  final Value<int> id;
  final Value<DateTime> timestamp;
  final Value<String> feature;
  final Value<String> model;
  final Value<int> inputTokens;
  final Value<int> outputTokens;
  final Value<int> cacheReadTokens;
  final Value<int> cacheWriteTokens;
  final Value<double> costUsd;
  const AiUsageCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.feature = const Value.absent(),
    this.model = const Value.absent(),
    this.inputTokens = const Value.absent(),
    this.outputTokens = const Value.absent(),
    this.cacheReadTokens = const Value.absent(),
    this.cacheWriteTokens = const Value.absent(),
    this.costUsd = const Value.absent(),
  });
  AiUsageCompanion.insert({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    required String feature,
    required String model,
    this.inputTokens = const Value.absent(),
    this.outputTokens = const Value.absent(),
    this.cacheReadTokens = const Value.absent(),
    this.cacheWriteTokens = const Value.absent(),
    this.costUsd = const Value.absent(),
  }) : feature = Value(feature),
       model = Value(model);
  static Insertable<AiUsageData> custom({
    Expression<int>? id,
    Expression<DateTime>? timestamp,
    Expression<String>? feature,
    Expression<String>? model,
    Expression<int>? inputTokens,
    Expression<int>? outputTokens,
    Expression<int>? cacheReadTokens,
    Expression<int>? cacheWriteTokens,
    Expression<double>? costUsd,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (feature != null) 'feature': feature,
      if (model != null) 'model': model,
      if (inputTokens != null) 'input_tokens': inputTokens,
      if (outputTokens != null) 'output_tokens': outputTokens,
      if (cacheReadTokens != null) 'cache_read_tokens': cacheReadTokens,
      if (cacheWriteTokens != null) 'cache_write_tokens': cacheWriteTokens,
      if (costUsd != null) 'cost_usd': costUsd,
    });
  }

  AiUsageCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? timestamp,
    Value<String>? feature,
    Value<String>? model,
    Value<int>? inputTokens,
    Value<int>? outputTokens,
    Value<int>? cacheReadTokens,
    Value<int>? cacheWriteTokens,
    Value<double>? costUsd,
  }) {
    return AiUsageCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      feature: feature ?? this.feature,
      model: model ?? this.model,
      inputTokens: inputTokens ?? this.inputTokens,
      outputTokens: outputTokens ?? this.outputTokens,
      cacheReadTokens: cacheReadTokens ?? this.cacheReadTokens,
      cacheWriteTokens: cacheWriteTokens ?? this.cacheWriteTokens,
      costUsd: costUsd ?? this.costUsd,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (feature.present) {
      map['feature'] = Variable<String>(feature.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (inputTokens.present) {
      map['input_tokens'] = Variable<int>(inputTokens.value);
    }
    if (outputTokens.present) {
      map['output_tokens'] = Variable<int>(outputTokens.value);
    }
    if (cacheReadTokens.present) {
      map['cache_read_tokens'] = Variable<int>(cacheReadTokens.value);
    }
    if (cacheWriteTokens.present) {
      map['cache_write_tokens'] = Variable<int>(cacheWriteTokens.value);
    }
    if (costUsd.present) {
      map['cost_usd'] = Variable<double>(costUsd.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiUsageCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('feature: $feature, ')
          ..write('model: $model, ')
          ..write('inputTokens: $inputTokens, ')
          ..write('outputTokens: $outputTokens, ')
          ..write('cacheReadTokens: $cacheReadTokens, ')
          ..write('cacheWriteTokens: $cacheWriteTokens, ')
          ..write('costUsd: $costUsd')
          ..write(')'))
        .toString();
  }
}

class $AiQueueTable extends AiQueue with TableInfo<$AiQueueTable, AiQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _featureMeta = const VerificationMeta(
    'feature',
  );
  @override
  late final GeneratedColumn<String> feature = GeneratedColumn<String>(
    'feature',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    feature,
    payloadJson,
    status,
    attempts,
    lastError,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<AiQueueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('feature')) {
      context.handle(
        _featureMeta,
        feature.isAcceptableOrUnknown(data['feature']!, _featureMeta),
      );
    } else if (isInserting) {
      context.missing(_featureMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AiQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiQueueData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      feature: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}feature'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AiQueueTable createAlias(String alias) {
    return $AiQueueTable(attachedDatabase, alias);
  }
}

class AiQueueData extends DataClass implements Insertable<AiQueueData> {
  final int id;
  final String feature;
  final String payloadJson;
  final String status;
  final int attempts;
  final String? lastError;
  final DateTime createdAt;
  const AiQueueData({
    required this.id,
    required this.feature,
    required this.payloadJson,
    required this.status,
    required this.attempts,
    this.lastError,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['feature'] = Variable<String>(feature);
    map['payload_json'] = Variable<String>(payloadJson);
    map['status'] = Variable<String>(status);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AiQueueCompanion toCompanion(bool nullToAbsent) {
    return AiQueueCompanion(
      id: Value(id),
      feature: Value(feature),
      payloadJson: Value(payloadJson),
      status: Value(status),
      attempts: Value(attempts),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      createdAt: Value(createdAt),
    );
  }

  factory AiQueueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiQueueData(
      id: serializer.fromJson<int>(json['id']),
      feature: serializer.fromJson<String>(json['feature']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      status: serializer.fromJson<String>(json['status']),
      attempts: serializer.fromJson<int>(json['attempts']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'feature': serializer.toJson<String>(feature),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'status': serializer.toJson<String>(status),
      'attempts': serializer.toJson<int>(attempts),
      'lastError': serializer.toJson<String?>(lastError),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AiQueueData copyWith({
    int? id,
    String? feature,
    String? payloadJson,
    String? status,
    int? attempts,
    Value<String?> lastError = const Value.absent(),
    DateTime? createdAt,
  }) => AiQueueData(
    id: id ?? this.id,
    feature: feature ?? this.feature,
    payloadJson: payloadJson ?? this.payloadJson,
    status: status ?? this.status,
    attempts: attempts ?? this.attempts,
    lastError: lastError.present ? lastError.value : this.lastError,
    createdAt: createdAt ?? this.createdAt,
  );
  AiQueueData copyWithCompanion(AiQueueCompanion data) {
    return AiQueueData(
      id: data.id.present ? data.id.value : this.id,
      feature: data.feature.present ? data.feature.value : this.feature,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      status: data.status.present ? data.status.value : this.status,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiQueueData(')
          ..write('id: $id, ')
          ..write('feature: $feature, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('status: $status, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    feature,
    payloadJson,
    status,
    attempts,
    lastError,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiQueueData &&
          other.id == this.id &&
          other.feature == this.feature &&
          other.payloadJson == this.payloadJson &&
          other.status == this.status &&
          other.attempts == this.attempts &&
          other.lastError == this.lastError &&
          other.createdAt == this.createdAt);
}

class AiQueueCompanion extends UpdateCompanion<AiQueueData> {
  final Value<int> id;
  final Value<String> feature;
  final Value<String> payloadJson;
  final Value<String> status;
  final Value<int> attempts;
  final Value<String?> lastError;
  final Value<DateTime> createdAt;
  const AiQueueCompanion({
    this.id = const Value.absent(),
    this.feature = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.status = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AiQueueCompanion.insert({
    this.id = const Value.absent(),
    required String feature,
    required String payloadJson,
    this.status = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : feature = Value(feature),
       payloadJson = Value(payloadJson);
  static Insertable<AiQueueData> custom({
    Expression<int>? id,
    Expression<String>? feature,
    Expression<String>? payloadJson,
    Expression<String>? status,
    Expression<int>? attempts,
    Expression<String>? lastError,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (feature != null) 'feature': feature,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (status != null) 'status': status,
      if (attempts != null) 'attempts': attempts,
      if (lastError != null) 'last_error': lastError,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AiQueueCompanion copyWith({
    Value<int>? id,
    Value<String>? feature,
    Value<String>? payloadJson,
    Value<String>? status,
    Value<int>? attempts,
    Value<String?>? lastError,
    Value<DateTime>? createdAt,
  }) {
    return AiQueueCompanion(
      id: id ?? this.id,
      feature: feature ?? this.feature,
      payloadJson: payloadJson ?? this.payloadJson,
      status: status ?? this.status,
      attempts: attempts ?? this.attempts,
      lastError: lastError ?? this.lastError,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (feature.present) {
      map['feature'] = Variable<String>(feature.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiQueueCompanion(')
          ..write('id: $id, ')
          ..write('feature: $feature, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('status: $status, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final $ExercisesTable exercises = $ExercisesTable(this);
  late final $WorkoutPlansTable workoutPlans = $WorkoutPlansTable(this);
  late final $PlanDaysTable planDays = $PlanDaysTable(this);
  late final $PlanExercisesTable planExercises = $PlanExercisesTable(this);
  late final $WorkoutSessionsTable workoutSessions = $WorkoutSessionsTable(
    this,
  );
  late final $SetLogsTable setLogs = $SetLogsTable(this);
  late final $SessionExerciseNotesTable sessionExerciseNotes =
      $SessionExerciseNotesTable(this);
  late final $CardioLogsTable cardioLogs = $CardioLogsTable(this);
  late final $MealPlansTable mealPlans = $MealPlansTable(this);
  late final $PlannedMealsTable plannedMeals = $PlannedMealsTable(this);
  late final $MealLogsTable mealLogs = $MealLogsTable(this);
  late final $FoodItemsTable foodItems = $FoodItemsTable(this);
  late final $BodyMetricsTable bodyMetrics = $BodyMetricsTable(this);
  late final $ProgressPhotosTable progressPhotos = $ProgressPhotosTable(this);
  late final $WaterLogsTable waterLogs = $WaterLogsTable(this);
  late final $SupplementsTable supplements = $SupplementsTable(this);
  late final $SupplementLogsTable supplementLogs = $SupplementLogsTable(this);
  late final $SleepLogsTable sleepLogs = $SleepLogsTable(this);
  late final $HealthDailyTable healthDaily = $HealthDailyTable(this);
  late final $CoachMessagesTable coachMessages = $CoachMessagesTable(this);
  late final $CoachMemoriesTable coachMemories = $CoachMemoriesTable(this);
  late final $CoachProposalsTable coachProposals = $CoachProposalsTable(this);
  late final $AiUsageTable aiUsage = $AiUsageTable(this);
  late final $AiQueueTable aiQueue = $AiQueueTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    userProfiles,
    exercises,
    workoutPlans,
    planDays,
    planExercises,
    workoutSessions,
    setLogs,
    sessionExerciseNotes,
    cardioLogs,
    mealPlans,
    plannedMeals,
    mealLogs,
    foodItems,
    bodyMetrics,
    progressPhotos,
    waterLogs,
    supplements,
    supplementLogs,
    sleepLogs,
    healthDaily,
    coachMessages,
    coachMemories,
    coachProposals,
    aiUsage,
    aiQueue,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'workout_plans',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('plan_days', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'plan_days',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('plan_exercises', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'plan_days',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('workout_sessions', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'workout_sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('set_logs', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'workout_sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('session_exercise_notes', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'workout_sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('cardio_logs', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'meal_plans',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('planned_meals', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'supplements',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('supplement_logs', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$UserProfilesTableCreateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<int> id,
      Value<String> language,
      Value<String?> sex,
      Value<int?> age,
      Value<double?> heightCm,
      Value<double?> weightKg,
      Value<double?> bodyFatPct,
      Value<String?> bodyFatMethod,
      Value<String> measurementsJson,
      Value<String?> goal,
      Value<double?> targetWeightKg,
      Value<int?> goalWeeks,
      Value<String?> level,
      Value<String?> trainingExperience,
      Value<int?> daysPerWeek,
      Value<String> trainingDaysJson,
      Value<int?> sessionMinutes,
      Value<String?> splitPreference,
      Value<String> focusMusclesJson,
      Value<String?> location,
      Value<String> injuriesJson,
      Value<String?> injuriesNote,
      Value<String?> jobType,
      Value<String?> jobHours,
      Value<String?> sleepTime,
      Value<String?> wakeTime,
      Value<String?> trainingTimeOfDay,
      Value<String?> trainingTime,
      Value<String?> cardioType,
      Value<int?> cardioPerWeek,
      Value<int?> mealsPerDay,
      Value<String> mealTimesJson,
      Value<String?> likedFoods,
      Value<String?> dislikedFoods,
      Value<String?> allergies,
      Value<String?> budgetLevel,
      Value<int?> budgetEgp,
      Value<String> supplementsJson,
      Value<int?> waterGoalMl,
      Value<bool> healthConnectEnabled,
      Value<double?> bmr,
      Value<double?> tdee,
      Value<int?> calorieTarget,
      Value<int?> proteinG,
      Value<int?> carbsG,
      Value<int?> fatG,
      Value<int?> trainingDayCarbsG,
      Value<int?> restDayCarbsG,
      Value<bool> onboardingComplete,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$UserProfilesTableUpdateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<int> id,
      Value<String> language,
      Value<String?> sex,
      Value<int?> age,
      Value<double?> heightCm,
      Value<double?> weightKg,
      Value<double?> bodyFatPct,
      Value<String?> bodyFatMethod,
      Value<String> measurementsJson,
      Value<String?> goal,
      Value<double?> targetWeightKg,
      Value<int?> goalWeeks,
      Value<String?> level,
      Value<String?> trainingExperience,
      Value<int?> daysPerWeek,
      Value<String> trainingDaysJson,
      Value<int?> sessionMinutes,
      Value<String?> splitPreference,
      Value<String> focusMusclesJson,
      Value<String?> location,
      Value<String> injuriesJson,
      Value<String?> injuriesNote,
      Value<String?> jobType,
      Value<String?> jobHours,
      Value<String?> sleepTime,
      Value<String?> wakeTime,
      Value<String?> trainingTimeOfDay,
      Value<String?> trainingTime,
      Value<String?> cardioType,
      Value<int?> cardioPerWeek,
      Value<int?> mealsPerDay,
      Value<String> mealTimesJson,
      Value<String?> likedFoods,
      Value<String?> dislikedFoods,
      Value<String?> allergies,
      Value<String?> budgetLevel,
      Value<int?> budgetEgp,
      Value<String> supplementsJson,
      Value<int?> waterGoalMl,
      Value<bool> healthConnectEnabled,
      Value<double?> bmr,
      Value<double?> tdee,
      Value<int?> calorieTarget,
      Value<int?> proteinG,
      Value<int?> carbsG,
      Value<int?> fatG,
      Value<int?> trainingDayCarbsG,
      Value<int?> restDayCarbsG,
      Value<bool> onboardingComplete,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$UserProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bodyFatPct => $composableBuilder(
    column: $table.bodyFatPct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bodyFatMethod => $composableBuilder(
    column: $table.bodyFatMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get measurementsJson => $composableBuilder(
    column: $table.measurementsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goal => $composableBuilder(
    column: $table.goal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetWeightKg => $composableBuilder(
    column: $table.targetWeightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get goalWeeks => $composableBuilder(
    column: $table.goalWeeks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trainingExperience => $composableBuilder(
    column: $table.trainingExperience,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get daysPerWeek => $composableBuilder(
    column: $table.daysPerWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trainingDaysJson => $composableBuilder(
    column: $table.trainingDaysJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sessionMinutes => $composableBuilder(
    column: $table.sessionMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get splitPreference => $composableBuilder(
    column: $table.splitPreference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get focusMusclesJson => $composableBuilder(
    column: $table.focusMusclesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get injuriesJson => $composableBuilder(
    column: $table.injuriesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get injuriesNote => $composableBuilder(
    column: $table.injuriesNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get jobType => $composableBuilder(
    column: $table.jobType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get jobHours => $composableBuilder(
    column: $table.jobHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sleepTime => $composableBuilder(
    column: $table.sleepTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get wakeTime => $composableBuilder(
    column: $table.wakeTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trainingTimeOfDay => $composableBuilder(
    column: $table.trainingTimeOfDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trainingTime => $composableBuilder(
    column: $table.trainingTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cardioType => $composableBuilder(
    column: $table.cardioType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cardioPerWeek => $composableBuilder(
    column: $table.cardioPerWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mealsPerDay => $composableBuilder(
    column: $table.mealsPerDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mealTimesJson => $composableBuilder(
    column: $table.mealTimesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get likedFoods => $composableBuilder(
    column: $table.likedFoods,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dislikedFoods => $composableBuilder(
    column: $table.dislikedFoods,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get allergies => $composableBuilder(
    column: $table.allergies,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get budgetLevel => $composableBuilder(
    column: $table.budgetLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get budgetEgp => $composableBuilder(
    column: $table.budgetEgp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supplementsJson => $composableBuilder(
    column: $table.supplementsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get waterGoalMl => $composableBuilder(
    column: $table.waterGoalMl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get healthConnectEnabled => $composableBuilder(
    column: $table.healthConnectEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bmr => $composableBuilder(
    column: $table.bmr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get tdee => $composableBuilder(
    column: $table.tdee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get calorieTarget => $composableBuilder(
    column: $table.calorieTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get proteinG => $composableBuilder(
    column: $table.proteinG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get carbsG => $composableBuilder(
    column: $table.carbsG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fatG => $composableBuilder(
    column: $table.fatG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get trainingDayCarbsG => $composableBuilder(
    column: $table.trainingDayCarbsG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restDayCarbsG => $composableBuilder(
    column: $table.restDayCarbsG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bodyFatPct => $composableBuilder(
    column: $table.bodyFatPct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bodyFatMethod => $composableBuilder(
    column: $table.bodyFatMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get measurementsJson => $composableBuilder(
    column: $table.measurementsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goal => $composableBuilder(
    column: $table.goal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetWeightKg => $composableBuilder(
    column: $table.targetWeightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get goalWeeks => $composableBuilder(
    column: $table.goalWeeks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trainingExperience => $composableBuilder(
    column: $table.trainingExperience,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get daysPerWeek => $composableBuilder(
    column: $table.daysPerWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trainingDaysJson => $composableBuilder(
    column: $table.trainingDaysJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sessionMinutes => $composableBuilder(
    column: $table.sessionMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get splitPreference => $composableBuilder(
    column: $table.splitPreference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get focusMusclesJson => $composableBuilder(
    column: $table.focusMusclesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get injuriesJson => $composableBuilder(
    column: $table.injuriesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get injuriesNote => $composableBuilder(
    column: $table.injuriesNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jobType => $composableBuilder(
    column: $table.jobType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jobHours => $composableBuilder(
    column: $table.jobHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sleepTime => $composableBuilder(
    column: $table.sleepTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get wakeTime => $composableBuilder(
    column: $table.wakeTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trainingTimeOfDay => $composableBuilder(
    column: $table.trainingTimeOfDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trainingTime => $composableBuilder(
    column: $table.trainingTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardioType => $composableBuilder(
    column: $table.cardioType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cardioPerWeek => $composableBuilder(
    column: $table.cardioPerWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mealsPerDay => $composableBuilder(
    column: $table.mealsPerDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealTimesJson => $composableBuilder(
    column: $table.mealTimesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get likedFoods => $composableBuilder(
    column: $table.likedFoods,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dislikedFoods => $composableBuilder(
    column: $table.dislikedFoods,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get allergies => $composableBuilder(
    column: $table.allergies,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get budgetLevel => $composableBuilder(
    column: $table.budgetLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get budgetEgp => $composableBuilder(
    column: $table.budgetEgp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supplementsJson => $composableBuilder(
    column: $table.supplementsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get waterGoalMl => $composableBuilder(
    column: $table.waterGoalMl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get healthConnectEnabled => $composableBuilder(
    column: $table.healthConnectEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bmr => $composableBuilder(
    column: $table.bmr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get tdee => $composableBuilder(
    column: $table.tdee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get calorieTarget => $composableBuilder(
    column: $table.calorieTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get proteinG => $composableBuilder(
    column: $table.proteinG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get carbsG => $composableBuilder(
    column: $table.carbsG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fatG => $composableBuilder(
    column: $table.fatG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get trainingDayCarbsG => $composableBuilder(
    column: $table.trainingDayCarbsG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restDayCarbsG => $composableBuilder(
    column: $table.restDayCarbsG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get sex =>
      $composableBuilder(column: $table.sex, builder: (column) => column);

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<double> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<double> get bodyFatPct => $composableBuilder(
    column: $table.bodyFatPct,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bodyFatMethod => $composableBuilder(
    column: $table.bodyFatMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get measurementsJson => $composableBuilder(
    column: $table.measurementsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get goal =>
      $composableBuilder(column: $table.goal, builder: (column) => column);

  GeneratedColumn<double> get targetWeightKg => $composableBuilder(
    column: $table.targetWeightKg,
    builder: (column) => column,
  );

  GeneratedColumn<int> get goalWeeks =>
      $composableBuilder(column: $table.goalWeeks, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get trainingExperience => $composableBuilder(
    column: $table.trainingExperience,
    builder: (column) => column,
  );

  GeneratedColumn<int> get daysPerWeek => $composableBuilder(
    column: $table.daysPerWeek,
    builder: (column) => column,
  );

  GeneratedColumn<String> get trainingDaysJson => $composableBuilder(
    column: $table.trainingDaysJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sessionMinutes => $composableBuilder(
    column: $table.sessionMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get splitPreference => $composableBuilder(
    column: $table.splitPreference,
    builder: (column) => column,
  );

  GeneratedColumn<String> get focusMusclesJson => $composableBuilder(
    column: $table.focusMusclesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<String> get injuriesJson => $composableBuilder(
    column: $table.injuriesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get injuriesNote => $composableBuilder(
    column: $table.injuriesNote,
    builder: (column) => column,
  );

  GeneratedColumn<String> get jobType =>
      $composableBuilder(column: $table.jobType, builder: (column) => column);

  GeneratedColumn<String> get jobHours =>
      $composableBuilder(column: $table.jobHours, builder: (column) => column);

  GeneratedColumn<String> get sleepTime =>
      $composableBuilder(column: $table.sleepTime, builder: (column) => column);

  GeneratedColumn<String> get wakeTime =>
      $composableBuilder(column: $table.wakeTime, builder: (column) => column);

  GeneratedColumn<String> get trainingTimeOfDay => $composableBuilder(
    column: $table.trainingTimeOfDay,
    builder: (column) => column,
  );

  GeneratedColumn<String> get trainingTime => $composableBuilder(
    column: $table.trainingTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cardioType => $composableBuilder(
    column: $table.cardioType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cardioPerWeek => $composableBuilder(
    column: $table.cardioPerWeek,
    builder: (column) => column,
  );

  GeneratedColumn<int> get mealsPerDay => $composableBuilder(
    column: $table.mealsPerDay,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mealTimesJson => $composableBuilder(
    column: $table.mealTimesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get likedFoods => $composableBuilder(
    column: $table.likedFoods,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dislikedFoods => $composableBuilder(
    column: $table.dislikedFoods,
    builder: (column) => column,
  );

  GeneratedColumn<String> get allergies =>
      $composableBuilder(column: $table.allergies, builder: (column) => column);

  GeneratedColumn<String> get budgetLevel => $composableBuilder(
    column: $table.budgetLevel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get budgetEgp =>
      $composableBuilder(column: $table.budgetEgp, builder: (column) => column);

  GeneratedColumn<String> get supplementsJson => $composableBuilder(
    column: $table.supplementsJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get waterGoalMl => $composableBuilder(
    column: $table.waterGoalMl,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get healthConnectEnabled => $composableBuilder(
    column: $table.healthConnectEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<double> get bmr =>
      $composableBuilder(column: $table.bmr, builder: (column) => column);

  GeneratedColumn<double> get tdee =>
      $composableBuilder(column: $table.tdee, builder: (column) => column);

  GeneratedColumn<int> get calorieTarget => $composableBuilder(
    column: $table.calorieTarget,
    builder: (column) => column,
  );

  GeneratedColumn<int> get proteinG =>
      $composableBuilder(column: $table.proteinG, builder: (column) => column);

  GeneratedColumn<int> get carbsG =>
      $composableBuilder(column: $table.carbsG, builder: (column) => column);

  GeneratedColumn<int> get fatG =>
      $composableBuilder(column: $table.fatG, builder: (column) => column);

  GeneratedColumn<int> get trainingDayCarbsG => $composableBuilder(
    column: $table.trainingDayCarbsG,
    builder: (column) => column,
  );

  GeneratedColumn<int> get restDayCarbsG => $composableBuilder(
    column: $table.restDayCarbsG,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfilesTable,
          UserProfile,
          $$UserProfilesTableFilterComposer,
          $$UserProfilesTableOrderingComposer,
          $$UserProfilesTableAnnotationComposer,
          $$UserProfilesTableCreateCompanionBuilder,
          $$UserProfilesTableUpdateCompanionBuilder,
          (
            UserProfile,
            BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>,
          ),
          UserProfile,
          PrefetchHooks Function()
        > {
  $$UserProfilesTableTableManager(_$AppDatabase db, $UserProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<String?> sex = const Value.absent(),
                Value<int?> age = const Value.absent(),
                Value<double?> heightCm = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<double?> bodyFatPct = const Value.absent(),
                Value<String?> bodyFatMethod = const Value.absent(),
                Value<String> measurementsJson = const Value.absent(),
                Value<String?> goal = const Value.absent(),
                Value<double?> targetWeightKg = const Value.absent(),
                Value<int?> goalWeeks = const Value.absent(),
                Value<String?> level = const Value.absent(),
                Value<String?> trainingExperience = const Value.absent(),
                Value<int?> daysPerWeek = const Value.absent(),
                Value<String> trainingDaysJson = const Value.absent(),
                Value<int?> sessionMinutes = const Value.absent(),
                Value<String?> splitPreference = const Value.absent(),
                Value<String> focusMusclesJson = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<String> injuriesJson = const Value.absent(),
                Value<String?> injuriesNote = const Value.absent(),
                Value<String?> jobType = const Value.absent(),
                Value<String?> jobHours = const Value.absent(),
                Value<String?> sleepTime = const Value.absent(),
                Value<String?> wakeTime = const Value.absent(),
                Value<String?> trainingTimeOfDay = const Value.absent(),
                Value<String?> trainingTime = const Value.absent(),
                Value<String?> cardioType = const Value.absent(),
                Value<int?> cardioPerWeek = const Value.absent(),
                Value<int?> mealsPerDay = const Value.absent(),
                Value<String> mealTimesJson = const Value.absent(),
                Value<String?> likedFoods = const Value.absent(),
                Value<String?> dislikedFoods = const Value.absent(),
                Value<String?> allergies = const Value.absent(),
                Value<String?> budgetLevel = const Value.absent(),
                Value<int?> budgetEgp = const Value.absent(),
                Value<String> supplementsJson = const Value.absent(),
                Value<int?> waterGoalMl = const Value.absent(),
                Value<bool> healthConnectEnabled = const Value.absent(),
                Value<double?> bmr = const Value.absent(),
                Value<double?> tdee = const Value.absent(),
                Value<int?> calorieTarget = const Value.absent(),
                Value<int?> proteinG = const Value.absent(),
                Value<int?> carbsG = const Value.absent(),
                Value<int?> fatG = const Value.absent(),
                Value<int?> trainingDayCarbsG = const Value.absent(),
                Value<int?> restDayCarbsG = const Value.absent(),
                Value<bool> onboardingComplete = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => UserProfilesCompanion(
                id: id,
                language: language,
                sex: sex,
                age: age,
                heightCm: heightCm,
                weightKg: weightKg,
                bodyFatPct: bodyFatPct,
                bodyFatMethod: bodyFatMethod,
                measurementsJson: measurementsJson,
                goal: goal,
                targetWeightKg: targetWeightKg,
                goalWeeks: goalWeeks,
                level: level,
                trainingExperience: trainingExperience,
                daysPerWeek: daysPerWeek,
                trainingDaysJson: trainingDaysJson,
                sessionMinutes: sessionMinutes,
                splitPreference: splitPreference,
                focusMusclesJson: focusMusclesJson,
                location: location,
                injuriesJson: injuriesJson,
                injuriesNote: injuriesNote,
                jobType: jobType,
                jobHours: jobHours,
                sleepTime: sleepTime,
                wakeTime: wakeTime,
                trainingTimeOfDay: trainingTimeOfDay,
                trainingTime: trainingTime,
                cardioType: cardioType,
                cardioPerWeek: cardioPerWeek,
                mealsPerDay: mealsPerDay,
                mealTimesJson: mealTimesJson,
                likedFoods: likedFoods,
                dislikedFoods: dislikedFoods,
                allergies: allergies,
                budgetLevel: budgetLevel,
                budgetEgp: budgetEgp,
                supplementsJson: supplementsJson,
                waterGoalMl: waterGoalMl,
                healthConnectEnabled: healthConnectEnabled,
                bmr: bmr,
                tdee: tdee,
                calorieTarget: calorieTarget,
                proteinG: proteinG,
                carbsG: carbsG,
                fatG: fatG,
                trainingDayCarbsG: trainingDayCarbsG,
                restDayCarbsG: restDayCarbsG,
                onboardingComplete: onboardingComplete,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<String?> sex = const Value.absent(),
                Value<int?> age = const Value.absent(),
                Value<double?> heightCm = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<double?> bodyFatPct = const Value.absent(),
                Value<String?> bodyFatMethod = const Value.absent(),
                Value<String> measurementsJson = const Value.absent(),
                Value<String?> goal = const Value.absent(),
                Value<double?> targetWeightKg = const Value.absent(),
                Value<int?> goalWeeks = const Value.absent(),
                Value<String?> level = const Value.absent(),
                Value<String?> trainingExperience = const Value.absent(),
                Value<int?> daysPerWeek = const Value.absent(),
                Value<String> trainingDaysJson = const Value.absent(),
                Value<int?> sessionMinutes = const Value.absent(),
                Value<String?> splitPreference = const Value.absent(),
                Value<String> focusMusclesJson = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<String> injuriesJson = const Value.absent(),
                Value<String?> injuriesNote = const Value.absent(),
                Value<String?> jobType = const Value.absent(),
                Value<String?> jobHours = const Value.absent(),
                Value<String?> sleepTime = const Value.absent(),
                Value<String?> wakeTime = const Value.absent(),
                Value<String?> trainingTimeOfDay = const Value.absent(),
                Value<String?> trainingTime = const Value.absent(),
                Value<String?> cardioType = const Value.absent(),
                Value<int?> cardioPerWeek = const Value.absent(),
                Value<int?> mealsPerDay = const Value.absent(),
                Value<String> mealTimesJson = const Value.absent(),
                Value<String?> likedFoods = const Value.absent(),
                Value<String?> dislikedFoods = const Value.absent(),
                Value<String?> allergies = const Value.absent(),
                Value<String?> budgetLevel = const Value.absent(),
                Value<int?> budgetEgp = const Value.absent(),
                Value<String> supplementsJson = const Value.absent(),
                Value<int?> waterGoalMl = const Value.absent(),
                Value<bool> healthConnectEnabled = const Value.absent(),
                Value<double?> bmr = const Value.absent(),
                Value<double?> tdee = const Value.absent(),
                Value<int?> calorieTarget = const Value.absent(),
                Value<int?> proteinG = const Value.absent(),
                Value<int?> carbsG = const Value.absent(),
                Value<int?> fatG = const Value.absent(),
                Value<int?> trainingDayCarbsG = const Value.absent(),
                Value<int?> restDayCarbsG = const Value.absent(),
                Value<bool> onboardingComplete = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => UserProfilesCompanion.insert(
                id: id,
                language: language,
                sex: sex,
                age: age,
                heightCm: heightCm,
                weightKg: weightKg,
                bodyFatPct: bodyFatPct,
                bodyFatMethod: bodyFatMethod,
                measurementsJson: measurementsJson,
                goal: goal,
                targetWeightKg: targetWeightKg,
                goalWeeks: goalWeeks,
                level: level,
                trainingExperience: trainingExperience,
                daysPerWeek: daysPerWeek,
                trainingDaysJson: trainingDaysJson,
                sessionMinutes: sessionMinutes,
                splitPreference: splitPreference,
                focusMusclesJson: focusMusclesJson,
                location: location,
                injuriesJson: injuriesJson,
                injuriesNote: injuriesNote,
                jobType: jobType,
                jobHours: jobHours,
                sleepTime: sleepTime,
                wakeTime: wakeTime,
                trainingTimeOfDay: trainingTimeOfDay,
                trainingTime: trainingTime,
                cardioType: cardioType,
                cardioPerWeek: cardioPerWeek,
                mealsPerDay: mealsPerDay,
                mealTimesJson: mealTimesJson,
                likedFoods: likedFoods,
                dislikedFoods: dislikedFoods,
                allergies: allergies,
                budgetLevel: budgetLevel,
                budgetEgp: budgetEgp,
                supplementsJson: supplementsJson,
                waterGoalMl: waterGoalMl,
                healthConnectEnabled: healthConnectEnabled,
                bmr: bmr,
                tdee: tdee,
                calorieTarget: calorieTarget,
                proteinG: proteinG,
                carbsG: carbsG,
                fatG: fatG,
                trainingDayCarbsG: trainingDayCarbsG,
                restDayCarbsG: restDayCarbsG,
                onboardingComplete: onboardingComplete,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UserProfilesTable, UserProfile>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $UserProfilesTable,
                    UserProfile
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfilesTable,
      UserProfile,
      $$UserProfilesTableFilterComposer,
      $$UserProfilesTableOrderingComposer,
      $$UserProfilesTableAnnotationComposer,
      $$UserProfilesTableCreateCompanionBuilder,
      $$UserProfilesTableUpdateCompanionBuilder,
      (
        UserProfile,
        BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>,
      ),
      UserProfile,
      PrefetchHooks Function()
    >;
typedef $$ExercisesTableCreateCompanionBuilder = ExercisesCompanion Function({
  required String id,
  required String nameEn,
  required String nameAr,
  Value<String> primaryMusclesJson,
  Value<String> secondaryMusclesJson,
  Value<String?> equipment,
  Value<String?> force,
  Value<String?> movementPattern,
  Value<String?> mechanic,
  Value<String?> category,
  Value<String?> level,
  Value<String> instructionsEnJson,
  Value<String> instructionsArJson,
  Value<String> mistakesEnJson,
  Value<String> mistakesArJson,
  Value<String> imagesJson,
  Value<String?> mediaPath,
  Value<bool> isCustom,
  Value<bool> isFavorite,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$ExercisesTableUpdateCompanionBuilder = ExercisesCompanion Function({
  Value<String> id,
  Value<String> nameEn,
  Value<String> nameAr,
  Value<String> primaryMusclesJson,
  Value<String> secondaryMusclesJson,
  Value<String?> equipment,
  Value<String?> force,
  Value<String?> movementPattern,
  Value<String?> mechanic,
  Value<String?> category,
  Value<String?> level,
  Value<String> instructionsEnJson,
  Value<String> instructionsArJson,
  Value<String> mistakesEnJson,
  Value<String> mistakesArJson,
  Value<String> imagesJson,
  Value<String?> mediaPath,
  Value<bool> isCustom,
  Value<bool> isFavorite,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$ExercisesTableReferences
    extends BaseReferences<_$AppDatabase, $ExercisesTable, Exercise> {
  $$ExercisesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PlanExercisesTable, List<PlanExercise>>
  _planExercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.planExercises,
    aliasName: 'exercises__id__plan_exercises__exercise_id',
  );

  $$PlanExercisesTableProcessedTableManager get planExercisesRefs {
    final manager = $$PlanExercisesTableTableManager(
      $_db,
      $_db.planExercises,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_planExercisesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SetLogsTable, List<SetLog>> _setLogsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.setLogs,
    aliasName: 'exercises__id__set_logs__exercise_id',
  );

  $$SetLogsTableProcessedTableManager get setLogsRefs {
    final manager = $$SetLogsTableTableManager(
      $_db,
      $_db.setLogs,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_setLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get primaryMusclesJson => $composableBuilder(
    column: $table.primaryMusclesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get secondaryMusclesJson => $composableBuilder(
    column: $table.secondaryMusclesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get equipment => $composableBuilder(
    column: $table.equipment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get force => $composableBuilder(
    column: $table.force,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get movementPattern => $composableBuilder(
    column: $table.movementPattern,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mechanic => $composableBuilder(
    column: $table.mechanic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get instructionsEnJson => $composableBuilder(
    column: $table.instructionsEnJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get instructionsArJson => $composableBuilder(
    column: $table.instructionsArJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mistakesEnJson => $composableBuilder(
    column: $table.mistakesEnJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mistakesArJson => $composableBuilder(
    column: $table.mistakesArJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagesJson => $composableBuilder(
    column: $table.imagesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mediaPath => $composableBuilder(
    column: $table.mediaPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> planExercisesRefs(
    Expression<bool> Function($$PlanExercisesTableFilterComposer f) f,
  ) {
    final $$PlanExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.planExercises,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanExercisesTableFilterComposer(
            $db: $db,
            $table: $db.planExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> setLogsRefs(
    Expression<bool> Function($$SetLogsTableFilterComposer f) f,
  ) {
    final $$SetLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.setLogs,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SetLogsTableFilterComposer(
            $db: $db,
            $table: $db.setLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primaryMusclesJson => $composableBuilder(
    column: $table.primaryMusclesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get secondaryMusclesJson => $composableBuilder(
    column: $table.secondaryMusclesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equipment => $composableBuilder(
    column: $table.equipment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get force => $composableBuilder(
    column: $table.force,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get movementPattern => $composableBuilder(
    column: $table.movementPattern,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mechanic => $composableBuilder(
    column: $table.mechanic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get instructionsEnJson => $composableBuilder(
    column: $table.instructionsEnJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get instructionsArJson => $composableBuilder(
    column: $table.instructionsArJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mistakesEnJson => $composableBuilder(
    column: $table.mistakesEnJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mistakesArJson => $composableBuilder(
    column: $table.mistakesArJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagesJson => $composableBuilder(
    column: $table.imagesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaPath => $composableBuilder(
    column: $table.mediaPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<String> get primaryMusclesJson => $composableBuilder(
    column: $table.primaryMusclesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get secondaryMusclesJson => $composableBuilder(
    column: $table.secondaryMusclesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get equipment =>
      $composableBuilder(column: $table.equipment, builder: (column) => column);

  GeneratedColumn<String> get force =>
      $composableBuilder(column: $table.force, builder: (column) => column);

  GeneratedColumn<String> get movementPattern => $composableBuilder(
    column: $table.movementPattern,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mechanic =>
      $composableBuilder(column: $table.mechanic, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get instructionsEnJson => $composableBuilder(
    column: $table.instructionsEnJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get instructionsArJson => $composableBuilder(
    column: $table.instructionsArJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mistakesEnJson => $composableBuilder(
    column: $table.mistakesEnJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mistakesArJson => $composableBuilder(
    column: $table.mistakesArJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imagesJson => $composableBuilder(
    column: $table.imagesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mediaPath =>
      $composableBuilder(column: $table.mediaPath, builder: (column) => column);

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> planExercisesRefs<T extends Object>(
    Expression<T> Function($$PlanExercisesTableAnnotationComposer a) f,
  ) {
    final $$PlanExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.planExercises,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.planExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> setLogsRefs<T extends Object>(
    Expression<T> Function($$SetLogsTableAnnotationComposer a) f,
  ) {
    final $$SetLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.setLogs,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SetLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.setLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExercisesTable,
          Exercise,
          $$ExercisesTableFilterComposer,
          $$ExercisesTableOrderingComposer,
          $$ExercisesTableAnnotationComposer,
          $$ExercisesTableCreateCompanionBuilder,
          $$ExercisesTableUpdateCompanionBuilder,
          (Exercise, $$ExercisesTableReferences),
          Exercise,
          PrefetchHooks Function({bool planExercisesRefs, bool setLogsRefs})
        > {
  $$ExercisesTableTableManager(_$AppDatabase db, $ExercisesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
                Value<String> nameAr = const Value.absent(),
                Value<String> primaryMusclesJson = const Value.absent(),
                Value<String> secondaryMusclesJson = const Value.absent(),
                Value<String?> equipment = const Value.absent(),
                Value<String?> force = const Value.absent(),
                Value<String?> movementPattern = const Value.absent(),
                Value<String?> mechanic = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String?> level = const Value.absent(),
                Value<String> instructionsEnJson = const Value.absent(),
                Value<String> instructionsArJson = const Value.absent(),
                Value<String> mistakesEnJson = const Value.absent(),
                Value<String> mistakesArJson = const Value.absent(),
                Value<String> imagesJson = const Value.absent(),
                Value<String?> mediaPath = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExercisesCompanion(
                id: id,
                nameEn: nameEn,
                nameAr: nameAr,
                primaryMusclesJson: primaryMusclesJson,
                secondaryMusclesJson: secondaryMusclesJson,
                equipment: equipment,
                force: force,
                movementPattern: movementPattern,
                mechanic: mechanic,
                category: category,
                level: level,
                instructionsEnJson: instructionsEnJson,
                instructionsArJson: instructionsArJson,
                mistakesEnJson: mistakesEnJson,
                mistakesArJson: mistakesArJson,
                imagesJson: imagesJson,
                mediaPath: mediaPath,
                isCustom: isCustom,
                isFavorite: isFavorite,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nameEn,
                required String nameAr,
                Value<String> primaryMusclesJson = const Value.absent(),
                Value<String> secondaryMusclesJson = const Value.absent(),
                Value<String?> equipment = const Value.absent(),
                Value<String?> force = const Value.absent(),
                Value<String?> movementPattern = const Value.absent(),
                Value<String?> mechanic = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String?> level = const Value.absent(),
                Value<String> instructionsEnJson = const Value.absent(),
                Value<String> instructionsArJson = const Value.absent(),
                Value<String> mistakesEnJson = const Value.absent(),
                Value<String> mistakesArJson = const Value.absent(),
                Value<String> imagesJson = const Value.absent(),
                Value<String?> mediaPath = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExercisesCompanion.insert(
                id: id,
                nameEn: nameEn,
                nameAr: nameAr,
                primaryMusclesJson: primaryMusclesJson,
                secondaryMusclesJson: secondaryMusclesJson,
                equipment: equipment,
                force: force,
                movementPattern: movementPattern,
                mechanic: mechanic,
                category: category,
                level: level,
                instructionsEnJson: instructionsEnJson,
                instructionsArJson: instructionsArJson,
                mistakesEnJson: mistakesEnJson,
                mistakesArJson: mistakesArJson,
                imagesJson: imagesJson,
                mediaPath: mediaPath,
                isCustom: isCustom,
                isFavorite: isFavorite,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExercisesTable, Exercise>(table),
                  $$ExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({planExercisesRefs = false, setLogsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (planExercisesRefs) db.planExercises,
                    if (setLogsRefs) db.setLogs,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (planExercisesRefs)
                        await $_getPrefetchedData<
                          Exercise,
                          $ExercisesTable,
                          PlanExercise
                        >(
                          currentTable: table,
                          referencedTable: $$ExercisesTableReferences
                              ._planExercisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).planExercisesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.exerciseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (setLogsRefs)
                        await $_getPrefetchedData<
                          Exercise,
                          $ExercisesTable,
                          SetLog
                        >(
                          currentTable: table,
                          referencedTable: $$ExercisesTableReferences
                              ._setLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).setLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.exerciseId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExercisesTable,
      Exercise,
      $$ExercisesTableFilterComposer,
      $$ExercisesTableOrderingComposer,
      $$ExercisesTableAnnotationComposer,
      $$ExercisesTableCreateCompanionBuilder,
      $$ExercisesTableUpdateCompanionBuilder,
      (Exercise, $$ExercisesTableReferences),
      Exercise,
      PrefetchHooks Function({bool planExercisesRefs, bool setLogsRefs})
    >;
typedef $$WorkoutPlansTableCreateCompanionBuilder =
    WorkoutPlansCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> notes,
      Value<String> source,
      Value<bool> isActive,
      Value<int?> deloadEveryWeeks,
      Value<String?> rawJson,
      Value<DateTime> createdAt,
      Value<DateTime?> activatedAt,
    });
typedef $$WorkoutPlansTableUpdateCompanionBuilder =
    WorkoutPlansCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> notes,
      Value<String> source,
      Value<bool> isActive,
      Value<int?> deloadEveryWeeks,
      Value<String?> rawJson,
      Value<DateTime> createdAt,
      Value<DateTime?> activatedAt,
    });

final class $$WorkoutPlansTableReferences
    extends BaseReferences<_$AppDatabase, $WorkoutPlansTable, WorkoutPlan> {
  $$WorkoutPlansTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PlanDaysTable, List<PlanDay>> _planDaysRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.planDays,
    aliasName: 'workout_plans__id__plan_days__plan_id',
  );

  $$PlanDaysTableProcessedTableManager get planDaysRefs {
    final manager = $$PlanDaysTableTableManager(
      $_db,
      $_db.planDays,
    ).filter((f) => f.planId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_planDaysRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutPlansTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutPlansTable> {
  $$WorkoutPlansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deloadEveryWeeks => $composableBuilder(
    column: $table.deloadEveryWeeks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawJson => $composableBuilder(
    column: $table.rawJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get activatedAt => $composableBuilder(
    column: $table.activatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> planDaysRefs(
    Expression<bool> Function($$PlanDaysTableFilterComposer f) f,
  ) {
    final $$PlanDaysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.planDays,
      getReferencedColumn: (t) => t.planId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanDaysTableFilterComposer(
            $db: $db,
            $table: $db.planDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutPlansTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutPlansTable> {
  $$WorkoutPlansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deloadEveryWeeks => $composableBuilder(
    column: $table.deloadEveryWeeks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawJson => $composableBuilder(
    column: $table.rawJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get activatedAt => $composableBuilder(
    column: $table.activatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkoutPlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutPlansTable> {
  $$WorkoutPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get deloadEveryWeeks => $composableBuilder(
    column: $table.deloadEveryWeeks,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rawJson =>
      $composableBuilder(column: $table.rawJson, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get activatedAt => $composableBuilder(
    column: $table.activatedAt,
    builder: (column) => column,
  );

  Expression<T> planDaysRefs<T extends Object>(
    Expression<T> Function($$PlanDaysTableAnnotationComposer a) f,
  ) {
    final $$PlanDaysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.planDays,
      getReferencedColumn: (t) => t.planId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanDaysTableAnnotationComposer(
            $db: $db,
            $table: $db.planDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutPlansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutPlansTable,
          WorkoutPlan,
          $$WorkoutPlansTableFilterComposer,
          $$WorkoutPlansTableOrderingComposer,
          $$WorkoutPlansTableAnnotationComposer,
          $$WorkoutPlansTableCreateCompanionBuilder,
          $$WorkoutPlansTableUpdateCompanionBuilder,
          (WorkoutPlan, $$WorkoutPlansTableReferences),
          WorkoutPlan,
          PrefetchHooks Function({bool planDaysRefs})
        > {
  $$WorkoutPlansTableTableManager(_$AppDatabase db, $WorkoutPlansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int?> deloadEveryWeeks = const Value.absent(),
                Value<String?> rawJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> activatedAt = const Value.absent(),
              }) => WorkoutPlansCompanion(
                id: id,
                name: name,
                notes: notes,
                source: source,
                isActive: isActive,
                deloadEveryWeeks: deloadEveryWeeks,
                rawJson: rawJson,
                createdAt: createdAt,
                activatedAt: activatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> notes = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int?> deloadEveryWeeks = const Value.absent(),
                Value<String?> rawJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> activatedAt = const Value.absent(),
              }) => WorkoutPlansCompanion.insert(
                id: id,
                name: name,
                notes: notes,
                source: source,
                isActive: isActive,
                deloadEveryWeeks: deloadEveryWeeks,
                rawJson: rawJson,
                createdAt: createdAt,
                activatedAt: activatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkoutPlansTable, WorkoutPlan>(table),
                  $$WorkoutPlansTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({planDaysRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (planDaysRefs) db.planDays],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (planDaysRefs)
                    await $_getPrefetchedData<
                      WorkoutPlan,
                      $WorkoutPlansTable,
                      PlanDay
                    >(
                      currentTable: table,
                      referencedTable: $$WorkoutPlansTableReferences
                          ._planDaysRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$WorkoutPlansTableReferences(
                            db,
                            table,
                            p0,
                          ).planDaysRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.planId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$WorkoutPlansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutPlansTable,
      WorkoutPlan,
      $$WorkoutPlansTableFilterComposer,
      $$WorkoutPlansTableOrderingComposer,
      $$WorkoutPlansTableAnnotationComposer,
      $$WorkoutPlansTableCreateCompanionBuilder,
      $$WorkoutPlansTableUpdateCompanionBuilder,
      (WorkoutPlan, $$WorkoutPlansTableReferences),
      WorkoutPlan,
      PrefetchHooks Function({bool planDaysRefs})
    >;
typedef $$PlanDaysTableCreateCompanionBuilder = PlanDaysCompanion Function({
  Value<int> id,
  required int planId,
  Value<int?> weekday,
  Value<int> orderIndex,
  required String name,
  Value<String?> focus,
  Value<String> warmupJson,
  Value<String> cooldownJson,
  Value<bool> isRest,
});
typedef $$PlanDaysTableUpdateCompanionBuilder = PlanDaysCompanion Function({
  Value<int> id,
  Value<int> planId,
  Value<int?> weekday,
  Value<int> orderIndex,
  Value<String> name,
  Value<String?> focus,
  Value<String> warmupJson,
  Value<String> cooldownJson,
  Value<bool> isRest,
});

final class $$PlanDaysTableReferences
    extends BaseReferences<_$AppDatabase, $PlanDaysTable, PlanDay> {
  $$PlanDaysTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutPlansTable _planIdTable(_$AppDatabase db) =>
      db.workoutPlans.createAlias('plan_days__plan_id__workout_plans__id');

  $$WorkoutPlansTableProcessedTableManager get planId {
    final $_column = $_itemColumn<int>('plan_id')!;

    final manager = $$WorkoutPlansTableTableManager(
      $_db,
      $_db.workoutPlans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_planIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PlanExercisesTable, List<PlanExercise>>
  _planExercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.planExercises,
    aliasName: 'plan_days__id__plan_exercises__plan_day_id',
  );

  $$PlanExercisesTableProcessedTableManager get planExercisesRefs {
    final manager = $$PlanExercisesTableTableManager(
      $_db,
      $_db.planExercises,
    ).filter((f) => f.planDayId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_planExercisesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WorkoutSessionsTable, List<WorkoutSession>>
  _workoutSessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutSessions,
    aliasName: 'plan_days__id__workout_sessions__plan_day_id',
  );

  $$WorkoutSessionsTableProcessedTableManager get workoutSessionsRefs {
    final manager = $$WorkoutSessionsTableTableManager(
      $_db,
      $_db.workoutSessions,
    ).filter((f) => f.planDayId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workoutSessionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PlanDaysTableFilterComposer
    extends Composer<_$AppDatabase, $PlanDaysTable> {
  $$PlanDaysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get focus => $composableBuilder(
    column: $table.focus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get warmupJson => $composableBuilder(
    column: $table.warmupJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cooldownJson => $composableBuilder(
    column: $table.cooldownJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRest => $composableBuilder(
    column: $table.isRest,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutPlansTableFilterComposer get planId {
    final $$WorkoutPlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.workoutPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutPlansTableFilterComposer(
            $db: $db,
            $table: $db.workoutPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> planExercisesRefs(
    Expression<bool> Function($$PlanExercisesTableFilterComposer f) f,
  ) {
    final $$PlanExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.planExercises,
      getReferencedColumn: (t) => t.planDayId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanExercisesTableFilterComposer(
            $db: $db,
            $table: $db.planExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> workoutSessionsRefs(
    Expression<bool> Function($$WorkoutSessionsTableFilterComposer f) f,
  ) {
    final $$WorkoutSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.planDayId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlanDaysTableOrderingComposer
    extends Composer<_$AppDatabase, $PlanDaysTable> {
  $$PlanDaysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get focus => $composableBuilder(
    column: $table.focus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get warmupJson => $composableBuilder(
    column: $table.warmupJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cooldownJson => $composableBuilder(
    column: $table.cooldownJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRest => $composableBuilder(
    column: $table.isRest,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutPlansTableOrderingComposer get planId {
    final $$WorkoutPlansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.workoutPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutPlansTableOrderingComposer(
            $db: $db,
            $table: $db.workoutPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlanDaysTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlanDaysTable> {
  $$PlanDaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get focus =>
      $composableBuilder(column: $table.focus, builder: (column) => column);

  GeneratedColumn<String> get warmupJson => $composableBuilder(
    column: $table.warmupJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cooldownJson => $composableBuilder(
    column: $table.cooldownJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isRest =>
      $composableBuilder(column: $table.isRest, builder: (column) => column);

  $$WorkoutPlansTableAnnotationComposer get planId {
    final $$WorkoutPlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.workoutPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutPlansTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> planExercisesRefs<T extends Object>(
    Expression<T> Function($$PlanExercisesTableAnnotationComposer a) f,
  ) {
    final $$PlanExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.planExercises,
      getReferencedColumn: (t) => t.planDayId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.planExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> workoutSessionsRefs<T extends Object>(
    Expression<T> Function($$WorkoutSessionsTableAnnotationComposer a) f,
  ) {
    final $$WorkoutSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.planDayId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlanDaysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlanDaysTable,
          PlanDay,
          $$PlanDaysTableFilterComposer,
          $$PlanDaysTableOrderingComposer,
          $$PlanDaysTableAnnotationComposer,
          $$PlanDaysTableCreateCompanionBuilder,
          $$PlanDaysTableUpdateCompanionBuilder,
          (PlanDay, $$PlanDaysTableReferences),
          PlanDay,
          PrefetchHooks Function({
            bool planId,
            bool planExercisesRefs,
            bool workoutSessionsRefs,
          })
        > {
  $$PlanDaysTableTableManager(_$AppDatabase db, $PlanDaysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlanDaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlanDaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlanDaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> planId = const Value.absent(),
                Value<int?> weekday = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> focus = const Value.absent(),
                Value<String> warmupJson = const Value.absent(),
                Value<String> cooldownJson = const Value.absent(),
                Value<bool> isRest = const Value.absent(),
              }) => PlanDaysCompanion(
                id: id,
                planId: planId,
                weekday: weekday,
                orderIndex: orderIndex,
                name: name,
                focus: focus,
                warmupJson: warmupJson,
                cooldownJson: cooldownJson,
                isRest: isRest,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int planId,
                Value<int?> weekday = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                required String name,
                Value<String?> focus = const Value.absent(),
                Value<String> warmupJson = const Value.absent(),
                Value<String> cooldownJson = const Value.absent(),
                Value<bool> isRest = const Value.absent(),
              }) => PlanDaysCompanion.insert(
                id: id,
                planId: planId,
                weekday: weekday,
                orderIndex: orderIndex,
                name: name,
                focus: focus,
                warmupJson: warmupJson,
                cooldownJson: cooldownJson,
                isRest: isRest,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlanDaysTable, PlanDay>(table),
                  $$PlanDaysTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                planId = false,
                planExercisesRefs = false,
                workoutSessionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (planExercisesRefs) db.planExercises,
                    if (workoutSessionsRefs) db.workoutSessions,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (planId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.planId,
                            referencedTable: $$PlanDaysTableReferences
                                ._planIdTable(db),
                            referencedColumn: $$PlanDaysTableReferences
                                ._planIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (planExercisesRefs)
                        await $_getPrefetchedData<
                          PlanDay,
                          $PlanDaysTable,
                          PlanExercise
                        >(
                          currentTable: table,
                          referencedTable: $$PlanDaysTableReferences
                              ._planExercisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlanDaysTableReferences(
                                db,
                                table,
                                p0,
                              ).planExercisesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.planDayId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (workoutSessionsRefs)
                        await $_getPrefetchedData<
                          PlanDay,
                          $PlanDaysTable,
                          WorkoutSession
                        >(
                          currentTable: table,
                          referencedTable: $$PlanDaysTableReferences
                              ._workoutSessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlanDaysTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutSessionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.planDayId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PlanDaysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlanDaysTable,
      PlanDay,
      $$PlanDaysTableFilterComposer,
      $$PlanDaysTableOrderingComposer,
      $$PlanDaysTableAnnotationComposer,
      $$PlanDaysTableCreateCompanionBuilder,
      $$PlanDaysTableUpdateCompanionBuilder,
      (PlanDay, $$PlanDaysTableReferences),
      PlanDay,
      PrefetchHooks Function({
        bool planId,
        bool planExercisesRefs,
        bool workoutSessionsRefs,
      })
    >;
typedef $$PlanExercisesTableCreateCompanionBuilder =
    PlanExercisesCompanion Function({
      Value<int> id,
      required int planDayId,
      required String exerciseId,
      Value<int> orderIndex,
      Value<int> sets,
      Value<int> repMin,
      Value<int> repMax,
      Value<double?> suggestedWeightKg,
      Value<double?> targetRpe,
      Value<int> restSeconds,
      Value<String?> notes,
    });
typedef $$PlanExercisesTableUpdateCompanionBuilder =
    PlanExercisesCompanion Function({
      Value<int> id,
      Value<int> planDayId,
      Value<String> exerciseId,
      Value<int> orderIndex,
      Value<int> sets,
      Value<int> repMin,
      Value<int> repMax,
      Value<double?> suggestedWeightKg,
      Value<double?> targetRpe,
      Value<int> restSeconds,
      Value<String?> notes,
    });

final class $$PlanExercisesTableReferences
    extends BaseReferences<_$AppDatabase, $PlanExercisesTable, PlanExercise> {
  $$PlanExercisesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PlanDaysTable _planDayIdTable(_$AppDatabase db) =>
      db.planDays.createAlias('plan_exercises__plan_day_id__plan_days__id');

  $$PlanDaysTableProcessedTableManager get planDayId {
    final $_column = $_itemColumn<int>('plan_day_id')!;

    final manager = $$PlanDaysTableTableManager(
      $_db,
      $_db.planDays,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_planDayIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExercisesTable _exerciseIdTable(_$AppDatabase db) =>
      db.exercises.createAlias('plan_exercises__exercise_id__exercises__id');

  $$ExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<String>('exercise_id')!;

    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PlanExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $PlanExercisesTable> {
  $$PlanExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sets => $composableBuilder(
    column: $table.sets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repMin => $composableBuilder(
    column: $table.repMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repMax => $composableBuilder(
    column: $table.repMax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get suggestedWeightKg => $composableBuilder(
    column: $table.suggestedWeightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetRpe => $composableBuilder(
    column: $table.targetRpe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$PlanDaysTableFilterComposer get planDayId {
    final $$PlanDaysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planDayId,
      referencedTable: $db.planDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanDaysTableFilterComposer(
            $db: $db,
            $table: $db.planDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlanExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $PlanExercisesTable> {
  $$PlanExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sets => $composableBuilder(
    column: $table.sets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repMin => $composableBuilder(
    column: $table.repMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repMax => $composableBuilder(
    column: $table.repMax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get suggestedWeightKg => $composableBuilder(
    column: $table.suggestedWeightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetRpe => $composableBuilder(
    column: $table.targetRpe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$PlanDaysTableOrderingComposer get planDayId {
    final $$PlanDaysTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planDayId,
      referencedTable: $db.planDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanDaysTableOrderingComposer(
            $db: $db,
            $table: $db.planDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlanExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlanExercisesTable> {
  $$PlanExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sets =>
      $composableBuilder(column: $table.sets, builder: (column) => column);

  GeneratedColumn<int> get repMin =>
      $composableBuilder(column: $table.repMin, builder: (column) => column);

  GeneratedColumn<int> get repMax =>
      $composableBuilder(column: $table.repMax, builder: (column) => column);

  GeneratedColumn<double> get suggestedWeightKg => $composableBuilder(
    column: $table.suggestedWeightKg,
    builder: (column) => column,
  );

  GeneratedColumn<double> get targetRpe =>
      $composableBuilder(column: $table.targetRpe, builder: (column) => column);

  GeneratedColumn<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$PlanDaysTableAnnotationComposer get planDayId {
    final $$PlanDaysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planDayId,
      referencedTable: $db.planDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanDaysTableAnnotationComposer(
            $db: $db,
            $table: $db.planDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlanExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlanExercisesTable,
          PlanExercise,
          $$PlanExercisesTableFilterComposer,
          $$PlanExercisesTableOrderingComposer,
          $$PlanExercisesTableAnnotationComposer,
          $$PlanExercisesTableCreateCompanionBuilder,
          $$PlanExercisesTableUpdateCompanionBuilder,
          (PlanExercise, $$PlanExercisesTableReferences),
          PlanExercise,
          PrefetchHooks Function({bool planDayId, bool exerciseId})
        > {
  $$PlanExercisesTableTableManager(_$AppDatabase db, $PlanExercisesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlanExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlanExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlanExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> planDayId = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<int> sets = const Value.absent(),
                Value<int> repMin = const Value.absent(),
                Value<int> repMax = const Value.absent(),
                Value<double?> suggestedWeightKg = const Value.absent(),
                Value<double?> targetRpe = const Value.absent(),
                Value<int> restSeconds = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => PlanExercisesCompanion(
                id: id,
                planDayId: planDayId,
                exerciseId: exerciseId,
                orderIndex: orderIndex,
                sets: sets,
                repMin: repMin,
                repMax: repMax,
                suggestedWeightKg: suggestedWeightKg,
                targetRpe: targetRpe,
                restSeconds: restSeconds,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int planDayId,
                required String exerciseId,
                Value<int> orderIndex = const Value.absent(),
                Value<int> sets = const Value.absent(),
                Value<int> repMin = const Value.absent(),
                Value<int> repMax = const Value.absent(),
                Value<double?> suggestedWeightKg = const Value.absent(),
                Value<double?> targetRpe = const Value.absent(),
                Value<int> restSeconds = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => PlanExercisesCompanion.insert(
                id: id,
                planDayId: planDayId,
                exerciseId: exerciseId,
                orderIndex: orderIndex,
                sets: sets,
                repMin: repMin,
                repMax: repMax,
                suggestedWeightKg: suggestedWeightKg,
                targetRpe: targetRpe,
                restSeconds: restSeconds,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlanExercisesTable, PlanExercise>(table),
                  $$PlanExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({planDayId = false, exerciseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (planDayId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.planDayId,
                        referencedTable: $$PlanExercisesTableReferences
                            ._planDayIdTable(db),
                        referencedColumn: $$PlanExercisesTableReferences
                            ._planDayIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (exerciseId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.exerciseId,
                        referencedTable: $$PlanExercisesTableReferences
                            ._exerciseIdTable(db),
                        referencedColumn: $$PlanExercisesTableReferences
                            ._exerciseIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PlanExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlanExercisesTable,
      PlanExercise,
      $$PlanExercisesTableFilterComposer,
      $$PlanExercisesTableOrderingComposer,
      $$PlanExercisesTableAnnotationComposer,
      $$PlanExercisesTableCreateCompanionBuilder,
      $$PlanExercisesTableUpdateCompanionBuilder,
      (PlanExercise, $$PlanExercisesTableReferences),
      PlanExercise,
      PrefetchHooks Function({bool planDayId, bool exerciseId})
    >;
typedef $$WorkoutSessionsTableCreateCompanionBuilder =
    WorkoutSessionsCompanion Function({
      Value<int> id,
      required DateTime date,
      Value<int?> planDayId,
      Value<String?> name,
      Value<DateTime?> startedAt,
      Value<DateTime?> endedAt,
      Value<String> status,
      Value<String?> notes,
      Value<double?> totalVolume,
      Value<String?> aiSummary,
      Value<bool> isDeload,
    });
typedef $$WorkoutSessionsTableUpdateCompanionBuilder =
    WorkoutSessionsCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<int?> planDayId,
      Value<String?> name,
      Value<DateTime?> startedAt,
      Value<DateTime?> endedAt,
      Value<String> status,
      Value<String?> notes,
      Value<double?> totalVolume,
      Value<String?> aiSummary,
      Value<bool> isDeload,
    });

final class $$WorkoutSessionsTableReferences
    extends
        BaseReferences<_$AppDatabase, $WorkoutSessionsTable, WorkoutSession> {
  $$WorkoutSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PlanDaysTable _planDayIdTable(_$AppDatabase db) =>
      db.planDays.createAlias('workout_sessions__plan_day_id__plan_days__id');

  $$PlanDaysTableProcessedTableManager? get planDayId {
    final $_column = $_itemColumn<int>('plan_day_id');
    if ($_column == null) return null;
    final manager = $$PlanDaysTableTableManager(
      $_db,
      $_db.planDays,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_planDayIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SetLogsTable, List<SetLog>> _setLogsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.setLogs,
    aliasName: 'workout_sessions__id__set_logs__session_id',
  );

  $$SetLogsTableProcessedTableManager get setLogsRefs {
    final manager = $$SetLogsTableTableManager(
      $_db,
      $_db.setLogs,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_setLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $SessionExerciseNotesTable,
    List<SessionExerciseNote>
  >
  _sessionExerciseNotesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.sessionExerciseNotes,
        aliasName: 'workout_sessions__id__session_exercise_notes__session_id',
      );

  $$SessionExerciseNotesTableProcessedTableManager
  get sessionExerciseNotesRefs {
    final manager = $$SessionExerciseNotesTableTableManager(
      $_db,
      $_db.sessionExerciseNotes,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _sessionExerciseNotesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CardioLogsTable, List<CardioLog>>
  _cardioLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cardioLogs,
    aliasName: 'workout_sessions__id__cardio_logs__session_id',
  );

  $$CardioLogsTableProcessedTableManager get cardioLogsRefs {
    final manager = $$CardioLogsTableTableManager(
      $_db,
      $_db.cardioLogs,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_cardioLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalVolume => $composableBuilder(
    column: $table.totalVolume,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aiSummary => $composableBuilder(
    column: $table.aiSummary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeload => $composableBuilder(
    column: $table.isDeload,
    builder: (column) => ColumnFilters(column),
  );

  $$PlanDaysTableFilterComposer get planDayId {
    final $$PlanDaysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planDayId,
      referencedTable: $db.planDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanDaysTableFilterComposer(
            $db: $db,
            $table: $db.planDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> setLogsRefs(
    Expression<bool> Function($$SetLogsTableFilterComposer f) f,
  ) {
    final $$SetLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.setLogs,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SetLogsTableFilterComposer(
            $db: $db,
            $table: $db.setLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> sessionExerciseNotesRefs(
    Expression<bool> Function($$SessionExerciseNotesTableFilterComposer f) f,
  ) {
    final $$SessionExerciseNotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionExerciseNotes,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionExerciseNotesTableFilterComposer(
            $db: $db,
            $table: $db.sessionExerciseNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> cardioLogsRefs(
    Expression<bool> Function($$CardioLogsTableFilterComposer f) f,
  ) {
    final $$CardioLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cardioLogs,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardioLogsTableFilterComposer(
            $db: $db,
            $table: $db.cardioLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalVolume => $composableBuilder(
    column: $table.totalVolume,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aiSummary => $composableBuilder(
    column: $table.aiSummary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeload => $composableBuilder(
    column: $table.isDeload,
    builder: (column) => ColumnOrderings(column),
  );

  $$PlanDaysTableOrderingComposer get planDayId {
    final $$PlanDaysTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planDayId,
      referencedTable: $db.planDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanDaysTableOrderingComposer(
            $db: $db,
            $table: $db.planDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<double> get totalVolume => $composableBuilder(
    column: $table.totalVolume,
    builder: (column) => column,
  );

  GeneratedColumn<String> get aiSummary =>
      $composableBuilder(column: $table.aiSummary, builder: (column) => column);

  GeneratedColumn<bool> get isDeload =>
      $composableBuilder(column: $table.isDeload, builder: (column) => column);

  $$PlanDaysTableAnnotationComposer get planDayId {
    final $$PlanDaysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planDayId,
      referencedTable: $db.planDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanDaysTableAnnotationComposer(
            $db: $db,
            $table: $db.planDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> setLogsRefs<T extends Object>(
    Expression<T> Function($$SetLogsTableAnnotationComposer a) f,
  ) {
    final $$SetLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.setLogs,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SetLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.setLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> sessionExerciseNotesRefs<T extends Object>(
    Expression<T> Function($$SessionExerciseNotesTableAnnotationComposer a) f,
  ) {
    final $$SessionExerciseNotesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.sessionExerciseNotes,
          getReferencedColumn: (t) => t.sessionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SessionExerciseNotesTableAnnotationComposer(
                $db: $db,
                $table: $db.sessionExerciseNotes,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> cardioLogsRefs<T extends Object>(
    Expression<T> Function($$CardioLogsTableAnnotationComposer a) f,
  ) {
    final $$CardioLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cardioLogs,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardioLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.cardioLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutSessionsTable,
          WorkoutSession,
          $$WorkoutSessionsTableFilterComposer,
          $$WorkoutSessionsTableOrderingComposer,
          $$WorkoutSessionsTableAnnotationComposer,
          $$WorkoutSessionsTableCreateCompanionBuilder,
          $$WorkoutSessionsTableUpdateCompanionBuilder,
          (WorkoutSession, $$WorkoutSessionsTableReferences),
          WorkoutSession,
          PrefetchHooks Function({
            bool planDayId,
            bool setLogsRefs,
            bool sessionExerciseNotesRefs,
            bool cardioLogsRefs,
          })
        > {
  $$WorkoutSessionsTableTableManager(
    _$AppDatabase db,
    $WorkoutSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int?> planDayId = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<double?> totalVolume = const Value.absent(),
                Value<String?> aiSummary = const Value.absent(),
                Value<bool> isDeload = const Value.absent(),
              }) => WorkoutSessionsCompanion(
                id: id,
                date: date,
                planDayId: planDayId,
                name: name,
                startedAt: startedAt,
                endedAt: endedAt,
                status: status,
                notes: notes,
                totalVolume: totalVolume,
                aiSummary: aiSummary,
                isDeload: isDeload,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                Value<int?> planDayId = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<double?> totalVolume = const Value.absent(),
                Value<String?> aiSummary = const Value.absent(),
                Value<bool> isDeload = const Value.absent(),
              }) => WorkoutSessionsCompanion.insert(
                id: id,
                date: date,
                planDayId: planDayId,
                name: name,
                startedAt: startedAt,
                endedAt: endedAt,
                status: status,
                notes: notes,
                totalVolume: totalVolume,
                aiSummary: aiSummary,
                isDeload: isDeload,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkoutSessionsTable, WorkoutSession>(table),
                  $$WorkoutSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                planDayId = false,
                setLogsRefs = false,
                sessionExerciseNotesRefs = false,
                cardioLogsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (setLogsRefs) db.setLogs,
                    if (sessionExerciseNotesRefs) db.sessionExerciseNotes,
                    if (cardioLogsRefs) db.cardioLogs,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (planDayId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.planDayId,
                            referencedTable: $$WorkoutSessionsTableReferences
                                ._planDayIdTable(db),
                            referencedColumn: $$WorkoutSessionsTableReferences
                                ._planDayIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (setLogsRefs)
                        await $_getPrefetchedData<
                          WorkoutSession,
                          $WorkoutSessionsTable,
                          SetLog
                        >(
                          currentTable: table,
                          referencedTable: $$WorkoutSessionsTableReferences
                              ._setLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutSessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).setLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (sessionExerciseNotesRefs)
                        await $_getPrefetchedData<
                          WorkoutSession,
                          $WorkoutSessionsTable,
                          SessionExerciseNote
                        >(
                          currentTable: table,
                          referencedTable: $$WorkoutSessionsTableReferences
                              ._sessionExerciseNotesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutSessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).sessionExerciseNotesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (cardioLogsRefs)
                        await $_getPrefetchedData<
                          WorkoutSession,
                          $WorkoutSessionsTable,
                          CardioLog
                        >(
                          currentTable: table,
                          referencedTable: $$WorkoutSessionsTableReferences
                              ._cardioLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutSessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).cardioLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$WorkoutSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutSessionsTable,
      WorkoutSession,
      $$WorkoutSessionsTableFilterComposer,
      $$WorkoutSessionsTableOrderingComposer,
      $$WorkoutSessionsTableAnnotationComposer,
      $$WorkoutSessionsTableCreateCompanionBuilder,
      $$WorkoutSessionsTableUpdateCompanionBuilder,
      (WorkoutSession, $$WorkoutSessionsTableReferences),
      WorkoutSession,
      PrefetchHooks Function({
        bool planDayId,
        bool setLogsRefs,
        bool sessionExerciseNotesRefs,
        bool cardioLogsRefs,
      })
    >;
typedef $$SetLogsTableCreateCompanionBuilder = SetLogsCompanion Function({
  Value<int> id,
  required int sessionId,
  required String exerciseId,
  required int setIndex,
  required double weightKg,
  required int reps,
  Value<double?> rpe,
  Value<String> setType,
  Value<bool> isPr,
  Value<String?> prTypes,
  Value<DateTime> createdAt,
});
typedef $$SetLogsTableUpdateCompanionBuilder = SetLogsCompanion Function({
  Value<int> id,
  Value<int> sessionId,
  Value<String> exerciseId,
  Value<int> setIndex,
  Value<double> weightKg,
  Value<int> reps,
  Value<double?> rpe,
  Value<String> setType,
  Value<bool> isPr,
  Value<String?> prTypes,
  Value<DateTime> createdAt,
});

final class $$SetLogsTableReferences
    extends BaseReferences<_$AppDatabase, $SetLogsTable, SetLog> {
  $$SetLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutSessionsTable _sessionIdTable(_$AppDatabase db) => db
      .workoutSessions
      .createAlias('set_logs__session_id__workout_sessions__id');

  $$WorkoutSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager = $$WorkoutSessionsTableTableManager(
      $_db,
      $_db.workoutSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExercisesTable _exerciseIdTable(_$AppDatabase db) =>
      db.exercises.createAlias('set_logs__exercise_id__exercises__id');

  $$ExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<String>('exercise_id')!;

    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SetLogsTableFilterComposer
    extends Composer<_$AppDatabase, $SetLogsTable> {
  $$SetLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get setIndex => $composableBuilder(
    column: $table.setIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rpe => $composableBuilder(
    column: $table.rpe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get setType => $composableBuilder(
    column: $table.setType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPr => $composableBuilder(
    column: $table.isPr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prTypes => $composableBuilder(
    column: $table.prTypes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutSessionsTableFilterComposer get sessionId {
    final $$WorkoutSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SetLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $SetLogsTable> {
  $$SetLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get setIndex => $composableBuilder(
    column: $table.setIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rpe => $composableBuilder(
    column: $table.rpe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get setType => $composableBuilder(
    column: $table.setType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPr => $composableBuilder(
    column: $table.isPr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prTypes => $composableBuilder(
    column: $table.prTypes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutSessionsTableOrderingComposer get sessionId {
    final $$WorkoutSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SetLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SetLogsTable> {
  $$SetLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get setIndex =>
      $composableBuilder(column: $table.setIndex, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<double> get rpe =>
      $composableBuilder(column: $table.rpe, builder: (column) => column);

  GeneratedColumn<String> get setType =>
      $composableBuilder(column: $table.setType, builder: (column) => column);

  GeneratedColumn<bool> get isPr =>
      $composableBuilder(column: $table.isPr, builder: (column) => column);

  GeneratedColumn<String> get prTypes =>
      $composableBuilder(column: $table.prTypes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$WorkoutSessionsTableAnnotationComposer get sessionId {
    final $$WorkoutSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SetLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SetLogsTable,
          SetLog,
          $$SetLogsTableFilterComposer,
          $$SetLogsTableOrderingComposer,
          $$SetLogsTableAnnotationComposer,
          $$SetLogsTableCreateCompanionBuilder,
          $$SetLogsTableUpdateCompanionBuilder,
          (SetLog, $$SetLogsTableReferences),
          SetLog,
          PrefetchHooks Function({bool sessionId, bool exerciseId})
        > {
  $$SetLogsTableTableManager(_$AppDatabase db, $SetLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SetLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SetLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SetLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sessionId = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<int> setIndex = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<int> reps = const Value.absent(),
                Value<double?> rpe = const Value.absent(),
                Value<String> setType = const Value.absent(),
                Value<bool> isPr = const Value.absent(),
                Value<String?> prTypes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SetLogsCompanion(
                id: id,
                sessionId: sessionId,
                exerciseId: exerciseId,
                setIndex: setIndex,
                weightKg: weightKg,
                reps: reps,
                rpe: rpe,
                setType: setType,
                isPr: isPr,
                prTypes: prTypes,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sessionId,
                required String exerciseId,
                required int setIndex,
                required double weightKg,
                required int reps,
                Value<double?> rpe = const Value.absent(),
                Value<String> setType = const Value.absent(),
                Value<bool> isPr = const Value.absent(),
                Value<String?> prTypes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SetLogsCompanion.insert(
                id: id,
                sessionId: sessionId,
                exerciseId: exerciseId,
                setIndex: setIndex,
                weightKg: weightKg,
                reps: reps,
                rpe: rpe,
                setType: setType,
                isPr: isPr,
                prTypes: prTypes,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SetLogsTable, SetLog>(table),
                  $$SetLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false, exerciseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.sessionId,
                        referencedTable: $$SetLogsTableReferences
                            ._sessionIdTable(db),
                        referencedColumn: $$SetLogsTableReferences
                            ._sessionIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (exerciseId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.exerciseId,
                        referencedTable: $$SetLogsTableReferences
                            ._exerciseIdTable(db),
                        referencedColumn: $$SetLogsTableReferences
                            ._exerciseIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SetLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SetLogsTable,
      SetLog,
      $$SetLogsTableFilterComposer,
      $$SetLogsTableOrderingComposer,
      $$SetLogsTableAnnotationComposer,
      $$SetLogsTableCreateCompanionBuilder,
      $$SetLogsTableUpdateCompanionBuilder,
      (SetLog, $$SetLogsTableReferences),
      SetLog,
      PrefetchHooks Function({bool sessionId, bool exerciseId})
    >;
typedef $$SessionExerciseNotesTableCreateCompanionBuilder =
    SessionExerciseNotesCompanion Function({
      Value<int> id,
      required int sessionId,
      required String exerciseId,
      required String note,
    });
typedef $$SessionExerciseNotesTableUpdateCompanionBuilder =
    SessionExerciseNotesCompanion Function({
      Value<int> id,
      Value<int> sessionId,
      Value<String> exerciseId,
      Value<String> note,
    });

final class $$SessionExerciseNotesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SessionExerciseNotesTable,
          SessionExerciseNote
        > {
  $$SessionExerciseNotesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorkoutSessionsTable _sessionIdTable(_$AppDatabase db) => db
      .workoutSessions
      .createAlias('session_exercise_notes__session_id__workout_sessions__id');

  $$WorkoutSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager = $$WorkoutSessionsTableTableManager(
      $_db,
      $_db.workoutSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SessionExerciseNotesTableFilterComposer
    extends Composer<_$AppDatabase, $SessionExerciseNotesTable> {
  $$SessionExerciseNotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutSessionsTableFilterComposer get sessionId {
    final $$WorkoutSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionExerciseNotesTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionExerciseNotesTable> {
  $$SessionExerciseNotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutSessionsTableOrderingComposer get sessionId {
    final $$WorkoutSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionExerciseNotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionExerciseNotesTable> {
  $$SessionExerciseNotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$WorkoutSessionsTableAnnotationComposer get sessionId {
    final $$WorkoutSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionExerciseNotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionExerciseNotesTable,
          SessionExerciseNote,
          $$SessionExerciseNotesTableFilterComposer,
          $$SessionExerciseNotesTableOrderingComposer,
          $$SessionExerciseNotesTableAnnotationComposer,
          $$SessionExerciseNotesTableCreateCompanionBuilder,
          $$SessionExerciseNotesTableUpdateCompanionBuilder,
          (SessionExerciseNote, $$SessionExerciseNotesTableReferences),
          SessionExerciseNote,
          PrefetchHooks Function({bool sessionId})
        > {
  $$SessionExerciseNotesTableTableManager(
    _$AppDatabase db,
    $SessionExerciseNotesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionExerciseNotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionExerciseNotesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SessionExerciseNotesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sessionId = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<String> note = const Value.absent(),
              }) => SessionExerciseNotesCompanion(
                id: id,
                sessionId: sessionId,
                exerciseId: exerciseId,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sessionId,
                required String exerciseId,
                required String note,
              }) => SessionExerciseNotesCompanion.insert(
                id: id,
                sessionId: sessionId,
                exerciseId: exerciseId,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SessionExerciseNotesTable, SessionExerciseNote>(
                    table,
                  ),
                  $$SessionExerciseNotesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.sessionId,
                        referencedTable: $$SessionExerciseNotesTableReferences
                            ._sessionIdTable(db),
                        referencedColumn: $$SessionExerciseNotesTableReferences
                            ._sessionIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SessionExerciseNotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionExerciseNotesTable,
      SessionExerciseNote,
      $$SessionExerciseNotesTableFilterComposer,
      $$SessionExerciseNotesTableOrderingComposer,
      $$SessionExerciseNotesTableAnnotationComposer,
      $$SessionExerciseNotesTableCreateCompanionBuilder,
      $$SessionExerciseNotesTableUpdateCompanionBuilder,
      (SessionExerciseNote, $$SessionExerciseNotesTableReferences),
      SessionExerciseNote,
      PrefetchHooks Function({bool sessionId})
    >;
typedef $$CardioLogsTableCreateCompanionBuilder = CardioLogsCompanion Function({
  Value<int> id,
  Value<int?> sessionId,
  required DateTime date,
  required String type,
  required double durationMin,
  Value<double?> speedKmh,
  Value<double?> inclinePct,
  Value<int?> level,
  Value<double?> calories,
  Value<String?> notes,
});
typedef $$CardioLogsTableUpdateCompanionBuilder = CardioLogsCompanion Function({
  Value<int> id,
  Value<int?> sessionId,
  Value<DateTime> date,
  Value<String> type,
  Value<double> durationMin,
  Value<double?> speedKmh,
  Value<double?> inclinePct,
  Value<int?> level,
  Value<double?> calories,
  Value<String?> notes,
});

final class $$CardioLogsTableReferences
    extends BaseReferences<_$AppDatabase, $CardioLogsTable, CardioLog> {
  $$CardioLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutSessionsTable _sessionIdTable(_$AppDatabase db) => db
      .workoutSessions
      .createAlias('cardio_logs__session_id__workout_sessions__id');

  $$WorkoutSessionsTableProcessedTableManager? get sessionId {
    final $_column = $_itemColumn<int>('session_id');
    if ($_column == null) return null;
    final manager = $$WorkoutSessionsTableTableManager(
      $_db,
      $_db.workoutSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CardioLogsTableFilterComposer
    extends Composer<_$AppDatabase, $CardioLogsTable> {
  $$CardioLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get durationMin => $composableBuilder(
    column: $table.durationMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get speedKmh => $composableBuilder(
    column: $table.speedKmh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get inclinePct => $composableBuilder(
    column: $table.inclinePct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutSessionsTableFilterComposer get sessionId {
    final $$WorkoutSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CardioLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $CardioLogsTable> {
  $$CardioLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get durationMin => $composableBuilder(
    column: $table.durationMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get speedKmh => $composableBuilder(
    column: $table.speedKmh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get inclinePct => $composableBuilder(
    column: $table.inclinePct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutSessionsTableOrderingComposer get sessionId {
    final $$WorkoutSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CardioLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardioLogsTable> {
  $$CardioLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get durationMin => $composableBuilder(
    column: $table.durationMin,
    builder: (column) => column,
  );

  GeneratedColumn<double> get speedKmh =>
      $composableBuilder(column: $table.speedKmh, builder: (column) => column);

  GeneratedColumn<double> get inclinePct => $composableBuilder(
    column: $table.inclinePct,
    builder: (column) => column,
  );

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<double> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$WorkoutSessionsTableAnnotationComposer get sessionId {
    final $$WorkoutSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CardioLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CardioLogsTable,
          CardioLog,
          $$CardioLogsTableFilterComposer,
          $$CardioLogsTableOrderingComposer,
          $$CardioLogsTableAnnotationComposer,
          $$CardioLogsTableCreateCompanionBuilder,
          $$CardioLogsTableUpdateCompanionBuilder,
          (CardioLog, $$CardioLogsTableReferences),
          CardioLog,
          PrefetchHooks Function({bool sessionId})
        > {
  $$CardioLogsTableTableManager(_$AppDatabase db, $CardioLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardioLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardioLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardioLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> sessionId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<double> durationMin = const Value.absent(),
                Value<double?> speedKmh = const Value.absent(),
                Value<double?> inclinePct = const Value.absent(),
                Value<int?> level = const Value.absent(),
                Value<double?> calories = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => CardioLogsCompanion(
                id: id,
                sessionId: sessionId,
                date: date,
                type: type,
                durationMin: durationMin,
                speedKmh: speedKmh,
                inclinePct: inclinePct,
                level: level,
                calories: calories,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> sessionId = const Value.absent(),
                required DateTime date,
                required String type,
                required double durationMin,
                Value<double?> speedKmh = const Value.absent(),
                Value<double?> inclinePct = const Value.absent(),
                Value<int?> level = const Value.absent(),
                Value<double?> calories = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => CardioLogsCompanion.insert(
                id: id,
                sessionId: sessionId,
                date: date,
                type: type,
                durationMin: durationMin,
                speedKmh: speedKmh,
                inclinePct: inclinePct,
                level: level,
                calories: calories,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CardioLogsTable, CardioLog>(table),
                  $$CardioLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.sessionId,
                        referencedTable: $$CardioLogsTableReferences
                            ._sessionIdTable(db),
                        referencedColumn: $$CardioLogsTableReferences
                            ._sessionIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CardioLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CardioLogsTable,
      CardioLog,
      $$CardioLogsTableFilterComposer,
      $$CardioLogsTableOrderingComposer,
      $$CardioLogsTableAnnotationComposer,
      $$CardioLogsTableCreateCompanionBuilder,
      $$CardioLogsTableUpdateCompanionBuilder,
      (CardioLog, $$CardioLogsTableReferences),
      CardioLog,
      PrefetchHooks Function({bool sessionId})
    >;
typedef $$MealPlansTableCreateCompanionBuilder = MealPlansCompanion Function({
  Value<int> id,
  required String name,
  Value<bool> isActive,
  Value<String?> notes,
  Value<String?> rawJson,
  Value<DateTime> createdAt,
});
typedef $$MealPlansTableUpdateCompanionBuilder = MealPlansCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<bool> isActive,
  Value<String?> notes,
  Value<String?> rawJson,
  Value<DateTime> createdAt,
});

final class $$MealPlansTableReferences
    extends BaseReferences<_$AppDatabase, $MealPlansTable, MealPlan> {
  $$MealPlansTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PlannedMealsTable, List<PlannedMeal>>
  _plannedMealsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.plannedMeals,
    aliasName: 'meal_plans__id__planned_meals__meal_plan_id',
  );

  $$PlannedMealsTableProcessedTableManager get plannedMealsRefs {
    final manager = $$PlannedMealsTableTableManager(
      $_db,
      $_db.plannedMeals,
    ).filter((f) => f.mealPlanId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_plannedMealsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MealPlansTableFilterComposer
    extends Composer<_$AppDatabase, $MealPlansTable> {
  $$MealPlansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawJson => $composableBuilder(
    column: $table.rawJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> plannedMealsRefs(
    Expression<bool> Function($$PlannedMealsTableFilterComposer f) f,
  ) {
    final $$PlannedMealsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.plannedMeals,
      getReferencedColumn: (t) => t.mealPlanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlannedMealsTableFilterComposer(
            $db: $db,
            $table: $db.plannedMeals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MealPlansTableOrderingComposer
    extends Composer<_$AppDatabase, $MealPlansTable> {
  $$MealPlansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawJson => $composableBuilder(
    column: $table.rawJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MealPlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealPlansTable> {
  $$MealPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get rawJson =>
      $composableBuilder(column: $table.rawJson, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> plannedMealsRefs<T extends Object>(
    Expression<T> Function($$PlannedMealsTableAnnotationComposer a) f,
  ) {
    final $$PlannedMealsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.plannedMeals,
      getReferencedColumn: (t) => t.mealPlanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlannedMealsTableAnnotationComposer(
            $db: $db,
            $table: $db.plannedMeals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MealPlansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealPlansTable,
          MealPlan,
          $$MealPlansTableFilterComposer,
          $$MealPlansTableOrderingComposer,
          $$MealPlansTableAnnotationComposer,
          $$MealPlansTableCreateCompanionBuilder,
          $$MealPlansTableUpdateCompanionBuilder,
          (MealPlan, $$MealPlansTableReferences),
          MealPlan,
          PrefetchHooks Function({bool plannedMealsRefs})
        > {
  $$MealPlansTableTableManager(_$AppDatabase db, $MealPlansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> rawJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MealPlansCompanion(
                id: id,
                name: name,
                isActive: isActive,
                notes: notes,
                rawJson: rawJson,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<bool> isActive = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> rawJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MealPlansCompanion.insert(
                id: id,
                name: name,
                isActive: isActive,
                notes: notes,
                rawJson: rawJson,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MealPlansTable, MealPlan>(table),
                  $$MealPlansTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({plannedMealsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (plannedMealsRefs) db.plannedMeals],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (plannedMealsRefs)
                    await $_getPrefetchedData<
                      MealPlan,
                      $MealPlansTable,
                      PlannedMeal
                    >(
                      currentTable: table,
                      referencedTable: $$MealPlansTableReferences
                          ._plannedMealsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$MealPlansTableReferences(
                            db,
                            table,
                            p0,
                          ).plannedMealsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.mealPlanId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$MealPlansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealPlansTable,
      MealPlan,
      $$MealPlansTableFilterComposer,
      $$MealPlansTableOrderingComposer,
      $$MealPlansTableAnnotationComposer,
      $$MealPlansTableCreateCompanionBuilder,
      $$MealPlansTableUpdateCompanionBuilder,
      (MealPlan, $$MealPlansTableReferences),
      MealPlan,
      PrefetchHooks Function({bool plannedMealsRefs})
    >;
typedef $$PlannedMealsTableCreateCompanionBuilder =
    PlannedMealsCompanion Function({
      Value<int> id,
      required int mealPlanId,
      Value<String> dayType,
      required int mealIndex,
      required String name,
      Value<String?> time,
      Value<String> itemsJson,
      Value<double> calories,
      Value<double> protein,
      Value<double> carbs,
      Value<double> fat,
    });
typedef $$PlannedMealsTableUpdateCompanionBuilder =
    PlannedMealsCompanion Function({
      Value<int> id,
      Value<int> mealPlanId,
      Value<String> dayType,
      Value<int> mealIndex,
      Value<String> name,
      Value<String?> time,
      Value<String> itemsJson,
      Value<double> calories,
      Value<double> protein,
      Value<double> carbs,
      Value<double> fat,
    });

final class $$PlannedMealsTableReferences
    extends BaseReferences<_$AppDatabase, $PlannedMealsTable, PlannedMeal> {
  $$PlannedMealsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MealPlansTable _mealPlanIdTable(_$AppDatabase db) =>
      db.mealPlans.createAlias('planned_meals__meal_plan_id__meal_plans__id');

  $$MealPlansTableProcessedTableManager get mealPlanId {
    final $_column = $_itemColumn<int>('meal_plan_id')!;

    final manager = $$MealPlansTableTableManager(
      $_db,
      $_db.mealPlans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mealPlanIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PlannedMealsTableFilterComposer
    extends Composer<_$AppDatabase, $PlannedMealsTable> {
  $$PlannedMealsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dayType => $composableBuilder(
    column: $table.dayType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mealIndex => $composableBuilder(
    column: $table.mealIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemsJson => $composableBuilder(
    column: $table.itemsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get protein => $composableBuilder(
    column: $table.protein,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbs => $composableBuilder(
    column: $table.carbs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fat => $composableBuilder(
    column: $table.fat,
    builder: (column) => ColumnFilters(column),
  );

  $$MealPlansTableFilterComposer get mealPlanId {
    final $$MealPlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealPlanId,
      referencedTable: $db.mealPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealPlansTableFilterComposer(
            $db: $db,
            $table: $db.mealPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlannedMealsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlannedMealsTable> {
  $$PlannedMealsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dayType => $composableBuilder(
    column: $table.dayType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mealIndex => $composableBuilder(
    column: $table.mealIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemsJson => $composableBuilder(
    column: $table.itemsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get protein => $composableBuilder(
    column: $table.protein,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbs => $composableBuilder(
    column: $table.carbs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fat => $composableBuilder(
    column: $table.fat,
    builder: (column) => ColumnOrderings(column),
  );

  $$MealPlansTableOrderingComposer get mealPlanId {
    final $$MealPlansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealPlanId,
      referencedTable: $db.mealPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealPlansTableOrderingComposer(
            $db: $db,
            $table: $db.mealPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlannedMealsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlannedMealsTable> {
  $$PlannedMealsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dayType =>
      $composableBuilder(column: $table.dayType, builder: (column) => column);

  GeneratedColumn<int> get mealIndex =>
      $composableBuilder(column: $table.mealIndex, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<String> get itemsJson =>
      $composableBuilder(column: $table.itemsJson, builder: (column) => column);

  GeneratedColumn<double> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<double> get protein =>
      $composableBuilder(column: $table.protein, builder: (column) => column);

  GeneratedColumn<double> get carbs =>
      $composableBuilder(column: $table.carbs, builder: (column) => column);

  GeneratedColumn<double> get fat =>
      $composableBuilder(column: $table.fat, builder: (column) => column);

  $$MealPlansTableAnnotationComposer get mealPlanId {
    final $$MealPlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealPlanId,
      referencedTable: $db.mealPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealPlansTableAnnotationComposer(
            $db: $db,
            $table: $db.mealPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlannedMealsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlannedMealsTable,
          PlannedMeal,
          $$PlannedMealsTableFilterComposer,
          $$PlannedMealsTableOrderingComposer,
          $$PlannedMealsTableAnnotationComposer,
          $$PlannedMealsTableCreateCompanionBuilder,
          $$PlannedMealsTableUpdateCompanionBuilder,
          (PlannedMeal, $$PlannedMealsTableReferences),
          PlannedMeal,
          PrefetchHooks Function({bool mealPlanId})
        > {
  $$PlannedMealsTableTableManager(_$AppDatabase db, $PlannedMealsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlannedMealsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlannedMealsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlannedMealsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> mealPlanId = const Value.absent(),
                Value<String> dayType = const Value.absent(),
                Value<int> mealIndex = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> time = const Value.absent(),
                Value<String> itemsJson = const Value.absent(),
                Value<double> calories = const Value.absent(),
                Value<double> protein = const Value.absent(),
                Value<double> carbs = const Value.absent(),
                Value<double> fat = const Value.absent(),
              }) => PlannedMealsCompanion(
                id: id,
                mealPlanId: mealPlanId,
                dayType: dayType,
                mealIndex: mealIndex,
                name: name,
                time: time,
                itemsJson: itemsJson,
                calories: calories,
                protein: protein,
                carbs: carbs,
                fat: fat,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int mealPlanId,
                Value<String> dayType = const Value.absent(),
                required int mealIndex,
                required String name,
                Value<String?> time = const Value.absent(),
                Value<String> itemsJson = const Value.absent(),
                Value<double> calories = const Value.absent(),
                Value<double> protein = const Value.absent(),
                Value<double> carbs = const Value.absent(),
                Value<double> fat = const Value.absent(),
              }) => PlannedMealsCompanion.insert(
                id: id,
                mealPlanId: mealPlanId,
                dayType: dayType,
                mealIndex: mealIndex,
                name: name,
                time: time,
                itemsJson: itemsJson,
                calories: calories,
                protein: protein,
                carbs: carbs,
                fat: fat,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlannedMealsTable, PlannedMeal>(table),
                  $$PlannedMealsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({mealPlanId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (mealPlanId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.mealPlanId,
                        referencedTable: $$PlannedMealsTableReferences
                            ._mealPlanIdTable(db),
                        referencedColumn: $$PlannedMealsTableReferences
                            ._mealPlanIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PlannedMealsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlannedMealsTable,
      PlannedMeal,
      $$PlannedMealsTableFilterComposer,
      $$PlannedMealsTableOrderingComposer,
      $$PlannedMealsTableAnnotationComposer,
      $$PlannedMealsTableCreateCompanionBuilder,
      $$PlannedMealsTableUpdateCompanionBuilder,
      (PlannedMeal, $$PlannedMealsTableReferences),
      PlannedMeal,
      PrefetchHooks Function({bool mealPlanId})
    >;
typedef $$MealLogsTableCreateCompanionBuilder = MealLogsCompanion Function({
  Value<int> id,
  required DateTime date,
  Value<DateTime> loggedAt,
  Value<int?> mealIndex,
  Value<int?> plannedMealId,
  required String name,
  Value<String> itemsJson,
  Value<double> calories,
  Value<double> protein,
  Value<double> carbs,
  Value<double> fat,
  Value<String?> photoPath,
  Value<String> source,
  Value<double?> confidence,
  Value<String> status,
});
typedef $$MealLogsTableUpdateCompanionBuilder = MealLogsCompanion Function({
  Value<int> id,
  Value<DateTime> date,
  Value<DateTime> loggedAt,
  Value<int?> mealIndex,
  Value<int?> plannedMealId,
  Value<String> name,
  Value<String> itemsJson,
  Value<double> calories,
  Value<double> protein,
  Value<double> carbs,
  Value<double> fat,
  Value<String?> photoPath,
  Value<String> source,
  Value<double?> confidence,
  Value<String> status,
});

class $$MealLogsTableFilterComposer
    extends Composer<_$AppDatabase, $MealLogsTable> {
  $$MealLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mealIndex => $composableBuilder(
    column: $table.mealIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plannedMealId => $composableBuilder(
    column: $table.plannedMealId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemsJson => $composableBuilder(
    column: $table.itemsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get protein => $composableBuilder(
    column: $table.protein,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbs => $composableBuilder(
    column: $table.carbs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fat => $composableBuilder(
    column: $table.fat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MealLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $MealLogsTable> {
  $$MealLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mealIndex => $composableBuilder(
    column: $table.mealIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedMealId => $composableBuilder(
    column: $table.plannedMealId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemsJson => $composableBuilder(
    column: $table.itemsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get protein => $composableBuilder(
    column: $table.protein,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbs => $composableBuilder(
    column: $table.carbs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fat => $composableBuilder(
    column: $table.fat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MealLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealLogsTable> {
  $$MealLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get loggedAt =>
      $composableBuilder(column: $table.loggedAt, builder: (column) => column);

  GeneratedColumn<int> get mealIndex =>
      $composableBuilder(column: $table.mealIndex, builder: (column) => column);

  GeneratedColumn<int> get plannedMealId => $composableBuilder(
    column: $table.plannedMealId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get itemsJson =>
      $composableBuilder(column: $table.itemsJson, builder: (column) => column);

  GeneratedColumn<double> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<double> get protein =>
      $composableBuilder(column: $table.protein, builder: (column) => column);

  GeneratedColumn<double> get carbs =>
      $composableBuilder(column: $table.carbs, builder: (column) => column);

  GeneratedColumn<double> get fat =>
      $composableBuilder(column: $table.fat, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$MealLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealLogsTable,
          MealLog,
          $$MealLogsTableFilterComposer,
          $$MealLogsTableOrderingComposer,
          $$MealLogsTableAnnotationComposer,
          $$MealLogsTableCreateCompanionBuilder,
          $$MealLogsTableUpdateCompanionBuilder,
          (MealLog, BaseReferences<_$AppDatabase, $MealLogsTable, MealLog>),
          MealLog,
          PrefetchHooks Function()
        > {
  $$MealLogsTableTableManager(_$AppDatabase db, $MealLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<DateTime> loggedAt = const Value.absent(),
                Value<int?> mealIndex = const Value.absent(),
                Value<int?> plannedMealId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> itemsJson = const Value.absent(),
                Value<double> calories = const Value.absent(),
                Value<double> protein = const Value.absent(),
                Value<double> carbs = const Value.absent(),
                Value<double> fat = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<double?> confidence = const Value.absent(),
                Value<String> status = const Value.absent(),
              }) => MealLogsCompanion(
                id: id,
                date: date,
                loggedAt: loggedAt,
                mealIndex: mealIndex,
                plannedMealId: plannedMealId,
                name: name,
                itemsJson: itemsJson,
                calories: calories,
                protein: protein,
                carbs: carbs,
                fat: fat,
                photoPath: photoPath,
                source: source,
                confidence: confidence,
                status: status,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                Value<DateTime> loggedAt = const Value.absent(),
                Value<int?> mealIndex = const Value.absent(),
                Value<int?> plannedMealId = const Value.absent(),
                required String name,
                Value<String> itemsJson = const Value.absent(),
                Value<double> calories = const Value.absent(),
                Value<double> protein = const Value.absent(),
                Value<double> carbs = const Value.absent(),
                Value<double> fat = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<double?> confidence = const Value.absent(),
                Value<String> status = const Value.absent(),
              }) => MealLogsCompanion.insert(
                id: id,
                date: date,
                loggedAt: loggedAt,
                mealIndex: mealIndex,
                plannedMealId: plannedMealId,
                name: name,
                itemsJson: itemsJson,
                calories: calories,
                protein: protein,
                carbs: carbs,
                fat: fat,
                photoPath: photoPath,
                source: source,
                confidence: confidence,
                status: status,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MealLogsTable, MealLog>(table),
                  BaseReferences<_$AppDatabase, $MealLogsTable, MealLog>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MealLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealLogsTable,
      MealLog,
      $$MealLogsTableFilterComposer,
      $$MealLogsTableOrderingComposer,
      $$MealLogsTableAnnotationComposer,
      $$MealLogsTableCreateCompanionBuilder,
      $$MealLogsTableUpdateCompanionBuilder,
      (MealLog, BaseReferences<_$AppDatabase, $MealLogsTable, MealLog>),
      MealLog,
      PrefetchHooks Function()
    >;
typedef $$FoodItemsTableCreateCompanionBuilder = FoodItemsCompanion Function({
  Value<int> id,
  required String name,
  Value<String> itemsJson,
  required double calories,
  required double protein,
  required double carbs,
  required double fat,
  Value<int> useCount,
  Value<DateTime?> lastUsed,
  Value<bool> isFavorite,
});
typedef $$FoodItemsTableUpdateCompanionBuilder = FoodItemsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> itemsJson,
  Value<double> calories,
  Value<double> protein,
  Value<double> carbs,
  Value<double> fat,
  Value<int> useCount,
  Value<DateTime?> lastUsed,
  Value<bool> isFavorite,
});

class $$FoodItemsTableFilterComposer
    extends Composer<_$AppDatabase, $FoodItemsTable> {
  $$FoodItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemsJson => $composableBuilder(
    column: $table.itemsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get protein => $composableBuilder(
    column: $table.protein,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbs => $composableBuilder(
    column: $table.carbs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fat => $composableBuilder(
    column: $table.fat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get useCount => $composableBuilder(
    column: $table.useCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUsed => $composableBuilder(
    column: $table.lastUsed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FoodItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $FoodItemsTable> {
  $$FoodItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemsJson => $composableBuilder(
    column: $table.itemsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get protein => $composableBuilder(
    column: $table.protein,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbs => $composableBuilder(
    column: $table.carbs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fat => $composableBuilder(
    column: $table.fat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get useCount => $composableBuilder(
    column: $table.useCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUsed => $composableBuilder(
    column: $table.lastUsed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FoodItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoodItemsTable> {
  $$FoodItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get itemsJson =>
      $composableBuilder(column: $table.itemsJson, builder: (column) => column);

  GeneratedColumn<double> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<double> get protein =>
      $composableBuilder(column: $table.protein, builder: (column) => column);

  GeneratedColumn<double> get carbs =>
      $composableBuilder(column: $table.carbs, builder: (column) => column);

  GeneratedColumn<double> get fat =>
      $composableBuilder(column: $table.fat, builder: (column) => column);

  GeneratedColumn<int> get useCount =>
      $composableBuilder(column: $table.useCount, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUsed =>
      $composableBuilder(column: $table.lastUsed, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );
}

class $$FoodItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FoodItemsTable,
          FoodItem,
          $$FoodItemsTableFilterComposer,
          $$FoodItemsTableOrderingComposer,
          $$FoodItemsTableAnnotationComposer,
          $$FoodItemsTableCreateCompanionBuilder,
          $$FoodItemsTableUpdateCompanionBuilder,
          (FoodItem, BaseReferences<_$AppDatabase, $FoodItemsTable, FoodItem>),
          FoodItem,
          PrefetchHooks Function()
        > {
  $$FoodItemsTableTableManager(_$AppDatabase db, $FoodItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoodItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoodItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoodItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> itemsJson = const Value.absent(),
                Value<double> calories = const Value.absent(),
                Value<double> protein = const Value.absent(),
                Value<double> carbs = const Value.absent(),
                Value<double> fat = const Value.absent(),
                Value<int> useCount = const Value.absent(),
                Value<DateTime?> lastUsed = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
              }) => FoodItemsCompanion(
                id: id,
                name: name,
                itemsJson: itemsJson,
                calories: calories,
                protein: protein,
                carbs: carbs,
                fat: fat,
                useCount: useCount,
                lastUsed: lastUsed,
                isFavorite: isFavorite,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String> itemsJson = const Value.absent(),
                required double calories,
                required double protein,
                required double carbs,
                required double fat,
                Value<int> useCount = const Value.absent(),
                Value<DateTime?> lastUsed = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
              }) => FoodItemsCompanion.insert(
                id: id,
                name: name,
                itemsJson: itemsJson,
                calories: calories,
                protein: protein,
                carbs: carbs,
                fat: fat,
                useCount: useCount,
                lastUsed: lastUsed,
                isFavorite: isFavorite,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FoodItemsTable, FoodItem>(table),
                  BaseReferences<_$AppDatabase, $FoodItemsTable, FoodItem>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FoodItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FoodItemsTable,
      FoodItem,
      $$FoodItemsTableFilterComposer,
      $$FoodItemsTableOrderingComposer,
      $$FoodItemsTableAnnotationComposer,
      $$FoodItemsTableCreateCompanionBuilder,
      $$FoodItemsTableUpdateCompanionBuilder,
      (FoodItem, BaseReferences<_$AppDatabase, $FoodItemsTable, FoodItem>),
      FoodItem,
      PrefetchHooks Function()
    >;
typedef $$BodyMetricsTableCreateCompanionBuilder =
    BodyMetricsCompanion Function({
      Value<int> id,
      required DateTime date,
      Value<double?> weightKg,
      Value<double?> waistCm,
      Value<double?> chestCm,
      Value<double?> armCm,
      Value<double?> thighCm,
      Value<double?> neckCm,
      Value<double?> hipsCm,
      Value<double?> bodyFatPct,
    });
typedef $$BodyMetricsTableUpdateCompanionBuilder =
    BodyMetricsCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<double?> weightKg,
      Value<double?> waistCm,
      Value<double?> chestCm,
      Value<double?> armCm,
      Value<double?> thighCm,
      Value<double?> neckCm,
      Value<double?> hipsCm,
      Value<double?> bodyFatPct,
    });

class $$BodyMetricsTableFilterComposer
    extends Composer<_$AppDatabase, $BodyMetricsTable> {
  $$BodyMetricsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get waistCm => $composableBuilder(
    column: $table.waistCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get chestCm => $composableBuilder(
    column: $table.chestCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get armCm => $composableBuilder(
    column: $table.armCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get thighCm => $composableBuilder(
    column: $table.thighCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get neckCm => $composableBuilder(
    column: $table.neckCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hipsCm => $composableBuilder(
    column: $table.hipsCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bodyFatPct => $composableBuilder(
    column: $table.bodyFatPct,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BodyMetricsTableOrderingComposer
    extends Composer<_$AppDatabase, $BodyMetricsTable> {
  $$BodyMetricsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get waistCm => $composableBuilder(
    column: $table.waistCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get chestCm => $composableBuilder(
    column: $table.chestCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get armCm => $composableBuilder(
    column: $table.armCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get thighCm => $composableBuilder(
    column: $table.thighCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get neckCm => $composableBuilder(
    column: $table.neckCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hipsCm => $composableBuilder(
    column: $table.hipsCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bodyFatPct => $composableBuilder(
    column: $table.bodyFatPct,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BodyMetricsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BodyMetricsTable> {
  $$BodyMetricsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<double> get waistCm =>
      $composableBuilder(column: $table.waistCm, builder: (column) => column);

  GeneratedColumn<double> get chestCm =>
      $composableBuilder(column: $table.chestCm, builder: (column) => column);

  GeneratedColumn<double> get armCm =>
      $composableBuilder(column: $table.armCm, builder: (column) => column);

  GeneratedColumn<double> get thighCm =>
      $composableBuilder(column: $table.thighCm, builder: (column) => column);

  GeneratedColumn<double> get neckCm =>
      $composableBuilder(column: $table.neckCm, builder: (column) => column);

  GeneratedColumn<double> get hipsCm =>
      $composableBuilder(column: $table.hipsCm, builder: (column) => column);

  GeneratedColumn<double> get bodyFatPct => $composableBuilder(
    column: $table.bodyFatPct,
    builder: (column) => column,
  );
}

class $$BodyMetricsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BodyMetricsTable,
          BodyMetric,
          $$BodyMetricsTableFilterComposer,
          $$BodyMetricsTableOrderingComposer,
          $$BodyMetricsTableAnnotationComposer,
          $$BodyMetricsTableCreateCompanionBuilder,
          $$BodyMetricsTableUpdateCompanionBuilder,
          (
            BodyMetric,
            BaseReferences<_$AppDatabase, $BodyMetricsTable, BodyMetric>,
          ),
          BodyMetric,
          PrefetchHooks Function()
        > {
  $$BodyMetricsTableTableManager(_$AppDatabase db, $BodyMetricsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BodyMetricsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BodyMetricsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BodyMetricsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<double?> waistCm = const Value.absent(),
                Value<double?> chestCm = const Value.absent(),
                Value<double?> armCm = const Value.absent(),
                Value<double?> thighCm = const Value.absent(),
                Value<double?> neckCm = const Value.absent(),
                Value<double?> hipsCm = const Value.absent(),
                Value<double?> bodyFatPct = const Value.absent(),
              }) => BodyMetricsCompanion(
                id: id,
                date: date,
                weightKg: weightKg,
                waistCm: waistCm,
                chestCm: chestCm,
                armCm: armCm,
                thighCm: thighCm,
                neckCm: neckCm,
                hipsCm: hipsCm,
                bodyFatPct: bodyFatPct,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                Value<double?> weightKg = const Value.absent(),
                Value<double?> waistCm = const Value.absent(),
                Value<double?> chestCm = const Value.absent(),
                Value<double?> armCm = const Value.absent(),
                Value<double?> thighCm = const Value.absent(),
                Value<double?> neckCm = const Value.absent(),
                Value<double?> hipsCm = const Value.absent(),
                Value<double?> bodyFatPct = const Value.absent(),
              }) => BodyMetricsCompanion.insert(
                id: id,
                date: date,
                weightKg: weightKg,
                waistCm: waistCm,
                chestCm: chestCm,
                armCm: armCm,
                thighCm: thighCm,
                neckCm: neckCm,
                hipsCm: hipsCm,
                bodyFatPct: bodyFatPct,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BodyMetricsTable, BodyMetric>(table),
                  BaseReferences<_$AppDatabase, $BodyMetricsTable, BodyMetric>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BodyMetricsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BodyMetricsTable,
      BodyMetric,
      $$BodyMetricsTableFilterComposer,
      $$BodyMetricsTableOrderingComposer,
      $$BodyMetricsTableAnnotationComposer,
      $$BodyMetricsTableCreateCompanionBuilder,
      $$BodyMetricsTableUpdateCompanionBuilder,
      (
        BodyMetric,
        BaseReferences<_$AppDatabase, $BodyMetricsTable, BodyMetric>,
      ),
      BodyMetric,
      PrefetchHooks Function()
    >;
typedef $$ProgressPhotosTableCreateCompanionBuilder =
    ProgressPhotosCompanion Function({
      Value<int> id,
      required DateTime date,
      required String angle,
      required String path,
    });
typedef $$ProgressPhotosTableUpdateCompanionBuilder =
    ProgressPhotosCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<String> angle,
      Value<String> path,
    });

class $$ProgressPhotosTableFilterComposer
    extends Composer<_$AppDatabase, $ProgressPhotosTable> {
  $$ProgressPhotosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get angle => $composableBuilder(
    column: $table.angle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProgressPhotosTableOrderingComposer
    extends Composer<_$AppDatabase, $ProgressPhotosTable> {
  $$ProgressPhotosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get angle => $composableBuilder(
    column: $table.angle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProgressPhotosTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProgressPhotosTable> {
  $$ProgressPhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get angle =>
      $composableBuilder(column: $table.angle, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);
}

class $$ProgressPhotosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProgressPhotosTable,
          ProgressPhoto,
          $$ProgressPhotosTableFilterComposer,
          $$ProgressPhotosTableOrderingComposer,
          $$ProgressPhotosTableAnnotationComposer,
          $$ProgressPhotosTableCreateCompanionBuilder,
          $$ProgressPhotosTableUpdateCompanionBuilder,
          (
            ProgressPhoto,
            BaseReferences<_$AppDatabase, $ProgressPhotosTable, ProgressPhoto>,
          ),
          ProgressPhoto,
          PrefetchHooks Function()
        > {
  $$ProgressPhotosTableTableManager(
    _$AppDatabase db,
    $ProgressPhotosTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProgressPhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProgressPhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProgressPhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> angle = const Value.absent(),
                Value<String> path = const Value.absent(),
              }) => ProgressPhotosCompanion(
                id: id,
                date: date,
                angle: angle,
                path: path,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required String angle,
                required String path,
              }) => ProgressPhotosCompanion.insert(
                id: id,
                date: date,
                angle: angle,
                path: path,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProgressPhotosTable, ProgressPhoto>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ProgressPhotosTable,
                    ProgressPhoto
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProgressPhotosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProgressPhotosTable,
      ProgressPhoto,
      $$ProgressPhotosTableFilterComposer,
      $$ProgressPhotosTableOrderingComposer,
      $$ProgressPhotosTableAnnotationComposer,
      $$ProgressPhotosTableCreateCompanionBuilder,
      $$ProgressPhotosTableUpdateCompanionBuilder,
      (
        ProgressPhoto,
        BaseReferences<_$AppDatabase, $ProgressPhotosTable, ProgressPhoto>,
      ),
      ProgressPhoto,
      PrefetchHooks Function()
    >;
typedef $$WaterLogsTableCreateCompanionBuilder = WaterLogsCompanion Function({
  Value<int> id,
  required DateTime timestamp,
  required int amountMl,
  Value<String> source,
});
typedef $$WaterLogsTableUpdateCompanionBuilder = WaterLogsCompanion Function({
  Value<int> id,
  Value<DateTime> timestamp,
  Value<int> amountMl,
  Value<String> source,
});

class $$WaterLogsTableFilterComposer
    extends Composer<_$AppDatabase, $WaterLogsTable> {
  $$WaterLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountMl => $composableBuilder(
    column: $table.amountMl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WaterLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $WaterLogsTable> {
  $$WaterLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMl => $composableBuilder(
    column: $table.amountMl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WaterLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WaterLogsTable> {
  $$WaterLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<int> get amountMl =>
      $composableBuilder(column: $table.amountMl, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);
}

class $$WaterLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WaterLogsTable,
          WaterLog,
          $$WaterLogsTableFilterComposer,
          $$WaterLogsTableOrderingComposer,
          $$WaterLogsTableAnnotationComposer,
          $$WaterLogsTableCreateCompanionBuilder,
          $$WaterLogsTableUpdateCompanionBuilder,
          (WaterLog, BaseReferences<_$AppDatabase, $WaterLogsTable, WaterLog>),
          WaterLog,
          PrefetchHooks Function()
        > {
  $$WaterLogsTableTableManager(_$AppDatabase db, $WaterLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WaterLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WaterLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WaterLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<int> amountMl = const Value.absent(),
                Value<String> source = const Value.absent(),
              }) => WaterLogsCompanion(
                id: id,
                timestamp: timestamp,
                amountMl: amountMl,
                source: source,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime timestamp,
                required int amountMl,
                Value<String> source = const Value.absent(),
              }) => WaterLogsCompanion.insert(
                id: id,
                timestamp: timestamp,
                amountMl: amountMl,
                source: source,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WaterLogsTable, WaterLog>(table),
                  BaseReferences<_$AppDatabase, $WaterLogsTable, WaterLog>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WaterLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WaterLogsTable,
      WaterLog,
      $$WaterLogsTableFilterComposer,
      $$WaterLogsTableOrderingComposer,
      $$WaterLogsTableAnnotationComposer,
      $$WaterLogsTableCreateCompanionBuilder,
      $$WaterLogsTableUpdateCompanionBuilder,
      (WaterLog, BaseReferences<_$AppDatabase, $WaterLogsTable, WaterLog>),
      WaterLog,
      PrefetchHooks Function()
    >;
typedef $$SupplementsTableCreateCompanionBuilder =
    SupplementsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> dose,
      Value<String?> timing,
      Value<double> proteinG,
      Value<double> calories,
      Value<double> carbsG,
      Value<double> fatG,
      Value<bool> active,
    });
typedef $$SupplementsTableUpdateCompanionBuilder =
    SupplementsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> dose,
      Value<String?> timing,
      Value<double> proteinG,
      Value<double> calories,
      Value<double> carbsG,
      Value<double> fatG,
      Value<bool> active,
    });

final class $$SupplementsTableReferences
    extends BaseReferences<_$AppDatabase, $SupplementsTable, Supplement> {
  $$SupplementsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SupplementLogsTable, List<SupplementLog>>
  _supplementLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.supplementLogs,
    aliasName: 'supplements__id__supplement_logs__supplement_id',
  );

  $$SupplementLogsTableProcessedTableManager get supplementLogsRefs {
    final manager = $$SupplementLogsTableTableManager(
      $_db,
      $_db.supplementLogs,
    ).filter((f) => f.supplementId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_supplementLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SupplementsTableFilterComposer
    extends Composer<_$AppDatabase, $SupplementsTable> {
  $$SupplementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dose => $composableBuilder(
    column: $table.dose,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timing => $composableBuilder(
    column: $table.timing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinG => $composableBuilder(
    column: $table.proteinG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbsG => $composableBuilder(
    column: $table.carbsG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatG => $composableBuilder(
    column: $table.fatG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> supplementLogsRefs(
    Expression<bool> Function($$SupplementLogsTableFilterComposer f) f,
  ) {
    final $$SupplementLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.supplementLogs,
      getReferencedColumn: (t) => t.supplementId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SupplementLogsTableFilterComposer(
            $db: $db,
            $table: $db.supplementLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SupplementsTableOrderingComposer
    extends Composer<_$AppDatabase, $SupplementsTable> {
  $$SupplementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dose => $composableBuilder(
    column: $table.dose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timing => $composableBuilder(
    column: $table.timing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinG => $composableBuilder(
    column: $table.proteinG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbsG => $composableBuilder(
    column: $table.carbsG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatG => $composableBuilder(
    column: $table.fatG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SupplementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SupplementsTable> {
  $$SupplementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get dose =>
      $composableBuilder(column: $table.dose, builder: (column) => column);

  GeneratedColumn<String> get timing =>
      $composableBuilder(column: $table.timing, builder: (column) => column);

  GeneratedColumn<double> get proteinG =>
      $composableBuilder(column: $table.proteinG, builder: (column) => column);

  GeneratedColumn<double> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<double> get carbsG =>
      $composableBuilder(column: $table.carbsG, builder: (column) => column);

  GeneratedColumn<double> get fatG =>
      $composableBuilder(column: $table.fatG, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  Expression<T> supplementLogsRefs<T extends Object>(
    Expression<T> Function($$SupplementLogsTableAnnotationComposer a) f,
  ) {
    final $$SupplementLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.supplementLogs,
      getReferencedColumn: (t) => t.supplementId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SupplementLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.supplementLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SupplementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SupplementsTable,
          Supplement,
          $$SupplementsTableFilterComposer,
          $$SupplementsTableOrderingComposer,
          $$SupplementsTableAnnotationComposer,
          $$SupplementsTableCreateCompanionBuilder,
          $$SupplementsTableUpdateCompanionBuilder,
          (Supplement, $$SupplementsTableReferences),
          Supplement,
          PrefetchHooks Function({bool supplementLogsRefs})
        > {
  $$SupplementsTableTableManager(_$AppDatabase db, $SupplementsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SupplementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SupplementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SupplementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> dose = const Value.absent(),
                Value<String?> timing = const Value.absent(),
                Value<double> proteinG = const Value.absent(),
                Value<double> calories = const Value.absent(),
                Value<double> carbsG = const Value.absent(),
                Value<double> fatG = const Value.absent(),
                Value<bool> active = const Value.absent(),
              }) => SupplementsCompanion(
                id: id,
                name: name,
                dose: dose,
                timing: timing,
                proteinG: proteinG,
                calories: calories,
                carbsG: carbsG,
                fatG: fatG,
                active: active,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> dose = const Value.absent(),
                Value<String?> timing = const Value.absent(),
                Value<double> proteinG = const Value.absent(),
                Value<double> calories = const Value.absent(),
                Value<double> carbsG = const Value.absent(),
                Value<double> fatG = const Value.absent(),
                Value<bool> active = const Value.absent(),
              }) => SupplementsCompanion.insert(
                id: id,
                name: name,
                dose: dose,
                timing: timing,
                proteinG: proteinG,
                calories: calories,
                carbsG: carbsG,
                fatG: fatG,
                active: active,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SupplementsTable, Supplement>(table),
                  $$SupplementsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({supplementLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (supplementLogsRefs) db.supplementLogs,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (supplementLogsRefs)
                    await $_getPrefetchedData<
                      Supplement,
                      $SupplementsTable,
                      SupplementLog
                    >(
                      currentTable: table,
                      referencedTable: $$SupplementsTableReferences
                          ._supplementLogsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SupplementsTableReferences(
                            db,
                            table,
                            p0,
                          ).supplementLogsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.supplementId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SupplementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SupplementsTable,
      Supplement,
      $$SupplementsTableFilterComposer,
      $$SupplementsTableOrderingComposer,
      $$SupplementsTableAnnotationComposer,
      $$SupplementsTableCreateCompanionBuilder,
      $$SupplementsTableUpdateCompanionBuilder,
      (Supplement, $$SupplementsTableReferences),
      Supplement,
      PrefetchHooks Function({bool supplementLogsRefs})
    >;
typedef $$SupplementLogsTableCreateCompanionBuilder =
    SupplementLogsCompanion Function({
      Value<int> id,
      required DateTime date,
      required int supplementId,
      Value<bool> taken,
      Value<String> source,
    });
typedef $$SupplementLogsTableUpdateCompanionBuilder =
    SupplementLogsCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<int> supplementId,
      Value<bool> taken,
      Value<String> source,
    });

final class $$SupplementLogsTableReferences
    extends BaseReferences<_$AppDatabase, $SupplementLogsTable, SupplementLog> {
  $$SupplementLogsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SupplementsTable _supplementIdTable(_$AppDatabase db) => db
      .supplements
      .createAlias('supplement_logs__supplement_id__supplements__id');

  $$SupplementsTableProcessedTableManager get supplementId {
    final $_column = $_itemColumn<int>('supplement_id')!;

    final manager = $$SupplementsTableTableManager(
      $_db,
      $_db.supplements,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_supplementIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SupplementLogsTableFilterComposer
    extends Composer<_$AppDatabase, $SupplementLogsTable> {
  $$SupplementLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get taken => $composableBuilder(
    column: $table.taken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  $$SupplementsTableFilterComposer get supplementId {
    final $$SupplementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supplementId,
      referencedTable: $db.supplements,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SupplementsTableFilterComposer(
            $db: $db,
            $table: $db.supplements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SupplementLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $SupplementLogsTable> {
  $$SupplementLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get taken => $composableBuilder(
    column: $table.taken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  $$SupplementsTableOrderingComposer get supplementId {
    final $$SupplementsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supplementId,
      referencedTable: $db.supplements,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SupplementsTableOrderingComposer(
            $db: $db,
            $table: $db.supplements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SupplementLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SupplementLogsTable> {
  $$SupplementLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<bool> get taken =>
      $composableBuilder(column: $table.taken, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  $$SupplementsTableAnnotationComposer get supplementId {
    final $$SupplementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supplementId,
      referencedTable: $db.supplements,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SupplementsTableAnnotationComposer(
            $db: $db,
            $table: $db.supplements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SupplementLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SupplementLogsTable,
          SupplementLog,
          $$SupplementLogsTableFilterComposer,
          $$SupplementLogsTableOrderingComposer,
          $$SupplementLogsTableAnnotationComposer,
          $$SupplementLogsTableCreateCompanionBuilder,
          $$SupplementLogsTableUpdateCompanionBuilder,
          (SupplementLog, $$SupplementLogsTableReferences),
          SupplementLog,
          PrefetchHooks Function({bool supplementId})
        > {
  $$SupplementLogsTableTableManager(
    _$AppDatabase db,
    $SupplementLogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SupplementLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SupplementLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SupplementLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> supplementId = const Value.absent(),
                Value<bool> taken = const Value.absent(),
                Value<String> source = const Value.absent(),
              }) => SupplementLogsCompanion(
                id: id,
                date: date,
                supplementId: supplementId,
                taken: taken,
                source: source,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required int supplementId,
                Value<bool> taken = const Value.absent(),
                Value<String> source = const Value.absent(),
              }) => SupplementLogsCompanion.insert(
                id: id,
                date: date,
                supplementId: supplementId,
                taken: taken,
                source: source,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SupplementLogsTable, SupplementLog>(table),
                  $$SupplementLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({supplementId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (supplementId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.supplementId,
                        referencedTable: $$SupplementLogsTableReferences
                            ._supplementIdTable(db),
                        referencedColumn: $$SupplementLogsTableReferences
                            ._supplementIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SupplementLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SupplementLogsTable,
      SupplementLog,
      $$SupplementLogsTableFilterComposer,
      $$SupplementLogsTableOrderingComposer,
      $$SupplementLogsTableAnnotationComposer,
      $$SupplementLogsTableCreateCompanionBuilder,
      $$SupplementLogsTableUpdateCompanionBuilder,
      (SupplementLog, $$SupplementLogsTableReferences),
      SupplementLog,
      PrefetchHooks Function({bool supplementId})
    >;
typedef $$SleepLogsTableCreateCompanionBuilder = SleepLogsCompanion Function({
  Value<int> id,
  required DateTime date,
  Value<DateTime?> start,
  Value<DateTime?> end,
  required int durationMin,
  Value<int?> quality,
  Value<int?> deepMin,
  Value<int?> remMin,
  Value<int?> lightMin,
  Value<int?> awakeMin,
  Value<String> source,
});
typedef $$SleepLogsTableUpdateCompanionBuilder = SleepLogsCompanion Function({
  Value<int> id,
  Value<DateTime> date,
  Value<DateTime?> start,
  Value<DateTime?> end,
  Value<int> durationMin,
  Value<int?> quality,
  Value<int?> deepMin,
  Value<int?> remMin,
  Value<int?> lightMin,
  Value<int?> awakeMin,
  Value<String> source,
});

class $$SleepLogsTableFilterComposer
    extends Composer<_$AppDatabase, $SleepLogsTable> {
  $$SleepLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get start => $composableBuilder(
    column: $table.start,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get end => $composableBuilder(
    column: $table.end,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMin => $composableBuilder(
    column: $table.durationMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quality => $composableBuilder(
    column: $table.quality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deepMin => $composableBuilder(
    column: $table.deepMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get remMin => $composableBuilder(
    column: $table.remMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lightMin => $composableBuilder(
    column: $table.lightMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get awakeMin => $composableBuilder(
    column: $table.awakeMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SleepLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $SleepLogsTable> {
  $$SleepLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get start => $composableBuilder(
    column: $table.start,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get end => $composableBuilder(
    column: $table.end,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMin => $composableBuilder(
    column: $table.durationMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quality => $composableBuilder(
    column: $table.quality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deepMin => $composableBuilder(
    column: $table.deepMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get remMin => $composableBuilder(
    column: $table.remMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lightMin => $composableBuilder(
    column: $table.lightMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get awakeMin => $composableBuilder(
    column: $table.awakeMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SleepLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SleepLogsTable> {
  $$SleepLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get start =>
      $composableBuilder(column: $table.start, builder: (column) => column);

  GeneratedColumn<DateTime> get end =>
      $composableBuilder(column: $table.end, builder: (column) => column);

  GeneratedColumn<int> get durationMin => $composableBuilder(
    column: $table.durationMin,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quality =>
      $composableBuilder(column: $table.quality, builder: (column) => column);

  GeneratedColumn<int> get deepMin =>
      $composableBuilder(column: $table.deepMin, builder: (column) => column);

  GeneratedColumn<int> get remMin =>
      $composableBuilder(column: $table.remMin, builder: (column) => column);

  GeneratedColumn<int> get lightMin =>
      $composableBuilder(column: $table.lightMin, builder: (column) => column);

  GeneratedColumn<int> get awakeMin =>
      $composableBuilder(column: $table.awakeMin, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);
}

class $$SleepLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SleepLogsTable,
          SleepLog,
          $$SleepLogsTableFilterComposer,
          $$SleepLogsTableOrderingComposer,
          $$SleepLogsTableAnnotationComposer,
          $$SleepLogsTableCreateCompanionBuilder,
          $$SleepLogsTableUpdateCompanionBuilder,
          (SleepLog, BaseReferences<_$AppDatabase, $SleepLogsTable, SleepLog>),
          SleepLog,
          PrefetchHooks Function()
        > {
  $$SleepLogsTableTableManager(_$AppDatabase db, $SleepLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SleepLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SleepLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SleepLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<DateTime?> start = const Value.absent(),
                Value<DateTime?> end = const Value.absent(),
                Value<int> durationMin = const Value.absent(),
                Value<int?> quality = const Value.absent(),
                Value<int?> deepMin = const Value.absent(),
                Value<int?> remMin = const Value.absent(),
                Value<int?> lightMin = const Value.absent(),
                Value<int?> awakeMin = const Value.absent(),
                Value<String> source = const Value.absent(),
              }) => SleepLogsCompanion(
                id: id,
                date: date,
                start: start,
                end: end,
                durationMin: durationMin,
                quality: quality,
                deepMin: deepMin,
                remMin: remMin,
                lightMin: lightMin,
                awakeMin: awakeMin,
                source: source,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                Value<DateTime?> start = const Value.absent(),
                Value<DateTime?> end = const Value.absent(),
                required int durationMin,
                Value<int?> quality = const Value.absent(),
                Value<int?> deepMin = const Value.absent(),
                Value<int?> remMin = const Value.absent(),
                Value<int?> lightMin = const Value.absent(),
                Value<int?> awakeMin = const Value.absent(),
                Value<String> source = const Value.absent(),
              }) => SleepLogsCompanion.insert(
                id: id,
                date: date,
                start: start,
                end: end,
                durationMin: durationMin,
                quality: quality,
                deepMin: deepMin,
                remMin: remMin,
                lightMin: lightMin,
                awakeMin: awakeMin,
                source: source,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SleepLogsTable, SleepLog>(table),
                  BaseReferences<_$AppDatabase, $SleepLogsTable, SleepLog>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SleepLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SleepLogsTable,
      SleepLog,
      $$SleepLogsTableFilterComposer,
      $$SleepLogsTableOrderingComposer,
      $$SleepLogsTableAnnotationComposer,
      $$SleepLogsTableCreateCompanionBuilder,
      $$SleepLogsTableUpdateCompanionBuilder,
      (SleepLog, BaseReferences<_$AppDatabase, $SleepLogsTable, SleepLog>),
      SleepLog,
      PrefetchHooks Function()
    >;
typedef $$HealthDailyTableCreateCompanionBuilder =
    HealthDailyCompanion Function({
      Value<int> id,
      required DateTime date,
      Value<int?> steps,
      Value<double?> restingHr,
      Value<double?> avgHr,
      Value<double?> hrv,
      Value<double?> activeCalories,
      Value<int?> recoveryScore,
      Value<String> sourcesJson,
      Value<DateTime?> lastSyncedAt,
    });
typedef $$HealthDailyTableUpdateCompanionBuilder =
    HealthDailyCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<int?> steps,
      Value<double?> restingHr,
      Value<double?> avgHr,
      Value<double?> hrv,
      Value<double?> activeCalories,
      Value<int?> recoveryScore,
      Value<String> sourcesJson,
      Value<DateTime?> lastSyncedAt,
    });

class $$HealthDailyTableFilterComposer
    extends Composer<_$AppDatabase, $HealthDailyTable> {
  $$HealthDailyTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get steps => $composableBuilder(
    column: $table.steps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get restingHr => $composableBuilder(
    column: $table.restingHr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get avgHr => $composableBuilder(
    column: $table.avgHr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hrv => $composableBuilder(
    column: $table.hrv,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get activeCalories => $composableBuilder(
    column: $table.activeCalories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recoveryScore => $composableBuilder(
    column: $table.recoveryScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourcesJson => $composableBuilder(
    column: $table.sourcesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HealthDailyTableOrderingComposer
    extends Composer<_$AppDatabase, $HealthDailyTable> {
  $$HealthDailyTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get steps => $composableBuilder(
    column: $table.steps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get restingHr => $composableBuilder(
    column: $table.restingHr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get avgHr => $composableBuilder(
    column: $table.avgHr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hrv => $composableBuilder(
    column: $table.hrv,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get activeCalories => $composableBuilder(
    column: $table.activeCalories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recoveryScore => $composableBuilder(
    column: $table.recoveryScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourcesJson => $composableBuilder(
    column: $table.sourcesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HealthDailyTableAnnotationComposer
    extends Composer<_$AppDatabase, $HealthDailyTable> {
  $$HealthDailyTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get steps =>
      $composableBuilder(column: $table.steps, builder: (column) => column);

  GeneratedColumn<double> get restingHr =>
      $composableBuilder(column: $table.restingHr, builder: (column) => column);

  GeneratedColumn<double> get avgHr =>
      $composableBuilder(column: $table.avgHr, builder: (column) => column);

  GeneratedColumn<double> get hrv =>
      $composableBuilder(column: $table.hrv, builder: (column) => column);

  GeneratedColumn<double> get activeCalories => $composableBuilder(
    column: $table.activeCalories,
    builder: (column) => column,
  );

  GeneratedColumn<int> get recoveryScore => $composableBuilder(
    column: $table.recoveryScore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourcesJson => $composableBuilder(
    column: $table.sourcesJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );
}

class $$HealthDailyTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HealthDailyTable,
          HealthDailyData,
          $$HealthDailyTableFilterComposer,
          $$HealthDailyTableOrderingComposer,
          $$HealthDailyTableAnnotationComposer,
          $$HealthDailyTableCreateCompanionBuilder,
          $$HealthDailyTableUpdateCompanionBuilder,
          (
            HealthDailyData,
            BaseReferences<_$AppDatabase, $HealthDailyTable, HealthDailyData>,
          ),
          HealthDailyData,
          PrefetchHooks Function()
        > {
  $$HealthDailyTableTableManager(_$AppDatabase db, $HealthDailyTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HealthDailyTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HealthDailyTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HealthDailyTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int?> steps = const Value.absent(),
                Value<double?> restingHr = const Value.absent(),
                Value<double?> avgHr = const Value.absent(),
                Value<double?> hrv = const Value.absent(),
                Value<double?> activeCalories = const Value.absent(),
                Value<int?> recoveryScore = const Value.absent(),
                Value<String> sourcesJson = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
              }) => HealthDailyCompanion(
                id: id,
                date: date,
                steps: steps,
                restingHr: restingHr,
                avgHr: avgHr,
                hrv: hrv,
                activeCalories: activeCalories,
                recoveryScore: recoveryScore,
                sourcesJson: sourcesJson,
                lastSyncedAt: lastSyncedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                Value<int?> steps = const Value.absent(),
                Value<double?> restingHr = const Value.absent(),
                Value<double?> avgHr = const Value.absent(),
                Value<double?> hrv = const Value.absent(),
                Value<double?> activeCalories = const Value.absent(),
                Value<int?> recoveryScore = const Value.absent(),
                Value<String> sourcesJson = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
              }) => HealthDailyCompanion.insert(
                id: id,
                date: date,
                steps: steps,
                restingHr: restingHr,
                avgHr: avgHr,
                hrv: hrv,
                activeCalories: activeCalories,
                recoveryScore: recoveryScore,
                sourcesJson: sourcesJson,
                lastSyncedAt: lastSyncedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$HealthDailyTable, HealthDailyData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $HealthDailyTable,
                    HealthDailyData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HealthDailyTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HealthDailyTable,
      HealthDailyData,
      $$HealthDailyTableFilterComposer,
      $$HealthDailyTableOrderingComposer,
      $$HealthDailyTableAnnotationComposer,
      $$HealthDailyTableCreateCompanionBuilder,
      $$HealthDailyTableUpdateCompanionBuilder,
      (
        HealthDailyData,
        BaseReferences<_$AppDatabase, $HealthDailyTable, HealthDailyData>,
      ),
      HealthDailyData,
      PrefetchHooks Function()
    >;
typedef $$CoachMessagesTableCreateCompanionBuilder =
    CoachMessagesCompanion Function({
      Value<int> id,
      required String role,
      required String content,
      Value<String> kind,
      Value<String?> metaJson,
      Value<bool> isRead,
      Value<DateTime> createdAt,
    });
typedef $$CoachMessagesTableUpdateCompanionBuilder =
    CoachMessagesCompanion Function({
      Value<int> id,
      Value<String> role,
      Value<String> content,
      Value<String> kind,
      Value<String?> metaJson,
      Value<bool> isRead,
      Value<DateTime> createdAt,
    });

class $$CoachMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $CoachMessagesTable> {
  $$CoachMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metaJson => $composableBuilder(
    column: $table.metaJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CoachMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $CoachMessagesTable> {
  $$CoachMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metaJson => $composableBuilder(
    column: $table.metaJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CoachMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CoachMessagesTable> {
  $$CoachMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get metaJson =>
      $composableBuilder(column: $table.metaJson, builder: (column) => column);

  GeneratedColumn<bool> get isRead =>
      $composableBuilder(column: $table.isRead, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CoachMessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CoachMessagesTable,
          CoachMessage,
          $$CoachMessagesTableFilterComposer,
          $$CoachMessagesTableOrderingComposer,
          $$CoachMessagesTableAnnotationComposer,
          $$CoachMessagesTableCreateCompanionBuilder,
          $$CoachMessagesTableUpdateCompanionBuilder,
          (
            CoachMessage,
            BaseReferences<_$AppDatabase, $CoachMessagesTable, CoachMessage>,
          ),
          CoachMessage,
          PrefetchHooks Function()
        > {
  $$CoachMessagesTableTableManager(_$AppDatabase db, $CoachMessagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CoachMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CoachMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CoachMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String?> metaJson = const Value.absent(),
                Value<bool> isRead = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CoachMessagesCompanion(
                id: id,
                role: role,
                content: content,
                kind: kind,
                metaJson: metaJson,
                isRead: isRead,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String role,
                required String content,
                Value<String> kind = const Value.absent(),
                Value<String?> metaJson = const Value.absent(),
                Value<bool> isRead = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CoachMessagesCompanion.insert(
                id: id,
                role: role,
                content: content,
                kind: kind,
                metaJson: metaJson,
                isRead: isRead,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CoachMessagesTable, CoachMessage>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CoachMessagesTable,
                    CoachMessage
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CoachMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CoachMessagesTable,
      CoachMessage,
      $$CoachMessagesTableFilterComposer,
      $$CoachMessagesTableOrderingComposer,
      $$CoachMessagesTableAnnotationComposer,
      $$CoachMessagesTableCreateCompanionBuilder,
      $$CoachMessagesTableUpdateCompanionBuilder,
      (
        CoachMessage,
        BaseReferences<_$AppDatabase, $CoachMessagesTable, CoachMessage>,
      ),
      CoachMessage,
      PrefetchHooks Function()
    >;
typedef $$CoachMemoriesTableCreateCompanionBuilder =
    CoachMemoriesCompanion Function({
      Value<int> id,
      required String content,
      Value<String> source,
      Value<DateTime> createdAt,
    });
typedef $$CoachMemoriesTableUpdateCompanionBuilder =
    CoachMemoriesCompanion Function({
      Value<int> id,
      Value<String> content,
      Value<String> source,
      Value<DateTime> createdAt,
    });

class $$CoachMemoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CoachMemoriesTable> {
  $$CoachMemoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CoachMemoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CoachMemoriesTable> {
  $$CoachMemoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CoachMemoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CoachMemoriesTable> {
  $$CoachMemoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CoachMemoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CoachMemoriesTable,
          CoachMemory,
          $$CoachMemoriesTableFilterComposer,
          $$CoachMemoriesTableOrderingComposer,
          $$CoachMemoriesTableAnnotationComposer,
          $$CoachMemoriesTableCreateCompanionBuilder,
          $$CoachMemoriesTableUpdateCompanionBuilder,
          (
            CoachMemory,
            BaseReferences<_$AppDatabase, $CoachMemoriesTable, CoachMemory>,
          ),
          CoachMemory,
          PrefetchHooks Function()
        > {
  $$CoachMemoriesTableTableManager(_$AppDatabase db, $CoachMemoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CoachMemoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CoachMemoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CoachMemoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CoachMemoriesCompanion(
                id: id,
                content: content,
                source: source,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String content,
                Value<String> source = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CoachMemoriesCompanion.insert(
                id: id,
                content: content,
                source: source,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CoachMemoriesTable, CoachMemory>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CoachMemoriesTable,
                    CoachMemory
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CoachMemoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CoachMemoriesTable,
      CoachMemory,
      $$CoachMemoriesTableFilterComposer,
      $$CoachMemoriesTableOrderingComposer,
      $$CoachMemoriesTableAnnotationComposer,
      $$CoachMemoriesTableCreateCompanionBuilder,
      $$CoachMemoriesTableUpdateCompanionBuilder,
      (
        CoachMemory,
        BaseReferences<_$AppDatabase, $CoachMemoriesTable, CoachMemory>,
      ),
      CoachMemory,
      PrefetchHooks Function()
    >;
typedef $$CoachProposalsTableCreateCompanionBuilder =
    CoachProposalsCompanion Function({
      Value<int> id,
      required String type,
      required String title,
      Value<String?> description,
      required String payloadJson,
      Value<String> status,
      Value<int?> messageId,
      Value<DateTime> createdAt,
      Value<DateTime?> resolvedAt,
    });
typedef $$CoachProposalsTableUpdateCompanionBuilder =
    CoachProposalsCompanion Function({
      Value<int> id,
      Value<String> type,
      Value<String> title,
      Value<String?> description,
      Value<String> payloadJson,
      Value<String> status,
      Value<int?> messageId,
      Value<DateTime> createdAt,
      Value<DateTime?> resolvedAt,
    });

class $$CoachProposalsTableFilterComposer
    extends Composer<_$AppDatabase, $CoachProposalsTable> {
  $$CoachProposalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get messageId => $composableBuilder(
    column: $table.messageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CoachProposalsTableOrderingComposer
    extends Composer<_$AppDatabase, $CoachProposalsTable> {
  $$CoachProposalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get messageId => $composableBuilder(
    column: $table.messageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CoachProposalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CoachProposalsTable> {
  $$CoachProposalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get messageId =>
      $composableBuilder(column: $table.messageId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => column,
  );
}

class $$CoachProposalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CoachProposalsTable,
          CoachProposal,
          $$CoachProposalsTableFilterComposer,
          $$CoachProposalsTableOrderingComposer,
          $$CoachProposalsTableAnnotationComposer,
          $$CoachProposalsTableCreateCompanionBuilder,
          $$CoachProposalsTableUpdateCompanionBuilder,
          (
            CoachProposal,
            BaseReferences<_$AppDatabase, $CoachProposalsTable, CoachProposal>,
          ),
          CoachProposal,
          PrefetchHooks Function()
        > {
  $$CoachProposalsTableTableManager(
    _$AppDatabase db,
    $CoachProposalsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CoachProposalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CoachProposalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CoachProposalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int?> messageId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> resolvedAt = const Value.absent(),
              }) => CoachProposalsCompanion(
                id: id,
                type: type,
                title: title,
                description: description,
                payloadJson: payloadJson,
                status: status,
                messageId: messageId,
                createdAt: createdAt,
                resolvedAt: resolvedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String type,
                required String title,
                Value<String?> description = const Value.absent(),
                required String payloadJson,
                Value<String> status = const Value.absent(),
                Value<int?> messageId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> resolvedAt = const Value.absent(),
              }) => CoachProposalsCompanion.insert(
                id: id,
                type: type,
                title: title,
                description: description,
                payloadJson: payloadJson,
                status: status,
                messageId: messageId,
                createdAt: createdAt,
                resolvedAt: resolvedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CoachProposalsTable, CoachProposal>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CoachProposalsTable,
                    CoachProposal
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CoachProposalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CoachProposalsTable,
      CoachProposal,
      $$CoachProposalsTableFilterComposer,
      $$CoachProposalsTableOrderingComposer,
      $$CoachProposalsTableAnnotationComposer,
      $$CoachProposalsTableCreateCompanionBuilder,
      $$CoachProposalsTableUpdateCompanionBuilder,
      (
        CoachProposal,
        BaseReferences<_$AppDatabase, $CoachProposalsTable, CoachProposal>,
      ),
      CoachProposal,
      PrefetchHooks Function()
    >;
typedef $$AiUsageTableCreateCompanionBuilder = AiUsageCompanion Function({
  Value<int> id,
  Value<DateTime> timestamp,
  required String feature,
  required String model,
  Value<int> inputTokens,
  Value<int> outputTokens,
  Value<int> cacheReadTokens,
  Value<int> cacheWriteTokens,
  Value<double> costUsd,
});
typedef $$AiUsageTableUpdateCompanionBuilder = AiUsageCompanion Function({
  Value<int> id,
  Value<DateTime> timestamp,
  Value<String> feature,
  Value<String> model,
  Value<int> inputTokens,
  Value<int> outputTokens,
  Value<int> cacheReadTokens,
  Value<int> cacheWriteTokens,
  Value<double> costUsd,
});

class $$AiUsageTableFilterComposer
    extends Composer<_$AppDatabase, $AiUsageTable> {
  $$AiUsageTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get feature => $composableBuilder(
    column: $table.feature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get inputTokens => $composableBuilder(
    column: $table.inputTokens,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get outputTokens => $composableBuilder(
    column: $table.outputTokens,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cacheReadTokens => $composableBuilder(
    column: $table.cacheReadTokens,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cacheWriteTokens => $composableBuilder(
    column: $table.cacheWriteTokens,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get costUsd => $composableBuilder(
    column: $table.costUsd,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AiUsageTableOrderingComposer
    extends Composer<_$AppDatabase, $AiUsageTable> {
  $$AiUsageTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get feature => $composableBuilder(
    column: $table.feature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get inputTokens => $composableBuilder(
    column: $table.inputTokens,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get outputTokens => $composableBuilder(
    column: $table.outputTokens,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cacheReadTokens => $composableBuilder(
    column: $table.cacheReadTokens,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cacheWriteTokens => $composableBuilder(
    column: $table.cacheWriteTokens,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get costUsd => $composableBuilder(
    column: $table.costUsd,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AiUsageTableAnnotationComposer
    extends Composer<_$AppDatabase, $AiUsageTable> {
  $$AiUsageTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get feature =>
      $composableBuilder(column: $table.feature, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<int> get inputTokens => $composableBuilder(
    column: $table.inputTokens,
    builder: (column) => column,
  );

  GeneratedColumn<int> get outputTokens => $composableBuilder(
    column: $table.outputTokens,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cacheReadTokens => $composableBuilder(
    column: $table.cacheReadTokens,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cacheWriteTokens => $composableBuilder(
    column: $table.cacheWriteTokens,
    builder: (column) => column,
  );

  GeneratedColumn<double> get costUsd =>
      $composableBuilder(column: $table.costUsd, builder: (column) => column);
}

class $$AiUsageTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AiUsageTable,
          AiUsageData,
          $$AiUsageTableFilterComposer,
          $$AiUsageTableOrderingComposer,
          $$AiUsageTableAnnotationComposer,
          $$AiUsageTableCreateCompanionBuilder,
          $$AiUsageTableUpdateCompanionBuilder,
          (
            AiUsageData,
            BaseReferences<_$AppDatabase, $AiUsageTable, AiUsageData>,
          ),
          AiUsageData,
          PrefetchHooks Function()
        > {
  $$AiUsageTableTableManager(_$AppDatabase db, $AiUsageTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AiUsageTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AiUsageTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AiUsageTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<String> feature = const Value.absent(),
                Value<String> model = const Value.absent(),
                Value<int> inputTokens = const Value.absent(),
                Value<int> outputTokens = const Value.absent(),
                Value<int> cacheReadTokens = const Value.absent(),
                Value<int> cacheWriteTokens = const Value.absent(),
                Value<double> costUsd = const Value.absent(),
              }) => AiUsageCompanion(
                id: id,
                timestamp: timestamp,
                feature: feature,
                model: model,
                inputTokens: inputTokens,
                outputTokens: outputTokens,
                cacheReadTokens: cacheReadTokens,
                cacheWriteTokens: cacheWriteTokens,
                costUsd: costUsd,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                required String feature,
                required String model,
                Value<int> inputTokens = const Value.absent(),
                Value<int> outputTokens = const Value.absent(),
                Value<int> cacheReadTokens = const Value.absent(),
                Value<int> cacheWriteTokens = const Value.absent(),
                Value<double> costUsd = const Value.absent(),
              }) => AiUsageCompanion.insert(
                id: id,
                timestamp: timestamp,
                feature: feature,
                model: model,
                inputTokens: inputTokens,
                outputTokens: outputTokens,
                cacheReadTokens: cacheReadTokens,
                cacheWriteTokens: cacheWriteTokens,
                costUsd: costUsd,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AiUsageTable, AiUsageData>(table),
                  BaseReferences<_$AppDatabase, $AiUsageTable, AiUsageData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AiUsageTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AiUsageTable,
      AiUsageData,
      $$AiUsageTableFilterComposer,
      $$AiUsageTableOrderingComposer,
      $$AiUsageTableAnnotationComposer,
      $$AiUsageTableCreateCompanionBuilder,
      $$AiUsageTableUpdateCompanionBuilder,
      (AiUsageData, BaseReferences<_$AppDatabase, $AiUsageTable, AiUsageData>),
      AiUsageData,
      PrefetchHooks Function()
    >;
typedef $$AiQueueTableCreateCompanionBuilder = AiQueueCompanion Function({
  Value<int> id,
  required String feature,
  required String payloadJson,
  Value<String> status,
  Value<int> attempts,
  Value<String?> lastError,
  Value<DateTime> createdAt,
});
typedef $$AiQueueTableUpdateCompanionBuilder = AiQueueCompanion Function({
  Value<int> id,
  Value<String> feature,
  Value<String> payloadJson,
  Value<String> status,
  Value<int> attempts,
  Value<String?> lastError,
  Value<DateTime> createdAt,
});

class $$AiQueueTableFilterComposer
    extends Composer<_$AppDatabase, $AiQueueTable> {
  $$AiQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get feature => $composableBuilder(
    column: $table.feature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AiQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $AiQueueTable> {
  $$AiQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get feature => $composableBuilder(
    column: $table.feature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AiQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $AiQueueTable> {
  $$AiQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get feature =>
      $composableBuilder(column: $table.feature, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AiQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AiQueueTable,
          AiQueueData,
          $$AiQueueTableFilterComposer,
          $$AiQueueTableOrderingComposer,
          $$AiQueueTableAnnotationComposer,
          $$AiQueueTableCreateCompanionBuilder,
          $$AiQueueTableUpdateCompanionBuilder,
          (
            AiQueueData,
            BaseReferences<_$AppDatabase, $AiQueueTable, AiQueueData>,
          ),
          AiQueueData,
          PrefetchHooks Function()
        > {
  $$AiQueueTableTableManager(_$AppDatabase db, $AiQueueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AiQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AiQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AiQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> feature = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AiQueueCompanion(
                id: id,
                feature: feature,
                payloadJson: payloadJson,
                status: status,
                attempts: attempts,
                lastError: lastError,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String feature,
                required String payloadJson,
                Value<String> status = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AiQueueCompanion.insert(
                id: id,
                feature: feature,
                payloadJson: payloadJson,
                status: status,
                attempts: attempts,
                lastError: lastError,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AiQueueTable, AiQueueData>(table),
                  BaseReferences<_$AppDatabase, $AiQueueTable, AiQueueData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AiQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AiQueueTable,
      AiQueueData,
      $$AiQueueTableFilterComposer,
      $$AiQueueTableOrderingComposer,
      $$AiQueueTableAnnotationComposer,
      $$AiQueueTableCreateCompanionBuilder,
      $$AiQueueTableUpdateCompanionBuilder,
      (AiQueueData, BaseReferences<_$AppDatabase, $AiQueueTable, AiQueueData>),
      AiQueueData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db, _db.exercises);
  $$WorkoutPlansTableTableManager get workoutPlans =>
      $$WorkoutPlansTableTableManager(_db, _db.workoutPlans);
  $$PlanDaysTableTableManager get planDays =>
      $$PlanDaysTableTableManager(_db, _db.planDays);
  $$PlanExercisesTableTableManager get planExercises =>
      $$PlanExercisesTableTableManager(_db, _db.planExercises);
  $$WorkoutSessionsTableTableManager get workoutSessions =>
      $$WorkoutSessionsTableTableManager(_db, _db.workoutSessions);
  $$SetLogsTableTableManager get setLogs =>
      $$SetLogsTableTableManager(_db, _db.setLogs);
  $$SessionExerciseNotesTableTableManager get sessionExerciseNotes =>
      $$SessionExerciseNotesTableTableManager(_db, _db.sessionExerciseNotes);
  $$CardioLogsTableTableManager get cardioLogs =>
      $$CardioLogsTableTableManager(_db, _db.cardioLogs);
  $$MealPlansTableTableManager get mealPlans =>
      $$MealPlansTableTableManager(_db, _db.mealPlans);
  $$PlannedMealsTableTableManager get plannedMeals =>
      $$PlannedMealsTableTableManager(_db, _db.plannedMeals);
  $$MealLogsTableTableManager get mealLogs =>
      $$MealLogsTableTableManager(_db, _db.mealLogs);
  $$FoodItemsTableTableManager get foodItems =>
      $$FoodItemsTableTableManager(_db, _db.foodItems);
  $$BodyMetricsTableTableManager get bodyMetrics =>
      $$BodyMetricsTableTableManager(_db, _db.bodyMetrics);
  $$ProgressPhotosTableTableManager get progressPhotos =>
      $$ProgressPhotosTableTableManager(_db, _db.progressPhotos);
  $$WaterLogsTableTableManager get waterLogs =>
      $$WaterLogsTableTableManager(_db, _db.waterLogs);
  $$SupplementsTableTableManager get supplements =>
      $$SupplementsTableTableManager(_db, _db.supplements);
  $$SupplementLogsTableTableManager get supplementLogs =>
      $$SupplementLogsTableTableManager(_db, _db.supplementLogs);
  $$SleepLogsTableTableManager get sleepLogs =>
      $$SleepLogsTableTableManager(_db, _db.sleepLogs);
  $$HealthDailyTableTableManager get healthDaily =>
      $$HealthDailyTableTableManager(_db, _db.healthDaily);
  $$CoachMessagesTableTableManager get coachMessages =>
      $$CoachMessagesTableTableManager(_db, _db.coachMessages);
  $$CoachMemoriesTableTableManager get coachMemories =>
      $$CoachMemoriesTableTableManager(_db, _db.coachMemories);
  $$CoachProposalsTableTableManager get coachProposals =>
      $$CoachProposalsTableTableManager(_db, _db.coachProposals);
  $$AiUsageTableTableManager get aiUsage =>
      $$AiUsageTableTableManager(_db, _db.aiUsage);
  $$AiQueueTableTableManager get aiQueue =>
      $$AiQueueTableTableManager(_db, _db.aiQueue);
}
