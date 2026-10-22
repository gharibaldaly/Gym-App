import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/navigation.dart';
import '../../core/utils/context_ext.dart';
import 'logging/log_actions.dart';
import 'widgets/meal_plan_view.dart';
import 'widgets/shopping_list_view.dart';
import 'widgets/today_view.dart';

/// Food tab: Today / Meal plan / Shopping list + FAB to log food.
class NutritionTabScreen extends ConsumerStatefulWidget {
  const NutritionTabScreen({super.key});

  @override
  ConsumerState<NutritionTabScreen> createState() => _NutritionTabScreenState();
}

class _NutritionTabScreenState extends ConsumerState<NutritionTabScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 3, vsync: this);

  @override
  void initState() {
    super.initState();
    _tabs.addListener(() {
      if (!_tabs.indexIsChanging && mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.nutTitle),
        actions: [
          IconButton(tooltip: l.settings, icon: const Icon(Symbols.settings_rounded), onPressed: () => openSettings(context)),
        ],
        bottom: TabBar(
          controller: _tabs,
          tabs: [
            Tab(text: l.nutTabToday),
            Tab(text: l.nutTabPlan),
            Tab(text: l.nutTabShopping),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          NutritionTodayView(onOpenPlan: () => _tabs.animateTo(1)),
          const MealPlanView(),
          const ShoppingListView(),
        ],
      ),
      floatingActionButton: _tabs.index == 2
          ? null
          : FloatingActionButton.extended(
              heroTag: 'nut_log_fab',
              onPressed: () => showLogFoodSheet(context, ref),
              icon: const Icon(Symbols.add_a_photo_rounded, fill: 1),
              label: Text(l.nutLogFood),
            ),
    );
  }
}
