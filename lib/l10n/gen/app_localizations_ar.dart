// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get coachTabChat => 'الشات';

  @override
  String get coachTabReports => 'التقارير';

  @override
  String get coachTabSuggestions => 'الاقتراحات';

  @override
  String get coachMemoryTitle => 'ذاكرة المدرب';

  @override
  String get coachMemoryHint =>
      'ملاحظات الكابتن حفظها من الشات، وبتتبعت مع كل رسالة عشان يفتكرك.';

  @override
  String get coachMemoryEmpty => 'الكابتن لسه مسجلش أي ملاحظات عنك.';

  @override
  String get coachMemoryClearAll => 'امسح الكل';

  @override
  String get coachMemoryClearConfirm => 'تمسح كل اللي الكابتن فاكره عنك؟';

  @override
  String get coachMemoryDeleted => 'اتمسحت';

  @override
  String get coachInputHint => 'اكتب للكابتن…';

  @override
  String get coachInputNoKey => 'ضيف مفتاح الـ API عشان تتكلم مع الكابتن';

  @override
  String get coachSend => 'ابعت';

  @override
  String get coachVoice => 'إدخال بالصوت';

  @override
  String get coachListening => 'بسمعك…';

  @override
  String get coachVoiceUnavailable => 'الإدخال بالصوت مش متاح على الموبايل ده';

  @override
  String get coachOfflineNotice =>
      'مفيش نت. رسالتك اتحفظت — دوس \"ابعت تاني\" لما النت يرجع.';

  @override
  String get coachResend => 'ابعت تاني';

  @override
  String get coachThinking => 'الكابتن بيكتب…';

  @override
  String get coachEmptyChat =>
      'اسأل الكابتن عن أي حاجة: الخطة، الأكل، ألم — أو قوله أكلت إيه وهو يسجله.';

  @override
  String get coachRefused => 'الكابتن مقدرش يرد على ده. جرب تكتبها بشكل تاني.';

  @override
  String get coachProposalWaiting => 'عملتلك اقتراح — شوف الكارت اللي تحت.';

  @override
  String get coachKindMorning => 'رسالة الصبح';

  @override
  String get coachKindWorkoutSummary => 'ملخص التمرينة';

  @override
  String get coachKindPlateau => 'ثبات في الأداء';

  @override
  String get coachKindWeekly => 'التقرير الأسبوعي';

  @override
  String get coachKindRecovery => 'الاستشفاء';

  @override
  String get coachAccepted => 'اتوافق عليه';

  @override
  String get coachRejected => 'اترفض';

  @override
  String get coachPending => 'مستني ردك';

  @override
  String get coachAppliedSnack => 'تمام — التعديل اتنفذ.';

  @override
  String get coachRejectedSnack => 'الاقتراح اترفض.';

  @override
  String coachApplyFailed(String error) {
    return 'مقدرتش أنفذ: $error';
  }

  @override
  String get coachNoPending => 'مفيش اقتراحات مستنياك.';

  @override
  String get coachHistory => 'اللي فات';

  @override
  String get coachReportsEmpty =>
      'لسه مفيش تقارير. التقرير الأسبوعي بيوصل كل جمعة بالليل، وملخص التمرينة بعد كل تمرينة.';

  @override
  String get coachGenerateWeekly => 'اعمل التقرير الأسبوعي دلوقتي';

  @override
  String get coachGenerating => 'بيتعمل…';

  @override
  String get coachWeeklyDone => 'التقرير الأسبوعي جاهز';

  @override
  String get coachShowMore => 'اعرض أكتر';

  @override
  String get coachShowLess => 'اعرض أقل';

  @override
  String get coachCopy => 'انسخ';

  @override
  String get coachCopied => 'اتنسخ';

  @override
  String coachPropPlanChangeTitle(String day) {
    return 'تعديل في الخطة: $day';
  }

  @override
  String coachPropSwapTitle(String from, String to) {
    return 'بدّل $from بـ $to';
  }

  @override
  String get coachSwapScopeToday => 'تمرينة النهارده بس';

  @override
  String get coachSwapScopeAlways => 'على طول في الخطة';

  @override
  String coachPropLogMealTitle(String name, int kcal) {
    return 'سجّل وجبة: $name ($kcal سعرة)';
  }

  @override
  String coachPropLogSetTitle(String exercise, String weight, int reps) {
    return 'سجّل ست: $exercise $weight كجم × $reps';
  }

  @override
  String coachPropMacrosTitle(int kcal) {
    return 'هدف يومي جديد: $kcal سعرة';
  }

  @override
  String coachMacroLine(int protein, int carbs, int fat) {
    return 'بروتين $protein جم · كارب $carbs جم · دهون $fat جم';
  }

  @override
  String coachChangeAdd(String exercise, String detail) {
    return 'إضافة: $exercise $detail';
  }

  @override
  String coachChangeRemove(String exercise) {
    return 'شيل: $exercise';
  }

  @override
  String coachChangeModify(String exercise, String detail) {
    return 'تعديل: $exercise ← $detail';
  }

  @override
  String coachRestSeconds(int seconds) {
    return 'راحة $seconds ث';
  }

  @override
  String coachPropRecoveryTitle(int score) {
    return 'خفف تمرينة النهارده (الاستشفاء $score)';
  }

  @override
  String get coachPropRecoveryDesc =>
      'أوزان أقل ١٠٪ وست أقل في كل تمرين، النهارده بس.';

  @override
  String coachRecoveryMessage(int score) {
    return 'درجة الاستشفاء النهارده **$score/100** — واطية. اقترحت أخفف التمرينة: أوزان أقل ١٠٪ وست أقل في كل تمرين. لو موافق دوس موافق في الكارت.';
  }

  @override
  String get coachNotifMorning => 'صباح الخير — الكابتن';

  @override
  String get coachNotifWorkout => 'ملخص التمرينة جاهز';

  @override
  String coachNotifPlateau(String exercise) {
    return 'ثبات في: $exercise';
  }

  @override
  String get coachNotifWeekly => 'تقريرك الأسبوعي جاهز';

  @override
  String get coachNotifRecovery => 'الاستشفاء واطي النهارده';

  @override
  String get appName => 'IronMind';

  @override
  String get tabToday => 'اليوم';

  @override
  String get tabWorkout => 'التمرين';

  @override
  String get tabFood => 'الأكل';

  @override
  String get tabCoach => 'المدرب';

  @override
  String get tabProgress => 'التقدم';

  @override
  String get settings => 'الإعدادات';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get ok => 'تمام';

  @override
  String get delete => 'مسح';

  @override
  String get edit => 'تعديل';

  @override
  String get add => 'إضافة';

  @override
  String get back => 'رجوع';

  @override
  String get next => 'التالي';

  @override
  String get done => 'خلصت';

  @override
  String get retry => 'حاول تاني';

  @override
  String get close => 'قفل';

  @override
  String get confirm => 'تأكيد';

  @override
  String get accept => 'موافق';

  @override
  String get reject => 'رفض';

  @override
  String get search => 'بحث';

  @override
  String get all => 'الكل';

  @override
  String get today => 'النهاردة';

  @override
  String get yesterday => 'امبارح';

  @override
  String get loading => 'بيحمّل…';

  @override
  String get errorGeneric => 'حصلت مشكلة';

  @override
  String get noInternet => 'مفيش نت';

  @override
  String get noApiKeyTitle => 'الـ AI مقفول';

  @override
  String get noApiKeyBody =>
      'ضيف مفتاح Claude API من الإعدادات عشان تشغّل ميزات الـ AI. باقي الأبلكيشن شغال من غيره.';

  @override
  String get addApiKey => 'ضيف المفتاح';

  @override
  String get aiQueuedOffline => 'اتحفظ. الـ AI هيكمّل أول ما النت يرجع.';

  @override
  String get kg => 'كجم';

  @override
  String get cm => 'سم';

  @override
  String get kcal => 'سعرة';

  @override
  String get gramsShort => 'جم';

  @override
  String get mlShort => 'مل';

  @override
  String get minutesShort => 'د';

  @override
  String get hoursShort => 'س';

  @override
  String get yes => 'أيوه';

  @override
  String get no => 'لأ';

  @override
  String get skip => 'تخطي';

  @override
  String get optional => 'اختياري';

  @override
  String get notes => 'ملاحظات';

  @override
  String get empty => 'مفيش حاجة لسه';

  @override
  String get protein => 'بروتين';

  @override
  String get carbs => 'كارب';

  @override
  String get fat => 'دهون';

  @override
  String get calories => 'سعرات';

  @override
  String get water => 'ميه';

  @override
  String get language => 'اللغة';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'English';

  @override
  String get weekdayMon => 'الاتنين';

  @override
  String get weekdayTue => 'التلات';

  @override
  String get weekdayWed => 'الأربع';

  @override
  String get weekdayThu => 'الخميس';

  @override
  String get weekdayFri => 'الجمعة';

  @override
  String get weekdaySat => 'السبت';

  @override
  String get weekdaySun => 'الحد';

  @override
  String get comingSoon => 'قريبًا';

  @override
  String get exLibraryTitle => 'مكتبة التمارين';

  @override
  String get exPickTitle => 'اختار تمرين';

  @override
  String get exSearchHint => 'دوّر بالعربي أو بالإنجليزي';

  @override
  String get exAllMuscles => 'كل العضلات';

  @override
  String get exAllEquipment => 'كل الأدوات';

  @override
  String get exMuscleFilter => 'العضلة';

  @override
  String get exEquipmentFilter => 'الأداة';

  @override
  String get exFavoritesOnly => 'المفضلة';

  @override
  String get exMyCustom => 'تماريني';

  @override
  String get exClearFilters => 'امسح الفلاتر';

  @override
  String exResultsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تمرين',
      few: '$count تمارين',
      two: 'تمرينين',
      one: 'تمرين واحد',
    );
    return '$_temp0';
  }

  @override
  String get exNoResults => 'مفيش تمارين بالبحث ده.';

  @override
  String get exAddWithAi => 'ضيف بالـ AI';

  @override
  String get exFavoriteAdd => 'ضيف للمفضلة';

  @override
  String get exFavoriteRemove => 'شيل من المفضلة';

  @override
  String get exCustomBadge => 'بتاعك';

  @override
  String get exBodyFront => 'قدام';

  @override
  String get exBodyBack => 'ورا';

  @override
  String get exPrimaryMuscles => 'العضلات الأساسية';

  @override
  String get exSecondaryMuscles => 'العضلات الثانوية';

  @override
  String get exMusclesWorked => 'العضلات اللي بتشتغل';

  @override
  String get exHowTo => 'إزاي تعمله';

  @override
  String get exCommonMistakes => 'أخطاء شائعة';

  @override
  String get exNoInstructions => 'مفيش شرح لسه.';

  @override
  String get exImageOffline =>
      'الصورة لسه متحملتش. افتحها مرة والنت شغال عشان تفضل متخزنة.';

  @override
  String exStepOf(int current, int total) {
    return '$current/$total';
  }

  @override
  String get exYourHistory => 'سجلك في التمرين ده';

  @override
  String get exNoHistory => 'لسه ما سجلتش التمرين ده.';

  @override
  String get exLastPerformance => 'آخر مرة';

  @override
  String get exPersonalRecords => 'أرقامك القياسية';

  @override
  String get exHeaviest => 'أتقل وزن';

  @override
  String get exBestE1rm => 'أعلى 1RM متوقع';

  @override
  String get exRepRecords => 'أكتر عدات على كل وزن';

  @override
  String exSetLine(String weight, int reps) {
    return '$weight كجم × $reps';
  }

  @override
  String exKgValue(String value) {
    return '$value كجم';
  }

  @override
  String exSessionVolume(String volume) {
    return 'الحجم: $volume كجم';
  }

  @override
  String get exProgressChart => 'التطور';

  @override
  String get exChartE1rm => '1RM متوقع';

  @override
  String get exChartTopWeight => 'أتقل وزن';

  @override
  String get exChartNeedMore =>
      'سجّل التمرين ده في جلستين على الأقل عشان يظهرلك رسم التطور.';

  @override
  String get exEdit => 'عدّل';

  @override
  String get exDelete => 'امسح التمرين';

  @override
  String get exDeleteConfirm => 'تمسح التمرين ده؟';

  @override
  String get exDeleteInUse =>
      'مينفعش يتمسح: التمرين ده موجود في سجلك أو في خطتك.';

  @override
  String get exDeleted => 'التمرين اتمسح';

  @override
  String get exNotFound => 'التمرين مش موجود';

  @override
  String get exAddTitle => 'ضيف تمرين';

  @override
  String get exEditTitle => 'عدّل التمرين';

  @override
  String get exReviewTitle => 'راجع وعدّل';

  @override
  String get exDescribeTitle => 'اوصف التمرين';

  @override
  String get exDescribeHint =>
      'بكلامك، مثلاً \"ماكينة بقعد عليها وبزق دراعين لقدام للصدر\"';

  @override
  String get exVoiceStart => 'اتكلم';

  @override
  String get exVoiceListening => 'بسمعك…';

  @override
  String get exVoiceUnavailable => 'الإدخال بالصوت مش متاح على الموبايل ده.';

  @override
  String get exPhotoOptional => 'صورة للجهاز (اختياري)';

  @override
  String get exPhotoCamera => 'كاميرا';

  @override
  String get exPhotoGallery => 'المعرض';

  @override
  String get exPhotoRemove => 'شيل الصورة';

  @override
  String get exPhotoError => 'معرفتش أفتح الصورة.';

  @override
  String get exContinue => 'كمّل';

  @override
  String get exCreateWithAi => 'اعمله بالـ AI';

  @override
  String get exFillManually => 'اكتبه بنفسك';

  @override
  String get exAiOffManual => 'الـ AI مقفول دلوقتي — تقدر تضيف التمرين بنفسك.';

  @override
  String get exDescribeFirst => 'اوصف التمرين أو ضيف صورة الأول.';

  @override
  String get exDidYouMean => 'قصدك…؟';

  @override
  String get exDidYouMeanBody =>
      'التمارين دي موجودة في المكتبة. استخدم واحد منهم بدل ما تكرر.';

  @override
  String get exUseExisting => 'استخدمه';

  @override
  String get exCreateNewAnyway => 'لأ، اعمل تمرين جديد';

  @override
  String get exAiWorking => 'Claude بيجهزلك التمرين…';

  @override
  String get exAiSimilarFound => 'شكله تمرين موجود عندك أصلاً:';

  @override
  String get exNameEn => 'الاسم بالإنجليزي';

  @override
  String get exNameAr => 'الاسم بالعربي';

  @override
  String get exFieldEquipment => 'الأداة';

  @override
  String get exFieldForce => 'اتجاه القوة';

  @override
  String get exFieldMechanic => 'مركب ولا عزل';

  @override
  String get exFieldCategory => 'التصنيف';

  @override
  String get exNone => '—';

  @override
  String get exStepsEn => 'الخطوات (إنجليزي)';

  @override
  String get exStepsAr => 'الخطوات (عربي)';

  @override
  String get exMistakesEn => 'الأخطاء الشائعة (إنجليزي)';

  @override
  String get exMistakesAr => 'الأخطاء الشائعة (عربي)';

  @override
  String get exOnePerLine => 'كل واحدة في سطر';

  @override
  String get exNeedNameAndMuscle =>
      'اكتب اسم واختار عضلة أساسية واحدة على الأقل.';

  @override
  String get exSave => 'احفظ التمرين';

  @override
  String get exSaved => 'التمرين اتحفظ';

  @override
  String get exOfflineTitle => 'صور التمارين أوفلاين';

  @override
  String exOfflineBody(int mb) {
    return 'نزّل صور خطوات كل التمارين عشان تظهر من غير نت (حوالي $mb ميجا). الصور اللي بتفتحها بتتخزن لوحدها كمان.';
  }

  @override
  String get exOfflineWifiTip => 'نصيحة: استخدم واي فاي — الحجم كبير.';

  @override
  String get exOfflineStart => 'نزّل الكل';

  @override
  String get exOfflineCancel => 'وقّف';

  @override
  String get exOfflineClear => 'امسح الصور المتنزلة';

  @override
  String get exOfflineClearConfirm =>
      'صور التمارين هتحتاج نت تاني لحد ما تنزلها من جديد.';

  @override
  String get exOfflineCleared => 'الصور المتنزلة اتمسحت';

  @override
  String exOfflineProgress(int done, int total) {
    return '$done / $total';
  }

  @override
  String exOfflineCached(int cached, int total) {
    return '$cached من $total صورة متخزنة';
  }

  @override
  String exOfflineFailed(int count) {
    return '$count فشلوا — جرب تاني بعدين';
  }

  @override
  String get exOfflineDone => 'كل صور التمارين متاحة أوفلاين';

  @override
  String get exOfflineChecking => 'بشوف الصور المتخزنة…';

  @override
  String get exOfflineNeedsInternet => 'افتح النت عشان تنزّل.';

  @override
  String get nutTitle => 'الأكل';

  @override
  String get nutTabToday => 'النهاردة';

  @override
  String get nutTabPlan => 'خطة الأكل';

  @override
  String get nutTabShopping => 'المشتريات';

  @override
  String get nutTodayTitle => 'سعرات النهاردة';

  @override
  String get nutTrainingDay => 'يوم تمرين';

  @override
  String get nutRestDay => 'يوم راحة';

  @override
  String get nutNoTargets =>
      'لسه مفيش أهداف سعرات. كمّل البروفايل عشان أرقامك اليومية تظهر.';

  @override
  String get nutKcalLeft => 'سعرة فاضلة';

  @override
  String get nutKcalOver => 'سعرة زيادة';

  @override
  String nutRemainingMacros(String protein, String carbs, String fat) {
    return 'فاضل: بروتين $protein ج · كارب $carbs ج · دهون $fat ج';
  }

  @override
  String nutFromSupplements(String protein, String kcal) {
    return 'منهم مكملات: $protein ج بروتين · $kcal سعرة';
  }

  @override
  String nutMacroLine(String kcal, String protein, String carbs, String fat) {
    return '$kcal سعرة · ب $protein · ك $carbs · د $fat';
  }

  @override
  String get nutProteinShort => 'ب';

  @override
  String get nutCarbsShort => 'ك';

  @override
  String get nutFatShort => 'د';

  @override
  String nutPendingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count وجبات مستنية تحليل الـ AI',
      two: 'وجبتين مستنيين تحليل الـ AI',
      one: 'وجبة مستنية تحليل الـ AI',
    );
    return '$_temp0';
  }

  @override
  String get nutPendingNoKey => 'ضيف مفتاح Claude API وهيتحللوا لوحدهم.';

  @override
  String get nutPendingOffline => 'هيتحللوا أول ما النت يرجع.';

  @override
  String get nutPendingWorking => 'بنحللهم في الخلفية…';

  @override
  String get nutMealsTitle => 'الوجبات: المخطط واللي اتاكل';

  @override
  String get nutNoPlanToday =>
      'لسه معندكش خطة أكل. اعمل واحدة عشان وجباتك تظهر هنا.';

  @override
  String get nutOpenPlan => 'افتح خطة الأكل';

  @override
  String nutPlannedLine(String macros) {
    return 'المخطط: $macros';
  }

  @override
  String nutEatenLine(String macros) {
    return 'اتاكل: $macros';
  }

  @override
  String get nutAteAsPlanned => 'كلتها زي الخطة';

  @override
  String get nutAteHalf => 'كلت نصها';

  @override
  String get nutAteDifferent => 'كلت حاجة تانية';

  @override
  String nutLoggedMeal(String name) {
    return 'اتسجل: $name';
  }

  @override
  String get nutUndo => 'تراجع';

  @override
  String get nutLoggedTitle => 'اللي اتسجل النهاردة';

  @override
  String get nutNothingLogged => 'لسه مسجلتش حاجة. دوس + وسجل وجبة.';

  @override
  String get nutWaitingForAi => 'مستني تحليل الـ AI';

  @override
  String nutConfidence(int percent) {
    return 'ثقة الـ AI $percent%';
  }

  @override
  String get nutSavedToMyFoods => 'اتحفظت في أكلاتي';

  @override
  String get nutAnalyzeNow => 'حللها دلوقتي';

  @override
  String get nutDeleted => 'الوجبة اتمسحت';

  @override
  String get nutSaved => 'اتحفظ';

  @override
  String get nutSupplementsTitle => 'مكملات النهاردة';

  @override
  String get nutNoSupplementsToday =>
      'مفيش مكملات متعلّم عليها النهاردة. علّم عليها من تاب اليوم وبروتينها وسعراتها هتتحسب هنا.';

  @override
  String nutSupplementMacros(String protein, String kcal) {
    return '$protein ج بروتين · $kcal سعرة';
  }

  @override
  String get nutNoMacros => 'من غير سعرات';

  @override
  String get nutLogFood => 'سجّل أكل';

  @override
  String get nutLogPhoto => 'صورة';

  @override
  String get nutLogPhotoHint => 'صوّر طبقك والـ AI يقدّره';

  @override
  String get nutLogText => 'اكتب أو قول';

  @override
  String get nutLogTextHint => 'مثلاً \"طبق كشري وسط وبيضتين\"';

  @override
  String get nutMyFoods => 'أكلاتي';

  @override
  String get nutMyFoodsHint => 'ضغطة واحدة، من غير AI، وشغالة أوفلاين';

  @override
  String get nutLogManual => 'يدوي';

  @override
  String get nutLogManualHint => 'اختار من الأكلات المصرية + الجرامات';

  @override
  String get nutLogged => 'الوجبة اتسجلت';

  @override
  String get nutTakePhoto => 'صوّر دلوقتي';

  @override
  String get nutFromGallery => 'اختار من الجاليري';

  @override
  String get nutPhotoError => 'مقدرناش نفتح الكاميرا أو الجاليري.';

  @override
  String get nutPhotoMealName => 'صورة وجبة';

  @override
  String get nutQueuedNoKey =>
      'اتحفظت بالصورة. ضيف مفتاح الـ API من الإعدادات وهتتحلل.';

  @override
  String get nutAnalyzingPhoto => 'بنحلل طبقك…';

  @override
  String get nutAnalysisFailed => 'التحليل منفعش';

  @override
  String get nutLogManually => 'سجّل يدوي';

  @override
  String get nutAnalyzeLater => 'احفظ وحلل بعدين';

  @override
  String get nutReviewTitle => 'راجع الوجبة';

  @override
  String get nutEditMeal => 'عدّل الوجبة';

  @override
  String get nutReviewHint =>
      'راجع الكميات — لما تغير الجرامات الماكروز بتتعدل لوحدها.';

  @override
  String get nutMealName => 'اسم الوجبة';

  @override
  String get nutWhichMeal => 'أنهي وجبة؟';

  @override
  String get nutOtherMeal => 'سناك / برا الخطة';

  @override
  String nutMealNumber(int number) {
    return 'وجبة $number';
  }

  @override
  String get nutItems => 'المكونات';

  @override
  String get nutAddFood => 'ضيف أكلة';

  @override
  String get nutNoItemsDetected => 'الـ AI ملقاش أكل. ضيف المكونات بنفسك.';

  @override
  String get nutNoItemsYet => 'لسه مفيش مكونات. ضيف أكلة من القايمة.';

  @override
  String get nutItemName => 'اسم الأكلة';

  @override
  String get nutGrams => 'الجرامات';

  @override
  String get nutTotal => 'الإجمالي';

  @override
  String get nutSaveToMyFoods => 'احفظها في أكلاتي';

  @override
  String get nutSaveToMyFoodsHint => 'تسجلها تاني بضغطة من غير AI';

  @override
  String get nutSaveMeal => 'احفظ الوجبة';

  @override
  String get nutAddAtLeastOne => 'ضيف أكلة واحدة على الأقل.';

  @override
  String get nutSearchFoods => 'دور على أكلة (فول، رز…)';

  @override
  String get nutNoFoodsFound => 'مفيش نتايج';

  @override
  String nutPer100g(String macros) {
    return 'لكل 100 ج: $macros';
  }

  @override
  String get nutTextPrompt => 'كلت إيه؟';

  @override
  String get nutTextHintExample => 'طبق كشري وسط وبيضتين';

  @override
  String get nutSpeak => 'اتكلم';

  @override
  String get nutStopListening => 'وقف';

  @override
  String get nutListening => 'بسمعك…';

  @override
  String get nutTapToSpeak => 'دوس على المايك وقول كلت إيه';

  @override
  String get nutSpeechUnavailable => 'الإدخال بالصوت مش متاح على الموبايل ده.';

  @override
  String get nutAnalyze => 'حلل بالـ AI';

  @override
  String get nutAnalyzing => 'بنحلل…';

  @override
  String get nutMyFoodsEmpty =>
      'الوجبات اللي بتسجلها بتتحفظ هنا عشان تسجلها تاني بضغطة.';

  @override
  String get nutMyFoodsTapHint =>
      'دوسة للتسجيل · ضغطة طويلة للكمية والاختيارات';

  @override
  String nutUsedTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'اتسجلت $count مرات',
      two: 'اتسجلت مرتين',
      one: 'اتسجلت مرة',
    );
    return '$_temp0';
  }

  @override
  String get nutMore => 'أكتر';

  @override
  String get nutHalfPortion => 'نص الكمية';

  @override
  String get nutFullPortion => 'الكمية كاملة';

  @override
  String get nutOneAndHalfPortion => 'كمية ونص';

  @override
  String get nutDoublePortion => 'الكمية مرتين';

  @override
  String get nutFavorite => 'ضيف للمفضلة';

  @override
  String get nutUnfavorite => 'شيل من المفضلة';

  @override
  String get nutNoPlan =>
      'لسه مفيش خطة أكل. الـ AI يعملك خطة بأكل مصري على قد ماكروزك وميزانيتك وذوقك.';

  @override
  String get nutGeneratePlan => 'ابني خطة أكلي';

  @override
  String get nutUseBasicPlan => 'استخدم خطة أساسية أوفلاين';

  @override
  String get nutGeneratingPlan => 'بنبني خطة أكلك… ممكن تاخد دقيقة.';

  @override
  String get nutBuildingPlan => 'بنعمل خطة أساسية…';

  @override
  String get nutPlanReady => 'خطة الأكل الجديدة جاهزة';

  @override
  String get nutBasicPlanReady => 'الخطة الأساسية جاهزة';

  @override
  String get nutPlanFallback =>
      'الـ AI مش متاح دلوقتي، فعملنالك خطة أساسية من أكلات مصرية.';

  @override
  String get nutPlanFailed => 'معرفناش نبني الخطة';

  @override
  String get nutTemplatePlanNote =>
      'خطة أساسية معمولة أوفلاين من جدول الأكلات. اعمل خطة جديدة بالـ AI عشان تبقى مظبوطة عليك.';

  @override
  String get nutDayTotal => 'إجمالي اليوم';

  @override
  String nutTargetLine(String macros) {
    return 'الهدف: $macros';
  }

  @override
  String get nutNoMealsForDay => 'مفيش وجبات لنوع اليوم ده في الخطة.';

  @override
  String nutItemMacros(String kcal, String protein, String carbs, String fat) {
    return '$kcal سعرة · ب $protein · ك $carbs · د $fat';
  }

  @override
  String get nutSwapMeal => 'بدّل الوجبة';

  @override
  String nutSwapTitle(String meal) {
    return 'بدّل $meal';
  }

  @override
  String nutSwapSubtitle(String macros) {
    return 'بدايل بنفس الماكروز تقريبًا: $macros';
  }

  @override
  String get nutFindingAlternatives => 'بندور على بدايل…';

  @override
  String get nutNoAlternatives => 'ملقيناش بدايل. جرب تاني.';

  @override
  String get nutUseThis => 'استخدم الوجبة دي';

  @override
  String get nutMoreAlternatives => 'بدايل تانية';

  @override
  String get nutMealSwapped => 'الوجبة اتبدلت في الخطة';

  @override
  String get nutRegenerate => 'اعمل خطة جديدة';

  @override
  String get nutRegenerateTitle => 'نعمل خطة أكل جديدة؟';

  @override
  String get nutRegenerateBody =>
      'الخطة الحالية (وأي تبديلات) هتتشال. الوجبات اللي سجلتها هتفضل زي ما هي.';

  @override
  String get nutShoppingNoPlan =>
      'اعمل خطة أكل الأول وقايمة مشترياتك الأسبوعية هتظهر هنا.';

  @override
  String get nutShoppingTitle => 'قايمة مشتريات الأسبوع';

  @override
  String nutShoppingSubtitle(int training, int rest) {
    return 'لـ $training أيام تمرين و$rest أيام راحة';
  }

  @override
  String nutShoppingShareTitle(String date) {
    return 'قايمة المشتريات – أسبوع $date';
  }

  @override
  String get nutShare => 'شارك';

  @override
  String get nutUncheckAll => 'شيل كل العلامات';

  @override
  String get nutLiter => 'لتر';

  @override
  String get nutCatProtein => 'لحوم وفراخ وبيض';

  @override
  String get nutCatCarb => 'عيش ونشويات وبقوليات';

  @override
  String get nutCatDairy => 'ألبان';

  @override
  String get nutCatFat => 'زيوت ومكسرات';

  @override
  String get nutCatFruit => 'فاكهة';

  @override
  String get nutCatVeg => 'خضار';

  @override
  String get nutCatDish => 'أكلات جاهزة';

  @override
  String get nutCatSupplement => 'مكملات';

  @override
  String get nutCatOther => 'حاجات تانية';

  @override
  String onbStepOf(String current, String total) {
    return 'خطوة $current من $total';
  }

  @override
  String get onbNext => 'التالي';

  @override
  String get onbBack => 'رجوع';

  @override
  String get onbSkip => 'تخطي';

  @override
  String get onbBackToSummary => 'ارجع للملخص';

  @override
  String get onbBuildPlan => 'ابني خطتي';

  @override
  String get onbNotSet => 'مش محدد';

  @override
  String get onbNone => 'ولا حاجة';

  @override
  String get onbOptional => 'اختياري';

  @override
  String onbErrRange(String min, String max) {
    return 'دخّل رقم بين $min و $max';
  }

  @override
  String get onbSectionBasics => 'عنك';

  @override
  String get onbSectionGoals => 'الهدف والمستوى';

  @override
  String get onbSectionTraining => 'التمرين';

  @override
  String get onbSectionLifestyle => 'الصحة ونمط الحياة';

  @override
  String get onbSectionNutrition => 'الأكل';

  @override
  String get onbSectionConnections => 'الربط';

  @override
  String get onbLangTitle => 'اختار اللغة';

  @override
  String get onbLangSubtitle => 'تقدر تغيرها في أي وقت من الإعدادات.';

  @override
  String get onbBodyTitle => 'عرّفنا بنفسك';

  @override
  String get onbBodySubtitle =>
      'هنستخدم الأرقام دي عشان نحسب سعراتك والماكروز.';

  @override
  String get onbSexMale => 'ذكر';

  @override
  String get onbSexFemale => 'أنثى';

  @override
  String get onbAge => 'السن';

  @override
  String get onbYears => 'سنة';

  @override
  String get onbHeight => 'الطول';

  @override
  String get onbWeight => 'وزنك دلوقتي';

  @override
  String get onbBodyFatTitle => 'نسبة الدهون';

  @override
  String get onbBodyFatSubtitle => 'تقدير تقريبي كفاية خالص.';

  @override
  String get onbBfNumber => 'عارف الرقم';

  @override
  String get onbBfNumberSub => 'من InBody أو كاليبر';

  @override
  String get onbBfShape => 'اختار شكل جسمي';

  @override
  String get onbBfShapeSub => 'هنقدّرها من شكل جسمك';

  @override
  String get onbBfUnknown => 'مش عارف';

  @override
  String get onbBfUnknownSub => 'مفيش مشكلة، هنحسب بالوزن والطول';

  @override
  String get onbBodyFatPct => 'نسبة الدهون';

  @override
  String get onbShapeLean => 'نشفان جدًا';

  @override
  String get onbShapeLeanSub => 'البطن باينة والعروق ظاهرة';

  @override
  String get onbShapeAthletic => 'رياضي';

  @override
  String get onbShapeAthleticSub => 'شكل البطن باين شوية';

  @override
  String get onbShapeAverage => 'متوسط';

  @override
  String get onbShapeAverageSub => 'البطن مفرودة تقريبًا من غير عضلات باينة';

  @override
  String get onbShapeSoft => 'عندي كرش خفيف';

  @override
  String get onbShapeSoftSub => 'الوسط طري شوية';

  @override
  String get onbShapeHeavy => 'وزن زيادة';

  @override
  String get onbShapeHeavySub => 'الكرش واضح';

  @override
  String onbShapeEstimate(String pct) {
    return '≈ $pct% دهون';
  }

  @override
  String get onbMeasTitle => 'مقاسات الجسم';

  @override
  String get onbMeasSubtitle =>
      'اختياري – بتساعدنا نتابع التقدم بعيد عن الميزان.';

  @override
  String get onbMeasHint =>
      'استخدم شريط قياس: الوسط عند السرة، الدراع وهو مشدود عند أعرض نقطة، والفخذ من النص.';

  @override
  String get onbMeasWaist => 'الوسط';

  @override
  String get onbMeasChest => 'الصدر';

  @override
  String get onbMeasArm => 'الدراع';

  @override
  String get onbMeasThigh => 'الفخذ';

  @override
  String get onbMeasNeck => 'الرقبة';

  @override
  String get onbMeasHips => 'الأرداف';

  @override
  String get onbGoalTitle => 'إيه هدفك الأساسي؟';

  @override
  String get onbGoalSubtitle => 'اختار واحد – الخطة كلها هتتبني عليه.';

  @override
  String get onbGoalBulk => 'تضخيم';

  @override
  String get onbGoalBulkSub => 'تزوّد عضل وحجم';

  @override
  String get onbGoalCut => 'تنشيف';

  @override
  String get onbGoalCutSub => 'تخس دهون وتحافظ على العضل';

  @override
  String get onbGoalRecomp => 'ريكومب';

  @override
  String get onbGoalRecompSub => 'تخس دهون وتبني عضل في نفس الوقت';

  @override
  String get onbGoalStrength => 'قوة';

  @override
  String get onbGoalStrengthSub => 'تشيل أتقل في التمارين الأساسية';

  @override
  String get onbGoalFitness => 'لياقة عامة';

  @override
  String get onbGoalFitnessSub => 'تبقى أصح وأنشط';

  @override
  String get onbTargetWeight => 'الوزن المستهدف (اختياري)';

  @override
  String get onbGoalWeeks => 'في كام أسبوع؟ (اختياري)';

  @override
  String get onbWeeks => 'أسبوع';

  @override
  String onbGoalWeeksSuggest(String weeks) {
    return 'المعدل الواقعي حوالي $weeks أسبوع';
  }

  @override
  String get onbWarnCutTarget =>
      'في التنشيف الوزن المستهدف عادةً بيبقى أقل من وزنك الحالي.';

  @override
  String get onbWarnBulkTarget =>
      'في التضخيم الوزن المستهدف عادةً بيبقى أعلى من وزنك الحالي.';

  @override
  String get onbLevelTitle => 'مستواك في التمرين';

  @override
  String get onbLevelSubtitle => 'خليك صريح – ده بيحدد الحجم ونوع التمارين.';

  @override
  String get onbLevelBeginner => 'مبتدئ';

  @override
  String get onbLevelBeginnerSub => 'جديد أو لسه بتتعلم الحركات';

  @override
  String get onbLevelIntermediate => 'متوسط';

  @override
  String get onbLevelIntermediateSub => 'منتظم وتكنيكك كويس';

  @override
  String get onbLevelAdvanced => 'متقدم';

  @override
  String get onbLevelAdvancedSub => 'سنين تمرين جدّي ومنظم';

  @override
  String get onbExperienceTitle => 'بقالك قد إيه بتتمرن؟';

  @override
  String get onbExpNone => 'لسه هبدأ';

  @override
  String get onbExpLt6m => 'أقل من 6 شهور';

  @override
  String get onbExp6to12m => 'من 6 لـ 12 شهر';

  @override
  String get onbExp1to3y => 'من سنة لـ 3 سنين';

  @override
  String get onbExp3yPlus => 'أكتر من 3 سنين';

  @override
  String get onbDaysTitle => 'كام يوم تمرين في الأسبوع؟';

  @override
  String get onbDaysSubtitle => 'وبعدين اختار الأيام نفسها.';

  @override
  String get onbPickDays => 'أنهي أيام؟';

  @override
  String onbDaysPicked(String picked, String total) {
    return 'اخترت $picked من $total أيام';
  }

  @override
  String get onbSessionTitle => 'التمرينة الواحدة تاخد قد إيه؟';

  @override
  String get onbSessionSubtitle => 'شامل الإحماء والإطالة.';

  @override
  String onbMinutesValue(String n) {
    return '$n دقيقة';
  }

  @override
  String get onbSession30 => 'سريعة ومركزة';

  @override
  String get onbSession60 => 'التمرينة الكلاسيكية';

  @override
  String get onbSession90 => 'تمرينة طويلة وحجم أكبر';

  @override
  String get onbSplitTitle => 'أسلوب التمرين المفضل';

  @override
  String get onbSplitSubtitle => 'تحب الأسبوع يتقسم إزاي؟';

  @override
  String get onbSplitMuscleGroup => 'مجموعة عضلات في اليوم';

  @override
  String get onbSplitMuscleGroupSub => 'زي صدر + تراي، ضهر + باي';

  @override
  String get onbSplitBro => 'Bro Split';

  @override
  String get onbSplitBroSub => 'عضلة واحدة في اليوم';

  @override
  String get onbSplitFullBody => 'Full Body';

  @override
  String get onbSplitFullBodySub => 'الجسم كله في كل تمرينة';

  @override
  String get onbSplitPpl => 'Push / Pull / Legs';

  @override
  String get onbSplitPplSub => 'يوم دفع ويوم سحب ويوم رجل';

  @override
  String get onbSplitUpperLower => 'Upper / Lower';

  @override
  String get onbSplitUpperLowerSub => 'يوم جزء علوي ويوم جزء سفلي';

  @override
  String get onbSplitAi => 'سيب الـ AI يختار';

  @override
  String get onbSplitAiSub => 'أنسب تقسيمة لأيامك وهدفك';

  @override
  String get onbFocusTitle => 'عضلات عايز تركز عليها';

  @override
  String get onbFocusSubtitle => 'اختار براحتك – أو ولا واحدة لخطة متوازنة.';

  @override
  String get onbMuscleChest => 'صدر';

  @override
  String get onbMuscleBack => 'ضهر';

  @override
  String get onbMuscleShoulders => 'كتف';

  @override
  String get onbMuscleBiceps => 'باي';

  @override
  String get onbMuscleTriceps => 'تراي';

  @override
  String get onbMuscleForearms => 'سواعد';

  @override
  String get onbMuscleAbs => 'بطن';

  @override
  String get onbMuscleQuads => 'أمامية الفخذ';

  @override
  String get onbMuscleHamstrings => 'خلفية الفخذ';

  @override
  String get onbMuscleGlutes => 'مؤخرة (جلوتس)';

  @override
  String get onbMuscleCalves => 'سمانة';

  @override
  String get onbMuscleTraps => 'ترابيس';

  @override
  String get onbLocationTitle => 'بتتمرن فين؟';

  @override
  String get onbLocationSubtitle => 'عشان نختار تمارين تقدر تعملها فعلاً.';

  @override
  String get onbLocFullGym => 'جيم كامل';

  @override
  String get onbLocFullGymSub => 'أجهزة وكابلات وبار ودمبلز';

  @override
  String get onbLocLimitedGym => 'جيم محدود';

  @override
  String get onbLocLimitedGymSub => 'أدوات أساسية وأجهزة قليلة';

  @override
  String get onbLocHome => 'البيت';

  @override
  String get onbLocHomeSub => 'وزن الجسم أو دمبلز أو أستك';

  @override
  String get onbInjuriesTitle => 'إصابات أو مشاكل صحية';

  @override
  String get onbInjuriesSubtitle => 'الخطة هتبعد عن أي حاجة ممكن تأذيك.';

  @override
  String get onbInjNoneLabel => 'مفيش أي إصابات أو مشاكل';

  @override
  String get onbInjGroupJoints => 'إصابات أو ألم';

  @override
  String get onbInjGroupHealth => 'مشاكل صحية';

  @override
  String get onbInjShoulder => 'كتف';

  @override
  String get onbInjKnee => 'ركبة';

  @override
  String get onbInjLowerBack => 'ضهر سفلي';

  @override
  String get onbInjElbow => 'كوع';

  @override
  String get onbInjWrist => 'رسغ';

  @override
  String get onbInjNeck => 'رقبة';

  @override
  String get onbInjHip => 'حوض';

  @override
  String get onbInjAnkle => 'كاحل';

  @override
  String get onbInjHypertension => 'ضغط عالي';

  @override
  String get onbInjDiabetes => 'سكر';

  @override
  String get onbInjHeart => 'مشاكل في القلب';

  @override
  String get onbInjAsthma => 'ربو';

  @override
  String get onbInjHernia => 'فتق';

  @override
  String get onbInjuriesNote =>
      'حاجة تانية؟ (مثلاً الكتف الشمال بيوجع في الضغط فوق الراس)';

  @override
  String get onbInjuriesDoctor =>
      'لو عندك مشاكل في القلب أو ضغط مش منتظم، استشير دكتور قبل التمرين التقيل.';

  @override
  String get onbJobTitle => 'طبيعة شغلك إيه؟';

  @override
  String get onbJobSubtitle => 'حركتك اليومية بتفرق في السعرات اللي بتحرقها.';

  @override
  String get onbJobDesk => 'شغل مكتبي';

  @override
  String get onbJobDeskSub => 'قاعد أغلب اليوم';

  @override
  String get onbJobMobile => 'شغل فيه حركة';

  @override
  String get onbJobMobileSub => 'ماشي وواقف كتير';

  @override
  String get onbJobPhysical => 'مجهود بدني';

  @override
  String get onbJobPhysicalSub => 'شيل ورفع وشغل تقيل';

  @override
  String get onbJobNone => 'مش بشتغل / طالب';

  @override
  String get onbJobNoneSub => 'يومي مرن';

  @override
  String get onbJobHours => 'مواعيد الشغل (اختياري)';

  @override
  String get onbJobFrom => 'من';

  @override
  String get onbJobTo => 'لحد';

  @override
  String get onbClear => 'امسح';

  @override
  String get onbSleepTitle => 'مواعيد نومك المعتادة';

  @override
  String get onbSleepSubtitle => 'النوم نص المكسب – هنظبط المواعيد عليه.';

  @override
  String get onbSleepTime => 'معاد النوم';

  @override
  String get onbWakeTime => 'معاد الصحيان';

  @override
  String onbSleepDuration(String hours) {
    return '≈ $hours ساعة نوم';
  }

  @override
  String get onbSleepShort => 'أقل من 7 ساعات – حاول تنام أكتر عشان الاستشفاء.';

  @override
  String get onbTrainTimeTitle => 'بتتمرن إمتى عادةً؟';

  @override
  String get onbTrainTimeSubtitle => 'هنفكرك ونظبط الوجبات حوالين المعاد.';

  @override
  String get onbTimeMorning => 'الصبح';

  @override
  String get onbTimeAfterWork => 'بعد الشغل';

  @override
  String get onbTimeNight => 'بالليل';

  @override
  String get onbExactTime => 'المعاد بالظبط';

  @override
  String get onbCardioTitle => 'الكارديو';

  @override
  String get onbCardioSubtitle => 'بتعمل إيه وكام مرة؟';

  @override
  String get onbCardioNone => 'مفيش كارديو';

  @override
  String get onbCardioWalking => 'مشي';

  @override
  String get onbCardioRunning => 'جري';

  @override
  String get onbCardioCycling => 'عجلة';

  @override
  String get onbCardioElliptical => 'أوبتيكال';

  @override
  String get onbCardioSwimming => 'سباحة';

  @override
  String get onbCardioHiit => 'HIIT';

  @override
  String get onbCardioStairs => 'سلالم';

  @override
  String get onbCardioJumpRope => 'نط حبل';

  @override
  String get onbCardioFootball => 'كورة';

  @override
  String get onbCardioPerWeek => 'كام مرة في الأسبوع';

  @override
  String get onbMealsTitle => 'عدد الوجبات في اليوم';

  @override
  String get onbMealsSubtitle => 'ومواعيدها – دوس على المعاد عشان تغيره.';

  @override
  String onbMealN(String n) {
    return 'وجبة $n';
  }

  @override
  String get onbMealsReset => 'اقترح مواعيد';

  @override
  String get onbFoodsTitle => 'الأكل اللي بتحبه';

  @override
  String get onbFoodsSubtitle =>
      'خطة الأكل هتستخدم اللي بتحبه وتبعد عن اللي مبتحبوش.';

  @override
  String get onbFoodsLiked => 'أكلات بتحبها';

  @override
  String get onbFoodsDisliked => 'أكلات مبتحبهاش';

  @override
  String get onbAllergies => 'حساسية';

  @override
  String get onbFoodsOther => 'حاجات تانية (افصل بفاصلة)';

  @override
  String get onbFoodFul => 'فول';

  @override
  String get onbFoodEggs => 'بيض';

  @override
  String get onbFoodChicken => 'فراخ';

  @override
  String get onbFoodTuna => 'تونة';

  @override
  String get onbFoodRice => 'رز';

  @override
  String get onbFoodBaladiBread => 'عيش بلدي';

  @override
  String get onbFoodYogurt => 'زبادي';

  @override
  String get onbFoodCottageCheese => 'جبنة قريش';

  @override
  String get onbFoodWhiteCheese => 'جبنة بيضا';

  @override
  String get onbFoodKoshari => 'كشري';

  @override
  String get onbFoodMincedBeef => 'لحمة مفرومة';

  @override
  String get onbFoodFish => 'سمك';

  @override
  String get onbFoodLentils => 'عدس';

  @override
  String get onbFoodTaameya => 'طعمية';

  @override
  String get onbFoodOats => 'شوفان';

  @override
  String get onbFoodPasta => 'مكرونة';

  @override
  String get onbFoodPotatoes => 'بطاطس';

  @override
  String get onbFoodSweetPotato => 'بطاطا';

  @override
  String get onbFoodMilk => 'لبن';

  @override
  String get onbFoodPeanutButter => 'زبدة فول سوداني';

  @override
  String get onbFoodBananas => 'موز';

  @override
  String get onbFoodDates => 'بلح';

  @override
  String get onbFoodLiver => 'كبدة';

  @override
  String get onbFoodMolokhia => 'ملوخية';

  @override
  String get onbAllergyLactose => 'اللاكتوز';

  @override
  String get onbAllergyGluten => 'الجلوتين';

  @override
  String get onbAllergyNuts => 'المكسرات';

  @override
  String get onbAllergyPeanuts => 'الفول السوداني';

  @override
  String get onbAllergyEggs => 'البيض';

  @override
  String get onbAllergySeafood => 'المأكولات البحرية';

  @override
  String get onbBudgetTitle => 'ميزانية الأكل في الشهر';

  @override
  String get onbBudgetSubtitle => 'بالجنيه المصري – خطة الأكل هتمشي عليها.';

  @override
  String get onbBudgetLow => 'منخفضة';

  @override
  String get onbBudgetLowSub => 'الأساسيات: بيض وفول ورز وفراخ وقريش';

  @override
  String get onbBudgetMedium => 'متوسطة';

  @override
  String get onbBudgetMediumSub => 'يدخل لحمة وسمك وشوفان وشوية إضافات';

  @override
  String get onbBudgetOpen => 'مفتوحة';

  @override
  String get onbBudgetOpenSub => 'اللي يناسب الخطة أكتر';

  @override
  String get onbBudgetCustom => 'مبلغ محدد';

  @override
  String get onbBudgetCustomSub => 'اكتبه بالجنيه';

  @override
  String get onbBudgetAmount => 'المبلغ في الشهر';

  @override
  String get onbEgp => 'جنيه';

  @override
  String get onbSuppTitle => 'المكملات اللي بتاخدها';

  @override
  String get onbSuppSubtitle =>
      'دوس عشان تضيف وحدد الجرعة. البروتين والسعرات بيتحسبوا في يومك.';

  @override
  String get onbSuppEmpty => 'مفيش مكملات – عادي جدًا.';

  @override
  String get onbSuppWhey => 'واي بروتين';

  @override
  String get onbSuppCreatine => 'كرياتين';

  @override
  String get onbSuppMassGainer => 'ماس جينر';

  @override
  String get onbSuppCasein => 'كازين';

  @override
  String get onbSuppMultivitamin => 'مالتي فيتامين';

  @override
  String get onbSuppOmega3 => 'أوميجا 3';

  @override
  String get onbSuppVitaminD => 'فيتامين د';

  @override
  String get onbSuppZma => 'ZMA';

  @override
  String get onbSuppBcaa => 'BCAA';

  @override
  String get onbSuppPreWorkout => 'بري وركاوت';

  @override
  String get onbSuppCaffeine => 'كافيين';

  @override
  String get onbSuppOther => 'حاجة تانية';

  @override
  String get onbSuppName => 'الاسم';

  @override
  String get onbSuppDose => 'الجرعة';

  @override
  String get onbSuppTiming => 'إمتى؟ (اختياري)';

  @override
  String get onbSuppPerServing => 'في الجرعة الواحدة';

  @override
  String get onbSuppProtein => 'بروتين (جم)';

  @override
  String get onbSuppCalories => 'سعرات';

  @override
  String get onbSuppCarbs => 'كارب (جم)';

  @override
  String get onbSuppFat => 'دهون (جم)';

  @override
  String get onbSuppAddMacros => 'بيدخل في السعرات؟';

  @override
  String get onbSuppRemove => 'شيل';

  @override
  String get onbDoseScoop => 'سكوب واحد (30 جم)';

  @override
  String get onbDoseScoopPlain => 'سكوب واحد';

  @override
  String get onbDoseGainer => 'جرعة واحدة (100 جم)';

  @override
  String onbDoseGrams(String g) {
    return '$g جم';
  }

  @override
  String get onbDoseTablet => 'قرص واحد';

  @override
  String get onbDoseCapsule => 'كبسولة واحدة';

  @override
  String get onbDoseServing => 'جرعة واحدة';

  @override
  String onbDoseMg(String mg) {
    return '$mg مجم';
  }

  @override
  String onbSuppMacrosValue(String protein, String calories) {
    return '$protein جم بروتين · $calories سعر';
  }

  @override
  String get onbWaterTitle => 'هدف الميه في اليوم';

  @override
  String get onbWaterSubtitle => 'مقترح حسب وزنك – عدّله لو حابب.';

  @override
  String onbWaterSuggested(String ml) {
    return 'المقترح: $ml مل';
  }

  @override
  String onbWaterLiters(String liters) {
    return '≈ $liters لتر';
  }

  @override
  String get onbWaterUseSuggestion => 'استخدم المقترح';

  @override
  String onbWaterGlasses(String glasses) {
    return 'حوالي $glasses كوباية 250 مل';
  }

  @override
  String get onbHealthTitle => 'اربط الخاتم الذكي';

  @override
  String get onbHealthSubtitle =>
      'عن طريق Health Connect هنقرا النوم والنبض والـ HRV والخطوات عشان نحسب درجة الاستشفاء اليومية.';

  @override
  String get onbHealthConnect => 'اربط Health Connect';

  @override
  String get onbHealthConnected => 'Health Connect متوصل';

  @override
  String get onbHealthConnectedSub => 'هنزامن لما تفتح الأبلكيشن وكل كام ساعة.';

  @override
  String get onbHealthDisconnect => 'اقفله';

  @override
  String get onbHealthNote =>
      'لو تطبيق الخاتم مش بيكتب في Health Connect تقدر تسجل النوم يدوي – مفيش حاجة هتبوظ. وتقدر تشوف آخر بيانات اتسحبت من الإعدادات.';

  @override
  String get onbHealthItemSleep => 'النوم ومراحله';

  @override
  String get onbHealthItemHeart => 'النبض ونبض الراحة والـ HRV';

  @override
  String get onbHealthItemSteps => 'الخطوات والسعرات المحروقة';

  @override
  String get onbKeyTitle => 'مفتاح Claude API';

  @override
  String get onbKeySubtitle =>
      'ده اللي بيشغّل المدرب الذكي والخطط وتحليل صور الأكل. باقي الأبلكيشن شغال من غيره – وتقدر تضيفه بعدين من الإعدادات.';

  @override
  String get onbKeyField => 'المفتاح (sk-ant-…)';

  @override
  String get onbKeyWhere =>
      'هتجيبه من console.anthropic.com ← API Keys. بيتخزن متشفّر على الموبايل ده بس.';

  @override
  String get onbKeyTest => 'اختبر المفتاح';

  @override
  String get onbKeySave => 'احفظ المفتاح';

  @override
  String get onbKeyValid => 'المفتاح شغال';

  @override
  String onbKeyInvalid(String error) {
    return 'المفتاح مشتغلش: $error';
  }

  @override
  String get onbKeySaved => 'المفتاح اتحفظ بأمان على الموبايل';

  @override
  String get onbKeyReplace => 'غيّر المفتاح';

  @override
  String get onbKeyEmpty => 'حط المفتاح الأول';

  @override
  String get onbSummaryTitle => 'راجع إجاباتك';

  @override
  String get onbSummarySubtitle =>
      'دوس على أي إجابة عشان تغيرها، وبعدين ابني خطتك.';

  @override
  String get onbSumLanguage => 'اللغة';

  @override
  String get onbSumBody => 'الجسم';

  @override
  String get onbSumBodyFat => 'نسبة الدهون';

  @override
  String get onbSumMeasurements => 'المقاسات';

  @override
  String get onbSumGoal => 'الهدف';

  @override
  String get onbSumLevel => 'المستوى';

  @override
  String get onbSumDays => 'أيام التمرين';

  @override
  String get onbSumSession => 'مدة التمرينة';

  @override
  String get onbSumSplit => 'أسلوب التمرين';

  @override
  String get onbSumFocus => 'عضلات التركيز';

  @override
  String get onbSumLocation => 'المكان';

  @override
  String get onbSumInjuries => 'الإصابات والصحة';

  @override
  String get onbSumJob => 'الشغل';

  @override
  String get onbSumSleep => 'النوم';

  @override
  String get onbSumTrainingTime => 'معاد التمرين';

  @override
  String get onbSumCardio => 'الكارديو';

  @override
  String get onbSumMeals => 'الوجبات';

  @override
  String get onbSumFoods => 'تفضيلات الأكل';

  @override
  String get onbSumBudget => 'ميزانية الأكل';

  @override
  String get onbSumSupplements => 'المكملات';

  @override
  String get onbSumWater => 'هدف الميه';

  @override
  String get onbSumHealth => 'Health Connect';

  @override
  String get onbSumApiKey => 'مفتاح Claude';

  @override
  String onbYearsValue(String age) {
    return '$age سنة';
  }

  @override
  String onbPerWeekValue(String n) {
    return '$n مرات في الأسبوع';
  }

  @override
  String onbWeeksValue(String weeks) {
    return '$weeks أسبوع';
  }

  @override
  String onbLikesValue(String list) {
    return 'بيحب: $list';
  }

  @override
  String onbDislikesValue(String list) {
    return 'مبيحبش: $list';
  }

  @override
  String onbAllergiesValue(String list) {
    return 'حساسية: $list';
  }

  @override
  String onbBodyFatShapeValue(String pct) {
    return '≈ $pct% (من شكل الجسم)';
  }

  @override
  String get onbConnected => 'متوصل';

  @override
  String get onbNotConnected => 'مش متوصل';

  @override
  String get onbKeySet => 'متضاف';

  @override
  String get onbKeyNotSet => 'مش متضاف – ضيفه بعدين';

  @override
  String get onbBuildingTitle => 'بنبني خطتك';

  @override
  String get onbBuildReadyTitle => 'خطتك جاهزة';

  @override
  String get onbBuildHint =>
      'ممكن ياخد دقيقة أو اتنين – الـ AI بيفكر فيها كويس.';

  @override
  String get onbBuildTargets => 'السعرات والماكروز';

  @override
  String get onbBuildWorkout => 'خطة التمرين';

  @override
  String get onbBuildMeals => 'خطة الأكل';

  @override
  String get onbBuildWorkoutLater =>
      'عملنالك خطة جاهزة من إجاباتك دلوقتي – وتقدر تعملها بالـ AI بعدين من تاب التمرين.';

  @override
  String get onbBuildMealsLater =>
      'عملنالك خطة أكل جاهزة دلوقتي – وتقدر تعملها بالـ AI بعدين من تاب الأكل.';

  @override
  String get onbBuildNoKey =>
      'لسه مفيش مفتاح Claude API، فعملنالك خطة تمرين وخطة أكل جاهزين من إجاباتك. ضيف المفتاح بعدين من الإعدادات وتقدر تعملهم بالـ AI من تاب التمرين وتاب الأكل.';

  @override
  String get onbBuildOffline =>
      'مفيش نت دلوقتي، فعملنالك خطة تمرين وخطة أكل جاهزين من إجاباتك. تقدر تعملهم بالـ AI من تاب التمرين وتاب الأكل لما النت يرجع.';

  @override
  String get onbDailyTargets => 'أهدافك اليومية';

  @override
  String get onbTdee => 'سعرات الثبات';

  @override
  String get onbTrainingDayCarbs => 'كارب يوم التمرين';

  @override
  String get onbRestDayCarbs => 'كارب يوم الراحة';

  @override
  String get onbReviewPlan => 'راجع خطة التمرين';

  @override
  String get onbSkipReview => 'هراجعها بعدين';

  @override
  String get onbStartApp => 'يلا بينا';

  @override
  String get onbGenericError => 'معرفناش نعملها دلوقتي.';

  @override
  String get onbStatusWaiting => 'مستني…';

  @override
  String get onbStatusWorking => 'شغالين عليها…';

  @override
  String get onbStatusDone => 'جاهزة';

  @override
  String get onbStatusFailed => 'مش دلوقتي';

  @override
  String get onbStatusTemplate => 'خطة جاهزة';

  @override
  String get onbProfileTitle => 'البروفايل';

  @override
  String get onbProfileSubtitle =>
      'دوس على أي إجابة عشان تغيرها. الأهداف بتتحدث لوحدها.';

  @override
  String get onbProfileTargets => 'أهدافك الحالية';

  @override
  String get onbSavedTargets => 'اتحفظ – والأهداف اتحدثت';

  @override
  String get onbSaved => 'اتحفظ';

  @override
  String get onbRegenTitle => 'نحدّث خططك؟';

  @override
  String get onbRegenBody =>
      'إجاباتك اتغيرت. نعمل الخطط من جديد بالـ AI عشان تناسبك؟';

  @override
  String get onbRegenWorkout => 'خطة التمرين';

  @override
  String get onbRegenMeals => 'خطة الأكل';

  @override
  String get onbRegenNow => 'اعملها من جديد';

  @override
  String get onbRegenSkip => 'مش دلوقتي';

  @override
  String get onbRegenRunning => 'بنعمل خططك من جديد…';

  @override
  String get onbRegenMealDone => 'خطة الأكل الجديدة جاهزة.';

  @override
  String get onbRegenWorkoutDone => 'خطة التمرين الجديدة جاهزة للمراجعة.';

  @override
  String get onbRegenNoKey =>
      'ضيف مفتاح Claude API من الإعدادات عشان تعمل الخطط بالـ AI.';

  @override
  String get onbRegenOffline => 'مفيش نت دلوقتي – جرب تاني لما النت يرجع.';

  @override
  String get onbRegenResultTitle => 'تحديث الخطط';

  @override
  String get onbPlanActivated => 'الخطة اتفعلت';

  @override
  String get onbErrSex => 'اختار ذكر ولا أنثى';

  @override
  String get onbErrAge => 'السن لازم يكون بين 12 و 90';

  @override
  String get onbErrHeight => 'الطول لازم يكون بين 120 و 230 سم';

  @override
  String get onbErrWeight => 'الوزن لازم يكون بين 30 و 300 كجم';

  @override
  String get onbErrBodyFatChoice => 'اختار واحد من الاختيارات';

  @override
  String get onbErrBodyFat => 'نسبة الدهون لازم تكون بين 3% و 60%';

  @override
  String get onbErrMeasurement => 'المقاسات لازم تكون بين 10 و 250 سم';

  @override
  String get onbErrGoal => 'اختار هدف';

  @override
  String get onbErrTargetWeight => 'الوزن المستهدف لازم يكون بين 30 و 300 كجم';

  @override
  String get onbErrWeeks => 'عدد الأسابيع لازم يكون بين 1 و 104';

  @override
  String get onbErrLevel => 'اختار مستواك وبقالك قد إيه بتتمرن';

  @override
  String get onbErrDaysCount => 'اختار كام يوم في الأسبوع';

  @override
  String onbErrDaysMismatch(String count) {
    return 'اختار $count أيام بالظبط';
  }

  @override
  String get onbErrChoose => 'اختار حاجة عشان تكمل';

  @override
  String get onbErrSleep => 'حدد معاد النوم والصحيان';

  @override
  String get onbErrCardioPerWeek => 'كام مرة في الأسبوع؟';

  @override
  String get onbErrMealTimes => 'حدد معاد لكل وجبة';

  @override
  String get onbErrBudget => 'اكتب مبلغ بين 100 و 1,000,000 جنيه';

  @override
  String get onbErrSuppName => 'كل مكمل لازم يكون ليه اسم';

  @override
  String get onbErrWater => 'هدف الميه لازم يكون بين 1,000 و 8,000 مل';

  @override
  String get progTitle => 'التقدم';

  @override
  String get progPeriodWeek => 'أسبوع';

  @override
  String get progPeriodMonth => 'شهر';

  @override
  String get progPeriod3Months => '3 شهور';

  @override
  String get progPeriodYear => 'سنة';

  @override
  String get progPeriodAll => 'الكل';

  @override
  String get progLinkPrs => 'الأرقام القياسية';

  @override
  String get progLinkPhotos => 'صور التقدم';

  @override
  String get progLinkMeasurements => 'المقاسات';

  @override
  String get progLinkWeight => 'وزن الجسم';

  @override
  String get progExportPdf => 'تصدير تقرير PDF';

  @override
  String get progCalendarTitle => 'كاليندر الالتزام';

  @override
  String get progLegendCompleted => 'كاملة';

  @override
  String get progLegendPartial => 'جزئية';

  @override
  String get progLegendMissed => 'غياب';

  @override
  String get progLegendRest => 'راحة';

  @override
  String progAdherencePct(String pct) {
    return 'التزام $pct%';
  }

  @override
  String get progAdherenceNone => 'لسه مفيش أيام تمرين عدّت الشهر ده';

  @override
  String progAdherenceCounts(String completed, String partial, String missed) {
    return '$completed كاملة · $partial جزئية · $missed غياب';
  }

  @override
  String get progPrevMonth => 'الشهر اللي فات';

  @override
  String get progNextMonth => 'الشهر الجاي';

  @override
  String get progStatusInProgress => 'شغالة دلوقتي';

  @override
  String get progStatusRestDay => 'يوم راحة';

  @override
  String get progStatusToday => 'النهارده – لسه متمرنتش';

  @override
  String get progStatusFuture => 'لسه جاي';

  @override
  String get progStatusNone => 'قبل ما تبدأ تسجّل';

  @override
  String get progDayNothing => 'مفيش حاجة متسجلة اليوم ده.';

  @override
  String get progDayWorkout => 'التمرينة';

  @override
  String get progDayNutrition => 'الأكل';

  @override
  String get progDayWater => 'الميه';

  @override
  String get progDaySleep => 'النوم';

  @override
  String get progDayWeight => 'الوزن';

  @override
  String get progDayRecovery => 'الاستشفاء';

  @override
  String get progDayCardio => 'كارديو';

  @override
  String get progSetTypeWarmup => 'إحماء';

  @override
  String get progSetTypeDrop => 'دروب ست';

  @override
  String get progSetTypeFailure => 'لحد الفشل';

  @override
  String progVolumeValue(String value) {
    return 'الحجم $value كجم';
  }

  @override
  String progSetsCount(String count) {
    return 'ستات: $count';
  }

  @override
  String progPrsCount(String count) {
    return 'أرقام قياسية: $count';
  }

  @override
  String get progPrBadge => 'PR';

  @override
  String progDurationMin(String minutes) {
    return '$minutes دقيقة';
  }

  @override
  String progMealsCount(String count) {
    return 'وجبات: $count';
  }

  @override
  String get progUnknownExercise => 'تمرين مش معروف';

  @override
  String get progExerciseTitle => 'تطور التمارين';

  @override
  String get progPickExercise => 'اختار تمرين';

  @override
  String get progSearchExercise => 'دوّر في تمارينك';

  @override
  String get progTopSet => 'أتقل ست';

  @override
  String get progE1rm => '1RM المتوقع';

  @override
  String get progNoExerciseData => 'سجّل تمرينة وتطور قوتك هيظهر هنا.';

  @override
  String get progNoDataInPeriod => 'مفيش بيانات في الفترة دي.';

  @override
  String get progBest => 'الأفضل';

  @override
  String get progChange => 'التغيير';

  @override
  String get progLatest => 'آخر قراءة';

  @override
  String progSessionsCount(String count) {
    return 'جلسات: $count';
  }

  @override
  String get progNoMatches => 'مفيش نتايج';

  @override
  String get progVolumeTitle => 'حجم التمرين الأسبوعي لكل عضلة';

  @override
  String progAvgPerWeek(String days) {
    return 'متوسط الأسبوع على مدار $days يوم · الحجم = الوزن × العدات';
  }

  @override
  String get progEffectiveSets => 'الستات الفعّالة / أسبوع';

  @override
  String get progEffectiveSetsHint =>
      'الست الفعّال = ست أساسي بـ RPE 7 أو أكتر (أو من غير RPE). حوالي 10–20 ست في الأسبوع لكل عضلة رينج كويس للتضخيم.';

  @override
  String get progWeeklyTotal => 'الحجم الكلي كل أسبوع';

  @override
  String get progNoVolumeData => 'مفيش ستات متسجلة في الفترة دي.';

  @override
  String get progMuscleCol => 'العضلة';

  @override
  String get progVolumeCol => 'الحجم/أسبوع';

  @override
  String get progSetsCol => 'ستات فعّالة';

  @override
  String get progBodyTitle => 'وزن الجسم';

  @override
  String get progDaily => 'يومي';

  @override
  String get progMovingAvg => 'متوسط 7 أيام';

  @override
  String get progMeasurementsTitle => 'المقاسات';

  @override
  String get progNoWeightData => 'مفيش وزن متسجل في الفترة دي.';

  @override
  String get progNoMeasurementData => 'مفيش مقاسات متسجلة في الفترة دي.';

  @override
  String get progLogWeight => 'سجّل وزنك';

  @override
  String get progLogMeasurements => 'سجّل مقاساتك';

  @override
  String get progMeasureWaist => 'الوسط';

  @override
  String get progMeasureChest => 'الصدر';

  @override
  String get progMeasureArm => 'الدراع';

  @override
  String get progMeasureThigh => 'الفخدة';

  @override
  String get progMeasureNeck => 'الرقبة';

  @override
  String get progMeasureHips => 'الأرداف';

  @override
  String get progMeasureBodyFat => 'نسبة الدهون %';

  @override
  String get progNutritionTitle => 'السعرات والماكروز مقابل الهدف';

  @override
  String get progTarget => 'الهدف';

  @override
  String progAvgPerDay(String days) {
    return 'متوسط اليوم ($days يوم متسجل)';
  }

  @override
  String get progNoNutritionData => 'مفيش أكل متسجل في الفترة دي.';

  @override
  String progDaysOnTarget(String count, String total) {
    return 'أيام في حدود ±10% من هدف السعرات: $count/$total';
  }

  @override
  String get progSleepTitle => 'النوم والاستشفاء';

  @override
  String get progSleepHours => 'النوم (ساعات)';

  @override
  String get progRecoveryScore => 'درجة الاستشفاء';

  @override
  String get progAvgSleep => 'متوسط النوم';

  @override
  String get progAvgRecovery => 'متوسط الاستشفاء';

  @override
  String get progNoSleepData =>
      'مفيش بيانات نوم أو استشفاء في الفترة دي. سجّل نومك يدوي أو اربط Health Connect.';

  @override
  String get progPrsTitle => 'الأرقام القياسية';

  @override
  String get progPrHeaviest => 'أتقل وزن';

  @override
  String get progPrBestE1rm => 'أعلى 1RM متوقع';

  @override
  String get progPrRepsAtWeight => 'أكتر عدات على كل وزن';

  @override
  String get progNoPrs => 'لسه مفيش أرقام قياسية – سجّل كام تمرينة الأول.';

  @override
  String progSetsLogged(String count) {
    return '$count ست أساسي';
  }

  @override
  String progLastTrained(String date) {
    return 'آخر مرة: $date';
  }

  @override
  String get progReportChoose => 'تصدير تقرير التقدم';

  @override
  String get progReportThisWeek => 'الأسبوع ده';

  @override
  String get progReportLastWeek => 'الأسبوع اللي فات';

  @override
  String get progReportThisMonth => 'الشهر ده';

  @override
  String get progReportLastMonth => 'الشهر اللي فات';

  @override
  String get progReportGenerating => 'بنجهّز التقرير…';

  @override
  String get progReportFailed => 'معرفناش نعمل التقرير';

  @override
  String get progReportShareSubject => 'تقرير تقدم IronMind';

  @override
  String get progPdfWeeklyTitle => 'تقرير التقدم الأسبوعي';

  @override
  String get progPdfMonthlyTitle => 'تقرير التقدم الشهري';

  @override
  String progPdfGenerated(String date) {
    return 'اتعمل يوم $date';
  }

  @override
  String get progPdfSummary => 'الملخص';

  @override
  String get progPdfSessionsDone => 'تمرينات اتعملت';

  @override
  String get progPdfSessionsMissed => 'أيام غياب';

  @override
  String get progPdfAdherence => 'الالتزام';

  @override
  String get progPdfVolume => 'الحجم الكلي';

  @override
  String get progPdfPrs => 'أرقام قياسية';

  @override
  String get progPdfAvgCalories => 'متوسط السعرات';

  @override
  String get progPdfAvgProtein => 'متوسط البروتين';

  @override
  String get progPdfWeightChange => 'تغيّر الوزن';

  @override
  String get progPdfAvgSleep => 'متوسط النوم';

  @override
  String get progPdfAvgRecovery => 'متوسط الاستشفاء';

  @override
  String progPdfTarget(String value) {
    return 'الهدف $value';
  }

  @override
  String get progPdfCoachSummary => 'ملخص المدرب';

  @override
  String get progPdfNoCoachSummary =>
      'مفيش تقرير أسبوعي من المدرب في الفترة دي. تقدر تطلبه من تاب المدرب.';

  @override
  String get progPdfSessionsTable => 'التمرينات';

  @override
  String get progPdfDate => 'التاريخ';

  @override
  String get progPdfName => 'التمرينة';

  @override
  String get progPdfStatus => 'الحالة';

  @override
  String get progPdfDuration => 'المدة';

  @override
  String get progPdfSets => 'الستات';

  @override
  String get progPdfExercise => 'التمرين';

  @override
  String get progPdfType => 'نوع الرقم';

  @override
  String get progPdfSet => 'الست';

  @override
  String get progPdfTypeWeight => 'أتقل وزن';

  @override
  String get progPdfTypeReps => 'عدات';

  @override
  String get progPdfTypeE1rm => '1RM';

  @override
  String get progPdfBodyTable => 'قياسات الجسم';

  @override
  String get progPdfMuscleChart => 'الحجم لكل عضلة (كجم)';

  @override
  String get progPdfCaloriesChart => 'السعرات اليومية مقابل الهدف';

  @override
  String get progPdfWeightChart => 'وزن الجسم (كجم)';

  @override
  String get progPdfNone => 'مفيش حاجة متسجلة في الفترة دي.';

  @override
  String progPdfPage(String page, String total) {
    return 'صفحة $page من $total';
  }

  @override
  String get progPdfEaten => 'اللي اتاكل';

  @override
  String get progOpenExercise => 'تفاصيل التمرين';

  @override
  String get progChangeExercise => 'غيّر';

  @override
  String get progSessionsLabel => 'الجلسات';

  @override
  String get progLegendOnTarget => 'مظبوط (±10%)';

  @override
  String get progLegendUnder => 'أقل من الهدف';

  @override
  String get progLegendOver => 'أكتر من الهدف';

  @override
  String get progWeeklyBarsNote =>
      'فترة طويلة: كل عمود = متوسط اليوم في أسبوع.';

  @override
  String get progCardioTreadmill => 'مشاية';

  @override
  String get progCardioBike => 'عجلة';

  @override
  String get progCardioElliptical => 'أوبتيكال';

  @override
  String get progCardioRowing => 'تجديف';

  @override
  String get progCardioWalk => 'مشي';

  @override
  String get progCardioRun => 'جري';

  @override
  String get progCardioStairs => 'سلالم';

  @override
  String get progCardioJumpRope => 'نط حبل';

  @override
  String get progCardioSwim => 'سباحة';

  @override
  String progPdfFromTo(String from, String to) {
    return 'من $from لـ $to';
  }

  @override
  String get setProfile => 'البروفايل';

  @override
  String get setProfileSub => 'عدّل إجاباتك وأهدافك';

  @override
  String get setSectionAi => 'المدرب الذكي (Claude)';

  @override
  String get setSectionApp => 'الأبلكيشن';

  @override
  String get setApiKey => 'مفتاح Claude API';

  @override
  String get setApiKeyHelp =>
      'بيتحفظ على الموبايل ده بس ومتشفّر. مش بيدخل في الباك أب.';

  @override
  String get setApiKeySaved => 'المفتاح اتحفظ';

  @override
  String get setApiKeyTest => 'اختبر المفتاح';

  @override
  String get setApiKeyTesting => 'بنجرّب…';

  @override
  String get setApiKeyValid => 'المفتاح شغال تمام';

  @override
  String get setApiKeyInvalid => 'المفتاح مش شغال';

  @override
  String get setApiKeyChange => 'غيّره';

  @override
  String get setApiKeyRemove => 'امسحه';

  @override
  String get setApiKeyRemoveTitle => 'تمسح المفتاح؟';

  @override
  String get setApiKeyRemoveBody => 'ميزات الـ AI هتقف لحد ما تضيف مفتاح تاني.';

  @override
  String get setModels => 'موديلات الـ AI';

  @override
  String get setModelFast => 'الموديل السريع (Haiku)';

  @override
  String get setModelFastHelp => 'تحويل الصوت والكلام، بدائل التمارين، الذاكرة';

  @override
  String get setModelBalanced => 'الموديل المتوازن (Sonnet)';

  @override
  String get setModelBalancedHelp =>
      'الشات، ملخص التمرينة، صور الأكل، رسالة الصبح';

  @override
  String get setModelSmart => 'الموديل الأذكى (Opus)';

  @override
  String get setModelSmartHelp => 'الخطة الأولى، خطة الأكل، التقرير الأسبوعي';

  @override
  String get setModelsSaved => 'الموديلات اتحفظت';

  @override
  String get setModelsReset => 'رجّع الافتراضي';

  @override
  String get setModelsResetDone => 'رجعنا الموديلات الافتراضية';

  @override
  String get setRefusalFallback => 'بديل تلقائي لو الموديل رفض';

  @override
  String get setRefusalFallbackSub =>
      'لو الموديل رفض طلب، Claude يعيده على موديل بديل لوحده.';

  @override
  String get setCost => 'مصاريف الـ AI';

  @override
  String get setCostToday => 'النهاردة';

  @override
  String get setCostMonth => 'الشهر ده';

  @override
  String get setCostAllTime => 'من الأول';

  @override
  String get setCostByFeature => 'حسب الميزة';

  @override
  String get setCostEmpty => 'مفيش طلبات AI في الفترة دي';

  @override
  String setCostTokens(String tokens) {
    return '$tokens توكن';
  }

  @override
  String setCostFeatureDetail(
    int requests,
    String input,
    String output,
    String cache,
  ) {
    return '$requests طلب · داخل $input · خارج $output · كاش $cache';
  }

  @override
  String get setCostNote => 'تقدير حسب الأسعار المعلنة. مفيش حد أقصى للصرف.';

  @override
  String get setFeatVoiceParse => 'الصوت ← ست';

  @override
  String get setFeatExerciseAlternatives => 'بدائل التمارين';

  @override
  String get setFeatMemoryExtract => 'ذاكرة المدرب';

  @override
  String get setFeatFoodText => 'أكل من الكلام';

  @override
  String get setFeatExerciseCreate => 'تمارين مخصصة';

  @override
  String get setFeatChat => 'شات المدرب';

  @override
  String get setFeatWorkoutSummary => 'ملخصات التمرين';

  @override
  String get setFeatFoodPhoto => 'صور الأكل';

  @override
  String get setFeatMorningMessage => 'رسالة الصبح';

  @override
  String get setFeatPlateau => 'تنبيهات الثبات';

  @override
  String get setFeatMealSwap => 'تبديل الوجبات';

  @override
  String get setFeatGroceryList => 'قائمة المشتريات';

  @override
  String get setFeatInitialPlan => 'خطة التمرين';

  @override
  String get setFeatMealPlan => 'خطة الأكل';

  @override
  String get setFeatWeeklyReport => 'التقرير الأسبوعي';

  @override
  String get setFeatKeyTest => 'اختبار المفتاح';

  @override
  String get setNotifications => 'الإشعارات';

  @override
  String get setNotificationsSub =>
      'التمرين، الوجبات، الميه، المكملات، الوزن، المدرب';

  @override
  String get setHealthConnect => 'Health Connect';

  @override
  String get setHealthConnectSub => 'الخاتم أو الساعة: النوم، النبض، الخطوات';

  @override
  String get setCoachMemory => 'ذاكرة المدرب';

  @override
  String get setCoachMemorySub => 'الحاجات اللي المدرب فاكرها عنك';

  @override
  String get setBackup => 'النسخ الاحتياطي';

  @override
  String get setBackupSub => 'صدّر كل حاجة في ملف واحد أو رجّعها';

  @override
  String get setBackupBanner => 'بقالك أكتر من أسبوعين من غير باك أب.';

  @override
  String get setBackupNow => 'اعمل باك أب';

  @override
  String get setLock => 'قفل البصمة';

  @override
  String get setLockSub => 'بصمة أو وش أو PIN لما تفتح الأبلكيشن';

  @override
  String get setLockTimeout => 'يقفل بعد ما تسيب الأبلكيشن';

  @override
  String get setLockImmediately => 'على طول';

  @override
  String setLockSeconds(int seconds) {
    return '$seconds ثانية';
  }

  @override
  String setLockMinutes(int minutes) {
    return '$minutes دقيقة';
  }

  @override
  String get setLockUnsupported =>
      'مفيش بصمة أو قفل شاشة متظبط على الموبايل ده.';

  @override
  String get setLockFailed => 'التحقق فشل. جرّب تاني.';

  @override
  String get setLockEnableReason => 'أكّد عشان تشغّل القفل';

  @override
  String get setLockDisableReason => 'أكّد عشان تقفل القفل';

  @override
  String get setLockReason => 'افتح IronMind';

  @override
  String get setLockLocked => 'IronMind مقفول';

  @override
  String get setLockUnlock => 'افتح';

  @override
  String get setAbout => 'عن الأبلكيشن';

  @override
  String get setAboutSub => 'الإصدار، مصادر البيانات، والتراخيص';

  @override
  String setAboutVersion(String version) {
    return 'الإصدار $version';
  }

  @override
  String get setAboutTagline =>
      'مدربك الشخصي في الجيم — تمرين وأكل ونوم وجسم، بذكاء Claude.';

  @override
  String get setAboutSources => 'مصادر البيانات والتراخيص';

  @override
  String get setAboutExerciseDb => 'بيانات وصور مكتبة التمارين';

  @override
  String get setAboutFontAr => 'الخط العربي';

  @override
  String get setAboutFontEn => 'الخط الإنجليزي';

  @override
  String get setAboutClaude => 'المدرب الذكي (بمفتاحك الخاص)';

  @override
  String get setAboutPrivacy => 'الخصوصية';

  @override
  String get setAboutPrivacyBody =>
      'كل بياناتك على الموبايل ده بس. اللي بيتبعت لـ Claude هو طلبات الـ AI اللي انت بتطلبها، وصور التقدم عمرها ما بتتبعت غير لو طلبت صراحة.';

  @override
  String get setAboutLicenses => 'تراخيص المكتبات المفتوحة';

  @override
  String get setExerciseImages => 'صور التمارين أوفلاين';

  @override
  String get setExerciseImagesSub =>
      'نزّل كل صور التمارين عشان تشتغل من غير نت';

  @override
  String get setBackupExport => 'تصدير نسخة احتياطية';

  @override
  String get setBackupExportHelp =>
      'ملف .zip واحد فيه القاعدة وصور التقدم وصور الأكل وصور التمارين المخصصة. احفظه على Drive أو أي مكان.';

  @override
  String get setBackupExportButton => 'صدّر وشارك';

  @override
  String get setBackupWorking => 'بنجهز الباك أب…';

  @override
  String get setBackupNever => 'لسه معملتش باك أب';

  @override
  String setBackupLast(String date) {
    return 'آخر باك أب: $date';
  }

  @override
  String get setBackupDone => 'الباك أب جاهز';

  @override
  String setBackupFailed(String error) {
    return 'الباك أب فشل: $error';
  }

  @override
  String get setBackupShareSubject => 'باك أب IronMind';

  @override
  String get setBackupKeyNote =>
      'مفتاح Claude مش بيدخل في الباك أب. ضيفه تاني بعد الاسترجاع على موبايل جديد.';

  @override
  String get setRestore => 'استرجاع من باك أب';

  @override
  String get setRestoreHelp =>
      'هيستبدل كل الداتا اللي على الموبايل ده بالباك أب.';

  @override
  String get setRestoreButton => 'اختار ملف الباك أب';

  @override
  String get setRestorePick => 'اختار باك أب IronMind (.zip)';

  @override
  String get setRestoreNotBackup => 'الملف ده مش باك أب IronMind.';

  @override
  String get setRestoreCorrupt => 'ملف الباك أب بايظ أو ناقص.';

  @override
  String get setRestoreNewer =>
      'الباك أب ده من نسخة أحدث من الأبلكيشن. حدّث الأبلكيشن الأول.';

  @override
  String get setRestoreConfirmTitle => 'تستبدل كل الداتا؟';

  @override
  String setRestoreConfirmBody(String date, String version) {
    return 'باك أب من $date (نسخة $version). كل اللي على الموبايل دلوقتي هيتمسح ويتحط مكانه. مفيش رجوع.';
  }

  @override
  String get setRestoreReplace => 'استبدل';

  @override
  String get setRestoreWorking => 'بنرجّع الداتا… ما تقفلش الأبلكيشن.';

  @override
  String get setRestoreDone => 'الاسترجاع خلص';

  @override
  String get setRestoreFailed => 'الاسترجاع فشل';

  @override
  String get setRestoreRestart => 'اقفل الأبلكيشن وافتحه تاني عشان تكمل.';

  @override
  String get setRestoreCloseApp => 'اقفل الأبلكيشن';

  @override
  String get setChannelWorkout => 'تذكير التمرين';

  @override
  String get setChannelMeals => 'تذكير الوجبات';

  @override
  String get setChannelWater => 'تذكير الميه';

  @override
  String get setChannelSupplements => 'تذكير المكملات';

  @override
  String get setChannelWeight => 'تذكير الوزن';

  @override
  String get setChannelCoach => 'رسايل المدرب';

  @override
  String get setChannelRestTimer => 'تايمر الراحة';

  @override
  String get setChannelBackup => 'تذكير الباك أب';

  @override
  String get setNotifWorkoutTitle => 'النهاردة يوم تمرين 💪';

  @override
  String setNotifWorkoutBody(String time) {
    return 'تمرينك الساعة $time. جهّز نفسك.';
  }

  @override
  String setNotifMealTitle(int number) {
    return 'الوجبة $number';
  }

  @override
  String get setNotifMealBody => 'وقت الأكل — سجّله بعدها.';

  @override
  String get setNotifWaterTitle => 'اشرب ميه 💧';

  @override
  String get setNotifWaterBody => 'كوباية دلوقتي تخليك على الهدف.';

  @override
  String get setNotifSupplementsTitle => 'المكملات';

  @override
  String get setNotifWeightTitle => 'وزن الصبح';

  @override
  String get setNotifWeightBody => 'اتوزن قبل ما تاكل أو تشرب.';

  @override
  String get setNotifBackupTitle => 'وقت الباك أب';

  @override
  String get setNotifBackupBody =>
      'بقالك أسبوعين من غير باك أب. اعمل واحد من الإعدادات عشان ما تخسرش تقدمك.';

  @override
  String get setNotifPermissionOff => 'الإشعارات مقفولة لـ IronMind.';

  @override
  String get setNotifExactOff =>
      'المنبهات الدقيقة مقفولة — التذكير ممكن يتأخر كام دقيقة.';

  @override
  String get setNotifAllow => 'اسمح';

  @override
  String get setNotifWorkout => 'تذكير التمرين';

  @override
  String setNotifWorkoutDays(String days) {
    return 'في أيام التمرين: $days';
  }

  @override
  String get setNotifWorkoutNoDays => 'حدد أيام تمرينك من البروفايل';

  @override
  String setNotifWorkoutDefault(String time) {
    return 'الافتراضي (قبل $time بنص ساعة)';
  }

  @override
  String get setNotifTime => 'ميعاد التذكير';

  @override
  String get setNotifMeals => 'تذكير الوجبات';

  @override
  String get setNotifMealsSub => 'في ميعاد كل وجبة';

  @override
  String get setNotifUseProfileTimes => 'استخدم مواعيد الوجبات من البروفايل';

  @override
  String get setNotifWater => 'تذكير الميه';

  @override
  String setNotifWaterSub(String wake, String sleep) {
    return 'وانت صاحي ($wake – $sleep)';
  }

  @override
  String get setNotifWaterEvery => 'فكّرني كل';

  @override
  String setNotifHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours ساعة',
      many: '$hours ساعة',
      few: '$hours ساعات',
      two: 'ساعتين',
      one: 'ساعة',
    );
    return '$_temp0';
  }

  @override
  String get setNotifSupplements => 'تذكير المكملات';

  @override
  String get setNotifNoSupplements => 'لسه مضفتش مكملات';

  @override
  String get setNotifWeight => 'وزن الصبح';

  @override
  String get setNotifWeightSub => 'أول ما تصحى';

  @override
  String get setNotifWeightDefault => 'الافتراضي (بعد الصحيان بربع ساعة)';

  @override
  String get setNotifCoach => 'مبادرات المدرب';

  @override
  String get setNotifCoachSub =>
      'رسالة الصبح، ملخص التمرينة، تنبيه الثبات، التقرير الأسبوعي';

  @override
  String get setNotifBackup => 'تذكير الباك أب';

  @override
  String get setNotifBackupSub => 'لو عدّى أسبوعين من غير باك أب';

  @override
  String get setNotifTest => 'ابعت إشعار تجربة';

  @override
  String get setNotifTestTitle => 'IronMind';

  @override
  String get setNotifTestBody => 'الإشعارات شغالة ✅';

  @override
  String get setWidgetWorkoutLabel => 'تمرينة النهاردة';

  @override
  String get setWidgetWorkout => 'تمرين';

  @override
  String get setWidgetNoPlan => 'لسه مفيش خطة';

  @override
  String get setWidgetOpenApp => 'افتح الأبلكيشن وابدأ';

  @override
  String get setWidgetRestDay => 'يوم راحة';

  @override
  String get setWidgetRestSub => 'استريح كويس';

  @override
  String get setWidgetWorkoutDone => 'خلصت ✓';

  @override
  String setWidgetExercises(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تمرين',
      many: '$count تمرين',
      few: '$count تمارين',
      two: 'تمرينين',
      one: 'تمرين واحد',
    );
    return '$_temp0';
  }

  @override
  String get setWidgetCaloriesLabel => 'السعرات';

  @override
  String setWidgetKcalLeft(int kcal) {
    return 'باقي $kcal';
  }

  @override
  String setWidgetKcalOver(int kcal) {
    return 'زيادة $kcal';
  }

  @override
  String get setWidgetWaterLabel => 'الميه';

  @override
  String setWidgetWaterText(int ml, int goal) {
    return '$ml / $goal مل';
  }

  @override
  String get setWidgetAddCup => '+ كوباية';

  @override
  String get todayCoachTitle => 'المدرب';

  @override
  String get todayCoachEmpty => 'رسالة المدرب بتاعة الصبح هتظهر هنا.';

  @override
  String get todayRecoveryTitle => 'الاستشفاء';

  @override
  String get todayRecoveryEmpty =>
      'سجّل نومك أو اربط Health Connect عشان تطلعلك درجة الاستشفاء.';

  @override
  String get todayRecoveryHigh => 'مستشفي كويس — اضغط جامد النهاردة.';

  @override
  String get todayRecoveryModerate => 'استشفاء متوسط — اتمرن عادي واسمع جسمك.';

  @override
  String get todayRecoveryLow => 'استشفاء واطي — يفضل تخفف تمرينة النهاردة.';

  @override
  String get todayWorkoutTitle => 'تمرينة النهاردة';

  @override
  String get todayNoPlan => 'مفيش خطة لسه. اعمل واحدة من تاب التمرين.';

  @override
  String get todayRestDay => 'يوم راحة. ريّح، كُل كويس وخلّص الميه بتاعتك.';

  @override
  String todayExerciseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تمرين',
      few: '$count تمارين',
      two: 'تمرينين',
      one: 'تمرين واحد',
    );
    return '$_temp0';
  }

  @override
  String get todayStartWorkout => 'ابدأ تمرينة النهاردة';

  @override
  String get todayResumeWorkout => 'كمّل التمرينة';

  @override
  String get todayWorkoutDone => 'خلصت النهاردة 💪';

  @override
  String get todayKcalLeft => 'سعرة فاضلة';

  @override
  String get todayKcalOver => 'سعرة زيادة';

  @override
  String get todayAddCup => '+ كوباية ميه';

  @override
  String get todaySupplementsTitle => 'المكملات';

  @override
  String get todaySupplementsEmpty => 'مفيش مكملات متضافة.';

  @override
  String get todayWeightTitle => 'وزن الجسم';

  @override
  String get todayWeightEmpty => 'دوس عشان تسجل وزن النهاردة.';

  @override
  String todayWeightAvg(String avg) {
    return 'متوسط ٧ أيام $avg';
  }

  @override
  String get trkWaterTitle => 'المية';

  @override
  String get trkSupplementsTitle => 'المكملات';

  @override
  String get trkSleepTitle => 'النوم';

  @override
  String get trkWeightTitle => 'وزن الجسم';

  @override
  String get trkMeasurementsTitle => 'المقاسات';

  @override
  String get trkPhotosTitle => 'صور التقدم';

  @override
  String get trkHealthConnectTitle => 'Health Connect والخاتم';

  @override
  String get trkDate => 'التاريخ';

  @override
  String get trkHistory => 'السجل';

  @override
  String get trkLast7Days => 'آخر 7 أيام';

  @override
  String get trkInvalidNumber => 'اكتب رقم صحيح';

  @override
  String trkDeleteConfirm(String name) {
    return 'تمسح \"$name\"؟';
  }

  @override
  String get trkDeleted => 'اتمسح';

  @override
  String trkHoursMinutes(int h, int m) {
    return '$hس $mد';
  }

  @override
  String get trkSourceManual => 'يدوي';

  @override
  String get trkSourceHealthConnect => 'Health Connect';

  @override
  String get trkSyncNow => 'زامن دلوقتي';

  @override
  String get trkSyncing => 'بنزامن…';

  @override
  String get trkSyncDone => 'اتزامن';

  @override
  String get trkSyncFailed => 'المزامنة منفعتش — التسجيل اليدوي شغال عادي';

  @override
  String get trkTypeValue => 'اكتب الرقم';

  @override
  String get trkClear => 'امسح';

  @override
  String trkWaterProgress(int drunk, int goal) {
    return '$drunk / $goal مل';
  }

  @override
  String trkWaterRemaining(int ml) {
    return 'فاضل $ml مل النهارده';
  }

  @override
  String get trkWaterGoalReached => 'خلصت هدف النهارده. عاش!';

  @override
  String trkAddCup(int ml) {
    return 'كوباية · $ml مل';
  }

  @override
  String trkAddBottle(int ml) {
    return 'زجاجة · $ml مل';
  }

  @override
  String get trkAddCustom => 'كمية تانية';

  @override
  String get trkUndoLast => 'الغي آخر واحدة';

  @override
  String trkUndone(int ml) {
    return 'اتشال $ml مل';
  }

  @override
  String trkWaterAdded(int ml) {
    return '+$ml مل';
  }

  @override
  String get trkWaterSizes => 'حجم الكوباية والزجاجة';

  @override
  String get trkCupSize => 'حجم الكوباية (مل)';

  @override
  String get trkBottleSize => 'حجم الزجاجة (مل)';

  @override
  String get trkAmountMl => 'الكمية (مل)';

  @override
  String get trkTodayEntries => 'تسجيلات النهارده';

  @override
  String get trkNoWaterYet => 'لسه مسجلتش مية النهارده';

  @override
  String trkGoalLabel(int ml) {
    return 'الهدف $ml مل';
  }

  @override
  String get trkSuppToday => 'النهارده';

  @override
  String trkSuppTakenCount(int taken, int total) {
    return 'خدت $taken من $total';
  }

  @override
  String get trkSuppManage => 'مكملاتي';

  @override
  String get trkSuppAdd => 'ضيف مكمل';

  @override
  String get trkSuppEdit => 'عدّل المكمل';

  @override
  String get trkSuppName => 'الاسم';

  @override
  String get trkSuppDose => 'الجرعة (مثلاً 5 جم، سكوب)';

  @override
  String get trkSuppTiming => 'المعاد';

  @override
  String get trkTimingMorning => 'الصبح';

  @override
  String get trkTimingPreWorkout => 'قبل التمرين';

  @override
  String get trkTimingPostWorkout => 'بعد التمرين';

  @override
  String get trkTimingWithMeal => 'مع الأكل';

  @override
  String get trkTimingEvening => 'بالليل';

  @override
  String get trkTimingBedtime => 'قبل النوم';

  @override
  String get trkSuppPerServing =>
      'في الجرعة الواحدة (بتتحسب في ماكروز اليوم لما تعلّم عليها)';

  @override
  String get trkSuppProtein => 'بروتين (جم)';

  @override
  String get trkSuppCalories => 'سعرات (ك.سعر)';

  @override
  String get trkSuppCarbs => 'كارب (جم)';

  @override
  String get trkSuppFat => 'دهون (جم)';

  @override
  String get trkSuppActive => 'باخده';

  @override
  String get trkSuppPaused => 'موقفه';

  @override
  String get trkSuppEmpty => 'ضيف المكملات اللي بتاخدها وعلّم عليها كل يوم.';

  @override
  String get trkSuppImport => 'هات اللي في البروفايل';

  @override
  String trkSuppImported(int count) {
    return 'اتضاف $count';
  }

  @override
  String get trkSuppNote => 'تسجيل بس — الأبلكيشن مبيقترحش مكملات.';

  @override
  String get trkSuppNoneActive => 'مفيش مكملات شغالة';

  @override
  String get trkNameRequired => 'الاسم مطلوب';

  @override
  String trkSuppMacros(String protein, String calories) {
    return '$protein جم بروتين · $calories سعر';
  }

  @override
  String get trkSleepLastNight => 'ليلة امبارح';

  @override
  String get trkSleepNoData => 'مفيش نوم متسجل لليلة امبارح';

  @override
  String get trkSleepLog => 'سجّل نومك';

  @override
  String get trkSleepEdit => 'عدّل النوم';

  @override
  String get trkSleepHours => 'نمت كام ساعة';

  @override
  String get trkSleepQuality => 'الجودة';

  @override
  String get trkQuality1 => 'وحش جدًا';

  @override
  String get trkQuality2 => 'وحش';

  @override
  String get trkQuality3 => 'نص نص';

  @override
  String get trkQuality4 => 'كويس';

  @override
  String get trkQuality5 => 'ممتاز';

  @override
  String get trkBedTime => 'نمت الساعة';

  @override
  String get trkWakeTime => 'صحيت الساعة';

  @override
  String get trkSleepDate => 'صحيت يوم';

  @override
  String get trkOptionalTimes => 'مواعيد النوم والصحيان (اختياري)';

  @override
  String get trkStageDeep => 'عميق';

  @override
  String get trkStageRem => 'REM';

  @override
  String get trkStageLight => 'خفيف';

  @override
  String get trkStageAwake => 'صاحي';

  @override
  String trkSleepWeekAvg(String value) {
    return 'متوسط 7 أيام $value';
  }

  @override
  String trkSleepNeed(String value) {
    return 'احتياجك $value';
  }

  @override
  String get trkSleepConnectHint =>
      'اربط الخاتم عن طريق Health Connect عشان النوم ومراحله يتسجلوا لوحدهم.';

  @override
  String get trkSleepManualOverrides =>
      'التسجيل اليدوي بيحل مكان بيانات الخاتم لليلة دي.';

  @override
  String get trkSleepEmpty => 'لسه مفيش نوم متسجل.';

  @override
  String get trkRecoveryToday => 'الاستشفاء النهارده';

  @override
  String get trkRecoveryLow => 'واطي';

  @override
  String get trkRecoveryModerate => 'متوسط';

  @override
  String get trkRecoveryHigh => 'عالي';

  @override
  String trkRecoveryCalibrating(int days) {
    return 'لسه بنحسب متوسطك ($days/14 يوم)';
  }

  @override
  String get trkWeightLog => 'سجّل وزنك';

  @override
  String get trkWeightLatest => 'آخر وزن';

  @override
  String get trkWeightAvg7 => 'متوسط 7 أيام';

  @override
  String get trkWeightChange7 => 'عن الأسبوع اللي فات';

  @override
  String get trkWeightDaily => 'يومي';

  @override
  String get trkRange1M => 'شهر';

  @override
  String get trkRange3M => '3 شهور';

  @override
  String get trkRange1Y => 'سنة';

  @override
  String get trkRangeAll => 'الكل';

  @override
  String get trkWeightEmpty =>
      'اوزن نفسك كل يوم الصبح — متوسط الـ 7 أيام بيمسح التذبذب اليومي.';

  @override
  String trkWeightSaved(String kg) {
    return 'اتسجل $kg كجم';
  }

  @override
  String get trkWeightKg => 'الوزن (كجم)';

  @override
  String get trkNeedTwoPoints => 'سجّل كام يوم عشان الرسمة تظهر';

  @override
  String get trkMeasureWaist => 'الوسط';

  @override
  String get trkMeasureChest => 'الصدر';

  @override
  String get trkMeasureArm => 'الدراع';

  @override
  String get trkMeasureThigh => 'الفخد';

  @override
  String get trkMeasureNeck => 'الرقبة';

  @override
  String get trkMeasureHips => 'الأرداف';

  @override
  String get trkMeasureBodyFat => 'نسبة الدهون %';

  @override
  String get trkMeasureNew => 'مقاسات جديدة';

  @override
  String get trkMeasureEdit => 'عدّل المقاسات';

  @override
  String get trkMeasureDue =>
      'عدى أكتر من أسبوع على آخر مقاسات — قيس النهارده.';

  @override
  String get trkMeasureNone =>
      'لسه مفيش مقاسات — قيس مرة كل أسبوع في نفس المعاد.';

  @override
  String get trkMeasureTip =>
      'قيس الصبح قبل الأكل، والشريط مشدود من غير ما يضغط.';

  @override
  String get trkMeasureNeedOne => 'اكتب رقم واحد على الأقل';

  @override
  String trkLastMeasured(String date) {
    return 'آخر مرة: $date';
  }

  @override
  String get trkPhotosLocked => 'صور التقدم مقفولة';

  @override
  String get trkPhotosUnlock => 'افتح';

  @override
  String get trkPhotosAuthReason => 'افتح القفل عشان تشوف صور التقدم';

  @override
  String get trkPhotosAdd => 'ضيف صور';

  @override
  String get trkPhotosCompare => 'قارن';

  @override
  String get trkAngleFront => 'أمامي';

  @override
  String get trkAngleSide => 'جانبي';

  @override
  String get trkAngleBack => 'خلفي';

  @override
  String get trkCamera => 'الكاميرا';

  @override
  String get trkGallery => 'المعرض';

  @override
  String get trkPhotosEmpty =>
      'صوّر أمامي وجانبي وخلفي كل 2–4 أسابيع في نفس الإضاءة ونفس الوقفة.';

  @override
  String get trkPhotosPrivate =>
      'بتتحفظ جوه الأبلكيشن بس — مش في المعرض ومبتتبعتش للـ AI.';

  @override
  String get trkPhotoDeleteConfirm => 'تمسح الصورة دي؟';

  @override
  String get trkBefore => 'قبل';

  @override
  String get trkAfter => 'بعد';

  @override
  String get trkSideBySide => 'جنب بعض';

  @override
  String get trkSlider => 'سلايدر';

  @override
  String get trkNoPhotoForAngle => 'مفيش صورة للزاوية دي في اليوم ده';

  @override
  String get trkComparePickTwo =>
      'ضيف صور في يومين مختلفين على الأقل عشان تقارن.';

  @override
  String get trkPhotoSaved => 'الصورة اتحفظت';

  @override
  String get trkPhotoFailed => 'معرفناش نحفظ الصورة';

  @override
  String get trkPhotoMissing => 'ملف الصورة مش موجود';

  @override
  String trkPhotosForDate(String date) {
    return 'صور يوم $date';
  }

  @override
  String get trkDragToCompare => 'اسحب عشان تقارن';

  @override
  String get trkHcEnable => 'استخدم Health Connect';

  @override
  String get trkHcEnableSub =>
      'اقرا النوم والنبض والـ HRV والخطوات والسعرات اللي تطبيق الخاتم بيكتبها';

  @override
  String get trkHcStatus => 'الحالة';

  @override
  String get trkHcAvailable => 'Health Connect متسطب';

  @override
  String get trkHcNotInstalled => 'Health Connect مش متسطب';

  @override
  String get trkHcNeedsUpdate => 'Health Connect محتاج تحديث';

  @override
  String get trkHcUnsupported => 'Health Connect مش مدعوم على الموبايل ده';

  @override
  String get trkHcInstall => 'سطّب Health Connect';

  @override
  String get trkHcInstallHint =>
      'أندرويد 14 وأحدث موجود جواه (الإعدادات ← الأمان والخصوصية ← Health Connect). الموبايلات الأقدم نزّله من Play Store.';

  @override
  String get trkHcPermGranted => 'صلاحيات القراية متاحة';

  @override
  String get trkHcPermMissing => 'لسه مدتش صلاحيات القراية';

  @override
  String get trkHcGrant => 'ادي الصلاحيات';

  @override
  String get trkHcBgGranted => 'القراية في الخلفية مسموحة';

  @override
  String get trkHcBgMissing =>
      'القراية في الخلفية مش مسموحة (المزامنة بتحصل لما تفتح الأبلكيشن)';

  @override
  String get trkHcBgAllow => 'اسمح بالقراية في الخلفية';

  @override
  String trkHcLastSync(String time) {
    return 'آخر مزامنة: $time';
  }

  @override
  String get trkHcNeverSynced => 'لسه متزامنش';

  @override
  String trkHcOutcomeOk(int count) {
    return 'آخر مزامنة جابت $count قراية';
  }

  @override
  String get trkHcOutcomeNoPermission => 'آخر مزامنة: مفيش صلاحية قراية';

  @override
  String get trkHcOutcomeUnavailable => 'آخر مزامنة: Health Connect مش متاح';

  @override
  String get trkHcOutcomeError => 'آخر مزامنة فشلت';

  @override
  String get trkHcLastPulled => 'آخر بيانات اتسحبت';

  @override
  String get trkHcLastPulledSub =>
      'بص على التطبيق المصدر: لو تطبيق الخاتم ظاهر هنا بتواريخ جديدة يبقى بيكتب في Health Connect.';

  @override
  String get trkHcColType => 'البيان';

  @override
  String get trkHcColDate => 'التاريخ';

  @override
  String get trkHcColValue => 'القيمة';

  @override
  String get trkHcColSource => 'التطبيق المصدر';

  @override
  String get trkHcNothing => 'لسه مفيش';

  @override
  String get trkHcTypeSleep => 'جلسة نوم';

  @override
  String get trkHcTypeAsleep => 'نايم (من غير مرحلة)';

  @override
  String get trkHcTypeHr => 'النبض';

  @override
  String get trkHcTypeRhr => 'نبض الراحة';

  @override
  String get trkHcTypeHrv => 'HRV (RMSSD)';

  @override
  String get trkHcTypeSteps => 'الخطوات';

  @override
  String get trkHcTypeCalories => 'السعرات المحروقة';

  @override
  String trkHcSources(String apps) {
    return 'التطبيقات اللي بتكتب بيانات: $apps';
  }

  @override
  String get trkHcCardooTitle => 'بيانات الخاتم بتوصل؟';

  @override
  String get trkHcCardooBody =>
      'مش مؤكد إن تطبيق Cardoo بيكتب في Health Connect. افتح تطبيق Cardoo وفعّل المزامنة مع Health Connect لو موجودة، البس الخاتم ليلة، وبعدين دوس زامن دلوقتي وبص على الجدول تحت.';

  @override
  String get trkHcManualFallback =>
      'لو مفيش حاجة وصلت، IronMind هيستخدم اللي بتسجله بإيدك (النوم، الوزن…). مفيش حاجة هتبوظ.';

  @override
  String get trkHcEnabledToast => 'Health Connect اتفعّل';

  @override
  String get trkHcDisabledToast => 'Health Connect اتقفل — تسجيل يدوي بس';

  @override
  String get trkUnitBpm => 'نبضة/د';

  @override
  String get trkUnitMs => 'مللي ث';

  @override
  String get trkUnitSteps => 'خطوة';

  @override
  String get woAddCardio => 'ضيف كارديو';

  @override
  String get woAddExercise => 'ضيف تمرين';

  @override
  String get woApprovePlan => 'اعتمد الخطة';

  @override
  String get woAskCoach => 'اطلب تقييم المدرب';

  @override
  String get woBuildTemplate => 'اعمل خطة أساسية (من غير AI)';

  @override
  String get woCaloriesAuto => 'محسوبة تلقائي (MET) – تقدر تعدلها';

  @override
  String get woCardio => 'كارديو';

  @override
  String get woCardioBike => 'عجلة';

  @override
  String get woCardioElliptical => 'إليبتكال';

  @override
  String get woCardioJumpRope => 'نط الحبل';

  @override
  String get woCardioOther => 'حاجة تانية';

  @override
  String get woCardioRowing => 'تجديف';

  @override
  String get woCardioRun => 'جري';

  @override
  String get woCardioStairs => 'سلم';

  @override
  String get woCardioSwim => 'سباحة';

  @override
  String get woCardioTreadmill => 'تريدميل';

  @override
  String get woCardioWalk => 'مشي';

  @override
  String get woCoachEvaluation => 'تقييم المدرب';

  @override
  String get woCoachNeedsKey =>
      'ضيف مفتاح Claude API عشان المدرب يقيّم التمرينة دي.';

  @override
  String get woCoachQueued =>
      'مفيش نت – المدرب هيراجع التمرينة أول ما النت يرجع.';

  @override
  String get woCoachReviewing => 'المدرب بيراجع تمرينتك…';

  @override
  String get woContinueWorkout => 'كمّل التمرينة دي';

  @override
  String get woCooldown => 'الإطالة (Cool-down)';

  @override
  String get woCopyLast => 'انسخ اللي فات';

  @override
  String get woDeleteSession => 'امسح التمرينة';

  @override
  String get woDeleteSessionBody =>
      'كل الستات والكارديو والنوتس بتاعة التمرينة دي هتتمسح.';

  @override
  String get woDeleteSessionTitle => 'تمسح التمرينة دي؟';

  @override
  String get woDeleteSetTitle => 'تمسح الست ده؟';

  @override
  String get woDeloadActiveBody =>
      'أسبوع خفيف: الاقتراحات بـ 85% من أوزانك. ركّز على التكنيك والاستشفاء.';

  @override
  String get woDeloadActiveShort => 'أسبوع Deload – أوزان 85%';

  @override
  String woDeloadActiveTitle(int day) {
    return 'أسبوع Deload – يوم $day من 7';
  }

  @override
  String get woDeloadBadge => 'Deload';

  @override
  String get woDeloadDuePerformance =>
      'أرقامك (1RM المتوقع) نزلت في آخر أسبوعين – ده غالبًا إرهاق متراكم. أسبوع خفيف بـ 85% هيرجعك أقوى.';

  @override
  String woDeloadDueSchedule(int weeks) {
    return 'بقالك $weeks أسابيع بتتمرن تقيل. أسبوع خفيف بأوزان 85% هيساعدك تستشفى وتكمّل تقدم.';
  }

  @override
  String get woDeloadDueTitle => 'جه وقت أسبوع Deload؟';

  @override
  String woDeloadEvery(int weeks) {
    return 'Deload كل $weeks أسابيع';
  }

  @override
  String get woDiscard => 'الغيها';

  @override
  String get woDuration => 'المدة';

  @override
  String get woEditPlan => 'عدّل الخطة';

  @override
  String get woEndDeload => 'إنهاء';

  @override
  String woExerciseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تمرين',
      many: '$count تمرين',
      few: '$count تمارين',
      two: 'تمرينين',
      one: 'تمرين واحد',
      zero: 'مفيش تمارين',
    );
    return '$_temp0';
  }

  @override
  String get woExerciseInfo => 'تفاصيل التمرين';

  @override
  String get woExerciseNote => 'نوتة للتمرين';

  @override
  String get woExerciseNoteHint => 'مثلاً: الكتف بيوجع في النزول';

  @override
  String get woExercises => 'التمارين';

  @override
  String get woFinish => 'إنهاء';

  @override
  String get woFinishPartialBody =>
      'لسه في ستات من الخطة مخلصتش. التمرينة هتتسجل جزئية.';

  @override
  String get woFinishPartialTitle => 'تنهي برضه؟';

  @override
  String get woFinishWorkout => 'خلّص التمرينة';

  @override
  String get woFirstTime => 'أول مرة – مفيش مقارنة لسه';

  @override
  String get woFreeWorkout => 'تمرينة';

  @override
  String get woFreeWorkoutHint => 'ضيف تمارين من المكتبة وسجّل ستاتك.';

  @override
  String get woGenerateWithAi => 'ابني خطتي بالـ AI';

  @override
  String get woGeneratingPlan => 'بنبني خطتك… ممكن تاخد دقيقة.';

  @override
  String get woHistory => 'السجل';

  @override
  String get woIncline => 'الميل';

  @override
  String get woKmh => 'كم/س';

  @override
  String get woLastTime => 'المرة اللي فاتت';

  @override
  String get woLevel => 'المستوى';

  @override
  String get woLibrary => 'المكتبة';

  @override
  String get woMissedBody =>
      'اليوم ده اتفوّت. الجدول مش بيتغير – بس متفوّتش الجاي.';

  @override
  String get woNewRecords => 'أرقام قياسية جديدة';

  @override
  String get woNoExercises => 'مفيش تمارين لسه';

  @override
  String get woNoHistory => 'مفيش تمرينات لسه. تمريناتك هتظهر هنا.';

  @override
  String get woNoPlan =>
      'لسه معندكش خطة تمرين. ابنيها بالـ AI، أو ابدأ بخطة أساسية بتشتغل من غير نت.';

  @override
  String get woNotNow => 'مش دلوقتي';

  @override
  String get woNothingLoggedBody =>
      'مسجلتش ولا ست ولا كارديو. تلغي التمرينة دي؟';

  @override
  String get woNothingLoggedTitle => 'مفيش حاجة متسجلة';

  @override
  String get woNothingToCopy => 'مفيش ست قبله تنسخه';

  @override
  String get woPendingPlan => 'في خطة جديدة مستنية مراجعتك';

  @override
  String get woPickFromLibrary => 'اختار من المكتبة';

  @override
  String get woPlanApproved => 'الخطة اشتغلت 💪';

  @override
  String get woPlanNotFound => 'الخطة مش موجودة';

  @override
  String get woPlanTools => 'الخطة';

  @override
  String woPrBanner(String exercise, String types) {
    return 'رقم قياسي جديد! $exercise: $types';
  }

  @override
  String get woPrE1rm => 'أعلى 1RM';

  @override
  String get woPrReps => 'أعلى عدات';

  @override
  String get woPrWeight => 'أتقل وزن';

  @override
  String get woPrs => 'أرقام قياسية';

  @override
  String get woReasonAddReps => 'نفس الوزن – حاول تزوّد عدة.';

  @override
  String get woReasonDeload => 'Deload: 85% من المرة اللي فاتت.';

  @override
  String get woReasonFirstTime => 'أول مرة – اختار وزن تقدر تلعبه بفورم سليم.';

  @override
  String get woReasonIncrease =>
      'وصلت لآخر نطاق العدات المرة اللي فاتت – زوّد الوزن.';

  @override
  String get woReasonReduce => 'تمرينتين صعبين ورا بعض – نزّل الوزن شوية.';

  @override
  String get woReasonRepeat => 'كرر أرقام المرة اللي فاتت بفورم نضيف.';

  @override
  String get woRecoveryAdjusted => 'متعدل للاستشفاء';

  @override
  String woRecoveryPill(int pct, int sets) {
    return 'استشفاء واطي: −$pct% وزن، −$sets ست';
  }

  @override
  String get woRegenerate => 'ابني الخطة من جديد بالـ AI';

  @override
  String get woRegenerateBody =>
      'الـ AI هيبني خطة جديدة تراجعها. خطتك الحالية هتفضل شغالة لحد ما تعتمد الجديدة.';

  @override
  String get woRegenerateTitle => 'تبني خطتك من جديد؟';

  @override
  String get woRemoveExerciseTitle => 'تشيل التمرين ده؟';

  @override
  String get woRepMax => 'أقصى عدات';

  @override
  String get woRepMin => 'أقل عدات';

  @override
  String get woReps => 'العدات';

  @override
  String get woRest => 'راحة';

  @override
  String get woRestDay => 'يوم راحة';

  @override
  String get woRestDayBody =>
      'استشفى النهاردة: نام كويس، كُل البروتين بتاعك، وممكن تمشي شوية.';

  @override
  String get woRestDoneBody => 'الراحة خلصت – يلا الست اللي بعده!';

  @override
  String get woRestDoneTitle => 'تايمر الراحة';

  @override
  String get woRestSeconds => 'الراحة (ثانية)';

  @override
  String get woRestTimer => 'راحة';

  @override
  String get woResumeWorkout => 'كمّل التمرينة';

  @override
  String get woReviewHint =>
      'عدّل اللي انت عايزه (دوس للتعديل، اسحب لتغيير الترتيب)، وبعدين اعتمد.';

  @override
  String get woReviewPlan => 'راجع خطتك';

  @override
  String get woSaveSet => 'احفظ الست';

  @override
  String get woSessionNotFound => 'التمرينة مش موجودة';

  @override
  String get woSessionNotes => 'نوتة التمرينة';

  @override
  String get woSessionNotesHint => 'كانت عاملة إزاي؟ في حاجة عايز تفتكرها؟';

  @override
  String get woSetTypeDrop => 'دروب ست';

  @override
  String get woSetTypeFailure => 'لحد الفشل';

  @override
  String get woSetTypeNormal => 'عادي';

  @override
  String get woSetTypeWarmup => 'إحمائي';

  @override
  String get woSets => 'الستات';

  @override
  String woSetsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ست',
      few: '$count ستات',
      two: 'ستين',
      one: 'ست واحد',
    );
    return '$_temp0';
  }

  @override
  String get woSourceAi => 'AI';

  @override
  String get woSourceTemplate => 'أساسية';

  @override
  String get woSpeed => 'السرعة';

  @override
  String get woStartDeload => 'ابدأ أسبوع Deload';

  @override
  String get woStartEmpty => 'ابدأ تمرينة فاضية';

  @override
  String get woStartThisWorkout => 'العب التمرينة دي دلوقتي';

  @override
  String get woStartToday => 'ابدأ تمرينة النهاردة';

  @override
  String get woStatusCompleted => 'كاملة';

  @override
  String get woStatusInProgress => 'شغالة';

  @override
  String get woStatusMissed => 'غياب';

  @override
  String get woStatusPartial => 'جزئية';

  @override
  String get woSubstitute => 'بديل';

  @override
  String get woSubstituteAi => 'اقتراحات الـ AI';

  @override
  String get woSubstituteAlways => 'دايمًا';

  @override
  String get woSubstituteLocal => 'تمارين شبهه';

  @override
  String get woSubstituteNone => 'ملقيناش بدايل';

  @override
  String get woSubstituteOnce => 'للتمرينة دي بس';

  @override
  String get woSubstituteTitle => 'بدّل التمرين';

  @override
  String get woSubstituted => 'متبدّل';

  @override
  String get woSummaryTitle => 'ملخص التمرينة';

  @override
  String get woSwap => 'بدّل';

  @override
  String get woTargetRpe => 'RPE المستهدف';

  @override
  String get woTemplateBody =>
      'هتتعمل خطة أساسية جديدة تراجعها. خطتك الحالية هتفضل شغالة لحد ما تعتمد الجديدة.';

  @override
  String get woTemplateTitle => 'تعمل خطة أساسية؟';

  @override
  String get woTodayTitle => 'النهاردة';

  @override
  String get woTotalVolume => 'الحجم الكلي';

  @override
  String get woTry => 'جرّب';

  @override
  String get woViewSummary => 'شوف الملخص';

  @override
  String get woVoiceConfirm => 'تحفظ الست ده؟';

  @override
  String get woVoiceExample => 'قول مثلاً \"80 كيلو 10 عدات\"';

  @override
  String get woVoiceHint =>
      'جرّب تقول الوزن وبعدين العدات، مثلاً \"80 كيلو 10 عدات\".';

  @override
  String get woVoiceNotUnderstood => 'مفهمتش';

  @override
  String get woVoiceParsing => 'بفهم…';

  @override
  String get woVoiceTitle => 'بسمعك…';

  @override
  String get woVoiceUnavailable => 'التعرف على الصوت مش متاح على الموبايل ده.';

  @override
  String get woVolume => 'الحجم';

  @override
  String woVsLastTime(String best, String volume) {
    return 'المرة اللي فاتت: أحسن ست $best · الحجم $volume كجم';
  }

  @override
  String get woWarmup => 'الإحماء';

  @override
  String get woWeeklyPlan => 'الخطة';

  @override
  String get woWeightKg => 'الوزن (كجم)';

  @override
  String get woWorkingSets => 'ستات أساسية';

  @override
  String get woWorkout => 'تمرينة';
}
