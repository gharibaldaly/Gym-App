import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Overridden in main() with the loaded instance.
final sharedPrefsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPrefsProvider must be overridden in main()');
});

/// Lightweight key/value settings (not secrets – the API key lives in secure storage).
class SettingsKeys {
  static const language = 'language'; // 'ar' | 'en'
  static const lockEnabled = 'lock_enabled';
  static const lockAfterSeconds = 'lock_after_seconds';
  static const lastBackupAt = 'last_backup_at';
  static const modelHaiku = 'model_haiku';
  static const modelSonnet = 'model_sonnet';
  static const modelOpus = 'model_opus';
  static const useRefusalFallbacks = 'use_refusal_fallbacks';
  static const waterCupMl = 'water_cup_ml';
  static const waterBottleMl = 'water_bottle_ml';
  static const seedVersion = 'exercise_seed_version';
  static const lastHealthSync = 'last_health_sync';
  static const lastMorningMessage = 'last_morning_message'; // yyyy-MM-dd
  static const lastWeeklyReport = 'last_weekly_report'; // yyyy-MM-dd
  static const notificationPrefix = 'notif_'; // notif_<id>_enabled / notif_<id>_time
}

class LocaleNotifier extends Notifier<String> {
  @override
  String build() {
    final prefs = ref.watch(sharedPrefsProvider);
    return prefs.getString(SettingsKeys.language) ?? 'ar';
  }

  Future<void> set(String code) async {
    await ref.read(sharedPrefsProvider).setString(SettingsKeys.language, code);
    state = code;
  }
}

/// Current UI language code ('ar' or 'en').
final localeProvider = NotifierProvider<LocaleNotifier, String>(LocaleNotifier.new);
