import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:archive/archive_io.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// package_info_plus comes with share_plus/workmanager; it only reads the app version.
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/providers.dart';
import '../notifications/reminder_planner.dart' show NotificationPrefs;
import 'backup_manifest.dart';

export 'backup_manifest.dart';

/// Thrown when a picked file is not a usable IronMind backup.
class BackupException implements Exception {
  final BackupProblem? problem;
  final String message;
  BackupException(this.message, {this.problem});
  @override
  String toString() => 'BackupException($message)';
}

/// A backup extracted to a staging folder and validated, ready to be applied.
class PreparedRestore {
  final BackupManifest manifest;
  final String stagingDir;
  const PreparedRestore(this.manifest, this.stagingDir);
}

/// Export/import a single zip (database + photos). The API key is never included
/// (it lives in flutter_secure_storage, which is not part of the app documents folder).
class BackupService {
  final AppDatabase db;
  final SharedPreferences prefs;
  BackupService(this.db, this.prefs);

  /// Folders under the documents dir that are caches / re-downloadable and are not backed up.
  /// Other features may add their own cache folder names here.
  static final Set<String> excludedDirs = {
    'backup_tmp',
    'restore_tmp',
    'flutter_assets',
    'cache',
    'tmp',
    'home_widget',
    'exercise_images',
    'exercise_images_offline',
    'exercise_media_cache',
    'offline_exercise_images',
  };

  /// SharedPreferences keys never restored from a backup (device-specific).
  static const Set<String> _prefsNotRestored = {
    SettingsKeys.lastHealthSync,
    NotificationPrefs.backupReminderShownKey,
  };

  /// Keys owned by the device, never written to or read from a backup: the
  /// sign-in session ("sb-…", supabase_flutter) and the cloud sync's state ("cloud_…").
  static bool isDeviceOnlyKey(String key) => key.startsWith('sb-') || key.startsWith('cloud_');

  static String get dbFileName => '${AppDatabase.dbName}.sqlite';

  static bool _isDbFile(String name) {
    final base = dbFileName;
    return name == base || name == '$base-wal' || name == '$base-shm' || name == '$base-journal';
  }

  /// Every user file under [docs] that belongs in a backup (relative posix paths).
  static List<String> collectFiles(String docs) {
    final root = Directory(docs);
    if (!root.existsSync()) return const [];
    final out = <String>[];
    void walk(Directory d, String rel) {
      for (final e in d.listSync(followLinks: false)) {
        final name = p.basename(e.path);
        final r = rel.isEmpty ? name : '$rel/$name';
        if (e is Directory) {
          if (rel.isEmpty && excludedDirs.contains(name)) continue;
          walk(e, r);
        } else if (e is File) {
          if (rel.isEmpty && _isDbFile(name)) continue;
          out.add(r);
        }
      }
    }

    walk(root, '');
    return out;
  }

  Map<String, Object> _prefsSnapshot() {
    final out = <String, Object>{};
    for (final k in prefs.getKeys()) {
      if (isDeviceOnlyKey(k)) continue;
      final v = prefs.get(k);
      if (v is String || v is bool || v is int || v is double) {
        out[k] = v!;
      } else if (v is List) {
        out[k] = v.map((e) => e.toString()).toList();
      }
    }
    return out;
  }

