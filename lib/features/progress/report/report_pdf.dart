/// Pure PDF builder for the weekly / monthly progress report (Arabic RTL + English).
library;

import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' show Locale;

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/calc/strength_calc.dart';
import '../../../l10n/gen/app_localizations.dart';
import 'report_data.dart';

const _ink = PdfColor.fromInt(0xFF141414);
const _muted = PdfColor.fromInt(0xFF6E6E6E);
const _accent = PdfColor.fromInt(0xFF1E8C0B);
const _neon = PdfColor.fromInt(0xFF39FF14);
const _black = PdfColor.fromInt(0xFF0A0A0A);
const _line = PdfColor.fromInt(0xFFE3E3E3);
const _soft = PdfColor.fromInt(0xFFF3F6F2);
const _danger = PdfColor.fromInt(0xFFD93636);
const _warn = PdfColor.fromInt(0xFFD99A00);
const _info = PdfColor.fromInt(0xFF1F8FD6);

final _arabicChars = RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]');
final _arabicTailWordEnd = RegExp(r'([\u0631\u0632\u0698\u0648\u0624\u064A\u0649\u0626\u06CC\u06D2])(?=[ \t\n]|$)');

final _arabicBeforeLatin = RegExp(r'([\u0600-\u06FF])(?= [0-9A-Za-z(+\-])');

bool containsArabic(String s) => _arabicChars.hasMatch(s);

/// Works around the `pdf` package placing RTL words by their ink box: final
/// forms whose tail reaches past the glyph advance (ر ز و ي ى ئ ؤ) swallow the
/// following space; the same happens before a number / Latin run. A hair space
/// (U+200A, no ink) after such word ends restores a visible gap.
String pdfSafeArabic(String s) => s
    .replaceAllMapped(_arabicTailWordEnd, (m) => '${m[1]}\u200A')
    .replaceAllMapped(_arabicBeforeLatin, (m) => '${m[1]}\u200A');

/// Builds the report PDF. [font] is the main font (Cairo for Arabic, Inter for
/// English). [arabicFont] (Cairo) is used for any Arabic text inside an English
/// report (exercise / meal names, coach text); in an Arabic report [font] is used.
Future<Uint8List> buildProgressReportPdf(
  ReportData data, {
  required String lang,
  required pw.Font font,
  pw.Font? arabicFont,
}) async {
  await initializeDateFormatting(lang);
  final arFont = lang == 'ar' ? font : (arabicFont ?? font);
  final fallback = [if (arFont != font) arFont];
  final b = _ReportBuilder(data, lang, lookupAppLocalizations(Locale(lang)), font, arFont);
  final doc = pw.Document(
    title: b.title,
    author: 'IronMind',
    creator: 'IronMind',
    theme: pw.ThemeData.withFont(base: font, bold: font, italic: font, boldItalic: font, fontFallback: fallback),
  );
  doc.addPage(pw.MultiPage(
    pageFormat: PdfPageFormat.a4,
    margin: const pw.EdgeInsets.fromLTRB(32, 28, 32, 28),
    textDirection: b.rtl ? pw.TextDirection.rtl : pw.TextDirection.ltr,
    maxPages: 60,
    footer: b.footer,
    build: (_) => b.build(),
  ));
  return doc.save();
}

class _ReportBuilder {
  final ReportData d;
  final String lang;
  final AppLocalizations l;
  final bool rtl;
  final DateFormat _dayFmt, _rangeFmt, _axisFmt;
  final NumberFormat _int = NumberFormat('#,##0', 'en');
  final pw.Font font, arFont;

  _ReportBuilder(this.d, this.lang, this.l, this.font, this.arFont)
      : rtl = lang == 'ar',
        _dayFmt = (DateFormat('EEE d/M', lang)..useNativeDigits = false),
        _rangeFmt = (DateFormat('d MMMM yyyy', lang)..useNativeDigits = false),
        _axisFmt = (DateFormat('d/M', 'en'));

  String get title => d.kind == ReportKind.weekly ? l.progPdfWeeklyTitle : l.progPdfMonthlyTitle;

