import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

void main() {
  test('probe', () async {
    final cairo = pw.Font.ttf(File('assets/fonts/Cairo-Variable.ttf').readAsBytesSync().buffer.asByteData());
    final inter = pw.Font.ttf(File('assets/fonts/Inter-Variable.ttf').readAsBytesSync().buffer.asByteData());
    final doc = pw.Document(theme: pw.ThemeData.withFont(base: cairo, fontFallback: [inter]));
    final st = pw.TextStyle(font: cairo, fontSize: 18);
    doc.addPage(pw.Page(pageFormat: PdfPageFormat.a5, textDirection: pw.TextDirection.rtl, build: (c) => pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Text('تقرير التقدم', style: st),
      pw.Text('تقرير\u00A0 التقدم كبير\u00A0 جدا', style: st),
      pw.Text('تقرير\u2009 التقدم كبير\u2009 جدا', style: st),
      pw.Text('تقرير\u200A التقدم كبير\u200A جدا', style: st),
      pw.Text('تقرير\u202F التقدم كبير\u202F جدا', style: st),
      pw.Text('الوزن والعضلات زيادة الوزن ضروري جدي وعي في ', style: st),
      pw.Text('تقرير التقدم كبير جدا', style: st.copyWith(wordSpacing: 1.8)),
      pw.Text('كبير جدا', style: st),
      pw.Text('تقرير الأداء', style: st),
      pw.Text('النوم والاستشفاء', style: st),
      pw.Text('بنش برس بالبار', style: st),
      pw.Text('عريض', style: st.copyWith(renderingMode: PdfTextRenderingMode.fillAndStroke)),
      pw.Text('Bench Press 100 كجم', style: st),
      pw.Text('Bench Press', style: st.copyWith(font: inter)),
    ])));
    File('/tmp/claude-0/-home-user-Gym-App/952830a8-6591-5a88-a711-183476a8644c/scratchpad/probe.pdf').writeAsBytesSync(await doc.save());
  });
}
