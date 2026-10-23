import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Keeps the app process (and its network access) alive while long work runs,
/// so locking the screen or leaving the app doesn't kill an AI request half-way.
///
/// On Android this runs BackgroundWorkService (a silent foreground service with a
/// partial wake lock) for as long as at least one [begin] has no matching [end].
/// Elsewhere it's a no-op.
class KeepAlive {
  static const _channel = MethodChannel('ironmind/background_work');

  /// Android may crash the app if a foreground service is stopped before it has
  /// started, so the service always lives at least this long.
  static const _minRun = Duration(milliseconds: 1500);

  static int _holders = 0;
  static bool _running = false;
  static DateTime? _startedAt;
  static Timer? _stopTimer;

  static bool get _supported => !kIsWeb && Platform.isAndroid;

  /// True while the foreground service is up (work can continue in the background).
  static bool get isRunning => _running;

  /// Starts (or keeps) the service. Strings are shown in the ongoing notification.
  static Future<void> begin({required String title, required String text, required String channel}) async {
    _holders++;
    _stopTimer?.cancel();
    _stopTimer = null;
    if (!_supported || _running) return;
    try {
      _running = await _channel.invokeMethod<bool>('start', {
            'title': title,
            'text': text,
            'channel': channel,
          }) ??
          false;
      if (_running) _startedAt = DateTime.now();
    } catch (e) {
      // MissingPluginException in tests, or Android refused the start: the work still runs, just unprotected.
      debugPrint('KeepAlive start failed: $e');
      _running = false;
    }
  }

  /// Releases one [begin]. The service stops when nothing holds it.
  static void end() {
    if (_holders > 0) _holders--;
    if (_holders > 0 || !_running) return;
    final elapsed = DateTime.now().difference(_startedAt ?? DateTime.now());
    final wait = elapsed >= _minRun ? Duration.zero : _minRun - elapsed;
    _stopTimer?.cancel();
    _stopTimer = Timer(wait, () async {
      _stopTimer = null;
      if (_holders > 0) return;
      _running = false;
      try {
        await _channel.invokeMethod<void>('stop');
      } catch (_) {}
    });
  }
}

/// Whether the app is currently in the foreground (true when there's no binding, e.g. in unit tests).
bool appInForeground() {
  try {
    final s = WidgetsBinding.instance.lifecycleState;
    return s == null || s == AppLifecycleState.resumed;
  } catch (_) {
    return true;
  }
}
