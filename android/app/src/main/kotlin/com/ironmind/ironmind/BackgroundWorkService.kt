package com.ironmind.ironmind

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.IBinder
import android.os.PowerManager

/**
 * Foreground service that keeps the process (and its network access) alive while the
 * app finishes a long task, e.g. a Claude request, with the screen locked or the app in
 * the background. It does no work itself: the Dart code keeps running in the main
 * isolate; this only stops Android from suspending it. Started/stopped from Dart over
 * the "ironmind/background_work" channel (see MainActivity).
 */
class BackgroundWorkService : Service() {
    private var wakeLock: PowerManager.WakeLock? = null

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val title = intent?.getStringExtra(EXTRA_TITLE) ?: "IronMind"
        val text = intent?.getStringExtra(EXTRA_TEXT) ?: ""
        val notification = buildNotification(title, text)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            startForeground(NOTIFICATION_ID, notification, ServiceInfo.FOREGROUND_SERVICE_TYPE_DATA_SYNC)
        } else {
            startForeground(NOTIFICATION_ID, notification)
        }
        if (wakeLock == null) {
            val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
            // Partial lock: the CPU keeps running with the screen off. Capped so a bug can't drain the battery.
            wakeLock = pm.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "IronMind:backgroundWork").apply {
                setReferenceCounted(false)
                acquire(MAX_WAKE_MS)
            }
        }
        // If Android kills the process, the Dart work is gone too: don't restart an empty service.
        return START_NOT_STICKY
    }

    override fun onTimeout(startId: Int, fgsType: Int) {
        // Android 15+ limit for dataSync services: stop cleanly instead of crashing.
        stopSelf()
    }

    override fun onDestroy() {
        wakeLock?.let { if (it.isHeld) it.release() }
        wakeLock = null
        super.onDestroy()
    }

    private fun buildNotification(title: String, text: String): Notification {
        val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        if (nm.getNotificationChannel(CHANNEL_ID) == null) {
            val name = channelName ?: "Background work"
            nm.createNotificationChannel(
                NotificationChannel(CHANNEL_ID, name, NotificationManager.IMPORTANCE_LOW).apply {
                    setShowBadge(false)
                    setSound(null, null)
                    enableVibration(false)
                }
            )
        }
        val open = packageManager.getLaunchIntentForPackage(packageName)?.let {
            PendingIntent.getActivity(this, 0, it, PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT)
        }
        val builder = Notification.Builder(this, CHANNEL_ID)
            .setSmallIcon(R.drawable.ic_stat_ironmind)
            .setColor(0xFFC6F432.toInt())
            .setContentTitle(title)
            .setContentText(text)
            .setStyle(Notification.BigTextStyle().bigText(text))
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .setShowWhen(false)
            .setProgress(0, 0, true)
            .setCategory(Notification.CATEGORY_PROGRESS)
            .setContentIntent(open)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            builder.setForegroundServiceBehavior(Notification.FOREGROUND_SERVICE_IMMEDIATE)
        }
        return builder.build()
    }

    companion object {
        private const val CHANNEL_ID = "background_work"
        private const val NOTIFICATION_ID = 4
        private const val MAX_WAKE_MS = 30L * 60L * 1000L
        private const val EXTRA_TITLE = "title"
        private const val EXTRA_TEXT = "text"

        /** Localized channel name, set by Dart before the first start. */
        @Volatile
        var channelName: String? = null

        /** Returns false when Android refuses (e.g. starting while the app is already in the background). */
        fun start(context: Context, title: String, text: String, channelName: String): Boolean {
            channelName = channelName
            val intent = Intent(context, BackgroundWorkService::class.java)
                .putExtra(EXTRA_TITLE, title)
                .putExtra(EXTRA_TEXT, text)
            return try {
                context.startForegroundService(intent)
                true
            } catch (e: Exception) {
                false
            }
        }

        fun stop(context: Context) {
            try {
                context.stopService(Intent(context, BackgroundWorkService::class.java))
            } catch (e: Exception) {
            }
        }
    }
}
