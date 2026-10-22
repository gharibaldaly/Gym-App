import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../l10n/gen/app_localizations.dart';
import 'onboarding_logic.dart';

/// A selectable answer: stored [code] + localized label/subtitle + icon.
class OnbOption<T> {
  final T code;
  final String label;
  final String? subtitle;
  final IconData? icon;
  const OnbOption(this.code, this.label, {this.subtitle, this.icon});
}

String? labelOf<T>(List<OnbOption<T>> options, T? code) {
  if (code == null) return null;
  for (final o in options) {
    if (o.code == code) return o.label;
  }
  return code.toString();
}

// ---------------------------------------------------------------------------
// Step metadata
// ---------------------------------------------------------------------------

IconData stepIcon(OnbStep s) => switch (s) {
      OnbStep.language => Symbols.translate_rounded,
      OnbStep.body => Symbols.accessibility_new_rounded,
      OnbStep.bodyFat => Symbols.water_drop_rounded,
      OnbStep.measurements => Symbols.straighten_rounded,
      OnbStep.goal => Symbols.flag_rounded,
      OnbStep.level => Symbols.trending_up_rounded,
      OnbStep.days => Symbols.calendar_month_rounded,
      OnbStep.sessionLength => Symbols.timer_rounded,
      OnbStep.split => Symbols.view_week_rounded,
      OnbStep.focus => Symbols.center_focus_strong_rounded,
      OnbStep.location => Symbols.location_on_rounded,
      OnbStep.injuries => Symbols.healing_rounded,
      OnbStep.job => Symbols.work_rounded,
      OnbStep.sleep => Symbols.bedtime_rounded,
      OnbStep.trainingTime => Symbols.schedule_rounded,
      OnbStep.cardio => Symbols.sprint_rounded,
      OnbStep.meals => Symbols.restaurant_rounded,
      OnbStep.foods => Symbols.favorite_rounded,
      OnbStep.budget => Symbols.payments_rounded,
      OnbStep.supplements => Symbols.pill_rounded,
      OnbStep.water => Symbols.water_full_rounded,
      OnbStep.healthConnect => Symbols.watch_rounded,
      OnbStep.apiKey => Symbols.key_rounded,
      OnbStep.summary => Symbols.fact_check_rounded,
    };

String stepTitle(AppLocalizations l, OnbStep s) => switch (s) {
      OnbStep.language => l.onbLangTitle,
      OnbStep.body => l.onbBodyTitle,
      OnbStep.bodyFat => l.onbBodyFatTitle,
      OnbStep.measurements => l.onbMeasTitle,
      OnbStep.goal => l.onbGoalTitle,
      OnbStep.level => l.onbLevelTitle,
      OnbStep.days => l.onbDaysTitle,
      OnbStep.sessionLength => l.onbSessionTitle,
      OnbStep.split => l.onbSplitTitle,
      OnbStep.focus => l.onbFocusTitle,
      OnbStep.location => l.onbLocationTitle,
      OnbStep.injuries => l.onbInjuriesTitle,
      OnbStep.job => l.onbJobTitle,
      OnbStep.sleep => l.onbSleepTitle,
      OnbStep.trainingTime => l.onbTrainTimeTitle,
      OnbStep.cardio => l.onbCardioTitle,
      OnbStep.meals => l.onbMealsTitle,
      OnbStep.foods => l.onbFoodsTitle,
      OnbStep.budget => l.onbBudgetTitle,
      OnbStep.supplements => l.onbSuppTitle,
      OnbStep.water => l.onbWaterTitle,
      OnbStep.healthConnect => l.onbHealthTitle,
      OnbStep.apiKey => l.onbKeyTitle,
      OnbStep.summary => l.onbSummaryTitle,
    };

