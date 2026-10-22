import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../core/theme/app_theme.dart';
import '../core/utils/context_ext.dart';
import '../core/widgets/motion.dart';
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

class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  static const tabs = [
    TodayScreen(),
    WorkoutTabScreen(),
    NutritionTabScreen(),
    CoachTabScreen(),
    ProgressTabScreen(),
  ];

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> with SingleTickerProviderStateMixin {
  // Fades the newly selected tab in; IndexedStack keeps every tab's state.
  late final AnimationController _fade = AnimationController(vsync: this, duration: AppMotion.base, value: 1);

  @override
  void dispose() {
    _fade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final index = ref.watch(homeTabProvider);
    ref.listen(homeTabProvider, (prev, next) {
      if (prev != next) _fade.forward(from: 0);
    });
    final l = context.l10n;
    return Scaffold(
      body: FadeTransition(
        opacity: CurvedAnimation(parent: _fade, curve: AppMotion.standard),
        child: IndexedStack(index: index, children: HomeShell.tabs),
      ),
      bottomNavigationBar: _NavBar(
        index: index,
        onSelect: (i) {
          if (i != index) tick();
          ref.read(homeTabProvider.notifier).select(i);
        },
        items: [
          (Symbols.home_rounded, l.tabToday),
          (Symbols.fitness_center_rounded, l.tabWorkout),
          (Symbols.restaurant_rounded, l.tabFood),
          (Symbols.forum_rounded, l.tabCoach),
          (Symbols.monitoring_rounded, l.tabProgress),
        ],
      ),
    );
  }
}

class _NavBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onSelect;
  final List<(IconData, String)> items;
  const _NavBar({required this.index, required this.onSelect, required this.items});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 72,
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: _NavItem(
                    icon: items[i].$1,
                    label: items[i].$2,
                    selected: i == index,
                    onTap: () => onSelect(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _NavItem({required this.icon, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.textMuted;
    return Semantics(
      selected: selected,
      button: true,
      child: InkResponse(
        onTap: onTap,
        radius: 36,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: AppMotion.base,
              curve: AppMotion.standard,
              width: selected ? 60 : 44,
              height: 32,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary.withValues(alpha: 0.16) : Colors.transparent,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: TweenAnimationBuilder<double>(
                tween: Tween(end: selected ? 1 : 0),
                duration: AppMotion.base,
                curve: AppMotion.standard,
                builder: (context, t, _) => Transform.scale(
                  scale: 1 + 0.08 * (1 - (2 * t - 1).abs()), // small pop mid-transition
                  child: Icon(icon, size: 24, fill: t, weight: 400 + 200 * t, color: color),
                ),
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: AppMotion.base,
              style: TextStyle(
                fontFamily: DefaultTextStyle.of(context).style.fontFamily,
                fontSize: 12,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? AppColors.text : AppColors.textMuted,
              ),
              child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}
