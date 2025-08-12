package com.example.azkar;

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.widget.RemoteViews;

import es.antonborri.home_widget.HomeWidgetPlugin;

public class DuaAppWidget extends AppWidgetProvider {

    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        for (int appWidgetId : appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId);
        }
    }

    static void updateAppWidget(Context context, AppWidgetManager appWidgetManager, int appWidgetId) {
        SharedPreferences widgetData = HomeWidgetPlugin.getData(context);
        
        RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.dua_widget);
        
        // Get data from SharedPreferences (set by Flutter)
        String title = widgetData.getString("dua_title", "Muslim Shield");
        String arabic = widgetData.getString("dua_arabic", "اللَّهُمَّ بَارِكْ لَنَا");
        String translation = widgetData.getString("dua_translation", "O Allah, bless us");
        String category = widgetData.getString("dua_category", "Daily Duas");
        
        // Update the widget views
        views.setTextViewText(R.id.widget_title, title);
        views.setTextViewText(R.id.widget_arabic, arabic);
        views.setTextViewText(R.id.widget_translation, translation);
        views.setTextViewText(R.id.widget_category, category);
        
        // Set click listener to open the app
        Intent intent = new Intent(context, MainActivity.class);
        intent.putExtra("route", "dua");
        PendingIntent pendingIntent = PendingIntent.getActivity(
            context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);
        views.setOnClickPendingIntent(R.id.widget_arabic, pendingIntent);
        
        appWidgetManager.updateAppWidget(appWidgetId, views);
    }
}