  /// Builds the backup zip in the temp folder and returns it. Without [includeFiles]
  /// it holds only the database and settings (the cloud backup uploads files separately).
  Future<File> createBackup({bool includeFiles = true}) async {
    final docs = (await getApplicationDocumentsDirectory()).path;
    final tmpRoot = Directory(p.join((await getTemporaryDirectory()).path, 'backup_tmp'));
    if (tmpRoot.existsSync()) await tmpRoot.delete(recursive: true);
    await tmpRoot.create(recursive: true);

    // Consistent snapshot of the live DB (works while the app keeps using it).
    final snap = p.join(tmpRoot.path, 'snapshot.sqlite');
    await db.customStatement("VACUUM INTO '${snap.replaceAll("'", "''")}'");

    final info = await _packageInfo();
    final files = includeFiles ? collectFiles(docs) : const <String>[];
    final now = DateTime.now();
    final manifest = BackupManifest(
      appVersion: info.$1,
      buildNumber: info.$2,
      schemaVersion: db.schemaVersion,
      createdAt: now,
      documentsPath: docs,
      fileCount: files.length,
    );
    final stamp = '${now.year}${_pad2(now.month)}${_pad2(now.day)}-${_pad2(now.hour)}${_pad2(now.minute)}';
    final zipPath = p.join(tmpRoot.path, 'IronMind-backup-$stamp.zip');
    final manifestJson = const JsonEncoder.withIndent('  ').convert(manifest.toJson());
    final prefsJson = jsonEncode(_prefsSnapshot());

    await _writeZipInIsolate(zipPath, snap, docs, files, manifestJson, prefsJson);
    await File(snap).delete();
    return File(zipPath);
  }

  // Static wrappers so the isolate closures never capture `this` (the DB isn't sendable).
  static Future<void> _writeZipInIsolate(
    String zipPath,
    String snap,
    String docs,
    List<String> files,
    String manifestJson,
    String prefsJson,
  ) =>
      Isolate.run(() => _writeZip(
            zipPath: zipPath,
            dbSnapshot: snap,
            docs: docs,
            files: files,
            manifestJson: manifestJson,
            prefsJson: prefsJson,
          ));

  static Future<void> _extractInIsolate(String zip, String outDir) =>
      Isolate.run(() => extractFileToDisk(zip, outDir));

  static String _pad2(int v) => v.toString().padLeft(2, '0');

  static Future<void> _writeZip({
    required String zipPath,
    required String dbSnapshot,
    required String docs,
    required List<String> files,
    required String manifestJson,
    required String prefsJson,
  }) async {
    final enc = ZipFileEncoder();
    enc.create(zipPath);
    enc.addArchiveFile(ArchiveFile.string(BackupManifest.fileName, manifestJson));
    enc.addArchiveFile(ArchiveFile.string(BackupManifest.prefsEntry, prefsJson));
    await enc.addFile(File(dbSnapshot), BackupManifest.dbEntry);
    for (final rel in files) {
      final f = File(p.join(docs, rel));
      if (f.existsSync()) await enc.addFile(f, '${BackupManifest.filesDir}/$rel');
    }
    await enc.close();
  }

  static Future<(String, String)> _packageInfo() async {
    try {
      final i = await PackageInfo.fromPlatform();
      return (i.version, i.buildNumber);
    } catch (_) {
      return ('1.0.0', '');
    }
  }

  /// Creates the zip and opens the share sheet (Drive, Files, …). Records the backup
  /// time unless the user dismissed the sheet.
  Future<bool> exportAndShare({String? subject}) async {
    final zip = await createBackup();
    final res = await SharePlus.instance.share(ShareParams(
      files: [XFile(zip.path, mimeType: 'application/zip')],
      subject: subject ?? p.basename(zip.path),
      title: subject ?? p.basename(zip.path),
    ));
    if (res.status == ShareResultStatus.dismissed) return false;
    await prefs.setString(SettingsKeys.lastBackupAt, DateTime.now().toIso8601String());
    return true;
  }

  /// Extracts [zipPath] to a staging folder and validates its manifest.
  Future<PreparedRestore> prepareRestore(String zipPath) async {
    final tmp = await getTemporaryDirectory();
    final staging = Directory(p.join(tmp.path, 'restore_tmp'));
    if (staging.existsSync()) await staging.delete(recursive: true);
    await staging.create(recursive: true);
    // extractFileToDisk needs a .zip extension.
    final zipCopy = p.join(tmp.path, 'restore_input.zip');
    if (p.normalize(zipPath) != p.normalize(zipCopy)) await File(zipPath).copy(zipCopy);
    try {
      await _extractInIsolate(zipCopy, staging.path);
    } catch (e) {
      throw BackupException('not a zip: $e', problem: BackupProblem.notJson);
    } finally {
      try {
        await File(zipCopy).delete();
      } catch (_) {}
    }
    final mf = File(p.join(staging.path, BackupManifest.fileName));
    if (!mf.existsSync()) throw BackupException('manifest missing', problem: BackupProblem.wrongApp);
    Object? json;
    try {
      json = jsonDecode(await mf.readAsString());
    } catch (_) {
      throw BackupException('manifest is not JSON', problem: BackupProblem.notJson);
    }
    final dbEntry = json is Map && json['db'] is String ? json['db'] as String : BackupManifest.dbEntry;
    final dbFile = File(p.normalize(p.join(staging.path, dbEntry)));
    final v = validateBackupManifest(
      json,
      currentSchemaVersion: db.schemaVersion,
      dbExists: p.isWithin(staging.path, dbFile.path) && dbFile.existsSync(),
    );
    if (!v.isValid) throw BackupException('invalid backup: ${v.problem}', problem: v.problem);
    return PreparedRestore(v.manifest!, staging.path);
  }

  /// Replaces ALL local data with the staged backup. Closes [db] – the app must
  /// be restarted afterwards.
  Future<void> applyRestore(PreparedRestore r) async {
    final docs = (await getApplicationDocumentsDirectory()).path;
    final stagedDb = p.join(r.stagingDir, r.manifest.db);

    // 1. Upgrade the staged DB to the current schema and rewrite absolute media paths.
    final staged = AppDatabase(NativeDatabase(File(stagedDb)));
    try {
      await staged.customSelect('SELECT 1').get(); // opens + runs migrations
      final from = r.manifest.documentsPath;
      if (from != null && from != docs) {
        for (final row in await staged.select(staged.mealLogs).get()) {
          final np = rebasePath(row.photoPath, from, docs);
          if (np != row.photoPath) {
            await (staged.update(staged.mealLogs)..where((t) => t.id.equals(row.id)))
                .write(MealLogsCompanion(photoPath: Value(np)));
          }
        }
        for (final row in await staged.select(staged.exercises).get()) {
          final np = rebasePath(row.mediaPath, from, docs);
          if (np != row.mediaPath) {
            await (staged.update(staged.exercises)..where((t) => t.id.equals(row.id)))
                .write(ExercisesCompanion(mediaPath: Value(np)));
          }
        }
        for (final row in await staged.select(staged.progressPhotos).get()) {
          final np = rebasePath(row.path, from, docs);
          if (np != row.path) {
            await (staged.update(staged.progressPhotos)..where((t) => t.id.equals(row.id)))
                .write(ProgressPhotosCompanion(path: Value(np!)));
          }
        }
      }
    } finally {
      await staged.close();
    }

    // 2. Close the live DB, then swap files.
    await db.close();
    for (final rel in collectFiles(docs)) {
      try {
        await File(p.join(docs, rel)).delete();
      } catch (_) {}
    }
    for (final suffix in ['', '-wal', '-shm', '-journal']) {
      final f = File(p.join(docs, '$dbFileName$suffix'));
      if (f.existsSync()) await f.delete();
    }
    await _moveOrCopy(File(stagedDb), p.join(docs, dbFileName));
    final filesRoot = Directory(p.join(r.stagingDir, BackupManifest.filesDir));
    if (filesRoot.existsSync()) {
      for (final e in filesRoot.listSync(recursive: true, followLinks: false)) {
        if (e is! File) continue;
        final rel = p.relative(e.path, from: filesRoot.path);
        final target = p.join(docs, rel);
        if (!p.isWithin(docs, target)) continue;
        await Directory(p.dirname(target)).create(recursive: true);
        await _moveOrCopy(e, target);
      }
    }

    // 3. Settings (the API key is not part of prefs, so it stays as it is on this device).
    final pf = File(p.join(r.stagingDir, BackupManifest.prefsEntry));
    if (pf.existsSync()) {
      try {
        final m = jsonDecode(await pf.readAsString()) as Map<String, dynamic>;
        await restorePrefs(prefs, m);
      } catch (e) {
        debugPrint('restore prefs failed: $e');
      }
    }
    await prefs.setString(SettingsKeys.lastBackupAt, r.manifest.createdAt.toIso8601String());

    try {
      await Directory(r.stagingDir).delete(recursive: true);
    } catch (_) {}
  }

  /// Writes backed-up settings into [prefs] (skips device-specific keys).
  static Future<void> restorePrefs(SharedPreferences prefs, Map<String, dynamic> m) async {
    for (final e in m.entries) {
      if (_prefsNotRestored.contains(e.key) || isDeviceOnlyKey(e.key)) continue;
      final v = e.value;
      if (v is bool) {
        await prefs.setBool(e.key, v);
      } else if (v is int) {
        await prefs.setInt(e.key, v);
      } else if (v is double) {
        await prefs.setDouble(e.key, v);
      } else if (v is String) {
        await prefs.setString(e.key, v);
      } else if (v is List) {
        await prefs.setStringList(e.key, v.map((x) => x.toString()).toList());
      }
    }
  }

  static Future<void> _moveOrCopy(File src, String target) async {
    try {
      await src.rename(target);
    } on FileSystemException {
      await src.copy(target);
      try {
        await src.delete();
      } catch (_) {}
    }
  }

  /// Deletes leftovers of an aborted restore.
  static Future<void> discardPrepared(PreparedRestore r) async {
    try {
      await Directory(r.stagingDir).delete(recursive: true);
    } catch (_) {}
  }
}

final backupServiceProvider = Provider<BackupService>(
  (ref) => BackupService(ref.read(databaseProvider), ref.read(sharedPrefsProvider)),
);

/// Last successful backup time (null → never).
DateTime? lastBackupAt(SharedPreferences prefs) =>
    DateTime.tryParse(prefs.getString(SettingsKeys.lastBackupAt) ?? '');
