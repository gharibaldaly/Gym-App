import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/providers.dart';
import 'exercise_labels.dart';

/// Bump when the bundled seed data (or the derivation logic) changes so the
/// library is re-upserted on next start. Favorites and custom exercises survive.
const int kExerciseSeedVersion = 1;

const String kExerciseSeedAsset = 'assets/data/free-exercise-db.json';

/// Arabic content files written separately (any may be missing).
const List<String> kExerciseArabicAssets = [
  'assets/data/exercises_ar_1.json',
  'assets/data/exercises_ar_2.json',
  'assets/data/exercises_ar_3.json',
  'assets/data/exercises_ar_4.json',
];

/// Loads the exercise seed into the DB on first run / when the seed version changes
/// (or when the library is empty, e.g. after a restore of an empty DB).
Future<void> seedExercisesIfNeeded(AppDatabase db, SharedPreferences prefs, {AssetBundle? bundle}) async {
  final stored = prefs.getInt(SettingsKeys.seedVersion);
  if (stored == kExerciseSeedVersion && await _seedCount(db) > 0) return;

  final sw = Stopwatch()..start();
  final b = bundle ?? rootBundle;
  final raw = jsonDecode(await b.loadString(kExerciseSeedAsset)) as List;
  final ar = <String, ArabicExerciseContent>{};
  for (final path in kExerciseArabicAssets) {
    try {
      ar.addAll(parseArabicContent(await b.loadString(path)));
    } catch (_) {
      // File not bundled yet or malformed: fall back to the glossary / English.
    }
  }
  final rows = buildSeedCompanions(raw, ar);
  await applySeed(db, rows);
  await prefs.setInt(SettingsKeys.seedVersion, kExerciseSeedVersion);
  debugPrint('exercise seed: ${rows.length} exercises (${ar.length} with Arabic content) in ${sw.elapsedMilliseconds} ms');
}

Future<int> _seedCount(AppDatabase db) async {
  final c = db.exercises.id.count();
  final q = db.selectOnly(db.exercises)
    ..addColumns([c])
    ..where(db.exercises.isCustom.equals(false));
  return (await q.map((r) => r.read(c)).getSingle()) ?? 0;
}

/// Upserts [rows] in one batch. Only seed columns are written on conflict, so
/// isFavorite / isCustom / mediaPath / createdAt of existing rows are untouched.
Future<void> applySeed(AppDatabase db, List<ExercisesCompanion> rows) async {
  await db.batch((batch) => batch.insertAllOnConflictUpdate(db.exercises, rows));
}

/// Arabic content for one exercise, keyed by exercise id in the content files.
class ArabicExerciseContent {
  final String? nameAr;
  final List<String> instructionsAr;
  final List<String> mistakesEn;
  final List<String> mistakesAr;
  const ArabicExerciseContent({
    this.nameAr,
    this.instructionsAr = const [],
    this.mistakesEn = const [],
    this.mistakesAr = const [],
  });
}

List<String> _strList(Object? v) =>
    v is List ? v.whereType<String>().map((s) => s.trim()).where((s) => s.isNotEmpty).toList() : const [];

/// Parses an `exercises_ar_N.json` file: `{ "<id>": {nameAr, instructionsAr[], mistakesEn[], mistakesAr[]} }`.
/// Invalid entries are skipped; a non-object root yields an empty map.
Map<String, ArabicExerciseContent> parseArabicContent(String source) {
  final decoded = jsonDecode(source);
  if (decoded is! Map) return {};
  final out = <String, ArabicExerciseContent>{};
  decoded.forEach((k, v) {
    if (k is! String || v is! Map) return;
    final name = v['nameAr'];
    out[k] = ArabicExerciseContent(
      nameAr: name is String && name.trim().isNotEmpty ? name.trim() : null,
      instructionsAr: _strList(v['instructionsAr']),
      mistakesEn: _strList(v['mistakesEn']),
      mistakesAr: _strList(v['mistakesAr']),
    );
  });
  return out;
}

