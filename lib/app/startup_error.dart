import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Full-screen diagnostic shown when startup fails, so the problem is visible
/// (and can be screenshotted) instead of the app hanging on the splash screen.
class StartupErrorApp extends StatelessWidget {
  final Object error;
  final StackTrace? stack;
  final VoidCallback? onRetry;
  const StartupErrorApp({super.key, required this.error, this.stack, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: StartupErrorView(error: error, stack: stack, onRetry: onRetry),
    );
  }
}

class StartupErrorView extends StatelessWidget {
  final Object error;
  final StackTrace? stack;
  final VoidCallback? onRetry;
  const StartupErrorView({super.key, required this.error, this.stack, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final details = '$error\n\n${stack ?? ''}'.trim();
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.error_outline, color: Color(0xFFFF4D4D), size: 48),
              const SizedBox(height: 12),
              const Text(
                'حصلت مشكلة وأنا بفتح الأبلكيشن\nIronMind failed to start',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              const SizedBox(height: 8),
              const Text(
                'صوّر الشاشة دي وابعتها.\nPlease screenshot this screen.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF9A9A9A)),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: SelectableText(
                    details,
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 12, color: Color(0xFFF2F2F2)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Clipboard.setData(ClipboardData(text: details)),
                    child: const Text('Copy / نسخ'),
                  ),
                ),
                if (onRetry != null) ...[
                  const SizedBox(width: 12),
                  Expanded(child: FilledButton(onPressed: onRetry, child: const Text('Retry / تاني'))),
                ],
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
