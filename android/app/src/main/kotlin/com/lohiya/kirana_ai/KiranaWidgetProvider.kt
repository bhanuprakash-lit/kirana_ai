package com.lohiya.kirana_ai

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.graphics.Color
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

/**
 * Renders the medium 4-stat "Today at a glance" widget. It only paints the
 * snapshot the Flutter app writes (see HomeWidgetService) — no data access here.
 */
class KiranaWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        for (id in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.kirana_widget)
            val loggedIn = widgetData.getString("logged_in", "false") == "true"

            if (!loggedIn) {
                views.setViewVisibility(R.id.content, View.GONE)
                views.setViewVisibility(R.id.empty, View.VISIBLE)
                views.setTextViewText(
                    R.id.empty,
                    widgetData.getString("empty_msg", "Open Kirana AI")
                )
                views.setOnClickPendingIntent(R.id.empty, launch(context, "kiranaai://w"))
                appWidgetManager.updateAppWidget(id, views)
                continue
            }

            views.setViewVisibility(R.id.empty, View.GONE)
            views.setViewVisibility(R.id.content, View.VISIBLE)
            views.setTextViewText(R.id.updated, widgetData.getString("updated_at", ""))

            bindCell(views, widgetData, "sales", R.id.sales_label, R.id.sales_value, R.id.sales_sub)
            bindCell(views, widgetData, "udhaar", R.id.udhaar_label, R.id.udhaar_value, R.id.udhaar_sub)
            bindCell(views, widgetData, "stock", R.id.stock_label, R.id.stock_value, R.id.stock_sub)
            bindCell(views, widgetData, "supplier", R.id.supplier_label, R.id.supplier_value, R.id.supplier_sub)

            views.setTextViewText(R.id.btn_newbill, widgetData.getString("newbill_label", "+ New Bill"))

            views.setOnClickPendingIntent(R.id.cell_sales, launch(context, "kiranaai://w?tab=overview"))
            views.setOnClickPendingIntent(R.id.cell_udhaar, launch(context, "kiranaai://w?tab=finance&subtab=0"))
            views.setOnClickPendingIntent(R.id.cell_stock, launch(context, "kiranaai://w?tab=pos&subtab=1"))
            views.setOnClickPendingIntent(R.id.cell_supplier, launch(context, "kiranaai://w?tab=finance&subtab=1"))
            views.setOnClickPendingIntent(R.id.btn_newbill, launch(context, "kiranaai://w?tab=pos&subtab=0&action=scan"))

            appWidgetManager.updateAppWidget(id, views)
        }
    }

    private fun bindCell(
        views: RemoteViews,
        data: SharedPreferences,
        key: String,
        labelId: Int,
        valueId: Int,
        subId: Int
    ) {
        views.setTextViewText(labelId, data.getString("${key}_label", ""))
        views.setTextViewText(valueId, data.getString("${key}_value", "—"))
        views.setTextViewText(subId, data.getString("${key}_sub", ""))
        val alert = data.getString("${key}_alert", "false") == "true"
        views.setTextColor(subId, if (alert) Color.parseColor("#FCA5A5") else Color.parseColor("#AEBBD4"))
    }

    private fun launch(context: Context, uri: String): PendingIntent =
        HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java, Uri.parse(uri))
}