/// Builds DB rows from the raw free-exercise-db list merged with Arabic content.
List<ExercisesCompanion> buildSeedCompanions(List raw, Map<String, ArabicExerciseContent> ar) {
  final rows = <ExercisesCompanion>[];
  for (final item in raw) {
    if (item is! Map) continue;
    final id = item['id'];
    final nameEn = item['name'];
    if (id is! String || nameEn is! String || id.isEmpty) continue;
    final a = ar[id];
    final primary = _muscles(item['primaryMuscles']);
    final secondary = _muscles(item['secondaryMuscles']).where((m) => !primary.contains(m)).toList();
    final category = item['category'] as String?;
    final force = item['force'] as String?;
    final equipment = (item['equipment'] as String?) ?? (category == 'stretching' ? 'body only' : 'other');
    rows.add(ExercisesCompanion(
      id: Value(id),
      nameEn: Value(nameEn.trim()),
      nameAr: Value(a?.nameAr ?? autoArabicName(nameEn) ?? nameEn.trim()),
      primaryMusclesJson: Value(jsonEncode(primary)),
      secondaryMusclesJson: Value(jsonEncode(secondary)),
      equipment: Value(equipment),
      force: Value(force),
      movementPattern: Value(deriveMovementPattern(
        force: force,
        category: category,
        primary: primary,
        secondary: secondary,
      )),
      mechanic: Value(item['mechanic'] as String?),
      category: Value(category),
      level: Value(item['level'] as String?),
      instructionsEnJson: Value(jsonEncode(_strList(item['instructions']))),
      instructionsArJson: Value(jsonEncode(a?.instructionsAr ?? const <String>[])),
      mistakesEnJson: Value(jsonEncode(a?.mistakesEn ?? const <String>[])),
      mistakesArJson: Value(jsonEncode(a?.mistakesAr ?? const <String>[])),
      imagesJson: Value(jsonEncode(_strList(item['images']))),
    ));
  }
  return rows;
}

List<String> _muscles(Object? v) {
  final out = <String>[];
  for (final m in _strList(v)) {
    final id = normalizeMuscle(m);
    if (id != null && !out.contains(id)) out.add(id);
  }
  return out;
}

/// push / pull / legs / core / cardio / stretch / olympic from the free-exercise-db fields.
String deriveMovementPattern({
  String? force,
  String? category,
  required List<String> primary,
  List<String> secondary = const [],
}) {
  switch (category) {
    case 'stretching':
      return 'stretch';
    case 'cardio':
      return 'cardio';
    case 'olympic weightlifting':
      return 'olympic';
  }
  if (primary.any(kLowerBodyMuscles.contains)) return 'legs';
  if (primary.contains('abdominals')) return 'core';
  final p = primary.isEmpty ? null : primary.first;
  if (p == 'lower back') return force == 'static' ? 'core' : 'pull';
  if (force == 'push') return 'push';
  if (force == 'pull') return 'pull';
  if (p != null && kPushMuscles.contains(p)) return 'push';
  if (p != null && kPullMuscles.contains(p)) return 'pull';
  if (category == 'plyometrics') return 'cardio';
  return 'core';
}

// ---------------------------------------------------------------------------
// Glossary-based Arabic name fallback (used only when no curated Arabic name).
// Egyptian gyms mostly use transliterated English names, so main words are
// transliterated in English order and modifiers (equipment, position, grip)
// are moved to an Arabic suffix: "Incline Dumbbell Press" → "إنكلاين بريس بالدمبل".
// ---------------------------------------------------------------------------

