import '../../../core/providers.dart';

/// Callback every question widget uses to report a (partial) answer change.
/// The host decides whether to persist immediately (onboarding) or on Save
/// (profile editor).
typedef ProfilePatch = void Function(UserProfilesCompanion patch);
