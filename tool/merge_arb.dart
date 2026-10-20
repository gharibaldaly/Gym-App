// Merges lib/l10n/parts/<feature>_<locale>.arb fragments into
// lib/l10n/app_<locale>.arb (the files flutter gen-l10n reads).
// Run: dart run tool/merge_arb.dart && flutter gen-l10n
import 'dart:convert';
import 'dart:io';

void main() {
  final dir = Directory('lib/l10n/parts');
  final byLocale = <String, Map<String, dynamic>>{};
  final owner = <String, String>{};
  var failed = false;
  final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.arb')).toList()
    ..sort((a, b) => a.path.compareTo(b.path));
  for (final f in files) {
    final name = f.uri.pathSegments.last.replaceAll('.arb', '');
    final locale = name.split('_').last;
    final Map<String, dynamic> json;
    try {
      json = jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;
    } catch (e) {
      stderr.writeln('Invalid JSON in ${f.path}: $e');
      failed = true;
      continue;
    }
    final target = byLocale.putIfAbsent(locale, () => {'@@locale': locale});
    json.forEach((k, v) {
      if (k == '@@locale') return;
      final id = '$locale:$k';
      if (target.containsKey(k) && owner[id] != f.path) {
        stderr.writeln('Duplicate key "$k" in ${f.path} (already in ${owner[id]})');
        failed = true;
        return;
      }
      target[k] = v;
      owner[id] = f.path;
    });
  }
  final en = byLocale['en'] ?? {};
  for (final entry in byLocale.entries) {
    if (entry.key == 'en') continue;
    for (final k in en.keys.where((k) => !k.startsWith('@'))) {
      if (!entry.value.containsKey(k)) {
        stderr.writeln('Missing "${entry.key}" translation for "$k"');
        failed = true;
      }
    }
  }
  const enc = JsonEncoder.withIndent('  ');
  byLocale.forEach((locale, map) {
    File('lib/l10n/app_$locale.arb').writeAsStringSync('${enc.convert(map)}\n');
  });
  stdout.writeln('Merged ${files.length} fragments into ${byLocale.keys.map((l) => 'app_$l.arb').join(', ')}');
  if (failed) exit(1);
}