const Map<String, String> _arPhrases = {
  'bench press': 'بنش بريس',
  'front squat': 'فرونت سكوات',
  'leg press': 'ليج بريس',
  'leg extension': 'رجل أمامي',
  'leg extensions': 'رجل أمامي',
  'leg curl': 'رجل خلفي',
  'leg curls': 'رجل خلفي',
  'lateral raise': 'رفرفة جانبي',
  'lateral raises': 'رفرفة جانبي',
  'side lateral raise': 'رفرفة جانبي',
  'front raise': 'رفرفة أمامي',
  'front raises': 'رفرفة أمامي',
  'rear delt raise': 'رفرفة خلفي',
  'rear delt fly': 'رفرفة خلفي',
  'calf raise': 'سمانة',
  'calf raises': 'سمانة',
  'calf press': 'سمانة بريس',
  'push up': 'ضغط',
  'push ups': 'ضغط',
  'pushup': 'ضغط',
  'pushups': 'ضغط',
  'pull up': 'عقلة',
  'pull ups': 'عقلة',
  'pullups': 'عقلة',
  'chin up': 'عقلة قبضة عكسية',
  'chin ups': 'عقلة قبضة عكسية',
  'sit up': 'سيت أب',
  'sit ups': 'سيت أب',
  'lat pulldown': 'سحب عالي',
  'pulldown': 'سحب عالي',
  'pulldowns': 'سحب عالي',
  'romanian deadlift': 'ديدلفت روماني',
  'stiff legged deadlift': 'ديدلفت رجل مفرودة',
  'stiff leg deadlift': 'ديدلفت رجل مفرودة',
  'good morning': 'جود مورنينج',
  'good mornings': 'جود مورنينج',
  'hip thrust': 'هيب ثرست',
  'glute bridge': 'جلوت بريدج',
  'face pull': 'فيس بول',
  'skull crusher': 'سكال كراشر',
  'skullcrusher': 'سكال كراشر',
  'hammer curl': 'هامر كيرل',
  'hammer curls': 'هامر كيرل',
  'preacher curl': 'بريتشر كيرل',
  'concentration curls': 'كونسنتريشن كيرل',
  'shoulder press': 'ضغط كتف',
  'military press': 'ميليتري بريس',
  'overhead press': 'ضغط فوق الراس',
  'upright row': 'أبرايت رو',
  'upright rows': 'أبرايت رو',
  'bent over': 'منحني',
  't bar': 'تي بار',
  'close grip': 'قبضة ضيقة',
  'wide grip': 'قبضة واسعة',
  'reverse grip': 'قبضة عكسية',
  'neutral grip': 'قبضة محايدة',
  'one arm': 'بدراع واحدة',
  'single arm': 'بدراع واحدة',
  'one leg': 'برجل واحدة',
  'single leg': 'برجل واحدة',
  'two arm': 'بالدراعين',
  'smith machine': 'على السميث',
  'medicine ball': 'بالكورة الطبية',
  'exercise ball': 'على الكورة السويسري',
  'stability ball': 'على الكورة السويسري',
  'ez bar': 'بالبار الزجزاج',
  'e z bar': 'بالبار الزجزاج',
  'ez curl bar': 'بالبار الزجزاج',
  'jump rope': 'نط الحبل',
  'mountain climbers': 'ماونتن كلايمبرز',
  'farmer s walk': 'مشية الفلاح',
  'russian twist': 'رشن تويست',
  'kettlebell swing': 'كيتل بل سوينج',
  'hanging leg raise': 'رفع رجل وانت متعلق',
  'leg raise': 'رفع رجل',
  'leg raises': 'رفع رجل',
  'clean and jerk': 'كلين آند جيرك',
  'clean and press': 'كلين آند بريس',
  'palms up': 'الكف لفوق',
  'palms down': 'الكف لتحت',
  'behind the neck': 'ورا الرقبة',
  'behind neck': 'ورا الرقبة',
};

/// Modifiers moved to the end of the Arabic name.
const Set<String> _arSuffixKeys = {
  'close grip',
  'wide grip',
  'reverse grip',
  'neutral grip',
  'one arm',
  'single arm',
  'one leg',
  'single leg',
  'two arm',
  'smith machine',
  'medicine ball',
  'exercise ball',
  'stability ball',
  'ez bar',
  'e z bar',
  'ez curl bar',
  'palms up',
  'palms down',
  'behind the neck',
  'behind neck',
  'dumbbell',
  'dumbbells',
  'barbell',
  'cable',
  'cables',
  'kettlebell',
  'kettlebells',
  'machine',
  'band',
  'bands',
  'smith',
  'plate',
  'chains',
  'weighted',
  'standing',
  'seated',
  'lying',
  'kneeling',
  'alternating',
  'alternate',
  'leverage',
  'rope',
  'pulley',
  'smr',
  'bodyweight',
  'floor',
  'ball',
  'sled',
  'box',
  'bar',
};

