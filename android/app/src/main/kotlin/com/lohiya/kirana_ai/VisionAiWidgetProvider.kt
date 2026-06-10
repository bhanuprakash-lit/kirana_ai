package com.lohiya.kirana_ai

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

/** 1×1 widget for the (upcoming) Vision AI feature — opens the app and shows a
 *  "coming soon" toast for now. */
class VisionAiWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        for (id in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.vision_ai_widget)
            views.setOnClickPendingIntent(
                R.id.vision_ai_root,
                HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java,
                    Uri.parse("kiranaai://w?tab=overview&action=vision")
                )
            )
            appWidgetManager.updateAppWidget(id, views)
        }
    }
}
