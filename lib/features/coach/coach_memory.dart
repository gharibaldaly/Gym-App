/// Coach memory: Haiku extracts lasting facts from recent chat, deduped locally.
library;

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../ai/ai_queue.dart';
import '../../ai/ai_service.dart';
import '../../core/providers.dart';

/// Queue key for memory extraction jobs.
const coachMemoryJob = 'coach_memory';

/// SharedPreferences key: id of the last coach message already scanned for memories.
const coachMemoryLastIdKey = 'coach_memory_last_msg_id';

final _diacritics = RegExp('[ً-ْـ]');
final _punct = RegExp(r'''[^\p{L}\p{N}\s]''', unicode: true);
final _spaces = RegExp(r'\s+');

/// Lowercases, strips Arabic diacritics/tatweel, unifies alef/ya/ta-marbuta forms
/// and punctuation so near-identical facts compare equal.
String normalizeFact(String s) {
  var t = s.toLowerCase().replaceAll(_diacritics, '');
  t = t
      .replaceAll(RegExp('[أإآٱ]'), 'ا')
      .replaceAll('ى', 'ي')
      .replaceAll('ة', 'ه')
      .replaceAll('ؤ', 'و')
      .replaceAll('ئ', 'ي');
  t = t.replaceAll(_punct, ' ').replaceAll(_spaces, ' ').trim();
  return t;
}

Set<String> _tokens(String normalized) => normalized.split(' ').where((w) => w.length > 1).toSet();

/// True when [a] and [b] state (almost) the same fact.
bool isDuplicateFact(String a, String b) {
  final na = normalizeFact(a), nb = normalizeFact(b);
  if (na.isEmpty || nb.isEmpty) return na == nb;
  if (na == nb) return true;
  final shorter = na.length <= nb.length ? na : nb;
  final longer = na.length <= nb.length ? nb : na;
  if (shorter.length >= 12 && longer.contains(shorter)) return true;
  final ta = _tokens(na), tb = _tokens(nb);
  if (ta.isEmpty || tb.isEmpty) return false;
  final inter = ta.intersection(tb).length;
  final union = ta.union(tb).length;
  return inter / union >= 0.75;
}

/// Returns the [candidates] that are non-empty, not duplicates of [existing]
/// and not duplicates of each other (first one wins).
List<String> dedupeFacts(Iterable<String> candidates, Iterable<String> existing) {
  final kept = <String>[];
  final all = existing.toList();
  for (final raw in candidates) {
    final c = raw.trim();
    if (c.length < 4) continue;
    if (all.any((e) => isDuplicateFact(e, c))) continue;
    kept.add(c);
    all.add(c);
  }
  return kept;
}

/// Inserts new facts after deduping against stored memories. Returns what was inserted.
Future<List<String>> insertMemoriesDeduped(AppDatabase db, Iterable<String> facts, {String source = 'chat'}) async {
  final existing = await db.select(db.coachMemories).get();
  final fresh = dedupeFacts(facts, existing.map((m) => m.content));
  for (final f in fresh) {
    await db.into(db.coachMemories).insert(CoachMemoriesCompanion.insert(content: f, source: Value(source)));
  }
  return fresh;
}

const _memorySchema = {
  'type': 'object',
  'properties': {
    'memories': {
      'type': 'array',
      'items': {'type': 'string'},
    },
  },
  'required': ['memories'],
};

/// Runs memory extraction over chat messages newer than the last scanned id.
class CoachMemoryService {
  final Ref ref;
  CoachMemoryService(this.ref);

  AppDatabase get _db => ref.read(databaseProvider);

  /// Queues an extraction job when there are unscanned user messages
  /// (no-op otherwise). Safe to call often (debounced by the chat).
  Future<void> scheduleExtraction() async {
    try {
      final prefs = ref.read(sharedPrefsProvider);
      final lastId = prefs.getInt(coachMemoryLastIdKey) ?? 0;
      final newer = await (_db.select(_db.coachMessages)
            ..where((m) => m.id.isBiggerThanValue(lastId) & m.role.equals('user'))
            ..limit(1))
          .get();
      if (newer.isEmpty) return;
      final pending = await (_db.select(_db.aiQueue)
            ..where((q) => q.feature.equals(coachMemoryJob) & q.status.equals('pending')))
          .get();
      if (pending.isNotEmpty) {
        await ref.read(aiQueueProvider).process();
        return;
      }
      await ref.read(aiQueueProvider).enqueue(coachMemoryJob, {});
    } catch (_) {
      // Memory is best-effort.
    }
  }

  /// Queue handler: extracts facts with Haiku and stores the new ones.
  Future<List<String>> extract() async {
    final prefs = ref.read(sharedPrefsProvider);
    final lastId = prefs.getInt(coachMemoryLastIdKey) ?? 0;
    final msgs = await (_db.select(_db.coachMessages)
          ..where((m) => m.id.isBiggerThanValue(lastId) & m.kind.equals('offline_notice').not())
          ..orderBy([(m) => OrderingTerm.asc(m.id)])
          ..limit(60))
        .get();
    if (msgs.isEmpty || !msgs.any((m) => m.role == 'user')) return [];
    final existing = await _db.select(_db.coachMemories).get();
    final convo = msgs
        .map((m) => '${m.role == 'user' ? 'USER' : 'COACH'}: ${m.content.length > 1200 ? m.content.substring(0, 1200) : m.content}')
        .join('\n');
    final prompt = '''
Extract lasting, useful facts about the USER from this gym-coach conversation, to remember in future chats.
Keep only things that stay true for weeks: injuries/pain locations, health conditions, equipment access, schedule constraints, food preferences/allergies, training preferences, goals, life circumstances.
Ignore one-off logs (today's meal, a single set), greetings, and anything the coach said that the user did not confirm.
Write each fact as one short sentence in the same language the user used. Do not repeat facts that are already known.
Return an empty list when there is nothing new.

ALREADY KNOWN:
${existing.isEmpty ? '(none)' : existing.map((e) => '- ${e.content}').join('\n')}

CONVERSATION:
$convo''';
    final res = await ref.read(aiServiceProvider).structured(
          feature: AiFeature.memoryExtract,
          prompt: prompt,
          schema: _memorySchema,
          maxTokens: 2000,
        );
    final facts = (res['memories'] as List).whereType<String>().toList();
    final inserted = await insertMemoriesDeduped(_db, facts);
    await prefs.setInt(coachMemoryLastIdKey, msgs.last.id);
    return inserted;
  }
}

final coachMemoryServiceProvider = Provider<CoachMemoryService>((ref) => CoachMemoryService(ref));
