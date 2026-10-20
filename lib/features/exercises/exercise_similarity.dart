/// Local fuzzy matching of exercise names (ar/en) used to suggest existing
/// exercises before creating a new one, and to build AI candidate lists.
library;

import 'dart:math' as math;

/// Lowercases, unifies Arabic letter variants, strips diacritics/punctuation.
String normalizeForSearch(String s) {
  var t = s.toLowerCase();
  t = t.replaceAll(RegExp('[ً-ْـ]'), ''); // tashkeel + tatweel
  t = t.replaceAll(RegExp('[أإآ]'), 'ا').replaceAll('ة', 'ه').replaceAll('ى', 'ي').replaceAll('ؤ', 'و').replaceAll('ئ', 'ي');
  t = t.replaceAll(RegExp(r"[^a-z0-9؀-ۿ]+"), ' ');
  return t.trim().replaceAll(RegExp(r'\s+'), ' ');
}

const Set<String> _stopWords = {
  'with', 'the', 'a', 'an', 'on', 'of', 'to', 'in', 'and', 'for', 'my', 'i', 'it', 'is', 'using', 'exercise',
  'do', 'where', 'you', 'your', 'that', 'this', 'from', 'like', 'some', 'kind', 'thing',
  // Arabic fillers (normalized spelling)
  'في', 'علي', 'على', 'من', 'و', 'ب', 'ده', 'دي', 'اللي', 'تمرين', 'تمرينه', 'عن', 'مع', 'بتاع', 'بتاعه', 'انا',
  'وانا', 'لما', 'بيه', 'فيه', 'كده', 'زي', 'حاجه', 'يعني',
};

/// Maps abbreviations / Arabic gym words to a shared English token so that an
/// Arabic description can match an English name and vice versa.
const Map<String, String> _synonyms = {
  'db': 'dumbbell',
  'dumbell': 'dumbbell',
  'dumbbells': 'dumbbell',
  'دمبل': 'dumbbell',
  'دامبل': 'dumbbell',
  'bb': 'barbell',
  'بار': 'barbell',
  'باربل': 'barbell',
  'kb': 'kettlebell',
  'kettlebells': 'kettlebell',
  'كيتل': 'kettlebell',
  'cables': 'cable',
  'كابل': 'cable',
  'كيبل': 'cable',
  'machine': 'machine',
  'ماكينه': 'machine',
  'مكنه': 'machine',
  'جهاز': 'machine',
  'smith': 'smith',
  'سميث': 'smith',
  'بنش': 'bench',
  'بريس': 'press',
  'برس': 'press',
  'ضغط': 'press',
  'سكوات': 'squat',
  'اسكوات': 'squat',
  'كيرل': 'curl',
  'ديدلفت': 'deadlift',
  'رو': 'row',
  'تجديف': 'row',
  'صدر': 'chest',
  'كتف': 'shoulder',
  'اكتاف': 'shoulder',
  'shoulders': 'shoulder',
  'باي': 'biceps',
  'بايسبس': 'biceps',
  'bicep': 'biceps',
  'تراي': 'triceps',
  'ترايسبس': 'triceps',
  'tricep': 'triceps',
  'رجل': 'leg',
  'legs': 'leg',
  'سمانه': 'calf',
  'calves': 'calf',
  'بطن': 'ab',
  'abs': 'ab',
  'abdominal': 'ab',
  'ضهر': 'back',
  'ظهر': 'back',
  'سحب': 'pull',
  'عقله': 'pullup',
  'pullups': 'pullup',
  'pull-up': 'pullup',
  'انكلاين': 'incline',
  'مايل': 'incline',
  'ديكلاين': 'decline',
  'رفرفه': 'raise',
  'raises': 'raise',
  'جانبي': 'lateral',
  'side': 'lateral',
  'امامي': 'front',
  'خلفي': 'rear',
  'تفتيح': 'fly',
  'flye': 'fly',
  'flyes': 'fly',
  'flys': 'fly',
  'لانج': 'lunge',
  'اطاله': 'stretch',
  'قاعد': 'seated',
  'sitting': 'seated',
  'واقف': 'standing',
  'نايم': 'lying',
  'هامر': 'hammer',
  'حبل': 'rope',
  'ليج': 'leg',
  'كرانش': 'crunch',
  'بلانك': 'plank',
  'ديبس': 'dip',
  'dips': 'dip',
  'شراج': 'shrug',
  'شرج': 'shrug',
};

