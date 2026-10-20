/// Offline template plan builder (no AI) so the app is usable without an API key.
/// Produces the same JSON shape as the AI plan (see [workoutPlanSchema]).
library;

import 'dart:math' as math;

import 'workout_logic.dart';

class TemplateInput {
  /// Training weekdays (1=Mon … 7=Sun).
  final List<int> days;
  final String? split; // muscle_group / bro / full_body / ppl / upper_lower / ai
  final String? location; // full_gym / limited_gym / home
  final String? level; // beginner / intermediate / advanced
  final String? goal; // bulk / cut / recomp / strength / fitness
  final String? sex;
  final int? sessionMinutes;
  final double? bodyweightKg;
  final String lang;

  /// Exercise ids that exist in the DB (null = trust the built-in ids).
  final Set<String>? available;

  const TemplateInput({
    required this.days,
    this.split,
    this.location,
    this.level,
    this.goal,
    this.sex,
    this.sessionMinutes,
    this.bodyweightKg,
    this.lang = 'ar',
    this.available,
  });
}

enum _Env { gym, limited, home }

enum _Slot {
  squat,
  hinge,
  deadlift,
  lunge,
  legPress,
  legCurl,
  legExt,
  calves,
  glute,
  hPush,
  inclinePush,
  vPush,
  chestFly,
  lateral,
  rearDelt,
  vPull,
  hPull,
  hPull2,
  biceps,
  biceps2,
  triceps,
  triceps2,
  core,
}

