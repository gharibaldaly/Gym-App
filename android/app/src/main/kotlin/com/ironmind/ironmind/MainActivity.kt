package com.ironmind.ironmind

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

// FlutterFragmentActivity is required by local_auth (BiometricPrompt) and health (Health Connect permissions).
class MainActivity : FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Keeps long tasks alive with the screen locked (see BackgroundWorkService).
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "ironmind/background_work")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "start" -> result.success(
                        BackgroundWorkService.start(
                            applicationContext,
                            call.argument<String>("title") ?: "IronMind",
                            call.argument<String>("text") ?: "",
                            call.argument<String>("channel") ?: "Background work",
                        )
                    )
                    "stop" -> {
                        BackgroundWorkService.stop(applicationContext)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
