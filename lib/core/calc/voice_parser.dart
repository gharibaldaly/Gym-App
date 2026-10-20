/// Local regex parser for spoken set entries, e.g.
/// "80 كيلو 10 عدات", "تمانين كيلو عشر عدات", "82.5 kg 8 reps rpe 8", "80 في 10".
/// Returns null when it can't find both weight and reps → caller falls back to Claude (Haiku).
library;

class ParsedSet {
  final double weightKg;
  final int reps;
  final double? rpe;
  const ParsedSet(this.weightKg, this.reps, {this.rpe});

  @override
  bool operator ==(Object other) =>
      other is ParsedSet && other.weightKg == weightKg && other.reps == reps && other.rpe == rpe;

  @override
  int get hashCode => Object.hash(weightKg, reps, rpe);

  @override
  String toString() => 'ParsedSet($weightKg kg x $reps, rpe: $rpe)';
}

class VoiceSetParser {
  static const _arDigits = {'٠': '0', '١': '1', '٢': '2', '٣': '3', '٤': '4', '٥': '5', '٦': '6', '٧': '7', '٨': '8', '٩': '9'};

  static const Map<String, double> _arWords = {
    'صفر': 0,
    'واحد': 1, 'واحدة': 1, 'واحده': 1,
    'اتنين': 2, 'اثنين': 2, 'إتنين': 2, 'اثنان': 2, 'إثنين': 2,
    'تلاتة': 3, 'تلاته': 3, 'ثلاثة': 3, 'ثلاثه': 3, 'تلات': 3, 'ثلاث': 3,
    'اربعة': 4, 'أربعة': 4, 'اربعه': 4, 'أربعه': 4, 'اربع': 4, 'أربع': 4,
    'خمسة': 5, 'خمسه': 5, 'خمس': 5,
    'ستة': 6, 'سته': 6, 'ست': 6,
    'سبعة': 7, 'سبعه': 7, 'سبع': 7,
    'تمانية': 8, 'تمانيه': 8, 'ثمانية': 8, 'ثمانيه': 8, 'تمن': 8, 'ثمان': 8, 'تماني': 8,
    'تسعة': 9, 'تسعه': 9, 'تسع': 9,
    'عشرة': 10, 'عشره': 10, 'عشر': 10,
    'حداشر': 11, 'احداشر': 11, 'إحداشر': 11, 'حداشمر': 11,
    'اتناشر': 12, 'اثناشر': 12, 'إتناشر': 12,
    'تلتاشر': 13, 'تلطاشر': 13, 'ثلاثطاشر': 13,
    'اربعتاشر': 14, 'اربعطاشر': 14, 'أربعتاشر': 14,
    'خمستاشر': 15, 'خمسطاشر': 15,
    'ستاشر': 16, 'سطاشر': 16,
    'سبعتاشر': 17, 'سبعطاشر': 17,
    'تمنتاشر': 18, 'طمنطاشر': 18, 'تمنطاشر': 18,
    'تسعتاشر': 19, 'تسعطاشر': 19,
    'عشرين': 20, 'تلاتين': 30, 'ثلاثين': 30, 'اربعين': 40, 'أربعين': 40,
    'خمسين': 50, 'ستين': 60, 'سبعين': 70, 'تمانين': 80, 'ثمانين': 80, 'تسعين': 90,
    'مية': 100, 'ميه': 100, 'مائة': 100, 'مئة': 100, 'مائه': 100,
    'ميتين': 200, 'مائتين': 200, 'متين': 200,
    'نص': 0.5, 'نصف': 0.5,
  };

  static const Map<String, double> _enWords = {
    'zero': 0, 'one': 1, 'two': 2, 'three': 3, 'four': 4, 'five': 5, 'six': 6, 'seven': 7,
    'eight': 8, 'nine': 9, 'ten': 10, 'eleven': 11, 'twelve': 12, 'thirteen': 13, 'fourteen': 14,
    'fifteen': 15, 'sixteen': 16, 'seventeen': 17, 'eighteen': 18, 'nineteen': 19, 'twenty': 20,
    'thirty': 30, 'forty': 40, 'fifty': 50, 'sixty': 60, 'seventy': 70, 'eighty': 80, 'ninety': 90,
    'hundred': 100, 'half': 0.5,
  };

  static const _weightUnits = r'(?:kg|kgs|kilo|kilos|kilograms?|كيلو|كيلوجرام|كجم|كيلوات|ك)';
  static const _repUnits = r'(?:reps?|repetitions?|times|عدات|عدة|عده|عدّات|تكرارات|تكرار|مرات|مرة|مره)';
  static const _rpeWords = r'(?:rpe|ار بي اي|آر بي إي|مجهود)';

