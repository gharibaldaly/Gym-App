import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Library with search/filter/favorites. In [pickMode] tapping an exercise pops its id (String).
class ExerciseLibraryScreen extends ConsumerWidget {
  final bool pickMode;
  const ExerciseLibraryScreen({super.key, this.pickMode = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(appBar: AppBar(title: const Text('ExerciseLibraryScreen')), body: const Center(child: Text('TODO')));
  }
}
