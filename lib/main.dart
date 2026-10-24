import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'app/app_restarter.dart';
import 'app/startup_error.dart';
import 'core/settings/app_settings.dart';
import 'core/widgets/brand_mark.dart';
import 'services/cloud/cloud_providers.dart';

void main() {
  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();
    // In release builds a failed build() would otherwise render an empty grey box.
    ErrorWidget.builder = (details) => StartupErrorView(error: details.exception, stack: details.stack);
    // Draw the first frame right away; plugins are initialised behind it.
    runApp(const _Root());
  }, (error, stack) => debugPrint('Uncaught: $error\n$stack'));
}

/// Loads what the app needs before the provider tree exists (SharedPreferences),
/// with a timeout so a stuck platform channel shows an error instead of hanging.
class _Root extends StatefulWidget {
  const _Root();

  @override
  State<_Root> createState() => _RootState();
}

class _RootState extends State<_Root> {
  late Future<SharedPreferences> _prefs = _load();

  /// Changing it rebuilds the whole provider tree (fresh database), e.g. after a restore.
  int _generation = 0;

  Future<SharedPreferences> _load() async {
    final prefs = await SharedPreferences.getInstance().timeout(const Duration(seconds: 15));
    await CloudRuntime.init();
    return prefs;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: _prefs,
      builder: (context, snap) {
        if (snap.hasError) {
          return StartupErrorApp(
            error: snap.error!,
            stack: snap.stackTrace,
            onRetry: () => setState(() => _prefs = _load()),
          );
        }
        if (!snap.hasData) {
          return const BrandSplash();
        }
        return AppRestarter(
          restart: () => setState(() => _generation++),
          child: ProviderScope(
            key: ValueKey(_generation),
            overrides: [sharedPrefsProvider.overrideWithValue(snap.data!)],
            child: const IronMindApp(),
          ),
        );
      },
    );
  }
}
