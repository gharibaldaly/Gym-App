import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/context_ext.dart';
import '../coach_proposals.dart';
import '../coach_repository.dart';
import 'markdown_lite.dart';

IconData proposalIcon(String type) => switch (type) {
      ProposalTypes.planChange => Symbols.edit_calendar_rounded,
      ProposalTypes.swapExercise => Symbols.swap_horiz_rounded,
      ProposalTypes.logMeal => Symbols.restaurant_rounded,
      ProposalTypes.logSet => Symbols.fitness_center_rounded,
      ProposalTypes.adjustMacros => Symbols.pie_chart_rounded,
      ProposalTypes.recoveryAdjust => Symbols.battery_charging_full_rounded,
      ProposalTypes.deload => Symbols.trending_down_rounded,
      _ => Symbols.lightbulb_rounded,
    };

/// Approve / reject card for a coach proposal (chat + Suggestions tab).
class ProposalCard extends ConsumerStatefulWidget {
  final CoachProposal proposal;
  final bool compact;
  const ProposalCard({super.key, required this.proposal, this.compact = false});

  @override
  ConsumerState<ProposalCard> createState() => _ProposalCardState();
}

class _ProposalCardState extends ConsumerState<ProposalCard> {
  bool _busy = false;

  Future<void> _resolve(bool accept) async {
    setState(() => _busy = true);
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    try {
      final applier = ref.read(proposalApplierProvider);
      if (accept) {
        await applier.accept(widget.proposal.id);
        HapticFeedback.mediumImpact();
      } else {
        await applier.reject(widget.proposal.id);
        HapticFeedback.selectionClick();
      }
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(accept ? l.coachAppliedSnack : l.coachRejectedSnack)));
    } catch (e) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l.coachApplyFailed('$e'))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.proposal;
    final l = context.l10n;
    final pending = p.isPending;
    final statusColor = switch (p.status) {
      'accepted' => AppColors.primary,
      'rejected' => AppColors.danger,
      _ => AppColors.warning,
    };
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: pending ? AppColors.primary.withValues(alpha: 0.6) : AppColors.border),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(proposalIcon(p.type), color: pending ? AppColors.primary : AppColors.textMuted),
              const SizedBox(width: 10),
              Expanded(
                child: Text(p.title, style: context.text.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  switch (p.status) {
                    'accepted' => l.coachAccepted,
                    'rejected' => l.coachRejected,
                    _ => l.coachPending,
                  },
                  style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          if (!widget.compact && p.description != null && p.description!.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            MarkdownLite(
              p.description!,
              style: context.text.bodyMedium?.copyWith(color: AppColors.textMuted),
            ),
          ],
          if (pending) ...[
            const SizedBox(height: 12),
            if (_busy)
              const Center(child: Padding(padding: EdgeInsets.all(8), child: CircularProgressIndicator()))
            else
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.text,
                        side: const BorderSide(color: AppColors.border),
                      ),
                      onPressed: () => _resolve(false),
                      icon: const Icon(Symbols.close_rounded),
                      label: Text(l.reject),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(minimumSize: const Size(64, 48)),
                      onPressed: () => _resolve(true),
                      icon: const Icon(Symbols.check_rounded),
                      label: Text(l.accept),
                    ),
                  ),
                ],
              ),
          ],
        ],
      ),
    );
  }
}
