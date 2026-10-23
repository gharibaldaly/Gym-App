import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../nutrition/meal_plan_generator.dart';
import '../workout/plan_generator.dart';
import 'coach_proposals.dart';
import 'coach_repository.dart';

/// What happened when a proposal was accepted (lets the UI follow up).
class ProposalAcceptResult {
  /// A new workout plan was generated and waits for review (PlanReviewScreen).
  final int? reviewPlanId;

  /// A new meal plan was generated and is now active.
  final bool mealPlanActivated;
  const ProposalAcceptResult({this.reviewPlanId, this.mealPlanActivated = false});
}

/// Accepts coach proposals. DB changes go through [ProposalApplier] in one transaction;
/// "regenerate" proposals run the AI plan generators first and are marked accepted only
/// once the new plan exists, so a failed generation leaves the card pending to retry.
class CoachProposalRunner {
  final Ref ref;
  CoachProposalRunner(this.ref);

  Future<ProposalAcceptResult> accept(CoachProposal p) async {
    final applier = ref.read(proposalApplierProvider);
    final payload = p.payload;
    switch (p.type) {
      case ProposalTypes.regenerateWorkoutPlan:
        final days = (payload['trainingDays'] as List?)?.map((e) => (e as num).toInt()).toList();
        final planId = await ref
            .read(workoutPlanGeneratorProvider)
            .generateAndSave(instructions: payload['instructions'] as String?, trainingDays: days);
        await applier.markAccepted(p.id);
        return ProposalAcceptResult(reviewPlanId: planId);
      case ProposalTypes.regenerateMealPlan:
        await ref
            .read(mealPlanGeneratorProvider)
            .generate(allowTemplateFallback: false, extraInstructions: payload['instructions'] as String?);
        await applier.markAccepted(p.id);
        return const ProposalAcceptResult(mealPlanActivated: true);
      default:
        await applier.accept(p.id);
        return const ProposalAcceptResult();
    }
  }
}

final coachProposalRunnerProvider = Provider<CoachProposalRunner>((ref) => CoachProposalRunner(ref));
