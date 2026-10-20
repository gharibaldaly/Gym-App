import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/home_shell.dart' show homeTabProvider;
import '../../core/navigation.dart';
import '../../core/utils/context_ext.dart';
import 'coach_chat_controller.dart';
import 'coach_chat_view.dart';
import 'coach_memory_screen.dart';
import 'coach_reports_view.dart';
import 'coach_repository.dart';
import 'coach_suggestions_view.dart';

/// Index of the Coach tab in the home shell.
const coachHomeTabIndex = 3;

/// Coach tab: Chat / Reports / Suggestions (pending proposals).
class CoachTabScreen extends ConsumerStatefulWidget {
  const CoachTabScreen({super.key});

  @override
  ConsumerState<CoachTabScreen> createState() => _CoachTabScreenState();
}

class _CoachTabScreenState extends ConsumerState<CoachTabScreen> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    // Memory extraction when the user leaves the app.
    _lifecycle = AppLifecycleListener(onPause: () => ref.read(coachChatProvider.notifier).flushMemory());
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    // Memory extraction when the user leaves the Coach tab.
    ref.listen<int>(homeTabProvider, (prev, next) {
      if (prev == coachHomeTabIndex && next != coachHomeTabIndex) {
        ref.read(coachChatProvider.notifier).flushMemory();
      }
    });
    final visible = ref.watch(homeTabProvider) == coachHomeTabIndex;
    final unread = ref.watch(coachUnreadCountProvider).value ?? 0;
    if (visible && unread > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(coachRepositoryProvider).markAllRead());
    }
    final pending = ref.watch(pendingProposalsProvider).value?.length ?? 0;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.tabCoach),
          actions: [
            IconButton(
              tooltip: l.coachMemoryTitle,
              icon: const Icon(Icons.psychology_outlined),
              onPressed: () => push(context, const CoachMemoryScreen()),
            ),
            IconButton(
              tooltip: l.settings,
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => openSettings(context),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: l.coachTabChat),
              Tab(text: l.coachTabReports),
              Tab(
                child: Badge(
                  isLabelVisible: pending > 0,
                  label: Text('$pending'),
                  offset: const Offset(14, -4),
                  child: Text(l.coachTabSuggestions),
                ),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CoachChatView(),
            CoachReportsView(),
            CoachSuggestionsView(),
          ],
        ),
      ),
    );
  }
}
