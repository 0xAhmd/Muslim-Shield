package com.example.azkar;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.app.Service;
import android.appwidget.AppWidgetManager;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android:content.Context;
import android.content.Intent;
import android.os.IBinder;
import android.os.SystemClock;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class WidgetUpdateService extends Service {
    private static final String ACTION_UPDATE_WIDGET = "com.example.azkar.UPDATE_WIDGET";
    private static final long UPDATE_INTERVAL = 10 * 60 * 1000; // 10 minutes in milliseconds
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
        Intent updateIntent = new Intent(this, WidgetUpdateReceiver.class);
        updateIntent.setAction(ACTION_UPDATE_WIDGET);
        
        PendingIntent pendingIntent = PendingIntent.getBroadcast(
            this, 
            0, 
            updateIntent, 
            PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE
        );

        // Schedule repeating alarm every 10 minutes
        alarmManager.setRepeating(
            AlarmManager.ELAPSED_REALTIME,
            SystemClock.elapsedRealtime() + UPDATE_INTERVAL,
            UPDATE_INTERVAL,
            pendingIntent
        );

        // Also use ScheduledExecutorService as backup
        if (executorService == null) {
            executorService = Executors.newSingleThreadScheduledExecutor();
            executorService.scheduleAtFixedRate(
                this::updateAllWidgets, 
                10, 
                10, 
                TimeUnit.MINUTES
            );
        }
    }

    private void updateAllWidgets() {
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
                
                System.out.println("Auto-updated " + appWidgetIds.length + " dua widgets");
            }
        } catch (Exception e) {
            System.err.println("Error auto-updating widgets: " + e.getMessage());
        }
    }

    // BroadcastReceiver to handle alarm-triggered updates
    public static class WidgetUpdateReceiver extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            if (ACTION_UPDATE_WIDGET.equals(intent.getAction())) {
                // Start the service to update widgets
                Intent serviceIntent = new Intent(context, WidgetUpdateService.class);
                serviceIntent.setAction(ACTION_UPDATE_WIDGET);
                context.startService(serviceIntent);
            }
        }
    }

    // Method to start the service from Flutter/MainActivity
    public static void startAutoUpdates(Context context) {
        Intent serviceIntent = new Intent(context, WidgetUpdateService.class);
        context.startService(serviceIntent);
    }

    // Method to stop auto updates
    public static void stopAutoUpdates(Context context) {
        Intent serviceIntent = new Intent(context, WidgetUpdateService.class);
        context.stopService(serviceIntent);
        
        // Cancel the alarm
        AlarmManager alarmManager = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);
        Intent updateIntent = new Intent(context, WidgetUpdateReceiver.class);
        updateIntent.setAction(ACTION_UPDATE_WIDGET);
        PendingIntent pendingIntent = PendingIntent.getBroadcast(
            context, 
            0, 
            updateIntent, 
            PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE
        );
        alarmManager.cancel(pendingIntent);
    }
}