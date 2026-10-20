import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../core/utils/context_ext.dart' show dayOf;
import '../../data/repositories/profile_repository.dart';
import 'onboarding_logic.dart';

/// DB side effects of onboarding answers that live outside user_profiles:
/// the initial body_metrics row and the `supplements` table.
class OnboardingData {
  final AppDatabase db;
  OnboardingData(this.db);

  /// Ensures the single profile row exists (language = current UI language).
  static Future<UserProfile> ensureProfile(ProfileRepository repo, String language) async {
    final existing = await repo.get();
    if (existing != null) return existing;
    await repo.upsert(UserProfilesCompanion(language: Value(language)));
    return (await repo.get())!;
  }

  /// Writes today's body_metrics row from the profile's weight, body fat and
  /// measurements (updates the row if one exists for today). Only non-null
  /// values are written so data logged elsewhere today is kept.
  Future<void> upsertTodayBodyMetric(UserProfile p, {DateTime? now}) async {
    final day = dayOf(now ?? DateTime.now());
    final m = parseMeasurements(p.measurementsJson);
    Value<double?> v(double? x) => x == null ? const Value.absent() : Value(x);
    final bf = p.bodyFatMethod == 'unknown' ? null : p.bodyFatPct;
    final data = BodyMetricsCompanion(
      date: Value(day),
      weightKg: v(p.weightKg),
      bodyFatPct: v(bf),
      waistCm: v(m['waist']),
      chestCm: v(m['chest']),
      armCm: v(m['arm']),
      thighCm: v(m['thigh']),
      neckCm: v(m['neck']),
      hipsCm: v(m['hips']),
    );
    final hasAny = p.weightKg != null || bf != null || m.isNotEmpty;
    if (!hasAny) return;
    final existing = await (db.select(db.bodyMetrics)
          ..where((t) => t.date.equals(day))
          ..orderBy([(t) => OrderingTerm.desc(t.id)])
          ..limit(1))
        .getSingleOrNull();
    if (existing == null) {
      await db.into(db.bodyMetrics).insert(data);
    } else {
      await (db.update(db.bodyMetrics)..where((t) => t.id.equals(existing.id))).write(data);
    }
  }

  /// Mirrors the supplements answer into the `supplements` table, matching by
  /// name (case-insensitive). Entries present in [previous] but removed from
  /// [current] are deactivated (history is kept); supplements added elsewhere
  /// in the app are left alone.
  Future<void> syncSupplements(List<SupplementEntry> previous, List<SupplementEntry> current) async {
    String norm(String s) => s.trim().toLowerCase();
    await db.transaction(() async {
      final rows = await db.select(db.supplements).get();
      final byName = {for (final r in rows) norm(r.name): r};
      final currentNames = <String>{};
      for (final e in current) {
        final name = e.name.trim();
        if (name.isEmpty) continue;
        currentNames.add(norm(name));
        final data = SupplementsCompanion(
          name: Value(name),
          dose: Value(e.dose.trim().isEmpty ? null : e.dose.trim()),
          timing: Value(e.timing),
          proteinG: Value(e.proteinG),
          calories: Value(e.calories),
          carbsG: Value(e.carbsG),
          fatG: Value(e.fatG),
          active: const Value(true),
        );
        final row = byName[norm(name)];
        if (row == null) {
          await db.into(db.supplements).insert(data);
        } else {
          await (db.update(db.supplements)..where((t) => t.id.equals(row.id))).write(data);
        }
      }
      for (final e in previous) {
        final n = norm(e.name);
        if (n.isEmpty || currentNames.contains(n)) continue;
        final row = byName[n];
        if (row != null && row.active) {
          await (db.update(db.supplements)..where((t) => t.id.equals(row.id)))
              .write(const SupplementsCompanion(active: Value(false)));
        }
      }
    });
  }
}

final onboardingDataProvider = Provider<OnboardingData>((ref) => OnboardingData(ref.watch(databaseProvider)));
