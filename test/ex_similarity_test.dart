import 'package:flutter_test/flutter_test.dart';
import 'package:ironmind/features/exercises/exercise_similarity.dart';

void main() {
  const names = [
    ('Dumbbell Bench Press', 'بنش بريس بالدمبل'),
    ('Barbell Bench Press - Medium Grip', 'بنش بريس بالبار'),
    ('Incline Dumbbell Press', 'إنكلاين بريس بالدمبل'),
    ('Dumbbell Bicep Curl', 'باي كيرل بالدمبل'),
    ('Seated Cable Rows', 'سحب أرضي بالكابل'),
    ('Leg Press', 'ليج بريس'),
    ('Plank', 'بلانك'),
  ];

  String top(String q, {double min = 0.3}) {
    final r = rankBySimilarity(q, names, (n) => [n.$1, n.$2], minScore: min);
    return r.isEmpty ? '' : r.first.item.$1;
  }

  test('normalizeForSearch unifies Arabic letters and strips marks', () {
    expect(normalizeForSearch('إطالةٌ  الصدرِ!'), 'اطاله الصدر');
    expect(normalizeForSearch('Push-Up (Wide)'), 'push up wide');
  });

  test('searchTokens maps synonyms, Arabic prefixes and plurals', () {
    expect(searchTokens('db curls'), ['dumbbell', 'curl']);
    expect(searchTokens('بنش بالدمبل'), ['bench', 'dumbbell']);
    expect(searchTokens('the rows with cable'), ['row', 'cable']);
  });

  test('exact and reordered names rank first', () {
    expect(top('dumbbell bench press'), 'Dumbbell Bench Press');
    expect(top('bench press with dumbbells'), 'Dumbbell Bench Press');
    expect(top('db curl'), 'Dumbbell Bicep Curl');
    expect(top('cable row seated'), 'Seated Cable Rows');
  });

  test('Arabic description matches English names', () {
    expect(top('بنش بريس دمبل'), 'Dumbbell Bench Press');
    expect(top('ليج بريس'), 'Leg Press');
  });

  test('typos and glued words still match', () {
    expect(top('benchpress dumbell'), 'Dumbbell Bench Press');
    expect(nameSimilarity('plank', 'Plank'), closeTo(1.0, 1e-9));
  });

  test('unrelated text does not trigger "did you mean"', () {
    final r = rankBySimilarity('jump rope intervals', names, (n) => [n.$1, n.$2], minScore: 0.55);
    expect(r, isEmpty);
  });

  test('scores are bounded and symmetric-ish', () {
    final s = nameSimilarity('incline dumbbell press', 'Incline Dumbbell Press');
    expect(s, inInclusiveRange(0.99, 1.0));
    expect(nameSimilarity('', 'Plank'), 0);
  });
}
