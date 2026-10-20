import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ml drunk today.
final todayWaterProvider = StreamProvider<int>((ref) => Stream.value(0));

/// Daily water goal in ml.
final waterGoalProvider = Provider<int>((ref) => 3000);

/// Adds water (one-tap cup/bottle) for now.
Future<void> addWater(WidgetRef ref, int ml) async {}

/// Latest logged body weight (kg) and its 7-day moving average.
final latestWeightProvider = StreamProvider<({double? weight, double? avg7})>((ref) => Stream.value((weight: null, avg7: null)));

/// Today's recovery score 0-100 (null when no data).
final todayRecoveryProvider = StreamProvider<int?>((ref) => Stream.value(null));
