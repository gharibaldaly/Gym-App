import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/context_ext.dart';
import '../../core/widgets/brand_mark.dart';
import '../../core/widgets/motion.dart';
import '../../services/cloud/cloud_providers.dart';

/// Human-readable sign-in / sign-up error.
String authErrorText(AppLocalizations l, Object e) {
  if (e is AuthRetryableFetchException || e is SocketException || e is TimeoutException) return l.authErrNetwork;
  if (e is AuthWeakPasswordException) return l.authErrWeak;
  if (e is AuthException) {
    switch (e.code) {
      case 'invalid_credentials':
        return l.authErrInvalid;
      case 'email_not_confirmed':
        return l.authErrNotConfirmed;
      case 'user_already_exists' || 'email_exists':
        return l.authErrExists;
      case 'weak_password':
        return l.authErrWeak;
      case 'over_request_rate_limit' || 'over_email_send_rate_limit':
        return l.authErrRate;
    }
    if (e.message.toLowerCase().contains('invalid login credentials')) return l.authErrInvalid;
    return l.authErrGeneric(e.message);
  }
  return l.authErrGeneric('$e');
}

final _emailRe = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

/// First screen of the app: sign in or create an account (email + password, or Google).
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _signUp = false;
  bool _obscure = true;
  bool _busy = false;
  String? _emailError;
  String? _passwordError;

  GoTrueClient get _auth => CloudRuntime.auth;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  bool _validate({bool needPassword = true}) {
    final l = context.l10n;
    setState(() {
      _emailError = _emailRe.hasMatch(_email.text.trim()) ? null : l.authEmailInvalid;
      _passwordError = !needPassword || _password.text.length >= 6 ? null : l.authPasswordShort;
    });
    return _emailError == null && _passwordError == null;
  }

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
    } catch (e) {
      if (mounted) context.snack(authErrorText(context.l10n, e), kind: ToastKind.error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_validate()) return;
    final email = _email.text.trim();
    final l = context.l10n;
    await _run(() async {
      if (_signUp) {
        final res = await _auth.signUp(email: email, password: _password.text, emailRedirectTo: CloudConfig.redirectUrl);
        // With email confirmation on there is no session yet: the user confirms, then signs in.
        if (res.session == null && mounted) {
          setState(() => _signUp = false);
          await showDialog<void>(
            context: context,
            builder: (c) => AlertDialog(
              icon: const Icon(Symbols.mark_email_read_rounded, color: AppColors.primary, size: 36),
              content: Text(l.authCheckEmail(email), textAlign: TextAlign.center),
              actions: [TextButton(onPressed: () => Navigator.pop(c), child: Text(MaterialLocalizations.of(c).okButtonLabel))],
            ),
          );
        }
      } else {
        await _auth.signInWithPassword(email: email, password: _password.text);
      }
      HapticFeedback.mediumImpact();
    });
  }

  Future<void> _forgot() async {
    final l = context.l10n;
    if (!_emailRe.hasMatch(_email.text.trim())) {
      setState(() => _emailError = l.authEnterEmailFirst);
      return;
    }
    final email = _email.text.trim();
    await _run(() async {
      await _auth.resetPasswordForEmail(email, redirectTo: CloudConfig.redirectUrl);
      if (mounted) context.snack(l.authResetSent(email), kind: ToastKind.success);
    });
  }

  Future<void> _google() async {
    final l = context.l10n;
    await _run(() async {
      final ok = await _auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: CloudConfig.redirectUrl,
        authScreenLaunchMode: LaunchMode.externalApplication,
      );
      if (!ok && mounted) context.snack(l.authErrGoogle, kind: ToastKind.error);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(AppSpace.xl, AppSpace.xl, AppSpace.xl, AppSpace.xxl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: revealAll([
                    const Center(child: BrandMark(size: 96)),
                    const SizedBox(height: AppSpace.md),
                    Text('IronMind', textAlign: TextAlign.center, style: context.text.headlineLarge),
                    const SizedBox(height: AppSpace.sm),
                    Text(
                      l.authTagline,
                      textAlign: TextAlign.center,
                      style: context.text.bodyMedium?.copyWith(color: AppColors.textMuted),
                    ),
                    const SizedBox(height: AppSpace.xl),
                    SegmentedButton<bool>(
                      segments: [
                        ButtonSegment(value: false, label: Text(l.authSignIn)),
                        ButtonSegment(value: true, label: Text(l.authSignUp)),
                      ],
                      selected: {_signUp},
                      showSelectedIcon: false,
                      onSelectionChanged: _busy ? null : (s) => setState(() => _signUp = s.first),
                    ),
                    const SizedBox(height: AppSpace.lg),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: _email,
                          enabled: !_busy,
                          keyboardType: TextInputType.emailAddress,
                          textDirection: TextDirection.ltr,
                          autofillHints: const [AutofillHints.email],
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: l.authEmail,
                            errorText: _emailError,
                            prefixIcon: const Icon(Symbols.mail_rounded),
                          ),
                        ),
                        const SizedBox(height: AppSpace.md),
                        TextField(
                          controller: _password,
                          enabled: !_busy,
                          obscureText: _obscure,
                          textDirection: TextDirection.ltr,
                          autofillHints: [_signUp ? AutofillHints.newPassword : AutofillHints.password],
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _submit(),
                          decoration: InputDecoration(
                            labelText: l.authPassword,
                            errorText: _passwordError,
                            prefixIcon: const Icon(Symbols.lock_rounded),
                            suffixIcon: IconButton(
                              onPressed: () => setState(() => _obscure = !_obscure),
                              icon: Icon(_obscure ? Symbols.visibility_rounded : Symbols.visibility_off_rounded),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (!_signUp)
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: TextButton(onPressed: _busy ? null : _forgot, child: Text(l.authForgot)),
                      )
                    else
                      const SizedBox(height: AppSpace.lg),
                    FilledButton(
                      onPressed: _busy ? null : _submit,
                      child: _busy
                          ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5))
                          : Text(_signUp ? l.authSignUp : l.authSignIn),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSpace.lg),
                      child: Row(children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpace.md),
                          child: Text(l.authOr, style: context.text.labelMedium),
                        ),
                        const Expanded(child: Divider()),
                      ]),
                    ),
                    OutlinedButton.icon(
                      onPressed: _busy ? null : _google,
                      icon: const Icon(Symbols.account_circle_rounded),
                      label: Text(l.authGoogle),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Asks for a new password after the user opened a password-reset link.
Future<void> showNewPasswordDialog(BuildContext context) async {
  final l = context.l10n;
  final controller = TextEditingController();
  String? error;
  var busy = false;
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (c) => StatefulBuilder(
      builder: (c, set) => AlertDialog(
        title: Text(l.authNewPasswordTitle),
        content: TextField(
          controller: controller,
          obscureText: true,
          autofocus: true,
          textDirection: TextDirection.ltr,
          decoration: InputDecoration(labelText: l.authPassword, errorText: error),
        ),
        actions: [
          TextButton(
            onPressed: busy ? null : () => Navigator.pop(c),
            child: Text(MaterialLocalizations.of(c).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: busy
                ? null
                : () async {
                    if (controller.text.length < 6) {
                      set(() => error = l.authPasswordShort);
                      return;
                    }
                    set(() => busy = true);
                    try {
                      await CloudRuntime.auth.updateUser(UserAttributes(password: controller.text));
                      if (c.mounted) Navigator.pop(c);
                      if (context.mounted) context.snack(l.authPasswordUpdated, kind: ToastKind.success);
                    } catch (e) {
                      set(() {
                        busy = false;
                        error = authErrorText(l, e);
                      });
                    }
                  },
            child: Text(MaterialLocalizations.of(c).saveButtonLabel),
          ),
        ],
      ),
    ),
  );
  controller.dispose();
}
