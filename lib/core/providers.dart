import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/db/database.dart';

export '../data/db/database.dart';
export 'settings/app_settings.dart';

/// Single database instance for the whole app. Overridden in tests with an in-memory DB.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  // Closing twice (a restore already closed it) must not surface as an error.
  ref.onDispose(() => db.close().catchError((_) {}));
  return db;
});

/// Emits true when any network interface is up. (A connected interface does not
/// guarantee internet, so AI calls still handle network errors.)
final connectivityProvider = StreamProvider<bool>((ref) async* {
  final c = Connectivity();
  bool online(List<ConnectivityResult> r) => r.any((e) => e != ConnectivityResult.none);
  yield online(await c.checkConnectivity());
  yield* c.onConnectivityChanged.map(online);
});

final isOnlineProvider = Provider<bool>((ref) {
  return ref.watch(connectivityProvider).value ?? true;
});
