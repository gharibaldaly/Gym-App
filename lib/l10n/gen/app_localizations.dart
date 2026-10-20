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
  /// **'You can generate it later from the Workout tab.'**
  String get onbBuildWorkoutLater;

  /// No description provided for @onbBuildMealsLater.
  ///
  /// In en, this message translates to:
  /// **'You can generate it later from the Food tab.'**
  String get onbBuildMealsLater;

  /// No description provided for @onbBuildNoKey.
  ///
  /// In en, this message translates to:
  /// **'AI plans need a Claude API key. Your calories and macros are ready; add the key later from Settings and generate the plans from the Workout and Food tabs.'**
  String get onbBuildNoKey;

  /// No description provided for @onbBuildOffline.
  ///
  /// In en, this message translates to:
  /// **'No internet right now. Your calories and macros are ready; generate the AI plans from the Workout and Food tabs when you\'re back online.'**
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
