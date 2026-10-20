import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironmind/data/db/database.dart';
import 'package:ironmind/features/settings/ai_cost.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  Future<void> add(DateTime ts, String feature, {int inTok = 0, int outTok = 0, int cr = 0, int cw = 0, double cost = 0}) =>
      db.into(db.aiUsage).insert(AiUsageCompanion.insert(
            feature: feature,
            model: 'claude-sonnet-5-5',
            timestamp: Value(ts),
            inputTokens: Value(inTok),
            outputTokens: Value(outTok),
            cacheReadTokens: Value(cr),
            cacheWriteTokens: Value(cw),
            costUsd: Value(cost),
          ));

  test('aggregates today / month / all time and per feature', () async {
    final now = DateTime(2026, 10, 20, 15, 30);
    await add(DateTime(2026, 10, 20, 9), 'chat', inTok: 1000, outTok: 500, cost: 0.01);
    await add(DateTime(2026, 10, 20, 14), 'chat', inTok: 2000, outTok: 100, cr: 300, cost: 0.02);
    await add(DateTime(2026, 10, 20, 10), 'food_photo', inTok: 4000, outTok: 200, cost: 0.05);
    await add(DateTime(2026, 10, 3), 'weekly_report', inTok: 10000, outTok: 3000, cw: 500, cost: 0.30);
    await add(DateTime(2026, 9, 28), 'chat', inTok: 100, outTok: 100, cost: 0.002);

    final s = await loadCostSummary(db, now: now);

    expect(s.today.total.requests, 3);
    expect(s.today.total.inputTokens, 7000);
    expect(s.today.total.outputTokens, 800);
    expect(s.today.total.cacheReadTokens, 300);
    expect(s.today.total.costUsd, closeTo(0.08, 1e-9));
    // Sorted by cost: food_photo (0.05) before chat (0.03).
    expect(s.today.byFeature.map((e) => e.key), ['food_photo', 'chat']);
    expect(s.today.byFeature.last.value.requests, 2);

    expect(s.month.total.requests, 4);
    expect(s.month.total.costUsd, closeTo(0.38, 1e-9));
    expect(s.month.byFeature.first.key, 'weekly_report');
    expect(s.month.total.cacheWriteTokens, 500);

    expect(s.allTime.total.requests, 5);
    expect(s.allTime.total.costUsd, closeTo(0.382, 1e-9));
    final chat = s.allTime.byFeature.firstWhere((e) => e.key == 'chat').value;
    expect(chat.requests, 3);
    expect(chat.inputTokens, 3100);
    expect(chat.totalTokens, 3100 + 700 + 300);
  });

  test('empty table gives zeros', () async {
    final s = await loadCostSummary(db, now: DateTime(2026, 1, 1));
    expect(s.allTime.total.requests, 0);
    expect(s.allTime.total.costUsd, 0);
    expect(s.month.byFeature, isEmpty);
  });

  test('formatters', () {
    expect(fmtUsd(0), r'$0.00');
    expect(fmtUsd(0.0034), r'$0.0034');
    expect(fmtUsd(0.25), r'$0.250');
    expect(fmtUsd(12.345), r'$12.35');
    expect(fmtTokens(950), '950');
    expect(fmtTokens(1234), '1.2K');
    expect(fmtTokens(45600), '46K');
    expect(fmtTokens(2500000), '2.50M');
  });
}
