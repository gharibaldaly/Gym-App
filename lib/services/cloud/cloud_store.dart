import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase project the app signs in to and backs up to. The publishable key is
/// meant to ship inside apps; access is limited by the storage policies (each
/// user can only read and write their own `<user id>/` folder).
class CloudConfig {
  static const url = 'https://eejrwgfqdrrexstqewzq.supabase.co';
  static const publishableKey = 'sb_publishable_hF-HeAvrY4C7QeCIJBsD7w_D6bIcIuX';
  static const bucket = 'backups';

  /// Deep link that brings Google sign-in, email confirmation and password reset
  /// back into the app (intent filter in AndroidManifest.xml). It must also be in
  /// Supabase → Authentication → URL Configuration → Redirect URLs.
  static const redirectUrl = 'com.ironmind.ironmind://login-callback';
}

/// Minimal object storage used by [CloudSync] (faked in tests).
abstract class CloudStore {
  /// Returns null when the object does not exist.
  Future<Uint8List?> download(String path);
  Future<void> upload(String path, Uint8List bytes, {String contentType = 'application/octet-stream'});
  Future<void> remove(List<String> paths);
}

class SupabaseCloudStore implements CloudStore {
  final SupabaseClient client;
  SupabaseCloudStore(this.client);

  StorageFileApi get _bucket => client.storage.from(CloudConfig.bucket);

  @override
  Future<Uint8List?> download(String path) async {
    try {
      return await _bucket.download(path);
    } on StorageException catch (e) {
      final missing = e.statusCode == '404' ||
          e.statusCode == '400' && e.message.toLowerCase().contains('not found') ||
          e.error == 'not_found';
      if (missing) return null;
      rethrow;
    }
  }

  @override
  Future<void> upload(String path, Uint8List bytes, {String contentType = 'application/octet-stream'}) =>
      _bucket.uploadBinary(path, bytes, fileOptions: FileOptions(upsert: true, contentType: contentType));

  @override
  Future<void> remove(List<String> paths) async {
    if (paths.isEmpty) return;
    // The API takes at most 1000 paths per call.
    for (var i = 0; i < paths.length; i += 500) {
      await _bucket.remove(paths.sublist(i, i + 500 > paths.length ? paths.length : i + 500));
    }
  }
}
