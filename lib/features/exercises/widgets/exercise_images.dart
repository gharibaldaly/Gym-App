import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/context_ext.dart';
import '../../../data/repositories/exercise_repository.dart';
import '../exercise_media.dart';

/// Image provider for an exercise image URL, backed by the persistent exercise cache.
ImageProvider exerciseImageProvider(String url) => CachedNetworkImageProvider(url, cacheManager: exerciseCacheManager);

class _Fallback extends StatelessWidget {
  final double? size;
  final bool error;
  const _Fallback({this.size, this.error = false});

  @override
  Widget build(BuildContext context) => Container(
        color: AppColors.cardHigh,
        alignment: Alignment.center,
        child: Icon(
          error ? Symbols.image_not_supported_rounded : Symbols.fitness_center_rounded,
          color: AppColors.textMuted,
          size: size == null ? 32 : size! * 0.42,
        ),
      );
}

/// Square thumbnail: custom photo, else the first step image, else an icon.
class ExerciseThumb extends StatelessWidget {
  final Exercise exercise;
  final double size;
  final double radius;
  const ExerciseThumb({super.key, required this.exercise, this.size = 56, this.radius = 12});

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final cachePx = (size * dpr).round();
    Widget child;
    if (exercise.mediaPath != null && File(exercise.mediaPath!).existsSync()) {
      child = Image.file(File(exercise.mediaPath!), fit: BoxFit.cover, cacheWidth: cachePx);
    } else if (exercise.imageUrls.isNotEmpty) {
      child = CachedNetworkImage(
        imageUrl: exercise.imageUrls.first,
        cacheManager: exerciseCacheManager,
        fit: BoxFit.cover,
        memCacheWidth: cachePx,
        fadeInDuration: const Duration(milliseconds: 150),
        placeholder: (_, _) => _Fallback(size: size),
        errorWidget: (_, _, _) => _Fallback(size: size, error: true),
      );
    } else {
      child = _Fallback(size: size);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(width: size, height: size, child: child),
    );
  }
}

/// Step images that alternate every [interval] (a lightweight "animation" of
/// the movement from the start/end photos). Tap to pause / resume.
class ExerciseStepImages extends StatefulWidget {
  final Exercise exercise;
  final double height;
  final Duration interval;
  const ExerciseStepImages({
    super.key,
    required this.exercise,
    this.height = 240,
    this.interval = const Duration(milliseconds: 1100),
  });

  @override
  State<ExerciseStepImages> createState() => _ExerciseStepImagesState();
}

class _ExerciseStepImagesState extends State<ExerciseStepImages> {
  Timer? _timer;
  int _index = 0;
  bool _playing = true;
  bool _precached = false;

  List<String> get _urls => widget.exercise.imageUrls;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_precached) {
      _precached = true;
      // Warms both frames (and stores them in the offline cache).
      for (final u in _urls) {
        precacheImage(exerciseImageProvider(u), context, onError: (_, _) {});
      }
    }
  }

  void _startTimer() {
    _timer?.cancel();
    if (_urls.length < 2 || !_playing) return;
    _timer = Timer.periodic(widget.interval, (_) {
      if (mounted) setState(() => _index = (_index + 1) % _urls.length);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ex = widget.exercise;
    final hasPhoto = ex.mediaPath != null && File(ex.mediaPath!).existsSync();
    if (_urls.isEmpty && !hasPhoto) {
      return SizedBox(height: widget.height * 0.6, child: const _Fallback());
    }
    if (_urls.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: widget.height,
          width: double.infinity,
          child: Image.file(File(ex.mediaPath!), fit: BoxFit.cover),
        ),
      );
    }
    return GestureDetector(
      onTap: () {
        setState(() => _playing = !_playing);
        _startTimer();
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: widget.height,
          color: Colors.white,
          child: Stack(
            fit: StackFit.expand,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 280),
                child: CachedNetworkImage(
                  key: ValueKey(_index),
                  imageUrl: _urls[_index],
                  cacheManager: exerciseCacheManager,
                  fit: BoxFit.contain,
                  fadeInDuration: Duration.zero,
                  placeholder: (_, _) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  errorWidget: (_, _, _) => Container(
                    color: AppColors.cardHigh,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(16),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Symbols.cloud_off_rounded, color: AppColors.textMuted, size: 36),
                      const SizedBox(height: 8),
                      Text(context.l10n.exImageOffline,
                          textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textMuted)),
                    ]),
                  ),
                ),
              ),
              PositionedDirectional(
                bottom: 8,
                end: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(12)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(_playing ? Symbols.pause_rounded : Symbols.play_arrow_rounded, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(context.l10n.exStepOf(_index + 1, _urls.length),
                        style: const TextStyle(color: Colors.white, fontSize: 12)),
                  ]),
                ),
              ),
              if (hasPhoto)
                PositionedDirectional(
                  top: 8,
                  start: 8,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(File(ex.mediaPath!), width: 64, height: 64, fit: BoxFit.cover),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
