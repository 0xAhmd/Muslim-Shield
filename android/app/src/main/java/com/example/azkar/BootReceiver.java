package com.example.azkar;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.appwidget.AppWidgetManager;
import android.content.ComponentName;

public class BootReceiver extends BroadcastReceiver {
    
    @Override
    public void onReceive(Context context, Intent intent) {
        String action = intent.getAction();
        
        if (Intent.ACTION_BOOT_COMPLETED.equals(action) ||
            Intent.ACTION_MY_PACKAGE_REPLACED.equals(action) ||
            Intent.ACTION_PACKAGE_REPLACED.equals(action)) {
            
            // Check if we have any active widgets
            if (hasActiveWidgets(context)) {
                // Restart the widget auto-update service
                WidgetUpdateService.startAutoUpdates(context);
                
                // Immediately update widgets with fresh content
                updateAllWidgets(context);
                
                System.out.println("Widget auto-updates restarted after boot/update");
            }
        }
    }
    
    private boolean hasActiveWidgets(Context context) {
        AppWidgetManager appWidgetManager = AppWidgetManager.getInstance(context);
        
        // Check for Dua widgets
        ComponentName duaWidget = new ComponentName(context, DuaAppWidget.class);
        int[] duaWidgetIds = appWidgetManager.getAppWidgetIds(duaWidget);
        
        // Check for Prayer widgets
        ComponentName prayerWidget = new ComponentName(context, NextPrayerAppWidget.class);
        int[] prayerWidgetIds = appWidgetManager.getAppWidgetIds(prayerWidget);
        
        return duaWidgetIds.length > 0 || prayerWidgetIds.length > 0;
    }
    
    private void updateAllWidgets(Context context) {
        try {
            AppWidgetManager appWidgetManager = AppWidgetManager.getInstance(context);
            
            // Update Dua widgets
            ComponentName duaWidget = new ComponentName(context, DuaAppWidget.class);
            int[] duaWidgetIds = appWidgetManager.getAppWidgetIds(duaWidget);
            for (int widgetId : duaWidgetIds) {
                DuaAppWidget.updateAppWidget(context, appWidgetManager, widgetId);
            }
            
            // Update Prayer widgets
            ComponentName prayerWidget = new ComponentName(context, NextPrayerAppWidget.class);
            int[] prayerWidgetIds = appWidgetManager.getAppWidgetIds(prayerWidget);
            for (int widgetId : prayerWidgetIds) {
                NextPrayerAppWidget.updateAppWidget(context, appWidgetManager, widgetId);
            }
            
        } catch (Exception e) {
            System.err.println("Error updating widgets after boot: " + e.getMessage());
        }
    }
}