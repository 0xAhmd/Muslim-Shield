package com.example.azkar;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.app.Service;
import android.appwidget.AppWidgetManager;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.os.IBinder;
import android.os.SystemClock;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class WidgetUpdateService extends Service {
    private static final String ACTION_UPDATE_WIDGET = "com.example.azkar.UPDATE_WIDGET";
    private static final long DUA_UPDATE_INTERVAL = 10 * 60 * 1000; // 10 minutes for Dua widget
    private static final long PRAYER_UPDATE_INTERVAL = 1 * 60 * 1000; // 1 minute for Prayer widget (for countdown)
    private ScheduledExecutorService executorService;

    @Override
    public void onCreate() {
        super.onCreate();
        scheduleWidgetUpdates();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        if (ACTION_UPDATE_WIDGET.equals(intent.getAction())) {
            updateAllWidgets();
        }
        return START_STICKY; // Restart if killed
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null; // We don't need binding
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (executorService != null) {
            executorService.shutdown();
        }
    }

    private void scheduleWidgetUpdates() {
        // Use AlarmManager for reliable periodic updates
        AlarmManager alarmManager = (AlarmManager) getSystemService(Context.ALARM_SERVICE);
        
        // Schedule Dua widget updates (every 10 minutes)
        Intent duaUpdateIntent = new Intent(this, WidgetUpdateReceiver.class);
        duaUpdateIntent.setAction(ACTION_UPDATE_WIDGET);
        duaUpdateIntent.putExtra("widget_type", "dua");
        
        PendingIntent duaPendingIntent = PendingIntent.getBroadcast(
            this, 
            1, 
            duaUpdateIntent, 
            PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE
        );

        alarmManager.setRepeating(
            AlarmManager.ELAPSED_REALTIME,
            SystemClock.elapsedRealtime() + DUA_UPDATE_INTERVAL,
            DUA_UPDATE_INTERVAL,
            duaPendingIntent
        );

        // Schedule Prayer widget updates (every 1 minute for countdown)
        Intent prayerUpdateIntent = new Intent(this, WidgetUpdateReceiver.class);
        prayerUpdateIntent.setAction(ACTION_UPDATE_WIDGET);
        prayerUpdateIntent.putExtra("widget_type", "prayer");
        
        PendingIntent prayerPendingIntent = PendingIntent.getBroadcast(
            this, 
            2, 
            prayerUpdateIntent, 
            PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE
        );

        alarmManager.setRepeating(
            AlarmManager.ELAPSED_REALTIME,
            SystemClock.elapsedRealtime() + PRAYER_UPDATE_INTERVAL,
            PRAYER_UPDATE_INTERVAL,
            prayerPendingIntent
        );

        // Also use ScheduledExecutorService as backup
        if (executorService == null) {
            executorService = Executors.newSingleThreadScheduledExecutor();
            
            // Schedule Dua widget updates
            executorService.scheduleAtFixedRate(
                this::updateDuaWidgets, 
                10, 
                10, 
                TimeUnit.MINUTES
            );
            
            // Schedule Prayer widget updates (more frequent for countdown)
            executorService.scheduleAtFixedRate(
                this::updatePrayerWidgets, 
                1, 
                1, 
                TimeUnit.MINUTES
            );
        }
        
        System.out.println("WidgetUpdateService: Scheduled updates for both widget types");
    }

    private void updateAllWidgets() {
        updateDuaWidgets();
        updatePrayerWidgets();
    }

    private void updateDuaWidgets() {
        try {
            AppWidgetManager appWidgetManager = AppWidgetManager.getInstance(this);
            ComponentName duaWidget = new ComponentName(this, DuaAppWidget.class);
            int[] appWidgetIds = appWidgetManager.getAppWidgetIds(duaWidget);
            
            if (appWidgetIds.length > 0) {
                // Trigger widget update
                Intent updateIntent = new Intent(AppWidgetManager.ACTION_APPWIDGET_UPDATE);
                updateIntent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, appWidgetIds);
                sendBroadcast(updateIntent);
                
                // Also directly update
                for (int widgetId : appWidgetIds) {
                    DuaAppWidget.updateAppWidget(this, appWidgetManager, widgetId);
                }
                
                System.out.println("WidgetUpdateService: Auto-updated " + appWidgetIds.length + " dua widgets");
            }
        } catch (Exception e) {
            System.err.println("WidgetUpdateService: Error auto-updating dua widgets: " + e.getMessage());
        }
    }

    private void updatePrayerWidgets() {
        try {
            AppWidgetManager appWidgetManager = AppWidgetManager.getInstance(this);
            ComponentName prayerWidget = new ComponentName(this, NextPrayerAppWidget.class);
            int[] appWidgetIds = appWidgetManager.getAppWidgetIds(prayerWidget);
            
            if (appWidgetIds.length > 0) {
                System.out.println("WidgetUpdateService: Updating " + appWidgetIds.length + " prayer widgets");
                
                // Directly update prayer widgets
                for (int widgetId : appWidgetIds) {
                    NextPrayerAppWidget.updateAppWidget(this, appWidgetManager, widgetId);
                }
                
                System.out.println("WidgetUpdateService: Auto-updated " + appWidgetIds.length + " prayer widgets");
            }
        } catch (Exception e) {
            System.err.println("WidgetUpdateService: Error auto-updating prayer widgets: " + e.getMessage());
        }
    }

    // BroadcastReceiver to handle alarm-triggered updates
    public static class WidgetUpdateReceiver extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            if (ACTION_UPDATE_WIDGET.equals(intent.getAction())) {
                String widgetType = intent.getStringExtra("widget_type");
                
                // Start the service to update widgets
                Intent serviceIntent = new Intent(context, WidgetUpdateService.class);
                serviceIntent.setAction(ACTION_UPDATE_WIDGET);
                serviceIntent.putExtra("widget_type", widgetType);
                context.startService(serviceIntent);
                
                System.out.println("WidgetUpdateReceiver: Triggered update for " + widgetType + " widget");
            }
        }
    }

    // Method to start the service from Flutter/MainActivity
    public static void startAutoUpdates(Context context) {
        Intent serviceIntent = new Intent(context, WidgetUpdateService.class);
        context.startService(serviceIntent);
        System.out.println("WidgetUpdateService: Auto-updates started");
    }

    // Method to stop auto updates
    public static void stopAutoUpdates(Context context) {
        Intent serviceIntent = new Intent(context, WidgetUpdateService.class);
        context.stopService(serviceIntent);
        
        // Cancel the alarms
        AlarmManager alarmManager = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);
        
        // Cancel Dua widget alarm
        Intent duaUpdateIntent = new Intent(context, WidgetUpdateReceiver.class);
        duaUpdateIntent.setAction(ACTION_UPDATE_WIDGET);
        duaUpdateIntent.putExtra("widget_type", "dua");
        PendingIntent duaPendingIntent = PendingIntent.getBroadcast(
            context, 
            1, 
            duaUpdateIntent, 
            PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE
        );
        alarmManager.cancel(duaPendingIntent);
        
        // Cancel Prayer widget alarm
        Intent prayerUpdateIntent = new Intent(context, WidgetUpdateReceiver.class);
        prayerUpdateIntent.setAction(ACTION_UPDATE_WIDGET);
        prayerUpdateIntent.putExtra("widget_type", "prayer");
        PendingIntent prayerPendingIntent = PendingIntent.getBroadcast(
            context, 
            2, 
            prayerUpdateIntent, 
            PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE
        );
        alarmManager.cancel(prayerPendingIntent);
        
        System.out.println("WidgetUpdateService: Auto-updates stopped");
    }
}