/// Candidate ids per slot and environment, in preference order (all verified in
/// assets/data/free-exercise-db.json).
const Map<_Slot, Map<_Env, List<String>>> _slotIds = {
  _Slot.squat: {
    _Env.gym: ['Barbell_Squat', 'Leg_Press', 'Goblet_Squat'],
    _Env.limited: ['Goblet_Squat', 'Dumbbell_Squat', 'Barbell_Squat', 'Leg_Press'],
    _Env.home: ['Goblet_Squat', 'Dumbbell_Squat', 'Bodyweight_Squat'],
  },
  _Slot.hinge: {
    _Env.gym: ['Romanian_Deadlift', 'Stiff-Legged_Dumbbell_Deadlift'],
    _Env.limited: ['Stiff-Legged_Dumbbell_Deadlift', 'Romanian_Deadlift'],
    _Env.home: ['Stiff-Legged_Dumbbell_Deadlift', 'Butt_Lift_Bridge'],
  },
  _Slot.deadlift: {
    _Env.gym: ['Barbell_Deadlift', 'Romanian_Deadlift'],
    _Env.limited: ['Barbell_Deadlift', 'Stiff-Legged_Dumbbell_Deadlift'],
    _Env.home: ['Stiff-Legged_Dumbbell_Deadlift', 'Butt_Lift_Bridge'],
  },
  _Slot.lunge: {
    _Env.gym: ['Dumbbell_Lunges', 'Barbell_Lunge', 'Bodyweight_Walking_Lunge'],
    _Env.limited: ['Dumbbell_Lunges', 'Bodyweight_Walking_Lunge'],
    _Env.home: ['Dumbbell_Lunges', 'Bodyweight_Walking_Lunge'],
  },
  _Slot.legPress: {
    _Env.gym: ['Leg_Press', 'Goblet_Squat'],
    _Env.limited: ['Leg_Press', 'Goblet_Squat', 'Dumbbell_Squat'],
    _Env.home: ['Dumbbell_Squat', 'Bodyweight_Squat'],
  },
  _Slot.legCurl: {
    _Env.gym: ['Lying_Leg_Curls', 'Stiff-Legged_Dumbbell_Deadlift'],
    _Env.limited: ['Lying_Leg_Curls', 'Stiff-Legged_Dumbbell_Deadlift'],
    _Env.home: ['Butt_Lift_Bridge', 'Stiff-Legged_Dumbbell_Deadlift'],
  },
  _Slot.legExt: {
    _Env.gym: ['Leg_Extensions', 'Dumbbell_Lunges'],
    _Env.limited: ['Leg_Extensions', 'Dumbbell_Lunges'],
    _Env.home: ['Bodyweight_Walking_Lunge', 'Bodyweight_Squat'],
  },
  _Slot.calves: {
    _Env.gym: ['Standing_Calf_Raises', 'Seated_Calf_Raise'],
    _Env.limited: ['Standing_Dumbbell_Calf_Raise', 'Seated_Calf_Raise'],
    _Env.home: ['Standing_Dumbbell_Calf_Raise'],
  },
  _Slot.glute: {
    _Env.gym: ['Barbell_Hip_Thrust', 'Butt_Lift_Bridge'],
    _Env.limited: ['Barbell_Hip_Thrust', 'Butt_Lift_Bridge'],
    _Env.home: ['Butt_Lift_Bridge', 'Leg_Lift'],
  },
  _Slot.hPush: {
    _Env.gym: ['Barbell_Bench_Press_-_Medium_Grip', 'Dumbbell_Bench_Press'],
    _Env.limited: ['Dumbbell_Bench_Press', 'Barbell_Bench_Press_-_Medium_Grip', 'Pushups'],
    _Env.home: ['Pushups', 'Dumbbell_Bench_Press'],
  },
  _Slot.inclinePush: {
    _Env.gym: ['Incline_Dumbbell_Press', 'Barbell_Incline_Bench_Press_-_Medium_Grip'],
    _Env.limited: ['Incline_Dumbbell_Press', 'Push-Ups_With_Feet_Elevated'],
    _Env.home: ['Push-Ups_With_Feet_Elevated', 'Incline_Dumbbell_Press'],
  },
  _Slot.vPush: {
    _Env.gym: ['Standing_Military_Press', 'Dumbbell_Shoulder_Press'],
    _Env.limited: ['Dumbbell_Shoulder_Press', 'Seated_Dumbbell_Press'],
    _Env.home: ['Dumbbell_Shoulder_Press', 'Arnold_Dumbbell_Press'],
  },
  _Slot.chestFly: {
    _Env.gym: ['Cable_Crossover', 'Dumbbell_Flyes'],
    _Env.limited: ['Dumbbell_Flyes', 'Cable_Crossover'],
    _Env.home: ['Dumbbell_Flyes', 'Pushups'],
  },
  _Slot.lateral: {
    _Env.gym: ['Side_Lateral_Raise'],
    _Env.limited: ['Side_Lateral_Raise'],
    _Env.home: ['Side_Lateral_Raise'],
  },
  _Slot.rearDelt: {
    _Env.gym: ['Face_Pull', 'Reverse_Flyes'],
    _Env.limited: ['Reverse_Flyes', 'Face_Pull'],
    _Env.home: ['Reverse_Flyes'],
  },
  _Slot.vPull: {
    _Env.gym: ['Wide-Grip_Lat_Pulldown', 'Pullups'],
    _Env.limited: ['Wide-Grip_Lat_Pulldown', 'Pullups', 'Chin-Up'],
    _Env.home: ['Pullups', 'Chin-Up', 'One-Arm_Dumbbell_Row'],
  },
  _Slot.hPull: {
    _Env.gym: ['Bent_Over_Barbell_Row', 'Seated_Cable_Rows'],
    _Env.limited: ['One-Arm_Dumbbell_Row', 'Seated_Cable_Rows'],
    _Env.home: ['One-Arm_Dumbbell_Row', 'Bent_Over_Two-Dumbbell_Row', 'Inverted_Row'],
  },
  _Slot.hPull2: {
    _Env.gym: ['Seated_Cable_Rows', 'One-Arm_Dumbbell_Row'],
    _Env.limited: ['Seated_Cable_Rows', 'Bent_Over_Two-Dumbbell_Row'],
    _Env.home: ['Bent_Over_Two-Dumbbell_Row', 'Inverted_Row', 'One-Arm_Dumbbell_Row'],
  },
  _Slot.biceps: {
    _Env.gym: ['Barbell_Curl', 'Dumbbell_Bicep_Curl'],
    _Env.limited: ['Dumbbell_Bicep_Curl', 'Barbell_Curl'],
    _Env.home: ['Dumbbell_Bicep_Curl'],
  },
  _Slot.biceps2: {
    _Env.gym: ['Hammer_Curls'],
    _Env.limited: ['Hammer_Curls'],
    _Env.home: ['Hammer_Curls'],
  },
  _Slot.triceps: {
    _Env.gym: ['Triceps_Pushdown', 'EZ-Bar_Skullcrusher'],
    _Env.limited: ['Triceps_Pushdown', 'Standing_Dumbbell_Triceps_Extension'],
    _Env.home: ['Standing_Dumbbell_Triceps_Extension', 'Dips_-_Triceps_Version'],
  },
  _Slot.triceps2: {
    _Env.gym: ['Close-Grip_Barbell_Bench_Press', 'Dips_-_Triceps_Version'],
    _Env.limited: ['Dips_-_Triceps_Version', 'Tricep_Dumbbell_Kickback'],
    _Env.home: ['Tricep_Dumbbell_Kickback', 'Dips_-_Triceps_Version'],
  },
  _Slot.core: {
    _Env.gym: ['Hanging_Leg_Raise', 'Plank', 'Crunches'],
    _Env.limited: ['Plank', 'Hanging_Leg_Raise', 'Crunches'],
    _Env.home: ['Plank', 'Crunches'],
  },
};

