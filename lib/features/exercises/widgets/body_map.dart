import 'package:flutter/material.dart';

/// Front + back body silhouette; primary muscles dark green, secondary light green.
class BodyMap extends StatelessWidget {
  final List<String> primary;
  final List<String> secondary;
  final double height;
  const BodyMap({super.key, required this.primary, this.secondary = const [], this.height = 220});

  @override
  Widget build(BuildContext context) => SizedBox(height: height);
}
