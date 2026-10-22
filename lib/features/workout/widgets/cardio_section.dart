import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/calc/stats.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/context_ext.dart';
import '../../../core/widgets/common.dart';
import '../session_summary_screen.dart' show cardioDetails, cardioTypeLabel;
import '../workout_repository.dart';

const cardioTypes = ['treadmill', 'bike', 'elliptical', 'rowing', 'walk', 'run', 'stairs', 'jump_rope', 'swim', 'other'];
const _speedTypes = {'treadmill', 'walk', 'run'};
const _levelTypes = {'bike', 'elliptical', 'rowing', 'stairs'};

/// Cardio logged in this session + "add cardio".
class CardioSection extends ConsumerWidget {
  final int? sessionId;

  /// Creates the session on demand when logging before any set.
  final Future<int> Function() ensureSession;
  const CardioSection({super.key, required this.sessionId, required this.ensureSession});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final logs = sessionId == null ? const <CardioLog>[] : (ref.watch(sessionCardioProvider(sessionId!)).value ?? const []);
    return SectionCard(
      title: l.woCardio,
      trailing: const Icon(Symbols.sprint_rounded, color: AppColors.primary),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final c in logs)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(cardioTypeLabel(context, c.type)),
              subtitle: Text(cardioDetails(context, c)),
              trailing: IconButton(
                icon: const Icon(Symbols.delete_rounded),
                onPressed: () => ref.read(workoutRepositoryProvider).deleteCardio(c.id),
              ),
            ),
          OutlinedButton.icon(
            icon: const Icon(Symbols.add_rounded),
            label: Text(l.woAddCardio),
            onPressed: () async {
              final sid = await ensureSession();
              if (!context.mounted) return;
              await showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                builder: (_) => _CardioSheet(sessionId: sid),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CardioSheet extends ConsumerStatefulWidget {
  final int sessionId;
  const _CardioSheet({required this.sessionId});

  @override
  ConsumerState<_CardioSheet> createState() => _CardioSheetState();
}

class _CardioSheetState extends ConsumerState<_CardioSheet> {
  String _type = 'treadmill';
  double _minutes = 20;
  double _speed = 6;
  double _incline = 0;
  double _level = 5;
  double _bodyweight = 75;
  bool _caloriesEdited = false;
  final _calories = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.read(workoutRepositoryProvider).currentBodyweight().then((w) {
      if (!mounted) return;
      setState(() => _bodyweight = w);
      _recalc();
    });
    _recalc();
  }

  @override
  void dispose() {
    _calories.dispose();
    super.dispose();
  }

  double _estimate() => CardioCalc.calories(
        type: _type,
        minutes: _minutes,
        weightKg: _bodyweight,
        speedKmh: _speedTypes.contains(_type) ? _speed : null,
        inclinePct: _type == 'treadmill' ? _incline : null,
        level: _levelTypes.contains(_type) ? _level.round() : null,
      );

  void _recalc() {
    if (_caloriesEdited) return;
    _calories.text = _estimate().round().toString();
  }

  void _set(VoidCallback f) {
    setState(f);
    _recalc();
  }

  Future<void> _save() async {
    final kcal = double.tryParse(_calories.text.trim()) ?? _estimate();
    final session = await ref.read(workoutRepositoryProvider).session(widget.sessionId);
    await ref.read(workoutRepositoryProvider).addCardio(CardioLogsCompanion.insert(
          sessionId: Value(widget.sessionId),
          date: session?.date ?? today(),
          type: _type,
          durationMin: _minutes,
          speedKmh: Value(_speedTypes.contains(_type) ? _speed : null),
          inclinePct: Value(_type == 'treadmill' ? _incline : null),
          level: Value(_levelTypes.contains(_type) ? _level.round() : null),
          calories: Value(kcal),
        ));
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.woAddCardio, style: context.text.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final t in cardioTypes)
                  ChoiceChip(
                    label: Text(cardioTypeLabel(context, t)),
                    selected: _type == t,
                    onSelected: (_) => _set(() {
                      _type = t;
                      if (t == 'run' && _speed < 8) _speed = 9;
                      if (t == 'walk' && _speed > 7) _speed = 5;
                    }),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.spaceEvenly,
              spacing: 12,
              runSpacing: 16,
              children: [
                BigStepper(
                  label: '${l.woDuration} (${l.minutesShort})',
                  value: _minutes,
                  step: 5,
                  min: 1,
                  decimals: 0,
                  onChanged: (v) => _set(() => _minutes = v),
                ),
                if (_speedTypes.contains(_type))
                  BigStepper(
                    label: '${l.woSpeed} (${l.woKmh})',
                    value: _speed,
                    step: 0.5,
                    min: 0.5,
                    onChanged: (v) => _set(() => _speed = v),
                  ),
                if (_type == 'treadmill')
                  BigStepper(
                    label: '${l.woIncline} %',
                    value: _incline,
                    step: 1,
                    decimals: 0,
                    onChanged: (v) => _set(() => _incline = v.clamp(0, 30)),
                  ),
                if (_levelTypes.contains(_type))
                  BigStepper(
                    label: l.woLevel,
                    value: _level,
                    step: 1,
                    min: 1,
                    decimals: 0,
                    onChanged: (v) => _set(() => _level = v.clamp(1, 20)),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _calories,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: '${l.calories} (${l.kcal})',
                helperText: l.woCaloriesAuto,
                suffixIcon: _caloriesEdited
                    ? IconButton(
                        icon: const Icon(Symbols.refresh_rounded),
                        onPressed: () => _set(() => _caloriesEdited = false),
                      )
                    : null,
              ),
              onChanged: (_) => _caloriesEdited = true,
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: _save, child: Text(l.save)),
          ],
        ),
      ),
    );
  }
}
