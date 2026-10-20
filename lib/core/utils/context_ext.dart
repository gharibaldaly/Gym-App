import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/gen/app_localizations.dart';

export '../../l10n/gen/app_localizations.dart';

extension ContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
  bool get isAr => Localizations.localeOf(this).languageCode == 'ar';
  String get lang => Localizations.localeOf(this).languageCode;
  TextTheme get text => Theme.of(this).textTheme;

  /// Picks the Arabic or English variant.
  String tr(String ar, String en) => isAr ? ar : en;

  void snack(String msg) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }
}

/// Local-midnight date for "day" columns.
DateTime dayOf(DateTime d) => DateTime(d.year, d.month, d.day);
DateTime today() => dayOf(DateTime.now());

/// Monday-based start of week.
DateTime startOfWeek(DateTime d) => dayOf(d).subtract(Duration(days: d.weekday - 1));

String ymd(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

/// "1 decimal unless whole" → 80, 82.5
String fmtNum(num v, {int maxDecimals = 1}) {
  if (v == v.roundToDouble()) return v.toInt().toString();
  return v.toStringAsFixed(maxDecimals).replaceFirst(RegExp(r'\.?0+$'), '');
}

String fmtDuration(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
  final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return h > 0 ? '$h:$m:$s' : '$m:$s';
}

/// Parses "HH:mm" → TimeOfDay (null if invalid).
TimeOfDay? parseHm(String? s) {
  if (s == null) return null;
  final p = s.split(':');
  if (p.length != 2) return null;
  final h = int.tryParse(p[0]), m = int.tryParse(p[1]);
  if (h == null || m == null) return null;
  return TimeOfDay(hour: h, minute: m);
}

String hm(TimeOfDay t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

/// Weekday label (DateTime.weekday 1=Mon … 7=Sun).
String weekdayName(BuildContext context, int weekday) {
  final l = context.l10n;
  return switch (weekday) {
    1 => l.weekdayMon,
    2 => l.weekdayTue,
    3 => l.weekdayWed,
    4 => l.weekdayThu,
    5 => l.weekdayFri,
    6 => l.weekdaySat,
    _ => l.weekdaySun,
  };
}
