import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/home_shell.dart' show homeTabProvider;
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/context_ext.dart';
import '../../data/repositories/profile_repository.dart';
import '../../features/nutrition/nutrition_providers.dart';
import '../../features/tracking/tracking_providers.dart';
import '../../features/workout/today_workout_provider.dart';
import '../notifications/notification_service.dart';
import '../widget/home_widget_service.dart';
import 'lock_rules.dart';

export 'lock_rules.dart';

/// Outcome of an authentication attempt.
enum LockAuthResult { success, failed, unavailable }

/// Thin wrapper over local_auth (biometrics with device PIN/pattern fallback).
class AppLockAuth {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> isSupported() async {
    try {
      return await _auth.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  static Future<LockAuthResult> authenticate(String reason) async {
    try {
      final ok = await _auth.authenticate(localizedReason: reason, persistAcrossBackgrounding: true);
      return ok ? LockAuthResult.success : LockAuthResult.failed;
    } on LocalAuthException catch (e) {
      // Only a phone without any screen lock counts as "unavailable"; every other
      // error (cancel, lockout, UI not ready…) keeps the app locked.
      return e.code == LocalAuthExceptionCode.noCredentialsSet ? LockAuthResult.unavailable : LockAuthResult.failed;
    } on PlatformException {
      return LockAuthResult.failed;
    } on MissingPluginException {
      return LockAuthResult.unavailable;
    }
  }
}

/// Lock settings helpers (SettingsKeys.lockEnabled / lockAfterSeconds).
class AppLockPrefs {
  static const defaultTimeoutSeconds = 60;
  static const timeoutOptions = [0, 30, 60, 300, 900];

  static bool enabled(SharedPreferences p) => p.getBool(SettingsKeys.lockEnabled) ?? false;
  static int timeoutSeconds(SharedPreferences p) => p.getInt(SettingsKeys.lockAfterSeconds) ?? defaultTimeoutSeconds;
}


/// Biometric lock on open and after a period in background (toggle in settings).
/// Also hosts app-wide glue that must live inside the ProviderScope:
/// notification taps → tab switch, live home-widget refresh, DB refresh on resume.
class AppLockGate extends ConsumerStatefulWidget {
  final Widget child;
  const AppLockGate({super.key, required this.child});

