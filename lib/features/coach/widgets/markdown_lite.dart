import 'package:flutter/material.dart';

final _bullet = RegExp(r'^\s*([-•*])\s+');
final _numbered = RegExp(r'^\s*(\d+)[.)]\s+');
final _heading = RegExp(r'^\s*#{1,6}\s+');

/// Minimal markdown renderer for coach text: **bold**, "- " bullets,
/// "1." numbered lines and "#" headings. Everything else is plain text.
class MarkdownLite extends StatelessWidget {
  final String text;
  final TextStyle? style;
  const MarkdownLite(this.text, {super.key, this.style});

  /// Splits a line into normal / bold spans on `**`.
  static List<InlineSpan> inlineSpans(String line, TextStyle base) {
    final parts = line.split('**');
    // Unbalanced "**" → treat the trailing one literally.
    if (parts.length.isEven) {
      final last = parts.removeLast();
      parts[parts.length - 1] = '${parts.last}**$last';
    }
    return [
      for (var i = 0; i < parts.length; i++)
        if (parts[i].isNotEmpty)
          TextSpan(text: parts[i], style: i.isOdd ? base.copyWith(fontWeight: FontWeight.w800) : base),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final base = style ?? DefaultTextStyle.of(context).style;
    final lines = text.trim().split('\n');
    final children = <Widget>[];
    for (final raw in lines) {
      final line = raw.trimRight();
      if (line.trim().isEmpty) {
        if (children.isNotEmpty) children.add(const SizedBox(height: 6));
        continue;
      }
      final b = _bullet.firstMatch(line);
      final n = _numbered.firstMatch(line);
      if (b != null || n != null) {
        final marker = b != null ? '•' : '${n!.group(1)}.';
        final content = line.substring((b ?? n)!.end);
        children.add(Padding(
          padding: const EdgeInsetsDirectional.only(start: 4, top: 2, bottom: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 18, child: Text(marker, style: base.copyWith(fontWeight: FontWeight.w700))),
              Expanded(child: Text.rich(TextSpan(children: inlineSpans(content, base)))),
            ],
          ),
        ));
        continue;
      }
      if (_heading.hasMatch(line)) {
        final h = base.copyWith(fontWeight: FontWeight.w800, fontSize: (base.fontSize ?? 14) + 1);
        children.add(Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 2),
          child: Text.rich(TextSpan(children: inlineSpans(line.replaceFirst(_heading, ''), h))),
        ));
        continue;
      }
      children.add(Text.rich(TextSpan(children: inlineSpans(line, base))));
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: children);
  }
}
