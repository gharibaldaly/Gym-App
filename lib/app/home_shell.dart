import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../core/utils/context_ext.dart';
import '../features/coach/coach_tab_screen.dart';
import '../features/nutrition/nutrition_tab_screen.dart';
import '../features/progress/progress_tab_screen.dart';
import '../features/today/today_screen.dart';
import '../features/workout/workout_tab_screen.dart';

/// Lets any screen switch the bottom tab (e.g. Today → Coach).
final homeTabProvider = NotifierProvider<HomeTabNotifier, int>(HomeTabNotifier.new);

class HomeTabNotifier extends Notifier<int> {
  @override
  int build() => 0;
  void select(int i) => state = i;
}

class HomeShell extends ConsumerWidget {
  const HomeShell({super.key});

  static const tabs = [
    TodayScreen(),
    WorkoutTabScreen(),
    NutritionTabScreen(),
    CoachTabScreen(),
    ProgressTabScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(homeTabProvider);
    final l = context.l10n;
    return Scaffold(
      body: IndexedStack(index: index, children: tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: ref.read(homeTabProvider.notifier).select,
        destinations: [
          NavigationDestination(icon: const Icon(Symbols.today_rounded), selectedIcon: const Icon(Symbols.today_rounded, fill: 1), label: l.tabToday),
          NavigationDestination(icon: const Icon(Symbols.fitness_center_rounded), selectedIcon: const Icon(Symbols.fitness_center_rounded, fill: 1), label: l.tabWorkout),
          NavigationDestination(icon: const Icon(Symbols.restaurant_rounded), selectedIcon: const Icon(Symbols.restaurant_rounded, fill: 1), label: l.tabFood),
          NavigationDestination(icon: const Icon(Symbols.forum_rounded), selectedIcon: const Icon(Symbols.forum_rounded, fill: 1), label: l.tabCoach),
          NavigationDestination(icon: const Icon(Symbols.monitoring_rounded), selectedIcon: const Icon(Symbols.monitoring_rounded, fill: 1), label: l.tabProgress),
        ],
      ),
    );
  }
}
