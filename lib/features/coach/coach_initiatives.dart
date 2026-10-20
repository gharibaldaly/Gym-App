import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';

/// Proactive coach messages: morning, workout summary, plateau, weekly report.
class CoachInitiatives {
  final Ref ref;
  CoachInitiatives(this.ref);

  /// Called right after a workout is finished (queues the AI summary if offline).
  Future<void> onWorkoutFinished(int sessionId) async {}

  /// Called when the local rule detects a plateau for [exerciseId].
  Future<void> explainPlateau(String exerciseId) async {}

  /// Morning message + weekly report when due. Safe to call often (on open / background).
  Future<void> runScheduledChecks() async {}
}

final coachInitiativesProvider = Provider<CoachInitiatives>((ref) => CoachInitiatives(ref));

/// Latest coach message to show on the Today tab.
final latestCoachMessageProvider = StreamProvider<CoachMessage?>((ref) => Stream.value(null));

/// Registers offline AI-queue handlers owned by the coach.
void registerCoachAiHandlers() {}