String stepSubtitle(AppLocalizations l, OnbStep s) => switch (s) {
      OnbStep.language => l.onbLangSubtitle,
      OnbStep.body => l.onbBodySubtitle,
      OnbStep.bodyFat => l.onbBodyFatSubtitle,
      OnbStep.measurements => l.onbMeasSubtitle,
      OnbStep.goal => l.onbGoalSubtitle,
      OnbStep.level => l.onbLevelSubtitle,
      OnbStep.days => l.onbDaysSubtitle,
      OnbStep.sessionLength => l.onbSessionSubtitle,
      OnbStep.split => l.onbSplitSubtitle,
      OnbStep.focus => l.onbFocusSubtitle,
      OnbStep.location => l.onbLocationSubtitle,
      OnbStep.injuries => l.onbInjuriesSubtitle,
      OnbStep.job => l.onbJobSubtitle,
      OnbStep.sleep => l.onbSleepSubtitle,
      OnbStep.trainingTime => l.onbTrainTimeSubtitle,
      OnbStep.cardio => l.onbCardioSubtitle,
      OnbStep.meals => l.onbMealsSubtitle,
      OnbStep.foods => l.onbFoodsSubtitle,
      OnbStep.budget => l.onbBudgetSubtitle,
      OnbStep.supplements => l.onbSuppSubtitle,
      OnbStep.water => l.onbWaterSubtitle,
      OnbStep.healthConnect => l.onbHealthSubtitle,
      OnbStep.apiKey => l.onbKeySubtitle,
      OnbStep.summary => l.onbSummarySubtitle,
    };

/// Short label used in summary rows.
String stepShortLabel(AppLocalizations l, OnbStep s) => switch (s) {
      OnbStep.language => l.onbSumLanguage,
      OnbStep.body => l.onbSumBody,
      OnbStep.bodyFat => l.onbSumBodyFat,
      OnbStep.measurements => l.onbSumMeasurements,
      OnbStep.goal => l.onbSumGoal,
      OnbStep.level => l.onbSumLevel,
      OnbStep.days => l.onbSumDays,
      OnbStep.sessionLength => l.onbSumSession,
      OnbStep.split => l.onbSumSplit,
      OnbStep.focus => l.onbSumFocus,
      OnbStep.location => l.onbSumLocation,
      OnbStep.injuries => l.onbSumInjuries,
      OnbStep.job => l.onbSumJob,
      OnbStep.sleep => l.onbSumSleep,
      OnbStep.trainingTime => l.onbSumTrainingTime,
      OnbStep.cardio => l.onbSumCardio,
      OnbStep.meals => l.onbSumMeals,
      OnbStep.foods => l.onbSumFoods,
      OnbStep.budget => l.onbSumBudget,
      OnbStep.supplements => l.onbSumSupplements,
      OnbStep.water => l.onbSumWater,
      OnbStep.healthConnect => l.onbSumHealth,
      OnbStep.apiKey => l.onbSumApiKey,
      OnbStep.summary => l.onbSummaryTitle,
    };

String sectionTitle(AppLocalizations l, OnbSection s) => switch (s) {
      OnbSection.basics => l.onbSectionBasics,
      OnbSection.goals => l.onbSectionGoals,
      OnbSection.training => l.onbSectionTraining,
      OnbSection.lifestyle => l.onbSectionLifestyle,
      OnbSection.nutrition => l.onbSectionNutrition,
      OnbSection.connections => l.onbSectionConnections,
    };

String issueText(AppLocalizations l, OnbIssue issue, {int? daysPerWeek}) => switch (issue) {
      OnbIssue.sexRequired => l.onbErrSex,
      OnbIssue.ageRange => l.onbErrAge,
      OnbIssue.heightRange => l.onbErrHeight,
      OnbIssue.weightRange => l.onbErrWeight,
      OnbIssue.bodyFatChoice => l.onbErrBodyFatChoice,
      OnbIssue.bodyFatRange => l.onbErrBodyFat,
      OnbIssue.measurementRange => l.onbErrMeasurement,
      OnbIssue.goalRequired => l.onbErrGoal,
      OnbIssue.targetWeightRange => l.onbErrTargetWeight,
      OnbIssue.goalWeeksRange => l.onbErrWeeks,
      OnbIssue.levelRequired => l.onbErrLevel,
      OnbIssue.daysCountRequired => l.onbErrDaysCount,
      OnbIssue.daysMismatch => l.onbErrDaysMismatch('${daysPerWeek ?? ''}'),
      OnbIssue.choiceRequired => l.onbErrChoose,
      OnbIssue.sleepRequired => l.onbErrSleep,
      OnbIssue.cardioPerWeekRequired => l.onbErrCardioPerWeek,
      OnbIssue.mealTimesMismatch => l.onbErrMealTimes,
      OnbIssue.budgetRange => l.onbErrBudget,
      OnbIssue.suppNameRequired => l.onbErrSuppName,
      OnbIssue.waterRange => l.onbErrWater,
    };

