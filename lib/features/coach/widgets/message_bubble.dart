import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/context_ext.dart';
import '../coach_repository.dart';
import 'markdown_lite.dart';

IconData kindIcon(String kind) => switch (kind) {
      CoachKinds.morning => Icons.wb_sunny_outlined,
      CoachKinds.workoutSummary => Icons.fitness_center,
      CoachKinds.plateau => Icons.trending_flat,
      CoachKinds.weekly => Icons.assessment_outlined,
      CoachKinds.recovery => Icons.battery_alert_outlined,
      _ => Icons.chat_bubble_outline,
    };

String kindLabel(BuildContext context, String kind) {
  final l = context.l10n;
  return switch (kind) {
    CoachKinds.morning => l.coachKindMorning,
    CoachKinds.workoutSummary => l.coachKindWorkoutSummary,
    CoachKinds.plateau => l.coachKindPlateau,
    CoachKinds.weekly => l.coachKindWeekly,
    CoachKinds.recovery => l.coachKindRecovery,
    _ => '',
  };
}

/// Small pill showing the initiative type (morning / weekly …).
class KindBadge extends StatelessWidget {
  final String kind;
  const KindBadge(this.kind, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(kindIcon(kind), size: 14, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(kindLabel(context, kind),
              style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

String formatMessageTime(BuildContext context, DateTime t) {
  final now = DateTime.now();
  final sameDay = t.year == now.year && t.month == now.month && t.day == now.day;
  final locale = context.lang;
  return sameDay ? DateFormat.Hm(locale).format(t) : DateFormat('d MMM, HH:mm', locale).format(t);
}

/// One chat bubble. User → end side, coach → start side.
class MessageBubble extends StatelessWidget {
  final String role;
  final String text;
  final String kind;
  final DateTime? time;
  final bool streaming;
  final Widget? footer;
  const MessageBubble({
    super.key,
    required this.role,
    required this.text,
    this.kind = CoachKinds.chat,
    this.time,
    this.streaming = false,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = role == 'user';
    final isNotice = kind == CoachKinds.offlineNotice;
    final bg = isUser
        ? AppColors.primary.withValues(alpha: 0.16)
        : isNotice
            ? AppColors.warning.withValues(alpha: 0.12)
            : AppColors.card;
    final radius = BorderRadiusDirectional.only(
      topStart: const Radius.circular(18),
      topEnd: const Radius.circular(18),
      bottomStart: Radius.circular(isUser ? 18 : 4),
      bottomEnd: Radius.circular(isUser ? 4 : 18),
    );
    final style = context.text.bodyLarge?.copyWith(height: 1.45, fontSize: 15) ?? const TextStyle(fontSize: 15);
    return Align(
      alignment: isUser ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.86),
        child: GestureDetector(
          onLongPress: text.isEmpty
              ? null
              : () {
                  Clipboard.setData(ClipboardData(text: text));
                  context.snack(context.l10n.coachCopied);
                },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: radius,
              border: Border.all(color: isNotice ? AppColors.warning.withValues(alpha: 0.5) : AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (CoachKinds.initiatives.contains(kind)) ...[
                  Align(alignment: AlignmentDirectional.centerStart, child: KindBadge(kind)),
                  const SizedBox(height: 8),
                ],
                if (isNotice)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.wifi_off, color: AppColors.warning, size: 20),
                      const SizedBox(width: 8),
                      Expanded(child: Text(text, style: style)),
                    ],
                  )
                else if (isUser)
                  Text(text, style: style)
                else
                  MarkdownLite(text, style: style),
                if (streaming)
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                    ),
                  ),
                if (time != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      formatMessageTime(context, time!),
                      textAlign: TextAlign.end,
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                    ),
                  ),
                ?footer,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
