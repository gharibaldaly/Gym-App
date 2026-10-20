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
  String get exLibraryTitle => 'Exercise library';

  @override
  String get exPickTitle => 'Choose an exercise';

  @override
  String get exSearchHint => 'Search in Arabic or English';

  @override
  String get exAllMuscles => 'All muscles';

  @override
  String get exAllEquipment => 'All equipment';

  @override
  String get exMuscleFilter => 'Muscle';

  @override
  String get exEquipmentFilter => 'Equipment';

  @override
  String get exFavoritesOnly => 'Favorites';

  @override
  String get exMyCustom => 'My exercises';

  @override
  String get exClearFilters => 'Clear filters';

  @override
  String exResultsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count exercises',
      one: '1 exercise',
    );
    return '$_temp0';
  }

  @override
  String get exNoResults => 'No exercises match your search.';

  @override
  String get exAddWithAi => 'Add with AI';

  @override
  String get exFavoriteAdd => 'Add to favorites';

  @override
  String get exFavoriteRemove => 'Remove from favorites';

  @override
  String get exCustomBadge => 'Custom';

  @override
  String get exBodyFront => 'Front';

  @override
  String get exBodyBack => 'Back';

  @override
  String get exPrimaryMuscles => 'Primary muscles';

  @override
  String get exSecondaryMuscles => 'Secondary muscles';

  @override
  String get exMusclesWorked => 'Muscles worked';

  @override
  String get exHowTo => 'How to do it';

  @override
  String get exCommonMistakes => 'Common mistakes';

  @override
  String get exNoInstructions => 'No instructions yet.';

  @override
  String get exImageOffline =>
      'Image not downloaded yet. Open it once with internet to keep it offline.';

  @override
  String exStepOf(int current, int total) {
    return '$current/$total';
  }

  @override
  String get exYourHistory => 'Your history';

  @override
  String get exNoHistory => 'You haven\'t logged this exercise yet.';

  @override
  String get exLastPerformance => 'Last time';

  @override
  String get exPersonalRecords => 'Personal records';

  @override
  String get exHeaviest => 'Heaviest weight';

  @override
  String get exBestE1rm => 'Best est. 1RM';

  @override
  String get exRepRecords => 'Most reps at each weight';

  @override
  String exSetLine(String weight, int reps) {
    return '$weight kg × $reps';
  }

  @override
  String exKgValue(String value) {
    return '$value kg';
  }

  @override
  String exSessionVolume(String volume) {
    return 'Volume: $volume kg';
  }

  @override
  String get exProgressChart => 'Progress';

  @override
  String get exChartE1rm => 'Est. 1RM';

  @override
  String get exChartTopWeight => 'Top weight';

  @override
  String get exChartNeedMore =>
      'Log this exercise in at least 2 sessions to see your progress chart.';

  @override
  String get exEdit => 'Edit';

  @override
  String get exDelete => 'Delete exercise';

  @override
  String get exDeleteConfirm => 'Delete this custom exercise?';

  @override
  String get exDeleteInUse =>
      'Can\'t delete: this exercise is used in your logs or plan.';

  @override
  String get exDeleted => 'Exercise deleted';

  @override
  String get exNotFound => 'Exercise not found';

  @override
  String get exAddTitle => 'Add exercise';

  @override
  String get exEditTitle => 'Edit exercise';

  @override
  String get exReviewTitle => 'Review & edit';

  @override
  String get exDescribeTitle => 'Describe the exercise';

  @override
  String get exDescribeHint =>
      'In your own words, e.g. \"machine where I sit and push two handles forward for chest\"';

  @override
  String get exVoiceStart => 'Speak';

  @override
  String get exVoiceListening => 'Listening…';

  @override
  String get exVoiceUnavailable =>
      'Voice input isn\'t available on this device.';

  @override
  String get exPhotoOptional => 'Photo of the machine (optional)';

  @override
  String get exPhotoCamera => 'Camera';

  @override
  String get exPhotoGallery => 'Gallery';

  @override
  String get exPhotoRemove => 'Remove photo';

  @override
  String get exPhotoError => 'Couldn\'t load the photo.';

  @override
  String get exContinue => 'Continue';

  @override
  String get exCreateWithAi => 'Create with AI';

  @override
  String get exFillManually => 'Fill in manually';

  @override
  String get exAiOffManual =>
      'AI is off — you can still add the exercise manually.';

  @override
  String get exDescribeFirst => 'Describe the exercise or add a photo first.';

  @override
  String get exDidYouMean => 'Did you mean…?';

  @override
  String get exDidYouMeanBody =>
      'These exercises are already in the library. Use one instead of creating a duplicate.';

  @override
  String get exUseExisting => 'Use';

  @override
  String get exCreateNewAnyway => 'No, create a new one';

  @override
  String get exAiWorking => 'Claude is building the exercise…';

  @override
  String get exAiSimilarFound =>
      'This looks like an exercise you already have:';

  @override
  String get exNameEn => 'Name (English)';

  @override
  String get exNameAr => 'Name (Arabic)';

  @override
  String get exFieldEquipment => 'Equipment';

  @override
  String get exFieldForce => 'Force';

  @override
  String get exFieldMechanic => 'Compound / isolation';

  @override
  String get exFieldCategory => 'Category';

  @override
  String get exNone => '—';

  @override
  String get exStepsEn => 'Steps (English)';

  @override
  String get exStepsAr => 'Steps (Arabic)';

  @override
  String get exMistakesEn => 'Common mistakes (English)';

  @override
  String get exMistakesAr => 'Common mistakes (Arabic)';

  @override
  String get exOnePerLine => 'One per line';

  @override
  String get exNeedNameAndMuscle =>
      'Add a name and at least one primary muscle.';

  @override
  String get exSave => 'Save exercise';

  @override
  String get exSaved => 'Exercise saved';

  @override
  String get exOfflineTitle => 'Offline exercise images';

  @override
  String exOfflineBody(int mb) {
    return 'Download the step images of all exercises so they show without internet (about $mb MB). Images you open are also kept automatically.';
  }

  @override
  String get exOfflineWifiTip => 'Tip: use Wi-Fi — the pack is large.';

  @override
  String get exOfflineStart => 'Download all';

  @override
  String get exOfflineCancel => 'Stop';

  @override
  String get exOfflineClear => 'Delete downloaded images';

  @override
  String get exOfflineClearConfirm =>
      'Exercise images will need internet again until re-downloaded.';

  @override
  String get exOfflineCleared => 'Downloaded images deleted';

  @override
  String exOfflineProgress(int done, int total) {
    return '$done / $total';
  }

  @override
  String exOfflineCached(int cached, int total) {
    return '$cached of $total images saved';
  }

  @override
  String exOfflineFailed(int count) {
    return '$count failed — try again later';
  }

  @override
  String get exOfflineDone => 'All exercise images are available offline';

  @override
  String get exOfflineChecking => 'Checking saved images…';

  @override
  String get exOfflineNeedsInternet => 'Connect to the internet to download.';

  @override
  String get nutTitle => 'Nutrition';

  @override
  String get nutTabToday => 'Today';

  @override
  String get nutTabPlan => 'Meal plan';

  @override
  String get nutTabShopping => 'Shopping';

  @override
  String get nutTodayTitle => 'Today\'s calories';

  @override
  String get nutTrainingDay => 'Training day';

  @override
  String get nutRestDay => 'Rest day';

  @override
  String get nutNoTargets =>
      'No calorie targets yet. Finish your profile to get your daily numbers.';

  @override
  String get nutKcalLeft => 'kcal left';

  @override
  String get nutKcalOver => 'kcal over';

  @override
  String nutRemainingMacros(String protein, String carbs, String fat) {
    return 'Left: protein $protein g · carbs $carbs g · fat $fat g';
  }

  @override
  String nutFromSupplements(String protein, String kcal) {
    return 'Incl. supplements: $protein g protein · $kcal kcal';
  }

  @override
  String nutMacroLine(String kcal, String protein, String carbs, String fat) {
    return '$kcal kcal · P $protein · C $carbs · F $fat';
  }

  @override
  String get nutProteinShort => 'P';

  @override
  String get nutCarbsShort => 'C';

  @override
  String get nutFatShort => 'F';

  @override
  String nutPendingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count meals waiting for AI analysis',
      one: '1 meal waiting for AI analysis',
    );
    return '$_temp0';
  }

  @override
  String get nutPendingNoKey =>
      'Add your Claude API key and they will be analyzed automatically.';

  @override
  String get nutPendingOffline =>
      'They\'ll be analyzed when you\'re back online.';

  @override
  String get nutPendingWorking => 'Analyzing in the background…';

  @override
  String get nutMealsTitle => 'Meals: planned vs eaten';

  @override
  String get nutNoPlanToday =>
      'You don\'t have a meal plan yet. Create one to see your meals here.';

  @override
  String get nutOpenPlan => 'Open meal plan';

  @override
  String nutPlannedLine(String macros) {
    return 'Planned: $macros';
  }

  @override
  String nutEatenLine(String macros) {
    return 'Eaten: $macros';
  }

  @override
  String get nutAteAsPlanned => 'Ate it as planned';

  @override
  String get nutAteHalf => 'Ate half of it';

  @override
  String get nutAteDifferent => 'Ate something different';

  @override
  String nutLoggedMeal(String name) {
    return 'Logged: $name';
  }

  @override
  String get nutUndo => 'Undo';

  @override
  String get nutLoggedTitle => 'Logged today';

  @override
  String get nutNothingLogged => 'Nothing logged yet. Tap + to log a meal.';

  @override
  String get nutWaitingForAi => 'Waiting for AI analysis';

  @override
  String nutConfidence(int percent) {
    return 'AI confidence $percent%';
  }

  @override
  String get nutSavedToMyFoods => 'Saved to My foods';

  @override
  String get nutAnalyzeNow => 'Analyze now';

  @override
  String get nutDeleted => 'Meal deleted';

  @override
  String get nutSaved => 'Saved';

  @override
  String get nutSupplementsTitle => 'Supplements today';

  @override
  String get nutNoSupplementsToday =>
      'No supplements ticked today. Mark them in the Today tab and their protein/calories count here.';

  @override
  String nutSupplementMacros(String protein, String kcal) {
    return '$protein g protein · $kcal kcal';
  }

  @override
  String get nutNoMacros => 'no calories';

  @override
  String get nutLogFood => 'Log food';

  @override
  String get nutLogPhoto => 'Photo';

  @override
  String get nutLogPhotoHint => 'Snap your plate, the AI estimates it';

  @override
  String get nutLogText => 'Type or say it';

  @override
  String get nutLogTextHint => 'e.g. \"a medium koshary and two eggs\"';

  @override
  String get nutMyFoods => 'My foods';

  @override
  String get nutMyFoodsHint => 'One tap, no AI, works offline';

  @override
  String get nutLogManual => 'Manual';

  @override
  String get nutLogManualHint => 'Pick from Egyptian foods + grams';

  @override
  String get nutLogged => 'Meal logged';

  @override
  String get nutTakePhoto => 'Take a photo';

  @override
  String get nutFromGallery => 'Choose from gallery';

  @override
  String get nutPhotoError => 'Couldn\'t open the camera or gallery.';

  @override
  String get nutPhotoMealName => 'Meal photo';

  @override
  String get nutQueuedNoKey =>
      'Saved with the photo. Add your API key in Settings and it will be analyzed.';

  @override
  String get nutAnalyzingPhoto => 'Analyzing your plate…';

  @override
  String get nutAnalysisFailed => 'Couldn\'t analyze it';

  @override
  String get nutLogManually => 'Log manually';

  @override
  String get nutAnalyzeLater => 'Save & analyze later';

  @override
  String get nutReviewTitle => 'Review meal';

  @override
  String get nutEditMeal => 'Edit meal';

  @override
  String get nutReviewHint =>
      'Check the amounts — changing grams updates the macros.';

  @override
  String get nutMealName => 'Meal name';

  @override
  String get nutWhichMeal => 'Which meal?';

  @override
  String get nutOtherMeal => 'Snack / outside the plan';

  @override
  String nutMealNumber(int number) {
    return 'Meal $number';
  }

  @override
  String get nutItems => 'Items';

  @override
  String get nutAddFood => 'Add food';

  @override
  String get nutNoItemsDetected =>
      'The AI found no food. Add the items yourself.';

  @override
  String get nutNoItemsYet => 'No items yet. Add a food from the list.';

  @override
  String get nutItemName => 'Item name';

  @override
  String get nutGrams => 'Grams';

  @override
  String get nutTotal => 'Total';

  @override
  String get nutSaveToMyFoods => 'Save to My foods';

  @override
  String get nutSaveToMyFoodsHint =>
      'Log it again later with one tap, without AI';

  @override
  String get nutSaveMeal => 'Save meal';

  @override
  String get nutAddAtLeastOne => 'Add at least one item.';

  @override
  String get nutSearchFoods => 'Search foods (فول، rice…)';

  @override
  String get nutNoFoodsFound => 'No foods found';

  @override
  String nutPer100g(String macros) {
    return 'Per 100 g: $macros';
  }

  @override
  String get nutTextPrompt => 'What did you eat?';

  @override
  String get nutTextHintExample => 'a medium koshary plate and two eggs';

  @override
  String get nutSpeak => 'Speak';

  @override
  String get nutStopListening => 'Stop';

  @override
  String get nutListening => 'Listening…';

  @override
  String get nutTapToSpeak => 'Tap the mic and say what you ate';

  @override
  String get nutSpeechUnavailable =>
      'Voice input is not available on this device.';

  @override
  String get nutAnalyze => 'Analyze with AI';

  @override
  String get nutAnalyzing => 'Analyzing…';

  @override
  String get nutMyFoodsEmpty =>
      'Meals you log are saved here so you can log them again with one tap.';

  @override
  String get nutMyFoodsTapHint => 'Tap to log · hold for portion & options';

  @override
  String nutUsedTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Used $count times',
      one: 'Used once',
    );
    return '$_temp0';
  }

  @override
  String get nutMore => 'More';

  @override
  String get nutHalfPortion => 'Half portion';

  @override
  String get nutFullPortion => 'Full portion';

  @override
  String get nutOneAndHalfPortion => '1.5 portions';

  @override
  String get nutDoublePortion => 'Double portion';

  @override
  String get nutFavorite => 'Add to favorites';

  @override
  String get nutUnfavorite => 'Remove from favorites';

  @override
  String get nutNoPlan =>
      'No meal plan yet. The AI builds one with Egyptian food that fits your macros, budget and taste.';

  @override
  String get nutGeneratePlan => 'Build my meal plan';

  @override
  String get nutUseBasicPlan => 'Use a basic offline plan';

  @override
  String get nutGeneratingPlan =>
      'Building your meal plan… this can take a minute.';

  @override
  String get nutBuildingPlan => 'Building a basic plan…';

  @override
  String get nutPlanReady => 'Your new meal plan is ready';

  @override
  String get nutBasicPlanReady => 'Basic plan ready';

  @override
  String get nutPlanFallback =>
      'No AI right now, so we built a basic plan from Egyptian foods.';

  @override
  String get nutPlanFailed => 'Couldn\'t build the plan';

  @override
  String get nutTemplatePlanNote =>
      'Basic plan built offline from the built-in food table. Regenerate with AI for a personalized plan.';

  @override
  String get nutDayTotal => 'Day total';

  @override
  String nutTargetLine(String macros) {
    return 'Target: $macros';
  }

  @override
  String get nutNoMealsForDay => 'No meals for this day type in the plan.';

  @override
  String nutItemMacros(String kcal, String protein, String carbs, String fat) {
    return '$kcal kcal · P $protein · C $carbs · F $fat';
  }

  @override
  String get nutSwapMeal => 'Swap meal';

  @override
  String nutSwapTitle(String meal) {
    return 'Swap $meal';
  }

  @override
  String nutSwapSubtitle(String macros) {
    return 'Alternatives with about the same macros: $macros';
  }

  @override
  String get nutFindingAlternatives => 'Finding alternatives…';

  @override
  String get nutNoAlternatives => 'No alternatives found. Try again.';

  @override
  String get nutUseThis => 'Use this meal';

  @override
  String get nutMoreAlternatives => 'Other alternatives';

  @override
  String get nutMealSwapped => 'Meal swapped in your plan';

  @override
  String get nutRegenerate => 'Regenerate plan';

  @override
  String get nutRegenerateTitle => 'Build a new meal plan?';

  @override
  String get nutRegenerateBody =>
      'Your current plan (and any swaps) will be replaced. Your logged meals stay.';

  @override
  String get nutShoppingNoPlan =>
      'Create a meal plan first and your weekly shopping list will appear here.';

  @override
  String get nutShoppingTitle => 'Weekly shopping list';

  @override
  String nutShoppingSubtitle(int training, int rest) {
    return 'For $training training days and $rest rest days';
  }

  @override
  String nutShoppingShareTitle(String date) {
    return 'Shopping list – week of $date';
  }

  @override
  String get nutShare => 'Share';

  @override
  String get nutUncheckAll => 'Uncheck all';

  @override
  String get nutLiter => 'L';

  @override
  String get nutCatProtein => 'Meat, poultry & eggs';

  @override
  String get nutCatCarb => 'Bread, grains & legumes';

  @override
  String get nutCatDairy => 'Dairy';

  @override
  String get nutCatFat => 'Oils, nuts & spreads';

  @override
  String get nutCatFruit => 'Fruit';

  @override
  String get nutCatVeg => 'Vegetables';

  @override
  String get nutCatDish => 'Ready dishes';

  @override
  String get nutCatSupplement => 'Supplements';

  @override
  String get nutCatOther => 'Other';

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
  String get progTitle => 'Progress';

  @override
  String get progPeriodWeek => 'Week';

  @override
  String get progPeriodMonth => 'Month';

  @override
  String get progPeriod3Months => '3 months';

  @override
  String get progPeriodYear => 'Year';

  @override
  String get progPeriodAll => 'All';

  @override
  String get progLinkPrs => 'Records';

  @override
  String get progLinkPhotos => 'Photos';

  @override
  String get progLinkMeasurements => 'Measurements';

  @override
  String get progLinkWeight => 'Body weight';

  @override
  String get progExportPdf => 'Export PDF report';

  @override
  String get progCalendarTitle => 'Adherence calendar';

  @override
  String get progLegendCompleted => 'Completed';

  @override
  String get progLegendPartial => 'Partial';

  @override
  String get progLegendMissed => 'Missed';

  @override
  String get progLegendRest => 'Rest';

  @override
  String progAdherencePct(String pct) {
    return '$pct% adherence';
  }

  @override
  String get progAdherenceNone => 'No training days due yet this month';

  @override
  String progAdherenceCounts(String completed, String partial, String missed) {
    return '$completed completed · $partial partial · $missed missed';
  }

  @override
  String get progPrevMonth => 'Previous month';

  @override
  String get progNextMonth => 'Next month';

  @override
  String get progStatusInProgress => 'In progress';

  @override
  String get progStatusRestDay => 'Rest day';

  @override
  String get progStatusToday => 'Today – not trained yet';

  @override
  String get progStatusFuture => 'Upcoming';

  @override
  String get progStatusNone => 'Before you started tracking';

  @override
  String get progDayNothing => 'Nothing logged on this day.';

  @override
  String get progDayWorkout => 'Workout';

  @override
  String get progDayNutrition => 'Food';

  @override
  String get progDayWater => 'Water';

  @override
  String get progDaySleep => 'Sleep';

  @override
  String get progDayWeight => 'Weight';

  @override
  String get progDayRecovery => 'Recovery';

  @override
  String get progDayCardio => 'Cardio';

  @override
  String get progSetTypeWarmup => 'Warm-up';

  @override
  String get progSetTypeDrop => 'Drop set';

  @override
  String get progSetTypeFailure => 'To failure';

  @override
  String progVolumeValue(String value) {
    return 'Volume $value kg';
  }

  @override
  String progSetsCount(String count) {
    return 'Sets: $count';
  }

  @override
  String progPrsCount(String count) {
    return 'PRs: $count';
  }

  @override
  String get progPrBadge => 'PR';

  @override
  String progDurationMin(String minutes) {
    return '$minutes min';
  }

  @override
  String progMealsCount(String count) {
    return 'Meals: $count';
  }

  @override
  String get progUnknownExercise => 'Unknown exercise';

  @override
  String get progExerciseTitle => 'Exercise progress';

  @override
  String get progPickExercise => 'Pick an exercise';

  @override
  String get progSearchExercise => 'Search your exercises';

  @override
  String get progTopSet => 'Top set';

  @override
  String get progE1rm => 'Est. 1RM';

  @override
  String get progNoExerciseData =>
      'Log a workout and your strength progress shows up here.';

  @override
  String get progNoDataInPeriod => 'No data in this period.';

  @override
  String get progBest => 'Best';

  @override
  String get progChange => 'Change';

  @override
  String get progLatest => 'Latest';

  @override
  String progSessionsCount(String count) {
    return 'Sessions: $count';
  }

  @override
  String get progNoMatches => 'No matches';

  @override
  String get progVolumeTitle => 'Weekly volume per muscle';

  @override
  String progAvgPerWeek(String weeks) {
    return 'Weekly average over $weeks weeks (weight × reps)';
  }

  @override
  String get progEffectiveSets => 'Effective sets / week';

  @override
  String get progEffectiveSetsHint =>
      'Effective set = working set at RPE 7+ (or no RPE logged). Around 10–20 per muscle per week is a solid range for growth.';

  @override
  String get progWeeklyTotal => 'Total volume per week';

  @override
  String get progNoVolumeData => 'No working sets in this period yet.';

  @override
  String get progMuscleCol => 'Muscle';

  @override
  String get progVolumeCol => 'Volume/wk';

  @override
  String get progSetsCol => 'Eff. sets';

  @override
  String get progBodyTitle => 'Body weight';

  @override
  String get progDaily => 'Daily';

  @override
  String get progMovingAvg => '7-day average';

  @override
  String get progMeasurementsTitle => 'Measurements';

  @override
  String get progNoWeightData => 'No weight logged in this period.';

  @override
  String get progNoMeasurementData => 'No measurements in this period.';

  @override
  String get progLogWeight => 'Log weight';

  @override
  String get progLogMeasurements => 'Add measurements';

  @override
  String get progMeasureWaist => 'Waist';

  @override
  String get progMeasureChest => 'Chest';

  @override
  String get progMeasureArm => 'Arm';

  @override
  String get progMeasureThigh => 'Thigh';

  @override
  String get progMeasureNeck => 'Neck';

  @override
  String get progMeasureHips => 'Hips';

  @override
  String get progMeasureBodyFat => 'Body fat %';

  @override
  String get progNutritionTitle => 'Calories & macros vs target';

  @override
  String get progTarget => 'Target';

  @override
  String progAvgPerDay(String days) {
    return 'Daily average ($days days logged)';
  }

  @override
  String get progNoNutritionData => 'No meals logged in this period.';

  @override
  String progDaysOnTarget(String count, String total) {
    return 'Days within ±10% of your calorie target: $count/$total';
  }

  @override
  String get progSleepTitle => 'Sleep & recovery';

  @override
  String get progSleepHours => 'Sleep (h)';

  @override
  String get progRecoveryScore => 'Recovery score';

  @override
  String get progAvgSleep => 'Avg sleep';

  @override
  String get progAvgRecovery => 'Avg recovery';

  @override
  String get progNoSleepData =>
      'No sleep or recovery data in this period. Log sleep manually or connect Health Connect.';

  @override
  String get progPrsTitle => 'Personal records';

  @override
  String get progPrHeaviest => 'Heaviest';

  @override
  String get progPrBestE1rm => 'Best est. 1RM';

  @override
  String get progPrRepsAtWeight => 'Most reps at each weight';

  @override
  String get progNoPrs => 'No records yet – log a few workouts first.';

  @override
  String progSetsLogged(String count) {
    return '$count working sets';
  }

  @override
  String progLastTrained(String date) {
    return 'Last: $date';
  }

  @override
  String get progReportChoose => 'Export progress report';

  @override
  String get progReportThisWeek => 'This week';

  @override
  String get progReportLastWeek => 'Last week';

  @override
  String get progReportThisMonth => 'This month';

  @override
  String get progReportLastMonth => 'Last month';

  @override
  String get progReportGenerating => 'Preparing your report…';

  @override
  String get progReportFailed => 'Couldn\'t create the report';

  @override
  String get progReportShareSubject => 'IronMind progress report';

  @override
  String get progPdfWeeklyTitle => 'Weekly progress report';

  @override
  String get progPdfMonthlyTitle => 'Monthly progress report';

  @override
  String progPdfGenerated(String date) {
    return 'Generated $date';
  }

  @override
  String get progPdfSummary => 'Summary';

  @override
  String get progPdfSessionsDone => 'Sessions done';

  @override
  String get progPdfSessionsMissed => 'Missed days';

  @override
  String get progPdfAdherence => 'Adherence';

  @override
  String get progPdfVolume => 'Total volume';

  @override
  String get progPdfPrs => 'Personal records';

  @override
  String get progPdfAvgCalories => 'Avg calories';

  @override
  String get progPdfAvgProtein => 'Avg protein';

  @override
  String get progPdfWeightChange => 'Weight change';

  @override
  String get progPdfAvgSleep => 'Avg sleep';

  @override
  String get progPdfAvgRecovery => 'Avg recovery';

  @override
  String progPdfTarget(String value) {
    return 'target $value';
  }

  @override
  String get progPdfCoachSummary => 'Coach summary';

  @override
  String get progPdfNoCoachSummary =>
      'No weekly coach report in this period. You can ask the coach for one from the Coach tab.';

  @override
  String get progPdfSessionsTable => 'Sessions';

  @override
  String get progPdfDate => 'Date';

  @override
  String get progPdfName => 'Workout';

  @override
  String get progPdfStatus => 'Status';

  @override
  String get progPdfDuration => 'Duration';

  @override
  String get progPdfSets => 'Sets';

  @override
  String get progPdfExercise => 'Exercise';

  @override
  String get progPdfType => 'Record';

  @override
  String get progPdfSet => 'Set';

  @override
  String get progPdfTypeWeight => 'Heaviest';

  @override
  String get progPdfTypeReps => 'Reps';

  @override
  String get progPdfTypeE1rm => 'e1RM';

  @override
  String get progPdfBodyTable => 'Body metrics';

  @override
  String get progPdfMuscleChart => 'Volume per muscle (kg)';

  @override
  String get progPdfCaloriesChart => 'Daily calories vs target';

  @override
  String get progPdfWeightChart => 'Body weight (kg)';

  @override
  String get progPdfNone => 'Nothing logged in this period.';

  @override
  String progPdfPage(String page, String total) {
    return 'Page $page of $total';
  }

  @override
  String get progPdfEaten => 'Eaten';

  @override
  String progPdfFromTo(String from, String to) {
    return '$from to $to';
  }

  @override
  String get setProfile => 'Profile';

  @override
  String get setProfileSub => 'Edit your answers, goals and targets';

  @override
  String get setSectionAi => 'AI coach (Claude)';

  @override
  String get setSectionApp => 'App';

  @override
  String get setApiKey => 'Claude API key';

  @override
  String get setApiKeyHelp =>
      'Stored only on this phone in encrypted storage. Never included in backups.';

  @override
  String get setApiKeySaved => 'API key saved';

  @override
  String get setApiKeyTest => 'Test key';

  @override
  String get setApiKeyTesting => 'Testing…';

  @override
  String get setApiKeyValid => 'The key works';

  @override
  String get setApiKeyInvalid => 'The key didn\'t work';

  @override
  String get setApiKeyChange => 'Change';

  @override
  String get setApiKeyRemove => 'Remove';

  @override
  String get setApiKeyRemoveTitle => 'Remove API key?';

  @override
  String get setApiKeyRemoveBody =>
      'AI features will stop working until you add a key again.';

  @override
  String get setModels => 'AI models';

  @override
  String get setModelFast => 'Fast model (Haiku tier)';

  @override
  String get setModelFastHelp =>
      'Voice/text parsing, exercise alternatives, memory';

  @override
  String get setModelBalanced => 'Balanced model (Sonnet tier)';

  @override
  String get setModelBalancedHelp =>
      'Chat, workout summaries, food photos, morning message';

  @override
  String get setModelSmart => 'Smartest model (Opus tier)';

  @override
  String get setModelSmartHelp => 'First plan, meal plan, weekly report';

  @override
  String get setModelsSaved => 'Models saved';

  @override
  String get setModelsReset => 'Reset to defaults';

  @override
  String get setModelsResetDone => 'Default models restored';

  @override
  String get setRefusalFallback => 'Server-side fallback on refusals';

  @override
  String get setRefusalFallbackSub =>
      'If a model refuses a request, Claude retries it on a fallback model automatically.';

  @override
  String get setCost => 'AI costs';

  @override
  String get setCostToday => 'Today';

  @override
  String get setCostMonth => 'This month';

  @override
  String get setCostAllTime => 'All time';

  @override
  String get setCostByFeature => 'By feature';

  @override
  String get setCostEmpty => 'No AI requests in this period';

  @override
  String setCostTokens(String tokens) {
    return '$tokens tokens';
  }

  @override
  String setCostFeatureDetail(
    int requests,
    String input,
    String output,
    String cache,
  ) {
    return '$requests requests · in $input · out $output · cache $cache';
  }

  @override
  String get setCostNote =>
      'Estimated from public prices. No spending limit is applied.';

  @override
  String get setFeatVoiceParse => 'Voice → set';

  @override
  String get setFeatExerciseAlternatives => 'Exercise alternatives';

  @override
  String get setFeatMemoryExtract => 'Coach memory';

  @override
  String get setFeatFoodText => 'Food from text';

  @override
  String get setFeatExerciseCreate => 'Custom exercises';

  @override
  String get setFeatChat => 'Coach chat';

  @override
  String get setFeatWorkoutSummary => 'Workout summaries';

  @override
  String get setFeatFoodPhoto => 'Food photos';

  @override
  String get setFeatMorningMessage => 'Morning message';

  @override
  String get setFeatPlateau => 'Plateau alerts';

  @override
  String get setFeatMealSwap => 'Meal swaps';

  @override
  String get setFeatGroceryList => 'Grocery list';

  @override
  String get setFeatInitialPlan => 'Workout plan';

  @override
  String get setFeatMealPlan => 'Meal plan';

  @override
  String get setFeatWeeklyReport => 'Weekly report';

  @override
  String get setFeatKeyTest => 'Key test';

  @override
  String get setNotifications => 'Notifications';

  @override
  String get setNotificationsSub =>
      'Workout, meals, water, supplements, weight, coach';

  @override
  String get setHealthConnect => 'Health Connect';

  @override
  String get setHealthConnectSub =>
      'Smart ring / watch: sleep, heart rate, steps';

  @override
  String get setCoachMemory => 'Coach memory';

  @override
  String get setCoachMemorySub => 'What the coach remembers about you';

  @override
  String get setBackup => 'Backup & restore';

  @override
  String get setBackupSub => 'Export everything to one file or restore it';

  @override
  String get setBackupBanner => 'You haven\'t backed up in over 2 weeks.';

  @override
  String get setBackupNow => 'Back up';

  @override
  String get setLock => 'App lock';

  @override
  String get setLockSub => 'Fingerprint / face / PIN when opening the app';

  @override
  String get setLockTimeout => 'Lock after leaving the app';

  @override
  String get setLockImmediately => 'Immediately';

  @override
  String setLockSeconds(int seconds) {
    return '$seconds sec';
  }

  @override
  String setLockMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get setLockUnsupported =>
      'No fingerprint, face or screen lock is set up on this phone.';

  @override
  String get setLockFailed => 'Authentication failed. Try again.';

  @override
  String get setLockEnableReason => 'Confirm to turn on the app lock';

  @override
  String get setLockDisableReason => 'Confirm to turn off the app lock';

  @override
  String get setLockReason => 'Unlock IronMind';

  @override
  String get setLockLocked => 'IronMind is locked';

  @override
  String get setLockUnlock => 'Unlock';

  @override
  String get setAbout => 'About';

  @override
  String get setAboutSub => 'Version, data sources and licenses';

  @override
  String setAboutVersion(String version) {
    return 'Version $version';
  }

  @override
  String get setAboutTagline =>
      'Your personal gym coach — workouts, nutrition, sleep and body, powered by Claude.';

  @override
  String get setAboutSources => 'Data sources & licenses';

  @override
  String get setAboutExerciseDb => 'Exercise library data and images';

  @override
  String get setAboutFontAr => 'Arabic font';

  @override
  String get setAboutFontEn => 'English font';

  @override
  String get setAboutClaude => 'AI coach (your own API key)';

  @override
  String get setAboutPrivacy => 'Privacy';

  @override
  String get setAboutPrivacyBody =>
      'All your data stays on this phone. Only the AI requests you trigger are sent to Claude, and progress photos are never sent unless you explicitly ask.';

  @override
  String get setAboutLicenses => 'Open-source licenses';

  @override
  String get setExerciseImages => 'Exercise images offline';

  @override
  String get setExerciseImagesSub =>
      'Download all exercise images for use without internet';

  @override
  String get setBackupExport => 'Export backup';

  @override
  String get setBackupExportHelp =>
      'One .zip file with your database, progress photos, meal photos and custom exercise media. Save it to Drive or anywhere.';

  @override
  String get setBackupExportButton => 'Export & share';

  @override
  String get setBackupWorking => 'Preparing backup…';

  @override
  String get setBackupNever => 'No backup yet';

  @override
  String setBackupLast(String date) {
    return 'Last backup: $date';
  }

  @override
  String get setBackupDone => 'Backup ready';

  @override
  String setBackupFailed(String error) {
    return 'Backup failed: $error';
  }

  @override
  String get setBackupShareSubject => 'IronMind backup';

  @override
  String get setBackupKeyNote =>
      'Your Claude API key is never included. Add it again after restoring on a new phone.';

  @override
  String get setRestore => 'Restore from backup';

  @override
  String get setRestoreHelp =>
      'Replaces ALL data on this phone with the backup.';

  @override
  String get setRestoreButton => 'Choose backup file';

  @override
  String get setRestorePick => 'Choose an IronMind backup (.zip)';

  @override
  String get setRestoreNotBackup => 'This file isn\'t an IronMind backup.';

  @override
  String get setRestoreCorrupt => 'The backup file is damaged or incomplete.';

  @override
  String get setRestoreNewer =>
      'This backup is from a newer app version. Update the app first.';

  @override
  String get setRestoreConfirmTitle => 'Replace all data?';

  @override
  String setRestoreConfirmBody(String date, String version) {
    return 'Backup from $date (app $version). Everything currently on this phone will be replaced. This can\'t be undone.';
  }

  @override
  String get setRestoreReplace => 'Replace';

  @override
  String get setRestoreWorking => 'Restoring your data… don\'t close the app.';

  @override
  String get setRestoreDone => 'Restore complete';

  @override
  String get setRestoreFailed => 'Restore failed';

  @override
  String get setRestoreRestart =>
      'Close the app and open it again to continue.';

  @override
  String get setRestoreCloseApp => 'Close app';

  @override
  String get setChannelWorkout => 'Workout reminders';

  @override
  String get setChannelMeals => 'Meal reminders';

  @override
  String get setChannelWater => 'Water reminders';

  @override
  String get setChannelSupplements => 'Supplement reminders';

  @override
  String get setChannelWeight => 'Weigh-in reminder';

  @override
  String get setChannelCoach => 'Coach messages';

  @override
  String get setChannelRestTimer => 'Rest timer';

  @override
  String get setChannelBackup => 'Backup reminder';

  @override
  String get setNotifWorkoutTitle => 'Training day 💪';

  @override
  String setNotifWorkoutBody(String time) {
    return 'Your workout is at $time. Get ready.';
  }

  @override
  String setNotifMealTitle(int number) {
    return 'Meal $number';
  }

  @override
  String get setNotifMealBody => 'Time to eat — log it after.';

  @override
  String get setNotifWaterTitle => 'Drink water 💧';

  @override
  String get setNotifWaterBody => 'A glass now keeps you on target.';

  @override
  String get setNotifSupplementsTitle => 'Supplements';

  @override
  String get setNotifWeightTitle => 'Morning weigh-in';

  @override
  String get setNotifWeightBody => 'Weigh yourself before eating or drinking.';

  @override
  String get setNotifBackupTitle => 'Time for a backup';

  @override
  String get setNotifBackupBody =>
      'No backup in 2 weeks. Export one from Settings so you don\'t lose your progress.';

  @override
  String get setNotifPermissionOff =>
      'Notifications are turned off for IronMind.';

  @override
  String get setNotifExactOff =>
      'Exact alarms are off — reminders may arrive a few minutes late.';

  @override
  String get setNotifAllow => 'Allow';

  @override
  String get setNotifWorkout => 'Workout reminder';

  @override
  String setNotifWorkoutDays(String days) {
    return 'On training days: $days';
  }

  @override
  String get setNotifWorkoutNoDays => 'Set your training days in your profile';

  @override
  String setNotifWorkoutDefault(String time) {
    return 'Use default (30 min before $time)';
  }

  @override
  String get setNotifTime => 'Reminder time';

  @override
  String get setNotifMeals => 'Meal reminders';

  @override
  String get setNotifMealsSub => 'At each meal time';

  @override
  String get setNotifUseProfileTimes => 'Use meal times from profile';

  @override
  String get setNotifWater => 'Water reminders';

  @override
  String setNotifWaterSub(String wake, String sleep) {
    return 'While you\'re awake ($wake – $sleep)';
  }

  @override
  String get setNotifWaterEvery => 'Remind me every';

  @override
  String setNotifHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours hours',
      one: '1 hour',
    );
    return '$_temp0';
  }

  @override
  String get setNotifSupplements => 'Supplement reminders';

  @override
  String get setNotifNoSupplements => 'No supplements added yet';

  @override
  String get setNotifWeight => 'Morning weigh-in';

  @override
  String get setNotifWeightSub => 'Right after you wake up';

  @override
  String get setNotifWeightDefault => 'Use default (15 min after waking)';

  @override
  String get setNotifCoach => 'Coach initiatives';

  @override
  String get setNotifCoachSub =>
      'Morning message, workout summaries, plateau alerts, weekly report';

  @override
  String get setNotifBackup => 'Backup reminder';

  @override
  String get setNotifBackupSub => 'If you haven\'t backed up for 2 weeks';

  @override
  String get setNotifTest => 'Send a test notification';

  @override
  String get setNotifTestTitle => 'IronMind';

  @override
  String get setNotifTestBody => 'Notifications are working ✅';

  @override
  String get setWidgetWorkoutLabel => 'Today\'s workout';

  @override
  String get setWidgetWorkout => 'Workout';

  @override
  String get setWidgetNoPlan => 'No plan yet';

  @override
  String get setWidgetOpenApp => 'Open the app to start';

  @override
  String get setWidgetRestDay => 'Rest day';

  @override
  String get setWidgetRestSub => 'Recover well';

  @override
  String get setWidgetWorkoutDone => 'Done ✓';

  @override
  String setWidgetExercises(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count exercises',
      one: '1 exercise',
    );
    return '$_temp0';
  }

  @override
  String get setWidgetCaloriesLabel => 'Calories';

  @override
  String setWidgetKcalLeft(int kcal) {
    return '$kcal left';
  }

  @override
  String setWidgetKcalOver(int kcal) {
    return '$kcal over';
  }

  @override
  String get setWidgetWaterLabel => 'Water';

  @override
  String setWidgetWaterText(int ml, int goal) {
    return '$ml / $goal ml';
  }

  @override
  String get setWidgetAddCup => '+ Cup';

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

  @override
  String get trkWaterTitle => 'Water';

  @override
  String get trkSupplementsTitle => 'Supplements';

  @override
  String get trkSleepTitle => 'Sleep';

  @override
  String get trkWeightTitle => 'Body weight';

  @override
  String get trkMeasurementsTitle => 'Measurements';

  @override
  String get trkPhotosTitle => 'Progress photos';

  @override
  String get trkHealthConnectTitle => 'Health Connect & ring';

  @override
  String get trkDate => 'Date';

  @override
  String get trkHistory => 'History';

  @override
  String get trkLast7Days => 'Last 7 days';

  @override
  String get trkInvalidNumber => 'Enter a valid number';

  @override
  String trkDeleteConfirm(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get trkDeleted => 'Deleted';

  @override
  String trkHoursMinutes(int h, int m) {
    return '${h}h ${m}m';
  }

  @override
  String get trkSourceManual => 'Manual';

  @override
  String get trkSourceHealthConnect => 'Health Connect';

  @override
  String get trkSyncNow => 'Sync now';

  @override
  String get trkSyncing => 'Syncing…';

  @override
  String get trkSyncDone => 'Synced';

  @override
  String get trkSyncFailed => 'Couldn\'t sync — your manual entries still work';

  @override
  String get trkTypeValue => 'Type a value';

  @override
  String get trkClear => 'Clear';

  @override
  String trkWaterProgress(int drunk, int goal) {
    return '$drunk / $goal ml';
  }

  @override
  String trkWaterRemaining(int ml) {
    return '$ml ml left today';
  }

  @override
  String get trkWaterGoalReached => 'Daily goal reached. Nice!';

  @override
  String trkAddCup(int ml) {
    return 'Cup · $ml ml';
  }

  @override
  String trkAddBottle(int ml) {
    return 'Bottle · $ml ml';
  }

  @override
  String get trkAddCustom => 'Custom amount';

  @override
  String get trkUndoLast => 'Undo last';

  @override
  String trkUndone(int ml) {
    return 'Removed $ml ml';
  }

  @override
  String trkWaterAdded(int ml) {
    return '+$ml ml';
  }

  @override
  String get trkWaterSizes => 'Cup & bottle sizes';

  @override
  String get trkCupSize => 'Cup size (ml)';

  @override
  String get trkBottleSize => 'Bottle size (ml)';

  @override
  String get trkAmountMl => 'Amount (ml)';

  @override
  String get trkTodayEntries => 'Today\'s entries';

  @override
  String get trkNoWaterYet => 'No water logged today yet';

  @override
  String trkGoalLabel(int ml) {
    return 'Goal $ml ml';
  }

  @override
  String get trkSuppToday => 'Today';

  @override
  String trkSuppTakenCount(int taken, int total) {
    return '$taken of $total taken';
  }

  @override
  String get trkSuppManage => 'My supplements';

  @override
  String get trkSuppAdd => 'Add supplement';

  @override
  String get trkSuppEdit => 'Edit supplement';

  @override
  String get trkSuppName => 'Name';

  @override
  String get trkSuppDose => 'Dose (e.g. 5 g, 1 scoop)';

  @override
  String get trkSuppTiming => 'Timing';

  @override
  String get trkTimingMorning => 'Morning';

  @override
  String get trkTimingPreWorkout => 'Pre-workout';

  @override
  String get trkTimingPostWorkout => 'Post-workout';

  @override
  String get trkTimingWithMeal => 'With a meal';

  @override
  String get trkTimingEvening => 'Evening';

  @override
  String get trkTimingBedtime => 'Before bed';

  @override
  String get trkSuppPerServing =>
      'Per serving (added to your daily macros when ticked)';

  @override
  String get trkSuppProtein => 'Protein (g)';

  @override
  String get trkSuppCalories => 'Calories (kcal)';

  @override
  String get trkSuppCarbs => 'Carbs (g)';

  @override
  String get trkSuppFat => 'Fat (g)';

  @override
  String get trkSuppActive => 'In use';

  @override
  String get trkSuppPaused => 'Paused';

  @override
  String get trkSuppEmpty =>
      'Add the supplements you take, then tick them off every day.';

  @override
  String get trkSuppImport => 'Import from my profile';

  @override
  String trkSuppImported(int count) {
    return '$count imported';
  }

  @override
  String get trkSuppNote =>
      'Logging only — the app doesn\'t recommend supplements.';

  @override
  String get trkSuppNoneActive => 'No supplements in use';

  @override
  String get trkNameRequired => 'Name is required';

  @override
  String trkSuppMacros(String protein, String calories) {
    return '$protein g protein · $calories kcal';
  }

  @override
  String get trkSleepLastNight => 'Last night';

  @override
  String get trkSleepNoData => 'No sleep logged for last night';

  @override
  String get trkSleepLog => 'Log sleep';

  @override
  String get trkSleepEdit => 'Edit sleep';

  @override
  String get trkSleepHours => 'Hours slept';

  @override
  String get trkSleepQuality => 'Quality';

  @override
  String get trkQuality1 => 'Very bad';

  @override
  String get trkQuality2 => 'Bad';

  @override
  String get trkQuality3 => 'OK';

  @override
  String get trkQuality4 => 'Good';

  @override
  String get trkQuality5 => 'Excellent';

  @override
  String get trkBedTime => 'Bedtime';

  @override
  String get trkWakeTime => 'Wake-up';

  @override
  String get trkSleepDate => 'Woke up on';

  @override
  String get trkOptionalTimes => 'Bed & wake times (optional)';

  @override
  String get trkStageDeep => 'Deep';

  @override
  String get trkStageRem => 'REM';

  @override
  String get trkStageLight => 'Light';

  @override
  String get trkStageAwake => 'Awake';

  @override
  String trkSleepWeekAvg(String value) {
    return '7-day average $value';
  }

  @override
  String trkSleepNeed(String value) {
    return 'Your need $value';
  }

  @override
  String get trkSleepConnectHint =>
      'Connect your ring through Health Connect to fill sleep and stages automatically.';

  @override
  String get trkSleepManualOverrides =>
      'A manual entry replaces the ring data for that night.';

  @override
  String get trkSleepEmpty => 'No sleep logged yet.';

  @override
  String get trkRecoveryToday => 'Recovery today';

  @override
  String get trkRecoveryLow => 'Low';

  @override
  String get trkRecoveryModerate => 'Moderate';

  @override
  String get trkRecoveryHigh => 'High';

  @override
  String trkRecoveryCalibrating(int days) {
    return 'Baseline still calibrating ($days/14 days)';
  }

  @override
  String get trkWeightLog => 'Log weight';

  @override
  String get trkWeightLatest => 'Latest';

  @override
  String get trkWeightAvg7 => '7-day average';

  @override
  String get trkWeightChange7 => 'vs last week';

  @override
  String get trkWeightDaily => 'Daily';

  @override
  String get trkRange1M => '1M';

  @override
  String get trkRange3M => '3M';

  @override
  String get trkRange1Y => '1Y';

  @override
  String get trkRangeAll => 'All';

  @override
  String get trkWeightEmpty =>
      'Weigh yourself every morning — the 7-day average smooths out daily swings.';

  @override
  String trkWeightSaved(String kg) {
    return 'Saved $kg kg';
  }

  @override
  String get trkWeightKg => 'Weight (kg)';

  @override
  String get trkNeedTwoPoints => 'Log a few days to see the chart';

  @override
  String get trkMeasureWaist => 'Waist';

  @override
  String get trkMeasureChest => 'Chest';

  @override
  String get trkMeasureArm => 'Arm';

  @override
  String get trkMeasureThigh => 'Thigh';

  @override
  String get trkMeasureNeck => 'Neck';

  @override
  String get trkMeasureHips => 'Hips';

  @override
  String get trkMeasureBodyFat => 'Body fat %';

  @override
  String get trkMeasureNew => 'New measurements';

  @override
  String get trkMeasureEdit => 'Edit measurements';

  @override
  String get trkMeasureDue =>
      'It\'s been over a week since your last measurements — measure today.';

  @override
  String get trkMeasureNone =>
      'No measurements yet — take them once a week, same time of day.';

  @override
  String get trkMeasureTip =>
      'Measure in the morning before eating; tape snug, not tight.';

  @override
  String get trkMeasureNeedOne => 'Enter at least one value';

  @override
  String trkLastMeasured(String date) {
    return 'Last: $date';
  }

  @override
  String get trkPhotosLocked => 'Progress photos are locked';

  @override
  String get trkPhotosUnlock => 'Unlock';

  @override
  String get trkPhotosAuthReason => 'Unlock to view your progress photos';

  @override
  String get trkPhotosAdd => 'Add photos';

  @override
  String get trkPhotosCompare => 'Compare';

  @override
  String get trkAngleFront => 'Front';

  @override
  String get trkAngleSide => 'Side';

  @override
  String get trkAngleBack => 'Back';

  @override
  String get trkCamera => 'Camera';

  @override
  String get trkGallery => 'Gallery';

  @override
  String get trkPhotosEmpty =>
      'Take front, side and back photos every 2–4 weeks in the same light and pose.';

  @override
  String get trkPhotosPrivate =>
      'Saved privately inside the app — never in your gallery and never sent to the AI.';

  @override
  String get trkPhotoDeleteConfirm => 'Delete this photo?';

  @override
  String get trkBefore => 'Before';

  @override
  String get trkAfter => 'After';

  @override
  String get trkSideBySide => 'Side by side';

  @override
  String get trkSlider => 'Slider';

  @override
  String get trkNoPhotoForAngle => 'No photo for this angle on this date';

  @override
  String get trkComparePickTwo =>
      'Add photos on at least two dates to compare.';

  @override
  String get trkPhotoSaved => 'Photo saved';

  @override
  String get trkPhotoFailed => 'Couldn\'t save the photo';

  @override
  String get trkPhotoMissing => 'Photo file missing';

  @override
  String trkPhotosForDate(String date) {
    return 'Photos for $date';
  }

  @override
  String get trkDragToCompare => 'Drag to compare';

  @override
  String get trkHcEnable => 'Use Health Connect';

  @override
  String get trkHcEnableSub =>
      'Read sleep, heart rate, HRV, steps and calories written by your ring\'s app';

  @override
  String get trkHcStatus => 'Status';

  @override
  String get trkHcAvailable => 'Health Connect is installed';

  @override
  String get trkHcNotInstalled => 'Health Connect isn\'t installed';

  @override
  String get trkHcNeedsUpdate => 'Health Connect needs an update';

  @override
  String get trkHcUnsupported =>
      'Health Connect isn\'t supported on this device';

  @override
  String get trkHcInstall => 'Install Health Connect';

  @override
  String get trkHcInstallHint =>
      'Android 14+ has it built in (Settings → Security & privacy → Health Connect). On older phones install it from the Play Store.';

  @override
  String get trkHcPermGranted => 'Read permissions granted';

  @override
  String get trkHcPermMissing => 'Read permissions not granted yet';

  @override
  String get trkHcGrant => 'Grant permissions';

  @override
  String get trkHcBgGranted => 'Background reading allowed';

  @override
  String get trkHcBgMissing =>
      'Background reading not allowed (sync runs when you open the app)';

  @override
  String get trkHcBgAllow => 'Allow background reading';

  @override
  String trkHcLastSync(String time) {
    return 'Last sync: $time';
  }

  @override
  String get trkHcNeverSynced => 'Never synced';

  @override
  String trkHcOutcomeOk(int count) {
    return 'Last sync pulled $count data points';
  }

  @override
  String get trkHcOutcomeNoPermission =>
      'Last sync: no permission to read data';

  @override
  String get trkHcOutcomeUnavailable => 'Last sync: Health Connect unavailable';

  @override
  String get trkHcOutcomeError => 'Last sync failed';

  @override
  String get trkHcLastPulled => 'Last data pulled';

  @override
  String get trkHcLastPulledSub =>
      'Check the source app: if your ring\'s app shows up here with recent dates, it writes to Health Connect.';

  @override
  String get trkHcColType => 'Data';

  @override
  String get trkHcColDate => 'Date';

  @override
  String get trkHcColValue => 'Value';

  @override
  String get trkHcColSource => 'Source app';

  @override
  String get trkHcNothing => 'Nothing yet';

  @override
  String get trkHcTypeSleep => 'Sleep session';

  @override
  String get trkHcTypeAsleep => 'Asleep (no stage)';

  @override
  String get trkHcTypeHr => 'Heart rate';

  @override
  String get trkHcTypeRhr => 'Resting heart rate';

  @override
  String get trkHcTypeHrv => 'HRV (RMSSD)';

  @override
  String get trkHcTypeSteps => 'Steps';

  @override
  String get trkHcTypeCalories => 'Active calories';

  @override
  String trkHcSources(String apps) {
    return 'Apps writing data: $apps';
  }

  @override
  String get trkHcCardooTitle => 'Is your ring\'s data arriving?';

  @override
  String get trkHcCardooBody =>
      'It\'s not confirmed that the Cardoo app writes to Health Connect. Open the Cardoo app and enable syncing to Health Connect if it offers it, wear the ring for a night, then tap Sync now and check the table below.';

  @override
  String get trkHcManualFallback =>
      'If nothing arrives, IronMind just uses what you log manually (sleep, weight…). Nothing breaks.';

  @override
  String get trkHcEnabledToast => 'Health Connect enabled';

  @override
  String get trkHcDisabledToast =>
      'Health Connect disabled — manual entry only';

  @override
  String get trkUnitBpm => 'bpm';

  @override
  String get trkUnitMs => 'ms';

  @override
  String get trkUnitSteps => 'steps';

  @override
  String get woAddCardio => 'Add cardio';

  @override
  String get woAddExercise => 'Add exercise';

  @override
  String get woApprovePlan => 'Approve plan';

  @override
  String get woAskCoach => 'Ask the coach to review';

  @override
  String get woBuildTemplate => 'Build a basic plan (no AI)';

  @override
  String get woCaloriesAuto =>
      'Estimated automatically (MET) – you can edit it';

  @override
  String get woCardio => 'Cardio';

  @override
  String get woCardioBike => 'Bike';

  @override
  String get woCardioElliptical => 'Elliptical';

  @override
  String get woCardioJumpRope => 'Jump rope';

  @override
  String get woCardioOther => 'Other';

  @override
  String get woCardioRowing => 'Rowing';

  @override
  String get woCardioRun => 'Run';

  @override
  String get woCardioStairs => 'Stairs';

  @override
  String get woCardioSwim => 'Swim';

  @override
  String get woCardioTreadmill => 'Treadmill';

  @override
  String get woCardioWalk => 'Walk';

  @override
  String get woCoachEvaluation => 'Coach evaluation';

  @override
  String get woCoachNeedsKey =>
      'Add your Claude API key to get the coach\'s evaluation of this workout.';

  @override
  String get woCoachQueued =>
      'No internet – the coach will review this workout as soon as you\'re back online.';

  @override
  String get woCoachReviewing => 'The coach is reviewing your workout…';

  @override
  String get woContinueWorkout => 'Continue this workout';

  @override
  String get woCooldown => 'Cool-down';

  @override
  String get woCopyLast => 'Copy last';

  @override
  String get woDeleteSession => 'Delete workout';

  @override
  String get woDeleteSessionBody =>
      'All sets, cardio and notes of this workout will be deleted.';

  @override
  String get woDeleteSessionTitle => 'Delete this workout?';

  @override
  String get woDeleteSetTitle => 'Delete this set?';

  @override
  String get woDeloadActiveBody =>
      'Lighter week: suggestions use 85% of your weights. Focus on technique and recovery.';

  @override
  String get woDeloadActiveShort => 'Deload week – 85% weights';

  @override
  String woDeloadActiveTitle(int day) {
    return 'Deload week – day $day of 7';
  }

  @override
  String get woDeloadBadge => 'Deload';

  @override
  String get woDeloadDuePerformance =>
      'Your estimated 1RMs dropped over the last 2 weeks – that\'s usually accumulated fatigue. A lighter week at 85% will bring you back stronger.';

  @override
  String woDeloadDueSchedule(int weeks) {
    return 'You\'ve trained hard for $weeks weeks. A lighter week at 85% weights helps you recover and keep progressing.';
  }

  @override
  String get woDeloadDueTitle => 'Time for a deload week?';

  @override
  String woDeloadEvery(int weeks) {
    return 'Deload every $weeks weeks';
  }

  @override
  String get woDiscard => 'Discard';

  @override
  String get woDuration => 'Duration';

  @override
  String get woEditPlan => 'Edit plan';

  @override
  String get woEndDeload => 'End';

  @override
  String woExerciseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count exercises',
      one: '1 exercise',
      zero: 'no exercises',
    );
    return '$_temp0';
  }

  @override
  String get woExerciseInfo => 'Exercise details';

  @override
  String get woExerciseNote => 'Exercise note';

  @override
  String get woExerciseNoteHint => 'e.g. shoulder hurts on the way down';

  @override
  String get woExercises => 'Exercises';

  @override
  String get woFinish => 'Finish';

  @override
  String get woFinishPartialBody =>
      'Not all planned sets are done. It will be saved as a partial workout.';

  @override
  String get woFinishPartialTitle => 'Finish anyway?';

  @override
  String get woFinishWorkout => 'Finish workout';

  @override
  String get woFirstTime => 'First time – no comparison yet';

  @override
  String get woFreeWorkout => 'Workout';

  @override
  String get woFreeWorkoutHint =>
      'Add exercises from the library and log your sets.';

  @override
  String get woGenerateWithAi => 'Build my plan with AI';

  @override
  String get woGeneratingPlan => 'Building your plan… this can take a minute.';

  @override
  String get woHistory => 'History';

  @override
  String get woIncline => 'Incline';

  @override
  String get woKmh => 'km/h';

  @override
  String get woLastTime => 'Last time';

  @override
  String get woLevel => 'Level';

  @override
  String get woLibrary => 'Library';

  @override
  String get woMissedBody =>
      'This training day was missed. The schedule doesn\'t shift – just show up next time.';

  @override
  String get woNewRecords => 'New records';

  @override
  String get woNoExercises => 'No exercises yet';

  @override
  String get woNoHistory => 'No workouts yet. Your sessions will show up here.';

  @override
  String get woNoPlan =>
      'You don\'t have an active workout plan yet. Build one with AI, or start with a basic plan that works offline.';

  @override
  String get woNotNow => 'Not now';

  @override
  String get woNothingLoggedBody =>
      'You haven\'t logged any set or cardio. Discard this workout?';

  @override
  String get woNothingLoggedTitle => 'Nothing logged';

  @override
  String get woNothingToCopy => 'No previous set to copy';

  @override
  String get woPendingPlan => 'A new plan is waiting for your review';

  @override
  String get woPickFromLibrary => 'Pick from the library';

  @override
  String get woPlanApproved => 'Plan activated 💪';

  @override
  String get woPlanNotFound => 'Plan not found';

  @override
  String get woPlanTools => 'Plan';

  @override
  String woPrBanner(String exercise, String types) {
    return 'New PR! $exercise: $types';
  }

  @override
  String get woPrE1rm => 'Best 1RM';

  @override
  String get woPrReps => 'Most reps';

  @override
  String get woPrWeight => 'Heaviest weight';

  @override
  String get woPrs => 'PRs';

  @override
  String get woReasonAddReps => 'Same weight – aim for one more rep.';

  @override
  String get woReasonDeload => 'Deload: 85% of last time.';

  @override
  String get woReasonFirstTime =>
      'First time – pick a weight you can do with good form.';

  @override
  String get woReasonIncrease =>
      'You hit the top of the rep range last time – add weight.';

  @override
  String get woReasonReduce =>
      'Two tough sessions in a row – drop the weight a bit.';

  @override
  String get woReasonRepeat => 'Repeat last time\'s numbers with solid form.';

  @override
  String get woRecoveryAdjusted => 'Recovery adjusted';

  @override
  String woRecoveryPill(int pct, int sets) {
    return 'Low recovery: −$pct% weight, −$sets set';
  }

  @override
  String get woRegenerate => 'Rebuild plan with AI';

  @override
  String get woRegenerateBody =>
      'The AI will build a new plan for you to review. Your current plan stays active until you approve the new one.';

  @override
  String get woRegenerateTitle => 'Rebuild your plan?';

  @override
  String get woRemoveExerciseTitle => 'Remove this exercise?';

  @override
  String get woRepMax => 'Max reps';

  @override
  String get woRepMin => 'Min reps';

  @override
  String get woReps => 'Reps';

  @override
  String get woRest => 'Rest';

  @override
  String get woRestDay => 'Rest day';

  @override
  String get woRestDayBody =>
      'Recover today: sleep well, eat your protein, maybe a light walk.';

  @override
  String get woRestDoneBody => 'Rest is over – next set!';

  @override
  String get woRestDoneTitle => 'Rest timer';

  @override
  String get woRestSeconds => 'Rest (sec)';

  @override
  String get woRestTimer => 'Rest';

  @override
  String get woResumeWorkout => 'Resume workout';

  @override
  String get woReviewHint =>
      'Edit anything you like (tap to edit, drag to reorder), then approve.';

  @override
  String get woReviewPlan => 'Review your plan';

  @override
  String get woSaveSet => 'Save set';

  @override
  String get woSessionNotFound => 'Workout not found';

  @override
  String get woSessionNotes => 'Workout notes';

  @override
  String get woSessionNotesHint => 'How did it feel? Anything to remember?';

  @override
  String get woSetTypeDrop => 'Drop set';

  @override
  String get woSetTypeFailure => 'To failure';

  @override
  String get woSetTypeNormal => 'Normal';

  @override
  String get woSetTypeWarmup => 'Warm-up';

  @override
  String get woSets => 'Sets';

  @override
  String woSetsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sets',
      one: '1 set',
    );
    return '$_temp0';
  }

  @override
  String get woSourceAi => 'AI';

  @override
  String get woSourceTemplate => 'Basic';

  @override
  String get woSpeed => 'Speed';

  @override
  String get woStartDeload => 'Start deload week';

  @override
  String get woStartEmpty => 'Start an empty workout';

  @override
  String get woStartThisWorkout => 'Do this workout now';

  @override
  String get woStartToday => 'Start today\'s workout';

  @override
  String get woStatusCompleted => 'Completed';

  @override
  String get woStatusInProgress => 'In progress';

  @override
  String get woStatusMissed => 'Missed';

  @override
  String get woStatusPartial => 'Partial';

  @override
  String get woSubstitute => 'Substitute';

  @override
  String get woSubstituteAi => 'AI suggestions';

  @override
  String get woSubstituteAlways => 'Always';

  @override
  String get woSubstituteLocal => 'Similar exercises';

  @override
  String get woSubstituteNone => 'No alternatives found';

  @override
  String get woSubstituteOnce => 'Just this workout';

  @override
  String get woSubstituteTitle => 'Substitute exercise';

  @override
  String get woSubstituted => 'Substituted';

  @override
  String get woSummaryTitle => 'Workout summary';

  @override
  String get woSwap => 'Swap';

  @override
  String get woTargetRpe => 'Target RPE';

  @override
  String get woTemplateBody =>
      'A new basic plan will be built for you to review. Your current plan stays active until you approve it.';

  @override
  String get woTemplateTitle => 'Build a basic plan?';

  @override
  String get woTodayTitle => 'Today';

  @override
  String get woTotalVolume => 'Total volume';

  @override
  String get woTry => 'Try';

  @override
  String get woViewSummary => 'View summary';

  @override
  String get woVoiceConfirm => 'Save this set?';

  @override
  String get woVoiceExample => 'Say e.g. \"80 kilo 10 reps\"';

  @override
  String get woVoiceHint =>
      'Try saying the weight then the reps, e.g. \"80 kilo 10 reps\".';

  @override
  String get woVoiceNotUnderstood => 'Didn\'t catch that';

  @override
  String get woVoiceParsing => 'Understanding…';

  @override
  String get woVoiceTitle => 'Listening…';

  @override
  String get woVoiceUnavailable =>
      'Speech recognition isn\'t available on this device.';

  @override
  String get woVolume => 'Volume';

  @override
  String woVsLastTime(String best, String volume) {
    return 'Last time: best $best · volume $volume kg';
  }

  @override
  String get woWarmup => 'Warm-up';

  @override
  String get woWeeklyPlan => 'Plan';

  @override
  String get woWeightKg => 'Weight (kg)';

  @override
  String get woWorkingSets => 'Working sets';

  @override
  String get woWorkout => 'Workout';
}
