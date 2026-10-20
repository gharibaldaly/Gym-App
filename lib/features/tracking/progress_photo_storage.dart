import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../data/db/database.dart';
import 'tracking_repository.dart';

/// Progress photos live in `<app documents>/progress_photos/` (private app storage, never the
/// gallery). The DB stores the path relative to the documents dir, e.g. `progress_photos/x.jpg`.
class ProgressPhotoStorage {
  static const folder = 'progress_photos';
  static const angles = ['front', 'side', 'back'];

  static File resolve(Directory docs, String relPath) => File(p.join(docs.path, relPath));

  /// Picks an image from the camera or gallery and stores it for [date]/[angle].
  /// Returns false when the user cancelled.
  static Future<bool> capture(AppDatabase db, {required DateTime date, required String angle, required bool camera}) async {
    final x = await ImagePicker().pickImage(
      source: camera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 85,
      preferredCameraDevice: CameraDevice.rear,
      requestFullMetadata: false,
    );
    if (x == null) return false;
    await store(db, x, date: date, angle: angle);
    return true;
  }

  /// Copies [file] into the private folder and records it (replacing the same day + angle).
  static Future<String> store(AppDatabase db, XFile file, {required DateTime date, required String angle}) async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, folder));
    if (!dir.existsSync()) await dir.create(recursive: true);
    final d = DateTime(date.year, date.month, date.day);
    final stamp = DateTime.now().millisecondsSinceEpoch;
    final ext = p.extension(file.path).isEmpty ? '.jpg' : p.extension(file.path).toLowerCase();
    final name = '${d.year}${_two(d.month)}${_two(d.day)}_${angle}_$stamp$ext';
    final rel = p.join(folder, name);
    await file.saveTo(p.join(docs.path, rel));
    final replaced = await TrackingRepository(db).savePhoto(d, angle, rel);
    for (final old in replaced) {
      await _deleteFile(docs, old);
    }
    return rel;
  }

  static Future<void> delete(AppDatabase db, ProgressPhoto photo) async {
    await TrackingRepository(db).deletePhoto(photo.id);
    try {
      await _deleteFile(await getApplicationDocumentsDirectory(), photo.path);
    } catch (e) {
      debugPrint('progress photo delete: $e');
    }
  }

  static Future<void> _deleteFile(Directory docs, String rel) async {
    final f = resolve(docs, rel);
    if (f.existsSync()) await f.delete();
  }

  static String _two(int v) => v.toString().padLeft(2, '0');
}

/// Biometric / device-credential check before showing progress photos.
/// Returns true when unlocked or when the device has no lock at all.
Future<bool> authenticateForPhotos(String reason) async {
  final auth = LocalAuthentication();
  try {
    if (!await auth.isDeviceSupported()) return true;
    return await auth.authenticate(
      localizedReason: reason,
      biometricOnly: false, // falls back to the device PIN / pattern
      persistAcrossBackgrounding: true,
    );
  } on LocalAuthException catch (e) {
    // No screen lock / no hardware at all → nothing to protect with.
    return e.code == LocalAuthExceptionCode.noCredentialsSet || e.code == LocalAuthExceptionCode.noBiometricHardware;
  } on MissingPluginException {
    return true;
  } on PlatformException catch (e) {
    debugPrint('local_auth: $e');
    return false;
  }
}
