/// Glue between the UI and the pure PDF builder: fonts from assets, temp file, share sheet.
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/context_ext.dart';
import 'report_data.dart';
import 'report_pdf.dart';

pw.Font? _cairo, _inter;

/// Bundled report fonts (variable TTFs; the `pdf` package renders their default instance).
Future<({pw.Font cairo, pw.Font inter})> loadReportFonts() async {
  _cairo ??= pw.Font.ttf(await rootBundle.load('assets/fonts/Cairo-Variable.ttf'));
  _inter ??= pw.Font.ttf(await rootBundle.load('assets/fonts/Inter-Variable.ttf'));
  return (cairo: _cairo!, inter: _inter!);
}

/// Gathers the data for [range], renders the PDF in [lang] and returns the file.
Future<File> createProgressReportFile(AppDatabase db, ReportRange range, {required String lang, DateTime? now}) async {
  final (from, to) = range.resolve(now ?? DateTime.now());
  final data = await gatherReportData(db, from: from, to: to, kind: range.kind, lang: lang, now: now);
  final fonts = await loadReportFonts();
  final Uint8List bytes = lang == 'ar'
      ? await buildProgressReportPdf(data, lang: 'ar', font: fonts.cairo)
      : await buildProgressReportPdf(data, lang: lang, font: fonts.inter, arabicFont: fonts.cairo);
  final dir = await getTemporaryDirectory();
  final name = 'IronMind_${range.kind.name}_${ymd(from)}_${ymd(to)}.pdf';
  final file = File(p.join(dir.path, name));
  await file.writeAsBytes(bytes, flush: true);
  return file;
}

/// Bottom sheet: pick week / month → build → share.
Future<void> showReportExportSheet(BuildContext context, WidgetRef ref) async {
  final l = context.l10n;
  final range = await showModalBottomSheet<ReportRange>(
    context: context,
    showDragHandle: true,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 8),
            child: Text(l.progReportChoose, style: ctx.text.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          ),
          for (final (r, label, icon) in [
            (ReportRange.thisWeek, l.progReportThisWeek, Symbols.view_week_rounded),
            (ReportRange.lastWeek, l.progReportLastWeek, Symbols.history_rounded),
            (ReportRange.thisMonth, l.progReportThisMonth, Symbols.calendar_month_rounded),
            (ReportRange.lastMonth, l.progReportLastMonth, Symbols.event_repeat_rounded),
          ])
            ListTile(
              minTileHeight: 56,
              leading: Icon(icon, color: AppColors.primary),
              title: Text(label),
              subtitle: Text(_rangeLabel(ctx, r)),
              onTap: () => Navigator.pop(ctx, r),
            ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
  if (range == null || !context.mounted) return;

  final lang = context.lang;
  final db = ref.read(databaseProvider);
  final box = context.findRenderObject() as RenderBox?;
  final origin = box == null ? null : box.localToGlobal(Offset.zero) & box.size;
  final nav = Navigator.of(context, rootNavigator: true);
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => PopScope(
      canPop: false,
      child: AlertDialog(
        content: Row(children: [
          const CircularProgressIndicator(),
          const SizedBox(width: 20),
          Expanded(child: Text(l.progReportGenerating)),
        ]),
      ),
    ),
  );
  try {
    final file = await createProgressReportFile(db, range, lang: lang);
    nav.pop();
    await SharePlus.instance.share(ShareParams(
      files: [XFile(file.path, mimeType: 'application/pdf')],
      subject: l.progReportShareSubject,
      title: l.progReportShareSubject,
      sharePositionOrigin: origin,
    ));
  } catch (e) {
    nav.pop();
    if (context.mounted) context.snack('${l.progReportFailed}: $e');
  }
}

String _rangeLabel(BuildContext context, ReportRange r) {
  final (from, to) = r.resolve(DateTime.now());
  final loc = MaterialLocalizations.of(context);
  return '${loc.formatShortMonthDay(from)} – ${loc.formatShortMonthDay(to)}';
}
