import 'package:flutter_test/flutter_test.dart';
import 'package:ironmind/core/providers.dart';
import 'package:ironmind/features/coach/coach_context.dart';
import 'package:ironmind/features/coach/coach_persona.dart';

import 'coach_fixtures.dart';

void main() {
  late CoachFixture f;
  setUp(() async => f = await seedCoachDb());
  tearDown(() => f.db.close());

  test('stable part = persona + profile + compact plan with ids', () async {
    final ctx = await CoachContextBuilder(f.db, lang: 'ar', now: testNow).build();
    expect(ctx.stable, startsWith(coachPersona('ar')));
    expect(ctx.stable, contains('"goal": "cut"'));
    expect(ctx.stable, contains('planDayId ${f.pushDayId} Tue "Push A" (chest)'));
    expect(ctx.stable, contains('[pe ${f.benchPeId}] بنش برس بالبار (Barbell_Bench_Press) 3x6-8 80kg rest120s'));
    expect(ctx.stable, contains('planDayId ${f.restDayId} Wed "Rest": rest'));
    // Nothing date-dependent in the cached part.
    expect(ctx.stable, isNot(contains('2026-10-20')));
  });

  test('dynamic part summarises the last 7 days', () async {
    final ctx = await CoachContextBuilder(f.db, lang: 'en', now: testNow).build();
    final d = ctx.dynamicPart;
    expect(d, contains('Today 2026-10-20 (Tue)'));
    expect(d, contains('planned: planDayId ${f.pushDayId} "Push A"'));
    // Session condensed: warm-up ignored, top set, volume, PR flags.
    expect(d, contains('2026-10-15 Thu "Push A" completed 65min'));
    expect(d, contains('Barbell Bench Press: 2 sets [80x8, 80x7], top 80x8 @8, vol 1200, PR(weight/e1rm)'));
    expect(d, contains('Cable Fly: 1 sets [15x12]'));
    expect(d, contains('2026-10-17 Sat "Push A" missed'));
    // The session on 10-06 is outside the 7-day window.
    expect(d, isNot(contains('2026-10-06 Tue')));
    // Nutrition totals vs targets (rest day carbs on Monday 10-19).
    expect(d, contains('2026-10-19: 2100/2280 kcal, P 150/180, C 230/210, F 55/70 (2 meals)'));
    expect(d, contains('2026-10-18: no meals logged'));
    // Weight trend.
    expect(d, contains('latest 82.2kg (2026-10-19)'));
    expect(d, contains('7-day avg 82.2'));
    expect(d, contains('previous 7-day avg 83.2'));
    // Sleep + recovery.
    expect(d, contains('2026-10-19: sleep 6.5h q3/5, recovery 55, HRV 48, RHR 58'));
    // PRs, memory.
    expect(d, contains('Barbell Bench Press: 80x8 (e1RM 101)'));
    expect(d, contains('الكتف الشمال بيوجع'));
    expect(d, contains('PENDING PROPOSALS'));
  });

  test('context stays compact', () async {
    final ctx = await CoachContextBuilder(f.db, lang: 'ar', now: testNow).build();
    expect(ctx.approxTokens, lessThan(4000));
    final blocks = ctx.systemBlocks;
    expect(blocks, hasLength(2));
    expect(blocks.first['cache_control'], {'type': 'ephemeral'});
    expect(blocks.last.containsKey('cache_control'), isFalse);
  });

  test('empty database still builds', () async {
    final empty = await seedCoachDb(withLogs: false);
    addTearDown(empty.db.close);
    final ctx = await CoachContextBuilder(empty.db, lang: 'en', now: testNow).build();
    expect(ctx.dynamicPart, contains('(no meals logged in this period)'));
    expect(ctx.dynamicPart, contains('(no weigh-ins in the last 3 weeks)'));
    expect(ctx.dynamicPart, contains('(no sets logged yet)'));
  });

  test('condenseSets skips warm-ups and picks heaviest set', () {
    SetLog s(int id, String ex, double w, int r, {String type = 'normal'}) => SetLog(
          id: id,
          sessionId: 1,
          exerciseId: ex,
          setIndex: id,
          weightKg: w,
          reps: r,
          setType: type,
          isPr: false,
          createdAt: testNow,
        );
    final c = condenseSets([s(1, 'a', 20, 10, type: 'warmup'), s(2, 'a', 60, 8), s(3, 'a', 60, 9), s(4, 'b', 10, 12)]);
    expect(c, hasLength(2));
    expect(c.first.workingSets, 2);
    expect(c.first.top.reps, 9);
    expect(c.first.volume, 60 * 8 + 60 * 9);
  });
}