  /// Converts Arabic-Indic digits, decimal commas and spelled-out numbers to digits.
  static String normalize(String input) {
    var s = input.toLowerCase().trim();
    _arDigits.forEach((k, v) => s = s.replaceAll(k, v));
    s = s.replaceAll('٫', '.').replaceAllMapped(RegExp(r'(\d),(\d)'), (m) => '${m[1]}.${m[2]}');
    s = s.replaceAll(RegExp(r'[،,؛;!?؟]'), ' ');
    s = s.replaceAll('×', ' x ').replaceAll('*', ' x ');
    // Split digits glued to Arabic words ("80كيلو").
    s = s.replaceAllMapped(RegExp(r'(\d)([^\d\s.x])'), (m) => '${m[1]} ${m[2]}');
    return _wordsToNumbers(s);
  }

  static String _wordsToNumbers(String s) {
    final tokens = s.split(RegExp(r'\s+')).where((t) => t.isNotEmpty).toList();
    final out = <String>[];
    double? acc;

    double? valueOf(String t) {
      if (_arWords.containsKey(t)) return _arWords[t];
      if (_enWords.containsKey(t)) return _enWords[t];
      if (t.startsWith('و') && t.length > 1 && _arWords.containsKey(t.substring(1))) {
        return _arWords[t.substring(1)];
      }
      return null;
    }

    void flush() {
      if (acc != null) {
        final v = acc!;
        out.add(v == v.roundToDouble() ? v.toInt().toString() : v.toString());
        acc = null;
      }
    }

    for (var i = 0; i < tokens.length; i++) {
      final t = tokens[i];
      // English "and a half" / "and" connectors inside a number.
      if (acc != null && (t == 'and' || t == 'a') && i + 1 < tokens.length) {
        final next = tokens[i + 1];
        if (_enWords.containsKey(next) || next == 'a') continue;
      }
      final v = valueOf(t);
      final numeric = double.tryParse(t);
      if (v != null) {
        if (t == 'hundred' && acc != null) {
          acc = acc! * 100;
        } else {
          acc = (acc ?? 0) + v;
        }
        continue;
      }
      if (numeric != null && acc == null && i + 1 < tokens.length) {
        // "80 ونص" → 80.5
        final next = tokens[i + 1];
        if (next == 'ونص' || next == 'ونصف') {
          out.add((numeric + 0.5).toString());
          i++;
          continue;
        }
      }
      flush();
      out.add(t);
    }
    flush();
    return out.join(' ');
  }

  static ParsedSet? parse(String input) {
    final s = normalize(input);
    double? weight;
    int? reps;
    double? rpe;
    const num = r'(\d+(?:\.\d+)?)';

    final rpeM = RegExp('$_rpeWords\\s*$num').firstMatch(s);
    var rest = s;
    if (rpeM != null) {
      rpe = double.tryParse(rpeM.group(1)!);
      rest = rest.replaceRange(rpeM.start, rpeM.end, ' ');
    }

    final bodyweight = RegExp(r'(bodyweight|body weight|وزن الجسم|وزن جسم)').hasMatch(rest);

    final wM = RegExp('$num\\s*$_weightUnits(?![\\p{L}])', unicode: true).firstMatch(rest);
    if (wM != null) {
      weight = double.tryParse(wM.group(1)!);
      rest = rest.replaceRange(wM.start, wM.end, ' ');
    }
    final rM = RegExp('$num\\s*$_repUnits').firstMatch(rest) ??
        RegExp('$_repUnits\\s*$num').firstMatch(rest);
    if (rM != null) {
      reps = double.tryParse(rM.group(1)!)?.round();
      rest = rest.replaceRange(rM.start, rM.end, ' ');
    }

    if (weight == null || reps == null) {
      final pair = RegExp('$num\\s*(?:x|في|بـ|ب|for|at)\\s*$num').firstMatch(rest);
      if (pair != null && weight == null && reps == null) {
        final a = double.parse(pair.group(1)!);
        final b = double.parse(pair.group(2)!);
        final at = RegExp(r'\s(at|for)\s').hasMatch(rest.substring(pair.start, pair.end));
        // "10 at 80" → reps first; otherwise weight first ("80 x 10", "80 في 10").
        if (at && rest.substring(pair.start, pair.end).contains('at')) {
          reps = a.round();
          weight = b;
        } else {
          weight = a;
          reps = b.round();
        }
        rest = rest.replaceRange(pair.start, pair.end, ' ');
      }
    }

    if (weight == null || reps == null) {
      final bare = RegExp(num).allMatches(rest).map((m) => double.parse(m.group(1)!)).toList();
      if (weight == null && reps == null && bare.length >= 2) {
        weight = bare[0];
        reps = bare[1].round();
      } else if (weight == null && reps != null && bare.isNotEmpty) {
        weight = bare.first;
      } else if (reps == null && weight != null && bare.isNotEmpty) {
        reps = bare.first.round();
      }
    }

    if (bodyweight && reps == null) {
      final bare = RegExp(num).firstMatch(rest);
      if (bare != null) reps = double.parse(bare.group(1)!).round();
    }
    if (bodyweight) weight ??= 0;

    if (weight == null || reps == null || reps <= 0 || reps > 100 || weight < 0 || weight > 700) return null;
    if (rpe != null && (rpe < 1 || rpe > 10)) rpe = null;
    return ParsedSet(weight, reps, rpe: rpe);
  }
}