// ---------------------------------------------------------------------------
// Option lists
// ---------------------------------------------------------------------------

List<OnbOption<String>> sexOptions(AppLocalizations l) => [
      OnbOption('male', l.onbSexMale, icon: Symbols.male_rounded),
      OnbOption('female', l.onbSexFemale, icon: Symbols.female_rounded),
    ];

List<OnbOption<String>> bodyFatMethodOptions(AppLocalizations l) => [
      OnbOption('number', l.onbBfNumber, subtitle: l.onbBfNumberSub, icon: Symbols.percent_rounded),
      OnbOption('shape', l.onbBfShape, subtitle: l.onbBfShapeSub, icon: Symbols.accessibility_rounded),
      OnbOption('unknown', l.onbBfUnknown, subtitle: l.onbBfUnknownSub, icon: Symbols.help_rounded),
    ];

List<OnbOption<BodyShape>> bodyShapeOptions(AppLocalizations l) => [
      OnbOption(BodyShape.lean, l.onbShapeLean, subtitle: l.onbShapeLeanSub),
      OnbOption(BodyShape.athletic, l.onbShapeAthletic, subtitle: l.onbShapeAthleticSub),
      OnbOption(BodyShape.average, l.onbShapeAverage, subtitle: l.onbShapeAverageSub),
      OnbOption(BodyShape.soft, l.onbShapeSoft, subtitle: l.onbShapeSoftSub),
      OnbOption(BodyShape.heavy, l.onbShapeHeavy, subtitle: l.onbShapeHeavySub),
    ];

String measurementLabel(AppLocalizations l, String key) => switch (key) {
      'waist' => l.onbMeasWaist,
      'chest' => l.onbMeasChest,
      'arm' => l.onbMeasArm,
      'thigh' => l.onbMeasThigh,
      'neck' => l.onbMeasNeck,
      'hips' => l.onbMeasHips,
      _ => key,
    };

List<OnbOption<String>> goalOptions(AppLocalizations l) => [
      OnbOption('bulk', l.onbGoalBulk, subtitle: l.onbGoalBulkSub, icon: Symbols.fitness_center_rounded),
      OnbOption('cut', l.onbGoalCut, subtitle: l.onbGoalCutSub, icon: Symbols.local_fire_department_rounded),
      OnbOption('recomp', l.onbGoalRecomp, subtitle: l.onbGoalRecompSub, icon: Symbols.autorenew_rounded),
      OnbOption('strength', l.onbGoalStrength, subtitle: l.onbGoalStrengthSub, icon: Symbols.bolt_rounded),
      OnbOption('fitness', l.onbGoalFitness, subtitle: l.onbGoalFitnessSub, icon: Symbols.favorite_rounded),
    ];

List<OnbOption<String>> levelOptions(AppLocalizations l) => [
      OnbOption('beginner', l.onbLevelBeginner, subtitle: l.onbLevelBeginnerSub, icon: Symbols.signal_cellular_alt_1_bar_rounded),
      OnbOption('intermediate', l.onbLevelIntermediate,
          subtitle: l.onbLevelIntermediateSub, icon: Symbols.signal_cellular_alt_2_bar_rounded),
      OnbOption('advanced', l.onbLevelAdvanced, subtitle: l.onbLevelAdvancedSub, icon: Symbols.signal_cellular_alt_rounded),
    ];

List<OnbOption<String>> experienceOptions(AppLocalizations l) => [
      OnbOption('none', l.onbExpNone),
      OnbOption('<6m', l.onbExpLt6m),
      OnbOption('6-12m', l.onbExp6to12m),
      OnbOption('1-3y', l.onbExp1to3y),
      OnbOption('3y+', l.onbExp3yPlus),
    ];

const sessionMinuteOptions = [30, 45, 60, 75, 90];

