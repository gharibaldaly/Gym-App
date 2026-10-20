import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_image_compress/flutter_image_compress.dart';

/// Target longest side for food photos sent to Claude vision.
const mealPhotoMaxSide = 1024;

/// Scale factor that brings the longest side down to [maxSide] (never upscales).
double downscaleFactor(int width, int height, {int maxSide = mealPhotoMaxSide}) {
  final longest = math.max(width, height);
  if (longest <= maxSide || longest <= 0) return 1;
  return maxSide / longest;
}

/// Reads [path], downsizes so the longest side is ≤ 1024 px and re-encodes as JPEG.
/// Falls back to the original bytes if compression isn't available.
Future<Uint8List> compressMealPhoto(String path, {int quality = 82}) async {
  final original = await File(path).readAsBytes();
  try {
    var minW = mealPhotoMaxSide, minH = mealPhotoMaxSide;
    try {
      final buf = await ui.ImmutableBuffer.fromUint8List(original);
      final desc = await ui.ImageDescriptor.encoded(buf);
      final f = downscaleFactor(desc.width, desc.height);
      // flutter_image_compress scales by min(w/minW, h/minH) and never upscales,
      // so passing the scaled size yields exactly that size.
      minW = math.max(1, (desc.width * f).round());
      minH = math.max(1, (desc.height * f).round());
      desc.dispose();
      buf.dispose();
    } catch (_) {}
    final out = await FlutterImageCompress.compressWithFile(
      path,
      minWidth: minW,
      minHeight: minH,
      quality: quality,
      format: CompressFormat.jpeg,
    );
    if (out != null && out.isNotEmpty) return out;
  } catch (_) {}
  return original;
}
