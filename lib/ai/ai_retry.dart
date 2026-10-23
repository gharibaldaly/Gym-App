import 'dart:async';

import 'claude_client.dart';

/// Retry policy for Claude calls: dropped connections and temporary server errors
/// (429 / 5xx / 529 overloaded) are retried after a short backoff, once the app can
/// reach the network again ([waitUntilUsable]). Other errors are rethrown at once.
class AiRetry {
  final int maxAttempts;
  final List<Duration> backoff;
  final Future<void> Function() waitUntilUsable;

  const AiRetry({
    this.maxAttempts = 4,
    this.backoff = const [Duration(seconds: 2), Duration(seconds: 5), Duration(seconds: 10)],
    required this.waitUntilUsable,
  });

  static bool shouldRetry(Object e) {
    if (e is AiNetworkException) return true;
    if (e is! AiException || e is AiOfflineException || e is AiNoKeyException) return false;
    final code = e.statusCode;
    return code != null && (code == 429 || code >= 500);
  }

  /// Delay before attempt number [attempt] + 1 (attempt is 1-based).
  Duration delayAfter(int attempt) => backoff.isEmpty ? Duration.zero : backoff[(attempt - 1).clamp(0, backoff.length - 1)];

  /// Waits (backoff, then [waitUntilUsable]) before the next attempt.
  Future<void> pause(int attempt) async {
    final d = delayAfter(attempt);
    if (d > Duration.zero) await Future<void>.delayed(d);
    await waitUntilUsable();
  }

  Future<T> run<T>(Future<T> Function() attempt) async {
    for (var i = 1;; i++) {
      try {
        return await attempt();
      } catch (e) {
        if (!shouldRetry(e) || i >= maxAttempts) rethrow;
      }
      await pause(i);
    }
  }
}