List<OnbOption<String>> splitOptions(AppLocalizations l) => [
      OnbOption('muscle_group', l.onbSplitMuscleGroup, subtitle: l.onbSplitMuscleGroupSub, icon: Symbols.grid_view_rounded),
      OnbOption('bro', l.onbSplitBro, subtitle: l.onbSplitBroSub, icon: Symbols.looks_one_rounded),
      OnbOption('full_body', l.onbSplitFullBody, subtitle: l.onbSplitFullBodySub, icon: Symbols.accessibility_new_rounded),
      OnbOption('ppl', l.onbSplitPpl, subtitle: l.onbSplitPplSub, icon: Symbols.swap_vert_rounded),
      OnbOption('upper_lower', l.onbSplitUpperLower, subtitle: l.onbSplitUpperLowerSub, icon: Symbols.unfold_more_rounded),
      OnbOption('ai', l.onbSplitAi, subtitle: l.onbSplitAiSub, icon: Symbols.auto_awesome_rounded),
    ];

List<OnbOption<String>> muscleOptions(AppLocalizations l) => [
      OnbOption('chest', l.onbMuscleChest),
      OnbOption('back', l.onbMuscleBack),
      OnbOption('shoulders', l.onbMuscleShoulders),
      OnbOption('biceps', l.onbMuscleBiceps),
      OnbOption('triceps', l.onbMuscleTriceps),
      OnbOption('forearms', l.onbMuscleForearms),
      OnbOption('abdominals', l.onbMuscleAbs),
      OnbOption('quadriceps', l.onbMuscleQuads),
      OnbOption('hamstrings', l.onbMuscleHamstrings),
      OnbOption('glutes', l.onbMuscleGlutes),
      OnbOption('calves', l.onbMuscleCalves),
      OnbOption('traps', l.onbMuscleTraps),
    ];

List<OnbOption<String>> locationOptions(AppLocalizations l) => [
      OnbOption('full_gym', l.onbLocFullGym, subtitle: l.onbLocFullGymSub, icon: Symbols.fitness_center_rounded),
      OnbOption('limited_gym', l.onbLocLimitedGym, subtitle: l.onbLocLimitedGymSub, icon: Symbols.sports_gymnastics_rounded),
      OnbOption('home', l.onbLocHome, subtitle: l.onbLocHomeSub, icon: Symbols.home_rounded),
    ];

List<OnbOption<String>> jointInjuryOptions(AppLocalizations l) => [
      OnbOption('shoulder', l.onbInjShoulder),
      OnbOption('knee', l.onbInjKnee),
      OnbOption('lower_back', l.onbInjLowerBack),
      OnbOption('elbow', l.onbInjElbow),
      OnbOption('wrist', l.onbInjWrist),
      OnbOption('neck', l.onbInjNeck),
      OnbOption('hip', l.onbInjHip),
      OnbOption('ankle', l.onbInjAnkle),
    ];

List<OnbOption<String>> healthConditionOptions(AppLocalizations l) => [
      OnbOption('hypertension', l.onbInjHypertension),
      OnbOption('diabetes', l.onbInjDiabetes),
      OnbOption('heart', l.onbInjHeart),
      OnbOption('asthma', l.onbInjAsthma),
      OnbOption('hernia', l.onbInjHernia),
    ];

List<OnbOption<String>> jobOptions(AppLocalizations l) => [
      OnbOption('desk', l.onbJobDesk, subtitle: l.onbJobDeskSub, icon: Symbols.computer_rounded),
      OnbOption('mobile', l.onbJobMobile, subtitle: l.onbJobMobileSub, icon: Symbols.directions_walk_rounded),
      OnbOption('physical', l.onbJobPhysical, subtitle: l.onbJobPhysicalSub, icon: Symbols.construction_rounded),
      OnbOption('none', l.onbJobNone, subtitle: l.onbJobNoneSub, icon: Symbols.school_rounded),
    ];

List<OnbOption<String>> trainingTimeOptions(AppLocalizations l) => [
      OnbOption('morning', l.onbTimeMorning, icon: Symbols.wb_sunny_rounded),
      OnbOption('after_work', l.onbTimeAfterWork, icon: Symbols.wb_twilight_rounded),
      OnbOption('night', l.onbTimeNight, icon: Symbols.nightlight_rounded),
    ];