/// Main compound slots (heavier, longer rest).
const _compound = {
  _Slot.squat,
  _Slot.hinge,
  _Slot.deadlift,
  _Slot.legPress,
  _Slot.hPush,
  _Slot.inclinePush,
  _Slot.vPush,
  _Slot.vPull,
  _Slot.hPull,
  _Slot.hPull2,
  _Slot.lunge,
  _Slot.glute,
};

/// Starting weight as a fraction of bodyweight for an intermediate male.
/// Dumbbell values are per hand. Exercises not listed → null (pick on the day).
const Map<String, double> _weightFactor = {
  'Barbell_Squat': 0.8,
  'Leg_Press': 1.4,
  'Goblet_Squat': 0.25,
  'Dumbbell_Squat': 0.2,
  'Romanian_Deadlift': 0.7,
  'Barbell_Deadlift': 1.0,
  'Stiff-Legged_Dumbbell_Deadlift': 0.22,
  'Dumbbell_Lunges': 0.15,
  'Barbell_Lunge': 0.4,
  'Barbell_Hip_Thrust': 0.8,
  'Barbell_Bench_Press_-_Medium_Grip': 0.65,
  'Dumbbell_Bench_Press': 0.22,
  'Incline_Dumbbell_Press': 0.2,
  'Barbell_Incline_Bench_Press_-_Medium_Grip': 0.55,
  'Standing_Military_Press': 0.4,
  'Dumbbell_Shoulder_Press': 0.15,
  'Seated_Dumbbell_Press': 0.15,
  'Arnold_Dumbbell_Press': 0.12,
  'Wide-Grip_Lat_Pulldown': 0.6,
  'Bent_Over_Barbell_Row': 0.55,
  'Seated_Cable_Rows': 0.55,
  'One-Arm_Dumbbell_Row': 0.25,
  'Bent_Over_Two-Dumbbell_Row': 0.18,
  'Barbell_Curl': 0.3,
  'Dumbbell_Bicep_Curl': 0.12,
  'Hammer_Curls': 0.12,
  'Triceps_Pushdown': 0.3,
  'EZ-Bar_Skullcrusher': 0.25,
  'Close-Grip_Barbell_Bench_Press': 0.5,
  'Standing_Dumbbell_Triceps_Extension': 0.15,
  'Tricep_Dumbbell_Kickback': 0.07,
  'Side_Lateral_Raise': 0.06,
  'Reverse_Flyes': 0.06,
  'Dumbbell_Flyes': 0.12,
  'Cable_Crossover': 0.15,
  'Face_Pull': 0.2,
  'Lying_Leg_Curls': 0.4,
  'Leg_Extensions': 0.45,
  'Standing_Calf_Raises': 0.8,
  'Seated_Calf_Raise': 0.5,
  'Standing_Dumbbell_Calf_Raise': 0.2,
};

const _dumbbellIds = {
  'Goblet_Squat',
  'Dumbbell_Squat',
  'Stiff-Legged_Dumbbell_Deadlift',
  'Dumbbell_Lunges',
  'Dumbbell_Bench_Press',
  'Incline_Dumbbell_Press',
  'Dumbbell_Shoulder_Press',
  'Seated_Dumbbell_Press',
  'Arnold_Dumbbell_Press',
  'One-Arm_Dumbbell_Row',
  'Bent_Over_Two-Dumbbell_Row',
  'Dumbbell_Bicep_Curl',
  'Hammer_Curls',
  'Standing_Dumbbell_Triceps_Extension',
  'Tricep_Dumbbell_Kickback',
  'Side_Lateral_Raise',
  'Reverse_Flyes',
  'Dumbbell_Flyes',
  'Standing_Dumbbell_Calf_Raise',
};

