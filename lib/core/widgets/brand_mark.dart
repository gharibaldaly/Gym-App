import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// The IronMind dumbbell mark. Same geometry as the launcher icon
/// (android/app/src/main/res/drawable/ic_launcher_foreground.xml), in a 108-unit canvas.
class BrandMark extends StatelessWidget {
  final double size;
  final Color color;
  const BrandMark({super.key, this.size = 96, this.color = AppColors.primary});

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _MarkPainter(color));
}

class _MarkPainter extends CustomPainter {
  final Color color;
  _MarkPainter(this.color);

  static const _rects = [
    (30.0, 51.0, 48.0, 6.0, 3.0),
    (37.0, 36.0, 8.0, 36.0, 4.0),
    (63.0, 36.0, 8.0, 36.0, 4.0),
    (27.0, 42.0, 8.0, 24.0, 4.0),
    (73.0, 42.0, 8.0, 24.0, 4.0),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 108;
    canvas.save();
    canvas.scale(s);
    canvas.translate(54, 54);
    canvas.rotate(-30 * math.pi / 180);
    canvas.translate(-54, -54);
    final paint = Paint()..color = color;
    for (final (x, y, w, h, r) in _rects) {
      canvas.drawRRect(RRect.fromLTRBR(x, y, x + w, y + h, Radius.circular(r)), paint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_MarkPainter old) => old.color != color;
}

/// Full-screen loading state: the brand mark with a slow breathing pulse.
/// Matches the native splash so the hand-off to Flutter is seamless.
class BrandSplash extends StatefulWidget {
  const BrandSplash({super.key});

  @override
  State<BrandSplash> createState() => _BrandSplashState();
}

class _BrandSplashState extends State<BrandSplash> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduce = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (!reduce && !_c.isAnimating) _c.repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = CurvedAnimation(parent: _c, curve: Curves.easeInOut);
    return ColoredBox(
      color: AppColors.background,
      child: Center(
        child: AnimatedBuilder(
          animation: t,
          builder: (context, child) => Opacity(
            opacity: 0.75 + 0.25 * t.value,
            child: Transform.scale(scale: 0.96 + 0.04 * t.value, child: child),
          ),
          child: const BrandMark(size: 144),
        ),
      ),
    );
  }
}
