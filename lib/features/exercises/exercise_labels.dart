/// Canonical vocabularies for the exercise library (shared by every feature).
///
/// Muscle ids follow the free-exercise-db vocabulary and are the canonical
/// muscle id set for the whole app (plans, volume charts, body map, AI schemas).
library;

/// Canonical muscle ids.
const List<String> kMuscles = [
  'abdominals',
  'abductors',
  'adductors',
  'biceps',
  'calves',
  'chest',
  'forearms',
  'glutes',
  'hamstrings',
  'lats',
  'lower back',
  'middle back',
  'neck',
  'quadriceps',
  'shoulders',
  'traps',
  'triceps',
];

/// Canonical equipment ids (free-exercise-db vocabulary).
const List<String> kEquipment = [
  'barbell',
  'dumbbell',
  'cable',
  'machine',
  'body only',
  'kettlebells',
  'bands',
  'e-z curl bar',
  'medicine ball',
  'exercise ball',
  'foam roll',
  'other',
];

/// Movement patterns derived at seed time (see `deriveMovementPattern`).
const List<String> kMovementPatterns = ['push', 'pull', 'legs', 'core', 'cardio', 'stretch', 'olympic'];

const List<String> kForces = ['push', 'pull', 'static'];
const List<String> kMechanics = ['compound', 'isolation'];
const List<String> kCategories = [
  'strength',
  'stretching',
  'plyometrics',
  'powerlifting',
  'olympic weightlifting',
  'strongman',
  'cardio',
];

/// Lower-body muscles (used for movement-pattern derivation and filters).
const Set<String> kLowerBodyMuscles = {'quadriceps', 'hamstrings', 'glutes', 'calves', 'adductors', 'abductors'};

/// Rough muscle grouping for UI sections ("upper push", "upper pull", …).
const Set<String> kPushMuscles = {'chest', 'shoulders', 'triceps'};
const Set<String> kPullMuscles = {'lats', 'middle back', 'biceps', 'traps', 'forearms', 'lower back', 'neck'};

const Map<String, (String ar, String en)> _muscleLabels = {
  'abdominals': ('البطن', 'Abs'),
  'abductors': ('الأبدكتور (خارج الفخذ)', 'Abductors'),
  'adductors': ('الأدكتور (داخل الفخذ)', 'Adductors'),
  'biceps': ('الباي', 'Biceps'),
  'calves': ('السمانة', 'Calves'),
  'chest': ('الصدر', 'Chest'),
  'forearms': ('السواعد', 'Forearms'),
  'glutes': ('الجلوتس (المؤخرة)', 'Glutes'),
  'hamstrings': ('الخلفية', 'Hamstrings'),
  'lats': ('المجنص (اللاتس)', 'Lats'),
  'lower back': ('أسفل الضهر', 'Lower back'),
  'middle back': ('نص الضهر', 'Middle back'),
  'neck': ('الرقبة', 'Neck'),
  'quadriceps': ('الأمامية', 'Quads'),
  'shoulders': ('الكتف', 'Shoulders'),
  'traps': ('الترابيس', 'Traps'),
  'triceps': ('التراي', 'Triceps'),
};

const Map<String, (String ar, String en)> _equipmentLabels = {
  'barbell': ('بار', 'Barbell'),
  'dumbbell': ('دمبل', 'Dumbbell'),
  'cable': ('كابل', 'Cable'),
  'machine': ('ماكينة', 'Machine'),
  'body only': ('وزن الجسم', 'Bodyweight'),
  'kettlebells': ('كيتل بل', 'Kettlebell'),
  'bands': ('أستيك مقاومة', 'Bands'),
  'e-z curl bar': ('بار زجزاج', 'EZ bar'),
  'medicine ball': ('كورة طبية', 'Medicine ball'),
  'exercise ball': ('كورة سويسري', 'Exercise ball'),
  'foam roll': ('فوم رولر', 'Foam roller'),
  'other': ('أداة تانية', 'Other'),
};

const Map<String, (String ar, String en)> _patternLabels = {
  'push': ('دفع', 'Push'),
  'pull': ('سحب', 'Pull'),
  'legs': ('رجل', 'Legs'),
  'core': ('بطن وجذع', 'Core'),
  'cardio': ('كارديو', 'Cardio'),
  'stretch': ('إطالة', 'Stretch'),
  'olympic': ('أوليمبي', 'Olympic'),
  'carry': ('حمل ومشي', 'Carry'),
};

const Map<String, (String ar, String en)> _mechanicLabels = {
  'compound': ('مركب', 'Compound'),
  'isolation': ('عزل', 'Isolation'),
};

const Map<String, (String ar, String en)> _forceLabels = {
  'push': ('دفع', 'Push'),
  'pull': ('سحب', 'Pull'),
  'static': ('ثابت', 'Static'),
};

