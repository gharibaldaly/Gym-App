import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/settings/app_settings.dart' show SettingsKeys;
import 'cloud_store.dart';

/// The parts of the local backup machinery the cloud sync needs (see BackupService).
abstract class CloudBackupOps {
  /// App documents folder (photos and other user files live under it).
  Future<String> documentsDir();

  /// User files under [documentsDir] that belong in a backup (relative posix paths).
  List<String> collectFiles(String docs);

  /// Zip with the database snapshot, settings and manifest, without user files.
  Future<File> createCoreZip();

  /// Extracts and validates a core zip; returns a handle for [stagedFilesDir] / [applyRestore].
  Future<Object> prepareRestore(String zipPath);

  /// Folder inside a prepared restore where user files are placed before [applyRestore].
  String stagedFilesDir(Object prepared);

  /// Replaces all local data with the prepared backup (closes the database).
  Future<void> applyRestore(Object prepared);

  /// Whether this device already holds the user's data (finished onboarding).
  Future<bool> hasLocalData();
}

/// Summary of the backup in the cloud (`<uid>/meta.json`).
class CloudBackupInfo {
  final DateTime createdAt;
  final int fileCount;
  final String appVersion;
  const CloudBackupInfo({required this.createdAt, required this.fileCount, this.appVersion = ''});

  Map<String, dynamic> toJson() => {
        'created_at': createdAt.toUtc().toIso8601String(),
        'file_count': fileCount,
        'app_version': appVersion,
      };

  static CloudBackupInfo? tryParse(Uint8List? bytes) {
    if (bytes == null) return null;
    try {
      final j = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
      return CloudBackupInfo(
        createdAt: DateTime.parse(j['created_at'] as String).toLocal(),
        fileCount: (j['file_count'] as num?)?.toInt() ?? 0,
        appVersion: (j['app_version'] ?? '').toString(),
      );
    } catch (_) {
      return null;
    }
  }
}

/// What to do right after signing in on this device.
enum LoginSyncAction {
  /// Nothing to sync yet (no local data, no cloud backup): start onboarding.
  none,

  /// Local data only: upload it.
  upload,

  /// Cloud backup only (fresh install): restore it.
  restore,

  /// Both exist: the user picks which one wins.
  choose,
}

LoginSyncAction decideLoginSync({required bool hasLocal, required bool hasCloud}) => switch ((hasLocal, hasCloud)) {
      (false, false) => LoginSyncAction.none,
      (true, false) => LoginSyncAction.upload,
      (false, true) => LoginSyncAction.restore,
      (true, true) => LoginSyncAction.choose,
    };

/// Backs the whole app up to the user's private cloud folder and restores it:
///
///   `<uid>/meta.json`         when / what was backed up (also: "is there a backup?")
///   `<uid>/core.zip`          database snapshot + settings (small)
///   `<uid>/files_index.json`  every user file in the backup
///   `<uid>/files/<path>`      each photo / media file, uploaded only when it changed
///
/// Files go up one by one so the size of one object stays far below storage limits,
/// and an unchanged photo is never uploaded twice.
class CloudSync {
  final CloudStore store;
  final CloudBackupOps ops;
  final SharedPreferences prefs;
  final String appVersion;
  CloudSync({required this.store, required this.ops, required this.prefs, this.appVersion = ''});

  /// Settings keys used by the sync itself (device-specific, never backed up / restored).
  static const prefix = 'cloud_';
  static const lastUploadKey = 'cloud_last_upload';
  static const dirtyKey = 'cloud_dirty_since';
  static String ledgerKey(String uid) => 'cloud_files_$uid';
  static String resolvedKey(String uid) => 'cloud_resolved_$uid';

  static String metaPath(String uid) => '$uid/meta.json';
  static String corePath(String uid) => '$uid/core.zip';
  static String indexPath(String uid) => '$uid/files_index.json';
  static String filePath(String uid, String rel) => '$uid/files/$rel';

  Future<void>? _running;

  DateTime? get lastUpload => DateTime.tryParse(prefs.getString(lastUploadKey) ?? '');
  bool get isDirty => prefs.getString(dirtyKey) != null;

  /// Marks local data as changed since the last upload.
  Future<void> markDirty() async {
    if (!isDirty) await prefs.setString(dirtyKey, DateTime.now().toIso8601String());
  }

  bool isResolved(String uid) => prefs.getBool(resolvedKey(uid)) ?? false;
  Future<void> markResolved(String uid) => prefs.setBool(resolvedKey(uid), true);

  Future<CloudBackupInfo?> remoteInfo(String uid) async => CloudBackupInfo.tryParse(await store.download(metaPath(uid)));

  Future<LoginSyncAction> decide(String uid) async =>
      decideLoginSync(hasLocal: await ops.hasLocalData(), hasCloud: await remoteInfo(uid) != null);

