import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/context_ext.dart';
import '../../core/widgets/common.dart';
import 'coach_repository.dart';
import 'widgets/proposal_card.dart';

/// Pending proposals (approve / reject) + recently resolved ones.
class CoachSuggestionsView extends ConsumerWidget {
  const CoachSuggestionsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final async = ref.watch(coachProposalsProvider);
    final all = async.value ?? const <CoachProposal>[];
    final pending = all.where((p) => p.isPending).toList();
    final resolved = all.where((p) => !p.isPending).take(30).toList();
    if (async.isLoading && all.isEmpty) return const Center(child: CircularProgressIndicator());
    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
      children: [
        if (pending.isEmpty)
          EmptyState(icon: Icons.task_alt, text: l.coachNoPending)
        else
          for (final p in pending) ProposalCard(proposal: p),
        if (resolved.isNotEmpty)
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              iconColor: AppColors.textMuted,
              collapsedIconColor: AppColors.textMuted,
              title: Text(l.coachHistory, style: const TextStyle(color: AppColors.textMuted)),
              children: [for (final p in resolved) ProposalCard(proposal: p, compact: true)],
            ),
          ),
      ],
    );
  }
}
