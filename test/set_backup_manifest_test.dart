import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:ironmind/services/backup/backup_service.dart' show BackupService;
import 'package:ironmind/services/backup/backup_manifest.dart';
import 'package:ironmind/services/lock/app_lock.dart' show shouldRelock;

void main() {
  Map<String, dynamic> valid() => BackupManifest(
        appVersion: '1.0.0',
        buildNumber: '1',
        schemaVersion: 1,
        createdAt: DateTime.utc(2026, 10, 1, 12),
        documentsPath: '/data/user/0/com.ironmind.ironmind/app_flutter',
        fileCount: 3,
      ).toJson();

  test('round trip + valid manifest', () {
    final v = validateBackupManifest(valid(), currentSchemaVersion: 1);
    expect(v.isValid, isTrue);
    expect(v.manifest!.appVersion, '1.0.0');
    expect(v.manifest!.schemaVersion, 1);
    expect(v.manifest!.createdAt.toUtc(), DateTime.utc(2026, 10, 1, 12));
    expect(v.manifest!.db, BackupManifest.dbEntry);
    expect(valid()['includes_api_key'], isFalse);
  });

  test('older schema is accepted (migrated on restore)', () {
    expect(validateBackupManifest(valid(), currentSchemaVersion: 3).isValid, isTrue);
  });

  test('rejects bad manifests', () {
    BackupProblem? problem(Object? j, {int schema = 1, bool db = true}) =>
        validateBackupManifest(j, currentSchemaVersion: schema, dbExists: db).problem;

    expect(problem('nope'), BackupProblem.notJson);
    expect(problem([1, 2]), BackupProblem.notJson);
    expect(problem(valid()..['app'] = 'other'), BackupProblem.wrongApp);
    expect(problem(valid()..['format'] = 99), BackupProblem.unsupportedFormat);
    expect(problem(valid()..remove('format')), BackupProblem.missingFields);
    expect(problem(valid()..['schema_version'] = 2), BackupProblem.newerSchema);
    expect(problem(valid()..['schema_version'] = 0), BackupProblem.missingFields);
    expect(problem(valid()..['created_at'] = 'yesterday'), BackupProblem.missingFields);
    expect(problem(valid()..remove('schema_version')), BackupProblem.missingFields);
    expect(problem(valid()..['db'] = 5), BackupProblem.missingFields);
    expect(problem(valid(), db: false), BackupProblem.missingDatabase);
  });

  test('rebasePath', () {
    const from = '/data/user/0/com.ironmind.ironmind/app_flutter';
    const to = '/data/user/10/com.ironmind.ironmind/app_flutter';
    expect(rebasePath('$from/meal_photos/a.jpg', from, to), '$to/meal_photos/a.jpg');
    expect(rebasePath('progress_photos/a.jpg', from, to), 'progress_photos/a.jpg');
    expect(rebasePath('/other/x.jpg', from, to), '/other/x.jpg');
    expect(rebasePath(null, from, to), isNull);
    expect(rebasePath('$from/x.jpg', null, to), '$from/x.jpg');
    expect(rebasePath('$from/x.jpg', from, from), '$from/x.jpg');
  });

  test('app lock relock rule', () {
    final t = DateTime(2026, 10, 20, 12);
    expect(shouldRelock(enabled: false, backgroundedAt: t, now: t.add(const Duration(hours: 1)), timeoutSeconds: 0), isFalse);
    expect(shouldRelock(enabled: true, backgroundedAt: null, now: t, timeoutSeconds: 0), isFalse);
    expect(shouldRelock(enabled: true, backgroundedAt: t, now: t.add(const Duration(seconds: 30)), timeoutSeconds: 60), isFalse);
    expect(shouldRelock(enabled: true, backgroundedAt: t, now: t.add(const Duration(seconds: 61)), timeoutSeconds: 60), isTrue);
    expect(shouldRelock(enabled: true, backgroundedAt: t, now: t, timeoutSeconds: 0), isTrue);
  });

  test('collectFiles skips the live DB and cache folders', () {
    final root = Directory.systemTemp.createTempSync('im_backup_');
    addTearDown(() => root.deleteSync(recursive: true));
    void touch(String rel) => (File('${root.path}/$rel')..createSync(recursive: true)).writeAsStringSync('x');
    touch('ironmind.sqlite');
    touch('ironmind.sqlite-wal');
    touch('progress_photos/2026-10-01_front.jpg');
    touch('meal_photos/a.jpg');
    touch('exercise_media/custom_1.jpg');
    touch('home_widget/img.png');
    touch('backup_tmp/old.zip');
    final files = BackupService.collectFiles(root.path)..sort();
    expect(files, ['exercise_media/custom_1.jpg', 'meal_photos/a.jpg', 'progress_photos/2026-10-01_front.jpg']);
  });
}