enum _DayKind { upper, lower, full }

class _DayTpl {
  final String en;
  final String ar;
  final String focusEn;
  final String focusAr;
  final _DayKind kind;
  final List<_Slot> slots;
  const _DayTpl(this.en, this.ar, this.focusEn, this.focusAr, this.kind, this.slots);
}

const _fullA = _DayTpl('Full Body A', 'فل بادي A', 'Squat, bench, row', 'سكوات، بنش، سحب', _DayKind.full, [
  _Slot.squat, _Slot.hPush, _Slot.hPull, _Slot.vPush, _Slot.legCurl, _Slot.biceps, _Slot.triceps, _Slot.core, //
]);
const _fullB = _DayTpl('Full Body B', 'فل بادي B', 'Deadlift, incline, pull-down', 'ديدلفت، إنكلاين، سحب عالي', _DayKind.full, [
  _Slot.deadlift, _Slot.inclinePush, _Slot.vPull, _Slot.lunge, _Slot.lateral, _Slot.calves, _Slot.core, _Slot.biceps2, //
]);
const _fullC = _DayTpl('Full Body C', 'فل بادي C', 'Legs, chest, back, shoulders', 'رجل، صدر، ضهر، أكتاف', _DayKind.full, [
  _Slot.legPress, _Slot.hPush, _Slot.hPull2, _Slot.vPush, _Slot.glute, _Slot.rearDelt, _Slot.triceps2, _Slot.core, //
]);
const _upperA = _DayTpl('Upper A', 'الجزء العلوي A', 'Chest, back, shoulders, arms', 'صدر، ضهر، أكتاف، دراعات', _DayKind.upper, [
  _Slot.hPush, _Slot.hPull, _Slot.vPush, _Slot.vPull, _Slot.lateral, _Slot.biceps, _Slot.triceps, _Slot.rearDelt, //
]);
const _upperB = _DayTpl('Upper B', 'الجزء العلوي B', 'Chest, back, shoulders, arms', 'صدر، ضهر، أكتاف، دراعات', _DayKind.upper, [
  _Slot.inclinePush, _Slot.vPull, _Slot.vPush, _Slot.hPull2, _Slot.chestFly, _Slot.rearDelt, _Slot.biceps2, _Slot.triceps2, //
]);
const _lowerA = _DayTpl('Lower A', 'الجزء السفلي A', 'Quads, hamstrings, calves', 'أمامية، خلفية، سمانة', _DayKind.lower, [
  _Slot.squat, _Slot.hinge, _Slot.legExt, _Slot.legCurl, _Slot.calves, _Slot.core, _Slot.lunge, //
]);
const _lowerB = _DayTpl('Lower B', 'الجزء السفلي B', 'Posterior chain, glutes, calves', 'السلسلة الخلفية، الجلوتس، السمانة', _DayKind.lower, [
  _Slot.deadlift, _Slot.legPress, _Slot.glute, _Slot.legCurl, _Slot.calves, _Slot.core, _Slot.legExt, //
]);
const _push = _DayTpl('Push', 'دفع (Push)', 'Chest, shoulders, triceps', 'صدر، أكتاف، ترايسبس', _DayKind.upper, [
  _Slot.hPush, _Slot.inclinePush, _Slot.vPush, _Slot.lateral, _Slot.chestFly, _Slot.triceps, _Slot.triceps2, //
]);
const _pull = _DayTpl('Pull', 'سحب (Pull)', 'Back, rear delts, biceps', 'ضهر، كتف خلفي، بايسبس', _DayKind.upper, [
  _Slot.vPull, _Slot.hPull, _Slot.hPull2, _Slot.rearDelt, _Slot.biceps, _Slot.biceps2, _Slot.core, //
]);
const _legs = _DayTpl('Legs', 'رجل (Legs)', 'Quads, hamstrings, glutes, calves', 'أمامية، خلفية، جلوتس، سمانة', _DayKind.lower, [
  _Slot.squat, _Slot.hinge, _Slot.legExt, _Slot.legCurl, _Slot.calves, _Slot.lunge, _Slot.core, //
]);
const _chest = _DayTpl('Chest', 'صدر', 'Chest', 'صدر', _DayKind.upper, [
  _Slot.hPush, _Slot.inclinePush, _Slot.chestFly, _Slot.triceps2, _Slot.core, //
]);
const _back = _DayTpl('Back', 'ضهر', 'Back', 'ضهر', _DayKind.upper, [
  _Slot.vPull, _Slot.hPull, _Slot.hPull2, _Slot.deadlift, _Slot.rearDelt, //
]);
const _shoulders = _DayTpl('Shoulders', 'أكتاف', 'Shoulders', 'أكتاف', _DayKind.upper, [
  _Slot.vPush, _Slot.lateral, _Slot.rearDelt, _Slot.hPush, _Slot.core, //
]);
const _arms = _DayTpl('Arms', 'دراعات', 'Biceps & triceps', 'بايسبس وترايسبس', _DayKind.upper, [
  _Slot.biceps, _Slot.triceps, _Slot.biceps2, _Slot.triceps2, _Slot.core, //
]);
const _chestTri = _DayTpl('Chest & Triceps', 'صدر وترايسبس', 'Chest, triceps', 'صدر، ترايسبس', _DayKind.upper, [
  _Slot.hPush, _Slot.inclinePush, _Slot.chestFly, _Slot.triceps, _Slot.triceps2, _Slot.core, //
]);
const _backBi = _DayTpl('Back & Biceps', 'ضهر وبايسبس', 'Back, biceps', 'ضهر، بايسبس', _DayKind.upper, [
  _Slot.vPull, _Slot.hPull, _Slot.hPull2, _Slot.biceps, _Slot.biceps2, _Slot.rearDelt, //
]);
const _legsShoulders = _DayTpl('Legs & Shoulders', 'رجل وأكتاف', 'Legs, shoulders', 'رجل، أكتاف', _DayKind.full, [
  _Slot.squat, _Slot.vPush, _Slot.hinge, _Slot.lateral, _Slot.legCurl, _Slot.calves, _Slot.rearDelt, //
]);