const Map<String, (String ar, String en)> _categoryLabels = {
  'strength': ('قوة', 'Strength'),
  'stretching': ('إطالة', 'Stretching'),
  'plyometrics': ('بليومتركس (نط)', 'Plyometrics'),
  'powerlifting': ('باورليفتنج', 'Powerlifting'),
  'olympic weightlifting': ('رفع أثقال أوليمبي', 'Olympic weightlifting'),
  'strongman': ('سترونج مان', 'Strongman'),
  'cardio': ('كارديو', 'Cardio'),
};

const Map<String, (String ar, String en)> _levelLabels = {
  'beginner': ('مبتدئ', 'Beginner'),
  'intermediate': ('متوسط', 'Intermediate'),
  'expert': ('متقدم', 'Expert'),
};

String _pick(Map<String, (String, String)> m, String? id, String lang) {
  if (id == null || id.isEmpty) return '';
  final v = m[id.toLowerCase()];
  if (v == null) return _titleCase(id);
  return lang == 'ar' ? v.$1 : v.$2;
}

String _titleCase(String s) =>
    s.split(' ').map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}').join(' ');

/// Bilingual muscle label for a canonical muscle id ('ar' | 'en').
String muscleLabel(String id, String lang) => _pick(_muscleLabels, id, lang);

/// Short Arabic muscle label without the explanatory parenthesis (for chips).
String muscleShortLabel(String id, String lang) {
  final l = muscleLabel(id, lang);
  final i = l.indexOf(' (');
  return i > 0 ? l.substring(0, i) : l;
}

/// Bilingual equipment label ('ar' | 'en'). Null/empty → ''.
String equipmentLabel(String? id, String lang) => _pick(_equipmentLabels, id, lang);

String movementPatternLabel(String? id, String lang) => _pick(_patternLabels, id, lang);
String mechanicLabel(String? id, String lang) => _pick(_mechanicLabels, id, lang);
String forceLabel(String? id, String lang) => _pick(_forceLabels, id, lang);
String categoryLabel(String? id, String lang) => _pick(_categoryLabels, id, lang);
String levelLabel(String? id, String lang) => _pick(_levelLabels, id, lang);

/// Maps loose muscle names (AI output, user text, other vocabularies) to a
/// canonical id from [kMuscles]; null when unknown.
String? normalizeMuscle(String raw) {
  final s = raw.trim().toLowerCase().replaceAll('_', ' ').replaceAll('-', ' ');
  if (kMuscles.contains(s)) return s;
  const aliases = {
    'abs': 'abdominals',
    'core': 'abdominals',
    'obliques': 'abdominals',
    'abdominal': 'abdominals',
    'abductor': 'abductors',
    'hip abductors': 'abductors',
    'adductor': 'adductors',
    'inner thigh': 'adductors',
    'bicep': 'biceps',
    'calf': 'calves',
    'pecs': 'chest',
    'pectorals': 'chest',
    'forearm': 'forearms',
    'grip': 'forearms',
    'glute': 'glutes',
    'gluteus': 'glutes',
    'hamstring': 'hamstrings',
    'lat': 'lats',
    'latissimus dorsi': 'lats',
    'back': 'lats',
    'upper back': 'middle back',
    'rhomboids': 'middle back',
    'lower back': 'lower back',
    'erectors': 'lower back',
    'quads': 'quadriceps',
    'quad': 'quadriceps',
    'delts': 'shoulders',
    'deltoids': 'shoulders',
    'shoulder': 'shoulders',
    'front delts': 'shoulders',
    'rear delts': 'shoulders',
    'trap': 'traps',
    'trapezius': 'traps',
    'tricep': 'triceps',
  };
  if (aliases.containsKey(s)) return aliases[s];
  for (final e in _muscleLabels.entries) {
    if (e.value.$1 == raw.trim() || muscleShortLabel(e.key, 'ar') == raw.trim()) return e.key;
  }
  return null;
}

/// Maps loose equipment names to a canonical id from [kEquipment] (fallback 'other').
String normalizeEquipment(String? raw) {
  if (raw == null || raw.trim().isEmpty) return 'other';
  final s = raw.trim().toLowerCase();
  if (kEquipment.contains(s)) return s;
  if (s.contains('ez') || s.contains('e-z')) return 'e-z curl bar';
  if (s.contains('smith') || s.contains('machine') || s.contains('press station')) return 'machine';
  if (s.contains('barbell') || s == 'bar') return 'barbell';
  if (s.contains('dumbbell')) return 'dumbbell';
  if (s.contains('cable') || s.contains('pulley')) return 'cable';
  if (s.contains('kettlebell')) return 'kettlebells';
  if (s.contains('band')) return 'bands';
  if (s.contains('medicine')) return 'medicine ball';
  if (s.contains('swiss') || s.contains('stability') || s.contains('exercise ball')) return 'exercise ball';
  if (s.contains('foam')) return 'foam roll';
  if (s.contains('body') || s == 'none' || s.contains('bodyweight')) return 'body only';
  return 'other';
}
