import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' show AppLifecycleListener;
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/settings/app_settings.dart';
import '../../l10n/gen/app_localizations.dart';
import '../notifications/notification_service.dart';

/// Keeps the app alive while important work (AI requests, backups, downloads)
/// runs, so locking the screen or switching apps doesn't kill it.
///
/// On Android, a backgrounded app is frozen within seconds and its open
/// network connections die. While at least one [run] is active we hold a
/// foreground service (ongoing "IronMind is working…" notification) and a
/// partial wake lock; both are released when the last task finishes.
class KeepAlive {
  static const _channel = MethodChannel('ironmind/keepalive');
  static int _active = 0;
  static Future<void>? _starting;

  static bool get _android => !kIsWeb && Platform.isAndroid;

  /// Number of tasks currently protected (for tests/diagnostics).
  static int get activeCount => _active;

  static Future<T> run<T>(Future<T> Function() task) async {
    _active++;
    if (_active == 1) _starting = _start();
    try {
      return await task();
    } finally {
      _active--;
      if (_active == 0) {
        await _starting;
        if (_active == 0) unawaited(_stop());
      }
    }
  }

  static Future<void> _start() async {
    if (!_android) return;
    try {
      await _channel.invokeMethod<void>('acquire');
    } catch (e) {
      debugPrint('KeepAlive wake lock failed: $e');
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      final l = lookupAppLocalizations(Locale(prefs.getString(SettingsKeys.language) ?? 'ar'));
      await NotificationService.startWorkService(title: l.setWorkNotifTitle, body: l.setWorkNotifBody);
    } catch (e) {
      debugPrint('KeepAlive service failed: $e');
    }
  }

  static Future<void> _stop() async {
    if (!_android) return;
    await NotificationService.stopWorkService();
    try {
      await _channel.invokeMethod<void>('release');
    } catch (_) {}
  }
}

/// Tracks whether the app is in the foreground so interrupted work can be
/// retried as soon as the user comes back.
class AppForeground {
  static AppLifecycleListener? _listener;
  static Completer<void>? _resumed;

  static void ensureInitialized() {
    if (_listener != null) return;
    try {
      _listener = AppLifecycleListener(onStateChange: (s) {
        if (s == AppLifecycleState.resumed) {
          _resumed?.complete();
          _resumed = null;
        }
      });
    } catch (_) {
      // No widgets binding (background isolate / plain tests): always "foreground".
    }
  }

  static bool get isForeground {
    final s = SchedulerBindingState.current;
    return s == null || s == AppLifecycleState.resumed;
  }

  /// Completes immediately when in the foreground, otherwise on the next resume.
  static Future<void> waitUntilForeground() {
    if (isForeground) return Future.value();
    ensureInitialized();
    if (_listener == null) return Future.value();
    return (_resumed ??= Completer<void>()).future;
  }
}

/// Indirection so the lifecycle state can be read without importing widgets everywhere.
class SchedulerBindingState {
  static AppLifecycleState? get current {
    try {
      return ServicesBinding.instance.lifecycleState;
    } catch (_) {
      return null;
    }
  }
}