List<_DayTpl> _rotation(String? split, int n) {
  switch (split) {
    case 'full_body':
      return const [_fullA, _fullB, _fullC];
    case 'upper_lower':
      return const [_upperA, _lowerA, _upperB, _lowerB];
    case 'ppl':
      return const [_push, _pull, _legs];
    case 'bro':
      return const [_chest, _back, _legs, _shoulders, _arms];
    case 'muscle_group':
      return const [_chestTri, _backBi, _legsShoulders];
  }
  if (n <= 3) return const [_fullA, _fullB, _fullC];
  if (n == 4) return const [_upperA, _lowerA, _upperB, _lowerB];
  if (n == 5) return const [_push, _pull, _legs, _upperA, _lowerB];
  return const [_push, _pull, _legs];
}

_Env _envOf(String? location) => switch (location) {
      'home' => _Env.home,
      'limited_gym' => _Env.limited,
      _ => _Env.gym,
    };

int _exerciseCount(int? minutes) => switch (minutes ?? 60) {
      <= 30 => 4,
      <= 45 => 5,
      <= 60 => 6,
      <= 75 => 7,
      _ => 8,
    };

List<String> _warmup(_DayKind k, bool ar) {
  final general = ar ? '5 دقايق كارديو خفيف (عجلة أو مشي سريع)' : '5 min easy cardio (bike or brisk walk)';
  final last = ar
      ? '1–2 ست إحماء خفيفين لأول تمرين (50% ثم 70% من الوزن)'
      : '1–2 light warm-up sets of the first exercise (50% then 70% of the working weight)';
  return switch (k) {
    _DayKind.upper => [
        general,
        ar ? 'لف الدراعات ودوران الكتف – 20 مرة' : 'Arm circles & shoulder rotations – 20 reps',
        ar ? 'Band pull-apart أو فتح الدراعات بالأستك – 2×15' : 'Band pull-aparts – 2×15',
        ar ? 'ضغط خفيف 10 عدات' : 'Easy push-ups ×10',
        last,
      ],
    _DayKind.lower => [
        general,
        ar ? 'سكوات بوزن الجسم ×15' : 'Bodyweight squats ×15',
        ar ? 'مرجحة الرجل 10 لكل ناحية' : 'Leg swings – 10 each side',
        ar ? 'كوبري جلوتس ×15' : 'Glute bridges ×15',
        last,
      ],
    _DayKind.full => [
        general,
        ar ? 'لف الدراعات ودوران الكتف – 20 مرة' : 'Arm circles & shoulder rotations – 20 reps',
        ar ? 'سكوات بوزن الجسم ×15' : 'Bodyweight squats ×15',
        ar ? 'Hip hinge بعصاية أو من غير وزن ×10' : 'Hip hinges with a dowel or bodyweight ×10',
        last,
      ],
  };
}

