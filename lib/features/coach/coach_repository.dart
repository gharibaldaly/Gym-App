import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';

/// Message kinds stored in coach_messages.kind.
class CoachKinds {
  static const chat = 'chat';
  static const morning = 'morning';
  static const workoutSummary = 'workout_summary';
  static const plateau = 'plateau';
  static const weekly = 'weekly';
  static const recovery = 'recovery';
  static const offlineNotice = 'offline_notice';

  static const initiatives = {morning, workoutSummary, plateau, weekly, recovery};
  static const reports = [weekly, workoutSummary];
}

/// Clock used by coach logic (overridden in tests).
final coachClockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

/// DB access for coach messages, memories and proposals.
class CoachRepository {
  final AppDatabase db;
  CoachRepository(this.db);

  // ---------------------------------------------------------------- messages

  /// Chat timeline, oldest first (last [limit] messages).
  Stream<List<CoachMessage>> watchMessages({int limit = 300}) {
    final q = db.select(db.coachMessages)
      ..orderBy([(m) => OrderingTerm.desc(m.id)])
      ..limit(limit);
    return q.watch().map((l) => l.reversed.toList());
  }

  Future<int> addMessage({
    required String role,
    required String content,
    String kind = CoachKinds.chat,
    Map<String, dynamic>? meta,
    bool isRead = false,
  }) =>
      db.into(db.coachMessages).insert(CoachMessagesCompanion.insert(
            role: role,
            content: content,
            kind: Value(kind),
            metaJson: Value(meta == null ? null : jsonEncode(meta)),
            isRead: Value(isRead || role == 'user'),
          ));

  Future<void> updateMessage(int id, {String? content, Map<String, dynamic>? meta}) =>
      (db.update(db.coachMessages)..where((m) => m.id.equals(id))).write(CoachMessagesCompanion(
        content: content == null ? const Value.absent() : Value(content),
        metaJson: meta == null ? const Value.absent() : Value(jsonEncode(meta)),
      ));

  /// The last [n] messages (oldest first) used as chat history.
  Future<List<CoachMessage>> recentMessages(int n) async {
    final rows = await (db.select(db.coachMessages)
          ..orderBy([(m) => OrderingTerm.desc(m.id)])
          ..limit(n))
        .get();
    return rows.reversed.toList();
  }

  Future<void> markAllRead() => (db.update(db.coachMessages)..where((m) => m.isRead.equals(false)))
      .write(const CoachMessagesCompanion(isRead: Value(true)));

  Stream<int> watchUnreadCount() {
    final c = db.coachMessages.id.count();
    final q = db.selectOnly(db.coachMessages)
      ..addColumns([c])
      ..where(db.coachMessages.isRead.equals(false) & db.coachMessages.role.equals('assistant'));
    return q.map((r) => r.read(c) ?? 0).watchSingle();
  }

  /// Weekly reports and workout summaries, newest first.
  Stream<List<CoachMessage>> watchReports() => (db.select(db.coachMessages)
        ..where((m) => m.kind.isIn(CoachKinds.reports) & m.role.equals('assistant'))
        ..orderBy([(m) => OrderingTerm.desc(m.createdAt), (m) => OrderingTerm.desc(m.id)]))
      .watch();

  /// Latest assistant messages (newest first) for the Today card.
  Stream<List<CoachMessage>> watchLatestAssistant({int limit = 30}) => (db.select(db.coachMessages)
        ..where((m) => m.role.equals('assistant') & m.kind.equals(CoachKinds.offlineNotice).not())
        ..orderBy([(m) => OrderingTerm.desc(m.id)])
        ..limit(limit))
      .watch();

  /// Latest weekly report text (used by the progress PDF).
  Future<CoachMessage?> latestWeekly() => (db.select(db.coachMessages)
        ..where((m) => m.kind.equals(CoachKinds.weekly))
        ..orderBy([(m) => OrderingTerm.desc(m.id)])
        ..limit(1))
      .getSingleOrNull();

  // ---------------------------------------------------------------- proposals

  Stream<List<CoachProposal>> watchProposals({String? status, int limit = 200}) {
    final q = db.select(db.coachProposals)
      ..orderBy([(p) => OrderingTerm.desc(p.createdAt), (p) => OrderingTerm.desc(p.id)])
      ..limit(limit);
    if (status != null) q.where((p) => p.status.equals(status));
    return q.watch();
  }

  Future<void> linkProposalsToMessage(Iterable<int> proposalIds, int messageId) async {
    final ids = proposalIds.toList();
    if (ids.isEmpty) return;
    await (db.update(db.coachProposals)..where((p) => p.id.isIn(ids)))
        .write(CoachProposalsCompanion(messageId: Value(messageId)));
  }

  // ---------------------------------------------------------------- memories

  Stream<List<CoachMemory>> watchMemories() => (db.select(db.coachMemories)
        ..orderBy([(m) => OrderingTerm.desc(m.createdAt), (m) => OrderingTerm.desc(m.id)]))
      .watch();

  Future<void> deleteMemory(int id) => (db.delete(db.coachMemories)..where((m) => m.id.equals(id))).go();

  Future<void> clearMemories() => db.delete(db.coachMemories).go();
}

final coachRepositoryProvider = Provider<CoachRepository>((ref) => CoachRepository(ref.watch(databaseProvider)));

final coachMessagesProvider =
    StreamProvider<List<CoachMessage>>((ref) => ref.watch(coachRepositoryProvider).watchMessages());

final coachProposalsProvider =
    StreamProvider<List<CoachProposal>>((ref) => ref.watch(coachRepositoryProvider).watchProposals());

final pendingProposalsProvider = StreamProvider<List<CoachProposal>>(
    (ref) => ref.watch(coachRepositoryProvider).watchProposals(status: 'pending'));

final coachMemoriesProvider =
    StreamProvider<List<CoachMemory>>((ref) => ref.watch(coachRepositoryProvider).watchMemories());

final coachReportsProvider =
    StreamProvider<List<CoachMessage>>((ref) => ref.watch(coachRepositoryProvider).watchReports());

/// Unread assistant messages (badge on the Coach tab).
final coachUnreadCountProvider =
    StreamProvider<int>((ref) => ref.watch(coachRepositoryProvider).watchUnreadCount());

/// Decoded metaJson of a coach message.
extension CoachMessageX on CoachMessage {
  Map<String, dynamic> get meta {
    if (metaJson == null) return const {};
    try {
      final v = jsonDecode(metaJson!);
      return v is Map<String, dynamic> ? v : const {};
    } catch (_) {
      return const {};
    }
  }

  bool get isInitiative => CoachKinds.initiatives.contains(kind);
}

extension CoachProposalX on CoachProposal {
  Map<String, dynamic> get payload {
    try {
      final v = jsonDecode(payloadJson);
      return v is Map<String, dynamic> ? v : const {};
    } catch (_) {
      return const {};
    }
  }

  bool get isPending => status == 'pending';
}
