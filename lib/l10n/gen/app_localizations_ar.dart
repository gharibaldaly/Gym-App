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
  String get onbBuildWorkoutLater => 'تقدر تعملها بعدين من تاب التمرين.';

  @override
  String get onbBuildMealsLater => 'تقدر تعملها بعدين من تاب الأكل.';

  @override
  String get onbBuildNoKey =>
      'خطط الـ AI محتاجة مفتاح Claude API. سعراتك والماكروز جاهزين؛ ضيف المفتاح بعدين من الإعدادات واعمل الخطط من تاب التمرين وتاب الأكل.';

  @override
  String get onbBuildOffline =>
      'مفيش نت دلوقتي. سعراتك والماكروز جاهزين؛ اعمل خطط الـ AI من تاب التمرين وتاب الأكل لما النت يرجع.';

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
}