List<String> _cooldown(_DayKind k, bool ar) {
  final walk = ar ? '3–5 دقايق مشي هادي' : '3–5 min easy walk';
  return switch (k) {
    _DayKind.upper => [
        ar ? 'إطالة الصدر على الباب – 30 ثانية لكل ناحية' : 'Doorway chest stretch – 30 s each side',
        ar ? 'إطالة الضهر (Lat stretch) – 30 ثانية لكل ناحية' : 'Lat stretch – 30 s each side',
        ar ? 'إطالة الترايسبس فوق الراس – 30 ثانية لكل دراع' : 'Overhead triceps stretch – 30 s each arm',
        ar ? 'إطالة الكتف عبر الصدر – 30 ثانية' : 'Cross-body shoulder stretch – 30 s each side',
        walk,
      ],
    _DayKind.lower => [
        ar ? 'إطالة الفخذ الأمامي واقف – 30 ثانية لكل رجل' : 'Standing quad stretch – 30 s each leg',
        ar ? 'إطالة الخلفية – 30 ثانية لكل رجل' : 'Hamstring stretch – 30 s each leg',
        ar ? 'إطالة الحوض (Hip flexor lunge) – 30 ثانية' : 'Hip-flexor lunge stretch – 30 s each side',
        ar ? 'إطالة السمانة على الحيطة – 30 ثانية' : 'Wall calf stretch – 30 s each leg',
        walk,
      ],
    _DayKind.full => [
        ar ? 'إطالة الصدر على الباب – 30 ثانية' : 'Doorway chest stretch – 30 s',
        ar ? 'إطالة الضهر (Child\'s pose) – 45 ثانية' : 'Child\'s pose – 45 s',
        ar ? 'إطالة الفخذ الأمامي – 30 ثانية لكل رجل' : 'Quad stretch – 30 s each leg',
        ar ? 'إطالة الخلفية – 30 ثانية لكل رجل' : 'Hamstring stretch – 30 s each leg',
        walk,
      ],
  };
}

String? _pickId(_Slot slot, _Env env, Set<String> used, Set<String>? available) {
  final ids = [...?_slotIds[slot]?[env], ...?_slotIds[slot]?[_Env.gym]];
  for (final id in ids) {
    if (used.contains(id)) continue;
    if (available != null && !available.contains(id)) continue;
    return id;
  }
  return null;
}

double? _estimateWeight(String id, TemplateInput i) {
  final f = _weightFactor[id];
  final bw = i.bodyweightKg;
  if (f == null || bw == null || bw <= 0) return null;
  final levelMul = switch (i.level) {
    'beginner' => 0.6,
    'advanced' => 1.25,
    _ => 1.0,
  };
  final sexMul = i.sex == 'female' ? 0.65 : 1.0;
  final raw = bw * f * levelMul * sexMul;
  final step = _dumbbellIds.contains(id) ? 2.0 : 2.5;
  final w = roundToStep(raw, step);
  return math.max(step, w);
}

