import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:ironmind/features/exercises/exercise_labels.dart';
import 'package:ironmind/features/exercises/widgets/body_map_svg.dart';

void main() {
  test('canonical muscles match the free-exercise-db vocabulary', () {
    final raw = jsonDecode(File('assets/data/free-exercise-db.json').readAsStringSync()) as List;
    final used = <String>{
      for (final e in raw) ...[...(e['primaryMuscles'] as List), ...(e['secondaryMuscles'] as List)].cast<String>(),
    };
    expect(used.difference(kMuscles.toSet()), isEmpty);
    expect(kMuscles.length, 17);
    final equipment = {for (final e in raw) e['equipment']}..remove(null);
    expect(equipment.difference(kEquipment.toSet()), isEmpty);
  });

  test('every muscle and equipment id has distinct ar/en labels', () {
    for (final m in kMuscles) {
      final ar = muscleLabel(m, 'ar');
      final en = muscleLabel(m, 'en');
      expect(ar, isNotEmpty);
      expect(en, isNotEmpty);
      expect(ar, isNot(en), reason: m);
      expect(RegExp('[؀-ۿ]').hasMatch(ar), isTrue, reason: m);
      expect(muscleShortLabel(m, 'ar').contains('('), isFalse);
    }
    for (final e in kEquipment) {
      expect(equipmentLabel(e, 'ar'), isNot(equipmentLabel(e, 'en')), reason: e);
    }
    for (final p in kMovementPatterns) {
      expect(movementPatternLabel(p, 'ar'), isNotEmpty);
    }
    expect(equipmentLabel(null, 'ar'), '');
    expect(muscleLabel('unknown thing', 'en'), 'Unknown Thing');
  });

  test('normalizers map aliases to canonical ids', () {
    expect(normalizeMuscle('Quads'), 'quadriceps');
    expect(normalizeMuscle('rear_delts'), 'shoulders');
    expect(normalizeMuscle('Lower Back'), 'lower back');
    expect(normalizeMuscle('الصدر'), 'chest');
    expect(normalizeMuscle('spleen'), isNull);
    expect(normalizeEquipment('Smith machine'), 'machine');
    expect(normalizeEquipment('EZ bar'), 'e-z curl bar');
    expect(normalizeEquipment('bodyweight'), 'body only');
    expect(normalizeEquipment(null), 'other');
  });

  test('body map draws every canonical muscle on the front or back', () {
    final drawn = musclesIn(BodyView.front).union(musclesIn(BodyView.back));
    expect(drawn, kMuscles.toSet());
    for (final r in [...kFrontRegions, ...kBackRegions]) {
      expect(kMuscles, contains(r.muscle));
    }
  });

  test('body svg colours primary / secondary / idle muscles', () {
    final svg = buildBodySvg(
      BodyView.front,
      fillFor: (m) => m == 'chest' ? 0xFF1E8C0B : (m == 'triceps' ? 0xFF9DFF85 : 0xFF3A3A3A),
    );
    expect(svg, startsWith('<svg'));
    expect(svg, contains('fill="#1e8c0b"'));
    expect(svg, contains('fill="#3a3a3a"'));
    expect(svg, isNot(contains('#9dff85'))); // triceps are only drawn on the back
    expect(buildBodySvg(BodyView.back, fillFor: (m) => m == 'triceps' ? 0xFF9DFF85 : 0xFF3A3A3A),
        contains('#9dff85'));
  });
}
