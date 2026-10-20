/// manifest.json stored at the root of every IronMind backup zip.
class BackupManifest {
  static const appId = 'ironmind';

  /// Bumped when the zip layout changes.
  static const currentFormat = 1;
  static const fileName = 'manifest.json';
  static const dbEntry = 'db/ironmind.sqlite';
  static const prefsEntry = 'prefs.json';
  static const filesDir = 'files';

  final String app;
  final int format;
  final String appVersion;
  final String buildNumber;
  final int schemaVersion;
  final DateTime createdAt;
  final String db;

  /// Absolute app-documents path on the source device (used to rewrite absolute media paths).
  final String? documentsPath;
  final int fileCount;

  const BackupManifest({
    this.app = appId,
    this.format = currentFormat,
    required this.appVersion,
    this.buildNumber = '',
    required this.schemaVersion,
    required this.createdAt,
    this.db = dbEntry,
    this.documentsPath,
    this.fileCount = 0,
  });

  Map<String, dynamic> toJson() => {
        'app': app,
        'format': format,
        'app_version': appVersion,
        'build_number': buildNumber,
        'schema_version': schemaVersion,
        'created_at': createdAt.toUtc().toIso8601String(),
        'db': db,
        'documents_path': documentsPath,
        'file_count': fileCount,
        'includes_api_key': false,
      };

  factory BackupManifest.fromJson(Map<String, dynamic> j) => BackupManifest(
        app: j['app'] as String,
        format: (j['format'] as num).toInt(),
        appVersion: (j['app_version'] ?? '').toString(),
        buildNumber: (j['build_number'] ?? '').toString(),
        schemaVersion: (j['schema_version'] as num).toInt(),
        createdAt: DateTime.parse(j['created_at'] as String).toLocal(),
        db: (j['db'] as String?) ?? dbEntry,
        documentsPath: j['documents_path'] as String?,
        fileCount: (j['file_count'] as num?)?.toInt() ?? 0,
      );
}

enum BackupProblem { notJson, wrongApp, unsupportedFormat, newerSchema, missingFields, missingDatabase }

class BackupValidation {
  final BackupManifest? manifest;
  final BackupProblem? problem;
  const BackupValidation.ok(BackupManifest this.manifest) : problem = null;
  const BackupValidation.fail(BackupProblem this.problem) : manifest = null;
  bool get isValid => manifest != null;
}

/// Validates a decoded manifest.json. [dbExists] tells whether the DB entry was found in the zip.
BackupValidation validateBackupManifest(
  Object? json, {
  required int currentSchemaVersion,
  bool dbExists = true,
}) {
  if (json is! Map) return const BackupValidation.fail(BackupProblem.notJson);
  final m = json.cast<String, dynamic>();
  if (m['app'] != BackupManifest.appId) return const BackupValidation.fail(BackupProblem.wrongApp);
  final format = m['format'];
  if (format is! num) return const BackupValidation.fail(BackupProblem.missingFields);
  if (format.toInt() < 1 || format.toInt() > BackupManifest.currentFormat) {
    return const BackupValidation.fail(BackupProblem.unsupportedFormat);
  }
  final schema = m['schema_version'];
  final created = m['created_at'];
  if (schema is! num || created is! String || DateTime.tryParse(created) == null) {
    return const BackupValidation.fail(BackupProblem.missingFields);
  }
  if (schema.toInt() < 1) return const BackupValidation.fail(BackupProblem.missingFields);
  if (schema.toInt() > currentSchemaVersion) return const BackupValidation.fail(BackupProblem.newerSchema);
  final db = m['db'];
  if (db != null && db is! String) return const BackupValidation.fail(BackupProblem.missingFields);
  if (!dbExists) return const BackupValidation.fail(BackupProblem.missingDatabase);
  try {
    return BackupValidation.ok(BackupManifest.fromJson(m));
  } catch (_) {
    return const BackupValidation.fail(BackupProblem.missingFields);
  }
}

/// Rewrites a stored absolute path from the source device's documents dir to this device's.
String? rebasePath(String? stored, String? fromDocs, String toDocs) {
  if (stored == null || fromDocs == null || fromDocs.isEmpty || fromDocs == toDocs) return stored;
  if (stored == fromDocs) return toDocs;
  final prefix = fromDocs.endsWith('/') ? fromDocs : '$fromDocs/';
  if (!stored.startsWith(prefix)) return stored;
  final to = toDocs.endsWith('/') ? toDocs : '$toDocs/';
  return '$to${stored.substring(prefix.length)}';
}
