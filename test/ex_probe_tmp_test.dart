import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironmind/features/exercises/exercise_seed.dart';

void main() {
  test('probe', () {
    final raw = jsonDecode(File('assets/data/free-exercise-db.json').readAsStringSync()) as List;
    var ok = 0;
    final miss = <String, int>{};
    for (final r in raw) {
      final n = r['name'] as String;
      final a = autoArabicName(n);
      if (a != null) {
        ok++;
        if (ok % 25 == 0) print('$n → $a');
      } else {
        for (final t in n.toLowerCase().replaceAll(RegExp(r"[^a-z0-9]+"), ' ').trim().split(' ')) {
          miss[t] = (miss[t] ?? 0) + 1;
        }
      }
    }
    print('coverage $ok / ${raw.length}');
    final m = miss.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    print(m.take(80).map((e) => '${e.key}:${e.value}').join(' '));
    final pats = <String, int>{};
    for (final c in buildSeedCompanions(raw, {})) { pats[c.movementPattern.value!] = (pats[c.movementPattern.value!] ?? 0) + 1; }
    print(pats);
  });
}