List<OnbOption<String>> cardioOptions(AppLocalizations l) => [
      OnbOption('none', l.onbCardioNone, icon: Symbols.block_rounded),
      OnbOption('walking', l.onbCardioWalking, icon: Symbols.directions_walk_rounded),
      OnbOption('running', l.onbCardioRunning, icon: Symbols.sprint_rounded),
      OnbOption('cycling', l.onbCardioCycling, icon: Symbols.directions_bike_rounded),
      OnbOption('elliptical', l.onbCardioElliptical, icon: Symbols.elevator_rounded),
      OnbOption('swimming', l.onbCardioSwimming, icon: Symbols.pool_rounded),
      OnbOption('hiit', l.onbCardioHiit, icon: Symbols.flash_on_rounded),
      OnbOption('stairs', l.onbCardioStairs, icon: Symbols.stairs_rounded),
      OnbOption('jump_rope', l.onbCardioJumpRope, icon: Symbols.cable_rounded),
      OnbOption('football', l.onbCardioFootball, icon: Symbols.sports_soccer_rounded),
    ];

String foodLabel(AppLocalizations l, String code) => switch (code) {
      'ful medames' => l.onbFoodFul,
      'eggs' => l.onbFoodEggs,
      'chicken' => l.onbFoodChicken,
      'tuna' => l.onbFoodTuna,
      'rice' => l.onbFoodRice,
      'baladi bread' => l.onbFoodBaladiBread,
      'yogurt' => l.onbFoodYogurt,
      'cottage cheese' => l.onbFoodCottageCheese,
      'white cheese' => l.onbFoodWhiteCheese,
      'koshari' => l.onbFoodKoshari,
      'minced beef' => l.onbFoodMincedBeef,
      'fish' => l.onbFoodFish,
      'lentils' => l.onbFoodLentils,
      'taameya' => l.onbFoodTaameya,
      'oats' => l.onbFoodOats,
      'pasta' => l.onbFoodPasta,
      'potatoes' => l.onbFoodPotatoes,
      'sweet potato' => l.onbFoodSweetPotato,
      'milk' => l.onbFoodMilk,
      'peanut butter' => l.onbFoodPeanutButter,
      'bananas' => l.onbFoodBananas,
      'dates' => l.onbFoodDates,
      'liver' => l.onbFoodLiver,
      'molokhia' => l.onbFoodMolokhia,
      _ => code,
    };

String allergyLabel(AppLocalizations l, String code) => switch (code) {
      'lactose' => l.onbAllergyLactose,
      'gluten' => l.onbAllergyGluten,
      'nuts' => l.onbAllergyNuts,
      'peanuts' => l.onbAllergyPeanuts,
      'eggs' => l.onbAllergyEggs,
      'seafood' => l.onbAllergySeafood,
      _ => code,
    };

List<OnbOption<String>> budgetOptions(AppLocalizations l) => [
      OnbOption('low', l.onbBudgetLow, subtitle: l.onbBudgetLowSub, icon: Symbols.savings_rounded),
      OnbOption('medium', l.onbBudgetMedium, subtitle: l.onbBudgetMediumSub, icon: Symbols.account_balance_wallet_rounded),
      OnbOption('open', l.onbBudgetOpen, subtitle: l.onbBudgetOpenSub, icon: Symbols.all_inclusive_rounded),
      OnbOption('custom', l.onbBudgetCustom, subtitle: l.onbBudgetCustomSub, icon: Symbols.edit_rounded),
    ];

String supplementName(AppLocalizations l, String key) => switch (key) {
      'whey' => l.onbSuppWhey,
      'creatine' => l.onbSuppCreatine,
      'mass_gainer' => l.onbSuppMassGainer,
      'casein' => l.onbSuppCasein,
      'multivitamin' => l.onbSuppMultivitamin,
      'omega3' => l.onbSuppOmega3,
      'vitamin_d' => l.onbSuppVitaminD,
      'zma' => l.onbSuppZma,
      'bcaa' => l.onbSuppBcaa,
      'pre_workout' => l.onbSuppPreWorkout,
      'caffeine' => l.onbSuppCaffeine,
      _ => key,
    };

String supplementDefaultDose(AppLocalizations l, SupplementTemplate t) => switch (t.doseKind) {
      'scoop' => l.onbDoseScoop,
      'scoop_plain' => l.onbDoseScoopPlain,
      'gainer' => l.onbDoseGainer,
      'grams5' => l.onbDoseGrams('5'),
      'tablet' => l.onbDoseTablet,
      'capsule' => l.onbDoseCapsule,
      'mg200' => l.onbDoseMg('200'),
      _ => l.onbDoseServing,
    };
