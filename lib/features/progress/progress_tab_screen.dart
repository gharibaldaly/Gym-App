import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProgressTabScreen extends ConsumerWidget {
  const ProgressTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(appBar: AppBar(title: const Text('ProgressTabScreen')), body: const Center(child: Text('TODO')));
  }
}