  @override
  ConsumerState<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends ConsumerState<AppLockGate> with WidgetsBindingObserver {
  bool _locked = false;
  bool _authInProgress = false;
  DateTime? _backgroundedAt;
  OverlayEntry? _entry;
  StreamSubscription<String?>? _tapSub;
  Timer? _widgetDebounce;
  Timer? _reminderDebounce;
  String? _reminderSignature;
  bool _permissionAsked = false;
  final _lockState = ValueNotifier<_LockViewState>(_LockViewState.idle);

  SharedPreferences get _prefs => ref.read(sharedPrefsProvider);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _locked = AppLockPrefs.enabled(_prefs);
    if (_locked) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showOverlay();
        _unlock();
      });
    }
    _tapSub = NotificationService.taps.listen(_onNotificationTap);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = NotificationService.consumeLaunchPayload();
      if (p != null) _onNotificationTap(p);
      if (mounted) _onReminderInputs();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tapSub?.cancel();
    _widgetDebounce?.cancel();
    _reminderDebounce?.cancel();
    _entry?.remove();
    _entry = null;
    _lockState.dispose();
    super.dispose();
  }

  void _onNotificationTap(String? payload) {
    final tab = switch (payload) {
      'workout' || 'rest_timer' => 1,
      'meals' => 2,
      'coach' => 3,
      'water' || 'weight' || 'supplements' => 0,
      _ => null,
    };
    if (tab != null) ref.read(homeTabProvider.notifier).select(tab);
  }

  void _scheduleWidgetUpdate() {
    _widgetDebounce?.cancel();
    _widgetDebounce = Timer(const Duration(seconds: 2), () {
      if (mounted) HomeWidgetService.updateWith(ref.read);
    });
  }

  /// Reschedules reminders whenever the inputs (profile times/days, supplements) change –
  /// so profile edits anywhere in the app keep notifications in sync.
  void _onReminderInputs() {
    final p = ref.read(profileProvider).value;
    final supps = ref.read(_activeSupplementNamesProvider).value;
    if (p == null || !p.onboardingComplete || supps == null) return;
    final sig = [
      p.trainingDaysJson,
      p.trainingTime,
      p.trainingTimeOfDay,
      p.mealTimesJson,
      p.wakeTime,
      p.sleepTime,
      p.supplementsJson,
      p.language,
      supps.join('|'),
    ].join('#');
    if (sig == _reminderSignature) return;
    _reminderSignature = sig;
    _reminderDebounce?.cancel();
    _reminderDebounce = Timer(const Duration(seconds: 1), () async {
      if (!mounted) return;
      final db = ref.read(databaseProvider);
      if (!_permissionAsked) {
        _permissionAsked = true;
        await NotificationService.init(requestPermission: true);
      }
      await NotificationService.rescheduleAll(db, _prefs);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_authInProgress) return; // the system auth dialog pauses/resumes the activity
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        if (_backgroundedAt == null) {
          _backgroundedAt = DateTime.now();
          _widgetDebounce?.cancel();
          HomeWidgetService.updateWith(ref.read);
        }
      case AppLifecycleState.resumed:
        final since = _backgroundedAt;
        _backgroundedAt = null;
        if (since != null) {
          // Background isolates (widget "+ cup", workmanager) write to the DB through
          // their own connection: refresh every live query.
          try {
            final db = ref.read(databaseProvider);
            db.markTablesUpdated(db.allTables);
          } catch (_) {}
        }
        if (!_locked &&
            shouldRelock(
              enabled: AppLockPrefs.enabled(_prefs),
              backgroundedAt: since,
              now: DateTime.now(),
              timeoutSeconds: AppLockPrefs.timeoutSeconds(_prefs),
            )) {
          setState(() => _locked = true);
          _showOverlay();
          _unlock();
        }
      default:
        break;
    }
  }

  void _showOverlay() {
    if (_entry != null || !mounted) return;
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;
    _entry = OverlayEntry(
      builder: (_) => _LockScreen(state: _lockState, onUnlock: _unlock),
    );
    overlay.insert(_entry!);
  }

  Future<void> _unlock() async {
    if (_authInProgress || !mounted) return;
    _authInProgress = true;
    _lockState.value = _LockViewState.authenticating;
    final res = await AppLockAuth.authenticate(context.l10n.setLockReason);
    _authInProgress = false;
    if (!mounted) return;
    if (res == LockAuthResult.success || res == LockAuthResult.unavailable) {
      // "unavailable": the device lost its screen lock → don't lock the user out of their data.
      _entry?.remove();
      _entry = null;
      _lockState.value = _LockViewState.idle;
      setState(() => _locked = false);
    } else {
      _lockState.value = _LockViewState.failed;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Keep the home-screen widget in sync with live data.
    ref.listen(todayWaterProvider, (_, _) => _scheduleWidgetUpdate());
    ref.listen(todayNutritionProvider, (_, _) => _scheduleWidgetUpdate());
    ref.listen(todayWorkoutProvider, (_, _) => _scheduleWidgetUpdate());
    // Keep scheduled reminders in sync with the profile.
    ref.listen(profileProvider, (_, _) => _onReminderInputs());
    ref.listen(_activeSupplementNamesProvider, (_, _) => _onReminderInputs());
    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        // Covers content during the first frame(s) before the overlay is inserted.
        if (_locked && _entry == null) const ColoredBox(color: AppColors.background),
      ],
    );
  }
}

final _activeSupplementNamesProvider = StreamProvider<List<String>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.supplements)..where((t) => t.active.equals(true)))
      .watch()
      .map((rows) => rows.map((s) => s.name).toList()..sort());
});

enum _LockViewState { idle, authenticating, failed }

class _LockScreen extends StatelessWidget {
  final ValueNotifier<_LockViewState> state;
  final VoidCallback onUnlock;
  const _LockScreen({required this.state, required this.onUnlock});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: ValueListenableBuilder(
                valueListenable: state,
                builder: (context, s, _) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withValues(alpha: 0.12),
                        border: Border.all(color: AppColors.primary, width: 2),
                      ),
                      child: const Icon(Icons.lock_outline, size: 44, color: AppColors.primary),
                    ),
                    const SizedBox(height: 24),
                    Text(l.appName, style: context.text.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    Text(l.setLockLocked, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textMuted)),
                    if (s == _LockViewState.failed) ...[
                      const SizedBox(height: 12),
                      Text(l.setLockFailed, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.danger)),
                    ],
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: s == _LockViewState.authenticating ? null : onUnlock,
                        icon: const Icon(Icons.fingerprint),
                        label: Text(l.setLockUnlock),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
