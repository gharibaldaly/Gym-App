import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LiveWorkoutScreen extends ConsumerWidget {
  final int? planDayId;
  final int? sessionId;
  const LiveWorkoutScreen({super.key, this.planDayId, this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(appBar: AppBar(title: const Text('LiveWorkoutScreen')), body: const Center(child: Text('TODO')));
  }
}
