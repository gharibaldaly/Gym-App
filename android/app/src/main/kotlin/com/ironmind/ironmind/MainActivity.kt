package com.ironmind.ironmind

import android.content.Context
import android.os.PowerManager
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

// FlutterFragmentActivity is required by local_auth (BiometricPrompt) and health (Health Connect permissions).
class MainActivity : FlutterFragmentActivity() {
    private var wakeLock: PowerManager.WakeLock? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Partial wake lock held while an AI request / backup runs (lib/services/keep_alive),
        // so the CPU keeps working when the screen turns off.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "ironmind/keepalive")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "acquire" -> {
                        if (wakeLock?.isHeld != true) {
                            val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
                            wakeLock = pm.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "IronMind:work").apply {
                                setReferenceCounted(false)
                                acquire(15 * 60 * 1000L) // safety timeout
                            }
                        }
                        result.success(null)
                    }
                    "release" -> {
                        releaseWakeLock()
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun releaseWakeLock() {
        wakeLock?.let { if (it.isHeld) it.release() }
        wakeLock = null
    }

    override fun onDestroy() {
        releaseWakeLock()
        super.onDestroy()
    }
}
