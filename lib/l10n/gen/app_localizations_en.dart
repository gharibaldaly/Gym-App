// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get coachTabChat => 'Chat';

  @override
  String get coachTabReports => 'Reports';

  @override
  String get coachTabSuggestions => 'Suggestions';

  @override
  String get coachMemoryTitle => 'Coach memory';

  @override
  String get coachMemoryHint =>
      'Facts the coach saved from your chats. They\'re sent with every message so he remembers you.';

  @override
  String get coachMemoryEmpty =>
      'The coach hasn\'t saved anything about you yet.';

  @override
  String get coachMemoryClearAll => 'Clear all';

  @override
  String get coachMemoryClearConfirm =>
      'Delete everything the coach remembers about you?';

  @override
  String get coachMemoryDeleted => 'Deleted';

  @override
  String get coachInputHint => 'Message your coach…';

  @override
  String get coachInputNoKey => 'Add your API key to chat with the coach';

  @override
  String get coachSend => 'Send';

  @override
  String get coachVoice => 'Voice input';

  @override
  String get coachListening => 'Listening…';

  @override
  String get coachVoiceUnavailable =>
      'Voice input isn\'t available on this device';

  @override
  String get coachOfflineNotice =>
      'No internet. Your message is saved — tap Resend when you\'re back online.';

  @override
  String get coachResend => 'Resend';

  @override
  String get coachThinking => 'Coach is typing…';

  @override
  String get coachEmptyChat =>
      'Ask your coach anything: your plan, food, a pain — or tell him what you ate and he\'ll log it.';

  @override
  String get coachRefused => 'The coach couldn\'t answer that. Try rephrasing.';

  @override
  String get coachProposalWaiting =>
      'I made a proposal — check the card below.';

  @override
  String get coachKindMorning => 'Morning';

  @override
  String get coachKindWorkoutSummary => 'Workout summary';

  @override
  String get coachKindPlateau => 'Plateau';

  @override
  String get coachKindWeekly => 'Weekly report';

  @override
  String get coachKindRecovery => 'Recovery';

  @override
  String get coachAccepted => 'Accepted';

  @override
  String get coachRejected => 'Rejected';

  @override
  String get coachPending => 'Waiting for you';

  @override
  String get coachAppliedSnack => 'Done — change applied.';

  @override
  String get coachRejectedSnack => 'Proposal rejected.';

  @override
  String coachApplyFailed(String error) {
    return 'Couldn\'t apply: $error';
  }

  @override
  String get coachNoPending => 'No pending suggestions.';

  @override
  String get coachHistory => 'History';

  @override
  String get coachReportsEmpty =>
      'No reports yet. Weekly reports arrive every Friday evening and workout summaries after each workout.';

  @override
  String get coachGenerateWeekly => 'Generate weekly report now';

  @override
  String get coachGenerating => 'Generating…';

  @override
  String get coachWeeklyDone => 'Weekly report is ready';

  @override
  String get coachShowMore => 'Show more';

  @override
  String get coachShowLess => 'Show less';

  @override
  String get coachCopy => 'Copy';

  @override
  String get coachCopied => 'Copied';

  @override
  String coachPropPlanChangeTitle(String day) {
    return 'Plan change: $day';
  }

  @override
  String coachPropSwapTitle(String from, String to) {
    return 'Swap $from → $to';
  }

  @override
  String get coachSwapScopeToday => 'Today\'s workout only';

  @override
  String get coachSwapScopeAlways => 'Permanently in the plan';

  @override
  String coachPropLogMealTitle(String name, int kcal) {
    return 'Log meal: $name ($kcal kcal)';
  }

  @override
  String coachPropLogSetTitle(String exercise, String weight, int reps) {
    return 'Log set: $exercise $weight kg × $reps';
  }

  @override
  String coachPropMacrosTitle(int kcal) {
    return 'New daily target: $kcal kcal';
  }

  @override
  String coachMacroLine(int protein, int carbs, int fat) {
    return 'Protein $protein g · Carbs $carbs g · Fat $fat g';
  }

  @override
  String coachChangeAdd(String exercise, String detail) {
    return 'Add: $exercise $detail';
  }

  @override
  String coachChangeRemove(String exercise) {
    return 'Remove: $exercise';
  }

  @override
  String coachChangeModify(String exercise, String detail) {
    return 'Change: $exercise → $detail';
  }

  @override
  String coachRestSeconds(int seconds) {
    return 'rest ${seconds}s';
  }

  @override
  String coachPropRecoveryTitle(int score) {
    return 'Lighter workout today (recovery $score)';
  }

  @override
  String get coachPropRecoveryDesc =>
      'Weights −10% and one set less per exercise, today only.';

  @override
  String coachRecoveryMessage(int score) {
    return 'Recovery today is **$score/100** — low. I proposed a lighter session: −10% weight and one set less per exercise. Approve it from the card if you agree.';
  }

  @override
  String get coachNotifMorning => 'Good morning — your coach';

  @override
  String get coachNotifWorkout => 'Workout summary is ready';

  @override
  String coachNotifPlateau(String exercise) {
    return 'Plateau: $exercise';
  }

  @override
  String get coachNotifWeekly => 'Your weekly report is ready';

  @override
  String get coachNotifRecovery => 'Low recovery today';

  @override
  String get appName => 'IronMind';

  @override
  String get tabToday => 'Today';

  @override
  String get tabWorkout => 'Workout';

  @override
  String get tabFood => 'Food';

  @override
  String get tabCoach => 'Coach';

  @override
  String get tabProgress => 'Progress';

  @override
  String get settings => 'Settings';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get done => 'Done';

  @override
  String get retry => 'Retry';

  @override
  String get close => 'Close';

  @override
  String get confirm => 'Confirm';

  @override
  String get accept => 'Accept';

  @override
  String get reject => 'Reject';

  @override
  String get search => 'Search';

  @override
  String get all => 'All';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get loading => 'Loading…';

  @override
  String get errorGeneric => 'Something went wrong';

  @override
  String get noInternet => 'No internet connection';

  @override
  String get noApiKeyTitle => 'AI is off';

  @override
  String get noApiKeyBody =>
      'Add your Claude API key in Settings to enable AI features. Everything else works without it.';

  @override
  String get addApiKey => 'Add API key';

  @override
  String get aiQueuedOffline =>
      'Saved. The AI will process it when you\'re back online.';

  @override
  String get kg => 'kg';

  @override
  String get cm => 'cm';

  @override
  String get kcal => 'kcal';

  @override
  String get gramsShort => 'g';

  @override
  String get mlShort => 'ml';

  @override
  String get minutesShort => 'min';

  @override
  String get hoursShort => 'h';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get skip => 'Skip';

  @override
  String get optional => 'Optional';

  @override
  String get notes => 'Notes';

  @override
  String get empty => 'Nothing here yet';

  @override
  String get protein => 'Protein';

  @override
  String get carbs => 'Carbs';

  @override
  String get fat => 'Fat';

  @override
  String get calories => 'Calories';

  @override
  String get water => 'Water';

  @override
  String get language => 'Language';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'English';

  @override
  String get weekdayMon => 'Mon';

  @override
  String get weekdayTue => 'Tue';

  @override
  String get weekdayWed => 'Wed';

  @override
  String get weekdayThu => 'Thu';

  @override
  String get weekdayFri => 'Fri';

  @override
  String get weekdaySat => 'Sat';

  @override
  String get weekdaySun => 'Sun';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String onbStepOf(String current, String total) {
    return 'Step $current of $total';
  }

  @override
  String get onbNext => 'Next';

  @override
  String get onbBack => 'Back';

  @override
  String get onbSkip => 'Skip';

  @override
  String get onbBackToSummary => 'Back to summary';

  @override
  String get onbBuildPlan => 'Build my plan';

  @override
  String get onbNotSet => 'Not set';

  @override
  String get onbNone => 'None';

  @override
  String get onbOptional => 'Optional';

  @override
  String onbErrRange(String min, String max) {
    return 'Enter a value between $min and $max';
  }

  @override
  String get onbSectionBasics => 'About you';

  @override
  String get onbSectionGoals => 'Goal & level';

  @override
  String get onbSectionTraining => 'Training';

  @override
  String get onbSectionLifestyle => 'Health & lifestyle';

  @override
  String get onbSectionNutrition => 'Nutrition';

  @override
  String get onbSectionConnections => 'Connections';

  @override
  String get onbLangTitle => 'Choose your language';

  @override
  String get onbLangSubtitle => 'You can change it anytime from Settings.';

  @override
  String get onbBodyTitle => 'Tell us about yourself';

  @override
  String get onbBodySubtitle =>
      'We use this to calculate your calories and macros.';

  @override
  String get onbSexMale => 'Male';

  @override
  String get onbSexFemale => 'Female';

  @override
  String get onbAge => 'Age';

  @override
  String get onbYears => 'years';

  @override
  String get onbHeight => 'Height';

  @override
  String get onbWeight => 'Current weight';

  @override
  String get onbBodyFatTitle => 'Body fat percentage';

  @override
  String get onbBodyFatSubtitle => 'A rough estimate is totally fine.';

  @override
  String get onbBfNumber => 'I know the number';

  @override
  String get onbBfNumberSub => 'From an InBody scan or calipers';

  @override
  String get onbBfShape => 'Pick my body shape';

  @override
  String get onbBfShapeSub => 'We\'ll estimate it from how you look';

  @override
  String get onbBfUnknown => 'I don\'t know';

  @override
  String get onbBfUnknownSub => 'No problem, we\'ll use your weight and height';

  @override
  String get onbBodyFatPct => 'Body fat';

  @override
  String get onbShapeLean => 'Very lean';

  @override
  String get onbShapeLeanSub => 'Clear abs and visible veins';

  @override
  String get onbShapeAthletic => 'Athletic';

  @override
  String get onbShapeAthleticSub => 'Abs outline shows';

  @override
  String get onbShapeAverage => 'Average';

  @override
  String get onbShapeAverageSub => 'Flat-ish belly, no abs';

  @override
  String get onbShapeSoft => 'A bit of a belly';

  @override
  String get onbShapeSoftSub => 'Soft midsection';

  @override
  String get onbShapeHeavy => 'Overweight';

  @override
  String get onbShapeHeavySub => 'Belly clearly sticks out';

  @override
  String onbShapeEstimate(String pct) {
    return '≈ $pct% body fat';
  }

  @override
  String get onbMeasTitle => 'Body measurements';

  @override
  String get onbMeasSubtitle =>
      'Optional – they help track progress beyond the scale.';

  @override
  String get onbMeasHint =>
      'Use a tape measure: waist at the navel, arm flexed at the widest point, thigh at the middle.';

  @override
  String get onbMeasWaist => 'Waist';

  @override
  String get onbMeasChest => 'Chest';

  @override
  String get onbMeasArm => 'Arm';

  @override
  String get onbMeasThigh => 'Thigh';

  @override
  String get onbMeasNeck => 'Neck';

  @override
  String get onbMeasHips => 'Hips';

  @override
  String get onbGoalTitle => 'What\'s your main goal?';

  @override
  String get onbGoalSubtitle => 'Pick one – the whole plan is built around it.';

  @override
  String get onbGoalBulk => 'Bulk';

  @override
  String get onbGoalBulkSub => 'Gain muscle and size';

  @override
  String get onbGoalCut => 'Cut';

  @override
  String get onbGoalCutSub => 'Lose fat, keep the muscle';

  @override
  String get onbGoalRecomp => 'Recomp';

  @override
  String get onbGoalRecompSub => 'Lose fat and build muscle together';

  @override
  String get onbGoalStrength => 'Strength';

  @override
  String get onbGoalStrengthSub => 'Lift heavier on the big lifts';

  @override
  String get onbGoalFitness => 'General fitness';

  @override
  String get onbGoalFitnessSub => 'Feel better, move better, stay healthy';

  @override
  String get onbTargetWeight => 'Target weight (optional)';

  @override
  String get onbGoalWeeks => 'In how many weeks? (optional)';

  @override
  String get onbWeeks => 'weeks';

  @override
  String onbGoalWeeksSuggest(String weeks) {
    return 'A realistic pace is about $weeks weeks';
  }

  @override
  String get onbWarnCutTarget =>
      'For a cut, the target is usually below your current weight.';

  @override
  String get onbWarnBulkTarget =>
      'For a bulk, the target is usually above your current weight.';

  @override
  String get onbLevelTitle => 'Your training level';

  @override
  String get onbLevelSubtitle =>
      'Be honest – it decides volume and exercise choice.';

  @override
  String get onbLevelBeginner => 'Beginner';

  @override
  String get onbLevelBeginnerSub => 'New or still learning the movements';

  @override
  String get onbLevelIntermediate => 'Intermediate';

  @override
  String get onbLevelIntermediateSub => 'Consistent training, solid technique';

  @override
  String get onbLevelAdvanced => 'Advanced';

  @override
  String get onbLevelAdvancedSub => 'Years of serious, structured training';

  @override
  String get onbExperienceTitle => 'How long have you been training?';

  @override
  String get onbExpNone => 'Just starting';

  @override
  String get onbExpLt6m => 'Less than 6 months';

  @override
  String get onbExp6to12m => '6–12 months';

  @override
  String get onbExp1to3y => '1–3 years';

  @override
  String get onbExp3yPlus => 'More than 3 years';

  @override
  String get onbDaysTitle => 'Training days per week';

  @override
  String get onbDaysSubtitle => 'Then pick the days themselves.';

  @override
  String get onbPickDays => 'Which days?';

  @override
  String onbDaysPicked(String picked, String total) {
    return '$picked of $total days picked';
  }

  @override
  String get onbSessionTitle => 'How long is each workout?';

  @override
  String get onbSessionSubtitle => 'Including warm-up and stretching.';

  @override
  String onbMinutesValue(String n) {
    return '$n min';
  }

  @override
  String get onbSession30 => 'Quick and focused';

  @override
  String get onbSession60 => 'The classic session';

  @override
  String get onbSession90 => 'Long sessions, more volume';

  @override
  String get onbSplitTitle => 'Preferred training split';

  @override
  String get onbSplitSubtitle => 'How should the week be divided?';

  @override
  String get onbSplitMuscleGroup => 'Muscle groups per day';

  @override
  String get onbSplitMuscleGroupSub => 'e.g. chest + triceps, back + biceps';

  @override
  String get onbSplitBro => 'Bro split';

  @override
  String get onbSplitBroSub => 'One muscle per day';

  @override
  String get onbSplitFullBody => 'Full body';

  @override
  String get onbSplitFullBodySub => 'Whole body every session';

  @override
  String get onbSplitPpl => 'Push / Pull / Legs';

  @override
  String get onbSplitPplSub => 'Pushing, pulling and leg days';

  @override
  String get onbSplitUpperLower => 'Upper / Lower';

  @override
  String get onbSplitUpperLowerSub => 'Alternate upper and lower body';

  @override
  String get onbSplitAi => 'Let the AI choose';

  @override
  String get onbSplitAiSub => 'Best split for your days and goal';

  @override
  String get onbFocusTitle => 'Muscles to focus on';

  @override
  String get onbFocusSubtitle => 'Pick any – or none for a balanced plan.';

  @override
  String get onbMuscleChest => 'Chest';

  @override
  String get onbMuscleBack => 'Back';

  @override
  String get onbMuscleShoulders => 'Shoulders';

  @override
  String get onbMuscleBiceps => 'Biceps';

  @override
  String get onbMuscleTriceps => 'Triceps';

  @override
  String get onbMuscleForearms => 'Forearms';

  @override
  String get onbMuscleAbs => 'Abs';

  @override
  String get onbMuscleQuads => 'Quads';

  @override
  String get onbMuscleHamstrings => 'Hamstrings';

  @override
  String get onbMuscleGlutes => 'Glutes';

  @override
  String get onbMuscleCalves => 'Calves';

  @override
  String get onbMuscleTraps => 'Traps';

  @override
  String get onbLocationTitle => 'Where do you train?';

  @override
  String get onbLocationSubtitle =>
      'So we only pick exercises you can actually do.';

  @override
  String get onbLocFullGym => 'Full gym';

  @override
  String get onbLocFullGymSub => 'Machines, cables, barbells, dumbbells';

  @override
  String get onbLocLimitedGym => 'Limited gym';

  @override
  String get onbLocLimitedGymSub => 'Basic equipment, few machines';

  @override
  String get onbLocHome => 'Home';

  @override
  String get onbLocHomeSub => 'Bodyweight, dumbbells or bands';

  @override
  String get onbInjuriesTitle => 'Injuries & health conditions';

  @override
  String get onbInjuriesSubtitle => 'The plan will avoid what could hurt you.';

  @override
  String get onbInjNoneLabel => 'No injuries or conditions';

  @override
  String get onbInjGroupJoints => 'Injuries / pain';

  @override
  String get onbInjGroupHealth => 'Health conditions';

  @override
  String get onbInjShoulder => 'Shoulder';

  @override
  String get onbInjKnee => 'Knee';

  @override
  String get onbInjLowerBack => 'Lower back';

  @override
  String get onbInjElbow => 'Elbow';

  @override
  String get onbInjWrist => 'Wrist';

  @override
  String get onbInjNeck => 'Neck';

  @override
  String get onbInjHip => 'Hip';

  @override
  String get onbInjAnkle => 'Ankle';

  @override
  String get onbInjHypertension => 'High blood pressure';

  @override
  String get onbInjDiabetes => 'Diabetes';

  @override
  String get onbInjHeart => 'Heart condition';

  @override
  String get onbInjAsthma => 'Asthma';

  @override
  String get onbInjHernia => 'Hernia';

  @override
  String get onbInjuriesNote =>
      'Anything else? (e.g. left shoulder hurts on overhead press)';

  @override
  String get onbInjuriesDoctor =>
      'With a heart condition or uncontrolled blood pressure, check with your doctor before intense training.';

  @override
  String get onbJobTitle => 'What\'s your job like?';

  @override
  String get onbJobSubtitle =>
      'Daily activity changes how many calories you burn.';

  @override
  String get onbJobDesk => 'Desk job';

  @override
  String get onbJobDeskSub => 'Sitting most of the day';

  @override
  String get onbJobMobile => 'On my feet';

  @override
  String get onbJobMobileSub => 'Walking and standing a lot';

  @override
  String get onbJobPhysical => 'Physical labor';

  @override
  String get onbJobPhysicalSub => 'Carrying, lifting, hard work';

  @override
  String get onbJobNone => 'Not working / student';

  @override
  String get onbJobNoneSub => 'Flexible daily schedule';

  @override
  String get onbJobHours => 'Working hours (optional)';

  @override
  String get onbJobFrom => 'From';

  @override
  String get onbJobTo => 'To';

  @override
  String get onbClear => 'Clear';

  @override
  String get onbSleepTitle => 'Your usual sleep';

  @override
  String get onbSleepSubtitle =>
      'Sleep is half the gains – we schedule around it.';

  @override
  String get onbSleepTime => 'Bedtime';

  @override
  String get onbWakeTime => 'Wake-up time';

  @override
  String onbSleepDuration(String hours) {
    return '≈ $hours h of sleep';
  }

  @override
  String get onbSleepShort =>
      'Less than 7 hours – try to sleep more for better recovery.';

  @override
  String get onbTrainTimeTitle => 'When do you usually train?';

  @override
  String get onbTrainTimeSubtitle =>
      'We\'ll remind you and time your meals around it.';

  @override
  String get onbTimeMorning => 'Morning';

  @override
  String get onbTimeAfterWork => 'After work';

  @override
  String get onbTimeNight => 'Night';

  @override
  String get onbExactTime => 'Exact time';

  @override
  String get onbCardioTitle => 'Cardio';

  @override
  String get onbCardioSubtitle => 'What do you do and how often?';

  @override
  String get onbCardioNone => 'No cardio';

  @override
  String get onbCardioWalking => 'Walking';

  @override
  String get onbCardioRunning => 'Running';

  @override
  String get onbCardioCycling => 'Cycling';

  @override
  String get onbCardioElliptical => 'Elliptical';

  @override
  String get onbCardioSwimming => 'Swimming';

  @override
  String get onbCardioHiit => 'HIIT';

  @override
  String get onbCardioStairs => 'Stair climber';

  @override
  String get onbCardioJumpRope => 'Jump rope';

  @override
  String get onbCardioFootball => 'Football';

  @override
  String get onbCardioPerWeek => 'Times per week';

  @override
  String get onbMealsTitle => 'Meals per day';

  @override
  String get onbMealsSubtitle =>
      'And their usual times – tap a time to change it.';

  @override
  String onbMealN(String n) {
    return 'Meal $n';
  }

  @override
  String get onbMealsReset => 'Suggest times';

  @override
  String get onbFoodsTitle => 'Food preferences';

  @override
  String get onbFoodsSubtitle =>
      'The meal plan will use what you like and skip what you don\'t.';

  @override
  String get onbFoodsLiked => 'Foods you like';

  @override
  String get onbFoodsDisliked => 'Foods you don\'t like';

  @override
  String get onbAllergies => 'Allergies';

  @override
  String get onbFoodsOther => 'Other (separate with commas)';

  @override
  String get onbFoodFul => 'Ful';

  @override
  String get onbFoodEggs => 'Eggs';

  @override
  String get onbFoodChicken => 'Chicken';

  @override
  String get onbFoodTuna => 'Tuna';

  @override
  String get onbFoodRice => 'Rice';

  @override
  String get onbFoodBaladiBread => 'Baladi bread';

  @override
  String get onbFoodYogurt => 'Yogurt';

  @override
  String get onbFoodCottageCheese => 'Cottage cheese (areesh)';

  @override
  String get onbFoodWhiteCheese => 'White cheese';

  @override
  String get onbFoodKoshari => 'Koshari';

  @override
  String get onbFoodMincedBeef => 'Minced beef';

  @override
  String get onbFoodFish => 'Fish';

  @override
  String get onbFoodLentils => 'Lentils';

  @override
  String get onbFoodTaameya => 'Taameya';

  @override
  String get onbFoodOats => 'Oats';

  @override
  String get onbFoodPasta => 'Pasta';

  @override
  String get onbFoodPotatoes => 'Potatoes';

  @override
  String get onbFoodSweetPotato => 'Sweet potato';

  @override
  String get onbFoodMilk => 'Milk';

  @override
  String get onbFoodPeanutButter => 'Peanut butter';

  @override
  String get onbFoodBananas => 'Bananas';

  @override
  String get onbFoodDates => 'Dates';

  @override
  String get onbFoodLiver => 'Liver';

  @override
  String get onbFoodMolokhia => 'Molokhia';

  @override
  String get onbAllergyLactose => 'Lactose';

  @override
  String get onbAllergyGluten => 'Gluten';

  @override
  String get onbAllergyNuts => 'Nuts';

  @override
  String get onbAllergyPeanuts => 'Peanuts';

  @override
  String get onbAllergyEggs => 'Eggs';

  @override
  String get onbAllergySeafood => 'Seafood';

  @override
  String get onbBudgetTitle => 'Monthly food budget';

  @override
  String get onbBudgetSubtitle =>
      'In Egyptian pounds – the meal plan will respect it.';

  @override
  String get onbBudgetLow => 'Low';

  @override
  String get onbBudgetLowSub => 'Basics: eggs, ful, rice, chicken, areesh';

  @override
  String get onbBudgetMedium => 'Medium';

  @override
  String get onbBudgetMediumSub => 'Adds meat, fish, oats and some extras';

  @override
  String get onbBudgetOpen => 'Open';

  @override
  String get onbBudgetOpenSub => 'Whatever fits the plan best';

  @override
  String get onbBudgetCustom => 'A specific amount';

  @override
  String get onbBudgetCustomSub => 'Enter it in EGP';

  @override
  String get onbBudgetAmount => 'Amount per month';

  @override
  String get onbEgp => 'EGP';

  @override
  String get onbSuppTitle => 'Current supplements';

  @override
  String get onbSuppSubtitle =>
      'Tap to add, then set the dose. Protein and calories count toward your day.';

  @override
  String get onbSuppEmpty => 'No supplements – totally fine.';

  @override
  String get onbSuppWhey => 'Whey protein';

  @override
  String get onbSuppCreatine => 'Creatine';

  @override
  String get onbSuppMassGainer => 'Mass gainer';

  @override
  String get onbSuppCasein => 'Casein';

  @override
  String get onbSuppMultivitamin => 'Multivitamin';

  @override
  String get onbSuppOmega3 => 'Omega-3';

  @override
  String get onbSuppVitaminD => 'Vitamin D';

  @override
  String get onbSuppZma => 'ZMA';

  @override
  String get onbSuppBcaa => 'BCAA';

  @override
  String get onbSuppPreWorkout => 'Pre-workout';

  @override
  String get onbSuppCaffeine => 'Caffeine';

  @override
  String get onbSuppOther => 'Other';

  @override
  String get onbSuppName => 'Name';

  @override
  String get onbSuppDose => 'Dose';

  @override
  String get onbSuppTiming => 'When? (optional)';

  @override
  String get onbSuppPerServing => 'Per serving';

  @override
  String get onbSuppProtein => 'Protein (g)';

  @override
  String get onbSuppCalories => 'Calories';

  @override
  String get onbSuppCarbs => 'Carbs (g)';

  @override
  String get onbSuppFat => 'Fat (g)';

  @override
  String get onbSuppAddMacros => 'Counts toward calories?';

  @override
  String get onbSuppRemove => 'Remove';

  @override
  String get onbDoseScoop => '1 scoop (30 g)';

  @override
  String get onbDoseScoopPlain => '1 scoop';

  @override
  String get onbDoseGainer => '1 serving (100 g)';

  @override
  String onbDoseGrams(String g) {
    return '$g g';
  }

  @override
  String get onbDoseTablet => '1 tablet';

  @override
  String get onbDoseCapsule => '1 capsule';

  @override
  String get onbDoseServing => '1 serving';

  @override
  String onbDoseMg(String mg) {
    return '$mg mg';
  }

  @override
  String onbSuppMacrosValue(String protein, String calories) {
    return '$protein g protein · $calories kcal';
  }

  @override
  String get onbWaterTitle => 'Daily water goal';

  @override
  String get onbWaterSubtitle =>
      'Suggested from your weight – adjust if you want.';

  @override
  String onbWaterSuggested(String ml) {
    return 'Suggested: $ml ml';
  }

  @override
  String onbWaterLiters(String liters) {
    return '≈ $liters liters';
  }

  @override
  String get onbWaterUseSuggestion => 'Use suggestion';

  @override
  String onbWaterGlasses(String glasses) {
    return 'About $glasses glasses of 250 ml';
  }

  @override
  String get onbHealthTitle => 'Connect your smart ring';

  @override
  String get onbHealthSubtitle =>
      'Through Health Connect we read sleep, heart rate, HRV and steps to calculate a daily recovery score.';

  @override
  String get onbHealthConnect => 'Connect Health Connect';

  @override
  String get onbHealthConnected => 'Health Connect is on';

  @override
  String get onbHealthConnectedSub =>
      'We\'ll sync when you open the app and every few hours.';

  @override
  String get onbHealthDisconnect => 'Turn off';

  @override
  String get onbHealthNote =>
      'If your ring\'s app doesn\'t write to Health Connect, you can log sleep manually – nothing breaks. You can check the last synced data in Settings.';

  @override
  String get onbHealthItemSleep => 'Sleep & stages';

  @override
  String get onbHealthItemHeart => 'Heart rate, resting HR & HRV';

  @override
  String get onbHealthItemSteps => 'Steps & active calories';

  @override
  String get onbKeyTitle => 'Claude API key';

  @override
  String get onbKeySubtitle =>
      'Powers the AI coach, plans and food-photo analysis. Everything else works without it – you can add it later from Settings.';

  @override
  String get onbKeyField => 'API key (sk-ant-…)';

  @override
  String get onbKeyWhere =>
      'Get one from console.anthropic.com → API Keys. It\'s stored encrypted on this device only.';

  @override
  String get onbKeyTest => 'Test key';

  @override
  String get onbKeySave => 'Save key';

  @override
  String get onbKeyValid => 'The key works';

  @override
  String onbKeyInvalid(String error) {
    return 'The key didn\'t work: $error';
  }

  @override
  String get onbKeySaved => 'Key saved securely on this device';

  @override
  String get onbKeyReplace => 'Replace key';

  @override
  String get onbKeyEmpty => 'Paste the key first';

  @override
  String get onbSummaryTitle => 'Review your answers';

  @override
  String get onbSummarySubtitle =>
      'Tap any answer to change it, then build your plan.';

  @override
  String get onbSumLanguage => 'Language';

  @override
  String get onbSumBody => 'Body';

  @override
  String get onbSumBodyFat => 'Body fat';

  @override
  String get onbSumMeasurements => 'Measurements';

  @override
  String get onbSumGoal => 'Goal';

  @override
  String get onbSumLevel => 'Level';

  @override
  String get onbSumDays => 'Training days';

  @override
  String get onbSumSession => 'Session length';

  @override
  String get onbSumSplit => 'Split';

  @override
  String get onbSumFocus => 'Focus muscles';

  @override
  String get onbSumLocation => 'Where';

  @override
  String get onbSumInjuries => 'Injuries & health';

  @override
  String get onbSumJob => 'Job';

  @override
  String get onbSumSleep => 'Sleep';

  @override
  String get onbSumTrainingTime => 'Training time';

  @override
  String get onbSumCardio => 'Cardio';

  @override
  String get onbSumMeals => 'Meals';

  @override
  String get onbSumFoods => 'Food preferences';

  @override
  String get onbSumBudget => 'Food budget';

  @override
  String get onbSumSupplements => 'Supplements';

  @override
  String get onbSumWater => 'Water goal';

  @override
  String get onbSumHealth => 'Health Connect';

  @override
  String get onbSumApiKey => 'Claude API key';

  @override
  String onbYearsValue(String age) {
    return '$age y';
  }

  @override
  String onbPerWeekValue(String n) {
    return '$n×/week';
  }

  @override
  String onbWeeksValue(String weeks) {
    return '$weeks weeks';
  }

  @override
  String onbLikesValue(String list) {
    return 'Likes: $list';
  }

  @override
  String onbDislikesValue(String list) {
    return 'Dislikes: $list';
  }

  @override
  String onbAllergiesValue(String list) {
    return 'Allergies: $list';
  }

  @override
  String onbBodyFatShapeValue(String pct) {
    return '≈ $pct% (from body shape)';
  }

  @override
  String get onbConnected => 'Connected';

  @override
  String get onbNotConnected => 'Not connected';

  @override
  String get onbKeySet => 'Added';

  @override
  String get onbKeyNotSet => 'Not added – add later';

  @override
  String get onbBuildingTitle => 'Building your plan';

  @override
  String get onbBuildReadyTitle => 'Your plan is ready';

  @override
  String get onbBuildHint =>
      'This can take a minute or two – the AI is thinking it through.';

  @override
  String get onbBuildTargets => 'Calories & macros';

  @override
  String get onbBuildWorkout => 'Workout plan';

  @override
  String get onbBuildMeals => 'Meal plan';

  @override
  String get onbBuildWorkoutLater =>
      'You can generate it later from the Workout tab.';

  @override
  String get onbBuildMealsLater =>
      'You can generate it later from the Food tab.';

  @override
  String get onbBuildNoKey =>
      'AI plans need a Claude API key. Your calories and macros are ready; add the key later from Settings and generate the plans from the Workout and Food tabs.';

  @override
  String get onbBuildOffline =>
      'No internet right now. Your calories and macros are ready; generate the AI plans from the Workout and Food tabs when you\'re back online.';

  @override
  String get onbDailyTargets => 'Your daily targets';

  @override
  String get onbTdee => 'Maintenance';

  @override
  String get onbTrainingDayCarbs => 'Training-day carbs';

  @override
  String get onbRestDayCarbs => 'Rest-day carbs';

  @override
  String get onbReviewPlan => 'Review my workout plan';

  @override
  String get onbSkipReview => 'Skip review for now';

  @override
  String get onbStartApp => 'Let\'s go';

  @override
  String get onbGenericError => 'Couldn\'t do it right now.';

  @override
  String get onbStatusWaiting => 'Waiting…';

  @override
  String get onbStatusWorking => 'Working on it…';

  @override
  String get onbStatusDone => 'Ready';

  @override
  String get onbStatusFailed => 'Not now';

  @override
  String get onbProfileTitle => 'My profile';

  @override
  String get onbProfileSubtitle =>
      'Tap any answer to change it. Targets update automatically.';

  @override
  String get onbProfileTargets => 'Current targets';

  @override
  String get onbSavedTargets => 'Saved – targets updated';

  @override
  String get onbSaved => 'Saved';

  @override
  String get onbRegenTitle => 'Update your plans?';

  @override
  String get onbRegenBody =>
      'Your answers changed. Regenerate with AI so your plans match?';

  @override
  String get onbRegenWorkout => 'Workout plan';

  @override
  String get onbRegenMeals => 'Meal plan';

  @override
  String get onbRegenNow => 'Regenerate';

  @override
  String get onbRegenSkip => 'Not now';

  @override
  String get onbRegenRunning => 'Regenerating your plans…';

  @override
  String get onbRegenMealDone => 'Your new meal plan is ready.';

  @override
  String get onbRegenWorkoutDone =>
      'Your new workout plan is ready for review.';

  @override
  String get onbRegenNoKey =>
      'Add your Claude API key in Settings to regenerate plans with AI.';

  @override
  String get onbRegenOffline =>
      'No internet right now – try again when you\'re online.';

  @override
  String get onbRegenResultTitle => 'Plan update';

  @override
  String get onbPlanActivated => 'Plan activated';

  @override
  String get onbErrSex => 'Pick male or female';

  @override
  String get onbErrAge => 'Age must be between 12 and 90';

  @override
  String get onbErrHeight => 'Height must be between 120 and 230 cm';

  @override
  String get onbErrWeight => 'Weight must be between 30 and 300 kg';

  @override
  String get onbErrBodyFatChoice => 'Choose one of the options';

  @override
  String get onbErrBodyFat => 'Body fat must be between 3% and 60%';

  @override
  String get onbErrMeasurement => 'Measurements must be between 10 and 250 cm';

  @override
  String get onbErrGoal => 'Pick a goal';

  @override
  String get onbErrTargetWeight =>
      'Target weight must be between 30 and 300 kg';

  @override
  String get onbErrWeeks => 'Weeks must be between 1 and 104';

  @override
  String get onbErrLevel => 'Pick your level and how long you\'ve trained';

  @override
  String get onbErrDaysCount => 'Pick how many days per week';

  @override
  String onbErrDaysMismatch(String count) {
    return 'Pick exactly $count days';
  }

  @override
  String get onbErrChoose => 'Pick one option to continue';

  @override
  String get onbErrSleep => 'Set your bedtime and wake-up time';

  @override
  String get onbErrCardioPerWeek => 'How many times per week?';

  @override
  String get onbErrMealTimes => 'Set a time for every meal';

  @override
  String get onbErrBudget => 'Enter an amount between 100 and 1,000,000 EGP';

  @override
  String get onbErrSuppName => 'Every supplement needs a name';

  @override
  String get onbErrWater => 'Water goal must be between 1,000 and 8,000 ml';

  @override
  String get todayCoachTitle => 'Coach';

  @override
  String get todayCoachEmpty =>
      'Your coach\'s morning message will appear here.';

  @override
  String get todayRecoveryTitle => 'Recovery';

  @override
  String get todayRecoveryEmpty =>
      'Log your sleep or connect Health Connect to get a recovery score.';

  @override
  String get todayRecoveryHigh => 'Well recovered — push hard today.';

  @override
  String get todayRecoveryModerate =>
      'Moderate recovery — train normally, listen to your body.';

  @override
  String get todayRecoveryLow =>
      'Low recovery — consider a lighter session today.';

  @override
  String get todayWorkoutTitle => 'Today\'s workout';

  @override
  String get todayNoPlan =>
      'No active plan yet. Build one from the Workout tab.';

  @override
  String get todayRestDay =>
      'Rest day. Recover, eat well and hit your water goal.';

  @override
  String todayExerciseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count exercises',
      one: '1 exercise',
    );
    return '$_temp0';
  }

  @override
  String get todayStartWorkout => 'Start today\'s workout';

  @override
  String get todayResumeWorkout => 'Resume workout';

  @override
  String get todayWorkoutDone => 'Done for today 💪';

  @override
  String get todayKcalLeft => 'kcal left';

  @override
  String get todayKcalOver => 'kcal over';

  @override
  String get todayAddCup => '+ Cup of water';

  @override
  String get todaySupplementsTitle => 'Supplements';

  @override
  String get todaySupplementsEmpty => 'No supplements added.';

  @override
  String get todayWeightTitle => 'Body weight';

  @override
  String get todayWeightEmpty => 'Tap to log today\'s weight.';

  @override
  String todayWeightAvg(String avg) {
    return '7-day avg $avg';
  }
}