/// Builds the plan JSON (same shape as the AI output).
Map<String, dynamic> buildTemplatePlanJson(TemplateInput i) {
  final ar = i.lang == 'ar';
  final env = _envOf(i.location);
  final days = ({...i.days.where((d) => d >= 1 && d <= 7)}.toList()..sort());
  final trainingDays = days.isEmpty ? const [6, 1, 3] : days; // fallback: Sat/Mon/Wed
  final rotation = _rotation(i.split, trainingDays.length);
  final count = _exerciseCount(i.sessionMinutes);
  final strength = i.goal == 'strength';
  final rpe = switch (i.level) {
    'beginner' => 7.0,
    'advanced' => 8.5,
    _ => 8.0,
  };

  // Label repeated day types as A/B when the split has no letter already.
  final seenCount = <_DayTpl, int>{};
  final outDays = <Map<String, dynamic>>[];
  for (var k = 0; k < trainingDays.length; k++) {
    final tpl = rotation[k % rotation.length];
    final n = (seenCount[tpl] ?? 0) + 1;
    seenCount[tpl] = n;
    final repeats = trainingDays.length > rotation.length;
    final hasLetter = RegExp(r' [ABC]$').hasMatch(tpl.en);
    final suffix = (!hasLetter && repeats) ? ' ${String.fromCharCode(64 + n)}' : '';
    final used = <String>{};
    final exercises = <Map<String, dynamic>>[];
    for (final slot in tpl.slots) {
      if (exercises.length >= count) break;
      final id = _pickId(slot, env, used, i.available);
      if (id == null) continue;
      used.add(id);
      final compound = _compound.contains(slot);
      final primary = compound && exercises.length < 2;
      final isCore = slot == _Slot.core;
      final bodyweight = const {
        'Pushups',
        'Push-Ups_With_Feet_Elevated',
        'Pullups',
        'Chin-Up',
        'Inverted_Row',
        'Dips_-_Triceps_Version',
        'Bodyweight_Squat',
        'Bodyweight_Walking_Lunge',
        'Butt_Lift_Bridge',
        'Leg_Lift',
        'Plank',
        'Crunches',
        'Hanging_Leg_Raise',
      }.contains(id);
      final (rMin, rMax) = isCore
          ? (id == 'Plank' ? (30, 60) : (10, 15))
          : primary
              ? (strength ? (4, 6) : (6, 10))
              : compound
                  ? (8, 12)
                  : (10, 15);
      exercises.add({
        'exerciseId': id,
        'sets': primary && i.level != 'beginner' ? 4 : 3,
        'repMin': rMin,
        'repMax': rMax,
        'suggestedWeightKg': bodyweight ? 0.0 : _estimateWeight(id, i),
        'targetRpe': isCore ? 7.0 : rpe,
        'restSeconds': primary ? (strength ? 180 : 150) : (compound ? 105 : 75),
        'notes': id == 'Plank'
            ? (ar ? 'العدات = ثواني الثبات' : 'Reps = seconds held')
            : null,
      });
    }
    outDays.add({
      'weekday': trainingDays[k],
      'name': '${ar ? tpl.ar : tpl.en}$suffix',
      'focus': ar ? tpl.focusAr : tpl.focusEn,
      'warmup': _warmup(tpl.kind, ar),
      'cooldown': _cooldown(tpl.kind, ar),
      'exercises': exercises,
    });
  }

  final splitName = switch (rotation.first) {
    _fullA => ar ? 'فل بادي' : 'Full Body',
    _upperA => ar ? 'أبر/لوور' : 'Upper/Lower',
    _push => ar ? 'Push/Pull/Legs' : 'Push/Pull/Legs',
    _chest => ar ? 'عضلة في اليوم' : 'Bro Split',
    _ => ar ? 'مجموعات عضلية' : 'Muscle Groups',
  };
  final n = trainingDays.length;
  return {
    'name': ar ? 'خطة $splitName – $n أيام' : '$splitName – $n days',
    'notes': ar
        ? 'خطة أساسية اتبنت من غير AI. زوّد العدات لحد آخر النطاق وبعدين زوّد الوزن. تقدر تعيد بناءها بالـ AI من تاب التمرين بعد ما تضيف مفتاح الـ API.'
        : 'Basic plan built offline without AI. Hit the top of the rep range, then add weight. '
            'Regenerate it with AI from the Workout tab once you add your API key.',
    'deloadEveryWeeks': switch (i.level) {
      'beginner' => 6,
      'advanced' => 4,
      _ => 5,
    },
    'days': outDays,
  };
}

/// Every exercise id the template may use (for tests / seed checks).
Set<String> get templateExerciseIds => {
      for (final m in _slotIds.values)
        for (final l in m.values) ...l,
    };
