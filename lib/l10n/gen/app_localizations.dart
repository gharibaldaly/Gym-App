import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @authTagline.
  ///
  /// In en, this message translates to:
  /// **'Sign in so your data is saved to your account and comes back on any phone.'**
  String get authTagline;

  /// No description provided for @authSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authSignIn;

  /// No description provided for @authSignUp.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get authSignUp;

  /// No description provided for @authEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmail;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authForgot.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get authForgot;

  /// No description provided for @authOr.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get authOr;

  /// No description provided for @authGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authGoogle;

  /// No description provided for @authEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email.'**
  String get authEmailInvalid;

  /// No description provided for @authPasswordShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters.'**
  String get authPasswordShort;

  /// No description provided for @authCheckEmail.
  ///
  /// In en, this message translates to:
  /// **'We sent a confirmation link to {email}. Open it, then sign in here.'**
  String authCheckEmail(String email);

  /// No description provided for @authResetSent.
  ///
  /// In en, this message translates to:
  /// **'We sent a password reset link to {email}.'**
  String authResetSent(String email);

  /// No description provided for @authEnterEmailFirst.
  ///
  /// In en, this message translates to:
  /// **'Enter your email first.'**
  String get authEnterEmailFirst;

  /// No description provided for @authErrInvalid.
  ///
  /// In en, this message translates to:
  /// **'Wrong email or password.'**
  String get authErrInvalid;

  /// No description provided for @authErrNotConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Your email isn\'t confirmed yet. Open the confirmation link we sent you.'**
  String get authErrNotConfirmed;

  /// No description provided for @authErrExists.
  ///
  /// In en, this message translates to:
  /// **'This email already has an account. Sign in instead.'**
  String get authErrExists;

  /// No description provided for @authErrWeak.
  ///
  /// In en, this message translates to:
  /// **'That password is too weak. Try a longer one.'**
  String get authErrWeak;

  /// No description provided for @authErrRate.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Wait a bit and try again.'**
  String get authErrRate;

  /// No description provided for @authErrNetwork.
  ///
  /// In en, this message translates to:
  /// **'No connection. Check your internet and try again.'**
  String get authErrNetwork;

  /// No description provided for @authErrGoogle.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in isn\'t available right now. Use email instead.'**
  String get authErrGoogle;

  /// No description provided for @authErrGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong: {error}'**
  String authErrGeneric(String error);

  /// No description provided for @authNewPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get authNewPasswordTitle;

  /// No description provided for @authPasswordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Password updated.'**
  String get authPasswordUpdated;

  /// No description provided for @cloudChecking.
  ///
  /// In en, this message translates to:
  /// **'Looking for your data…'**
  String get cloudChecking;

  /// No description provided for @cloudRestoring.
  ///
  /// In en, this message translates to:
  /// **'Restoring your data… {percent}%'**
  String cloudRestoring(int percent);

  /// No description provided for @cloudUploading.
  ///
  /// In en, this message translates to:
  /// **'Saving your data to your account… {percent}%'**
  String cloudUploading(int percent);

  /// No description provided for @cloudChooseTitle.
  ///
  /// In en, this message translates to:
  /// **'There\'s data on this phone and in your account'**
  String get cloudChooseTitle;

  /// No description provided for @cloudChooseBody.
  ///
  /// In en, this message translates to:
  /// **'Which one do you want to keep? The other one will be replaced.'**
  String get cloudChooseBody;

  /// No description provided for @cloudUseCloud.
  ///
  /// In en, this message translates to:
  /// **'Account data (last saved {date})'**
  String cloudUseCloud(String date);

  /// No description provided for @cloudUseDevice.
  ///
  /// In en, this message translates to:
  /// **'This phone\'s data'**
  String get cloudUseDevice;

  /// No description provided for @cloudOfflineTitle.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t reach your account'**
  String get cloudOfflineTitle;

  /// No description provided for @cloudOfflineBody.
  ///
  /// In en, this message translates to:
  /// **'Check your internet so we can bring your data back.'**
  String get cloudOfflineBody;

  /// No description provided for @cloudRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get cloudRetry;

  /// No description provided for @cloudContinueOffline.
  ///
  /// In en, this message translates to:
  /// **'Continue without it for now'**
  String get cloudContinueOffline;

  /// No description provided for @setAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get setAccountTitle;

  /// No description provided for @setAccountLastBackup.
  ///
  /// In en, this message translates to:
  /// **'Last saved to your account: {date}'**
  String setAccountLastBackup(String date);

  /// No description provided for @setAccountNeverBackedUp.
  ///
  /// In en, this message translates to:
  /// **'Not saved to your account yet.'**
  String get setAccountNeverBackedUp;

  /// No description provided for @setAccountBackupNow.
  ///
  /// In en, this message translates to:
  /// **'Save a copy now'**
  String get setAccountBackupNow;

  /// No description provided for @setAccountBackedUp.
  ///
  /// In en, this message translates to:
  /// **'Your data is saved to your account.'**
  String get setAccountBackedUp;

  /// No description provided for @setAccountSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get setAccountSignOut;

  /// No description provided for @setAccountSignOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'We\'ll save the latest copy of your data to your account, then sign you out. Your data stays on this phone too.'**
  String get setAccountSignOutConfirm;

  /// No description provided for @coachTabChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get coachTabChat;

  /// No description provided for @coachTabReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get coachTabReports;

  /// No description provided for @coachTabSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Suggestions'**
  String get coachTabSuggestions;

  /// No description provided for @coachMemoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Coach memory'**
  String get coachMemoryTitle;

  /// No description provided for @coachMemoryHint.
  ///
  /// In en, this message translates to:
  /// **'Facts the coach saved from your chats. They\'re sent with every message so he remembers you.'**
  String get coachMemoryHint;

  /// No description provided for @coachMemoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'The coach hasn\'t saved anything about you yet.'**
  String get coachMemoryEmpty;

  /// No description provided for @coachMemoryClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get coachMemoryClearAll;

  /// No description provided for @coachMemoryClearConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete everything the coach remembers about you?'**
  String get coachMemoryClearConfirm;

  /// No description provided for @coachMemoryDeleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get coachMemoryDeleted;

  /// No description provided for @coachInputHint.
  ///
  /// In en, this message translates to:
  /// **'Message your coach…'**
  String get coachInputHint;

  /// No description provided for @coachInputNoKey.
  ///
  /// In en, this message translates to:
  /// **'Add your API key to chat with the coach'**
  String get coachInputNoKey;

  /// No description provided for @coachSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get coachSend;

  /// No description provided for @coachVoice.
  ///
  /// In en, this message translates to:
  /// **'Voice input'**
  String get coachVoice;

  /// No description provided for @coachListening.
  ///
  /// In en, this message translates to:
  /// **'Listening…'**
  String get coachListening;

  /// No description provided for @coachVoiceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Voice input isn\'t available on this device'**
  String get coachVoiceUnavailable;

  /// No description provided for @coachOfflineNotice.
  ///
  /// In en, this message translates to:
  /// **'No internet. Your message is saved — tap Resend when you\'re back online.'**
  String get coachOfflineNotice;

  /// No description provided for @coachResend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get coachResend;

  /// No description provided for @coachThinking.
  ///
  /// In en, this message translates to:
  /// **'Coach is typing…'**
  String get coachThinking;

  /// No description provided for @coachEmptyChat.
  ///
  /// In en, this message translates to:
  /// **'Ask your coach anything: your plan, food, a pain — or tell him what you ate and he\'ll log it.'**
  String get coachEmptyChat;

  /// No description provided for @coachRefused.
  ///
  /// In en, this message translates to:
  /// **'The coach couldn\'t answer that. Try rephrasing.'**
  String get coachRefused;

  /// No description provided for @coachProposalWaiting.
  ///
  /// In en, this message translates to:
  /// **'I made a proposal — check the card below.'**
  String get coachProposalWaiting;

  /// No description provided for @coachKindMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get coachKindMorning;

  /// No description provided for @coachKindWorkoutSummary.
  ///
  /// In en, this message translates to:
  /// **'Workout summary'**
  String get coachKindWorkoutSummary;

  /// No description provided for @coachKindPlateau.
  ///
  /// In en, this message translates to:
  /// **'Plateau'**
  String get coachKindPlateau;

  /// No description provided for @coachKindWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly report'**
  String get coachKindWeekly;

  /// No description provided for @coachKindRecovery.
  ///
  /// In en, this message translates to:
  /// **'Recovery'**
  String get coachKindRecovery;

  /// No description provided for @coachAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get coachAccepted;

  /// No description provided for @coachRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get coachRejected;

  /// No description provided for @coachPending.
  ///
  /// In en, this message translates to:
  /// **'Waiting for you'**
  String get coachPending;

  /// No description provided for @coachAppliedSnack.
  ///
  /// In en, this message translates to:
  /// **'Done — change applied.'**
  String get coachAppliedSnack;

  /// No description provided for @coachRejectedSnack.
  ///
  /// In en, this message translates to:
  /// **'Proposal rejected.'**
  String get coachRejectedSnack;

  /// No description provided for @coachApplyFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t apply: {error}'**
  String coachApplyFailed(String error);

  /// No description provided for @coachNoPending.
  ///
  /// In en, this message translates to:
  /// **'No pending suggestions.'**
  String get coachNoPending;

  /// No description provided for @coachHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get coachHistory;

  /// No description provided for @coachReportsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No reports yet. Weekly reports arrive every Friday evening and workout summaries after each workout.'**
  String get coachReportsEmpty;

  /// No description provided for @coachGenerateWeekly.
  ///
  /// In en, this message translates to:
  /// **'Generate weekly report now'**
  String get coachGenerateWeekly;

  /// No description provided for @coachGenerating.
  ///
  /// In en, this message translates to:
  /// **'Generating…'**
  String get coachGenerating;

  /// No description provided for @coachWeeklyDone.
  ///
  /// In en, this message translates to:
  /// **'Weekly report is ready'**
  String get coachWeeklyDone;

  /// No description provided for @coachShowMore.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get coachShowMore;

  /// No description provided for @coachShowLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get coachShowLess;

  /// No description provided for @coachCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get coachCopy;

  /// No description provided for @coachCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get coachCopied;

  /// No description provided for @coachPropPlanChangeTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan change: {day}'**
  String coachPropPlanChangeTitle(String day);

  /// No description provided for @coachPropSwapTitle.
  ///
  /// In en, this message translates to:
  /// **'Swap {from} → {to}'**
  String coachPropSwapTitle(String from, String to);

  /// No description provided for @coachSwapScopeToday.
  ///
  /// In en, this message translates to:
  /// **'Today\'s workout only'**
  String get coachSwapScopeToday;

  /// No description provided for @coachSwapScopeAlways.
  ///
  /// In en, this message translates to:
  /// **'Permanently in the plan'**
  String get coachSwapScopeAlways;

  /// No description provided for @coachPropLogMealTitle.
  ///
  /// In en, this message translates to:
  /// **'Log meal: {name} ({kcal} kcal)'**
  String coachPropLogMealTitle(String name, int kcal);

  /// No description provided for @coachPropLogSetTitle.
  ///
  /// In en, this message translates to:
  /// **'Log set: {exercise} {weight} kg × {reps}'**
  String coachPropLogSetTitle(String exercise, String weight, int reps);

  /// No description provided for @coachPropMacrosTitle.
  ///
  /// In en, this message translates to:
  /// **'New daily target: {kcal} kcal'**
  String coachPropMacrosTitle(int kcal);

  /// No description provided for @coachMacroLine.
  ///
  /// In en, this message translates to:
  /// **'Protein {protein} g · Carbs {carbs} g · Fat {fat} g'**
  String coachMacroLine(int protein, int carbs, int fat);

  /// No description provided for @coachChangeAdd.
  ///
  /// In en, this message translates to:
  /// **'Add: {exercise} {detail}'**
  String coachChangeAdd(String exercise, String detail);

  /// No description provided for @coachChangeRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove: {exercise}'**
  String coachChangeRemove(String exercise);

  /// No description provided for @coachChangeModify.
  ///
  /// In en, this message translates to:
  /// **'Change: {exercise} → {detail}'**
  String coachChangeModify(String exercise, String detail);

  /// No description provided for @coachRestSeconds.
  ///
  /// In en, this message translates to:
  /// **'rest {seconds}s'**
  String coachRestSeconds(int seconds);

  /// No description provided for @coachPropRecoveryTitle.
  ///
  /// In en, this message translates to:
  /// **'Lighter workout today (recovery {score})'**
  String coachPropRecoveryTitle(int score);

  /// No description provided for @coachPropRecoveryDesc.
  ///
  /// In en, this message translates to:
  /// **'Weights −10% and one set less per exercise, today only.'**
  String get coachPropRecoveryDesc;

  /// No description provided for @coachRecoveryMessage.
  ///
  /// In en, this message translates to:
  /// **'Recovery today is **{score}/100** — low. I proposed a lighter session: −10% weight and one set less per exercise. Approve it from the card if you agree.'**
  String coachRecoveryMessage(int score);

  /// No description provided for @coachNotifMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning — your coach'**
  String get coachNotifMorning;

  /// No description provided for @coachNotifWorkout.
  ///
  /// In en, this message translates to:
  /// **'Workout summary is ready'**
  String get coachNotifWorkout;

  /// No description provided for @coachNotifPlateau.
  ///
  /// In en, this message translates to:
  /// **'Plateau: {exercise}'**
  String coachNotifPlateau(String exercise);

  /// No description provided for @coachNotifWeekly.
  ///
  /// In en, this message translates to:
  /// **'Your weekly report is ready'**
  String get coachNotifWeekly;

  /// No description provided for @coachNotifRecovery.
  ///
  /// In en, this message translates to:
  /// **'Low recovery today'**
  String get coachNotifRecovery;

  /// No description provided for @coachPropScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Change training schedule'**
  String get coachPropScheduleTitle;

  /// No description provided for @coachScheduleMove.
  ///
  /// In en, this message translates to:
  /// **'{day}: {from} → {to}'**
  String coachScheduleMove(String day, String from, String to);

  /// No description provided for @coachScheduleNone.
  ///
  /// In en, this message translates to:
  /// **'no day'**
  String get coachScheduleNone;

  /// No description provided for @coachPropProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Update your profile'**
  String get coachPropProfileTitle;

  /// No description provided for @coachProfileLine.
  ///
  /// In en, this message translates to:
  /// **'{field}: {value}'**
  String coachProfileLine(String field, String value);

  /// No description provided for @coachRecalcTargets.
  ///
  /// In en, this message translates to:
  /// **'Calorie and macro targets will be recalculated from this.'**
  String get coachRecalcTargets;

  /// No description provided for @coachFieldWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get coachFieldWeight;

  /// No description provided for @coachFieldTargetWeight.
  ///
  /// In en, this message translates to:
  /// **'Target weight'**
  String get coachFieldTargetWeight;

  /// No description provided for @coachFieldGoal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get coachFieldGoal;

  /// No description provided for @coachFieldLevel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get coachFieldLevel;

  /// No description provided for @coachFieldSessionMinutes.
  ///
  /// In en, this message translates to:
  /// **'Session length'**
  String get coachFieldSessionMinutes;

  /// No description provided for @coachFieldTrainingTime.
  ///
  /// In en, this message translates to:
  /// **'Training time'**
  String get coachFieldTrainingTime;

  /// No description provided for @coachFieldWakeTime.
  ///
  /// In en, this message translates to:
  /// **'Wake-up time'**
  String get coachFieldWakeTime;

  /// No description provided for @coachFieldSleepTime.
  ///
  /// In en, this message translates to:
  /// **'Bedtime'**
  String get coachFieldSleepTime;

  /// No description provided for @coachFieldMealTimes.
  ///
  /// In en, this message translates to:
  /// **'Meal times'**
  String get coachFieldMealTimes;

  /// No description provided for @coachFieldLikedFoods.
  ///
  /// In en, this message translates to:
  /// **'Foods you like'**
  String get coachFieldLikedFoods;

  /// No description provided for @coachFieldDislikedFoods.
  ///
  /// In en, this message translates to:
  /// **'Foods you dislike'**
  String get coachFieldDislikedFoods;

  /// No description provided for @coachFieldAllergies.
  ///
  /// In en, this message translates to:
  /// **'Allergies'**
  String get coachFieldAllergies;

  /// No description provided for @coachFieldInjuries.
  ///
  /// In en, this message translates to:
  /// **'Injuries'**
  String get coachFieldInjuries;

  /// No description provided for @coachFieldWater.
  ///
  /// In en, this message translates to:
  /// **'Water goal'**
  String get coachFieldWater;

  /// No description provided for @coachFieldLocation.
  ///
  /// In en, this message translates to:
  /// **'Training location'**
  String get coachFieldLocation;

  /// No description provided for @coachMinutes.
  ///
  /// In en, this message translates to:
  /// **'{n} min'**
  String coachMinutes(int n);

  /// No description provided for @coachPropNewWorkoutPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'New workout plan'**
  String get coachPropNewWorkoutPlanTitle;

  /// No description provided for @coachPropNewMealPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'New meal plan'**
  String get coachPropNewMealPlanTitle;

  /// No description provided for @coachNewWorkoutPlanNote.
  ///
  /// In en, this message translates to:
  /// **'When you approve, the new plan is built (can take a minute or two) and you review it before it goes live.'**
  String get coachNewWorkoutPlanNote;

  /// No description provided for @coachNewMealPlanNote.
  ///
  /// In en, this message translates to:
  /// **'When you approve, the new meal plan is built (can take a minute) and becomes active right away.'**
  String get coachNewMealPlanNote;

  /// No description provided for @coachBuildingPlan.
  ///
  /// In en, this message translates to:
  /// **'Building the plan… you can lock the screen.'**
  String get coachBuildingPlan;

  /// No description provided for @coachWorkoutPlanReady.
  ///
  /// In en, this message translates to:
  /// **'The new plan is ready. Review and activate it.'**
  String get coachWorkoutPlanReady;

  /// No description provided for @coachMealPlanReady.
  ///
  /// In en, this message translates to:
  /// **'The new meal plan is active.'**
  String get coachMealPlanReady;

  /// No description provided for @coachFieldTrainingDays.
  ///
  /// In en, this message translates to:
  /// **'Training days'**
  String get coachFieldTrainingDays;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'IronMind'**
  String get appName;

  /// No description provided for @tabToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get tabToday;

  /// No description provided for @tabWorkout.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get tabWorkout;

  /// No description provided for @tabFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get tabFood;

  /// No description provided for @tabCoach.
  ///
  /// In en, this message translates to:
  /// **'Coach'**
  String get tabCoach;

  /// No description provided for @tabProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get tabProgress;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorGeneric;

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternet;

  /// No description provided for @noApiKeyTitle.
  ///
  /// In en, this message translates to:
  /// **'AI is off'**
  String get noApiKeyTitle;

  /// No description provided for @noApiKeyBody.
  ///
  /// In en, this message translates to:
  /// **'Add your Claude API key in Settings to enable AI features. Everything else works without it.'**
  String get noApiKeyBody;

  /// No description provided for @addApiKey.
  ///
  /// In en, this message translates to:
  /// **'Add API key'**
  String get addApiKey;

  /// No description provided for @aiQueuedOffline.
  ///
  /// In en, this message translates to:
  /// **'Saved. The AI will process it when you\'re back online.'**
  String get aiQueuedOffline;

  /// No description provided for @kg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get kg;

  /// No description provided for @cm.
  ///
  /// In en, this message translates to:
  /// **'cm'**
  String get cm;

  /// No description provided for @kcal.
  ///
  /// In en, this message translates to:
  /// **'kcal'**
  String get kcal;

  /// No description provided for @gramsShort.
  ///
  /// In en, this message translates to:
  /// **'g'**
  String get gramsShort;

  /// No description provided for @mlShort.
  ///
  /// In en, this message translates to:
  /// **'ml'**
  String get mlShort;

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minutesShort;

  /// No description provided for @hoursShort.
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get hoursShort;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @empty.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get empty;

  /// No description provided for @protein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get protein;

  /// No description provided for @carbs.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get carbs;

  /// No description provided for @fat.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get fat;

  /// No description provided for @calories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get calories;

  /// No description provided for @water.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get water;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @weekdayMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get weekdayMon;

  /// No description provided for @weekdayTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get weekdayTue;

  /// No description provided for @weekdayWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get weekdayWed;

  /// No description provided for @weekdayThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get weekdayThu;

  /// No description provided for @weekdayFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get weekdayFri;

  /// No description provided for @weekdaySat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get weekdaySat;

  /// No description provided for @weekdaySun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get weekdaySun;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @bgWorkChannel.
  ///
  /// In en, this message translates to:
  /// **'Background work'**
  String get bgWorkChannel;

  /// No description provided for @bgWorkTitle.
  ///
  /// In en, this message translates to:
  /// **'IronMind is finishing your request'**
  String get bgWorkTitle;

  /// No description provided for @bgWorkBody.
  ///
  /// In en, this message translates to:
  /// **'You can lock the screen or leave the app; it will keep going.'**
  String get bgWorkBody;

  /// No description provided for @aiConnectionLost.
  ///
  /// In en, this message translates to:
  /// **'The connection dropped before the request finished. Try again.'**
  String get aiConnectionLost;

  /// No description provided for @exLibraryTitle.
  ///
  /// In en, this message translates to:
  /// **'Exercise library'**
  String get exLibraryTitle;

  /// No description provided for @exPickTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose an exercise'**
  String get exPickTitle;

  /// No description provided for @exSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search in Arabic or English'**
  String get exSearchHint;

  /// No description provided for @exAllMuscles.
  ///
  /// In en, this message translates to:
  /// **'All muscles'**
  String get exAllMuscles;

  /// No description provided for @exAllEquipment.
  ///
  /// In en, this message translates to:
  /// **'All equipment'**
  String get exAllEquipment;

  /// No description provided for @exMuscleFilter.
  ///
  /// In en, this message translates to:
  /// **'Muscle'**
  String get exMuscleFilter;

  /// No description provided for @exEquipmentFilter.
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get exEquipmentFilter;

  /// No description provided for @exFavoritesOnly.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get exFavoritesOnly;

  /// No description provided for @exMyCustom.
  ///
  /// In en, this message translates to:
  /// **'My exercises'**
  String get exMyCustom;

  /// No description provided for @exClearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get exClearFilters;

  /// No description provided for @exResultsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 exercise} other{{count} exercises}}'**
  String exResultsCount(int count);

  /// No description provided for @exNoResults.
  ///
  /// In en, this message translates to:
  /// **'No exercises match your search.'**
  String get exNoResults;

  /// No description provided for @exAddWithAi.
  ///
  /// In en, this message translates to:
  /// **'Add with AI'**
  String get exAddWithAi;

  /// No description provided for @exFavoriteAdd.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get exFavoriteAdd;

  /// No description provided for @exFavoriteRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get exFavoriteRemove;

  /// No description provided for @exCustomBadge.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get exCustomBadge;

  /// No description provided for @exBodyFront.
  ///
  /// In en, this message translates to:
  /// **'Front'**
  String get exBodyFront;

  /// No description provided for @exBodyBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get exBodyBack;

  /// No description provided for @exPrimaryMuscles.
  ///
  /// In en, this message translates to:
  /// **'Primary muscles'**
  String get exPrimaryMuscles;

  /// No description provided for @exSecondaryMuscles.
  ///
  /// In en, this message translates to:
  /// **'Secondary muscles'**
  String get exSecondaryMuscles;

  /// No description provided for @exMusclesWorked.
  ///
  /// In en, this message translates to:
  /// **'Muscles worked'**
  String get exMusclesWorked;

  /// No description provided for @exHowTo.
  ///
  /// In en, this message translates to:
  /// **'How to do it'**
  String get exHowTo;

  /// No description provided for @exCommonMistakes.
  ///
  /// In en, this message translates to:
  /// **'Common mistakes'**
  String get exCommonMistakes;

  /// No description provided for @exNoInstructions.
  ///
  /// In en, this message translates to:
  /// **'No instructions yet.'**
  String get exNoInstructions;

  /// No description provided for @exImageOffline.
  ///
  /// In en, this message translates to:
  /// **'Image not downloaded yet. Open it once with internet to keep it offline.'**
  String get exImageOffline;

  /// No description provided for @exStepOf.
  ///
  /// In en, this message translates to:
  /// **'{current}/{total}'**
  String exStepOf(int current, int total);

  /// No description provided for @exYourHistory.
  ///
  /// In en, this message translates to:
  /// **'Your history'**
  String get exYourHistory;

  /// No description provided for @exNoHistory.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t logged this exercise yet.'**
  String get exNoHistory;

  /// No description provided for @exLastPerformance.
  ///
  /// In en, this message translates to:
  /// **'Last time'**
  String get exLastPerformance;

  /// No description provided for @exPersonalRecords.
  ///
  /// In en, this message translates to:
  /// **'Personal records'**
  String get exPersonalRecords;

  /// No description provided for @exHeaviest.
  ///
  /// In en, this message translates to:
  /// **'Heaviest weight'**
  String get exHeaviest;

  /// No description provided for @exBestE1rm.
  ///
  /// In en, this message translates to:
  /// **'Best est. 1RM'**
  String get exBestE1rm;

  /// No description provided for @exRepRecords.
  ///
  /// In en, this message translates to:
  /// **'Most reps at each weight'**
  String get exRepRecords;

  /// No description provided for @exSetLine.
  ///
  /// In en, this message translates to:
  /// **'{weight} kg × {reps}'**
  String exSetLine(String weight, int reps);

  /// No description provided for @exKgValue.
  ///
  /// In en, this message translates to:
  /// **'{value} kg'**
  String exKgValue(String value);

  /// No description provided for @exSessionVolume.
  ///
  /// In en, this message translates to:
  /// **'Volume: {volume} kg'**
  String exSessionVolume(String volume);

  /// No description provided for @exProgressChart.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get exProgressChart;

  /// No description provided for @exChartE1rm.
  ///
  /// In en, this message translates to:
  /// **'Est. 1RM'**
  String get exChartE1rm;

  /// No description provided for @exChartTopWeight.
  ///
  /// In en, this message translates to:
  /// **'Top weight'**
  String get exChartTopWeight;

  /// No description provided for @exChartNeedMore.
  ///
  /// In en, this message translates to:
  /// **'Log this exercise in at least 2 sessions to see your progress chart.'**
  String get exChartNeedMore;

  /// No description provided for @exEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get exEdit;

  /// No description provided for @exDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete exercise'**
  String get exDelete;

  /// No description provided for @exDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this custom exercise?'**
  String get exDeleteConfirm;

  /// No description provided for @exDeleteInUse.
  ///
  /// In en, this message translates to:
  /// **'Can\'t delete: this exercise is used in your logs or plan.'**
  String get exDeleteInUse;

  /// No description provided for @exDeleted.
  ///
  /// In en, this message translates to:
  /// **'Exercise deleted'**
  String get exDeleted;

  /// No description provided for @exNotFound.
  ///
  /// In en, this message translates to:
  /// **'Exercise not found'**
  String get exNotFound;

  /// No description provided for @exAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add exercise'**
  String get exAddTitle;

  /// No description provided for @exEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit exercise'**
  String get exEditTitle;

  /// No description provided for @exReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review & edit'**
  String get exReviewTitle;

  /// No description provided for @exDescribeTitle.
  ///
  /// In en, this message translates to:
  /// **'Describe the exercise'**
  String get exDescribeTitle;

  /// No description provided for @exDescribeHint.
  ///
  /// In en, this message translates to:
  /// **'In your own words, e.g. \"machine where I sit and push two handles forward for chest\"'**
  String get exDescribeHint;

  /// No description provided for @exVoiceStart.
  ///
  /// In en, this message translates to:
  /// **'Speak'**
  String get exVoiceStart;

  /// No description provided for @exVoiceListening.
  ///
  /// In en, this message translates to:
  /// **'Listening…'**
  String get exVoiceListening;

  /// No description provided for @exVoiceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Voice input isn\'t available on this device.'**
  String get exVoiceUnavailable;

  /// No description provided for @exPhotoOptional.
  ///
  /// In en, this message translates to:
  /// **'Photo of the machine (optional)'**
  String get exPhotoOptional;

  /// No description provided for @exPhotoCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get exPhotoCamera;

  /// No description provided for @exPhotoGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get exPhotoGallery;

  /// No description provided for @exPhotoRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get exPhotoRemove;

  /// No description provided for @exPhotoError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the photo.'**
  String get exPhotoError;

  /// No description provided for @exContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get exContinue;

  /// No description provided for @exCreateWithAi.
  ///
  /// In en, this message translates to:
  /// **'Create with AI'**
  String get exCreateWithAi;

  /// No description provided for @exFillManually.
  ///
  /// In en, this message translates to:
  /// **'Fill in manually'**
  String get exFillManually;

  /// No description provided for @exAiOffManual.
  ///
  /// In en, this message translates to:
  /// **'AI is off — you can still add the exercise manually.'**
  String get exAiOffManual;

  /// No description provided for @exDescribeFirst.
  ///
  /// In en, this message translates to:
  /// **'Describe the exercise or add a photo first.'**
  String get exDescribeFirst;

  /// No description provided for @exDidYouMean.
  ///
  /// In en, this message translates to:
  /// **'Did you mean…?'**
  String get exDidYouMean;

  /// No description provided for @exDidYouMeanBody.
  ///
  /// In en, this message translates to:
  /// **'These exercises are already in the library. Use one instead of creating a duplicate.'**
  String get exDidYouMeanBody;

  /// No description provided for @exUseExisting.
  ///
  /// In en, this message translates to:
  /// **'Use'**
  String get exUseExisting;

  /// No description provided for @exCreateNewAnyway.
  ///
  /// In en, this message translates to:
  /// **'No, create a new one'**
  String get exCreateNewAnyway;

  /// No description provided for @exAiWorking.
  ///
  /// In en, this message translates to:
  /// **'Claude is building the exercise…'**
  String get exAiWorking;

  /// No description provided for @exAiSimilarFound.
  ///
  /// In en, this message translates to:
  /// **'This looks like an exercise you already have:'**
  String get exAiSimilarFound;

  /// No description provided for @exNameEn.
  ///
  /// In en, this message translates to:
  /// **'Name (English)'**
  String get exNameEn;

  /// No description provided for @exNameAr.
  ///
  /// In en, this message translates to:
  /// **'Name (Arabic)'**
  String get exNameAr;

  /// No description provided for @exFieldEquipment.
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get exFieldEquipment;

  /// No description provided for @exFieldForce.
  ///
  /// In en, this message translates to:
  /// **'Force'**
  String get exFieldForce;

  /// No description provided for @exFieldMechanic.
  ///
  /// In en, this message translates to:
  /// **'Compound / isolation'**
  String get exFieldMechanic;

  /// No description provided for @exFieldCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get exFieldCategory;

  /// No description provided for @exNone.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get exNone;

  /// No description provided for @exStepsEn.
  ///
  /// In en, this message translates to:
  /// **'Steps (English)'**
  String get exStepsEn;

  /// No description provided for @exStepsAr.
  ///
  /// In en, this message translates to:
  /// **'Steps (Arabic)'**
  String get exStepsAr;

  /// No description provided for @exMistakesEn.
  ///
  /// In en, this message translates to:
  /// **'Common mistakes (English)'**
  String get exMistakesEn;

  /// No description provided for @exMistakesAr.
  ///
  /// In en, this message translates to:
  /// **'Common mistakes (Arabic)'**
  String get exMistakesAr;

  /// No description provided for @exOnePerLine.
  ///
  /// In en, this message translates to:
  /// **'One per line'**
  String get exOnePerLine;

  /// No description provided for @exNeedNameAndMuscle.
  ///
  /// In en, this message translates to:
  /// **'Add a name and at least one primary muscle.'**
  String get exNeedNameAndMuscle;

  /// No description provided for @exSave.
  ///
  /// In en, this message translates to:
  /// **'Save exercise'**
  String get exSave;

  /// No description provided for @exSaved.
  ///
  /// In en, this message translates to:
  /// **'Exercise saved'**
  String get exSaved;

  /// No description provided for @exOfflineTitle.
  ///
  /// In en, this message translates to:
  /// **'Offline exercise images'**
  String get exOfflineTitle;

  /// No description provided for @exOfflineBody.
  ///
  /// In en, this message translates to:
  /// **'Download the step images of all exercises so they show without internet (about {mb} MB). Images you open are also kept automatically.'**
  String exOfflineBody(int mb);

  /// No description provided for @exOfflineWifiTip.
  ///
  /// In en, this message translates to:
  /// **'Tip: use Wi-Fi — the pack is large.'**
  String get exOfflineWifiTip;

  /// No description provided for @exOfflineStart.
  ///
  /// In en, this message translates to:
  /// **'Download all'**
  String get exOfflineStart;

  /// No description provided for @exOfflineCancel.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get exOfflineCancel;

  /// No description provided for @exOfflineClear.
  ///
  /// In en, this message translates to:
  /// **'Delete downloaded images'**
  String get exOfflineClear;

  /// No description provided for @exOfflineClearConfirm.
  ///
  /// In en, this message translates to:
  /// **'Exercise images will need internet again until re-downloaded.'**
  String get exOfflineClearConfirm;

  /// No description provided for @exOfflineCleared.
  ///
  /// In en, this message translates to:
  /// **'Downloaded images deleted'**
  String get exOfflineCleared;

  /// No description provided for @exOfflineProgress.
  ///
  /// In en, this message translates to:
  /// **'{done} / {total}'**
  String exOfflineProgress(int done, int total);

  /// No description provided for @exOfflineCached.
  ///
  /// In en, this message translates to:
  /// **'{cached} of {total} images saved'**
  String exOfflineCached(int cached, int total);

  /// No description provided for @exOfflineFailed.
  ///
  /// In en, this message translates to:
  /// **'{count} failed — try again later'**
  String exOfflineFailed(int count);

  /// No description provided for @exOfflineDone.
  ///
  /// In en, this message translates to:
  /// **'All exercise images are available offline'**
  String get exOfflineDone;

  /// No description provided for @exOfflineChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking saved images…'**
  String get exOfflineChecking;

  /// No description provided for @exOfflineNeedsInternet.
  ///
  /// In en, this message translates to:
  /// **'Connect to the internet to download.'**
  String get exOfflineNeedsInternet;

  /// No description provided for @nutTitle.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get nutTitle;

  /// No description provided for @nutTabToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get nutTabToday;

  /// No description provided for @nutTabPlan.
  ///
  /// In en, this message translates to:
  /// **'Meal plan'**
  String get nutTabPlan;

  /// No description provided for @nutTabShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get nutTabShopping;

  /// No description provided for @nutTodayTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s calories'**
  String get nutTodayTitle;

  /// No description provided for @nutTrainingDay.
  ///
  /// In en, this message translates to:
  /// **'Training day'**
  String get nutTrainingDay;

  /// No description provided for @nutRestDay.
  ///
  /// In en, this message translates to:
  /// **'Rest day'**
  String get nutRestDay;

  /// No description provided for @nutNoTargets.
  ///
  /// In en, this message translates to:
  /// **'No calorie targets yet. Finish your profile to get your daily numbers.'**
  String get nutNoTargets;

  /// No description provided for @nutKcalLeft.
  ///
  /// In en, this message translates to:
  /// **'kcal left'**
  String get nutKcalLeft;

  /// No description provided for @nutKcalOver.
  ///
  /// In en, this message translates to:
  /// **'kcal over'**
  String get nutKcalOver;

  /// No description provided for @nutRemainingMacros.
  ///
  /// In en, this message translates to:
  /// **'Left: protein {protein} g · carbs {carbs} g · fat {fat} g'**
  String nutRemainingMacros(String protein, String carbs, String fat);

  /// No description provided for @nutFromSupplements.
  ///
  /// In en, this message translates to:
  /// **'Incl. supplements: {protein} g protein · {kcal} kcal'**
  String nutFromSupplements(String protein, String kcal);

  /// No description provided for @nutMacroLine.
  ///
  /// In en, this message translates to:
  /// **'{kcal} kcal · P {protein} · C {carbs} · F {fat}'**
  String nutMacroLine(String kcal, String protein, String carbs, String fat);

  /// No description provided for @nutProteinShort.
  ///
  /// In en, this message translates to:
  /// **'P'**
  String get nutProteinShort;

  /// No description provided for @nutCarbsShort.
  ///
  /// In en, this message translates to:
  /// **'C'**
  String get nutCarbsShort;

  /// No description provided for @nutFatShort.
  ///
  /// In en, this message translates to:
  /// **'F'**
  String get nutFatShort;

  /// No description provided for @nutPendingCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 meal waiting for AI analysis} other{{count} meals waiting for AI analysis}}'**
  String nutPendingCount(int count);

  /// No description provided for @nutPendingNoKey.
  ///
  /// In en, this message translates to:
  /// **'Add your Claude API key and they will be analyzed automatically.'**
  String get nutPendingNoKey;

  /// No description provided for @nutPendingOffline.
  ///
  /// In en, this message translates to:
  /// **'They\'ll be analyzed when you\'re back online.'**
  String get nutPendingOffline;

  /// No description provided for @nutPendingWorking.
  ///
  /// In en, this message translates to:
  /// **'Analyzing in the background…'**
  String get nutPendingWorking;

  /// No description provided for @nutMealsTitle.
  ///
  /// In en, this message translates to:
  /// **'Meals: planned vs eaten'**
  String get nutMealsTitle;

  /// No description provided for @nutNoPlanToday.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have a meal plan yet. Create one to see your meals here.'**
  String get nutNoPlanToday;

  /// No description provided for @nutOpenPlan.
  ///
  /// In en, this message translates to:
  /// **'Open meal plan'**
  String get nutOpenPlan;

  /// No description provided for @nutPlannedLine.
  ///
  /// In en, this message translates to:
  /// **'Planned: {macros}'**
  String nutPlannedLine(String macros);

  /// No description provided for @nutEatenLine.
  ///
  /// In en, this message translates to:
  /// **'Eaten: {macros}'**
  String nutEatenLine(String macros);

  /// No description provided for @nutAteAsPlanned.
  ///
  /// In en, this message translates to:
  /// **'Ate it as planned'**
  String get nutAteAsPlanned;

  /// No description provided for @nutAteHalf.
  ///
  /// In en, this message translates to:
  /// **'Ate half of it'**
  String get nutAteHalf;

  /// No description provided for @nutAteDifferent.
  ///
  /// In en, this message translates to:
  /// **'Ate something different'**
  String get nutAteDifferent;

  /// No description provided for @nutLoggedMeal.
  ///
  /// In en, this message translates to:
  /// **'Logged: {name}'**
  String nutLoggedMeal(String name);

  /// No description provided for @nutUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get nutUndo;

  /// No description provided for @nutLoggedTitle.
  ///
  /// In en, this message translates to:
  /// **'Logged today'**
  String get nutLoggedTitle;

  /// No description provided for @nutNothingLogged.
  ///
  /// In en, this message translates to:
  /// **'Nothing logged yet. Tap + to log a meal.'**
  String get nutNothingLogged;

  /// No description provided for @nutWaitingForAi.
  ///
  /// In en, this message translates to:
  /// **'Waiting for AI analysis'**
  String get nutWaitingForAi;

  /// No description provided for @nutConfidence.
  ///
  /// In en, this message translates to:
  /// **'AI confidence {percent}%'**
  String nutConfidence(int percent);

  /// No description provided for @nutSavedToMyFoods.
  ///
  /// In en, this message translates to:
  /// **'Saved to My foods'**
  String get nutSavedToMyFoods;

  /// No description provided for @nutAnalyzeNow.
  ///
  /// In en, this message translates to:
  /// **'Analyze now'**
  String get nutAnalyzeNow;

  /// No description provided for @nutDeleted.
  ///
  /// In en, this message translates to:
  /// **'Meal deleted'**
  String get nutDeleted;

  /// No description provided for @nutSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get nutSaved;

  /// No description provided for @nutSupplementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Supplements today'**
  String get nutSupplementsTitle;

  /// No description provided for @nutNoSupplementsToday.
  ///
  /// In en, this message translates to:
  /// **'No supplements ticked today. Mark them in the Today tab and their protein/calories count here.'**
  String get nutNoSupplementsToday;

  /// No description provided for @nutSupplementMacros.
  ///
  /// In en, this message translates to:
  /// **'{protein} g protein · {kcal} kcal'**
  String nutSupplementMacros(String protein, String kcal);

  /// No description provided for @nutNoMacros.
  ///
  /// In en, this message translates to:
  /// **'no calories'**
  String get nutNoMacros;

  /// No description provided for @nutLogFood.
  ///
  /// In en, this message translates to:
  /// **'Log food'**
  String get nutLogFood;

  /// No description provided for @nutLogPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get nutLogPhoto;

  /// No description provided for @nutLogPhotoHint.
  ///
  /// In en, this message translates to:
  /// **'Snap your plate, the AI estimates it'**
  String get nutLogPhotoHint;

  /// No description provided for @nutLogText.
  ///
  /// In en, this message translates to:
  /// **'Type or say it'**
  String get nutLogText;

  /// No description provided for @nutLogTextHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. \"a medium koshary and two eggs\"'**
  String get nutLogTextHint;

  /// No description provided for @nutMyFoods.
  ///
  /// In en, this message translates to:
  /// **'My foods'**
  String get nutMyFoods;

  /// No description provided for @nutMyFoodsHint.
  ///
  /// In en, this message translates to:
  /// **'One tap, no AI, works offline'**
  String get nutMyFoodsHint;

  /// No description provided for @nutLogManual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get nutLogManual;

  /// No description provided for @nutLogManualHint.
  ///
  /// In en, this message translates to:
  /// **'Pick from Egyptian foods + grams'**
  String get nutLogManualHint;

  /// No description provided for @nutLogged.
  ///
  /// In en, this message translates to:
  /// **'Meal logged'**
  String get nutLogged;

  /// No description provided for @nutTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get nutTakePhoto;

  /// No description provided for @nutFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get nutFromGallery;

  /// No description provided for @nutPhotoError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the camera or gallery.'**
  String get nutPhotoError;

  /// No description provided for @nutPhotoMealName.
  ///
  /// In en, this message translates to:
  /// **'Meal photo'**
  String get nutPhotoMealName;

  /// No description provided for @nutQueuedNoKey.
  ///
  /// In en, this message translates to:
  /// **'Saved with the photo. Add your API key in Settings and it will be analyzed.'**
  String get nutQueuedNoKey;

  /// No description provided for @nutAnalyzingPhoto.
  ///
  /// In en, this message translates to:
  /// **'Analyzing your plate…'**
  String get nutAnalyzingPhoto;

  /// No description provided for @nutAnalysisFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t analyze it'**
  String get nutAnalysisFailed;

  /// No description provided for @nutLogManually.
  ///
  /// In en, this message translates to:
  /// **'Log manually'**
  String get nutLogManually;

  /// No description provided for @nutAnalyzeLater.
  ///
  /// In en, this message translates to:
  /// **'Save & analyze later'**
  String get nutAnalyzeLater;

  /// No description provided for @nutReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review meal'**
  String get nutReviewTitle;

  /// No description provided for @nutEditMeal.
  ///
  /// In en, this message translates to:
  /// **'Edit meal'**
  String get nutEditMeal;

  /// No description provided for @nutReviewHint.
  ///
  /// In en, this message translates to:
  /// **'Check the amounts — changing grams updates the macros.'**
  String get nutReviewHint;

  /// No description provided for @nutMealName.
  ///
  /// In en, this message translates to:
  /// **'Meal name'**
  String get nutMealName;

  /// No description provided for @nutWhichMeal.
  ///
  /// In en, this message translates to:
  /// **'Which meal?'**
  String get nutWhichMeal;

  /// No description provided for @nutOtherMeal.
  ///
  /// In en, this message translates to:
  /// **'Snack / outside the plan'**
  String get nutOtherMeal;

  /// No description provided for @nutMealNumber.
  ///
  /// In en, this message translates to:
  /// **'Meal {number}'**
  String nutMealNumber(int number);

  /// No description provided for @nutItems.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get nutItems;

  /// No description provided for @nutAddFood.
  ///
  /// In en, this message translates to:
  /// **'Add food'**
  String get nutAddFood;

  /// No description provided for @nutNoItemsDetected.
  ///
  /// In en, this message translates to:
  /// **'The AI found no food. Add the items yourself.'**
  String get nutNoItemsDetected;

  /// No description provided for @nutNoItemsYet.
  ///
  /// In en, this message translates to:
  /// **'No items yet. Add a food from the list.'**
  String get nutNoItemsYet;

  /// No description provided for @nutItemName.
  ///
  /// In en, this message translates to:
  /// **'Item name'**
  String get nutItemName;

  /// No description provided for @nutGrams.
  ///
  /// In en, this message translates to:
  /// **'Grams'**
  String get nutGrams;

  /// No description provided for @nutTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get nutTotal;

  /// No description provided for @nutSaveToMyFoods.
  ///
  /// In en, this message translates to:
  /// **'Save to My foods'**
  String get nutSaveToMyFoods;

  /// No description provided for @nutSaveToMyFoodsHint.
  ///
  /// In en, this message translates to:
  /// **'Log it again later with one tap, without AI'**
  String get nutSaveToMyFoodsHint;

  /// No description provided for @nutSaveMeal.
  ///
  /// In en, this message translates to:
  /// **'Save meal'**
  String get nutSaveMeal;

  /// No description provided for @nutAddAtLeastOne.
  ///
  /// In en, this message translates to:
  /// **'Add at least one item.'**
  String get nutAddAtLeastOne;

  /// No description provided for @nutSearchFoods.
  ///
  /// In en, this message translates to:
  /// **'Search foods (فول، rice…)'**
  String get nutSearchFoods;

  /// No description provided for @nutNoFoodsFound.
  ///
  /// In en, this message translates to:
  /// **'No foods found'**
  String get nutNoFoodsFound;

  /// No description provided for @nutPer100g.
  ///
  /// In en, this message translates to:
  /// **'Per 100 g: {macros}'**
  String nutPer100g(String macros);

  /// No description provided for @nutTextPrompt.
  ///
  /// In en, this message translates to:
  /// **'What did you eat?'**
  String get nutTextPrompt;

  /// No description provided for @nutTextHintExample.
  ///
  /// In en, this message translates to:
  /// **'a medium koshary plate and two eggs'**
  String get nutTextHintExample;

  /// No description provided for @nutSpeak.
  ///
  /// In en, this message translates to:
  /// **'Speak'**
  String get nutSpeak;

  /// No description provided for @nutStopListening.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get nutStopListening;

  /// No description provided for @nutListening.
  ///
  /// In en, this message translates to:
  /// **'Listening…'**
  String get nutListening;

  /// No description provided for @nutTapToSpeak.
  ///
  /// In en, this message translates to:
  /// **'Tap the mic and say what you ate'**
  String get nutTapToSpeak;

  /// No description provided for @nutSpeechUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Voice input is not available on this device.'**
  String get nutSpeechUnavailable;

  /// No description provided for @nutAnalyze.
  ///
  /// In en, this message translates to:
  /// **'Analyze with AI'**
  String get nutAnalyze;

  /// No description provided for @nutAnalyzing.
  ///
  /// In en, this message translates to:
  /// **'Analyzing…'**
  String get nutAnalyzing;

  /// No description provided for @nutMyFoodsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Meals you log are saved here so you can log them again with one tap.'**
  String get nutMyFoodsEmpty;

  /// No description provided for @nutMyFoodsTapHint.
  ///
  /// In en, this message translates to:
  /// **'Tap to log · hold for portion & options'**
  String get nutMyFoodsTapHint;

  /// No description provided for @nutUsedTimes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Used once} other{Used {count} times}}'**
  String nutUsedTimes(int count);

  /// No description provided for @nutMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get nutMore;

  /// No description provided for @nutHalfPortion.
  ///
  /// In en, this message translates to:
  /// **'Half portion'**
  String get nutHalfPortion;

  /// No description provided for @nutFullPortion.
  ///
  /// In en, this message translates to:
  /// **'Full portion'**
  String get nutFullPortion;

  /// No description provided for @nutOneAndHalfPortion.
  ///
  /// In en, this message translates to:
  /// **'1.5 portions'**
  String get nutOneAndHalfPortion;

  /// No description provided for @nutDoublePortion.
  ///
  /// In en, this message translates to:
  /// **'Double portion'**
  String get nutDoublePortion;

  /// No description provided for @nutFavorite.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get nutFavorite;

  /// No description provided for @nutUnfavorite.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get nutUnfavorite;

  /// No description provided for @nutNoPlan.
  ///
  /// In en, this message translates to:
  /// **'No meal plan yet. The AI builds one with Egyptian food that fits your macros, budget and taste.'**
  String get nutNoPlan;

  /// No description provided for @nutGeneratePlan.
  ///
  /// In en, this message translates to:
  /// **'Build my meal plan'**
  String get nutGeneratePlan;

  /// No description provided for @nutUseBasicPlan.
  ///
  /// In en, this message translates to:
  /// **'Use a basic offline plan'**
  String get nutUseBasicPlan;

  /// No description provided for @nutGeneratingPlan.
  ///
  /// In en, this message translates to:
  /// **'Building your meal plan… this can take a minute.'**
  String get nutGeneratingPlan;

  /// No description provided for @nutBuildingPlan.
  ///
  /// In en, this message translates to:
  /// **'Building a basic plan…'**
  String get nutBuildingPlan;

  /// No description provided for @nutPlanReady.
  ///
  /// In en, this message translates to:
  /// **'Your new meal plan is ready'**
  String get nutPlanReady;

  /// No description provided for @nutBasicPlanReady.
  ///
  /// In en, this message translates to:
  /// **'Basic plan ready'**
  String get nutBasicPlanReady;

  /// No description provided for @nutPlanFallback.
  ///
  /// In en, this message translates to:
  /// **'No AI right now, so we built a basic plan from Egyptian foods.'**
  String get nutPlanFallback;

  /// No description provided for @nutPlanFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t build the plan'**
  String get nutPlanFailed;

  /// No description provided for @nutTemplatePlanNote.
  ///
  /// In en, this message translates to:
  /// **'Basic plan built offline from the built-in food table. Regenerate with AI for a personalized plan.'**
  String get nutTemplatePlanNote;

  /// No description provided for @nutDayTotal.
  ///
  /// In en, this message translates to:
  /// **'Day total'**
  String get nutDayTotal;

  /// No description provided for @nutTargetLine.
  ///
  /// In en, this message translates to:
  /// **'Target: {macros}'**
  String nutTargetLine(String macros);

  /// No description provided for @nutNoMealsForDay.
  ///
  /// In en, this message translates to:
  /// **'No meals for this day type in the plan.'**
  String get nutNoMealsForDay;

  /// No description provided for @nutItemMacros.
  ///
  /// In en, this message translates to:
  /// **'{kcal} kcal · P {protein} · C {carbs} · F {fat}'**
  String nutItemMacros(String kcal, String protein, String carbs, String fat);

  /// No description provided for @nutSwapMeal.
  ///
  /// In en, this message translates to:
  /// **'Swap meal'**
  String get nutSwapMeal;

  /// No description provided for @nutSwapTitle.
  ///
  /// In en, this message translates to:
  /// **'Swap {meal}'**
  String nutSwapTitle(String meal);

  /// No description provided for @nutSwapSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Alternatives with about the same macros: {macros}'**
  String nutSwapSubtitle(String macros);

  /// No description provided for @nutFindingAlternatives.
  ///
  /// In en, this message translates to:
  /// **'Finding alternatives…'**
  String get nutFindingAlternatives;

  /// No description provided for @nutNoAlternatives.
  ///
  /// In en, this message translates to:
  /// **'No alternatives found. Try again.'**
  String get nutNoAlternatives;

  /// No description provided for @nutUseThis.
  ///
  /// In en, this message translates to:
  /// **'Use this meal'**
  String get nutUseThis;

  /// No description provided for @nutMoreAlternatives.
  ///
  /// In en, this message translates to:
  /// **'Other alternatives'**
  String get nutMoreAlternatives;

  /// No description provided for @nutMealSwapped.
  ///
  /// In en, this message translates to:
  /// **'Meal swapped in your plan'**
  String get nutMealSwapped;

  /// No description provided for @nutRegenerate.
  ///
  /// In en, this message translates to:
  /// **'Regenerate plan'**
  String get nutRegenerate;

  /// No description provided for @nutRegenerateTitle.
  ///
  /// In en, this message translates to:
  /// **'Build a new meal plan?'**
  String get nutRegenerateTitle;

  /// No description provided for @nutRegenerateBody.
  ///
  /// In en, this message translates to:
  /// **'Your current plan (and any swaps) will be replaced. Your logged meals stay.'**
  String get nutRegenerateBody;

  /// No description provided for @nutShoppingNoPlan.
  ///
  /// In en, this message translates to:
  /// **'Create a meal plan first and your weekly shopping list will appear here.'**
  String get nutShoppingNoPlan;

  /// No description provided for @nutShoppingTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly shopping list'**
  String get nutShoppingTitle;

  /// No description provided for @nutShoppingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'For {training} training days and {rest} rest days'**
  String nutShoppingSubtitle(int training, int rest);

  /// No description provided for @nutShoppingShareTitle.
  ///
  /// In en, this message translates to:
  /// **'Shopping list – week of {date}'**
  String nutShoppingShareTitle(String date);

  /// No description provided for @nutShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get nutShare;

  /// No description provided for @nutUncheckAll.
  ///
  /// In en, this message translates to:
  /// **'Uncheck all'**
  String get nutUncheckAll;

  /// No description provided for @nutLiter.
  ///
  /// In en, this message translates to:
  /// **'L'**
  String get nutLiter;

  /// No description provided for @nutCatProtein.
  ///
  /// In en, this message translates to:
  /// **'Meat, poultry & eggs'**
  String get nutCatProtein;

  /// No description provided for @nutCatCarb.
  ///
  /// In en, this message translates to:
  /// **'Bread, grains & legumes'**
  String get nutCatCarb;

  /// No description provided for @nutCatDairy.
  ///
  /// In en, this message translates to:
  /// **'Dairy'**
  String get nutCatDairy;

  /// No description provided for @nutCatFat.
  ///
  /// In en, this message translates to:
  /// **'Oils, nuts & spreads'**
  String get nutCatFat;

  /// No description provided for @nutCatFruit.
  ///
  /// In en, this message translates to:
  /// **'Fruit'**
  String get nutCatFruit;

  /// No description provided for @nutCatVeg.
  ///
  /// In en, this message translates to:
  /// **'Vegetables'**
  String get nutCatVeg;

  /// No description provided for @nutCatDish.
  ///
  /// In en, this message translates to:
  /// **'Ready dishes'**
  String get nutCatDish;

  /// No description provided for @nutCatSupplement.
  ///
  /// In en, this message translates to:
  /// **'Supplements'**
  String get nutCatSupplement;

  /// No description provided for @nutCatOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get nutCatOther;

  /// No description provided for @onbStepOf.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String onbStepOf(String current, String total);

  /// No description provided for @onbNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onbNext;

  /// No description provided for @onbBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get onbBack;

  /// No description provided for @onbSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onbSkip;

  /// No description provided for @onbBackToSummary.
  ///
  /// In en, this message translates to:
  /// **'Back to summary'**
  String get onbBackToSummary;

  /// No description provided for @onbBuildPlan.
  ///
  /// In en, this message translates to:
  /// **'Build my plan'**
  String get onbBuildPlan;

  /// No description provided for @onbNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get onbNotSet;

  /// No description provided for @onbNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get onbNone;

  /// No description provided for @onbOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get onbOptional;

  /// No description provided for @onbErrRange.
  ///
  /// In en, this message translates to:
  /// **'Enter a value between {min} and {max}'**
  String onbErrRange(String min, String max);

  /// No description provided for @onbSectionBasics.
  ///
  /// In en, this message translates to:
  /// **'About you'**
  String get onbSectionBasics;

  /// No description provided for @onbSectionGoals.
  ///
  /// In en, this message translates to:
  /// **'Goal & level'**
  String get onbSectionGoals;

  /// No description provided for @onbSectionTraining.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get onbSectionTraining;

  /// No description provided for @onbSectionLifestyle.
  ///
  /// In en, this message translates to:
  /// **'Health & lifestyle'**
  String get onbSectionLifestyle;

  /// No description provided for @onbSectionNutrition.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get onbSectionNutrition;

  /// No description provided for @onbSectionConnections.
  ///
  /// In en, this message translates to:
  /// **'Connections'**
  String get onbSectionConnections;

  /// No description provided for @onbLangTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get onbLangTitle;

  /// No description provided for @onbLangSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You can change it anytime from Settings.'**
  String get onbLangSubtitle;

  /// No description provided for @onbBodyTitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us about yourself'**
  String get onbBodyTitle;

  /// No description provided for @onbBodySubtitle.
  ///
  /// In en, this message translates to:
  /// **'We use this to calculate your calories and macros.'**
  String get onbBodySubtitle;

  /// No description provided for @onbSexMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get onbSexMale;

  /// No description provided for @onbSexFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get onbSexFemale;

  /// No description provided for @onbAge.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get onbAge;

  /// No description provided for @onbYears.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get onbYears;

  /// No description provided for @onbHeight.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get onbHeight;

  /// No description provided for @onbWeight.
  ///
  /// In en, this message translates to:
  /// **'Current weight'**
  String get onbWeight;

  /// No description provided for @onbBodyFatTitle.
  ///
  /// In en, this message translates to:
  /// **'Body fat percentage'**
  String get onbBodyFatTitle;

  /// No description provided for @onbBodyFatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A rough estimate is totally fine.'**
  String get onbBodyFatSubtitle;

  /// No description provided for @onbBfNumber.
  ///
  /// In en, this message translates to:
  /// **'I know the number'**
  String get onbBfNumber;

  /// No description provided for @onbBfNumberSub.
  ///
  /// In en, this message translates to:
  /// **'From an InBody scan or calipers'**
  String get onbBfNumberSub;

  /// No description provided for @onbBfShape.
  ///
  /// In en, this message translates to:
  /// **'Pick my body shape'**
  String get onbBfShape;

  /// No description provided for @onbBfShapeSub.
  ///
  /// In en, this message translates to:
  /// **'We\'ll estimate it from how you look'**
  String get onbBfShapeSub;

  /// No description provided for @onbBfUnknown.
  ///
  /// In en, this message translates to:
  /// **'I don\'t know'**
  String get onbBfUnknown;

  /// No description provided for @onbBfUnknownSub.
  ///
  /// In en, this message translates to:
  /// **'No problem, we\'ll use your weight and height'**
  String get onbBfUnknownSub;

  /// No description provided for @onbBodyFatPct.
  ///
  /// In en, this message translates to:
  /// **'Body fat'**
  String get onbBodyFatPct;

  /// No description provided for @onbShapeLean.
  ///
  /// In en, this message translates to:
  /// **'Very lean'**
  String get onbShapeLean;

  /// No description provided for @onbShapeLeanSub.
  ///
  /// In en, this message translates to:
  /// **'Clear abs and visible veins'**
  String get onbShapeLeanSub;

  /// No description provided for @onbShapeAthletic.
  ///
  /// In en, this message translates to:
  /// **'Athletic'**
  String get onbShapeAthletic;

  /// No description provided for @onbShapeAthleticSub.
  ///
  /// In en, this message translates to:
  /// **'Abs outline shows'**
  String get onbShapeAthleticSub;

  /// No description provided for @onbShapeAverage.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get onbShapeAverage;

  /// No description provided for @onbShapeAverageSub.
  ///
  /// In en, this message translates to:
  /// **'Flat-ish belly, no abs'**
  String get onbShapeAverageSub;

  /// No description provided for @onbShapeSoft.
  ///
  /// In en, this message translates to:
  /// **'A bit of a belly'**
  String get onbShapeSoft;

  /// No description provided for @onbShapeSoftSub.
  ///
  /// In en, this message translates to:
  /// **'Soft midsection'**
  String get onbShapeSoftSub;

  /// No description provided for @onbShapeHeavy.
  ///
  /// In en, this message translates to:
  /// **'Overweight'**
  String get onbShapeHeavy;

  /// No description provided for @onbShapeHeavySub.
  ///
  /// In en, this message translates to:
  /// **'Belly clearly sticks out'**
  String get onbShapeHeavySub;

  /// No description provided for @onbShapeEstimate.
  ///
  /// In en, this message translates to:
  /// **'≈ {pct}% body fat'**
  String onbShapeEstimate(String pct);

  /// No description provided for @onbMeasTitle.
  ///
  /// In en, this message translates to:
  /// **'Body measurements'**
  String get onbMeasTitle;

  /// No description provided for @onbMeasSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Optional – they help track progress beyond the scale.'**
  String get onbMeasSubtitle;

  /// No description provided for @onbMeasHint.
  ///
  /// In en, this message translates to:
  /// **'Use a tape measure: waist at the navel, arm flexed at the widest point, thigh at the middle.'**
  String get onbMeasHint;

  /// No description provided for @onbMeasWaist.
  ///
  /// In en, this message translates to:
  /// **'Waist'**
  String get onbMeasWaist;

  /// No description provided for @onbMeasChest.
  ///
  /// In en, this message translates to:
  /// **'Chest'**
  String get onbMeasChest;

  /// No description provided for @onbMeasArm.
  ///
  /// In en, this message translates to:
  /// **'Arm'**
  String get onbMeasArm;

  /// No description provided for @onbMeasThigh.
  ///
  /// In en, this message translates to:
  /// **'Thigh'**
  String get onbMeasThigh;

  /// No description provided for @onbMeasNeck.
  ///
  /// In en, this message translates to:
  /// **'Neck'**
  String get onbMeasNeck;

  /// No description provided for @onbMeasHips.
  ///
  /// In en, this message translates to:
  /// **'Hips'**
  String get onbMeasHips;

  /// No description provided for @onbGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s your main goal?'**
  String get onbGoalTitle;

  /// No description provided for @onbGoalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick one – the whole plan is built around it.'**
  String get onbGoalSubtitle;

  /// No description provided for @onbGoalBulk.
  ///
  /// In en, this message translates to:
  /// **'Bulk'**
  String get onbGoalBulk;

  /// No description provided for @onbGoalBulkSub.
  ///
  /// In en, this message translates to:
  /// **'Gain muscle and size'**
  String get onbGoalBulkSub;

  /// No description provided for @onbGoalCut.
  ///
  /// In en, this message translates to:
  /// **'Cut'**
  String get onbGoalCut;

  /// No description provided for @onbGoalCutSub.
  ///
  /// In en, this message translates to:
  /// **'Lose fat, keep the muscle'**
  String get onbGoalCutSub;

  /// No description provided for @onbGoalRecomp.
  ///
  /// In en, this message translates to:
  /// **'Recomp'**
  String get onbGoalRecomp;

  /// No description provided for @onbGoalRecompSub.
  ///
  /// In en, this message translates to:
  /// **'Lose fat and build muscle together'**
  String get onbGoalRecompSub;

  /// No description provided for @onbGoalStrength.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get onbGoalStrength;

  /// No description provided for @onbGoalStrengthSub.
  ///
  /// In en, this message translates to:
  /// **'Lift heavier on the big lifts'**
  String get onbGoalStrengthSub;

  /// No description provided for @onbGoalFitness.
  ///
  /// In en, this message translates to:
  /// **'General fitness'**
  String get onbGoalFitness;

  /// No description provided for @onbGoalFitnessSub.
  ///
  /// In en, this message translates to:
  /// **'Feel better, move better, stay healthy'**
  String get onbGoalFitnessSub;

  /// No description provided for @onbTargetWeight.
  ///
  /// In en, this message translates to:
  /// **'Target weight (optional)'**
  String get onbTargetWeight;

  /// No description provided for @onbGoalWeeks.
  ///
  /// In en, this message translates to:
  /// **'In how many weeks? (optional)'**
  String get onbGoalWeeks;

  /// No description provided for @onbWeeks.
  ///
  /// In en, this message translates to:
  /// **'weeks'**
  String get onbWeeks;

  /// No description provided for @onbGoalWeeksSuggest.
  ///
  /// In en, this message translates to:
  /// **'A realistic pace is about {weeks} weeks'**
  String onbGoalWeeksSuggest(String weeks);

  /// No description provided for @onbWarnCutTarget.
  ///
  /// In en, this message translates to:
  /// **'For a cut, the target is usually below your current weight.'**
  String get onbWarnCutTarget;

  /// No description provided for @onbWarnBulkTarget.
  ///
  /// In en, this message translates to:
  /// **'For a bulk, the target is usually above your current weight.'**
  String get onbWarnBulkTarget;

  /// No description provided for @onbLevelTitle.
  ///
  /// In en, this message translates to:
  /// **'Your training level'**
  String get onbLevelTitle;

  /// No description provided for @onbLevelSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Be honest – it decides volume and exercise choice.'**
  String get onbLevelSubtitle;

  /// No description provided for @onbLevelBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get onbLevelBeginner;

  /// No description provided for @onbLevelBeginnerSub.
  ///
  /// In en, this message translates to:
  /// **'New or still learning the movements'**
  String get onbLevelBeginnerSub;

  /// No description provided for @onbLevelIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get onbLevelIntermediate;

  /// No description provided for @onbLevelIntermediateSub.
  ///
  /// In en, this message translates to:
  /// **'Consistent training, solid technique'**
  String get onbLevelIntermediateSub;

  /// No description provided for @onbLevelAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get onbLevelAdvanced;

  /// No description provided for @onbLevelAdvancedSub.
  ///
  /// In en, this message translates to:
  /// **'Years of serious, structured training'**
  String get onbLevelAdvancedSub;

  /// No description provided for @onbExperienceTitle.
  ///
  /// In en, this message translates to:
  /// **'How long have you been training?'**
  String get onbExperienceTitle;

  /// No description provided for @onbExpNone.
  ///
  /// In en, this message translates to:
  /// **'Just starting'**
  String get onbExpNone;

  /// No description provided for @onbExpLt6m.
  ///
  /// In en, this message translates to:
  /// **'Less than 6 months'**
  String get onbExpLt6m;

  /// No description provided for @onbExp6to12m.
  ///
  /// In en, this message translates to:
  /// **'6–12 months'**
  String get onbExp6to12m;

  /// No description provided for @onbExp1to3y.
  ///
  /// In en, this message translates to:
  /// **'1–3 years'**
  String get onbExp1to3y;

  /// No description provided for @onbExp3yPlus.
  ///
  /// In en, this message translates to:
  /// **'More than 3 years'**
  String get onbExp3yPlus;

  /// No description provided for @onbDaysTitle.
  ///
  /// In en, this message translates to:
  /// **'Training days per week'**
  String get onbDaysTitle;

  /// No description provided for @onbDaysSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Then pick the days themselves.'**
  String get onbDaysSubtitle;

  /// No description provided for @onbPickDays.
  ///
  /// In en, this message translates to:
  /// **'Which days?'**
  String get onbPickDays;

  /// No description provided for @onbDaysPicked.
  ///
  /// In en, this message translates to:
  /// **'{picked} of {total} days picked'**
  String onbDaysPicked(String picked, String total);

  /// No description provided for @onbSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'How long is each workout?'**
  String get onbSessionTitle;

  /// No description provided for @onbSessionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Including warm-up and stretching.'**
  String get onbSessionSubtitle;

  /// No description provided for @onbMinutesValue.
  ///
  /// In en, this message translates to:
  /// **'{n} min'**
  String onbMinutesValue(String n);

  /// No description provided for @onbSession30.
  ///
  /// In en, this message translates to:
  /// **'Quick and focused'**
  String get onbSession30;

  /// No description provided for @onbSession60.
  ///
  /// In en, this message translates to:
  /// **'The classic session'**
  String get onbSession60;

  /// No description provided for @onbSession90.
  ///
  /// In en, this message translates to:
  /// **'Long sessions, more volume'**
  String get onbSession90;

  /// No description provided for @onbSplitTitle.
  ///
  /// In en, this message translates to:
  /// **'Preferred training split'**
  String get onbSplitTitle;

  /// No description provided for @onbSplitSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How should the week be divided?'**
  String get onbSplitSubtitle;

  /// No description provided for @onbSplitMuscleGroup.
  ///
  /// In en, this message translates to:
  /// **'Muscle groups per day'**
  String get onbSplitMuscleGroup;

  /// No description provided for @onbSplitMuscleGroupSub.
  ///
  /// In en, this message translates to:
  /// **'e.g. chest + triceps, back + biceps'**
  String get onbSplitMuscleGroupSub;

  /// No description provided for @onbSplitBro.
  ///
  /// In en, this message translates to:
  /// **'Bro split'**
  String get onbSplitBro;

  /// No description provided for @onbSplitBroSub.
  ///
  /// In en, this message translates to:
  /// **'One muscle per day'**
  String get onbSplitBroSub;

  /// No description provided for @onbSplitFullBody.
  ///
  /// In en, this message translates to:
  /// **'Full body'**
  String get onbSplitFullBody;

  /// No description provided for @onbSplitFullBodySub.
  ///
  /// In en, this message translates to:
  /// **'Whole body every session'**
  String get onbSplitFullBodySub;

  /// No description provided for @onbSplitPpl.
  ///
  /// In en, this message translates to:
  /// **'Push / Pull / Legs'**
  String get onbSplitPpl;

  /// No description provided for @onbSplitPplSub.
  ///
  /// In en, this message translates to:
  /// **'Pushing, pulling and leg days'**
  String get onbSplitPplSub;

  /// No description provided for @onbSplitUpperLower.
  ///
  /// In en, this message translates to:
  /// **'Upper / Lower'**
  String get onbSplitUpperLower;

  /// No description provided for @onbSplitUpperLowerSub.
  ///
  /// In en, this message translates to:
  /// **'Alternate upper and lower body'**
  String get onbSplitUpperLowerSub;

  /// No description provided for @onbSplitAi.
  ///
  /// In en, this message translates to:
  /// **'Let the AI choose'**
  String get onbSplitAi;

  /// No description provided for @onbSplitAiSub.
  ///
  /// In en, this message translates to:
  /// **'Best split for your days and goal'**
  String get onbSplitAiSub;

  /// No description provided for @onbFocusTitle.
  ///
  /// In en, this message translates to:
  /// **'Muscles to focus on'**
  String get onbFocusTitle;

  /// No description provided for @onbFocusSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick any – or none for a balanced plan.'**
  String get onbFocusSubtitle;

  /// No description provided for @onbMuscleChest.
  ///
  /// In en, this message translates to:
  /// **'Chest'**
  String get onbMuscleChest;

  /// No description provided for @onbMuscleBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get onbMuscleBack;

  /// No description provided for @onbMuscleShoulders.
  ///
  /// In en, this message translates to:
  /// **'Shoulders'**
  String get onbMuscleShoulders;

  /// No description provided for @onbMuscleBiceps.
  ///
  /// In en, this message translates to:
  /// **'Biceps'**
  String get onbMuscleBiceps;

  /// No description provided for @onbMuscleTriceps.
  ///
  /// In en, this message translates to:
  /// **'Triceps'**
  String get onbMuscleTriceps;

  /// No description provided for @onbMuscleForearms.
  ///
  /// In en, this message translates to:
  /// **'Forearms'**
  String get onbMuscleForearms;

  /// No description provided for @onbMuscleAbs.
  ///
  /// In en, this message translates to:
  /// **'Abs'**
  String get onbMuscleAbs;

  /// No description provided for @onbMuscleQuads.
  ///
  /// In en, this message translates to:
  /// **'Quads'**
  String get onbMuscleQuads;

  /// No description provided for @onbMuscleHamstrings.
  ///
  /// In en, this message translates to:
  /// **'Hamstrings'**
  String get onbMuscleHamstrings;

  /// No description provided for @onbMuscleGlutes.
  ///
  /// In en, this message translates to:
  /// **'Glutes'**
  String get onbMuscleGlutes;

  /// No description provided for @onbMuscleCalves.
  ///
  /// In en, this message translates to:
  /// **'Calves'**
  String get onbMuscleCalves;

  /// No description provided for @onbMuscleTraps.
  ///
  /// In en, this message translates to:
  /// **'Traps'**
  String get onbMuscleTraps;

  /// No description provided for @onbLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Where do you train?'**
  String get onbLocationTitle;

  /// No description provided for @onbLocationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'So we only pick exercises you can actually do.'**
  String get onbLocationSubtitle;

  /// No description provided for @onbLocFullGym.
  ///
  /// In en, this message translates to:
  /// **'Full gym'**
  String get onbLocFullGym;

  /// No description provided for @onbLocFullGymSub.
  ///
  /// In en, this message translates to:
  /// **'Machines, cables, barbells, dumbbells'**
  String get onbLocFullGymSub;

  /// No description provided for @onbLocLimitedGym.
  ///
  /// In en, this message translates to:
  /// **'Limited gym'**
  String get onbLocLimitedGym;

  /// No description provided for @onbLocLimitedGymSub.
  ///
  /// In en, this message translates to:
  /// **'Basic equipment, few machines'**
  String get onbLocLimitedGymSub;

  /// No description provided for @onbLocHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get onbLocHome;

  /// No description provided for @onbLocHomeSub.
  ///
  /// In en, this message translates to:
  /// **'Bodyweight, dumbbells or bands'**
  String get onbLocHomeSub;

  /// No description provided for @onbInjuriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Injuries & health conditions'**
  String get onbInjuriesTitle;

  /// No description provided for @onbInjuriesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The plan will avoid what could hurt you.'**
  String get onbInjuriesSubtitle;

  /// No description provided for @onbInjNoneLabel.
  ///
  /// In en, this message translates to:
  /// **'No injuries or conditions'**
  String get onbInjNoneLabel;

  /// No description provided for @onbInjGroupJoints.
  ///
  /// In en, this message translates to:
  /// **'Injuries / pain'**
  String get onbInjGroupJoints;

  /// No description provided for @onbInjGroupHealth.
  ///
  /// In en, this message translates to:
  /// **'Health conditions'**
  String get onbInjGroupHealth;

  /// No description provided for @onbInjShoulder.
  ///
  /// In en, this message translates to:
  /// **'Shoulder'**
  String get onbInjShoulder;

  /// No description provided for @onbInjKnee.
  ///
  /// In en, this message translates to:
  /// **'Knee'**
  String get onbInjKnee;

  /// No description provided for @onbInjLowerBack.
  ///
  /// In en, this message translates to:
  /// **'Lower back'**
  String get onbInjLowerBack;

  /// No description provided for @onbInjElbow.
  ///
  /// In en, this message translates to:
  /// **'Elbow'**
  String get onbInjElbow;

  /// No description provided for @onbInjWrist.
  ///
  /// In en, this message translates to:
  /// **'Wrist'**
  String get onbInjWrist;

  /// No description provided for @onbInjNeck.
  ///
  /// In en, this message translates to:
  /// **'Neck'**
  String get onbInjNeck;

  /// No description provided for @onbInjHip.
  ///
  /// In en, this message translates to:
  /// **'Hip'**
  String get onbInjHip;

  /// No description provided for @onbInjAnkle.
  ///
  /// In en, this message translates to:
  /// **'Ankle'**
  String get onbInjAnkle;

  /// No description provided for @onbInjHypertension.
  ///
  /// In en, this message translates to:
  /// **'High blood pressure'**
  String get onbInjHypertension;

  /// No description provided for @onbInjDiabetes.
  ///
  /// In en, this message translates to:
  /// **'Diabetes'**
  String get onbInjDiabetes;

  /// No description provided for @onbInjHeart.
  ///
  /// In en, this message translates to:
  /// **'Heart condition'**
  String get onbInjHeart;

  /// No description provided for @onbInjAsthma.
  ///
  /// In en, this message translates to:
  /// **'Asthma'**
  String get onbInjAsthma;

  /// No description provided for @onbInjHernia.
  ///
  /// In en, this message translates to:
  /// **'Hernia'**
  String get onbInjHernia;

  /// No description provided for @onbInjuriesNote.
  ///
  /// In en, this message translates to:
  /// **'Anything else? (e.g. left shoulder hurts on overhead press)'**
  String get onbInjuriesNote;

  /// No description provided for @onbInjuriesDoctor.
  ///
  /// In en, this message translates to:
  /// **'With a heart condition or uncontrolled blood pressure, check with your doctor before intense training.'**
  String get onbInjuriesDoctor;

  /// No description provided for @onbJobTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s your job like?'**
  String get onbJobTitle;

  /// No description provided for @onbJobSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Daily activity changes how many calories you burn.'**
  String get onbJobSubtitle;

  /// No description provided for @onbJobDesk.
  ///
  /// In en, this message translates to:
  /// **'Desk job'**
  String get onbJobDesk;

  /// No description provided for @onbJobDeskSub.
  ///
  /// In en, this message translates to:
  /// **'Sitting most of the day'**
  String get onbJobDeskSub;

  /// No description provided for @onbJobMobile.
  ///
  /// In en, this message translates to:
  /// **'On my feet'**
  String get onbJobMobile;

  /// No description provided for @onbJobMobileSub.
  ///
  /// In en, this message translates to:
  /// **'Walking and standing a lot'**
  String get onbJobMobileSub;

  /// No description provided for @onbJobPhysical.
  ///
  /// In en, this message translates to:
  /// **'Physical labor'**
  String get onbJobPhysical;

  /// No description provided for @onbJobPhysicalSub.
  ///
  /// In en, this message translates to:
  /// **'Carrying, lifting, hard work'**
  String get onbJobPhysicalSub;

  /// No description provided for @onbJobNone.
  ///
  /// In en, this message translates to:
  /// **'Not working / student'**
  String get onbJobNone;

  /// No description provided for @onbJobNoneSub.
  ///
  /// In en, this message translates to:
  /// **'Flexible daily schedule'**
  String get onbJobNoneSub;

  /// No description provided for @onbJobHours.
  ///
  /// In en, this message translates to:
  /// **'Working hours (optional)'**
  String get onbJobHours;

  /// No description provided for @onbJobFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get onbJobFrom;

  /// No description provided for @onbJobTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get onbJobTo;

  /// No description provided for @onbClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get onbClear;

  /// No description provided for @onbSleepTitle.
  ///
  /// In en, this message translates to:
  /// **'Your usual sleep'**
  String get onbSleepTitle;

  /// No description provided for @onbSleepSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sleep is half the gains – we schedule around it.'**
  String get onbSleepSubtitle;

  /// No description provided for @onbSleepTime.
  ///
  /// In en, this message translates to:
  /// **'Bedtime'**
  String get onbSleepTime;

  /// No description provided for @onbWakeTime.
  ///
  /// In en, this message translates to:
  /// **'Wake-up time'**
  String get onbWakeTime;

  /// No description provided for @onbSleepDuration.
  ///
  /// In en, this message translates to:
  /// **'≈ {hours} h of sleep'**
  String onbSleepDuration(String hours);

  /// No description provided for @onbSleepShort.
  ///
  /// In en, this message translates to:
  /// **'Less than 7 hours – try to sleep more for better recovery.'**
  String get onbSleepShort;

  /// No description provided for @onbTrainTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'When do you usually train?'**
  String get onbTrainTimeTitle;

  /// No description provided for @onbTrainTimeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll remind you and time your meals around it.'**
  String get onbTrainTimeSubtitle;

  /// No description provided for @onbTimeMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get onbTimeMorning;

  /// No description provided for @onbTimeAfterWork.
  ///
  /// In en, this message translates to:
  /// **'After work'**
  String get onbTimeAfterWork;

  /// No description provided for @onbTimeNight.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get onbTimeNight;

  /// No description provided for @onbExactTime.
  ///
  /// In en, this message translates to:
  /// **'Exact time'**
  String get onbExactTime;

  /// No description provided for @onbCardioTitle.
  ///
  /// In en, this message translates to:
  /// **'Cardio'**
  String get onbCardioTitle;

  /// No description provided for @onbCardioSubtitle.
  ///
  /// In en, this message translates to:
  /// **'What do you do and how often?'**
  String get onbCardioSubtitle;

  /// No description provided for @onbCardioNone.
  ///
  /// In en, this message translates to:
  /// **'No cardio'**
  String get onbCardioNone;

  /// No description provided for @onbCardioWalking.
  ///
  /// In en, this message translates to:
  /// **'Walking'**
  String get onbCardioWalking;

  /// No description provided for @onbCardioRunning.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get onbCardioRunning;

  /// No description provided for @onbCardioCycling.
  ///
  /// In en, this message translates to:
  /// **'Cycling'**
  String get onbCardioCycling;

  /// No description provided for @onbCardioElliptical.
  ///
  /// In en, this message translates to:
  /// **'Elliptical'**
  String get onbCardioElliptical;

  /// No description provided for @onbCardioSwimming.
  ///
  /// In en, this message translates to:
  /// **'Swimming'**
  String get onbCardioSwimming;

  /// No description provided for @onbCardioHiit.
  ///
  /// In en, this message translates to:
  /// **'HIIT'**
  String get onbCardioHiit;

  /// No description provided for @onbCardioStairs.
  ///
  /// In en, this message translates to:
  /// **'Stair climber'**
  String get onbCardioStairs;

  /// No description provided for @onbCardioJumpRope.
  ///
  /// In en, this message translates to:
  /// **'Jump rope'**
  String get onbCardioJumpRope;

  /// No description provided for @onbCardioFootball.
  ///
  /// In en, this message translates to:
  /// **'Football'**
  String get onbCardioFootball;

  /// No description provided for @onbCardioPerWeek.
  ///
  /// In en, this message translates to:
  /// **'Times per week'**
  String get onbCardioPerWeek;

  /// No description provided for @onbMealsTitle.
  ///
  /// In en, this message translates to:
  /// **'Meals per day'**
  String get onbMealsTitle;

  /// No description provided for @onbMealsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'And their usual times – tap a time to change it.'**
  String get onbMealsSubtitle;

  /// No description provided for @onbMealN.
  ///
  /// In en, this message translates to:
  /// **'Meal {n}'**
  String onbMealN(String n);

  /// No description provided for @onbMealsReset.
  ///
  /// In en, this message translates to:
  /// **'Suggest times'**
  String get onbMealsReset;

  /// No description provided for @onbFoodsTitle.
  ///
  /// In en, this message translates to:
  /// **'Food preferences'**
  String get onbFoodsTitle;

  /// No description provided for @onbFoodsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The meal plan will use what you like and skip what you don\'t.'**
  String get onbFoodsSubtitle;

  /// No description provided for @onbFoodsLiked.
  ///
  /// In en, this message translates to:
  /// **'Foods you like'**
  String get onbFoodsLiked;

  /// No description provided for @onbFoodsDisliked.
  ///
  /// In en, this message translates to:
  /// **'Foods you don\'t like'**
  String get onbFoodsDisliked;

  /// No description provided for @onbAllergies.
  ///
  /// In en, this message translates to:
  /// **'Allergies'**
  String get onbAllergies;

  /// No description provided for @onbFoodsOther.
  ///
  /// In en, this message translates to:
  /// **'Other (separate with commas)'**
  String get onbFoodsOther;

  /// No description provided for @onbFoodFul.
  ///
  /// In en, this message translates to:
  /// **'Ful'**
  String get onbFoodFul;

  /// No description provided for @onbFoodEggs.
  ///
  /// In en, this message translates to:
  /// **'Eggs'**
  String get onbFoodEggs;

  /// No description provided for @onbFoodChicken.
  ///
  /// In en, this message translates to:
  /// **'Chicken'**
  String get onbFoodChicken;

  /// No description provided for @onbFoodTuna.
  ///
  /// In en, this message translates to:
  /// **'Tuna'**
  String get onbFoodTuna;

  /// No description provided for @onbFoodRice.
  ///
  /// In en, this message translates to:
  /// **'Rice'**
  String get onbFoodRice;

  /// No description provided for @onbFoodBaladiBread.
  ///
  /// In en, this message translates to:
  /// **'Baladi bread'**
  String get onbFoodBaladiBread;

  /// No description provided for @onbFoodYogurt.
  ///
  /// In en, this message translates to:
  /// **'Yogurt'**
  String get onbFoodYogurt;

  /// No description provided for @onbFoodCottageCheese.
  ///
  /// In en, this message translates to:
  /// **'Cottage cheese (areesh)'**
  String get onbFoodCottageCheese;

  /// No description provided for @onbFoodWhiteCheese.
  ///
  /// In en, this message translates to:
  /// **'White cheese'**
  String get onbFoodWhiteCheese;

  /// No description provided for @onbFoodKoshari.
  ///
  /// In en, this message translates to:
  /// **'Koshari'**
  String get onbFoodKoshari;

  /// No description provided for @onbFoodMincedBeef.
  ///
  /// In en, this message translates to:
  /// **'Minced beef'**
  String get onbFoodMincedBeef;

  /// No description provided for @onbFoodFish.
  ///
  /// In en, this message translates to:
  /// **'Fish'**
  String get onbFoodFish;

  /// No description provided for @onbFoodLentils.
  ///
  /// In en, this message translates to:
  /// **'Lentils'**
  String get onbFoodLentils;

  /// No description provided for @onbFoodTaameya.
  ///
  /// In en, this message translates to:
  /// **'Taameya'**
  String get onbFoodTaameya;

  /// No description provided for @onbFoodOats.
  ///
  /// In en, this message translates to:
  /// **'Oats'**
  String get onbFoodOats;

  /// No description provided for @onbFoodPasta.
  ///
  /// In en, this message translates to:
  /// **'Pasta'**
  String get onbFoodPasta;

  /// No description provided for @onbFoodPotatoes.
  ///
  /// In en, this message translates to:
  /// **'Potatoes'**
  String get onbFoodPotatoes;

  /// No description provided for @onbFoodSweetPotato.
  ///
  /// In en, this message translates to:
  /// **'Sweet potato'**
  String get onbFoodSweetPotato;

  /// No description provided for @onbFoodMilk.
  ///
  /// In en, this message translates to:
  /// **'Milk'**
  String get onbFoodMilk;

  /// No description provided for @onbFoodPeanutButter.
  ///
  /// In en, this message translates to:
  /// **'Peanut butter'**
  String get onbFoodPeanutButter;

  /// No description provided for @onbFoodBananas.
  ///
  /// In en, this message translates to:
  /// **'Bananas'**
  String get onbFoodBananas;

  /// No description provided for @onbFoodDates.
  ///
  /// In en, this message translates to:
  /// **'Dates'**
  String get onbFoodDates;

  /// No description provided for @onbFoodLiver.
  ///
  /// In en, this message translates to:
  /// **'Liver'**
  String get onbFoodLiver;

  /// No description provided for @onbFoodMolokhia.
  ///
  /// In en, this message translates to:
  /// **'Molokhia'**
  String get onbFoodMolokhia;

  /// No description provided for @onbAllergyLactose.
  ///
  /// In en, this message translates to:
  /// **'Lactose'**
  String get onbAllergyLactose;

  /// No description provided for @onbAllergyGluten.
  ///
  /// In en, this message translates to:
  /// **'Gluten'**
  String get onbAllergyGluten;

  /// No description provided for @onbAllergyNuts.
  ///
  /// In en, this message translates to:
  /// **'Nuts'**
  String get onbAllergyNuts;

  /// No description provided for @onbAllergyPeanuts.
  ///
  /// In en, this message translates to:
  /// **'Peanuts'**
  String get onbAllergyPeanuts;

  /// No description provided for @onbAllergyEggs.
  ///
  /// In en, this message translates to:
  /// **'Eggs'**
  String get onbAllergyEggs;

  /// No description provided for @onbAllergySeafood.
  ///
  /// In en, this message translates to:
  /// **'Seafood'**
  String get onbAllergySeafood;

  /// No description provided for @onbBudgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly food budget'**
  String get onbBudgetTitle;

  /// No description provided for @onbBudgetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'In Egyptian pounds – the meal plan will respect it.'**
  String get onbBudgetSubtitle;

  /// No description provided for @onbBudgetLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get onbBudgetLow;

  /// No description provided for @onbBudgetLowSub.
  ///
  /// In en, this message translates to:
  /// **'Basics: eggs, ful, rice, chicken, areesh'**
  String get onbBudgetLowSub;

  /// No description provided for @onbBudgetMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get onbBudgetMedium;

  /// No description provided for @onbBudgetMediumSub.
  ///
  /// In en, this message translates to:
  /// **'Adds meat, fish, oats and some extras'**
  String get onbBudgetMediumSub;

  /// No description provided for @onbBudgetOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get onbBudgetOpen;

  /// No description provided for @onbBudgetOpenSub.
  ///
  /// In en, this message translates to:
  /// **'Whatever fits the plan best'**
  String get onbBudgetOpenSub;

  /// No description provided for @onbBudgetCustom.
  ///
  /// In en, this message translates to:
  /// **'A specific amount'**
  String get onbBudgetCustom;

  /// No description provided for @onbBudgetCustomSub.
  ///
  /// In en, this message translates to:
  /// **'Enter it in EGP'**
  String get onbBudgetCustomSub;

  /// No description provided for @onbBudgetAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount per month'**
  String get onbBudgetAmount;

  /// No description provided for @onbEgp.
  ///
  /// In en, this message translates to:
  /// **'EGP'**
  String get onbEgp;

  /// No description provided for @onbSuppTitle.
  ///
  /// In en, this message translates to:
  /// **'Current supplements'**
  String get onbSuppTitle;

  /// No description provided for @onbSuppSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap to add, then set the dose. Protein and calories count toward your day.'**
  String get onbSuppSubtitle;

  /// No description provided for @onbSuppEmpty.
  ///
  /// In en, this message translates to:
  /// **'No supplements – totally fine.'**
  String get onbSuppEmpty;

  /// No description provided for @onbSuppWhey.
  ///
  /// In en, this message translates to:
  /// **'Whey protein'**
  String get onbSuppWhey;

  /// No description provided for @onbSuppCreatine.
  ///
  /// In en, this message translates to:
  /// **'Creatine'**
  String get onbSuppCreatine;

  /// No description provided for @onbSuppMassGainer.
  ///
  /// In en, this message translates to:
  /// **'Mass gainer'**
  String get onbSuppMassGainer;

  /// No description provided for @onbSuppCasein.
  ///
  /// In en, this message translates to:
  /// **'Casein'**
  String get onbSuppCasein;

  /// No description provided for @onbSuppMultivitamin.
  ///
  /// In en, this message translates to:
  /// **'Multivitamin'**
  String get onbSuppMultivitamin;

  /// No description provided for @onbSuppOmega3.
  ///
  /// In en, this message translates to:
  /// **'Omega-3'**
  String get onbSuppOmega3;

  /// No description provided for @onbSuppVitaminD.
  ///
  /// In en, this message translates to:
  /// **'Vitamin D'**
  String get onbSuppVitaminD;

  /// No description provided for @onbSuppZma.
  ///
  /// In en, this message translates to:
  /// **'ZMA'**
  String get onbSuppZma;

  /// No description provided for @onbSuppBcaa.
  ///
  /// In en, this message translates to:
  /// **'BCAA'**
  String get onbSuppBcaa;

  /// No description provided for @onbSuppPreWorkout.
  ///
  /// In en, this message translates to:
  /// **'Pre-workout'**
  String get onbSuppPreWorkout;

  /// No description provided for @onbSuppCaffeine.
  ///
  /// In en, this message translates to:
  /// **'Caffeine'**
  String get onbSuppCaffeine;

  /// No description provided for @onbSuppOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get onbSuppOther;

  /// No description provided for @onbSuppName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get onbSuppName;

  /// No description provided for @onbSuppDose.
  ///
  /// In en, this message translates to:
  /// **'Dose'**
  String get onbSuppDose;

  /// No description provided for @onbSuppTiming.
  ///
  /// In en, this message translates to:
  /// **'When? (optional)'**
  String get onbSuppTiming;

  /// No description provided for @onbSuppPerServing.
  ///
  /// In en, this message translates to:
  /// **'Per serving'**
  String get onbSuppPerServing;

  /// No description provided for @onbSuppProtein.
  ///
  /// In en, this message translates to:
  /// **'Protein (g)'**
  String get onbSuppProtein;

  /// No description provided for @onbSuppCalories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get onbSuppCalories;

  /// No description provided for @onbSuppCarbs.
  ///
  /// In en, this message translates to:
  /// **'Carbs (g)'**
  String get onbSuppCarbs;

  /// No description provided for @onbSuppFat.
  ///
  /// In en, this message translates to:
  /// **'Fat (g)'**
  String get onbSuppFat;

  /// No description provided for @onbSuppAddMacros.
  ///
  /// In en, this message translates to:
  /// **'Counts toward calories?'**
  String get onbSuppAddMacros;

  /// No description provided for @onbSuppRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get onbSuppRemove;

  /// No description provided for @onbDoseScoop.
  ///
  /// In en, this message translates to:
  /// **'1 scoop (30 g)'**
  String get onbDoseScoop;

  /// No description provided for @onbDoseScoopPlain.
  ///
  /// In en, this message translates to:
  /// **'1 scoop'**
  String get onbDoseScoopPlain;

  /// No description provided for @onbDoseGainer.
  ///
  /// In en, this message translates to:
  /// **'1 serving (100 g)'**
  String get onbDoseGainer;

  /// No description provided for @onbDoseGrams.
  ///
  /// In en, this message translates to:
  /// **'{g} g'**
  String onbDoseGrams(String g);

  /// No description provided for @onbDoseTablet.
  ///
  /// In en, this message translates to:
  /// **'1 tablet'**
  String get onbDoseTablet;

  /// No description provided for @onbDoseCapsule.
  ///
  /// In en, this message translates to:
  /// **'1 capsule'**
  String get onbDoseCapsule;

  /// No description provided for @onbDoseServing.
  ///
  /// In en, this message translates to:
  /// **'1 serving'**
  String get onbDoseServing;

  /// No description provided for @onbDoseMg.
  ///
  /// In en, this message translates to:
  /// **'{mg} mg'**
  String onbDoseMg(String mg);

  /// No description provided for @onbSuppMacrosValue.
  ///
  /// In en, this message translates to:
  /// **'{protein} g protein · {calories} kcal'**
  String onbSuppMacrosValue(String protein, String calories);

  /// No description provided for @onbWaterTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily water goal'**
  String get onbWaterTitle;

  /// No description provided for @onbWaterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Suggested from your weight – adjust if you want.'**
  String get onbWaterSubtitle;

  /// No description provided for @onbWaterSuggested.
  ///
  /// In en, this message translates to:
  /// **'Suggested: {ml} ml'**
  String onbWaterSuggested(String ml);

  /// No description provided for @onbWaterLiters.
  ///
  /// In en, this message translates to:
  /// **'≈ {liters} liters'**
  String onbWaterLiters(String liters);

  /// No description provided for @onbWaterUseSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Use suggestion'**
  String get onbWaterUseSuggestion;

  /// No description provided for @onbWaterGlasses.
  ///
  /// In en, this message translates to:
  /// **'About {glasses} glasses of 250 ml'**
  String onbWaterGlasses(String glasses);

  /// No description provided for @onbHealthTitle.
  ///
  /// In en, this message translates to:
  /// **'Connect your smart ring'**
  String get onbHealthTitle;

  /// No description provided for @onbHealthSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Through Health Connect we read sleep, heart rate, HRV and steps to calculate a daily recovery score.'**
  String get onbHealthSubtitle;

  /// No description provided for @onbHealthConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect Health Connect'**
  String get onbHealthConnect;

  /// No description provided for @onbHealthConnected.
  ///
  /// In en, this message translates to:
  /// **'Health Connect is on'**
  String get onbHealthConnected;

  /// No description provided for @onbHealthConnectedSub.
  ///
  /// In en, this message translates to:
  /// **'We\'ll sync when you open the app and every few hours.'**
  String get onbHealthConnectedSub;

  /// No description provided for @onbHealthDisconnect.
  ///
  /// In en, this message translates to:
  /// **'Turn off'**
  String get onbHealthDisconnect;

  /// No description provided for @onbHealthNote.
  ///
  /// In en, this message translates to:
  /// **'If your ring\'s app doesn\'t write to Health Connect, you can log sleep manually – nothing breaks. You can check the last synced data in Settings.'**
  String get onbHealthNote;

  /// No description provided for @onbHealthItemSleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep & stages'**
  String get onbHealthItemSleep;

  /// No description provided for @onbHealthItemHeart.
  ///
  /// In en, this message translates to:
  /// **'Heart rate, resting HR & HRV'**
  String get onbHealthItemHeart;

  /// No description provided for @onbHealthItemSteps.
  ///
  /// In en, this message translates to:
  /// **'Steps & active calories'**
  String get onbHealthItemSteps;

  /// No description provided for @onbKeyTitle.
  ///
  /// In en, this message translates to:
  /// **'Claude API key'**
  String get onbKeyTitle;

  /// No description provided for @onbKeySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Powers the AI coach, plans and food-photo analysis. Everything else works without it – you can add it later from Settings.'**
  String get onbKeySubtitle;

  /// No description provided for @onbKeyField.
  ///
  /// In en, this message translates to:
  /// **'API key (sk-ant-…)'**
  String get onbKeyField;

  /// No description provided for @onbKeyWhere.
  ///
  /// In en, this message translates to:
  /// **'Get one from console.anthropic.com → API Keys. It\'s stored encrypted on this device only.'**
  String get onbKeyWhere;

  /// No description provided for @onbKeyTest.
  ///
  /// In en, this message translates to:
  /// **'Test key'**
  String get onbKeyTest;

  /// No description provided for @onbKeySave.
  ///
  /// In en, this message translates to:
  /// **'Save key'**
  String get onbKeySave;

  /// No description provided for @onbKeyValid.
  ///
  /// In en, this message translates to:
  /// **'The key works'**
  String get onbKeyValid;

  /// No description provided for @onbKeyInvalid.
  ///
  /// In en, this message translates to:
  /// **'The key didn\'t work: {error}'**
  String onbKeyInvalid(String error);

  /// No description provided for @onbKeySaved.
  ///
  /// In en, this message translates to:
  /// **'Key saved securely on this device'**
  String get onbKeySaved;

  /// No description provided for @onbKeyReplace.
  ///
  /// In en, this message translates to:
  /// **'Replace key'**
  String get onbKeyReplace;

  /// No description provided for @onbKeyEmpty.
  ///
  /// In en, this message translates to:
  /// **'Paste the key first'**
  String get onbKeyEmpty;

  /// No description provided for @onbSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Review your answers'**
  String get onbSummaryTitle;

  /// No description provided for @onbSummarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap any answer to change it, then build your plan.'**
  String get onbSummarySubtitle;

  /// No description provided for @onbSumLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get onbSumLanguage;

  /// No description provided for @onbSumBody.
  ///
  /// In en, this message translates to:
  /// **'Body'**
  String get onbSumBody;

  /// No description provided for @onbSumBodyFat.
  ///
  /// In en, this message translates to:
  /// **'Body fat'**
  String get onbSumBodyFat;

  /// No description provided for @onbSumMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Measurements'**
  String get onbSumMeasurements;

  /// No description provided for @onbSumGoal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get onbSumGoal;

  /// No description provided for @onbSumLevel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get onbSumLevel;

  /// No description provided for @onbSumDays.
  ///
  /// In en, this message translates to:
  /// **'Training days'**
  String get onbSumDays;

  /// No description provided for @onbSumSession.
  ///
  /// In en, this message translates to:
  /// **'Session length'**
  String get onbSumSession;

  /// No description provided for @onbSumSplit.
  ///
  /// In en, this message translates to:
  /// **'Split'**
  String get onbSumSplit;

  /// No description provided for @onbSumFocus.
  ///
  /// In en, this message translates to:
  /// **'Focus muscles'**
  String get onbSumFocus;

  /// No description provided for @onbSumLocation.
  ///
  /// In en, this message translates to:
  /// **'Where'**
  String get onbSumLocation;

  /// No description provided for @onbSumInjuries.
  ///
  /// In en, this message translates to:
  /// **'Injuries & health'**
  String get onbSumInjuries;

  /// No description provided for @onbSumJob.
  ///
  /// In en, this message translates to:
  /// **'Job'**
  String get onbSumJob;

  /// No description provided for @onbSumSleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get onbSumSleep;

  /// No description provided for @onbSumTrainingTime.
  ///
  /// In en, this message translates to:
  /// **'Training time'**
  String get onbSumTrainingTime;

  /// No description provided for @onbSumCardio.
  ///
  /// In en, this message translates to:
  /// **'Cardio'**
  String get onbSumCardio;

  /// No description provided for @onbSumMeals.
  ///
  /// In en, this message translates to:
  /// **'Meals'**
  String get onbSumMeals;

  /// No description provided for @onbSumFoods.
  ///
  /// In en, this message translates to:
  /// **'Food preferences'**
  String get onbSumFoods;

  /// No description provided for @onbSumBudget.
  ///
  /// In en, this message translates to:
  /// **'Food budget'**
  String get onbSumBudget;

  /// No description provided for @onbSumSupplements.
  ///
  /// In en, this message translates to:
  /// **'Supplements'**
  String get onbSumSupplements;

  /// No description provided for @onbSumWater.
  ///
  /// In en, this message translates to:
  /// **'Water goal'**
  String get onbSumWater;

  /// No description provided for @onbSumHealth.
  ///
  /// In en, this message translates to:
  /// **'Health Connect'**
  String get onbSumHealth;

  /// No description provided for @onbSumApiKey.
  ///
  /// In en, this message translates to:
  /// **'Claude API key'**
  String get onbSumApiKey;

  /// No description provided for @onbYearsValue.
  ///
  /// In en, this message translates to:
  /// **'{age} y'**
  String onbYearsValue(String age);

  /// No description provided for @onbPerWeekValue.
  ///
  /// In en, this message translates to:
  /// **'{n}×/week'**
  String onbPerWeekValue(String n);

  /// No description provided for @onbWeeksValue.
  ///
  /// In en, this message translates to:
  /// **'{weeks} weeks'**
  String onbWeeksValue(String weeks);

  /// No description provided for @onbLikesValue.
  ///
  /// In en, this message translates to:
  /// **'Likes: {list}'**
  String onbLikesValue(String list);

  /// No description provided for @onbDislikesValue.
  ///
  /// In en, this message translates to:
  /// **'Dislikes: {list}'**
  String onbDislikesValue(String list);

  /// No description provided for @onbAllergiesValue.
  ///
  /// In en, this message translates to:
  /// **'Allergies: {list}'**
  String onbAllergiesValue(String list);

  /// No description provided for @onbBodyFatShapeValue.
  ///
  /// In en, this message translates to:
  /// **'≈ {pct}% (from body shape)'**
  String onbBodyFatShapeValue(String pct);

  /// No description provided for @onbConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get onbConnected;

  /// No description provided for @onbNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Not connected'**
  String get onbNotConnected;

  /// No description provided for @onbKeySet.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get onbKeySet;

  /// No description provided for @onbKeyNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not added – add later'**
  String get onbKeyNotSet;

  /// No description provided for @onbBuildingTitle.
  ///
  /// In en, this message translates to:
  /// **'Building your plan'**
  String get onbBuildingTitle;

  /// No description provided for @onbBuildReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your plan is ready'**
  String get onbBuildReadyTitle;

  /// No description provided for @onbBuildHint.
  ///
  /// In en, this message translates to:
  /// **'This can take a minute or two – the AI is thinking it through.'**
  String get onbBuildHint;

  /// No description provided for @onbBuildTargets.
  ///
  /// In en, this message translates to:
  /// **'Calories & macros'**
  String get onbBuildTargets;

  /// No description provided for @onbBuildWorkout.
  ///
  /// In en, this message translates to:
  /// **'Workout plan'**
  String get onbBuildWorkout;

  /// No description provided for @onbBuildMeals.
  ///
  /// In en, this message translates to:
  /// **'Meal plan'**
  String get onbBuildMeals;

  /// No description provided for @onbBuildWorkoutLater.
  ///
  /// In en, this message translates to:
  /// **'We built a ready-made plan from your answers for now – you can regenerate it with AI later from the Workout tab.'**
  String get onbBuildWorkoutLater;

  /// No description provided for @onbBuildMealsLater.
  ///
  /// In en, this message translates to:
  /// **'We built a ready-made meal plan for now – you can regenerate it with AI later from the Food tab.'**
  String get onbBuildMealsLater;

  /// No description provided for @onbBuildNoKey.
  ///
  /// In en, this message translates to:
  /// **'No Claude API key yet, so we built ready-made workout and meal plans from your answers. Add the key later in Settings to regenerate them with AI from the Workout and Food tabs.'**
  String get onbBuildNoKey;

  /// No description provided for @onbBuildOffline.
  ///
  /// In en, this message translates to:
  /// **'No internet right now, so we built ready-made workout and meal plans from your answers. Regenerate them with AI from the Workout and Food tabs when you\'re back online.'**
  String get onbBuildOffline;

  /// No description provided for @onbDailyTargets.
  ///
  /// In en, this message translates to:
  /// **'Your daily targets'**
  String get onbDailyTargets;

  /// No description provided for @onbTdee.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get onbTdee;

  /// No description provided for @onbTrainingDayCarbs.
  ///
  /// In en, this message translates to:
  /// **'Training-day carbs'**
  String get onbTrainingDayCarbs;

  /// No description provided for @onbRestDayCarbs.
  ///
  /// In en, this message translates to:
  /// **'Rest-day carbs'**
  String get onbRestDayCarbs;

  /// No description provided for @onbReviewPlan.
  ///
  /// In en, this message translates to:
  /// **'Review my workout plan'**
  String get onbReviewPlan;

  /// No description provided for @onbSkipReview.
  ///
  /// In en, this message translates to:
  /// **'Skip review for now'**
  String get onbSkipReview;

  /// No description provided for @onbStartApp.
  ///
  /// In en, this message translates to:
  /// **'Let\'s go'**
  String get onbStartApp;

  /// No description provided for @onbGenericError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t do it right now.'**
  String get onbGenericError;

  /// No description provided for @onbStatusWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting…'**
  String get onbStatusWaiting;

  /// No description provided for @onbStatusWorking.
  ///
  /// In en, this message translates to:
  /// **'Working on it…'**
  String get onbStatusWorking;

  /// No description provided for @onbStatusDone.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get onbStatusDone;

  /// No description provided for @onbStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get onbStatusFailed;

  /// No description provided for @onbStatusTemplate.
  ///
  /// In en, this message translates to:
  /// **'Ready-made plan'**
  String get onbStatusTemplate;

  /// No description provided for @onbProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'My profile'**
  String get onbProfileTitle;

  /// No description provided for @onbProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap any answer to change it. Targets update automatically.'**
  String get onbProfileSubtitle;

  /// No description provided for @onbProfileTargets.
  ///
  /// In en, this message translates to:
  /// **'Current targets'**
  String get onbProfileTargets;

  /// No description provided for @onbSavedTargets.
  ///
  /// In en, this message translates to:
  /// **'Saved – targets updated'**
  String get onbSavedTargets;

  /// No description provided for @onbSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get onbSaved;

  /// No description provided for @onbRegenTitle.
  ///
  /// In en, this message translates to:
  /// **'Update your plans?'**
  String get onbRegenTitle;

  /// No description provided for @onbRegenBody.
  ///
  /// In en, this message translates to:
  /// **'Your answers changed. Regenerate with AI so your plans match?'**
  String get onbRegenBody;

  /// No description provided for @onbRegenWorkout.
  ///
  /// In en, this message translates to:
  /// **'Workout plan'**
  String get onbRegenWorkout;

  /// No description provided for @onbRegenMeals.
  ///
  /// In en, this message translates to:
  /// **'Meal plan'**
  String get onbRegenMeals;

  /// No description provided for @onbRegenNow.
  ///
  /// In en, this message translates to:
  /// **'Regenerate'**
  String get onbRegenNow;

  /// No description provided for @onbRegenSkip.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get onbRegenSkip;

  /// No description provided for @onbRegenRunning.
  ///
  /// In en, this message translates to:
  /// **'Regenerating your plans…'**
  String get onbRegenRunning;

  /// No description provided for @onbRegenMealDone.
  ///
  /// In en, this message translates to:
  /// **'Your new meal plan is ready.'**
  String get onbRegenMealDone;

  /// No description provided for @onbRegenWorkoutDone.
  ///
  /// In en, this message translates to:
  /// **'Your new workout plan is ready for review.'**
  String get onbRegenWorkoutDone;

  /// No description provided for @onbRegenNoKey.
  ///
  /// In en, this message translates to:
  /// **'Add your Claude API key in Settings to regenerate plans with AI.'**
  String get onbRegenNoKey;

  /// No description provided for @onbRegenOffline.
  ///
  /// In en, this message translates to:
  /// **'No internet right now – try again when you\'re online.'**
  String get onbRegenOffline;

  /// No description provided for @onbRegenResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan update'**
  String get onbRegenResultTitle;

  /// No description provided for @onbPlanActivated.
  ///
  /// In en, this message translates to:
  /// **'Plan activated'**
  String get onbPlanActivated;

  /// No description provided for @onbErrSex.
  ///
  /// In en, this message translates to:
  /// **'Pick male or female'**
  String get onbErrSex;

  /// No description provided for @onbErrAge.
  ///
  /// In en, this message translates to:
  /// **'Age must be between 12 and 90'**
  String get onbErrAge;

  /// No description provided for @onbErrHeight.
  ///
  /// In en, this message translates to:
  /// **'Height must be between 120 and 230 cm'**
  String get onbErrHeight;

  /// No description provided for @onbErrWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight must be between 30 and 300 kg'**
  String get onbErrWeight;

  /// No description provided for @onbErrBodyFatChoice.
  ///
  /// In en, this message translates to:
  /// **'Choose one of the options'**
  String get onbErrBodyFatChoice;

  /// No description provided for @onbErrBodyFat.
  ///
  /// In en, this message translates to:
  /// **'Body fat must be between 3% and 60%'**
  String get onbErrBodyFat;

  /// No description provided for @onbErrMeasurement.
  ///
  /// In en, this message translates to:
  /// **'Measurements must be between 10 and 250 cm'**
  String get onbErrMeasurement;

  /// No description provided for @onbErrGoal.
  ///
  /// In en, this message translates to:
  /// **'Pick a goal'**
  String get onbErrGoal;

  /// No description provided for @onbErrTargetWeight.
  ///
  /// In en, this message translates to:
  /// **'Target weight must be between 30 and 300 kg'**
  String get onbErrTargetWeight;

  /// No description provided for @onbErrWeeks.
  ///
  /// In en, this message translates to:
  /// **'Weeks must be between 1 and 104'**
  String get onbErrWeeks;

  /// No description provided for @onbErrLevel.
  ///
  /// In en, this message translates to:
  /// **'Pick your level and how long you\'ve trained'**
  String get onbErrLevel;

  /// No description provided for @onbErrDaysCount.
  ///
  /// In en, this message translates to:
  /// **'Pick how many days per week'**
  String get onbErrDaysCount;

  /// No description provided for @onbErrDaysMismatch.
  ///
  /// In en, this message translates to:
  /// **'Pick exactly {count} days'**
  String onbErrDaysMismatch(String count);

  /// No description provided for @onbErrChoose.
  ///
  /// In en, this message translates to:
  /// **'Pick one option to continue'**
  String get onbErrChoose;

  /// No description provided for @onbErrSleep.
  ///
  /// In en, this message translates to:
  /// **'Set your bedtime and wake-up time'**
  String get onbErrSleep;

  /// No description provided for @onbErrCardioPerWeek.
  ///
  /// In en, this message translates to:
  /// **'How many times per week?'**
  String get onbErrCardioPerWeek;

  /// No description provided for @onbErrMealTimes.
  ///
  /// In en, this message translates to:
  /// **'Set a time for every meal'**
  String get onbErrMealTimes;

  /// No description provided for @onbErrBudget.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount between 100 and 1,000,000 EGP'**
  String get onbErrBudget;

  /// No description provided for @onbErrSuppName.
  ///
  /// In en, this message translates to:
  /// **'Every supplement needs a name'**
  String get onbErrSuppName;

  /// No description provided for @onbErrWater.
  ///
  /// In en, this message translates to:
  /// **'Water goal must be between 1,000 and 8,000 ml'**
  String get onbErrWater;

  /// No description provided for @progTitle.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progTitle;

  /// No description provided for @progPeriodWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get progPeriodWeek;

  /// No description provided for @progPeriodMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get progPeriodMonth;

  /// No description provided for @progPeriod3Months.
  ///
  /// In en, this message translates to:
  /// **'3 months'**
  String get progPeriod3Months;

  /// No description provided for @progPeriodYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get progPeriodYear;

  /// No description provided for @progPeriodAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get progPeriodAll;

  /// No description provided for @progLinkPrs.
  ///
  /// In en, this message translates to:
  /// **'Records'**
  String get progLinkPrs;

  /// No description provided for @progLinkPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get progLinkPhotos;

  /// No description provided for @progLinkMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Measurements'**
  String get progLinkMeasurements;

  /// No description provided for @progLinkWeight.
  ///
  /// In en, this message translates to:
  /// **'Body weight'**
  String get progLinkWeight;

  /// No description provided for @progExportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF report'**
  String get progExportPdf;

  /// No description provided for @progCalendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Adherence calendar'**
  String get progCalendarTitle;

  /// No description provided for @progLegendCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get progLegendCompleted;

  /// No description provided for @progLegendPartial.
  ///
  /// In en, this message translates to:
  /// **'Partial'**
  String get progLegendPartial;

  /// No description provided for @progLegendMissed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get progLegendMissed;

  /// No description provided for @progLegendRest.
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get progLegendRest;

  /// No description provided for @progAdherencePct.
  ///
  /// In en, this message translates to:
  /// **'{pct}% adherence'**
  String progAdherencePct(String pct);

  /// No description provided for @progAdherenceNone.
  ///
  /// In en, this message translates to:
  /// **'No training days due yet this month'**
  String get progAdherenceNone;

  /// No description provided for @progAdherenceCounts.
  ///
  /// In en, this message translates to:
  /// **'{completed} completed · {partial} partial · {missed} missed'**
  String progAdherenceCounts(String completed, String partial, String missed);

  /// No description provided for @progPrevMonth.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get progPrevMonth;

  /// No description provided for @progNextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get progNextMonth;

  /// No description provided for @progStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get progStatusInProgress;

  /// No description provided for @progStatusRestDay.
  ///
  /// In en, this message translates to:
  /// **'Rest day'**
  String get progStatusRestDay;

  /// No description provided for @progStatusToday.
  ///
  /// In en, this message translates to:
  /// **'Today – not trained yet'**
  String get progStatusToday;

  /// No description provided for @progStatusFuture.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get progStatusFuture;

  /// No description provided for @progStatusNone.
  ///
  /// In en, this message translates to:
  /// **'Before you started tracking'**
  String get progStatusNone;

  /// No description provided for @progDayNothing.
  ///
  /// In en, this message translates to:
  /// **'Nothing logged on this day.'**
  String get progDayNothing;

  /// No description provided for @progDayWorkout.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get progDayWorkout;

  /// No description provided for @progDayNutrition.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get progDayNutrition;

  /// No description provided for @progDayWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get progDayWater;

  /// No description provided for @progDaySleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get progDaySleep;

  /// No description provided for @progDayWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get progDayWeight;

  /// No description provided for @progDayRecovery.
  ///
  /// In en, this message translates to:
  /// **'Recovery'**
  String get progDayRecovery;

  /// No description provided for @progDayCardio.
  ///
  /// In en, this message translates to:
  /// **'Cardio'**
  String get progDayCardio;

  /// No description provided for @progSetTypeWarmup.
  ///
  /// In en, this message translates to:
  /// **'Warm-up'**
  String get progSetTypeWarmup;

  /// No description provided for @progSetTypeDrop.
  ///
  /// In en, this message translates to:
  /// **'Drop set'**
  String get progSetTypeDrop;

  /// No description provided for @progSetTypeFailure.
  ///
  /// In en, this message translates to:
  /// **'To failure'**
  String get progSetTypeFailure;

  /// No description provided for @progVolumeValue.
  ///
  /// In en, this message translates to:
  /// **'Volume {value} kg'**
  String progVolumeValue(String value);

  /// No description provided for @progSetsCount.
  ///
  /// In en, this message translates to:
  /// **'Sets: {count}'**
  String progSetsCount(String count);

  /// No description provided for @progPrsCount.
  ///
  /// In en, this message translates to:
  /// **'PRs: {count}'**
  String progPrsCount(String count);

  /// No description provided for @progPrBadge.
  ///
  /// In en, this message translates to:
  /// **'PR'**
  String get progPrBadge;

  /// No description provided for @progDurationMin.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String progDurationMin(String minutes);

  /// No description provided for @progMealsCount.
  ///
  /// In en, this message translates to:
  /// **'Meals: {count}'**
  String progMealsCount(String count);

  /// No description provided for @progUnknownExercise.
  ///
  /// In en, this message translates to:
  /// **'Unknown exercise'**
  String get progUnknownExercise;

  /// No description provided for @progExerciseTitle.
  ///
  /// In en, this message translates to:
  /// **'Exercise progress'**
  String get progExerciseTitle;

  /// No description provided for @progPickExercise.
  ///
  /// In en, this message translates to:
  /// **'Pick an exercise'**
  String get progPickExercise;

  /// No description provided for @progSearchExercise.
  ///
  /// In en, this message translates to:
  /// **'Search your exercises'**
  String get progSearchExercise;

  /// No description provided for @progTopSet.
  ///
  /// In en, this message translates to:
  /// **'Top set'**
  String get progTopSet;

  /// No description provided for @progE1rm.
  ///
  /// In en, this message translates to:
  /// **'Est. 1RM'**
  String get progE1rm;

  /// No description provided for @progNoExerciseData.
  ///
  /// In en, this message translates to:
  /// **'Log a workout and your strength progress shows up here.'**
  String get progNoExerciseData;

  /// No description provided for @progNoDataInPeriod.
  ///
  /// In en, this message translates to:
  /// **'No data in this period.'**
  String get progNoDataInPeriod;

  /// No description provided for @progBest.
  ///
  /// In en, this message translates to:
  /// **'Best'**
  String get progBest;

  /// No description provided for @progChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get progChange;

  /// No description provided for @progLatest.
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get progLatest;

  /// No description provided for @progSessionsCount.
  ///
  /// In en, this message translates to:
  /// **'Sessions: {count}'**
  String progSessionsCount(String count);

  /// No description provided for @progNoMatches.
  ///
  /// In en, this message translates to:
  /// **'No matches'**
  String get progNoMatches;

  /// No description provided for @progVolumeTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly volume per muscle'**
  String get progVolumeTitle;

  /// No description provided for @progAvgPerWeek.
  ///
  /// In en, this message translates to:
  /// **'Average per week over {days} days · volume = weight × reps'**
  String progAvgPerWeek(String days);

  /// No description provided for @progEffectiveSets.
  ///
  /// In en, this message translates to:
  /// **'Effective sets / week'**
  String get progEffectiveSets;

  /// No description provided for @progEffectiveSetsHint.
  ///
  /// In en, this message translates to:
  /// **'Effective set = working set at RPE 7+ (or no RPE logged). Around 10–20 per muscle per week is a solid range for growth.'**
  String get progEffectiveSetsHint;

  /// No description provided for @progWeeklyTotal.
  ///
  /// In en, this message translates to:
  /// **'Total volume per week'**
  String get progWeeklyTotal;

  /// No description provided for @progNoVolumeData.
  ///
  /// In en, this message translates to:
  /// **'No working sets in this period yet.'**
  String get progNoVolumeData;

  /// No description provided for @progMuscleCol.
  ///
  /// In en, this message translates to:
  /// **'Muscle'**
  String get progMuscleCol;

  /// No description provided for @progVolumeCol.
  ///
  /// In en, this message translates to:
  /// **'Volume/wk'**
  String get progVolumeCol;

  /// No description provided for @progSetsCol.
  ///
  /// In en, this message translates to:
  /// **'Eff. sets'**
  String get progSetsCol;

  /// No description provided for @progBodyTitle.
  ///
  /// In en, this message translates to:
  /// **'Body weight'**
  String get progBodyTitle;

  /// No description provided for @progDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get progDaily;

  /// No description provided for @progMovingAvg.
  ///
  /// In en, this message translates to:
  /// **'7-day average'**
  String get progMovingAvg;

  /// No description provided for @progMeasurementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Measurements'**
  String get progMeasurementsTitle;

  /// No description provided for @progNoWeightData.
  ///
  /// In en, this message translates to:
  /// **'No weight logged in this period.'**
  String get progNoWeightData;

  /// No description provided for @progNoMeasurementData.
  ///
  /// In en, this message translates to:
  /// **'No measurements in this period.'**
  String get progNoMeasurementData;

  /// No description provided for @progLogWeight.
  ///
  /// In en, this message translates to:
  /// **'Log weight'**
  String get progLogWeight;

  /// No description provided for @progLogMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Add measurements'**
  String get progLogMeasurements;

  /// No description provided for @progMeasureWaist.
  ///
  /// In en, this message translates to:
  /// **'Waist'**
  String get progMeasureWaist;

  /// No description provided for @progMeasureChest.
  ///
  /// In en, this message translates to:
  /// **'Chest'**
  String get progMeasureChest;

  /// No description provided for @progMeasureArm.
  ///
  /// In en, this message translates to:
  /// **'Arm'**
  String get progMeasureArm;

  /// No description provided for @progMeasureThigh.
  ///
  /// In en, this message translates to:
  /// **'Thigh'**
  String get progMeasureThigh;

  /// No description provided for @progMeasureNeck.
  ///
  /// In en, this message translates to:
  /// **'Neck'**
  String get progMeasureNeck;

  /// No description provided for @progMeasureHips.
  ///
  /// In en, this message translates to:
  /// **'Hips'**
  String get progMeasureHips;

  /// No description provided for @progMeasureBodyFat.
  ///
  /// In en, this message translates to:
  /// **'Body fat %'**
  String get progMeasureBodyFat;

  /// No description provided for @progNutritionTitle.
  ///
  /// In en, this message translates to:
  /// **'Calories & macros vs target'**
  String get progNutritionTitle;

  /// No description provided for @progTarget.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get progTarget;

  /// No description provided for @progAvgPerDay.
  ///
  /// In en, this message translates to:
  /// **'Daily average ({days} days logged)'**
  String progAvgPerDay(String days);

  /// No description provided for @progNoNutritionData.
  ///
  /// In en, this message translates to:
  /// **'No meals logged in this period.'**
  String get progNoNutritionData;

  /// No description provided for @progDaysOnTarget.
  ///
  /// In en, this message translates to:
  /// **'Days within ±10% of your calorie target: {count}/{total}'**
  String progDaysOnTarget(String count, String total);

  /// No description provided for @progSleepTitle.
  ///
  /// In en, this message translates to:
  /// **'Sleep & recovery'**
  String get progSleepTitle;

  /// No description provided for @progSleepHours.
  ///
  /// In en, this message translates to:
  /// **'Sleep (h)'**
  String get progSleepHours;

  /// No description provided for @progRecoveryScore.
  ///
  /// In en, this message translates to:
  /// **'Recovery score'**
  String get progRecoveryScore;

  /// No description provided for @progAvgSleep.
  ///
  /// In en, this message translates to:
  /// **'Avg sleep'**
  String get progAvgSleep;

  /// No description provided for @progAvgRecovery.
  ///
  /// In en, this message translates to:
  /// **'Avg recovery'**
  String get progAvgRecovery;

  /// No description provided for @progNoSleepData.
  ///
  /// In en, this message translates to:
  /// **'No sleep or recovery data in this period. Log sleep manually or connect Health Connect.'**
  String get progNoSleepData;

  /// No description provided for @progPrsTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal records'**
  String get progPrsTitle;

  /// No description provided for @progPrHeaviest.
  ///
  /// In en, this message translates to:
  /// **'Heaviest'**
  String get progPrHeaviest;

  /// No description provided for @progPrBestE1rm.
  ///
  /// In en, this message translates to:
  /// **'Best est. 1RM'**
  String get progPrBestE1rm;

  /// No description provided for @progPrRepsAtWeight.
  ///
  /// In en, this message translates to:
  /// **'Most reps at each weight'**
  String get progPrRepsAtWeight;

  /// No description provided for @progNoPrs.
  ///
  /// In en, this message translates to:
  /// **'No records yet – log a few workouts first.'**
  String get progNoPrs;

  /// No description provided for @progSetsLogged.
  ///
  /// In en, this message translates to:
  /// **'{count} working sets'**
  String progSetsLogged(String count);

  /// No description provided for @progLastTrained.
  ///
  /// In en, this message translates to:
  /// **'Last: {date}'**
  String progLastTrained(String date);

  /// No description provided for @progReportChoose.
  ///
  /// In en, this message translates to:
  /// **'Export progress report'**
  String get progReportChoose;

  /// No description provided for @progReportThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get progReportThisWeek;

  /// No description provided for @progReportLastWeek.
  ///
  /// In en, this message translates to:
  /// **'Last week'**
  String get progReportLastWeek;

  /// No description provided for @progReportThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get progReportThisMonth;

  /// No description provided for @progReportLastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last month'**
  String get progReportLastMonth;

  /// No description provided for @progReportGenerating.
  ///
  /// In en, this message translates to:
  /// **'Preparing your report…'**
  String get progReportGenerating;

  /// No description provided for @progReportFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t create the report'**
  String get progReportFailed;

  /// No description provided for @progReportShareSubject.
  ///
  /// In en, this message translates to:
  /// **'IronMind progress report'**
  String get progReportShareSubject;

  /// No description provided for @progPdfWeeklyTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly progress report'**
  String get progPdfWeeklyTitle;

  /// No description provided for @progPdfMonthlyTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly progress report'**
  String get progPdfMonthlyTitle;

  /// No description provided for @progPdfGenerated.
  ///
  /// In en, this message translates to:
  /// **'Generated {date}'**
  String progPdfGenerated(String date);

  /// No description provided for @progPdfSummary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get progPdfSummary;

  /// No description provided for @progPdfSessionsDone.
  ///
  /// In en, this message translates to:
  /// **'Sessions done'**
  String get progPdfSessionsDone;

  /// No description provided for @progPdfSessionsMissed.
  ///
  /// In en, this message translates to:
  /// **'Missed days'**
  String get progPdfSessionsMissed;

  /// No description provided for @progPdfAdherence.
  ///
  /// In en, this message translates to:
  /// **'Adherence'**
  String get progPdfAdherence;

  /// No description provided for @progPdfVolume.
  ///
  /// In en, this message translates to:
  /// **'Total volume'**
  String get progPdfVolume;

  /// No description provided for @progPdfPrs.
  ///
  /// In en, this message translates to:
  /// **'Personal records'**
  String get progPdfPrs;

  /// No description provided for @progPdfAvgCalories.
  ///
  /// In en, this message translates to:
  /// **'Avg calories'**
  String get progPdfAvgCalories;

  /// No description provided for @progPdfAvgProtein.
  ///
  /// In en, this message translates to:
  /// **'Avg protein'**
  String get progPdfAvgProtein;

  /// No description provided for @progPdfWeightChange.
  ///
  /// In en, this message translates to:
  /// **'Weight change'**
  String get progPdfWeightChange;

  /// No description provided for @progPdfAvgSleep.
  ///
  /// In en, this message translates to:
  /// **'Avg sleep'**
  String get progPdfAvgSleep;

  /// No description provided for @progPdfAvgRecovery.
  ///
  /// In en, this message translates to:
  /// **'Avg recovery'**
  String get progPdfAvgRecovery;

  /// No description provided for @progPdfTarget.
  ///
  /// In en, this message translates to:
  /// **'target {value}'**
  String progPdfTarget(String value);

  /// No description provided for @progPdfCoachSummary.
  ///
  /// In en, this message translates to:
  /// **'Coach summary'**
  String get progPdfCoachSummary;

  /// No description provided for @progPdfNoCoachSummary.
  ///
  /// In en, this message translates to:
  /// **'No weekly coach report in this period. You can ask the coach for one from the Coach tab.'**
  String get progPdfNoCoachSummary;

  /// No description provided for @progPdfSessionsTable.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get progPdfSessionsTable;

  /// No description provided for @progPdfDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get progPdfDate;

  /// No description provided for @progPdfName.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get progPdfName;

  /// No description provided for @progPdfStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get progPdfStatus;

  /// No description provided for @progPdfDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get progPdfDuration;

  /// No description provided for @progPdfSets.
  ///
  /// In en, this message translates to:
  /// **'Sets'**
  String get progPdfSets;

  /// No description provided for @progPdfExercise.
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get progPdfExercise;

  /// No description provided for @progPdfType.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get progPdfType;

  /// No description provided for @progPdfSet.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get progPdfSet;

  /// No description provided for @progPdfTypeWeight.
  ///
  /// In en, this message translates to:
  /// **'Heaviest'**
  String get progPdfTypeWeight;

  /// No description provided for @progPdfTypeReps.
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get progPdfTypeReps;

  /// No description provided for @progPdfTypeE1rm.
  ///
  /// In en, this message translates to:
  /// **'e1RM'**
  String get progPdfTypeE1rm;

  /// No description provided for @progPdfBodyTable.
  ///
  /// In en, this message translates to:
  /// **'Body metrics'**
  String get progPdfBodyTable;

  /// No description provided for @progPdfMuscleChart.
  ///
  /// In en, this message translates to:
  /// **'Volume per muscle (kg)'**
  String get progPdfMuscleChart;

  /// No description provided for @progPdfCaloriesChart.
  ///
  /// In en, this message translates to:
  /// **'Daily calories vs target'**
  String get progPdfCaloriesChart;

  /// No description provided for @progPdfWeightChart.
  ///
  /// In en, this message translates to:
  /// **'Body weight (kg)'**
  String get progPdfWeightChart;

  /// No description provided for @progPdfNone.
  ///
  /// In en, this message translates to:
  /// **'Nothing logged in this period.'**
  String get progPdfNone;

  /// No description provided for @progPdfPage.
  ///
  /// In en, this message translates to:
  /// **'Page {page} of {total}'**
  String progPdfPage(String page, String total);

  /// No description provided for @progPdfEaten.
  ///
  /// In en, this message translates to:
  /// **'Eaten'**
  String get progPdfEaten;

  /// No description provided for @progOpenExercise.
  ///
  /// In en, this message translates to:
  /// **'Exercise details'**
  String get progOpenExercise;

  /// No description provided for @progChangeExercise.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get progChangeExercise;

  /// No description provided for @progSessionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get progSessionsLabel;

  /// No description provided for @progLegendOnTarget.
  ///
  /// In en, this message translates to:
  /// **'On target (±10%)'**
  String get progLegendOnTarget;

  /// No description provided for @progLegendUnder.
  ///
  /// In en, this message translates to:
  /// **'Under'**
  String get progLegendUnder;

  /// No description provided for @progLegendOver.
  ///
  /// In en, this message translates to:
  /// **'Over'**
  String get progLegendOver;

  /// No description provided for @progWeeklyBarsNote.
  ///
  /// In en, this message translates to:
  /// **'Long period: each bar is the daily average of one week.'**
  String get progWeeklyBarsNote;

  /// No description provided for @progCardioTreadmill.
  ///
  /// In en, this message translates to:
  /// **'Treadmill'**
  String get progCardioTreadmill;

  /// No description provided for @progCardioBike.
  ///
  /// In en, this message translates to:
  /// **'Bike'**
  String get progCardioBike;

  /// No description provided for @progCardioElliptical.
  ///
  /// In en, this message translates to:
  /// **'Elliptical'**
  String get progCardioElliptical;

  /// No description provided for @progCardioRowing.
  ///
  /// In en, this message translates to:
  /// **'Rowing'**
  String get progCardioRowing;

  /// No description provided for @progCardioWalk.
  ///
  /// In en, this message translates to:
  /// **'Walk'**
  String get progCardioWalk;

  /// No description provided for @progCardioRun.
  ///
  /// In en, this message translates to:
  /// **'Run'**
  String get progCardioRun;

  /// No description provided for @progCardioStairs.
  ///
  /// In en, this message translates to:
  /// **'Stairs'**
  String get progCardioStairs;

  /// No description provided for @progCardioJumpRope.
  ///
  /// In en, this message translates to:
  /// **'Jump rope'**
  String get progCardioJumpRope;

  /// No description provided for @progCardioSwim.
  ///
  /// In en, this message translates to:
  /// **'Swim'**
  String get progCardioSwim;

  /// No description provided for @progPdfFromTo.
  ///
  /// In en, this message translates to:
  /// **'{from} to {to}'**
  String progPdfFromTo(String from, String to);

  /// No description provided for @setProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get setProfile;

  /// No description provided for @setProfileSub.
  ///
  /// In en, this message translates to:
  /// **'Edit your answers, goals and targets'**
  String get setProfileSub;

  /// No description provided for @setSectionAi.
  ///
  /// In en, this message translates to:
  /// **'AI coach (Claude)'**
  String get setSectionAi;

  /// No description provided for @setSectionApp.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get setSectionApp;

  /// No description provided for @setApiKey.
  ///
  /// In en, this message translates to:
  /// **'Claude API key'**
  String get setApiKey;

  /// No description provided for @setApiKeyHelp.
  ///
  /// In en, this message translates to:
  /// **'Stored only on this phone in encrypted storage. Never included in backups.'**
  String get setApiKeyHelp;

  /// No description provided for @setApiKeySaved.
  ///
  /// In en, this message translates to:
  /// **'API key saved'**
  String get setApiKeySaved;

  /// No description provided for @setApiKeyTest.
  ///
  /// In en, this message translates to:
  /// **'Test key'**
  String get setApiKeyTest;

  /// No description provided for @setApiKeyTesting.
  ///
  /// In en, this message translates to:
  /// **'Testing…'**
  String get setApiKeyTesting;

  /// No description provided for @setApiKeyValid.
  ///
  /// In en, this message translates to:
  /// **'The key works'**
  String get setApiKeyValid;

  /// No description provided for @setApiKeyInvalid.
  ///
  /// In en, this message translates to:
  /// **'The key didn\'t work'**
  String get setApiKeyInvalid;

  /// No description provided for @setApiKeyChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get setApiKeyChange;

  /// No description provided for @setApiKeyRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get setApiKeyRemove;

  /// No description provided for @setApiKeyRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove API key?'**
  String get setApiKeyRemoveTitle;

  /// No description provided for @setApiKeyRemoveBody.
  ///
  /// In en, this message translates to:
  /// **'AI features will stop working until you add a key again.'**
  String get setApiKeyRemoveBody;

  /// No description provided for @setModels.
  ///
  /// In en, this message translates to:
  /// **'AI models'**
  String get setModels;

  /// No description provided for @setModelFast.
  ///
  /// In en, this message translates to:
  /// **'Fast model (Haiku tier)'**
  String get setModelFast;

  /// No description provided for @setModelFastHelp.
  ///
  /// In en, this message translates to:
  /// **'Voice/text parsing, exercise alternatives, memory'**
  String get setModelFastHelp;

  /// No description provided for @setModelBalanced.
  ///
  /// In en, this message translates to:
  /// **'Balanced model (Sonnet tier)'**
  String get setModelBalanced;

  /// No description provided for @setModelBalancedHelp.
  ///
  /// In en, this message translates to:
  /// **'Chat, workout summaries, food photos, morning message'**
  String get setModelBalancedHelp;

  /// No description provided for @setModelSmart.
  ///
  /// In en, this message translates to:
  /// **'Smartest model (Opus tier)'**
  String get setModelSmart;

  /// No description provided for @setModelSmartHelp.
  ///
  /// In en, this message translates to:
  /// **'First plan, meal plan, weekly report'**
  String get setModelSmartHelp;

  /// No description provided for @setModelsSaved.
  ///
  /// In en, this message translates to:
  /// **'Models saved'**
  String get setModelsSaved;

  /// No description provided for @setModelsReset.
  ///
  /// In en, this message translates to:
  /// **'Reset to defaults'**
  String get setModelsReset;

  /// No description provided for @setModelsResetDone.
  ///
  /// In en, this message translates to:
  /// **'Default models restored'**
  String get setModelsResetDone;

  /// No description provided for @setRefusalFallback.
  ///
  /// In en, this message translates to:
  /// **'Server-side fallback on refusals'**
  String get setRefusalFallback;

  /// No description provided for @setRefusalFallbackSub.
  ///
  /// In en, this message translates to:
  /// **'If a model refuses a request, Claude retries it on a fallback model automatically.'**
  String get setRefusalFallbackSub;

  /// No description provided for @setCost.
  ///
  /// In en, this message translates to:
  /// **'AI costs'**
  String get setCost;

  /// No description provided for @setCostToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get setCostToday;

  /// No description provided for @setCostMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get setCostMonth;

  /// No description provided for @setCostAllTime.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get setCostAllTime;

  /// No description provided for @setCostByFeature.
  ///
  /// In en, this message translates to:
  /// **'By feature'**
  String get setCostByFeature;

  /// No description provided for @setCostEmpty.
  ///
  /// In en, this message translates to:
  /// **'No AI requests in this period'**
  String get setCostEmpty;

  /// No description provided for @setCostTokens.
  ///
  /// In en, this message translates to:
  /// **'{tokens} tokens'**
  String setCostTokens(String tokens);

  /// No description provided for @setCostFeatureDetail.
  ///
  /// In en, this message translates to:
  /// **'{requests} requests · in {input} · out {output} · cache {cache}'**
  String setCostFeatureDetail(
    int requests,
    String input,
    String output,
    String cache,
  );

  /// No description provided for @setCostNote.
  ///
  /// In en, this message translates to:
  /// **'Estimated from public prices. No spending limit is applied.'**
  String get setCostNote;

  /// No description provided for @setFeatVoiceParse.
  ///
  /// In en, this message translates to:
  /// **'Voice → set'**
  String get setFeatVoiceParse;

  /// No description provided for @setFeatExerciseAlternatives.
  ///
  /// In en, this message translates to:
  /// **'Exercise alternatives'**
  String get setFeatExerciseAlternatives;

  /// No description provided for @setFeatMemoryExtract.
  ///
  /// In en, this message translates to:
  /// **'Coach memory'**
  String get setFeatMemoryExtract;

  /// No description provided for @setFeatFoodText.
  ///
  /// In en, this message translates to:
  /// **'Food from text'**
  String get setFeatFoodText;

  /// No description provided for @setFeatExerciseCreate.
  ///
  /// In en, this message translates to:
  /// **'Custom exercises'**
  String get setFeatExerciseCreate;

  /// No description provided for @setFeatChat.
  ///
  /// In en, this message translates to:
  /// **'Coach chat'**
  String get setFeatChat;

  /// No description provided for @setFeatWorkoutSummary.
  ///
  /// In en, this message translates to:
  /// **'Workout summaries'**
  String get setFeatWorkoutSummary;

  /// No description provided for @setFeatFoodPhoto.
  ///
  /// In en, this message translates to:
  /// **'Food photos'**
  String get setFeatFoodPhoto;

  /// No description provided for @setFeatMorningMessage.
  ///
  /// In en, this message translates to:
  /// **'Morning message'**
  String get setFeatMorningMessage;

  /// No description provided for @setFeatPlateau.
  ///
  /// In en, this message translates to:
  /// **'Plateau alerts'**
  String get setFeatPlateau;

  /// No description provided for @setFeatMealSwap.
  ///
  /// In en, this message translates to:
  /// **'Meal swaps'**
  String get setFeatMealSwap;

  /// No description provided for @setFeatGroceryList.
  ///
  /// In en, this message translates to:
  /// **'Grocery list'**
  String get setFeatGroceryList;

  /// No description provided for @setFeatInitialPlan.
  ///
  /// In en, this message translates to:
  /// **'Workout plan'**
  String get setFeatInitialPlan;

  /// No description provided for @setFeatMealPlan.
  ///
  /// In en, this message translates to:
  /// **'Meal plan'**
  String get setFeatMealPlan;

  /// No description provided for @setFeatWeeklyReport.
  ///
  /// In en, this message translates to:
  /// **'Weekly report'**
  String get setFeatWeeklyReport;

  /// No description provided for @setFeatKeyTest.
  ///
  /// In en, this message translates to:
  /// **'Key test'**
  String get setFeatKeyTest;

  /// No description provided for @setNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get setNotifications;

  /// No description provided for @setNotificationsSub.
  ///
  /// In en, this message translates to:
  /// **'Workout, meals, water, supplements, weight, coach'**
  String get setNotificationsSub;

  /// No description provided for @setHealthConnect.
  ///
  /// In en, this message translates to:
  /// **'Health Connect'**
  String get setHealthConnect;

  /// No description provided for @setHealthConnectSub.
  ///
  /// In en, this message translates to:
  /// **'Smart ring / watch: sleep, heart rate, steps'**
  String get setHealthConnectSub;

  /// No description provided for @setCoachMemory.
  ///
  /// In en, this message translates to:
  /// **'Coach memory'**
  String get setCoachMemory;

  /// No description provided for @setCoachMemorySub.
  ///
  /// In en, this message translates to:
  /// **'What the coach remembers about you'**
  String get setCoachMemorySub;

  /// No description provided for @setBackup.
  ///
  /// In en, this message translates to:
  /// **'Backup & restore'**
  String get setBackup;

  /// No description provided for @setBackupSub.
  ///
  /// In en, this message translates to:
  /// **'Export everything to one file or restore it'**
  String get setBackupSub;

  /// No description provided for @setBackupBanner.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t backed up in over 2 weeks.'**
  String get setBackupBanner;

  /// No description provided for @setBackupNow.
  ///
  /// In en, this message translates to:
  /// **'Back up'**
  String get setBackupNow;

  /// No description provided for @setLock.
  ///
  /// In en, this message translates to:
  /// **'App lock'**
  String get setLock;

  /// No description provided for @setLockSub.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint / face / PIN when opening the app'**
  String get setLockSub;

  /// No description provided for @setLockTimeout.
  ///
  /// In en, this message translates to:
  /// **'Lock after leaving the app'**
  String get setLockTimeout;

  /// No description provided for @setLockImmediately.
  ///
  /// In en, this message translates to:
  /// **'Immediately'**
  String get setLockImmediately;

  /// No description provided for @setLockSeconds.
  ///
  /// In en, this message translates to:
  /// **'{seconds} sec'**
  String setLockSeconds(int seconds);

  /// No description provided for @setLockMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String setLockMinutes(int minutes);

  /// No description provided for @setLockUnsupported.
  ///
  /// In en, this message translates to:
  /// **'No fingerprint, face or screen lock is set up on this phone.'**
  String get setLockUnsupported;

  /// No description provided for @setLockFailed.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed. Try again.'**
  String get setLockFailed;

  /// No description provided for @setLockEnableReason.
  ///
  /// In en, this message translates to:
  /// **'Confirm to turn on the app lock'**
  String get setLockEnableReason;

  /// No description provided for @setLockDisableReason.
  ///
  /// In en, this message translates to:
  /// **'Confirm to turn off the app lock'**
  String get setLockDisableReason;

  /// No description provided for @setLockReason.
  ///
  /// In en, this message translates to:
  /// **'Unlock IronMind'**
  String get setLockReason;

  /// No description provided for @setLockLocked.
  ///
  /// In en, this message translates to:
  /// **'IronMind is locked'**
  String get setLockLocked;

  /// No description provided for @setLockUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get setLockUnlock;

  /// No description provided for @setAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get setAbout;

  /// No description provided for @setAboutSub.
  ///
  /// In en, this message translates to:
  /// **'Version, data sources and licenses'**
  String get setAboutSub;

  /// No description provided for @setAboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String setAboutVersion(String version);

  /// No description provided for @setAboutTagline.
  ///
  /// In en, this message translates to:
  /// **'Your personal gym coach — workouts, nutrition, sleep and body, powered by Claude.'**
  String get setAboutTagline;

  /// No description provided for @setAboutSources.
  ///
  /// In en, this message translates to:
  /// **'Data sources & licenses'**
  String get setAboutSources;

  /// No description provided for @setAboutExerciseDb.
  ///
  /// In en, this message translates to:
  /// **'Exercise library data and images'**
  String get setAboutExerciseDb;

  /// No description provided for @setAboutFontAr.
  ///
  /// In en, this message translates to:
  /// **'Arabic font'**
  String get setAboutFontAr;

  /// No description provided for @setAboutFontEn.
  ///
  /// In en, this message translates to:
  /// **'English font'**
  String get setAboutFontEn;

  /// No description provided for @setAboutClaude.
  ///
  /// In en, this message translates to:
  /// **'AI coach (your own API key)'**
  String get setAboutClaude;

  /// No description provided for @setAboutPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get setAboutPrivacy;

  /// No description provided for @setAboutPrivacyBody.
  ///
  /// In en, this message translates to:
  /// **'All your data stays on this phone. Only the AI requests you trigger are sent to Claude, and progress photos are never sent unless you explicitly ask.'**
  String get setAboutPrivacyBody;

  /// No description provided for @setAboutLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open-source licenses'**
  String get setAboutLicenses;

  /// No description provided for @setExerciseImages.
  ///
  /// In en, this message translates to:
  /// **'Exercise images offline'**
  String get setExerciseImages;

  /// No description provided for @setExerciseImagesSub.
  ///
  /// In en, this message translates to:
  /// **'Download all exercise images for use without internet'**
  String get setExerciseImagesSub;

  /// No description provided for @setBackupExport.
  ///
  /// In en, this message translates to:
  /// **'Export backup'**
  String get setBackupExport;

  /// No description provided for @setBackupExportHelp.
  ///
  /// In en, this message translates to:
  /// **'One .zip file with your database, progress photos, meal photos and custom exercise media. Save it to Drive or anywhere.'**
  String get setBackupExportHelp;

  /// No description provided for @setBackupExportButton.
  ///
  /// In en, this message translates to:
  /// **'Export & share'**
  String get setBackupExportButton;

  /// No description provided for @setBackupWorking.
  ///
  /// In en, this message translates to:
  /// **'Preparing backup…'**
  String get setBackupWorking;

  /// No description provided for @setBackupNever.
  ///
  /// In en, this message translates to:
  /// **'No backup yet'**
  String get setBackupNever;

  /// No description provided for @setBackupLast.
  ///
  /// In en, this message translates to:
  /// **'Last backup: {date}'**
  String setBackupLast(String date);

  /// No description provided for @setBackupDone.
  ///
  /// In en, this message translates to:
  /// **'Backup ready'**
  String get setBackupDone;

  /// No description provided for @setBackupFailed.
  ///
  /// In en, this message translates to:
  /// **'Backup failed: {error}'**
  String setBackupFailed(String error);

  /// No description provided for @setBackupShareSubject.
  ///
  /// In en, this message translates to:
  /// **'IronMind backup'**
  String get setBackupShareSubject;

  /// No description provided for @setBackupKeyNote.
  ///
  /// In en, this message translates to:
  /// **'Your Claude API key is never included. Add it again after restoring on a new phone.'**
  String get setBackupKeyNote;

  /// No description provided for @setRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore from backup'**
  String get setRestore;

  /// No description provided for @setRestoreHelp.
  ///
  /// In en, this message translates to:
  /// **'Replaces ALL data on this phone with the backup.'**
  String get setRestoreHelp;

  /// No description provided for @setRestoreButton.
  ///
  /// In en, this message translates to:
  /// **'Choose backup file'**
  String get setRestoreButton;

  /// No description provided for @setRestorePick.
  ///
  /// In en, this message translates to:
  /// **'Choose an IronMind backup (.zip)'**
  String get setRestorePick;

  /// No description provided for @setRestoreNotBackup.
  ///
  /// In en, this message translates to:
  /// **'This file isn\'t an IronMind backup.'**
  String get setRestoreNotBackup;

  /// No description provided for @setRestoreCorrupt.
  ///
  /// In en, this message translates to:
  /// **'The backup file is damaged or incomplete.'**
  String get setRestoreCorrupt;

  /// No description provided for @setRestoreNewer.
  ///
  /// In en, this message translates to:
  /// **'This backup is from a newer app version. Update the app first.'**
  String get setRestoreNewer;

  /// No description provided for @setRestoreConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Replace all data?'**
  String get setRestoreConfirmTitle;

  /// No description provided for @setRestoreConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Backup from {date} (app {version}). Everything currently on this phone will be replaced. This can\'t be undone.'**
  String setRestoreConfirmBody(String date, String version);

  /// No description provided for @setRestoreReplace.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get setRestoreReplace;

  /// No description provided for @setRestoreWorking.
  ///
  /// In en, this message translates to:
  /// **'Restoring your data… don\'t close the app.'**
  String get setRestoreWorking;

  /// No description provided for @setRestoreDone.
  ///
  /// In en, this message translates to:
  /// **'Restore complete'**
  String get setRestoreDone;

  /// No description provided for @setRestoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Restore failed'**
  String get setRestoreFailed;

  /// No description provided for @setRestoreRestart.
  ///
  /// In en, this message translates to:
  /// **'Close the app and open it again to continue.'**
  String get setRestoreRestart;

  /// No description provided for @setRestoreCloseApp.
  ///
  /// In en, this message translates to:
  /// **'Close app'**
  String get setRestoreCloseApp;

  /// No description provided for @setChannelWorkout.
  ///
  /// In en, this message translates to:
  /// **'Workout reminders'**
  String get setChannelWorkout;

  /// No description provided for @setChannelMeals.
  ///
  /// In en, this message translates to:
  /// **'Meal reminders'**
  String get setChannelMeals;

  /// No description provided for @setChannelWater.
  ///
  /// In en, this message translates to:
  /// **'Water reminders'**
  String get setChannelWater;

  /// No description provided for @setChannelSupplements.
  ///
  /// In en, this message translates to:
  /// **'Supplement reminders'**
  String get setChannelSupplements;

  /// No description provided for @setChannelWeight.
  ///
  /// In en, this message translates to:
  /// **'Weigh-in reminder'**
  String get setChannelWeight;

  /// No description provided for @setChannelCoach.
  ///
  /// In en, this message translates to:
  /// **'Coach messages'**
  String get setChannelCoach;

  /// No description provided for @setChannelRestTimer.
  ///
  /// In en, this message translates to:
  /// **'Rest timer'**
  String get setChannelRestTimer;

  /// No description provided for @setChannelBackup.
  ///
  /// In en, this message translates to:
  /// **'Backup reminder'**
  String get setChannelBackup;

  /// No description provided for @setNotifWorkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Training day 💪'**
  String get setNotifWorkoutTitle;

  /// No description provided for @setNotifWorkoutBody.
  ///
  /// In en, this message translates to:
  /// **'Your workout is at {time}. Get ready.'**
  String setNotifWorkoutBody(String time);

  /// No description provided for @setNotifMealTitle.
  ///
  /// In en, this message translates to:
  /// **'Meal {number}'**
  String setNotifMealTitle(int number);

  /// No description provided for @setNotifMealBody.
  ///
  /// In en, this message translates to:
  /// **'Time to eat — log it after.'**
  String get setNotifMealBody;

  /// No description provided for @setNotifWaterTitle.
  ///
  /// In en, this message translates to:
  /// **'Drink water 💧'**
  String get setNotifWaterTitle;

  /// No description provided for @setNotifWaterBody.
  ///
  /// In en, this message translates to:
  /// **'A glass now keeps you on target.'**
  String get setNotifWaterBody;

  /// No description provided for @setNotifSupplementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Supplements'**
  String get setNotifSupplementsTitle;

  /// No description provided for @setNotifWeightTitle.
  ///
  /// In en, this message translates to:
  /// **'Morning weigh-in'**
  String get setNotifWeightTitle;

  /// No description provided for @setNotifWeightBody.
  ///
  /// In en, this message translates to:
  /// **'Weigh yourself before eating or drinking.'**
  String get setNotifWeightBody;

  /// No description provided for @setNotifBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'Time for a backup'**
  String get setNotifBackupTitle;

  /// No description provided for @setNotifBackupBody.
  ///
  /// In en, this message translates to:
  /// **'No backup in 2 weeks. Export one from Settings so you don\'t lose your progress.'**
  String get setNotifBackupBody;

  /// No description provided for @setNotifPermissionOff.
  ///
  /// In en, this message translates to:
  /// **'Notifications are turned off for IronMind.'**
  String get setNotifPermissionOff;

  /// No description provided for @setNotifExactOff.
  ///
  /// In en, this message translates to:
  /// **'Exact alarms are off — reminders may arrive a few minutes late.'**
  String get setNotifExactOff;

  /// No description provided for @setNotifAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get setNotifAllow;

  /// No description provided for @setNotifWorkout.
  ///
  /// In en, this message translates to:
  /// **'Workout reminder'**
  String get setNotifWorkout;

  /// No description provided for @setNotifWorkoutDays.
  ///
  /// In en, this message translates to:
  /// **'On training days: {days}'**
  String setNotifWorkoutDays(String days);

  /// No description provided for @setNotifWorkoutNoDays.
  ///
  /// In en, this message translates to:
  /// **'Set your training days in your profile'**
  String get setNotifWorkoutNoDays;

  /// No description provided for @setNotifWorkoutDefault.
  ///
  /// In en, this message translates to:
  /// **'Use default (30 min before {time})'**
  String setNotifWorkoutDefault(String time);

  /// No description provided for @setNotifTime.
  ///
  /// In en, this message translates to:
  /// **'Reminder time'**
  String get setNotifTime;

  /// No description provided for @setNotifMeals.
  ///
  /// In en, this message translates to:
  /// **'Meal reminders'**
  String get setNotifMeals;

  /// No description provided for @setNotifMealsSub.
  ///
  /// In en, this message translates to:
  /// **'At each meal time'**
  String get setNotifMealsSub;

  /// No description provided for @setNotifUseProfileTimes.
  ///
  /// In en, this message translates to:
  /// **'Use meal times from profile'**
  String get setNotifUseProfileTimes;

  /// No description provided for @setNotifWater.
  ///
  /// In en, this message translates to:
  /// **'Water reminders'**
  String get setNotifWater;

  /// No description provided for @setNotifWaterSub.
  ///
  /// In en, this message translates to:
  /// **'While you\'re awake ({wake} – {sleep})'**
  String setNotifWaterSub(String wake, String sleep);

  /// No description provided for @setNotifWaterEvery.
  ///
  /// In en, this message translates to:
  /// **'Remind me every'**
  String get setNotifWaterEvery;

  /// No description provided for @setNotifHours.
  ///
  /// In en, this message translates to:
  /// **'{hours, plural, =1{1 hour} other{{hours} hours}}'**
  String setNotifHours(int hours);

  /// No description provided for @setNotifSupplements.
  ///
  /// In en, this message translates to:
  /// **'Supplement reminders'**
  String get setNotifSupplements;

  /// No description provided for @setNotifNoSupplements.
  ///
  /// In en, this message translates to:
  /// **'No supplements added yet'**
  String get setNotifNoSupplements;

  /// No description provided for @setNotifWeight.
  ///
  /// In en, this message translates to:
  /// **'Morning weigh-in'**
  String get setNotifWeight;

  /// No description provided for @setNotifWeightSub.
  ///
  /// In en, this message translates to:
  /// **'Right after you wake up'**
  String get setNotifWeightSub;

  /// No description provided for @setNotifWeightDefault.
  ///
  /// In en, this message translates to:
  /// **'Use default (15 min after waking)'**
  String get setNotifWeightDefault;

  /// No description provided for @setNotifCoach.
  ///
  /// In en, this message translates to:
  /// **'Coach initiatives'**
  String get setNotifCoach;

  /// No description provided for @setNotifCoachSub.
  ///
  /// In en, this message translates to:
  /// **'Morning message, workout summaries, plateau alerts, weekly report'**
  String get setNotifCoachSub;

  /// No description provided for @setNotifBackup.
  ///
  /// In en, this message translates to:
  /// **'Backup reminder'**
  String get setNotifBackup;

  /// No description provided for @setNotifBackupSub.
  ///
  /// In en, this message translates to:
  /// **'If you haven\'t backed up for 2 weeks'**
  String get setNotifBackupSub;

  /// No description provided for @setNotifTest.
  ///
  /// In en, this message translates to:
  /// **'Send a test notification'**
  String get setNotifTest;

  /// No description provided for @setNotifTestTitle.
  ///
  /// In en, this message translates to:
  /// **'IronMind'**
  String get setNotifTestTitle;

  /// No description provided for @setNotifTestBody.
  ///
  /// In en, this message translates to:
  /// **'Notifications are working ✅'**
  String get setNotifTestBody;

  /// No description provided for @setWidgetWorkoutLabel.
  ///
  /// In en, this message translates to:
  /// **'Today\'s workout'**
  String get setWidgetWorkoutLabel;

  /// No description provided for @setWidgetWorkout.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get setWidgetWorkout;

  /// No description provided for @setWidgetNoPlan.
  ///
  /// In en, this message translates to:
  /// **'No plan yet'**
  String get setWidgetNoPlan;

  /// No description provided for @setWidgetOpenApp.
  ///
  /// In en, this message translates to:
  /// **'Open the app to start'**
  String get setWidgetOpenApp;

  /// No description provided for @setWidgetRestDay.
  ///
  /// In en, this message translates to:
  /// **'Rest day'**
  String get setWidgetRestDay;

  /// No description provided for @setWidgetRestSub.
  ///
  /// In en, this message translates to:
  /// **'Recover well'**
  String get setWidgetRestSub;

  /// No description provided for @setWidgetWorkoutDone.
  ///
  /// In en, this message translates to:
  /// **'Done ✓'**
  String get setWidgetWorkoutDone;

  /// No description provided for @setWidgetExercises.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 exercise} other{{count} exercises}}'**
  String setWidgetExercises(int count);

  /// No description provided for @setWidgetCaloriesLabel.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get setWidgetCaloriesLabel;

  /// No description provided for @setWidgetKcalLeft.
  ///
  /// In en, this message translates to:
  /// **'{kcal} left'**
  String setWidgetKcalLeft(int kcal);

  /// No description provided for @setWidgetKcalOver.
  ///
  /// In en, this message translates to:
  /// **'{kcal} over'**
  String setWidgetKcalOver(int kcal);

  /// No description provided for @setWidgetWaterLabel.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get setWidgetWaterLabel;

  /// No description provided for @setWidgetWaterText.
  ///
  /// In en, this message translates to:
  /// **'{ml} / {goal} ml'**
  String setWidgetWaterText(int ml, int goal);

  /// No description provided for @setWidgetAddCup.
  ///
  /// In en, this message translates to:
  /// **'+ Cup'**
  String get setWidgetAddCup;

  /// No description provided for @setChannelRestLive.
  ///
  /// In en, this message translates to:
  /// **'Rest countdown'**
  String get setChannelRestLive;

  /// No description provided for @setNotifRestLiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Resting'**
  String get setNotifRestLiveTitle;

  /// No description provided for @setNotifRestLiveBody.
  ///
  /// In en, this message translates to:
  /// **'Next set when the countdown ends'**
  String get setNotifRestLiveBody;

  /// No description provided for @todayCoachTitle.
  ///
  /// In en, this message translates to:
  /// **'Coach'**
  String get todayCoachTitle;

  /// No description provided for @todayCoachEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your coach\'s morning message will appear here.'**
  String get todayCoachEmpty;

  /// No description provided for @todayRecoveryTitle.
  ///
  /// In en, this message translates to:
  /// **'Recovery'**
  String get todayRecoveryTitle;

  /// No description provided for @todayRecoveryEmpty.
  ///
  /// In en, this message translates to:
  /// **'Log your sleep or connect Health Connect to get a recovery score.'**
  String get todayRecoveryEmpty;

  /// No description provided for @todayRecoveryHigh.
  ///
  /// In en, this message translates to:
  /// **'Well recovered — push hard today.'**
  String get todayRecoveryHigh;

  /// No description provided for @todayRecoveryModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate recovery — train normally, listen to your body.'**
  String get todayRecoveryModerate;

  /// No description provided for @todayRecoveryLow.
  ///
  /// In en, this message translates to:
  /// **'Low recovery — consider a lighter session today.'**
  String get todayRecoveryLow;

  /// No description provided for @todayWorkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s workout'**
  String get todayWorkoutTitle;

  /// No description provided for @todayNoPlan.
  ///
  /// In en, this message translates to:
  /// **'No active plan yet. Build one from the Workout tab.'**
  String get todayNoPlan;

  /// No description provided for @todayRestDay.
  ///
  /// In en, this message translates to:
  /// **'Rest day. Recover, eat well and hit your water goal.'**
  String get todayRestDay;

  /// No description provided for @todayExerciseCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 exercise} other{{count} exercises}}'**
  String todayExerciseCount(int count);

  /// No description provided for @todayStartWorkout.
  ///
  /// In en, this message translates to:
  /// **'Start today\'s workout'**
  String get todayStartWorkout;

  /// No description provided for @todayResumeWorkout.
  ///
  /// In en, this message translates to:
  /// **'Resume workout'**
  String get todayResumeWorkout;

  /// No description provided for @todayWorkoutDone.
  ///
  /// In en, this message translates to:
  /// **'Done for today 💪'**
  String get todayWorkoutDone;

  /// No description provided for @todayKcalLeft.
  ///
  /// In en, this message translates to:
  /// **'kcal left'**
  String get todayKcalLeft;

  /// No description provided for @todayKcalOver.
  ///
  /// In en, this message translates to:
  /// **'kcal over'**
  String get todayKcalOver;

  /// No description provided for @todayAddCup.
  ///
  /// In en, this message translates to:
  /// **'+ Cup of water'**
  String get todayAddCup;

  /// No description provided for @todaySupplementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Supplements'**
  String get todaySupplementsTitle;

  /// No description provided for @todaySupplementsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No supplements added.'**
  String get todaySupplementsEmpty;

  /// No description provided for @todayWeightTitle.
  ///
  /// In en, this message translates to:
  /// **'Body weight'**
  String get todayWeightTitle;

  /// No description provided for @todayWeightEmpty.
  ///
  /// In en, this message translates to:
  /// **'Tap to log today\'s weight.'**
  String get todayWeightEmpty;

  /// No description provided for @todayWeightAvg.
  ///
  /// In en, this message translates to:
  /// **'7-day avg {avg}'**
  String todayWeightAvg(String avg);

  /// No description provided for @todayGreetMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get todayGreetMorning;

  /// No description provided for @todayGreetAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get todayGreetAfternoon;

  /// No description provided for @todayGreetEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get todayGreetEvening;

  /// No description provided for @trkWaterTitle.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get trkWaterTitle;

  /// No description provided for @trkSupplementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Supplements'**
  String get trkSupplementsTitle;

  /// No description provided for @trkSleepTitle.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get trkSleepTitle;

  /// No description provided for @trkWeightTitle.
  ///
  /// In en, this message translates to:
  /// **'Body weight'**
  String get trkWeightTitle;

  /// No description provided for @trkMeasurementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Measurements'**
  String get trkMeasurementsTitle;

  /// No description provided for @trkPhotosTitle.
  ///
  /// In en, this message translates to:
  /// **'Progress photos'**
  String get trkPhotosTitle;

  /// No description provided for @trkHealthConnectTitle.
  ///
  /// In en, this message translates to:
  /// **'Health Connect & ring'**
  String get trkHealthConnectTitle;

  /// No description provided for @trkDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get trkDate;

  /// No description provided for @trkHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get trkHistory;

  /// No description provided for @trkLast7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get trkLast7Days;

  /// No description provided for @trkInvalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number'**
  String get trkInvalidNumber;

  /// No description provided for @trkDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?'**
  String trkDeleteConfirm(String name);

  /// No description provided for @trkDeleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get trkDeleted;

  /// No description provided for @trkHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{h}h {m}m'**
  String trkHoursMinutes(int h, int m);

  /// No description provided for @trkSourceManual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get trkSourceManual;

  /// No description provided for @trkSourceHealthConnect.
  ///
  /// In en, this message translates to:
  /// **'Health Connect'**
  String get trkSourceHealthConnect;

  /// No description provided for @trkSyncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get trkSyncNow;

  /// No description provided for @trkSyncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing…'**
  String get trkSyncing;

  /// No description provided for @trkSyncDone.
  ///
  /// In en, this message translates to:
  /// **'Synced'**
  String get trkSyncDone;

  /// No description provided for @trkSyncFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t sync — your manual entries still work'**
  String get trkSyncFailed;

  /// No description provided for @trkTypeValue.
  ///
  /// In en, this message translates to:
  /// **'Type a value'**
  String get trkTypeValue;

  /// No description provided for @trkClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get trkClear;

  /// No description provided for @trkWaterProgress.
  ///
  /// In en, this message translates to:
  /// **'{drunk} / {goal} ml'**
  String trkWaterProgress(int drunk, int goal);

  /// No description provided for @trkWaterRemaining.
  ///
  /// In en, this message translates to:
  /// **'{ml} ml left today'**
  String trkWaterRemaining(int ml);

  /// No description provided for @trkWaterGoalReached.
  ///
  /// In en, this message translates to:
  /// **'Daily goal reached. Nice!'**
  String get trkWaterGoalReached;

  /// No description provided for @trkAddCup.
  ///
  /// In en, this message translates to:
  /// **'Cup · {ml} ml'**
  String trkAddCup(int ml);

  /// No description provided for @trkAddBottle.
  ///
  /// In en, this message translates to:
  /// **'Bottle · {ml} ml'**
  String trkAddBottle(int ml);

  /// No description provided for @trkAddCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom amount'**
  String get trkAddCustom;

  /// No description provided for @trkUndoLast.
  ///
  /// In en, this message translates to:
  /// **'Undo last'**
  String get trkUndoLast;

  /// No description provided for @trkUndone.
  ///
  /// In en, this message translates to:
  /// **'Removed {ml} ml'**
  String trkUndone(int ml);

  /// No description provided for @trkWaterAdded.
  ///
  /// In en, this message translates to:
  /// **'+{ml} ml'**
  String trkWaterAdded(int ml);

  /// No description provided for @trkWaterSizes.
  ///
  /// In en, this message translates to:
  /// **'Cup & bottle sizes'**
  String get trkWaterSizes;

  /// No description provided for @trkCupSize.
  ///
  /// In en, this message translates to:
  /// **'Cup size (ml)'**
  String get trkCupSize;

  /// No description provided for @trkBottleSize.
  ///
  /// In en, this message translates to:
  /// **'Bottle size (ml)'**
  String get trkBottleSize;

  /// No description provided for @trkAmountMl.
  ///
  /// In en, this message translates to:
  /// **'Amount (ml)'**
  String get trkAmountMl;

  /// No description provided for @trkTodayEntries.
  ///
  /// In en, this message translates to:
  /// **'Today\'s entries'**
  String get trkTodayEntries;

  /// No description provided for @trkNoWaterYet.
  ///
  /// In en, this message translates to:
  /// **'No water logged today yet'**
  String get trkNoWaterYet;

  /// No description provided for @trkGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'Goal {ml} ml'**
  String trkGoalLabel(int ml);

  /// No description provided for @trkSuppToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get trkSuppToday;

  /// No description provided for @trkSuppTakenCount.
  ///
  /// In en, this message translates to:
  /// **'{taken} of {total} taken'**
  String trkSuppTakenCount(int taken, int total);

  /// No description provided for @trkSuppManage.
  ///
  /// In en, this message translates to:
  /// **'My supplements'**
  String get trkSuppManage;

  /// No description provided for @trkSuppAdd.
  ///
  /// In en, this message translates to:
  /// **'Add supplement'**
  String get trkSuppAdd;

  /// No description provided for @trkSuppEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit supplement'**
  String get trkSuppEdit;

  /// No description provided for @trkSuppName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get trkSuppName;

  /// No description provided for @trkSuppDose.
  ///
  /// In en, this message translates to:
  /// **'Dose (e.g. 5 g, 1 scoop)'**
  String get trkSuppDose;

  /// No description provided for @trkSuppTiming.
  ///
  /// In en, this message translates to:
  /// **'Timing'**
  String get trkSuppTiming;

  /// No description provided for @trkTimingMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get trkTimingMorning;

  /// No description provided for @trkTimingPreWorkout.
  ///
  /// In en, this message translates to:
  /// **'Pre-workout'**
  String get trkTimingPreWorkout;

  /// No description provided for @trkTimingPostWorkout.
  ///
  /// In en, this message translates to:
  /// **'Post-workout'**
  String get trkTimingPostWorkout;

  /// No description provided for @trkTimingWithMeal.
  ///
  /// In en, this message translates to:
  /// **'With a meal'**
  String get trkTimingWithMeal;

  /// No description provided for @trkTimingEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get trkTimingEvening;

  /// No description provided for @trkTimingBedtime.
  ///
  /// In en, this message translates to:
  /// **'Before bed'**
  String get trkTimingBedtime;

  /// No description provided for @trkSuppPerServing.
  ///
  /// In en, this message translates to:
  /// **'Per serving (added to your daily macros when ticked)'**
  String get trkSuppPerServing;

  /// No description provided for @trkSuppProtein.
  ///
  /// In en, this message translates to:
  /// **'Protein (g)'**
  String get trkSuppProtein;

  /// No description provided for @trkSuppCalories.
  ///
  /// In en, this message translates to:
  /// **'Calories (kcal)'**
  String get trkSuppCalories;

  /// No description provided for @trkSuppCarbs.
  ///
  /// In en, this message translates to:
  /// **'Carbs (g)'**
  String get trkSuppCarbs;

  /// No description provided for @trkSuppFat.
  ///
  /// In en, this message translates to:
  /// **'Fat (g)'**
  String get trkSuppFat;

  /// No description provided for @trkSuppActive.
  ///
  /// In en, this message translates to:
  /// **'In use'**
  String get trkSuppActive;

  /// No description provided for @trkSuppPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get trkSuppPaused;

  /// No description provided for @trkSuppEmpty.
  ///
  /// In en, this message translates to:
  /// **'Add the supplements you take, then tick them off every day.'**
  String get trkSuppEmpty;

  /// No description provided for @trkSuppImport.
  ///
  /// In en, this message translates to:
  /// **'Import from my profile'**
  String get trkSuppImport;

  /// No description provided for @trkSuppImported.
  ///
  /// In en, this message translates to:
  /// **'{count} imported'**
  String trkSuppImported(int count);

  /// No description provided for @trkSuppNote.
  ///
  /// In en, this message translates to:
  /// **'Logging only — the app doesn\'t recommend supplements.'**
  String get trkSuppNote;

  /// No description provided for @trkSuppNoneActive.
  ///
  /// In en, this message translates to:
  /// **'No supplements in use'**
  String get trkSuppNoneActive;

  /// No description provided for @trkNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get trkNameRequired;

  /// No description provided for @trkSuppMacros.
  ///
  /// In en, this message translates to:
  /// **'{protein} g protein · {calories} kcal'**
  String trkSuppMacros(String protein, String calories);

  /// No description provided for @trkSleepLastNight.
  ///
  /// In en, this message translates to:
  /// **'Last night'**
  String get trkSleepLastNight;

  /// No description provided for @trkSleepNoData.
  ///
  /// In en, this message translates to:
  /// **'No sleep logged for last night'**
  String get trkSleepNoData;

  /// No description provided for @trkSleepLog.
  ///
  /// In en, this message translates to:
  /// **'Log sleep'**
  String get trkSleepLog;

  /// No description provided for @trkSleepEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit sleep'**
  String get trkSleepEdit;

  /// No description provided for @trkSleepHours.
  ///
  /// In en, this message translates to:
  /// **'Hours slept'**
  String get trkSleepHours;

  /// No description provided for @trkSleepQuality.
  ///
  /// In en, this message translates to:
  /// **'Quality'**
  String get trkSleepQuality;

  /// No description provided for @trkQuality1.
  ///
  /// In en, this message translates to:
  /// **'Very bad'**
  String get trkQuality1;

  /// No description provided for @trkQuality2.
  ///
  /// In en, this message translates to:
  /// **'Bad'**
  String get trkQuality2;

  /// No description provided for @trkQuality3.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get trkQuality3;

  /// No description provided for @trkQuality4.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get trkQuality4;

  /// No description provided for @trkQuality5.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get trkQuality5;

  /// No description provided for @trkBedTime.
  ///
  /// In en, this message translates to:
  /// **'Bedtime'**
  String get trkBedTime;

  /// No description provided for @trkWakeTime.
  ///
  /// In en, this message translates to:
  /// **'Wake-up'**
  String get trkWakeTime;

  /// No description provided for @trkSleepDate.
  ///
  /// In en, this message translates to:
  /// **'Woke up on'**
  String get trkSleepDate;

  /// No description provided for @trkOptionalTimes.
  ///
  /// In en, this message translates to:
  /// **'Bed & wake times (optional)'**
  String get trkOptionalTimes;

  /// No description provided for @trkStageDeep.
  ///
  /// In en, this message translates to:
  /// **'Deep'**
  String get trkStageDeep;

  /// No description provided for @trkStageRem.
  ///
  /// In en, this message translates to:
  /// **'REM'**
  String get trkStageRem;

  /// No description provided for @trkStageLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get trkStageLight;

  /// No description provided for @trkStageAwake.
  ///
  /// In en, this message translates to:
  /// **'Awake'**
  String get trkStageAwake;

  /// No description provided for @trkSleepWeekAvg.
  ///
  /// In en, this message translates to:
  /// **'7-day average {value}'**
  String trkSleepWeekAvg(String value);

  /// No description provided for @trkSleepNeed.
  ///
  /// In en, this message translates to:
  /// **'Your need {value}'**
  String trkSleepNeed(String value);

  /// No description provided for @trkSleepConnectHint.
  ///
  /// In en, this message translates to:
  /// **'Connect your ring through Health Connect to fill sleep and stages automatically.'**
  String get trkSleepConnectHint;

  /// No description provided for @trkSleepManualOverrides.
  ///
  /// In en, this message translates to:
  /// **'A manual entry replaces the ring data for that night.'**
  String get trkSleepManualOverrides;

  /// No description provided for @trkSleepEmpty.
  ///
  /// In en, this message translates to:
  /// **'No sleep logged yet.'**
  String get trkSleepEmpty;

  /// No description provided for @trkRecoveryToday.
  ///
  /// In en, this message translates to:
  /// **'Recovery today'**
  String get trkRecoveryToday;

  /// No description provided for @trkRecoveryLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get trkRecoveryLow;

  /// No description provided for @trkRecoveryModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get trkRecoveryModerate;

  /// No description provided for @trkRecoveryHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get trkRecoveryHigh;

  /// No description provided for @trkRecoveryCalibrating.
  ///
  /// In en, this message translates to:
  /// **'Baseline still calibrating ({days}/14 days)'**
  String trkRecoveryCalibrating(int days);

  /// No description provided for @trkWeightLog.
  ///
  /// In en, this message translates to:
  /// **'Log weight'**
  String get trkWeightLog;

  /// No description provided for @trkWeightLatest.
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get trkWeightLatest;

  /// No description provided for @trkWeightAvg7.
  ///
  /// In en, this message translates to:
  /// **'7-day average'**
  String get trkWeightAvg7;

  /// No description provided for @trkWeightChange7.
  ///
  /// In en, this message translates to:
  /// **'vs last week'**
  String get trkWeightChange7;

  /// No description provided for @trkWeightDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get trkWeightDaily;

  /// No description provided for @trkRange1M.
  ///
  /// In en, this message translates to:
  /// **'1M'**
  String get trkRange1M;

  /// No description provided for @trkRange3M.
  ///
  /// In en, this message translates to:
  /// **'3M'**
  String get trkRange3M;

  /// No description provided for @trkRange1Y.
  ///
  /// In en, this message translates to:
  /// **'1Y'**
  String get trkRange1Y;

  /// No description provided for @trkRangeAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get trkRangeAll;

  /// No description provided for @trkWeightEmpty.
  ///
  /// In en, this message translates to:
  /// **'Weigh yourself every morning — the 7-day average smooths out daily swings.'**
  String get trkWeightEmpty;

  /// No description provided for @trkWeightSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved {kg} kg'**
  String trkWeightSaved(String kg);

  /// No description provided for @trkWeightKg.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get trkWeightKg;

  /// No description provided for @trkNeedTwoPoints.
  ///
  /// In en, this message translates to:
  /// **'Log a few days to see the chart'**
  String get trkNeedTwoPoints;

  /// No description provided for @trkMeasureWaist.
  ///
  /// In en, this message translates to:
  /// **'Waist'**
  String get trkMeasureWaist;

  /// No description provided for @trkMeasureChest.
  ///
  /// In en, this message translates to:
  /// **'Chest'**
  String get trkMeasureChest;

  /// No description provided for @trkMeasureArm.
  ///
  /// In en, this message translates to:
  /// **'Arm'**
  String get trkMeasureArm;

  /// No description provided for @trkMeasureThigh.
  ///
  /// In en, this message translates to:
  /// **'Thigh'**
  String get trkMeasureThigh;

  /// No description provided for @trkMeasureNeck.
  ///
  /// In en, this message translates to:
  /// **'Neck'**
  String get trkMeasureNeck;

  /// No description provided for @trkMeasureHips.
  ///
  /// In en, this message translates to:
  /// **'Hips'**
  String get trkMeasureHips;

  /// No description provided for @trkMeasureBodyFat.
  ///
  /// In en, this message translates to:
  /// **'Body fat %'**
  String get trkMeasureBodyFat;

  /// No description provided for @trkMeasureNew.
  ///
  /// In en, this message translates to:
  /// **'New measurements'**
  String get trkMeasureNew;

  /// No description provided for @trkMeasureEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit measurements'**
  String get trkMeasureEdit;

  /// No description provided for @trkMeasureDue.
  ///
  /// In en, this message translates to:
  /// **'It\'s been over a week since your last measurements — measure today.'**
  String get trkMeasureDue;

  /// No description provided for @trkMeasureNone.
  ///
  /// In en, this message translates to:
  /// **'No measurements yet — take them once a week, same time of day.'**
  String get trkMeasureNone;

  /// No description provided for @trkMeasureTip.
  ///
  /// In en, this message translates to:
  /// **'Measure in the morning before eating; tape snug, not tight.'**
  String get trkMeasureTip;

  /// No description provided for @trkMeasureNeedOne.
  ///
  /// In en, this message translates to:
  /// **'Enter at least one value'**
  String get trkMeasureNeedOne;

  /// No description provided for @trkLastMeasured.
  ///
  /// In en, this message translates to:
  /// **'Last: {date}'**
  String trkLastMeasured(String date);

  /// No description provided for @trkPhotosLocked.
  ///
  /// In en, this message translates to:
  /// **'Progress photos are locked'**
  String get trkPhotosLocked;

  /// No description provided for @trkPhotosUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get trkPhotosUnlock;

  /// No description provided for @trkPhotosAuthReason.
  ///
  /// In en, this message translates to:
  /// **'Unlock to view your progress photos'**
  String get trkPhotosAuthReason;

  /// No description provided for @trkPhotosAdd.
  ///
  /// In en, this message translates to:
  /// **'Add photos'**
  String get trkPhotosAdd;

  /// No description provided for @trkPhotosCompare.
  ///
  /// In en, this message translates to:
  /// **'Compare'**
  String get trkPhotosCompare;

  /// No description provided for @trkAngleFront.
  ///
  /// In en, this message translates to:
  /// **'Front'**
  String get trkAngleFront;

  /// No description provided for @trkAngleSide.
  ///
  /// In en, this message translates to:
  /// **'Side'**
  String get trkAngleSide;

  /// No description provided for @trkAngleBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get trkAngleBack;

  /// No description provided for @trkCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get trkCamera;

  /// No description provided for @trkGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get trkGallery;

  /// No description provided for @trkPhotosEmpty.
  ///
  /// In en, this message translates to:
  /// **'Take front, side and back photos every 2–4 weeks in the same light and pose.'**
  String get trkPhotosEmpty;

  /// No description provided for @trkPhotosPrivate.
  ///
  /// In en, this message translates to:
  /// **'Saved privately inside the app — never in your gallery and never sent to the AI.'**
  String get trkPhotosPrivate;

  /// No description provided for @trkPhotoDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this photo?'**
  String get trkPhotoDeleteConfirm;

  /// No description provided for @trkBefore.
  ///
  /// In en, this message translates to:
  /// **'Before'**
  String get trkBefore;

  /// No description provided for @trkAfter.
  ///
  /// In en, this message translates to:
  /// **'After'**
  String get trkAfter;

  /// No description provided for @trkSideBySide.
  ///
  /// In en, this message translates to:
  /// **'Side by side'**
  String get trkSideBySide;

  /// No description provided for @trkSlider.
  ///
  /// In en, this message translates to:
  /// **'Slider'**
  String get trkSlider;

  /// No description provided for @trkNoPhotoForAngle.
  ///
  /// In en, this message translates to:
  /// **'No photo for this angle on this date'**
  String get trkNoPhotoForAngle;

  /// No description provided for @trkComparePickTwo.
  ///
  /// In en, this message translates to:
  /// **'Add photos on at least two dates to compare.'**
  String get trkComparePickTwo;

  /// No description provided for @trkPhotoSaved.
  ///
  /// In en, this message translates to:
  /// **'Photo saved'**
  String get trkPhotoSaved;

  /// No description provided for @trkPhotoFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save the photo'**
  String get trkPhotoFailed;

  /// No description provided for @trkPhotoMissing.
  ///
  /// In en, this message translates to:
  /// **'Photo file missing'**
  String get trkPhotoMissing;

  /// No description provided for @trkPhotosForDate.
  ///
  /// In en, this message translates to:
  /// **'Photos for {date}'**
  String trkPhotosForDate(String date);

  /// No description provided for @trkDragToCompare.
  ///
  /// In en, this message translates to:
  /// **'Drag to compare'**
  String get trkDragToCompare;

  /// No description provided for @trkHcEnable.
  ///
  /// In en, this message translates to:
  /// **'Use Health Connect'**
  String get trkHcEnable;

  /// No description provided for @trkHcEnableSub.
  ///
  /// In en, this message translates to:
  /// **'Read sleep, heart rate, HRV, steps and calories written by your ring\'s app'**
  String get trkHcEnableSub;

  /// No description provided for @trkHcStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get trkHcStatus;

  /// No description provided for @trkHcAvailable.
  ///
  /// In en, this message translates to:
  /// **'Health Connect is installed'**
  String get trkHcAvailable;

  /// No description provided for @trkHcNotInstalled.
  ///
  /// In en, this message translates to:
  /// **'Health Connect isn\'t installed'**
  String get trkHcNotInstalled;

  /// No description provided for @trkHcNeedsUpdate.
  ///
  /// In en, this message translates to:
  /// **'Health Connect needs an update'**
  String get trkHcNeedsUpdate;

  /// No description provided for @trkHcUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Health Connect isn\'t supported on this device'**
  String get trkHcUnsupported;

  /// No description provided for @trkHcInstall.
  ///
  /// In en, this message translates to:
  /// **'Install Health Connect'**
  String get trkHcInstall;

  /// No description provided for @trkHcInstallHint.
  ///
  /// In en, this message translates to:
  /// **'Android 14+ has it built in (Settings → Security & privacy → Health Connect). On older phones install it from the Play Store.'**
  String get trkHcInstallHint;

  /// No description provided for @trkHcPermGranted.
  ///
  /// In en, this message translates to:
  /// **'Read permissions granted'**
  String get trkHcPermGranted;

  /// No description provided for @trkHcPermMissing.
  ///
  /// In en, this message translates to:
  /// **'Read permissions not granted yet'**
  String get trkHcPermMissing;

  /// No description provided for @trkHcGrant.
  ///
  /// In en, this message translates to:
  /// **'Grant permissions'**
  String get trkHcGrant;

  /// No description provided for @trkHcBgGranted.
  ///
  /// In en, this message translates to:
  /// **'Background reading allowed'**
  String get trkHcBgGranted;

  /// No description provided for @trkHcBgMissing.
  ///
  /// In en, this message translates to:
  /// **'Background reading not allowed (sync runs when you open the app)'**
  String get trkHcBgMissing;

  /// No description provided for @trkHcBgAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow background reading'**
  String get trkHcBgAllow;

  /// No description provided for @trkHcLastSync.
  ///
  /// In en, this message translates to:
  /// **'Last sync: {time}'**
  String trkHcLastSync(String time);

  /// No description provided for @trkHcNeverSynced.
  ///
  /// In en, this message translates to:
  /// **'Never synced'**
  String get trkHcNeverSynced;

  /// No description provided for @trkHcOutcomeOk.
  ///
  /// In en, this message translates to:
  /// **'Last sync pulled {count} data points'**
  String trkHcOutcomeOk(int count);

  /// No description provided for @trkHcOutcomeNoPermission.
  ///
  /// In en, this message translates to:
  /// **'Last sync: no permission to read data'**
  String get trkHcOutcomeNoPermission;

  /// No description provided for @trkHcOutcomeUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Last sync: Health Connect unavailable'**
  String get trkHcOutcomeUnavailable;

  /// No description provided for @trkHcOutcomeError.
  ///
  /// In en, this message translates to:
  /// **'Last sync failed'**
  String get trkHcOutcomeError;

  /// No description provided for @trkHcLastPulled.
  ///
  /// In en, this message translates to:
  /// **'Last data pulled'**
  String get trkHcLastPulled;

  /// No description provided for @trkHcLastPulledSub.
  ///
  /// In en, this message translates to:
  /// **'Check the source app: if your ring\'s app shows up here with recent dates, it writes to Health Connect.'**
  String get trkHcLastPulledSub;

  /// No description provided for @trkHcColType.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get trkHcColType;

  /// No description provided for @trkHcColDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get trkHcColDate;

  /// No description provided for @trkHcColValue.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get trkHcColValue;

  /// No description provided for @trkHcColSource.
  ///
  /// In en, this message translates to:
  /// **'Source app'**
  String get trkHcColSource;

  /// No description provided for @trkHcNothing.
  ///
  /// In en, this message translates to:
  /// **'Nothing yet'**
  String get trkHcNothing;

  /// No description provided for @trkHcTypeSleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep session'**
  String get trkHcTypeSleep;

  /// No description provided for @trkHcTypeAsleep.
  ///
  /// In en, this message translates to:
  /// **'Asleep (no stage)'**
  String get trkHcTypeAsleep;

  /// No description provided for @trkHcTypeHr.
  ///
  /// In en, this message translates to:
  /// **'Heart rate'**
  String get trkHcTypeHr;

  /// No description provided for @trkHcTypeRhr.
  ///
  /// In en, this message translates to:
  /// **'Resting heart rate'**
  String get trkHcTypeRhr;

  /// No description provided for @trkHcTypeHrv.
  ///
  /// In en, this message translates to:
  /// **'HRV (RMSSD)'**
  String get trkHcTypeHrv;

  /// No description provided for @trkHcTypeSteps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get trkHcTypeSteps;

  /// No description provided for @trkHcTypeCalories.
  ///
  /// In en, this message translates to:
  /// **'Active calories'**
  String get trkHcTypeCalories;

  /// No description provided for @trkHcSources.
  ///
  /// In en, this message translates to:
  /// **'Apps writing data: {apps}'**
  String trkHcSources(String apps);

  /// No description provided for @trkHcCardooTitle.
  ///
  /// In en, this message translates to:
  /// **'Is your ring\'s data arriving?'**
  String get trkHcCardooTitle;

  /// No description provided for @trkHcCardooBody.
  ///
  /// In en, this message translates to:
  /// **'It\'s not confirmed that the Cardoo app writes to Health Connect. Open the Cardoo app and enable syncing to Health Connect if it offers it, wear the ring for a night, then tap Sync now and check the table below.'**
  String get trkHcCardooBody;

  /// No description provided for @trkHcManualFallback.
  ///
  /// In en, this message translates to:
  /// **'If nothing arrives, IronMind just uses what you log manually (sleep, weight…). Nothing breaks.'**
  String get trkHcManualFallback;

  /// No description provided for @trkHcEnabledToast.
  ///
  /// In en, this message translates to:
  /// **'Health Connect enabled'**
  String get trkHcEnabledToast;

  /// No description provided for @trkHcDisabledToast.
  ///
  /// In en, this message translates to:
  /// **'Health Connect disabled — manual entry only'**
  String get trkHcDisabledToast;

  /// No description provided for @trkUnitBpm.
  ///
  /// In en, this message translates to:
  /// **'bpm'**
  String get trkUnitBpm;

  /// No description provided for @trkUnitMs.
  ///
  /// In en, this message translates to:
  /// **'ms'**
  String get trkUnitMs;

  /// No description provided for @trkUnitSteps.
  ///
  /// In en, this message translates to:
  /// **'steps'**
  String get trkUnitSteps;

  /// No description provided for @woAddCardio.
  ///
  /// In en, this message translates to:
  /// **'Add cardio'**
  String get woAddCardio;

  /// No description provided for @woAddExercise.
  ///
  /// In en, this message translates to:
  /// **'Add exercise'**
  String get woAddExercise;

  /// No description provided for @woApprovePlan.
  ///
  /// In en, this message translates to:
  /// **'Approve plan'**
  String get woApprovePlan;

  /// No description provided for @woAskCoach.
  ///
  /// In en, this message translates to:
  /// **'Ask the coach to review'**
  String get woAskCoach;

  /// No description provided for @woBuildTemplate.
  ///
  /// In en, this message translates to:
  /// **'Build a basic plan (no AI)'**
  String get woBuildTemplate;

  /// No description provided for @woCaloriesAuto.
  ///
  /// In en, this message translates to:
  /// **'Estimated automatically (MET) – you can edit it'**
  String get woCaloriesAuto;

  /// No description provided for @woCardio.
  ///
  /// In en, this message translates to:
  /// **'Cardio'**
  String get woCardio;

  /// No description provided for @woCardioBike.
  ///
  /// In en, this message translates to:
  /// **'Bike'**
  String get woCardioBike;

  /// No description provided for @woCardioElliptical.
  ///
  /// In en, this message translates to:
  /// **'Elliptical'**
  String get woCardioElliptical;

  /// No description provided for @woCardioJumpRope.
  ///
  /// In en, this message translates to:
  /// **'Jump rope'**
  String get woCardioJumpRope;

  /// No description provided for @woCardioOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get woCardioOther;

  /// No description provided for @woCardioRowing.
  ///
  /// In en, this message translates to:
  /// **'Rowing'**
  String get woCardioRowing;

  /// No description provided for @woCardioRun.
  ///
  /// In en, this message translates to:
  /// **'Run'**
  String get woCardioRun;

  /// No description provided for @woCardioStairs.
  ///
  /// In en, this message translates to:
  /// **'Stairs'**
  String get woCardioStairs;

  /// No description provided for @woCardioSwim.
  ///
  /// In en, this message translates to:
  /// **'Swim'**
  String get woCardioSwim;

  /// No description provided for @woCardioTreadmill.
  ///
  /// In en, this message translates to:
  /// **'Treadmill'**
  String get woCardioTreadmill;

  /// No description provided for @woCardioWalk.
  ///
  /// In en, this message translates to:
  /// **'Walk'**
  String get woCardioWalk;

  /// No description provided for @woCoachEvaluation.
  ///
  /// In en, this message translates to:
  /// **'Coach evaluation'**
  String get woCoachEvaluation;

  /// No description provided for @woCoachNeedsKey.
  ///
  /// In en, this message translates to:
  /// **'Add your Claude API key to get the coach\'s evaluation of this workout.'**
  String get woCoachNeedsKey;

  /// No description provided for @woCoachQueued.
  ///
  /// In en, this message translates to:
  /// **'No internet – the coach will review this workout as soon as you\'re back online.'**
  String get woCoachQueued;

  /// No description provided for @woCoachReviewing.
  ///
  /// In en, this message translates to:
  /// **'The coach is reviewing your workout…'**
  String get woCoachReviewing;

  /// No description provided for @woContinueWorkout.
  ///
  /// In en, this message translates to:
  /// **'Continue this workout'**
  String get woContinueWorkout;

  /// No description provided for @woCooldown.
  ///
  /// In en, this message translates to:
  /// **'Cool-down'**
  String get woCooldown;

  /// No description provided for @woCopyLast.
  ///
  /// In en, this message translates to:
  /// **'Copy last'**
  String get woCopyLast;

  /// No description provided for @woDeleteSession.
  ///
  /// In en, this message translates to:
  /// **'Delete workout'**
  String get woDeleteSession;

  /// No description provided for @woDeleteSessionBody.
  ///
  /// In en, this message translates to:
  /// **'All sets, cardio and notes of this workout will be deleted.'**
  String get woDeleteSessionBody;

  /// No description provided for @woDeleteSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this workout?'**
  String get woDeleteSessionTitle;

  /// No description provided for @woDeleteSetTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this set?'**
  String get woDeleteSetTitle;

  /// No description provided for @woDeloadActiveBody.
  ///
  /// In en, this message translates to:
  /// **'Lighter week: suggestions use 85% of your weights. Focus on technique and recovery.'**
  String get woDeloadActiveBody;

  /// No description provided for @woDeloadActiveShort.
  ///
  /// In en, this message translates to:
  /// **'Deload week – 85% weights'**
  String get woDeloadActiveShort;

  /// No description provided for @woDeloadActiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Deload week – day {day} of 7'**
  String woDeloadActiveTitle(int day);

  /// No description provided for @woDeloadBadge.
  ///
  /// In en, this message translates to:
  /// **'Deload'**
  String get woDeloadBadge;

  /// No description provided for @woDeloadDuePerformance.
  ///
  /// In en, this message translates to:
  /// **'Your estimated 1RMs dropped over the last 2 weeks – that\'s usually accumulated fatigue. A lighter week at 85% will bring you back stronger.'**
  String get woDeloadDuePerformance;

  /// No description provided for @woDeloadDueSchedule.
  ///
  /// In en, this message translates to:
  /// **'You\'ve trained hard for {weeks} weeks. A lighter week at 85% weights helps you recover and keep progressing.'**
  String woDeloadDueSchedule(int weeks);

  /// No description provided for @woDeloadDueTitle.
  ///
  /// In en, this message translates to:
  /// **'Time for a deload week?'**
  String get woDeloadDueTitle;

  /// No description provided for @woDeloadEvery.
  ///
  /// In en, this message translates to:
  /// **'Deload every {weeks} weeks'**
  String woDeloadEvery(int weeks);

  /// No description provided for @woDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get woDiscard;

  /// No description provided for @woDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get woDuration;

  /// No description provided for @woEditPlan.
  ///
  /// In en, this message translates to:
  /// **'Edit plan'**
  String get woEditPlan;

  /// No description provided for @woEndDeload.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get woEndDeload;

  /// No description provided for @woExerciseCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{no exercises} =1{1 exercise} other{{count} exercises}}'**
  String woExerciseCount(int count);

  /// No description provided for @woExerciseInfo.
  ///
  /// In en, this message translates to:
  /// **'Exercise details'**
  String get woExerciseInfo;

  /// No description provided for @woExerciseNote.
  ///
  /// In en, this message translates to:
  /// **'Exercise note'**
  String get woExerciseNote;

  /// No description provided for @woExerciseNoteHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. shoulder hurts on the way down'**
  String get woExerciseNoteHint;

  /// No description provided for @woExercises.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get woExercises;

  /// No description provided for @woFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get woFinish;

  /// No description provided for @woFinishPartialBody.
  ///
  /// In en, this message translates to:
  /// **'Not all planned sets are done. It will be saved as a partial workout.'**
  String get woFinishPartialBody;

  /// No description provided for @woFinishPartialTitle.
  ///
  /// In en, this message translates to:
  /// **'Finish anyway?'**
  String get woFinishPartialTitle;

  /// No description provided for @woFinishWorkout.
  ///
  /// In en, this message translates to:
  /// **'Finish workout'**
  String get woFinishWorkout;

  /// No description provided for @woFirstTime.
  ///
  /// In en, this message translates to:
  /// **'First time – no comparison yet'**
  String get woFirstTime;

  /// No description provided for @woFreeWorkout.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get woFreeWorkout;

  /// No description provided for @woFreeWorkoutHint.
  ///
  /// In en, this message translates to:
  /// **'Add exercises from the library and log your sets.'**
  String get woFreeWorkoutHint;

  /// No description provided for @woGenerateWithAi.
  ///
  /// In en, this message translates to:
  /// **'Build my plan with AI'**
  String get woGenerateWithAi;

  /// No description provided for @woGeneratingPlan.
  ///
  /// In en, this message translates to:
  /// **'Building your plan… this can take a minute.'**
  String get woGeneratingPlan;

  /// No description provided for @woHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get woHistory;

  /// No description provided for @woIncline.
  ///
  /// In en, this message translates to:
  /// **'Incline'**
  String get woIncline;

  /// No description provided for @woKmh.
  ///
  /// In en, this message translates to:
  /// **'km/h'**
  String get woKmh;

  /// No description provided for @woLastTime.
  ///
  /// In en, this message translates to:
  /// **'Last time'**
  String get woLastTime;

  /// No description provided for @woLevel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get woLevel;

  /// No description provided for @woLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get woLibrary;

  /// No description provided for @woMissedBody.
  ///
  /// In en, this message translates to:
  /// **'This training day was missed. The schedule doesn\'t shift – just show up next time.'**
  String get woMissedBody;

  /// No description provided for @woNewRecords.
  ///
  /// In en, this message translates to:
  /// **'New records'**
  String get woNewRecords;

  /// No description provided for @woNoExercises.
  ///
  /// In en, this message translates to:
  /// **'No exercises yet'**
  String get woNoExercises;

  /// No description provided for @woNoHistory.
  ///
  /// In en, this message translates to:
  /// **'No workouts yet. Your sessions will show up here.'**
  String get woNoHistory;

  /// No description provided for @woNoPlan.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have an active workout plan yet. Build one with AI, or start with a basic plan that works offline.'**
  String get woNoPlan;

  /// No description provided for @woNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get woNotNow;

  /// No description provided for @woNothingLoggedBody.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t logged any set or cardio. Discard this workout?'**
  String get woNothingLoggedBody;

  /// No description provided for @woNothingLoggedTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing logged'**
  String get woNothingLoggedTitle;

  /// No description provided for @woNothingToCopy.
  ///
  /// In en, this message translates to:
  /// **'No previous set to copy'**
  String get woNothingToCopy;

  /// No description provided for @woPendingPlan.
  ///
  /// In en, this message translates to:
  /// **'A new plan is waiting for your review'**
  String get woPendingPlan;

  /// No description provided for @woPickFromLibrary.
  ///
  /// In en, this message translates to:
  /// **'Pick from the library'**
  String get woPickFromLibrary;

  /// No description provided for @woPlanApproved.
  ///
  /// In en, this message translates to:
  /// **'Plan activated 💪'**
  String get woPlanApproved;

  /// No description provided for @woPlanNotFound.
  ///
  /// In en, this message translates to:
  /// **'Plan not found'**
  String get woPlanNotFound;

  /// No description provided for @woPlanTools.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get woPlanTools;

  /// No description provided for @woPrBanner.
  ///
  /// In en, this message translates to:
  /// **'New PR! {exercise}: {types}'**
  String woPrBanner(String exercise, String types);

  /// No description provided for @woPrE1rm.
  ///
  /// In en, this message translates to:
  /// **'Best 1RM'**
  String get woPrE1rm;

  /// No description provided for @woPrReps.
  ///
  /// In en, this message translates to:
  /// **'Most reps'**
  String get woPrReps;

  /// No description provided for @woPrWeight.
  ///
  /// In en, this message translates to:
  /// **'Heaviest weight'**
  String get woPrWeight;

  /// No description provided for @woPrs.
  ///
  /// In en, this message translates to:
  /// **'PRs'**
  String get woPrs;

  /// No description provided for @woReasonAddReps.
  ///
  /// In en, this message translates to:
  /// **'Same weight – aim for one more rep.'**
  String get woReasonAddReps;

  /// No description provided for @woReasonDeload.
  ///
  /// In en, this message translates to:
  /// **'Deload: 85% of last time.'**
  String get woReasonDeload;

  /// No description provided for @woReasonFirstTime.
  ///
  /// In en, this message translates to:
  /// **'First time – pick a weight you can do with good form.'**
  String get woReasonFirstTime;

  /// No description provided for @woReasonIncrease.
  ///
  /// In en, this message translates to:
  /// **'You hit the top of the rep range last time – add weight.'**
  String get woReasonIncrease;

  /// No description provided for @woReasonReduce.
  ///
  /// In en, this message translates to:
  /// **'Two tough sessions in a row – drop the weight a bit.'**
  String get woReasonReduce;

  /// No description provided for @woReasonRepeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat last time\'s numbers with solid form.'**
  String get woReasonRepeat;

  /// No description provided for @woRecoveryAdjusted.
  ///
  /// In en, this message translates to:
  /// **'Recovery adjusted'**
  String get woRecoveryAdjusted;

  /// No description provided for @woRecoveryPill.
  ///
  /// In en, this message translates to:
  /// **'Low recovery: −{pct}% weight, −{sets} set'**
  String woRecoveryPill(int pct, int sets);

  /// No description provided for @woRegenerate.
  ///
  /// In en, this message translates to:
  /// **'Rebuild plan with AI'**
  String get woRegenerate;

  /// No description provided for @woRegenerateBody.
  ///
  /// In en, this message translates to:
  /// **'The AI will build a new plan for you to review. Your current plan stays active until you approve the new one.'**
  String get woRegenerateBody;

  /// No description provided for @woRegenerateTitle.
  ///
  /// In en, this message translates to:
  /// **'Rebuild your plan?'**
  String get woRegenerateTitle;

  /// No description provided for @woRemoveExerciseTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove this exercise?'**
  String get woRemoveExerciseTitle;

  /// No description provided for @woRepMax.
  ///
  /// In en, this message translates to:
  /// **'Max reps'**
  String get woRepMax;

  /// No description provided for @woRepMin.
  ///
  /// In en, this message translates to:
  /// **'Min reps'**
  String get woRepMin;

  /// No description provided for @woReps.
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get woReps;

  /// No description provided for @woRest.
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get woRest;

  /// No description provided for @woRestDay.
  ///
  /// In en, this message translates to:
  /// **'Rest day'**
  String get woRestDay;

  /// No description provided for @woRestDayBody.
  ///
  /// In en, this message translates to:
  /// **'Recover today: sleep well, eat your protein, maybe a light walk.'**
  String get woRestDayBody;

  /// No description provided for @woRestDoneBody.
  ///
  /// In en, this message translates to:
  /// **'Rest is over – next set!'**
  String get woRestDoneBody;

  /// No description provided for @woRestDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Rest timer'**
  String get woRestDoneTitle;

  /// No description provided for @woRestSeconds.
  ///
  /// In en, this message translates to:
  /// **'Rest (sec)'**
  String get woRestSeconds;

  /// No description provided for @woRestTimer.
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get woRestTimer;

  /// No description provided for @woResumeWorkout.
  ///
  /// In en, this message translates to:
  /// **'Resume workout'**
  String get woResumeWorkout;

  /// No description provided for @woReviewHint.
  ///
  /// In en, this message translates to:
  /// **'Edit anything you like (tap to edit, drag to reorder), then approve.'**
  String get woReviewHint;

  /// No description provided for @woReviewPlan.
  ///
  /// In en, this message translates to:
  /// **'Review your plan'**
  String get woReviewPlan;

  /// No description provided for @woSaveSet.
  ///
  /// In en, this message translates to:
  /// **'Save set'**
  String get woSaveSet;

  /// No description provided for @woSessionNotFound.
  ///
  /// In en, this message translates to:
  /// **'Workout not found'**
  String get woSessionNotFound;

  /// No description provided for @woSessionNotes.
  ///
  /// In en, this message translates to:
  /// **'Workout notes'**
  String get woSessionNotes;

  /// No description provided for @woSessionNotesHint.
  ///
  /// In en, this message translates to:
  /// **'How did it feel? Anything to remember?'**
  String get woSessionNotesHint;

  /// No description provided for @woSetTypeDrop.
  ///
  /// In en, this message translates to:
  /// **'Drop set'**
  String get woSetTypeDrop;

  /// No description provided for @woSetTypeFailure.
  ///
  /// In en, this message translates to:
  /// **'To failure'**
  String get woSetTypeFailure;

  /// No description provided for @woSetTypeNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get woSetTypeNormal;

  /// No description provided for @woSetTypeWarmup.
  ///
  /// In en, this message translates to:
  /// **'Warm-up'**
  String get woSetTypeWarmup;

  /// No description provided for @woSets.
  ///
  /// In en, this message translates to:
  /// **'Sets'**
  String get woSets;

  /// No description provided for @woSetsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 set} other{{count} sets}}'**
  String woSetsCount(int count);

  /// No description provided for @woSourceAi.
  ///
  /// In en, this message translates to:
  /// **'AI'**
  String get woSourceAi;

  /// No description provided for @woSourceTemplate.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get woSourceTemplate;

  /// No description provided for @woSpeed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get woSpeed;

  /// No description provided for @woStartDeload.
  ///
  /// In en, this message translates to:
  /// **'Start deload week'**
  String get woStartDeload;

  /// No description provided for @woStartEmpty.
  ///
  /// In en, this message translates to:
  /// **'Start an empty workout'**
  String get woStartEmpty;

  /// No description provided for @woStartThisWorkout.
  ///
  /// In en, this message translates to:
  /// **'Do this workout now'**
  String get woStartThisWorkout;

  /// No description provided for @woStartToday.
  ///
  /// In en, this message translates to:
  /// **'Start today\'s workout'**
  String get woStartToday;

  /// No description provided for @woStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get woStatusCompleted;

  /// No description provided for @woStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get woStatusInProgress;

  /// No description provided for @woStatusMissed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get woStatusMissed;

  /// No description provided for @woStatusPartial.
  ///
  /// In en, this message translates to:
  /// **'Partial'**
  String get woStatusPartial;

  /// No description provided for @woSubstitute.
  ///
  /// In en, this message translates to:
  /// **'Substitute'**
  String get woSubstitute;

  /// No description provided for @woSubstituteAi.
  ///
  /// In en, this message translates to:
  /// **'AI suggestions'**
  String get woSubstituteAi;

  /// No description provided for @woSubstituteAlways.
  ///
  /// In en, this message translates to:
  /// **'Always'**
  String get woSubstituteAlways;

  /// No description provided for @woSubstituteLocal.
  ///
  /// In en, this message translates to:
  /// **'Similar exercises'**
  String get woSubstituteLocal;

  /// No description provided for @woSubstituteNone.
  ///
  /// In en, this message translates to:
  /// **'No alternatives found'**
  String get woSubstituteNone;

  /// No description provided for @woSubstituteOnce.
  ///
  /// In en, this message translates to:
  /// **'Just this workout'**
  String get woSubstituteOnce;

  /// No description provided for @woSubstituteTitle.
  ///
  /// In en, this message translates to:
  /// **'Substitute exercise'**
  String get woSubstituteTitle;

  /// No description provided for @woSubstituted.
  ///
  /// In en, this message translates to:
  /// **'Substituted'**
  String get woSubstituted;

  /// No description provided for @woSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Workout summary'**
  String get woSummaryTitle;

  /// No description provided for @woSwap.
  ///
  /// In en, this message translates to:
  /// **'Swap'**
  String get woSwap;

  /// No description provided for @woTargetRpe.
  ///
  /// In en, this message translates to:
  /// **'Target RPE'**
  String get woTargetRpe;

  /// No description provided for @woTemplateBody.
  ///
  /// In en, this message translates to:
  /// **'A new basic plan will be built for you to review. Your current plan stays active until you approve it.'**
  String get woTemplateBody;

  /// No description provided for @woTemplateTitle.
  ///
  /// In en, this message translates to:
  /// **'Build a basic plan?'**
  String get woTemplateTitle;

  /// No description provided for @woTodayTitle.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get woTodayTitle;

  /// No description provided for @woTotalVolume.
  ///
  /// In en, this message translates to:
  /// **'Total volume'**
  String get woTotalVolume;

  /// No description provided for @woTry.
  ///
  /// In en, this message translates to:
  /// **'Try'**
  String get woTry;

  /// No description provided for @woViewSummary.
  ///
  /// In en, this message translates to:
  /// **'View summary'**
  String get woViewSummary;

  /// No description provided for @woVoiceConfirm.
  ///
  /// In en, this message translates to:
  /// **'Save this set?'**
  String get woVoiceConfirm;

  /// No description provided for @woVoiceExample.
  ///
  /// In en, this message translates to:
  /// **'Say e.g. \"80 kilo 10 reps\"'**
  String get woVoiceExample;

  /// No description provided for @woVoiceHint.
  ///
  /// In en, this message translates to:
  /// **'Try saying the weight then the reps, e.g. \"80 kilo 10 reps\".'**
  String get woVoiceHint;

  /// No description provided for @woVoiceNotUnderstood.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t catch that'**
  String get woVoiceNotUnderstood;

  /// No description provided for @woVoiceParsing.
  ///
  /// In en, this message translates to:
  /// **'Understanding…'**
  String get woVoiceParsing;

  /// No description provided for @woVoiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Listening…'**
  String get woVoiceTitle;

  /// No description provided for @woVoiceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Speech recognition isn\'t available on this device.'**
  String get woVoiceUnavailable;

  /// No description provided for @woVolume.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get woVolume;

  /// No description provided for @woVsLastTime.
  ///
  /// In en, this message translates to:
  /// **'Last time: best {best} · volume {volume} kg'**
  String woVsLastTime(String best, String volume);

  /// No description provided for @woWarmup.
  ///
  /// In en, this message translates to:
  /// **'Warm-up'**
  String get woWarmup;

  /// No description provided for @woWeeklyPlan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get woWeeklyPlan;

  /// No description provided for @woWeightKg.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get woWeightKg;

  /// No description provided for @woWorkingSets.
  ///
  /// In en, this message translates to:
  /// **'Working sets'**
  String get woWorkingSets;

  /// No description provided for @woWorkout.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get woWorkout;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
