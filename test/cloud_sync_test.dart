import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:ironmind/core/settings/app_settings.dart';
import 'package:ironmind/services/backup/backup_service.dart';
import 'package:ironmind/services/cloud/cloud_store.dart';
import 'package:ironmind/services/cloud/cloud_sync.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

class _MemoryStore implements CloudStore {
  final objects = <String, Uint8List>{};
  final uploads = <String>[];

  @override
  Future<Uint8List?> download(String path) async => objects[path];

  @override
  Future<void> upload(String path, Uint8List bytes, {String contentType = 'application/octet-stream'}) async {
    uploads.add(path);
    objects[path] = bytes;
  }

  @override
  Future<void> remove(List<String> paths) async => paths.forEach(objects.remove);
}

/// Backup ops over a temp "documents" folder; the core zip is just a text file.
class _FakeOps implements CloudBackupOps {
  final Directory docs;
  final Directory staging;
  String coreContent = 'db-v1';
  bool local = true;
  String? restoredCore;
  _FakeOps(this.docs, this.staging);

  @override
  Future<String> documentsDir() async => docs.path;

  @override
  List<String> collectFiles(String docs) => BackupService.collectFiles(docs);

  @override
  Future<File> createCoreZip() async {
    final f = File(p.join(Directory.systemTemp.path, 'core_${DateTime.now().microsecondsSinceEpoch}.zip'));
    return f..writeAsStringSync(coreContent);
  }

  @override
  Future<Object> prepareRestore(String zipPath) async {
    restoredCore = File(zipPath).readAsStringSync();
    return staging.path;
  }

  @override
  String stagedFilesDir(Object prepared) => p.join(prepared as String, 'files');

  @override
  Future<void> applyRestore(Object prepared) async {
    // Like BackupService.applyRestore: replace the user files with the staged ones.
    for (final rel in BackupService.collectFiles(docs.path)) {
      File(p.join(docs.path, rel)).deleteSync();
    }
    final root = Directory(stagedFilesDir(prepared));
    if (!root.existsSync()) return;
    for (final e in root.listSync(recursive: true).whereType<File>()) {
      final target = File(p.join(docs.path, p.relative(e.path, from: root.path)));
      target.parent.createSync(recursive: true);
      e.copySync(target.path);
    }
  }

  @override
  Future<bool> hasLocalData() async => local;
}

