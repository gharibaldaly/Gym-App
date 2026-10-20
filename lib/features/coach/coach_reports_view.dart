import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../ai/ai_service.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/context_ext.dart';
import '../../core/widgets/common.dart';
import 'coach_initiatives.dart';
import 'coach_repository.dart';
import 'widgets/markdown_lite.dart';
import 'widgets/message_bubble.dart';

/// Weekly reports and workout summaries + "generate weekly report now".
class CoachReportsView extends ConsumerStatefulWidget {
  const CoachReportsView({super.key});

  @override
  ConsumerState<CoachReportsView> createState() => _CoachReportsViewState();
}

class _CoachReportsViewState extends ConsumerState<CoachReportsView> {
  bool _generating = false;

  Future<void> _generate() async {
    setState(() => _generating = true);
    final l = context.l10n;
    final ar = context.isAr;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(coachInitiativesProvider).generateWeeklyReportNow();
      messenger.showSnackBar(SnackBar(content: Text(l.coachWeeklyDone)));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(aiErrorText(e, ar: ar))));
    } finally {
      if (mounted) setState(() => _generating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final reports = ref.watch(coachReportsProvider);
    final hasKey = ref.watch(hasApiKeyProvider);
    final online = ref.watch(isOnlineProvider);
    final list = reports.value ?? const <CoachMessage>[];
    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
      children: [
        if (!hasKey || !online) const AiUnavailableBanner(),
        FilledButton.icon(
          onPressed: hasKey && online && !_generating ? _generate : null,
          icon: _generating
              ? const SizedBox(
                  width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.onPrimary))
              : const Icon(Icons.assessment_outlined),
          label: Text(_generating ? l.coachGenerating : l.coachGenerateWeekly),
        ),
        const SizedBox(height: 8),
        if (reports.isLoading && list.isEmpty)
          const Padding(padding: EdgeInsets.all(32), child: Center(child: CircularProgressIndicator()))
        else if (list.isEmpty)
          EmptyState(icon: Icons.description_outlined, text: l.coachReportsEmpty)
        else
          for (final m in list) _ReportCard(message: m),
      ],
    );
  }
}

class _ReportCard extends StatefulWidget {
  final CoachMessage message;
  const _ReportCard({required this.message});

  @override
  State<_ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends State<_ReportCard> {
  bool _expanded = false;

  static const _previewChars = 420;

  @override
  Widget build(BuildContext context) {
    final m = widget.message;
    final l = context.l10n;
    final long = m.content.length > _previewChars;
    final shown = !long || _expanded ? m.content : '${_cut(m.content)}…';
    final range = m.kind == CoachKinds.weekly && m.meta['weekStart'] != null
        ? '${m.meta['weekStart']} → ${m.meta['weekEnd']}'
        : formatMessageTime(context, m.createdAt);
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              KindBadge(m.kind),
              const SizedBox(width: 8),
              Expanded(
                child: Text(range, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
              ),
              IconButton(
                tooltip: l.coachCopy,
                icon: const Icon(Icons.copy, size: 18),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: m.content));
                  context.snack(l.coachCopied);
                },
              ),
            ],
          ),
          const SizedBox(height: 6),
          MarkdownLite(shown, style: context.text.bodyMedium?.copyWith(height: 1.45)),
          if (long)
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: () => setState(() => _expanded = !_expanded),
                child: Text(_expanded ? l.coachShowLess : l.coachShowMore),
              ),
            ),
        ],
      ),
    );
  }

  static String _cut(String s) {
    final cut = s.substring(0, _previewChars);
    final nl = cut.lastIndexOf('\n');
    return nl > _previewChars * 0.6 ? cut.substring(0, nl) : cut;
  }
}
