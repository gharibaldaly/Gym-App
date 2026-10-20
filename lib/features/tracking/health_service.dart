import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Health Connect (smart ring) sync: sleep + stages, HR, resting HR, HRV, steps, active calories.
class HealthService {
  final Ref ref;
  HealthService(this.ref);

  /// Called on app open and from the background task. Never throws.
  Future<void> sync() async {}
}

final healthServiceProvider = Provider<HealthService>((ref) => HealthService(ref));
