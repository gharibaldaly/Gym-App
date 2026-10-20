import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/navigation.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/context_ext.dart';
import '../tracking/tracking_screens.dart';
import 'adherence_calendar.dart';
import 'progress_providers.dart';
import 'prs_screen.dart';
import 'report/report_export.dart';
import 'widgets/progress_cards.dart';

/// Tab 5 – charts, adherence calendar, records, body links and PDF reports.
class ProgressTabScreen extends ConsumerWidget {
  const ProgressTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.progTitle),
        actions: [
          Builder(
            builder: (btnContext) => IconButton(
              tooltip: l.progExportPdf,
              icon: const Icon(Icons.picture_as_pdf_outlined),
              onPressed: () => showReportExportSheet(btnContext, ref),
            ),
          ),
          IconButton(
            tooltip: l.settings,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => openSettings(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
        children: const [
          _QuickLinks(),
          SizedBox(height: 8),
          AdherenceCalendarCard(),
          SizedBox(height: 12),
          _PeriodSelector(),
          SizedBox(height: 4),
          ExerciseProgressCard(),
          MuscleVolumeCard(),
          BodyProgressCard(),
          NutritionProgressCard(),
          SleepRecoveryCard(),
        ],
      ),
    );
  }
}

class _QuickLinks extends StatelessWidget {
  const _QuickLinks();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final links = [
      (Icons.emoji_events_outlined, l.progLinkPrs, () => push(context, const PrsScreen())),
      (Icons.photo_library_outlined, l.progLinkPhotos, () => push(context, const ProgressPhotosScreen())),
      (Icons.straighten, l.progLinkMeasurements, () => push(context, const BodyMeasurementsScreen())),
      (Icons.monitor_weight_outlined, l.progLinkWeight, () => push(context, const BodyWeightScreen())),
    ];
    return Row(children: [
      for (var i = 0; i < links.length; i++) ...[
        if (i > 0) const SizedBox(width: 8),
        Expanded(
          child: Material(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: links[i].$3,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
                child: Column(children: [
                  Icon(links[i].$1, color: AppColors.primary, size: 26),
                  const SizedBox(height: 6),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      links[i].$2,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ],
    ]);
  }
}

class _PeriodSelector extends ConsumerWidget {
  const _PeriodSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final current = ref.watch(progressPeriodProvider);
    final labels = {
      ProgressPeriod.week: l.progPeriodWeek,
      ProgressPeriod.month: l.progPeriodMonth,
      ProgressPeriod.threeMonths: l.progPeriod3Months,
      ProgressPeriod.year: l.progPeriodYear,
      ProgressPeriod.all: l.progPeriodAll,
    };
    return Container(
      height: 44,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(children: [
        for (final p in ProgressPeriod.values)
          Expanded(
            child: Semantics(
              selected: p == current,
              button: true,
              child: Material(
                color: p == current ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(11),
                child: InkWell(
                  borderRadius: BorderRadius.circular(11),
                  onTap: () => ref.read(progressPeriodProvider.notifier).set(p),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          labels[p]!,
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: p == current ? AppColors.onPrimary : AppColors.text,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ]),
    );
  }
}
