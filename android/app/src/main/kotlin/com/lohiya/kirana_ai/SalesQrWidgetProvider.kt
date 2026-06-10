package com.lohiya.kirana_ai

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

/** 1×1 quick-action widget — opens the item scanner (same as "New Bill"). */
class SalesQrWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        for (id in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.sales_qr_widget)
            views.setOnClickPendingIntent(
                R.id.sales_qr_root,
                HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java,
                    Uri.parse("kiranaai://w?tab=pos&subtab=0&action=scan")
                )
            )
            appWidgetManager.updateAppWidget(id, views)
        }
    }
}
