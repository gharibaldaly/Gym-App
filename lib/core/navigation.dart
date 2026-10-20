import 'package:flutter/material.dart';

import '../features/settings/settings_screen.dart';

Future<T?> push<T>(BuildContext context, Widget page) =>
    Navigator.of(context).push<T>(MaterialPageRoute(builder: (_) => page));

void openSettings(BuildContext context) => push(context, const SettingsScreen());
