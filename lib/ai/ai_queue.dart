import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers.dart';
import 'ai_service.dart';

/// Handler for one queued job. Throw to keep the job pending (it is retried later).
typedef AiQueueHandler = Future<void> Function(Ref ref, Map<String, dynamic> payload);

/// Offline queue for non-urgent AI work (workout summaries, food photo analysis…).
/// Features register a handler once (see `registerAiQueueHandlers` in app bootstrap),
/// enqueue jobs, and the queue drains whenever the device is online with a key.
class AiQueueService {
  final Ref ref;
  AiQueueService(this.ref);

  static final Map<String, AiQueueHandler> _handlers = {};
  bool _running = false;

  static void register(String feature, AiQueueHandler handler) => _handlers[feature] = handler;

  AppDatabase get _db => ref.read(databaseProvider);

  /// Adds a job and tries to run it immediately when online.
  Future<int> enqueue(String feature, Map<String, dynamic> payload) async {
    final id = await _db.into(_db.aiQueue).insert(
          AiQueueCompanion.insert(feature: feature, payloadJson: jsonEncode(payload)),
        );
    unawaited(process());
    return id;
  }

  Stream<int> watchPendingCount() {
    final q = _db.selectOnly(_db.aiQueue)
      ..addColumns([_db.aiQueue.id.count()])
      ..where(_db.aiQueue.status.equals('pending'));
    return q.map((r) => r.read(_db.aiQueue.id.count()) ?? 0).watchSingle();
  }

  Future<void> process() async {
    if (_running) return;
    if (!ref.read(isOnlineProvider)) return;
    if (!await ref.read(aiServiceProvider).hasKey) return;
    _running = true;
    try {
      final jobs = await (_db.select(_db.aiQueue)
            ..where((t) => t.status.equals('pending'))
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .get();
      for (final job in jobs) {
        final handler = _handlers[job.feature];
        if (handler == null) continue;
        try {
          await handler(ref, jsonDecode(job.payloadJson) as Map<String, dynamic>);
          await (_db.update(_db.aiQueue)..where((t) => t.id.equals(job.id)))
              .write(const AiQueueCompanion(status: Value('done')));
        } catch (e) {
          final attempts = job.attempts + 1;
          final offline = e is AiOfflineException;
          await (_db.update(_db.aiQueue)..where((t) => t.id.equals(job.id))).write(AiQueueCompanion(
            attempts: Value(attempts),
            lastError: Value(e.toString()),
            status: Value(!offline && attempts >= 5 ? 'failed' : 'pending'),
          ));
          debugPrint('AI queue job ${job.id} (${job.feature}) failed: $e');
          if (offline) break;
        }
      }
    } finally {
      _running = false;
    }
  }
}

final aiQueueProvider = Provider<AiQueueService>((ref) {
  final q = AiQueueService(ref);
  // Drain the queue whenever connectivity comes back.
  ref.listen<bool>(isOnlineProvider, (prev, next) {
    if (next && prev != true) unawaited(q.process());
  });
  return q;
});
