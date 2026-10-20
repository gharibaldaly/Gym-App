package com.ironmind.ironmind

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

/**
 * Home-screen widget: today's workout, remaining calories, water progress and a
 * "+ cup" button that logs water in the background (Dart callback, app stays closed).
 * Data is written from Dart by HomeWidgetService (keys prefixed with "im_").
 */
class IronMindWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.ironmind_widget).apply {
                val rtl = widgetData.getBoolean("im_rtl", true)
                setInt(
                    R.id.widget_root,
                    "setLayoutDirection",
                    if (rtl) View.LAYOUT_DIRECTION_RTL else View.LAYOUT_DIRECTION_LTR,
                )

                setTextViewText(R.id.widget_title, widgetData.getString("im_title", "IronMind"))
                setTextViewText(
                    R.id.widget_workout_label,
                    widgetData.getString("im_workout_label", context.getString(R.string.ironmind_widget_workout)),
                )
                setTextViewText(
                    R.id.widget_workout_title,
                    widgetData.getString("im_workout_title", context.getString(R.string.ironmind_widget_open_app)),
                )
                setTextViewText(R.id.widget_workout_sub, widgetData.getString("im_workout_sub", ""))
                setTextViewText(
                    R.id.widget_kcal_label,
                    widgetData.getString("im_kcal_label", context.getString(R.string.ironmind_widget_calories)),
                )
                setTextViewText(R.id.widget_kcal_text, widgetData.getString("im_kcal_text", "—"))
                setTextViewText(
                    R.id.widget_water_label,
                    widgetData.getString("im_water_label", context.getString(R.string.ironmind_widget_water)),
                )
                setTextViewText(R.id.widget_water_text, widgetData.getString("im_water_text", "0 / 0"))
                setProgressBar(R.id.widget_water_progress, 100, readInt(widgetData, "im_water_pct"), false)
                setTextViewText(
                    R.id.widget_add_cup,
                    widgetData.getString("im_cup_label", context.getString(R.string.ironmind_widget_add_cup)),
                )

                // Tap anywhere → open the app.
                val launch = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java,
                    Uri.parse("ironmind://open"),
                )
                setOnClickPendingIntent(R.id.widget_root, launch)

                // "+ cup" → Dart background callback (homeWidgetInteractivityCallback).
                val addWater = HomeWidgetBackgroundIntent.getBroadcast(
                    context,
                    Uri.parse("ironmind://addwater"),
                )
                setOnClickPendingIntent(R.id.widget_add_cup, addWater)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    private fun readInt(prefs: SharedPreferences, key: String): Int {
        return try {
            prefs.getInt(key, 0)
        } catch (e: ClassCastException) {
            // Dart ints may be stored as Long by home_widget.
            try {
                prefs.getLong(key, 0L).toInt()
            } catch (e2: ClassCastException) {
                0
            }
        }
    }
}
