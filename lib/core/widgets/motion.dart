import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';

bool _reduceMotion(BuildContext context) => MediaQuery.maybeDisableAnimationsOf(context) ?? false;

/// Fades and lifts its child in on first build. [index] staggers siblings in a list.
/// The delay is part of the controller (an [Interval]), so there are no pending timers.
class Reveal extends StatefulWidget {
  final Widget child;
  final int index;
  final double offset;
  const Reveal({super.key, required this.child, this.index = 0, this.offset = 16});

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _t;

  @override
  void initState() {
    super.initState();
    final delay = AppMotion.stagger * widget.index.clamp(0, 10);
    final total = delay + AppMotion.slow;
    _c = AnimationController(vsync: this, duration: total);
    final start = delay.inMicroseconds / total.inMicroseconds;
    _t = CurvedAnimation(parent: _c, curve: Interval(start, 1, curve: AppMotion.emphasized));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_c.status == AnimationStatus.dismissed) {
      if (_reduceMotion(context)) {
        _c.value = 1;
      } else {
        _c.forward();
      }
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _t,
      child: widget.child,
      builder: (context, child) => Opacity(
        opacity: _t.value.clamp(0.0, 1.0),
        child: Transform.translate(offset: Offset(0, (1 - _t.value) * widget.offset), child: child),
      ),
    );
  }
}

/// Wraps each child of a list in a staggered [Reveal].
List<Widget> revealAll(List<Widget> children) =>
    [for (var i = 0; i < children.length; i++) Reveal(index: i, child: children[i])];

/// Gives any tappable surface a short press-down scale. Does not consume the tap,
/// so the child's own InkWell / button still receives it.
class Pressable extends StatefulWidget {
  final Widget child;
  final bool enabled;
  final double scale;
  const Pressable({super.key, required this.child, this.enabled = true, this.scale = 0.975});

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _down = false;

  void _set(bool v) {
    if (!widget.enabled || _down == v) return;
    setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _set(true),
      onPointerUp: (_) => _set(false),
      onPointerCancel: (_) => _set(false),
      child: AnimatedScale(
        scale: _down ? widget.scale : 1,
        duration: AppMotion.fast,
        curve: AppMotion.standard,
        child: widget.child,
      ),
    );
  }
}

/// Number that counts to its new value instead of jumping.
class AnimatedNumber extends StatelessWidget {
  final double value;
  final String Function(double) format;
  final TextStyle? style;
  final TextAlign? textAlign;
  const AnimatedNumber({super.key, required this.value, required this.format, this.style, this.textAlign});

  @override
  Widget build(BuildContext context) {
    if (_reduceMotion(context)) return Text(format(value), style: style, textAlign: textAlign);
    return TweenAnimationBuilder<double>(
      tween: Tween(end: value),
      duration: AppMotion.reveal,
      curve: AppMotion.emphasized,
      builder: (context, v, _) => Text(format(v), style: style, textAlign: textAlign),
    );
  }
}

/// Light haptic tick for selections and small confirmations.
void tick() => HapticFeedback.selectionClick();
