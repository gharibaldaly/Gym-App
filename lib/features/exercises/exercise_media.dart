// `file` is a hard dependency of flutter_cache_manager (its FileSystem API returns
// package:file types), so it is always available; add it to pubspec to drop this.
import 'dart:async';
import 'dart:io' as io;

import 'package:file/file.dart' as f;
import 'package:file/local.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/providers.dart';
import '../../data/repositories/exercise_repository.dart';

const String _cacheKey = 'ironmindExerciseImages';

/// Stores cached images in the app-support directory (not the OS temp dir),
/// so downloaded step images survive "clear cache" pressure and stay offline.
class _PersistentFileSystem implements FileSystem {
  final Future<f.Directory> _dir = _create();

  static Future<f.Directory> _create() async {
    final base = await getApplicationSupportDirectory();
    final dir = const LocalFileSystem().directory(p.join(base.path, _cacheKey));
    await dir.create(recursive: true);
    return dir;
  }

  @override
  Future<f.File> createFile(String name) async {
    final dir = await _dir;
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir.childFile(name);
  }
}

/// Exercise images never change upstream: treat every download as valid for a
/// year so the cache is not re-validated on each view (GitHub sends max-age=300).
class _LongLivedFileService extends FileService {
  final HttpFileService _inner = HttpFileService();

  @override
  Future<FileServiceResponse> get(String url, {Map<String, String>? headers}) async =>
      _LongLivedResponse(await _inner.get(url, headers: headers));
}

class _LongLivedResponse implements FileServiceResponse {
  final FileServiceResponse _r;
  _LongLivedResponse(this._r);
  @override
  Stream<List<int>> get content => _r.content;
  @override
  int? get contentLength => _r.contentLength;
  @override
  int get statusCode => _r.statusCode;
  @override
  DateTime get validTill => DateTime.now().add(const Duration(days: 365));
  @override
  String? get eTag => _r.eTag;
  @override
  String get fileExtension => _r.fileExtension;
}

/// Cache used for every exercise image (thumbnails, detail carousel, offline pack).
final CacheManager exerciseCacheManager = CacheManager(Config(
  _cacheKey,
  stalePeriod: const Duration(days: 3650),
  maxNrOfCacheObjects: 5000,
  fileSystem: _PersistentFileSystem(),
  fileService: _LongLivedFileService(),
));

/// Approximate size of the full image pack (≈ 1750 jpgs × ~40 KB).
const int kExerciseMediaApproxMb = 70;

enum MediaDownloadPhase { idle, checking, downloading, done, cancelled }

class MediaDownloadState {
  final MediaDownloadPhase phase;
  final int total;
  final int processed;
  final int cached;
  final int failed;
  const MediaDownloadState({
    this.phase = MediaDownloadPhase.idle,
    this.total = 0,
    this.processed = 0,
    this.cached = 0,
    this.failed = 0,
  });

  bool get running => phase == MediaDownloadPhase.checking || phase == MediaDownloadPhase.downloading;
  double get progress => total == 0 ? 0 : processed / total;
  bool get complete => total > 0 && cached >= total;

  MediaDownloadState copyWith({MediaDownloadPhase? phase, int? total, int? processed, int? cached, int? failed}) =>
      MediaDownloadState(
        phase: phase ?? this.phase,
        total: total ?? this.total,
        processed: processed ?? this.processed,
        cached: cached ?? this.cached,
        failed: failed ?? this.failed,
      );
}

/// Pre-downloads every exercise image into [exerciseCacheManager] with progress.
/// Kept alive app-wide so the download continues if its screen is closed.
class ExerciseMediaDownloader extends Notifier<MediaDownloadState> {
  bool _cancel = false;

  @override
  MediaDownloadState build() => const MediaDownloadState();

  Future<List<String>> _allUrls() async {
    final all = await ref.read(exerciseRepositoryProvider).all();
    return [for (final e in all) ...e.imageUrls];
  }

  /// Counts already cached images (no network).
  Future<void> refreshStatus() async {
    if (state.running) return;
    state = state.copyWith(phase: MediaDownloadPhase.checking, processed: 0, cached: 0, failed: 0);
    final urls = await _allUrls();
    state = state.copyWith(total: urls.length);
    var cached = 0;
    var processed = 0;
    for (final u in urls) {
      if (await exerciseCacheManager.getFileFromCache(u) != null) cached++;
      processed++;
      if (processed % 100 == 0) state = state.copyWith(processed: processed, cached: cached);
    }
    state = state.copyWith(phase: MediaDownloadPhase.idle, processed: processed, cached: cached);
  }

  /// Downloads all missing images ([concurrency] parallel requests).
  Future<void> start({int concurrency = 6}) async {
    if (state.running) return;
    _cancel = false;
    final urls = await _allUrls();
    state = MediaDownloadState(phase: MediaDownloadPhase.downloading, total: urls.length);
    var next = 0;
    var processed = 0, cached = 0, failed = 0;

    Future<void> worker() async {
      while (!_cancel) {
        if (next >= urls.length) return;
        final url = urls[next++];
        try {
          final hit = await exerciseCacheManager.getFileFromCache(url);
          if (hit == null || !await io.File(hit.file.path).exists()) {
            await exerciseCacheManager.downloadFile(url);
          }
          cached++;
        } catch (_) {
          failed++;
        }
        processed++;
        if (processed % 10 == 0 || processed == urls.length) {
          state = state.copyWith(processed: processed, cached: cached, failed: failed);
        }
      }
    }

    await Future.wait(List.generate(concurrency, (_) => worker()));
    state = state.copyWith(
      phase: _cancel ? MediaDownloadPhase.cancelled : MediaDownloadPhase.done,
      processed: processed,
      cached: cached,
      failed: failed,
    );
  }

  void cancel() => _cancel = true;

  /// Removes every downloaded exercise image.
  Future<void> clear() async {
    cancel();
    await exerciseCacheManager.emptyCache();
    state = MediaDownloadState(total: state.total);
  }
}

final exerciseMediaDownloaderProvider =
    NotifierProvider<ExerciseMediaDownloader, MediaDownloadState>(ExerciseMediaDownloader.new);

/// Folder for user photos of custom exercises (inside the private app documents dir).
Future<io.Directory> customExerciseMediaDir() async {
  final docs = await getApplicationDocumentsDirectory();
  final dir = io.Directory(p.join(docs.path, 'exercise_media'));
  if (!await dir.exists()) await dir.create(recursive: true);
  return dir;
}

/// Convenience for other features: true when every image of [ex] is cached.
Future<bool> isExerciseCached(Exercise ex) async {
  for (final u in ex.imageUrls) {
    if (await exerciseCacheManager.getFileFromCache(u) == null) return false;
  }
  return true;
}
