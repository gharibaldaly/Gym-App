import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/context_ext.dart';
import '../../data/repositories/profile_repository.dart';
import '../../services/notifications/notification_service.dart';

/// Settings → Notifications: every reminder has its own switch and time(s).
class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends ConsumerState<NotificationSettingsScreen> with WidgetsBindingObserver {
  bool? _allowed;
  bool? _exact;
  Timer? _debounce;
  late final AppDatabase _db;
  late final SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _db = ref.read(databaseProvider);
    _prefs = ref.read(sharedPrefsProvider);
    WidgetsBinding.instance.addObserver(this);
    _checkPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Flush a pending reschedule.
    if (_debounce?.isActive ?? false) _reschedule();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final a = await NotificationService.areNotificationsEnabled();
    final e = await NotificationService.canScheduleExact();
    if (!mounted) return;
    setState(() {
      _allowed = a;
      _exact = e;
    });
  }

  void _reschedule() {
    NotificationService.rescheduleAll(_db, _prefs);
  }

  void _changed() {
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), _reschedule);
  }

  Future<void> _setEnabled(ReminderType t, bool v) async {
    await ref.read(sharedPrefsProvider).setBool(NotificationPrefs.enabledKey(t), v);
    if (v && _allowed == false) {
      await NotificationService.requestPermissions();
      await _checkPermissions();
    }
    _changed();
  }

  Future<String?> _pickTime(String initial) async {
    final p = parseHmPair(initial) ?? (h: 9, m: 0);
    final t = await showTimePicker(context: context, initialTime: TimeOfDay(hour: p.h, minute: p.m));
    return t == null ? null : fmtHm(t.hour, t.minute);
  }

  Future<void> _setTime(ReminderType t, String? hm) async {
    final prefs = ref.read(sharedPrefsProvider);
    if (hm == null) {
      await prefs.remove(NotificationPrefs.timeKey(t));
    } else {
      await prefs.setString(NotificationPrefs.timeKey(t), hm);
    }
    _changed();
  }

  Future<void> _setTimes(ReminderType t, List<String>? times) async {
    final prefs = ref.read(sharedPrefsProvider);
    if (times == null) {
      await prefs.remove(NotificationPrefs.timesKey(t));
    } else {
      final sorted = times.toSet().toList()..sort();
      await prefs.setString(NotificationPrefs.timesKey(t), jsonEncode(sorted));
    }
    _changed();
  }

  ReminderProfile _profileOf(UserProfile? p) {
    if (p == null) return const ReminderProfile();
    List<T> safe<T>(List<T> Function() f) {
      try {
        return f();
      } catch (_) {
        return <T>[];
      }
    }

    return ReminderProfile(
      trainingDays: safe(() => p.trainingDays),
      trainingTime: p.trainingTime,
      trainingTimeOfDay: p.trainingTimeOfDay,
      mealTimes: safe(() => p.mealTimes),
      wakeTime: p.wakeTime,
      sleepTime: p.sleepTime,
      supplementNames: safe(() => p.supplementsList.map((m) => (m['name'] ?? '').toString()).toList()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final prefs = ref.watch(sharedPrefsProvider);
    final np = NotificationPrefs.fromPrefs(prefs);
    final profile = _profileOf(ref.watch(profileProvider).value);
    final activeSupps = ref.watch(_activeSupplementsProvider).value ?? const <String>[];
    final hasSupps = activeSupps.isNotEmpty || profile.supplementNames.isNotEmpty;

    final workoutTime = np.workoutTime ?? defaultWorkoutReminderTime(profile);
    final mealTimes = np.mealTimes ?? profile.mealTimes.where((t) => parseHmPair(t) != null).toList();
    final waterTimes = waterReminderTimes(profile.effectiveWake, profile.effectiveSleep, np.waterIntervalHours);
    final weightTime = np.weightTime ?? defaultWeightReminderTime(profile);
    final days = [...profile.trainingDays]..sort();

    return Scaffold(
      appBar: AppBar(title: Text(l.setNotifications)),
      body: ListView(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 32),
        children: [
          if (_allowed == false)
            _PermissionBanner(
              text: l.setNotifPermissionOff,
              action: l.setNotifAllow,
              onTap: () async {
                await NotificationService.requestPermissions();
                await _checkPermissions();
              },
            ),
          if (_allowed == true && _exact == false)
            _PermissionBanner(
              text: l.setNotifExactOff,
              action: l.setNotifAllow,
              onTap: NotificationService.requestExactAlarms,
            ),
          _ReminderCard(
            icon: Symbols.fitness_center_rounded,
            title: l.setNotifWorkout,
            subtitle: days.isEmpty
                ? l.setNotifWorkoutNoDays
                : l.setNotifWorkoutDays(days.map((d) => weekdayName(context, d)).join('، ')),
            enabled: np.isEnabled(ReminderType.workout),
            onEnabled: (v) => _setEnabled(ReminderType.workout, v),
            children: [
              _TimeRow(
                label: l.setNotifTime,
                time: workoutTime,
                isCustom: np.workoutTime != null,
                onEdit: () async => _setTime(ReminderType.workout, await _pickTime(workoutTime)),
                onReset: () => _setTime(ReminderType.workout, null),
                resetLabel: l.setNotifWorkoutDefault(profile.effectiveTrainingTime),
              ),
            ],
          ),
          _ReminderCard(
            icon: Symbols.restaurant_rounded,
            title: l.setNotifMeals,
            subtitle: l.setNotifMealsSub,
            enabled: np.isEnabled(ReminderType.meals),
            onEnabled: (v) => _setEnabled(ReminderType.meals, v),
            children: [
              _TimesEditor(
                times: mealTimes,
                onEdit: (i) async {
                  final t = await _pickTime(mealTimes[i]);
                  if (t != null) _setTimes(ReminderType.meals, [...mealTimes]..[i] = t);
                },
                onRemove: (i) => _setTimes(ReminderType.meals, [...mealTimes]..removeAt(i)),
                onAdd: () async {
                  final t = await _pickTime(mealTimes.isEmpty ? '13:00' : mealTimes.last);
                  if (t != null) _setTimes(ReminderType.meals, [...mealTimes, t]);
                },
              ),
              if (np.mealTimes != null)
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: TextButton(
                    onPressed: () => _setTimes(ReminderType.meals, null),
                    child: Text(l.setNotifUseProfileTimes),
                  ),
                ),
            ],
          ),
          _ReminderCard(
            icon: Symbols.water_drop_rounded,
            title: l.setNotifWater,
            subtitle: l.setNotifWaterSub(profile.effectiveWake, profile.effectiveSleep),
            enabled: np.isEnabled(ReminderType.water),
            onEnabled: (v) => _setEnabled(ReminderType.water, v),
            children: [
              Row(
                children: [
                  Expanded(child: Text(l.setNotifWaterEvery)),
                  DropdownButton<int>(
                    value: np.waterIntervalHours,
                    underline: const SizedBox.shrink(),
                    items: [
                      for (final h in const [1, 2, 3, 4]) DropdownMenuItem(value: h, child: Text(l.setNotifHours(h))),
                    ],
                    onChanged: (h) async {
                      if (h == null) return;
                      await prefs.setInt(NotificationPrefs.waterIntervalKey, h);
                      _changed();
                    },
                  ),
                ],
              ),
              Text(
                waterTimes.isEmpty ? '—' : waterTimes.join(' · '),
                textDirection: TextDirection.ltr,
                textAlign: context.isAr ? TextAlign.right : TextAlign.left,
                style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
            ],
          ),
          _ReminderCard(
            icon: Symbols.pill_rounded,
            title: l.setNotifSupplements,
            subtitle: hasSupps ? (activeSupps.isNotEmpty ? activeSupps : profile.supplementNames).join('، ') : l.setNotifNoSupplements,
            enabled: np.isEnabled(ReminderType.supplements),
            onEnabled: (v) => _setEnabled(ReminderType.supplements, v),
            children: [
              _TimesEditor(
                times: np.supplementTimes,
                onEdit: (i) async {
                  final t = await _pickTime(np.supplementTimes[i]);
                  if (t != null) _setTimes(ReminderType.supplements, [...np.supplementTimes]..[i] = t);
                },
                onRemove: np.supplementTimes.length <= 1
                    ? null
                    : (i) => _setTimes(ReminderType.supplements, [...np.supplementTimes]..removeAt(i)),
                onAdd: () async {
                  final t = await _pickTime('21:00');
                  if (t != null) _setTimes(ReminderType.supplements, [...np.supplementTimes, t]);
                },
              ),
            ],
          ),
          _ReminderCard(
            icon: Symbols.monitor_weight_rounded,
            title: l.setNotifWeight,
            subtitle: l.setNotifWeightSub,
            enabled: np.isEnabled(ReminderType.weight),
            onEnabled: (v) => _setEnabled(ReminderType.weight, v),
            children: [
              _TimeRow(
                label: l.setNotifTime,
                time: weightTime,
                isCustom: np.weightTime != null,
                onEdit: () async => _setTime(ReminderType.weight, await _pickTime(weightTime)),
                onReset: () => _setTime(ReminderType.weight, null),
                resetLabel: l.setNotifWeightDefault,
              ),
            ],
          ),
          _ReminderCard(
            icon: Symbols.forum_rounded,
            title: l.setNotifCoach,
            subtitle: l.setNotifCoachSub,
            enabled: np.isEnabled(ReminderType.coach),
            onEnabled: (v) => _setEnabled(ReminderType.coach, v),
          ),
          _ReminderCard(
            icon: Symbols.backup_rounded,
            title: l.setNotifBackup,
            subtitle: l.setNotifBackupSub,
            enabled: np.isEnabled(ReminderType.backup),
            onEnabled: (v) => _setEnabled(ReminderType.backup, v),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => NotificationService.showNow(
              title: l.setNotifTestTitle,
              body: l.setNotifTestBody,
              channel: NotifChannel.workout,
            ),
            icon: const Icon(Symbols.notifications_active_rounded),
            label: Text(l.setNotifTest),
          ),
        ],
      ),
    );
  }
}

