import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Review/edit a generated plan (remove/add/swap/reorder) then approve (activate).
class PlanReviewScreen extends ConsumerWidget {
  final int planId;
  final VoidCallback? onApproved;
  const PlanReviewScreen({super.key, required this.planId, this.onApproved});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(appBar: AppBar(title: const Text('PlanReviewScreen')), body: const Center(child: Text('TODO')));
  }
}