String _stem(String t) {
  if (RegExp(r'^[a-z]+$').hasMatch(t) && t.length > 3) {
    if (t.endsWith('ies')) return '${t.substring(0, t.length - 3)}y';
    if (t.endsWith('es') && (t.endsWith('ches') || t.endsWith('shes') || t.endsWith('sses'))) {
      return t.substring(0, t.length - 2);
    }
    if (t.endsWith('s') && !t.endsWith('ss')) return t.substring(0, t.length - 1);
  }
  return t;
}

/// Normalized, stop-word-free, synonym-mapped tokens.
List<String> searchTokens(String s) {
  final out = <String>[];
  for (final raw in normalizeForSearch(s).split(' ')) {
    if (raw.isEmpty || _stopWords.contains(raw)) continue;
    var t = _synonyms[raw] ?? raw;
    // Arabic prefixes "بال"/"ال" ("بالدمبل" → "دمبل").
    if (t == raw && RegExp('^[؀-ۿ]').hasMatch(t)) {
      for (final p in const ['بال', 'وال', 'ال', 'ب']) {
        if (t.startsWith(p) && t.length - p.length >= 2) {
          final rest = t.substring(p.length);
          if (_synonyms.containsKey(rest)) {
            t = _synonyms[rest]!;
            break;
          }
          if (p != 'ب') {
            t = rest;
            break;
          }
        }
      }
    }
    t = _stem(_synonyms[t] ?? t);
    if (t.isNotEmpty && !out.contains(t)) out.add(t);
  }
  return out;
}

int _levenshtein(String a, String b) {
  if (a == b) return 0;
  if (a.isEmpty) return b.length;
  if (b.isEmpty) return a.length;
  var prev = List<int>.generate(b.length + 1, (i) => i);
  for (var i = 0; i < a.length; i++) {
    final cur = List<int>.filled(b.length + 1, 0);
    cur[0] = i + 1;
    for (var j = 0; j < b.length; j++) {
      final cost = a[i] == b[j] ? 0 : 1;
      cur[j + 1] = math.min(math.min(cur[j] + 1, prev[j + 1] + 1), prev[j] + cost);
    }
    prev = cur;
  }
  return prev[b.length];
}

bool _tokenMatch(String a, String b) {
  if (a == b) return true;
  final short = a.length < b.length ? a : b;
  final long = a.length < b.length ? b : a;
  if (short.length >= 4 && long.startsWith(short)) return true;
  if (short.length >= 5 && _levenshtein(a, b) <= 1) return true;
  return false;
}

Set<String> _trigrams(String s) {
  final t = ' ${s.replaceAll(' ', '')} ';
  final out = <String>{};
  for (var i = 0; i + 3 <= t.length; i++) {
    out.add(t.substring(i, i + 3));
  }
  return out;
}

/// Similarity 0..1 between a free-text [query] and an exercise [name].
/// Combines token overlap (Dice), coverage of the name's words and a trigram
/// score for typos / glued words ("benchpress").
double nameSimilarity(String query, String name) {
  final q = searchTokens(query);
  final n = searchTokens(name);
  if (q.isEmpty || n.isEmpty) return 0;
  var inter = 0;
  for (final nt in n) {
    if (q.any((qt) => _tokenMatch(qt, nt))) inter++;
  }
  final dice = 2 * inter / (q.length + n.length);
  final coverage = inter / n.length;
  final coverageScore = coverage * ((inter >= 2 || n.length == 1) ? 0.9 : 0.5);
  final ta = _trigrams(q.join(' '));
  final tb = _trigrams(n.join(' '));
  final triInter = ta.intersection(tb).length;
  final tri = (ta.isEmpty || tb.isEmpty) ? 0.0 : 2 * triInter / (ta.length + tb.length);
  return [dice, coverageScore, tri * 0.9].reduce(math.max).clamp(0.0, 1.0);
}

class SimilarMatch<T> {
  final T item;
  final double score;
  const SimilarMatch(this.item, this.score);
}

/// Ranks [items] by the best similarity of any of their [names] to [query].
List<SimilarMatch<T>> rankBySimilarity<T>(
  String query,
  Iterable<T> items,
  List<String> Function(T) names, {
  int limit = 5,
  double minScore = 0.55,
}) {
  final out = <SimilarMatch<T>>[];
  for (final it in items) {
    var best = 0.0;
    for (final n in names(it)) {
      if (n.isEmpty) continue;
      final s = nameSimilarity(query, n);
      if (s > best) best = s;
    }
    if (best >= minScore) out.add(SimilarMatch(it, best));
  }
  out.sort((a, b) => b.score.compareTo(a.score));
  return out.take(limit).toList();
}
