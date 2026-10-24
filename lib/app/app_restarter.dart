import 'package:flutter/widgets.dart';

/// Lets a screen restart the app's provider tree (used after restoring a backup,
/// which swaps the database file underneath the open connection).
class AppRestarter extends InheritedWidget {
  final VoidCallback restart;
  const AppRestarter({super.key, required this.restart, required super.child});

  static void restartApp(BuildContext context) =>
      context.getInheritedWidgetOfExactType<AppRestarter>()?.restart();

  @override
  bool updateShouldNotify(AppRestarter old) => false;
}