final _activeSupplementsProvider = StreamProvider<List<String>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.supplements)..where((t) => t.active.equals(true))).watch().map((r) => r.map((s) => s.name).toList());
});

class _PermissionBanner extends StatelessWidget {
  final String text;
  final String action;
  final VoidCallback onTap;
  const _PermissionBanner({required this.text, required this.action, required this.onTap});

  @override
  Widget build(BuildContext context) => Card(
        color: AppColors.warning.withValues(alpha: 0.12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              const Icon(Symbols.notifications_off_rounded, color: AppColors.warning),
              const SizedBox(width: 12),
              Expanded(child: Text(text)),
              TextButton(onPressed: onTap, child: Text(action)),
            ],
          ),
        ),
      );
}

class _ReminderCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool enabled;
  final ValueChanged<bool> onEnabled;
  final List<Widget> children;
  const _ReminderCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.enabled,
    required this.onEnabled,
    this.children = const [],
  });

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SwitchListTile(
                secondary: Icon(icon, color: enabled ? AppColors.primary : AppColors.textMuted),
                title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(subtitle, style: const TextStyle(color: AppColors.textMuted)),
                value: enabled,
                onChanged: onEnabled,
              ),
              if (enabled && children.isNotEmpty)
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
                ),
            ],
          ),
        ),
      );
}

