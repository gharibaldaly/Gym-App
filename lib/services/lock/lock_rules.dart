/// Pure rule: lock again after the app was in background longer than the timeout.
bool shouldRelock({required bool enabled, required DateTime? backgroundedAt, required DateTime now, required int timeoutSeconds}) {
  if (!enabled || backgroundedAt == null) return false;
  return now.difference(backgroundedAt).inSeconds >= timeoutSeconds;
}
