import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/providers.dart';
import '../../data/repositories/profile_repository.dart';
import '../backup/backup_service.dart';
import 'cloud_store.dart';
import 'cloud_sync.dart';

export 'cloud_store.dart' show CloudConfig;
export 'cloud_sync.dart';

/// Supabase start-up. When it fails (or in tests, where it never runs) the app works
/// as before: no sign-in screen and no cloud backup.
class CloudRuntime {
  static bool _ready = false;
  static bool get ready => _ready;
  static String _appVersion = '';

  static Future<void> init() async {
    if (_ready) return;
    try {
      await Supabase.initialize(url: CloudConfig.url, publishableKey: CloudConfig.publishableKey)
          .timeout(const Duration(seconds: 10));
      _ready = true;
    } catch (e, st) {
      debugPrint('Supabase init failed: $e\n$st');
    }
    try {
      _appVersion = (await PackageInfo.fromPlatform()).version;
    } catch (_) {}
  }

  static GoTrueClient get auth => Supabase.instance.client.auth;
}

/// Whether accounts / cloud backup are available in this run.
final cloudEnabledProvider = Provider<bool>((ref) => CloudRuntime.ready);

/// The signed-in user (null when signed out).
final authUserProvider = StreamProvider<User?>((ref) async* {
  if (!ref.watch(cloudEnabledProvider)) {
    yield null;
    return;
  }
  final auth = CloudRuntime.auth;
  yield auth.currentUser;
  yield* auth.onAuthStateChange.map((s) => s.session?.user);
});

class _BackupOps implements CloudBackupOps {
  final BackupService backup;
  final AppDatabase db;
  _BackupOps(this.backup, this.db);

  @override
  Future<String> documentsDir() async => (await getApplicationDocumentsDirectory()).path;

  @override
  List<String> collectFiles(String docs) => BackupService.collectFiles(docs);

  @override
  Future<File> createCoreZip() => backup.createBackup(includeFiles: false);

  @override
  Future<Object> prepareRestore(String zipPath) => backup.prepareRestore(zipPath);

  @override
  String stagedFilesDir(Object prepared) => p.join((prepared as PreparedRestore).stagingDir, BackupManifest.filesDir);

  @override
  Future<void> applyRestore(Object prepared) => backup.applyRestore(prepared as PreparedRestore);

  @override
  Future<bool> hasLocalData() async => (await ProfileRepository(db).get())?.onboardingComplete ?? false;
}

/// Cloud backup for the signed-in user (null when accounts are unavailable).
final cloudSyncProvider = Provider<CloudSync?>((ref) {
  if (!ref.watch(cloudEnabledProvider)) return null;
  return CloudSync(
    store: SupabaseCloudStore(Supabase.instance.client),
    ops: _BackupOps(ref.read(backupServiceProvider), ref.read(databaseProvider)),
    prefs: ref.read(sharedPrefsProvider),
    appVersion: CloudRuntime._appVersion,
  );
});

/// Time of the last successful upload, refreshed after each one (settings shows it).
final cloudLastUploadProvider = NotifierProvider<CloudLastUpload, DateTime?>(CloudLastUpload.new);

class CloudLastUpload extends Notifier<DateTime?> {
  @override
  DateTime? build() => ref.read(cloudSyncProvider)?.lastUpload;
  void refresh() => state = ref.read(cloudSyncProvider)?.lastUpload;
}

/// Keeps the cloud backup current while the user is signed in: any database change
/// marks the data dirty and is uploaded ~90 s later, or right away when the app goes
/// to the background.
class CloudSyncHost extends ConsumerStatefulWidget {
  final String uid;
  final Widget child;
  const CloudSyncHost({super.key, required this.uid, required this.child});

  @override
  ConsumerState<CloudSyncHost> createState() => _CloudSyncHostState();
}

class _CloudSyncHostState extends ConsumerState<CloudSyncHost> {
  static const _debounce = Duration(seconds: 90);
  StreamSubscription<Object?>? _changes;
  AppLifecycleListener? _lifecycle;
  Timer? _timer;

  CloudSync? get _sync => ref.read(cloudSyncProvider);

  @override
  void initState() {
    super.initState();
    final db = ref.read(databaseProvider);
    _changes = db.tableUpdates().listen((_) async {
      await _sync?.markDirty();
      _schedule();
    });
    _lifecycle = AppLifecycleListener(
      onPause: _uploadIfDirty,
      onHide: _uploadIfDirty,
      onResume: () {
        if (_sync?.isDirty ?? false) _schedule();
      },
    );
    // Catch up on changes made while the app was closed or offline.
    if (_sync?.isDirty ?? false) _schedule();
  }

  void _schedule() {
    _timer?.cancel();
    _timer = Timer(_debounce, _uploadIfDirty);
  }

  Future<void> _uploadIfDirty() async {
    _timer?.cancel();
    final sync = _sync;
    if (sync == null || !sync.isDirty || !ref.read(isOnlineProvider)) return;
    try {
      await sync.upload(widget.uid);
      if (mounted) ref.read(cloudLastUploadProvider.notifier).refresh();
    } catch (e) {
      debugPrint('cloud backup failed: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _changes?.cancel();
    _lifecycle?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