  static String _signature(File f) {
    final s = f.statSync();
    return '${s.size}:${s.modified.millisecondsSinceEpoch}';
  }

  Map<String, String> _ledger(String uid) {
    try {
      return (jsonDecode(prefs.getString(ledgerKey(uid)) ?? '{}') as Map).cast<String, String>();
    } catch (_) {
      return {};
    }
  }

  Future<void> _saveLedger(String uid, Map<String, String> ledger) =>
      prefs.setString(ledgerKey(uid), jsonEncode(ledger));

  /// Uploads everything that changed. Concurrent calls share one run.
  Future<void> upload(String uid, {void Function(double progress)? onProgress}) {
    return _running ??= _upload(uid, onProgress).whenComplete(() => _running = null);
  }

  Future<void> _upload(String uid, void Function(double)? onProgress) async {
    final dirtyAtStart = prefs.getString(dirtyKey);
    final docs = await ops.documentsDir();
    final files = ops.collectFiles(docs);
    final ledger = _ledger(uid);

    final changed = [
      for (final rel in files)
        if (ledger[rel] != _signature(File(p.join(docs, rel)))) rel,
    ];
    final steps = changed.length + 3;
    var done = 0;
    void step() => onProgress?.call(++done / steps);

    for (final rel in changed) {
      final f = File(p.join(docs, rel));
      if (!f.existsSync()) continue;
      await store.upload(filePath(uid, rel), await f.readAsBytes());
      ledger[rel] = _signature(f);
      await _saveLedger(uid, ledger);
      step();
    }
    final current = files.toSet();
    final gone = ledger.keys.where((k) => !current.contains(k)).toList();
    if (gone.isNotEmpty) {
      await store.remove([for (final rel in gone) filePath(uid, rel)]);
      for (final rel in gone) {
        ledger.remove(rel);
      }
      await _saveLedger(uid, ledger);
    }

    await store.upload(indexPath(uid), _json(files), contentType: 'application/json');
    step();
    final core = await ops.createCoreZip();
    try {
      await store.upload(corePath(uid), await core.readAsBytes(), contentType: 'application/zip');
    } finally {
      try {
        await core.delete();
      } catch (_) {}
    }
    step();
    final now = DateTime.now();
    await store.upload(
      metaPath(uid),
      _json(CloudBackupInfo(createdAt: now, fileCount: files.length, appVersion: appVersion).toJson()),
      contentType: 'application/json',
    );
    step();
    await prefs.setString(lastUploadKey, now.toIso8601String());
    // A cloud copy counts as a backup: no "back up your data" reminders while it runs.
    await prefs.setString(SettingsKeys.lastBackupAt, now.toIso8601String());
    // Only clear the flag if nothing changed while uploading.
    if (prefs.getString(dirtyKey) == dirtyAtStart) await prefs.remove(dirtyKey);
  }

  /// Replaces local data with the cloud backup. The database is closed afterwards,
  /// so the app must restart its provider tree.
  Future<void> restore(String uid, {void Function(double progress)? onProgress}) async {
    final core = await store.download(corePath(uid));
    if (core == null) throw StateError('No cloud backup');
    final indexBytes = await store.download(indexPath(uid));
    final index = indexBytes == null ? const <String>[] : (jsonDecode(utf8.decode(indexBytes)) as List).cast<String>();

    final tmp = await Directory.systemTemp.createTemp('ironmind_cloud');
    try {
      final zip = File(p.join(tmp.path, 'core.zip'));
      await zip.writeAsBytes(core);
      final prepared = await ops.prepareRestore(zip.path);
      final staged = ops.stagedFilesDir(prepared);
      final steps = index.length + 1;
      for (final (i, rel) in index.indexed) {
        final bytes = await store.download(filePath(uid, rel));
        if (bytes != null) {
          final target = p.join(staged, rel);
          if (!p.isWithin(staged, target)) continue;
          await Directory(p.dirname(target)).create(recursive: true);
          await File(target).writeAsBytes(bytes);
        }
        onProgress?.call((i + 1) / steps);
      }
      await ops.applyRestore(prepared);
      onProgress?.call(1);
    } finally {
      try {
        await tmp.delete(recursive: true);
      } catch (_) {}
    }

    // What is on disk now matches the cloud: remember it so nothing is re-uploaded.
    final docs = await ops.documentsDir();
    await _saveLedger(uid, {
      for (final rel in ops.collectFiles(docs))
        if (index.contains(rel)) rel: _signature(File(p.join(docs, rel))),
    });
    await prefs.setString(lastUploadKey, DateTime.now().toIso8601String());
    await prefs.remove(dirtyKey);
  }

  static Uint8List _json(Object value) => Uint8List.fromList(utf8.encode(jsonEncode(value)));
}
