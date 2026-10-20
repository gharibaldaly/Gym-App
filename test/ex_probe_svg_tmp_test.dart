import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironmind/features/exercises/widgets/body_map_svg.dart';

void main() {
  testWidgets('svg', (tester) async {
    int f(String m) => const {'chest': 0xFF1E8C0B, 'triceps': 0xFF9DFF85, 'shoulders': 0xFF9DFF85, 'lats': 0xFF1E8C0B, 'quadriceps': 0xFF1E8C0B, 'glutes': 0xFF9DFF85, 'abdominals': 0xFF1E8C0B, 'calves': 0xFF9DFF85, 'hamstrings': 0xFF1E8C0B, 'traps': 0xFF9DFF85}[m] ?? 0xFF3A3A3A;
    final key = GlobalKey();
    tester.view.physicalSize = const Size(800, 840);
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(Directionality(textDirection: TextDirection.ltr, child: RepaintBoundary(key: key, child: Container(color: const Color(0xFF0A0A0A), child: Row(children: [
      SvgPicture.string(buildBodySvg(BodyView.front, fillFor: f), width: 400, height: 840),
      SvgPicture.string(buildBodySvg(BodyView.back, fillFor: f), width: 400, height: 840),
    ])))));
    await tester.runAsync(() async { await Future.delayed(const Duration(milliseconds: 500)); });
    await tester.pumpAndSettle();
    await tester.runAsync(() async {
      final b = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final img = await b.toImage(pixelRatio: 1);
      final data = await img.toByteData(format: ui.ImageByteFormat.png);
      File('/tmp/claude-0/-home-user-Gym-App/952830a8-6591-5a88-a711-183476a8644c/scratchpad/both.png').writeAsBytesSync(data!.buffer.asUint8List());
    });
  });
}
