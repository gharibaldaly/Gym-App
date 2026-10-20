import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:ironmind/core/calc/strength_calc.dart';
import 'package:ironmind/features/progress/report/report_data.dart';
import 'package:ironmind/features/progress/report/report_pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'prog_seed.dart';

pw.Font _font(String file) => pw.Font.ttf(File('assets/fonts/$file').readAsBytesSync().buffer.asByteData());

void main() {
  final now = DateTime(2026, 10, 20, 12);

  test('report ranges: Saturday-based weeks and calendar months', () {
    expect(ReportRange.thisWeek.resolve(now), (DateTime(2026, 10, 17), DateTime(2026, 10, 23)));
    expect(ReportRange.lastWeek.resolve(now), (DateTime(2026, 10, 10), DateTime(2026, 10, 16)));
    expect(ReportRange.thisMonth.resolve(now), (DateTime(2026, 10, 1), DateTime(2026, 10, 31)));
    expect(ReportRange.lastMonth.resolve(DateTime(2026, 1, 5)), (DateTime(2025, 12, 1), DateTime(2025, 12, 31)));
    expect(ReportRange.lastWeek.kind, ReportKind.weekly);
    expect(ReportRange.thisMonth.kind, ReportKind.monthly);
  });

  test('gatherReportData aggregates a week from the DB', () async {
    final db = memoryDb();
    addTearDown(db.close);
    await seedFortnight(db);

    final r = await gatherReportData(db,
        from: DateTime(2026, 10, 10), to: DateTime(2026, 10, 16), kind: ReportKind.weekly, lang: 'ar', now: now);

    // Sat 10 completed, Mon 12 missed (no session), Wed 14 missed row.
    expect(r.sessionsDone, 1);
    expect(r.sessionsMissed, 2);
    expect(r.adherencePct, closeTo(100 / 3, 0.01));
    expect(r.sessions.single.name, 'Push A');
    expect(r.sessions.single.prs, 2);
    expect(r.totalVolume, 82.5 * 8 + 80 * 9);
    expect(r.prs.map((p) => p.types).toList(), [
      {PrType.weight, PrType.e1rm},
      {PrType.reps},
    ]);
    expect(r.prs.first.exercise, 'بنش برس بالبار');
    expect(r.avgCalories, 2300);
    expect(r.avgProtein, 150);
    expect(r.calorieTarget, 2500);
    expect(r.weightChange, closeTo(-0.4, 1e-9));
    expect(r.avgSleepHours, 7.5);
    expect(r.avgRecovery, 72);
    expect(r.bodyMetrics.firstWhere((b) => b.date == DateTime(2026, 10, 10)).waistCm, 84);
    expect(r.muscles.single.effectiveSets, 2);
    expect(r.coachSummary, contains('البنش'));

    final en = await gatherReportData(db,
        from: DateTime(2026, 10, 3), to: DateTime(2026, 10, 9), kind: ReportKind.weekly, lang: 'en', now: now);
    expect(en.coachSummary, isNull);
    expect(en.prs, isEmpty);
    expect(en.sessions.length, 3);
    expect(en.adherence.completed, 2);
    expect(en.adherence.partial, 1);
  });

  test('builds Arabic (Cairo variable font, RTL) and English PDFs', () async {
    final db = memoryDb();
    addTearDown(db.close);
    await seedFortnight(db);
    final cairo = _font('Cairo-Variable.ttf');
    final inter = _font('Inter-Variable.ttf');

    final ar = await buildProgressReportPdf(
      await gatherReportData(db,
          from: DateTime(2026, 10, 10), to: DateTime(2026, 10, 16), kind: ReportKind.weekly, lang: 'ar', now: now),
      lang: 'ar',
      font: cairo,
    );
    final en = await buildProgressReportPdf(
      await gatherReportData(db,
          from: DateTime(2026, 10, 1), to: DateTime(2026, 10, 31), kind: ReportKind.monthly, lang: 'en', now: now),
      lang: 'en',
      font: inter,
      arabicFont: cairo,
    );
    for (final bytes in [ar, en]) {
      expect(bytes, isNotEmpty);
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    }
    final out = Platform.environment['PROG_PDF_OUT'];
    if (out != null) {
      File('$out/report_ar.pdf').writeAsBytesSync(ar);
      File('$out/report_en.pdf').writeAsBytesSync(en);
    }
  });

  test('empty database still produces a valid PDF', () async {
    final db = memoryDb();
    addTearDown(db.close);
    final data = await gatherReportData(db,
        from: DateTime(2026, 10, 10), to: DateTime(2026, 10, 16), kind: ReportKind.weekly, lang: 'ar', now: now);
    expect(data.sessionsDone, 0);
    expect(data.adherencePct, isNull);
    final bytes = await buildProgressReportPdf(data, lang: 'ar', font: _font('Cairo-Variable.ttf'));
    expect(bytes, isNotEmpty);
  });

  test('pdfSafeArabic adds a hair space only after tailed Arabic word ends', () {
    expect(pdfSafeArabic('تقرير التقدم'), 'تقرير\u200A التقدم');
    expect(pdfSafeArabic('كبير جدا'), 'كبير\u200A جدا');
    expect(pdfSafeArabic('Bench Press 80'), 'Bench Press 80');
    expect(containsArabic('Bench بنش'), isTrue);
    expect(containsArabic('Bench'), isFalse);
  });
}
