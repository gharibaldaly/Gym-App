import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers.dart';
import '../core/theme/app_theme.dart';
import '../data/repositories/profile_repository.dart';
import '../features/onboarding/onboarding_flow.dart';
import '../l10n/gen/app_localizations.dart';
import '../services/lock/app_lock.dart';
import 'bootstrap.dart';
import 'home_shell.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class IronMindApp extends ConsumerWidget {
  const IronMindApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(localeProvider);
    final locale = Locale(lang);
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'IronMind',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(locale),
      darkTheme: AppTheme.dark(locale),
      themeMode: ThemeMode.dark,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const AppLockGate(child: _AppGate()),
    );
  }
}

/// Bootstraps services, then shows onboarding on first run or the main shell.
class _AppGate extends ConsumerWidget {
  const _AppGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boot = ref.watch(bootstrapProvider);
    final profile = ref.watch(profileProvider);
    if (boot.isLoading || profile.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (profile.value?.onboardingComplete != true) return const OnboardingFlow();
    return const HomeShell();
  }
}
