import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';

/// Token + cost totals for a set of ai_usage rows.
class UsageTotals {
  final int requests;
  final int inputTokens;
  final int outputTokens;
  final int cacheReadTokens;
  final int cacheWriteTokens;
  final double costUsd;

  const UsageTotals({
    this.requests = 0,
    this.inputTokens = 0,
    this.outputTokens = 0,
    this.cacheReadTokens = 0,
    this.cacheWriteTokens = 0,
    this.costUsd = 0,
  });

  static const zero = UsageTotals();

  int get totalTokens => inputTokens + outputTokens + cacheReadTokens + cacheWriteTokens;

  UsageTotals operator +(UsageTotals o) => UsageTotals(
        requests: requests + o.requests,
        inputTokens: inputTokens + o.inputTokens,
        outputTokens: outputTokens + o.outputTokens,
        cacheReadTokens: cacheReadTokens + o.cacheReadTokens,
        cacheWriteTokens: cacheWriteTokens + o.cacheWriteTokens,
        costUsd: costUsd + o.costUsd,
      );
}

/// Totals for one period, plus the per-feature breakdown (sorted by cost, highest first).
class PeriodUsage {
  final UsageTotals total;
  final List<MapEntry<String, UsageTotals>> byFeature;
  const PeriodUsage(this.total, this.byFeature);
  static const empty = PeriodUsage(UsageTotals.zero, []);
}

class CostSummary {
  final PeriodUsage today;
  final PeriodUsage month;
  final PeriodUsage allTime;
  const CostSummary({required this.today, required this.month, required this.allTime});
}

/// Aggregates ai_usage with SQL (GROUP BY feature) for rows at/after [since] (null → all rows).
Future<PeriodUsage> aggregateUsage(AppDatabase db, {DateTime? since}) async {
  final t = db.aiUsage;
  final n = t.id.count();
  final inTok = t.inputTokens.sum();
  final outTok = t.outputTokens.sum();
  final cr = t.cacheReadTokens.sum();
  final cw = t.cacheWriteTokens.sum();
  final cost = t.costUsd.sum();
  final q = db.selectOnly(t)
    ..addColumns([t.feature, n, inTok, outTok, cr, cw, cost])
    ..groupBy([t.feature]);
  if (since != null) q.where(t.timestamp.isBiggerOrEqualValue(since));
  final rows = await q.get();
  var total = UsageTotals.zero;
  final list = <MapEntry<String, UsageTotals>>[];
  for (final r in rows) {
    final u = UsageTotals(
      requests: r.read(n) ?? 0,
      inputTokens: r.read(inTok) ?? 0,
      outputTokens: r.read(outTok) ?? 0,
      cacheReadTokens: r.read(cr) ?? 0,
      cacheWriteTokens: r.read(cw) ?? 0,
      costUsd: r.read(cost) ?? 0,
    );
    total = total + u;
    list.add(MapEntry(r.read(t.feature) ?? '?', u));
  }
  list.sort((a, b) {
    final c = b.value.costUsd.compareTo(a.value.costUsd);
    return c != 0 ? c : b.value.totalTokens.compareTo(a.value.totalTokens);
  });
  return PeriodUsage(total, list);
}

/// Today / this month / all time, relative to [now] (local time).
Future<CostSummary> loadCostSummary(AppDatabase db, {DateTime? now}) async {
  final t = now ?? DateTime.now();
  return CostSummary(
    today: await aggregateUsage(db, since: DateTime(t.year, t.month, t.day)),
    month: await aggregateUsage(db, since: DateTime(t.year, t.month)),
    allTime: await aggregateUsage(db),
  );
}

/// Live cost summary (recomputed whenever ai_usage changes).
final costSummaryProvider = StreamProvider<CostSummary>((ref) {
  final db = ref.watch(databaseProvider);
  final trigger = db.customSelect('SELECT COUNT(*) AS c, MAX(id) AS m FROM ai_usage', readsFrom: {db.aiUsage}).watch();
  return trigger.asyncMap((_) => loadCostSummary(db));
});

/// "$0.0123" for small amounts, "$1.23" otherwise.
String fmtUsd(double v) {
  if (v == 0) return '\$0.00';
  if (v < 0.01) return '\$${v.toStringAsFixed(4)}';
  if (v < 1) return '\$${v.toStringAsFixed(3)}';
  return '\$${v.toStringAsFixed(2)}';
}

/// 1234 → "1.2K", 2500000 → "2.5M".
String fmtTokens(int v) {
  if (v < 1000) return '$v';
  if (v < 1000000) return '${(v / 1000).toStringAsFixed(v < 10000 ? 1 : 0)}K';
  return '${(v / 1000000).toStringAsFixed(v < 10000000 ? 2 : 1)}M';
}