void main() {
  late Directory tmp;
  late Directory docs;
  late _MemoryStore store;
  late _FakeOps ops;
  late SharedPreferences prefs;
  late CloudSync sync;
  const uid = 'user-1';

  void write(String rel, String content) {
    final f = File(p.join(docs.path, rel));
    f.parent.createSync(recursive: true);
    f.writeAsStringSync(content);
  }

  setUp(() async {
    tmp = Directory.systemTemp.createTempSync('cloud_sync_test');
    docs = Directory(p.join(tmp.path, 'docs'))..createSync();
    store = _MemoryStore();
    ops = _FakeOps(docs, Directory(p.join(tmp.path, 'staging'))..createSync());
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    sync = CloudSync(store: store, ops: ops, prefs: prefs, appVersion: '1.2.3');
  });
  tearDown(() => tmp.deleteSync(recursive: true));

  test('login decision covers every case', () {
    expect(decideLoginSync(hasLocal: false, hasCloud: false), LoginSyncAction.none);
    expect(decideLoginSync(hasLocal: true, hasCloud: false), LoginSyncAction.upload);
    expect(decideLoginSync(hasLocal: false, hasCloud: true), LoginSyncAction.restore);
    expect(decideLoginSync(hasLocal: true, hasCloud: true), LoginSyncAction.choose);
  });

  test('upload puts db, files, index and meta in the user folder', () async {
    write('progress_photos/a.jpg', 'A');
    write('food_photos/b.jpg', 'B');
    await sync.markDirty();
    await sync.upload(uid);

    expect(store.objects.keys, containsAll([
      'user-1/core.zip',
      'user-1/meta.json',
      'user-1/files_index.json',
      'user-1/files/progress_photos/a.jpg',
      'user-1/files/food_photos/b.jpg',
    ]));
    expect(store.objects.keys.every((k) => k.startsWith('user-1/')), isTrue);
    final index = (jsonDecode(utf8.decode(store.objects['user-1/files_index.json']!)) as List).toSet();
    expect(index, {'progress_photos/a.jpg', 'food_photos/b.jpg'});
    final info = (await sync.remoteInfo(uid))!;
    expect(info.fileCount, 2);
    expect(info.appVersion, '1.2.3');
    expect(sync.isDirty, isFalse);
    expect(sync.lastUpload, isNotNull);
    expect(prefs.getString(SettingsKeys.lastBackupAt), isNotNull);
  });

  test('unchanged files are not uploaded again; deleted files are removed', () async {
    write('progress_photos/a.jpg', 'A');
    write('progress_photos/b.jpg', 'B');
    await sync.upload(uid);
    store.uploads.clear();

    File(p.join(docs.path, 'progress_photos/b.jpg')).deleteSync();
    write('progress_photos/c.jpg', 'C');
    await sync.upload(uid);

    expect(store.uploads.where((u) => u.contains('/files/')), ['user-1/files/progress_photos/c.jpg']);
    expect(store.objects.containsKey('user-1/files/progress_photos/b.jpg'), isFalse);
    expect(store.objects.containsKey('user-1/files/progress_photos/a.jpg'), isTrue);
  });

  test('restore on a fresh install brings back the database and every file', () async {
    write('progress_photos/a.jpg', 'A');
    write('food_photos/b.jpg', 'B');
    await sync.upload(uid);

    // "Reinstall": empty documents folder and settings.
    for (final e in docs.listSync()) {
      e.deleteSync(recursive: true);
    }
    SharedPreferences.setMockInitialValues({});
    final freshPrefs = await SharedPreferences.getInstance();
    final fresh = CloudSync(store: store, ops: ops, prefs: freshPrefs);
    ops.local = false;
    expect(await fresh.decide(uid), LoginSyncAction.restore);

    final progress = <double>[];
    await fresh.restore(uid, onProgress: progress.add);
    expect(ops.restoredCore, 'db-v1');
    expect(File(p.join(docs.path, 'progress_photos/a.jpg')).readAsStringSync(), 'A');
    expect(File(p.join(docs.path, 'food_photos/b.jpg')).readAsStringSync(), 'B');
    expect(progress.last, 1);

    // Restored files are known: the next upload sends no files again.
    store.uploads.clear();
    await fresh.upload(uid);
    expect(store.uploads.where((u) => u.contains('/files/')), isEmpty);
  });

  test('restore without a cloud backup fails clearly', () async {
    expect(await sync.remoteInfo(uid), isNull);
    await expectLater(sync.restore(uid), throwsStateError);
  });

  test('each account keeps its own resolved flag and ledger', () async {
    await sync.markResolved('a');
    expect(sync.isResolved('a'), isTrue);
    expect(sync.isResolved('b'), isFalse);
  });

  test('session and sync keys never go into a backup', () {
    expect(BackupService.isDeviceOnlyKey('sb-eejrwgfqdrrexstqewzq-auth-token'), isTrue);
    expect(BackupService.isDeviceOnlyKey(CloudSync.ledgerKey('x')), isTrue);
    expect(BackupService.isDeviceOnlyKey(CloudSync.dirtyKey), isTrue);
    expect(BackupService.isDeviceOnlyKey(SettingsKeys.lastBackupAt), isFalse);
  });

  test('restorePrefs skips the session of the device that made the backup', () async {
    await prefs.setString('sb-eejrwgfqdrrexstqewzq-auth-token', 'mine');
    await BackupService.restorePrefs(prefs, {
      'sb-eejrwgfqdrrexstqewzq-auth-token': 'theirs',
      'cloud_files_x': '{}',
      'language': 'en',
    });
    expect(prefs.getString('sb-eejrwgfqdrrexstqewzq-auth-token'), 'mine');
    expect(prefs.getString('cloud_files_x'), isNull);
    expect(prefs.getString('language'), 'en');
  });

  test('cloud paths', () {
    expect(CloudConfig.bucket, 'backups');
    expect(CloudSync.filePath('u', 'progress_photos/x.jpg'), 'u/files/progress_photos/x.jpg');
  });
}
