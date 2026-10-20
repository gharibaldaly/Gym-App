import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/context_ext.dart';
import '../../../services/notifications/notification_service.dart';
import 'workout_widgets.dart';

/// Manual rest timer: countdown in the UI + a scheduled notification (sound + vibration)
/// so it alerts even when the app is in the background.
class RestTimerController extends ChangeNotifier {
  DateTime? _endAt;
  int _total = 0;
  Timer? _tick;
  String _title = '';
  String _body = '';

  bool get running => _endAt != null;
  int get totalSeconds => _total;
  Duration get remaining {
    final e = _endAt;
    if (e == null) return Duration.zero;
    final r = e.difference(DateTime.now());
    return r.isNegative ? Duration.zero : r;
  }

  double get progress => _total <= 0 ? 0 : (remaining.inMilliseconds / (_total * 1000)).clamp(0.0, 1.0);

  /// [title]/[body] are the localized notification texts.
  void start(int seconds, {required String title, required String body}) {
    _title = title;
    _body = body;
    _total = seconds.clamp(5, 900);
    _endAt = DateTime.now().add(Duration(seconds: _total));
    _schedule();
    _tick?.cancel();
    _tick = Timer.periodic(const Duration(milliseconds: 500), (_) => _onTick());
    notifyListeners();
  }

  void adjust(int deltaSeconds) {
    final e = _endAt;
    if (e == null) return;
    var next = e.add(Duration(seconds: deltaSeconds));
    final min = DateTime.now().add(const Duration(seconds: 5));
    if (next.isBefore(min)) next = min;
    _endAt = next;
    _total = (_total + deltaSeconds).clamp(5, 900);
    _schedule();
    notifyListeners();
  }

  void skip() {
    _stop();
    unawaited(_safe(NotificationService.cancelRestTimer));
    notifyListeners();
  }

  void _schedule() {
    final after = remaining;
    unawaited(() async {
      await _safe(NotificationService.cancelRestTimer);
      await _safe(() => NotificationService.scheduleRestTimer(after, title: _title, body: _body));
    }());
  }

  void _onTick() {
    if (_endAt == null) return;
    if (remaining == Duration.zero) {
      _stop();
      _alertForeground();
    }
    notifyListeners();
  }

  void _stop() {
    _tick?.cancel();
    _tick = null;
    _endAt = null;
  }

  Future<void> _alertForeground() async {
    HapticFeedback.heavyImpact();
    SystemSound.play(SystemSoundType.alert);
    await _safe(() async {
      if (await Vibration.hasVibrator()) {
        await Vibration.vibrate(pattern: const [0, 500, 250, 500, 250, 700]);
      }
    });
  }

  static Future<void> _safe(Future<void> Function() f) async {
    try {
      await f();
    } catch (e) {
      debugPrint('rest timer: $e');
    }
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }
}

/// Bottom bar with the countdown, ±15 s and skip.
class RestTimerBar extends StatelessWidget {
  final RestTimerController controller;
  const RestTimerBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        if (!controller.running) return const SizedBox.shrink();
        final left = controller.remaining;
        final secs = (left.inMilliseconds / 1000).ceil();
        return Material(
          color: AppColors.cardHigh,
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LinearProgressIndicator(value: controller.progress, minHeight: 4, backgroundColor: AppColors.border),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  child: Row(
                    children: [
                      const Icon(Icons.hourglass_bottom, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(l.woRestTimer, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                          Text(restText(secs),
                              style: context.text.headlineSmall?.copyWith(fontWeight: FontWeight.w800, color: AppColors.primary)),
                        ],
                      ),
                      const Spacer(),
                      _RoundBtn(label: '−15', onTap: () => controller.adjust(-15)),
                      const SizedBox(width: 8),
                      _RoundBtn(label: '+15', onTap: () => controller.adjust(15)),
                      const SizedBox(width: 8),
                      TextButton(onPressed: controller.skip, child: Text(l.skip)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RoundBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _RoundBtn({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 48,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(48, 48)),
        onPressed: onTap,
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }
}

/// Total elapsed time since [startedAt], ticking every second (isolated rebuilds).
class ElapsedTimerText extends StatefulWidget {
  final DateTime startedAt;
  final TextStyle? style;
  const ElapsedTimerText({super.key, required this.startedAt, this.style});

  @override
  State<ElapsedTimerText> createState() => _ElapsedTimerTextState();
}

class _ElapsedTimerTextState extends State<ElapsedTimerText> {
  late final Timer _t;

  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _t.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d = DateTime.now().difference(widget.startedAt);
    return Text(fmtDuration(d.isNegative ? Duration.zero : d), style: widget.style);
  }
}