class _TimeRow extends StatelessWidget {
  final String label;
  final String time;
  final bool isCustom;
  final VoidCallback onEdit;
  final VoidCallback onReset;
  final String resetLabel;
  const _TimeRow({
    required this.label,
    required this.time,
    required this.isCustom,
    required this.onEdit,
    required this.onReset,
    required this.resetLabel,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text(label)),
              ActionChip(
                avatar: const Icon(Symbols.schedule_rounded, size: 18),
                label: Text(time, textDirection: TextDirection.ltr),
                onPressed: onEdit,
              ),
            ],
          ),
          if (isCustom)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton(onPressed: onReset, child: Text(resetLabel)),
            ),
        ],
      );
}

class _TimesEditor extends StatelessWidget {
  final List<String> times;
  final ValueChanged<int> onEdit;
  final ValueChanged<int>? onRemove;
  final VoidCallback onAdd;
  const _TimesEditor({required this.times, required this.onEdit, required this.onRemove, required this.onAdd});

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (var i = 0; i < times.length; i++)
            InputChip(
              label: Text(times[i], textDirection: TextDirection.ltr),
              onPressed: () => onEdit(i),
              onDeleted: onRemove == null ? null : () => onRemove!(i),
            ),
          ActionChip(
            avatar: const Icon(Symbols.add_rounded, size: 18),
            label: Text(context.l10n.add),
            onPressed: times.length >= 10 ? null : onAdd,
          ),
        ],
      );
}