const Map<String, String> _arWords = {
  // equipment / modifiers (suffix)
  'dumbbell': 'بالدمبل',
  'dumbbells': 'بالدمبل',
  'barbell': 'بالبار',
  'bar': 'بالبار',
  'cable': 'بالكابل',
  'cables': 'بالكابل',
  'kettlebell': 'بالكيتل بل',
  'kettlebells': 'بالكيتل بل',
  'machine': 'على الماكينة',
  'band': 'بالأستيك',
  'bands': 'بالأستيك',
  'smith': 'على السميث',
  'plate': 'بالطارة',
  'chains': 'بالجنازير',
  'weighted': 'بوزن إضافي',
  'standing': 'واقف',
  'seated': 'قاعد',
  'lying': 'نايم',
  'kneeling': 'على الركبة',
  'alternating': 'بالتبادل',
  'alternate': 'بالتبادل',
  'leverage': 'على ماكينة ليفريدج',
  'rope': 'بالحبل',
  'pulley': 'بالكابل',
  'smr': 'مساج بالفوم رولر',
  'bodyweight': 'بوزن الجسم',
  'floor': 'على الأرض',
  'ball': 'بالكورة',
  'sled': 'بالزلاجة',
  'box': 'على البوكس',
  // movements
  'press': 'بريس',
  'presses': 'بريس',
  'curl': 'كيرل',
  'curls': 'كيرل',
  'squat': 'سكوات',
  'squats': 'سكوات',
  'raise': 'رفع',
  'raises': 'رفع',
  'stretch': 'إطالة',
  'row': 'رو',
  'rows': 'رو',
  'extension': 'إكستنشن',
  'extensions': 'إكستنشن',
  'deadlift': 'ديدلفت',
  'deadlifts': 'ديدلفت',
  'clean': 'كلين',
  'crunch': 'كرانش',
  'crunches': 'كرانش',
  'jump': 'نط',
  'jumps': 'نط',
  'snatch': 'سناتش',
  'jerk': 'جيرك',
  'shrug': 'شراج',
  'shrugs': 'شراج',
  'lunge': 'لانج',
  'lunges': 'لانج',
  'fly': 'تفتيح',
  'flye': 'تفتيح',
  'flyes': 'تفتيح',
  'flys': 'تفتيح',
  'crossover': 'كروس أوفر',
  'pullover': 'بول أوفر',
  'pushdown': 'بوش داون',
  'kickback': 'كيك باك',
  'kickbacks': 'كيك باك',
  'dip': 'ديبس',
  'dips': 'ديبس',
  'bridge': 'بريدج',
  'plank': 'بلانك',
  'twist': 'تويست',
  'twists': 'تويست',
  'rotation': 'لف',
  'circles': 'دوائر',
  'throw': 'رمي',
  'slam': 'خبط',
  'swing': 'سوينج',
  'swings': 'سوينج',
  'walk': 'مشي',
  'walking': 'مشي',
  'run': 'جري',
  'running': 'جري',
  'sprint': 'سبرينت',
  'sprints': 'سبرينت',
  'hop': 'نطة',
  'hops': 'نطات',
  'step': 'ستيب',
  'rollout': 'رول أوت',
  'hyperextension': 'هايبر إكستنشن',
  'hyperextensions': 'هايبر إكستنشن',
  'thrust': 'ثرست',
  'drag': 'سحب',
  'pull': 'سحب',
  'push': 'دفع',
  'lift': 'رفع',
  'hold': 'ثبات',
  'flexion': 'ثني',
  'abduction': 'تبعيد',
  'adduction': 'تقريب',
  'windmill': 'ويندميل',
  'bicycling': 'عجلة',
  'bike': 'عجلة',
  'treadmill': 'مشاية',
  'elliptical': 'أوبتكال',
  'rowing': 'تجديف',
  // body parts
  'arm': 'دراع',
  'arms': 'دراعات',
  'leg': 'رجل',
  'legs': 'رجلين',
  'triceps': 'تراي',
  'tricep': 'تراي',
  'biceps': 'باي',
  'bicep': 'باي',
  'chest': 'صدر',
  'shoulder': 'كتف',
  'shoulders': 'كتف',
  'calf': 'سمانة',
  'calves': 'سمانة',
  'back': 'ضهر',
  'wrist': 'رسغ',
  'hip': 'حوض',
  'hips': 'حوض',
  'hamstring': 'خلفية',
  'hamstrings': 'خلفية',
  'neck': 'رقبة',
  'glute': 'جلوت',
  'glutes': 'جلوت',
  'quad': 'أمامية',
  'quads': 'أمامية',
  'quadriceps': 'أمامية',
  'delt': 'كتف',
  'deltoid': 'كتف',
  'knee': 'ركبة',
  'knees': 'ركب',
  'ab': 'بطن',
  'abs': 'بطن',
  'lat': 'لاتس',
  'lats': 'لاتس',
  'groin': 'داخل الفخذ',
  'adductor': 'داخل الفخذ',
  'oblique': 'جوانب البطن',
  'head': 'راس',
  'ankle': 'كاحل',
  'thigh': 'فخذ',
  'forearm': 'ساعد',
  // descriptors
  'incline': 'إنكلاين',
  'decline': 'ديكلاين',
  'flat': 'فلات',
  'reverse': 'عكسي',
  'side': 'جانبي',
  'lateral': 'جانبي',
  'front': 'أمامي',
  'rear': 'خلفي',
  'overhead': 'فوق الراس',
  'over': 'أوفر',
  'up': 'أب',
  'ups': 'أب',
  'down': 'داون',
  'upright': 'أبرايت',
  'bent': 'منحني',
  'close': 'ضيق',
  'wide': 'واسع',
  'narrow': 'ضيق',
  'single': 'فردي',
  'one': 'واحد',
  'two': 'اتنين',
  'double': 'دبل',
  'split': 'سبليت',
  'sumo': 'سومو',
  'hang': 'هانج',
  'hanging': 'متعلق',
  'power': 'باور',
  'high': 'عالي',
  'low': 'واطي',
  'straight': 'مفرود',
  'stiff': 'مفرود',
  'legged': '',
  'goblet': 'جوبلت',
  'hack': 'هاك',
  'preacher': 'بريتشر',
  'hammer': 'هامر',
  'concentration': 'كونسنتريشن',
  'arnold': 'أرنولد',
  'zottman': 'زوتمان',
  'landmine': 'لاندماين',
  'pallof': 'بالوف',
  'jm': 'JM',
  'military': 'ميليتري',
  'upper': 'علوي',
  'lower': 'سفلي',
  'inner': 'داخلي',
  'external': 'خارجي',
  'internal': 'داخلي',
  'isometric': 'ثابت',
  'dynamic': 'ديناميك',
  'elevated': 'مرفوع',
  'deficit': 'ديفيسيت',
  'pause': 'بوقفة',
  'partial': 'جزئي',
  'full': 'كامل',
  'quick': 'سريع',
  'fast': 'سريع',
  'heavy': 'تقيل',
  'speed': 'سرعة',
  'grip': 'قبضة',
  'stance': 'وقفة',
  'wall': 'حيطة',
  'chair': 'كرسي',
  'bench': 'بنش',
  'mid': 'نص',
  'middle': 'نص',
  'cross': 'كروس',
  'and': 'و',
  'or': 'أو',
  'from': 'من',
  'behind': 'ورا',
  'around': 'حوالين',
  'through': 'من بين',
  'against': 'على',
  'suspended': 'معلق',
  'prone': 'على البطن',
  'supine': 'على الضهر',
  'balance': 'توازن',
  'long': 'طويل',
  'depth': 'عمق',
  'kick': 'كيك',
  'palm': 'كف',
  'blocks': 'بلوكات',
  'butt': 'مؤخرة',
  'chin': 'دقن',
  'attachment': '',
  'body': 'الجسم',
  'iron': 'حديد',
  'cross body': 'كروس بودي',
  'flexor': 'فليكسور',
  'ham': 'خلفية',
};

