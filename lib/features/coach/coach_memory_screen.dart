import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/context_ext.dart';
import '../../core/widgets/common.dart';
import 'coach_repository.dart';
import 'widgets/message_bubble.dart' show formatMessageTime;

/// Settings → Coach memory: everything the coach remembers, with delete / clear all.
class CoachMemoryScreen extends ConsumerWidget {
  const CoachMemoryScreen({super.key});

  Future<void> _clearAll(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(l.coachMemoryClearConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: Text(l.coachMemoryClearAll),
          ),
        ],
      ),
    );
    if (ok == true) await ref.read(coachRepositoryProvider).clearMemories();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final async = ref.watch(coachMemoriesProvider);
    final mems = async.value ?? const <CoachMemory>[];
    return Scaffold(
      appBar: AppBar(
        title: Text(l.coachMemoryTitle),
        actions: [
          if (mems.isNotEmpty)
            TextButton(
              onPressed: () => _clearAll(context, ref),
              style: TextButton.styleFrom(foregroundColor: AppColors.danger),
              child: Text(l.coachMemoryClearAll),
            ),
        ],
      ),
      body: async.isLoading && mems.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(l.coachMemoryHint, style: const TextStyle(color: AppColors.textMuted)),
                ),
                if (mems.isEmpty)
                  EmptyState(icon: Symbols.psychology_rounded, text: l.coachMemoryEmpty)
                else
                  for (final m in mems)
                    Dismissible(
                      key: ValueKey(m.id),
                      direction: DismissDirection.horizontal,
                      background: Container(
                        alignment: AlignmentDirectional.centerStart,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        color: AppColors.danger.withValues(alpha: 0.25),
                        child: const Icon(Symbols.delete_rounded, color: AppColors.danger),
                      ),
                      onDismissed: (_) {
                        ref.read(coachRepositoryProvider).deleteMemory(m.id);
                        context.snack(l.coachMemoryDeleted);
                      },
                      child: Card(
                        child: ListTile(
                          leading: const Icon(Symbols.push_pin_rounded, color: AppColors.primary),
                          title: Text(m.content),
                          subtitle: Text(formatMessageTime(context, m.createdAt),
                              style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                          trailing: IconButton(
                            tooltip: l.delete,
                            icon: const Icon(Symbols.delete_rounded),
                            onPressed: () => ref.read(coachRepositoryProvider).deleteMemory(m.id),
                          ),
                        ),
                      ),
                    ),
              ],
            ),
    );
  }
}