  // ---------------------------------------------------------------- text ----

  pw.Widget t(
    String s, {
    double size = 10,
    PdfColor color = _ink,
    pw.TextAlign? align,
    int? maxLines,
    double? lineSpacing,
  }) {
    // Arabic runs are shaped only when the span's own font is the Arabic one and
    // the direction is RTL; Latin/number-only strings stay LTR (RTL layout would
    // shift their first glyph past the box edge).
    final ar = containsArabic(s);
    return pw.Text(
      ar ? pdfSafeArabic(s) : s,
      style: pw.TextStyle(
        fontSize: size,
        color: color,
        lineSpacing: lineSpacing,
        font: ar ? arFont : font,
        fontFallback: [if (arFont != font) ar ? font : arFont],
      ),
      textDirection: ar ? pw.TextDirection.rtl : pw.TextDirection.ltr,
      textAlign: align ?? (rtl ? pw.TextAlign.right : pw.TextAlign.left),
      maxLines: maxLines,
      overflow: maxLines == null ? null : pw.TextOverflow.clip,
    );
  }

  String n(num v, {int decimals = 1}) {
    if (v == v.roundToDouble()) return _int.format(v);
    final s = v.toStringAsFixed(decimals);
    return s.contains('.') ? s.replaceFirst(RegExp(r'\.?0+$'), '') : s;
  }

  String signed(num v, {int decimals = 1}) => '${v > 0 ? '+' : v < 0 ? '−' : ''}${n(v.abs(), decimals: decimals)}';

  // --------------------------------------------------------------- layout ----

  List<pw.Widget> build() => [
        _header(),
        pw.SizedBox(height: 14),
        _group(l.progPdfSummary, pw.Column(children: _summary())),
        pw.SizedBox(height: 14),
        _sectionTitle(l.progPdfCoachSummary),
        ..._coach(),
        pw.SizedBox(height: 14),
        _group(l.progPdfMuscleChart, _muscleBars()),
        pw.SizedBox(height: 14),
        _group(l.progPdfCaloriesChart, _caloriesChart()),
        pw.SizedBox(height: 14),
        _group(l.progPdfWeightChart, _weightChart()),
        pw.SizedBox(height: 14),
        _sectionTitle(l.progPdfSessionsTable),
        _sessionsTable(),
        pw.SizedBox(height: 14),
        _sectionTitle(l.progPdfPrs),
        _prsTable(),
        pw.SizedBox(height: 14),
        _sectionTitle(l.progPdfBodyTable),
        _bodyTable(),
      ];