const Set<String> _arSkip = {'with', 'the', 'a', 'an', 'on', 'of', 'to', 'in', 'your', 'version', 'exercise', 'at', 's'};

/// Glossary translation of an English exercise name; null when any significant
/// word is unknown (caller then keeps the English name).
String? autoArabicName(String nameEn) {
  final norm = nameEn.toLowerCase().replaceAll(RegExp(r"[^a-z0-9]+"), ' ').trim();
  if (norm.isEmpty) return null;
  final tokens = norm.split(RegExp(r'\s+'));
  final main = <String>[];
  final suffix = <String>[];
  var i = 0;
  outer:
  while (i < tokens.length) {
    for (var len = 4; len >= 1; len--) {
      if (i + len > tokens.length) continue;
      final key = tokens.sublist(i, i + len).join(' ');
      final phrase = _arPhrases[key] ?? _arWords[key];
      if (phrase != null) {
        if (phrase.isNotEmpty) {
          (_arSuffixKeys.contains(key) ? suffix : main).add(phrase);
        }
        i += len;
        continue outer;
      }
    }
    final t = tokens[i];
    if (_arSkip.contains(t)) {
      i++;
      continue;
    }
    if (RegExp(r'^\d+$').hasMatch(t)) {
      main.add(t);
      i++;
      continue;
    }
    return null;
  }
  // Arabic puts the action first for stretches: "Quad Stretch" → "إطالة أمامية".
  const lead = 'إطالة';
  if (main.length > 1 && main.contains(lead)) {
    main
      ..remove(lead)
      ..insert(0, lead);
  }
  final parts = <String>[...main];
  for (final s in suffix) {
    if (!parts.contains(s)) parts.add(s);
  }
  if (main.isEmpty) return suffix.isEmpty ? null : suffix.join(' ');
  return parts.join(' ');
}
