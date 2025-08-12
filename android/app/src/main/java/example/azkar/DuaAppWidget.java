package com.example.azkar;

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.widget.RemoteViews;

public class DuaAppWidget extends AppWidgetProvider {

    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        for (int appWidgetId : appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId);
        }
    }

    static void updateAppWidget(Context context, AppWidgetManager appWidgetManager, int appWidgetId) {
        // Get SharedPreferences using the same key as Flutter
        SharedPreferences widgetData = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE);
        
        RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.dua_widget);
        
        // Get data from SharedPreferences (set by Flutter)
        // Note: Flutter adds "flutter." prefix to keys
        String title = widgetData.getString("flutter.dua_title", "Muslim Shield");
        String arabic = widgetData.getString("flutter.dua_arabic", "اللَّهُمَّ بَارِكْ لَنَا");
        String translation = widgetData.getString("flutter.dua_translation", "O Allah, bless us");
        String category = widgetData.getString("flutter.dua_category", "Daily Duas");
        
        // Update the widget views
        views.setTextViewText(R.id.widget_title, title);
        views.setTextViewText(R.id.widget_arabic, arabic);
        views.setTextViewText(R.id.widget_translation, translation);
        views.setTextViewText(R.id.widget_category, category);
        
        // Set click listener to open the app
        Intent intent = new Intent(context, MainActivity.class);
        intent.putExtra("route", "dua");
        intent.setAction("WIDGET_CLICK"); // Add unique action
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        
        PendingIntent pendingIntent = PendingIntent.getActivity(
            context, 
            appWidgetId, // Use appWidgetId as request code to make it unique
            intent, 
            PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE
        );
        
        // Set click listener on the entire widget
        views.setOnClickPendingIntent(R.id.widget_container, pendingIntent);
        
        appWidgetManager.updateAppWidget(appWidgetId, views);
    }
}