  /// Title + content kept on the same page.
  pw.Widget _group(String title, pw.Widget child) => pw.Inseparable(
        child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.stretch, children: [_sectionTitle(title), child]),
      );

  pw.Widget footer(pw.Context ctx) => pw.Container(
        margin: const pw.EdgeInsets.only(top: 10),
        padding: const pw.EdgeInsets.only(top: 6),
        decoration: const pw.BoxDecoration(border: pw.Border(top: pw.BorderSide(color: _line, width: .6))),
        child: pw.Row(children: [
          pw.Expanded(child: t('IronMind · $title', size: 8, color: _muted)),
          t(l.progPdfPage('${ctx.pageNumber}', '${ctx.pagesCount}'), size: 8, color: _muted),
        ]),
      );

  pw.Widget _header() => pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: const pw.BoxDecoration(color: _black, borderRadius: pw.BorderRadius.all(pw.Radius.circular(10))),
        child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.stretch, children: [
          pw.Row(children: [
            pw.Expanded(child: t('IronMind', size: 11, color: _neon)),
            t(l.progPdfGenerated(_rangeFmt.format(d.generatedAt)), size: 8, color: PdfColors.grey400),
          ]),
          pw.SizedBox(height: 6),
          t(title, size: 22, color: PdfColors.white),
          pw.SizedBox(height: 2),
          t('${_rangeFmt.format(d.from)}  —  ${_rangeFmt.format(d.to)}', size: 11, color: PdfColors.grey300),
        ]),
      );

  pw.Widget _sectionTitle(String s) => pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 6),
        child: pw.Row(children: [
          pw.Container(width: 4, height: 14, color: _accent),
          pw.SizedBox(width: 6),
          pw.Expanded(child: t(s, size: 13)),
        ]),
      );

  pw.Widget _empty() => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 6),
        child: t(l.progPdfNone, size: 9, color: _muted),
      );

  // -------------------------------------------------------------- summary ----

  List<pw.Widget> _summary() {
    final tiles = <pw.Widget>[
      _tile(l.progPdfSessionsDone, '${d.sessionsDone}'),
      _tile(l.progPdfSessionsMissed, '${d.sessionsMissed}', color: d.sessionsMissed > 0 ? _danger : _ink),
      _tile(l.progPdfAdherence, d.adherencePct == null ? '—' : '${d.adherencePct!.round()}%',
          color: _adherenceColor(d.adherencePct)),
      _tile(l.progPdfVolume, '${_int.format(d.totalVolume.round())} ${_kg()}'),
      _tile(l.progPdfPrs, '${d.prs.length}', color: d.prs.isNotEmpty ? _accent : _ink),
      _tile(
        l.progPdfAvgCalories,
        d.avgCalories == null ? '—' : _int.format(d.avgCalories!.round()),
        sub: d.calorieTarget == null ? null : l.progPdfTarget(_int.format(d.calorieTarget)),
      ),
      _tile(
        l.progPdfAvgProtein,
        d.avgProtein == null ? '—' : '${d.avgProtein!.round()} ${_g()}',
        sub: d.proteinTarget == null ? null : l.progPdfTarget('${d.proteinTarget} ${_g()}'),
      ),
      _tile(
        l.progPdfWeightChange,
        d.weightChange == null ? '—' : '${signed(d.weightChange!)} ${_kg()}',
        sub: d.weightChange == null ? null : l.progPdfFromTo(n(d.weightStart!), '${n(d.weightEnd!)} ${_kg()}'),
      ),
      _tile(l.progPdfAvgSleep, d.avgSleepHours == null ? '—' : '${n(d.avgSleepHours!)} ${_h()}'),
      _tile(l.progPdfAvgRecovery, d.avgRecovery == null ? '—' : '${d.avgRecovery!.round()}/100'),
    ];
    const perRow = 4;
    final rows = <pw.Widget>[];
    for (var i = 0; i < tiles.length; i += perRow) {
      final chunk = tiles.sublist(i, math.min(i + perRow, tiles.length));
      rows.add(pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 6),
        child: pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          for (var j = 0; j < perRow; j++) ...[
            if (j > 0) pw.SizedBox(width: 6),
            pw.Expanded(child: j < chunk.length ? chunk[j] : pw.SizedBox()),
          ],
        ]),
      ));
    }
    return rows;
  }

  PdfColor _adherenceColor(double? p) {
    if (p == null) return _ink;
    if (p >= 80) return _accent;
    if (p >= 50) return _warn;
    return _danger;
  }

  pw.Widget _tile(String label, String value, {String? sub, PdfColor color = _ink}) => pw.Container(
        height: 58,
        padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: const pw.BoxDecoration(color: _soft, borderRadius: pw.BorderRadius.all(pw.Radius.circular(6))),
        child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.stretch, children: [
          t(label, size: 8, color: _muted, maxLines: 1),
          pw.SizedBox(height: 2),
          t(value, size: 14, color: color, maxLines: 1),
          if (sub != null) t(sub, size: 7, color: _muted, maxLines: 1),
        ]),
      );

  String _kg() => l.kg;
  String _g() => l.gramsShort;
  String _h() => l.hoursShort;
  String _min() => l.minutesShort;

  // ---------------------------------------------------------------- coach ----

  List<pw.Widget> _coach() {
    final text = d.coachSummary;
    if (text == null) return [t(l.progPdfNoCoachSummary, size: 9, color: _muted)];
    final paragraphs = _plain(text).split(RegExp(r'\n\s*\n|\n')).map((p) => p.trim()).where((p) => p.isNotEmpty);
    return [
      for (final p in paragraphs)
        pw.Padding(padding: const pw.EdgeInsets.only(bottom: 4), child: t(p, size: 10, lineSpacing: 2)),
    ];
  }

  /// Strips the light markdown the coach uses (headings, bold, bullets).
  String _plain(String s) => s
      .replaceAll(RegExp(r'\*\*|__|`'), '')
      .replaceAllMapped(RegExp(r'^\s*#{1,6}\s*', multiLine: true), (_) => '')
      .replaceAllMapped(RegExp(r'^\s*[-*]\s+', multiLine: true), (_) => '• ');

  // --------------------------------------------------------------- charts ----

  pw.Widget _muscleBars() {
    final rows = d.muscles.where((m) => m.volume > 0 || m.effectiveSets > 0).take(12).toList();
    if (rows.isEmpty) return _empty();
    final maxV = rows.map((m) => m.volume).fold(0.0, math.max);
    return pw.Column(children: [
      for (final m in rows)
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 2),
          child: pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
            pw.SizedBox(width: 90, child: t(m.muscle, size: 9, maxLines: 1)),
            pw.SizedBox(width: 6),
            pw.Expanded(child: _bar(maxV <= 0 ? 0 : m.volume / maxV)),
            pw.SizedBox(width: 6),
            pw.SizedBox(
              width: 92,
              child: t('${_int.format(m.volume.round())} · ${m.effectiveSets} ${l.progPdfSets}',
                  size: 8, color: _muted, maxLines: 1),
            ),
          ]),
        ),
    ]);
  }

  /// Horizontal bar filling [fraction] of the available width (grows from the start side).
  pw.Widget _bar(double fraction) {
    final f = (fraction.clamp(0.0, 1.0) * 1000).round();
    return pw.Container(
      height: 9,
      decoration: const pw.BoxDecoration(color: _soft, borderRadius: pw.BorderRadius.all(pw.Radius.circular(3))),
      child: pw.Row(children: [
        if (f > 0)
          pw.Expanded(
            flex: f,
            child: pw.Container(
              decoration: const pw.BoxDecoration(color: _accent, borderRadius: pw.BorderRadius.all(pw.Radius.circular(3))),
            ),
          ),
        if (f < 1000) pw.Expanded(flex: 1000 - f, child: pw.SizedBox()),
      ]),
    );
  }

  pw.Widget _legend(List<(PdfColor, String)> items) => pw.Padding(
        padding: const pw.EdgeInsets.only(top: 4),
        child: pw.Row(children: [
          for (final (c, s) in items) ...[
            pw.Container(width: 8, height: 8, color: c),
            pw.SizedBox(width: 4),
            t(s, size: 8, color: _muted),
            pw.SizedBox(width: 12),
          ],
        ]),
      );

  /// Every [step]th label so long months stay readable.
  List<String> _axisLabels(List<DateTime> days) {
    final step = math.max(1, (days.length / 8).ceil());
    return [
      '',
      for (var i = 0; i < days.length; i++) i % step == 0 || i == days.length - 1 ? _axisFmt.format(days[i]) : '',
      '',
    ];
  }

  List<DateTime> _allDays() {
    final out = <DateTime>[];
    for (var x = d.from; !x.isAfter(d.to); x = DateTime(x.year, x.month, x.day + 1)) {
      out.add(x);
    }
    return out;
  }

  pw.Widget _caloriesChart() {
    if (d.nutrition.isEmpty) return _empty();
    final days = _allDays();
    final byDay = {for (final n in d.nutrition) n.date: n};
    final eaten = <pw.PointChartValue>[];
    final target = <pw.PointChartValue>[];
    var maxV = 0.0;
    for (var i = 0; i < days.length; i++) {
      final nd = byDay[days[i]];
      if (nd != null) {
        eaten.add(pw.PointChartValue(i + 1.0, nd.calories));
        maxV = math.max(maxV, nd.calories);
      }
      final tg = nd?.calorieTarget ?? d.calorieTarget;
      if (tg != null) {
        target.add(pw.PointChartValue(i + 1.0, tg.toDouble()));
        maxV = math.max(maxV, tg.toDouble());
      }
    }
    final ticks = _niceTicks(0, maxV);
    final barWidth = math.max(3.0, math.min(18.0, 380 / days.length));
    return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.stretch, children: [
      pw.Directionality(
        textDirection: pw.TextDirection.ltr,
        child: pw.SizedBox(
          height: 150,
          child: pw.Chart(
            grid: pw.CartesianGrid(
              xAxis: pw.FixedAxis.fromStrings(_axisLabels(days), textStyle: const pw.TextStyle(fontSize: 7, color: _muted)),
              yAxis: pw.FixedAxis(ticks,
                  format: (v) => _int.format(v),
                  divisions: true,
                  divisionsColor: _line,
                  textStyle: const pw.TextStyle(fontSize: 7, color: _muted)),
            ),
            datasets: [
              pw.BarDataSet(data: eaten, color: _accent, width: barWidth),
              if (target.length > 1)
                pw.LineDataSet(data: target, color: _danger, lineWidth: 1.2, drawPoints: false),
            ],
          ),
        ),
      ),
      _legend([(_accent, l.progPdfEaten), if (target.length > 1) (_danger, l.progTarget)]),
    ]);
  }

  pw.Widget _weightChart() {
    if (d.weights.length < 2) {
      if (d.weights.isEmpty) return _empty();
      return t('${_dayFmt.format(d.weights.first.date)}: ${n(d.weights.first.value)} ${_kg()}', size: 10);
    }
    final days = _allDays();
    final index = {for (var i = 0; i < days.length; i++) days[i]: i + 1.0};
    final pts = [
      for (final w in d.weights)
        if (index[w.date] != null) pw.PointChartValue(index[w.date]!, w.value),
    ];
    final minV = d.weights.map((w) => w.value).reduce(math.min);
    final maxV = d.weights.map((w) => w.value).reduce(math.max);
    final ticks = _niceTicks(minV - 0.5, maxV + 0.5, fromZero: false);
    return pw.Directionality(
      textDirection: pw.TextDirection.ltr,
      child: pw.SizedBox(
        height: 140,
        child: pw.Chart(
          grid: pw.CartesianGrid(
            xAxis: pw.FixedAxis.fromStrings(_axisLabels(days), textStyle: const pw.TextStyle(fontSize: 7, color: _muted)),
            yAxis: pw.FixedAxis(ticks,
                format: (v) => n(v),
                divisions: true,
                divisionsColor: _line,
                textStyle: const pw.TextStyle(fontSize: 7, color: _muted)),
          ),
          datasets: [
            pw.LineDataSet(
              data: pts,
              color: _info,
              lineWidth: 1.6,
              pointSize: 2,
              drawSurface: true,
              surfaceColor: _info,
              surfaceOpacity: .08,
            ),
          ],
        ),
      ),
    );
  }

  /// ~4–6 round tick values covering [lo]..[hi].
  List<double> _niceTicks(double lo, double hi, {bool fromZero = true}) {
    if (fromZero) lo = 0;
    if (hi <= lo) hi = lo + 1;
    final raw = (hi - lo) / 4;
    final mag = math.pow(10, (math.log(raw) / math.ln10).floor()).toDouble();
    final norm = raw / mag;
    final step = (norm <= 1 ? 1 : norm <= 2 ? 2 : norm <= 2.5 ? 2.5 : norm <= 5 ? 5 : 10) * mag;
    final start = (lo / step).floor() * step;
    final out = <double>[];
    for (var v = start; v < hi + step * 0.999; v += step) {
      out.add(double.parse(v.toStringAsFixed(4)));
    }
    if (out.length < 2) out.add(start + step);
    return out;
  }

  // --------------------------------------------------------------- tables ----

  pw.Widget _table(List<String> headers, List<List<String>> rows, {Map<int, double>? flex}) {
    if (rows.isEmpty) return _empty();
    List<T> order<T>(List<T> l) => rtl ? l.reversed.toList() : l;
    final n = headers.length;
    final widths = <int, pw.TableColumnWidth>{
      for (var i = 0; i < n; i++) i: pw.FlexColumnWidth(flex?[rtl ? n - 1 - i : i] ?? 1),
    };
    pw.Widget cell(String s, {bool header = false}) => pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 4),
          child: t(s, size: header ? 8 : 8.5, color: header ? _muted : _ink),
        );
    return pw.Table(
      columnWidths: widths,
      border: const pw.TableBorder(horizontalInside: pw.BorderSide(color: _line, width: .5)),
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: _soft),
          repeat: true,
          children: order([for (final h in headers) cell(h, header: true)]),
        ),
        for (final r in rows) pw.TableRow(children: order([for (final c in r) cell(c)])),
      ],
    );
  }

  String _status(String s) => switch (s) {
        'completed' => l.progLegendCompleted,
        'partial' => l.progLegendPartial,
        'missed' => l.progLegendMissed,
        _ => l.progStatusInProgress,
      };

  pw.Widget _sessionsTable() => _table(
        [l.progPdfDate, l.progPdfName, l.progPdfStatus, l.progPdfDuration, l.progPdfSets, l.progPdfVolume, l.progPrBadge],
        [
          for (final s in d.sessions)
            [
              _dayFmt.format(s.date),
              s.name,
              _status(s.status),
              s.durationMin == null ? '—' : '${s.durationMin} ${_min()}',
              '${s.sets}',
              '${_int.format(s.volume.round())} ${_kg()}',
              s.prs == 0 ? '—' : '${s.prs}',
            ],
        ],
        flex: {0: 1.2, 1: 2.4, 2: 1.1, 3: 0.9, 4: 0.7, 5: 1.3, 6: 0.5},
      );

  String _prType(PrType p) => switch (p) {
        PrType.weight => l.progPdfTypeWeight,
        PrType.reps => l.progPdfTypeReps,
        PrType.e1rm => l.progPdfTypeE1rm,
      };

  pw.Widget _prsTable() => _table(
        [l.progPdfDate, l.progPdfExercise, l.progPdfType, l.progPdfSet, l.progPdfTypeE1rm],
        [
          for (final p in d.prs)
            [
              _dayFmt.format(p.date),
              p.exercise,
              (p.types.toList()..sort((a, b) => a.index.compareTo(b.index))).map(_prType).join(' · '),
              '${n(p.weightKg)} ${_kg()} × ${p.reps}',
              '${n(p.e1rm)} ${_kg()}',
            ],
        ],
        flex: {0: 1.1, 1: 2.6, 2: 1.6, 3: 1.3, 4: 1.0},
      );

  pw.Widget _bodyTable() {
    final cols = <(String, double? Function(ReportBodyRow))>[
      ('${l.progDayWeight} (${_kg()})', (r) => r.weightKg),
      ('${l.progMeasureWaist} (${l.cm})', (r) => r.waistCm),
      ('${l.progMeasureChest} (${l.cm})', (r) => r.chestCm),
      ('${l.progMeasureArm} (${l.cm})', (r) => r.armCm),
      ('${l.progMeasureThigh} (${l.cm})', (r) => r.thighCm),
      ('${l.progMeasureNeck} (${l.cm})', (r) => r.neckCm),
      ('${l.progMeasureHips} (${l.cm})', (r) => r.hipsCm),
      (l.progMeasureBodyFat, (r) => r.bodyFatPct),
    ].where((c) => d.bodyMetrics.any((r) => c.$2(r) != null)).toList();
    if (cols.isEmpty) return _empty();
    return _table(
      [l.progPdfDate, for (final c in cols) c.$1],
      [
        for (final r in d.bodyMetrics)
          [_dayFmt.format(r.date), for (final c in cols) c.$2(r) == null ? '—' : n(c.$2(r)!)],
      ],
      flex: {0: 1.3},
    );
  }
}
