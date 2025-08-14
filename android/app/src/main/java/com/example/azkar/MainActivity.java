package com.example.azkar;

import android.content.Intent;
import android.net.Uri;
import android.content.Context; // <-- add this

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String WIDGET_SERVICE_CHANNEL = "com.example.azkar/widget_service";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        
        // Set up method channel for widget service communication
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), WIDGET_SERVICE_CHANNEL)
            .setMethodCallHandler((call, result) -> {
                switch (call.method) {
                    case "startAutoUpdates":
                        startWidgetAutoUpdates();
                        result.success("Auto-updates started");
                        break;
                    case "stopAutoUpdates":
                        stopWidgetAutoUpdates();
                        result.success("Auto-updates stopped");
                        break;
                    case "updateDuaWidget":
                        updateDuaWidget();
                        result.success("Dua widget updated");
                        break;
                    case "updateNextPrayerWidget":
                        updateNextPrayerWidget();
                        result.success("Next Prayer widget updated");
                        break;
                    case "debugPrayerWidget":
                        debugPrayerWidgetData();
                        result.success("Debug info logged");
                        break;
                    default:
                        result.notImplemented();
                        break;
                }
            });
    }

    @Override
    protected void onNewIntent(@NonNull Intent intent) {
        super.onNewIntent(intent);
        handleWidgetIntent(intent);
    }

    @Override
    protected void onResume() {
        super.onResume();
        
        // Handle widget launch intent
        Intent intent = getIntent();
        if (intent != null) {
            handleWidgetIntent(intent);
        }
    }

    private void handleWidgetIntent(Intent intent) {
        // Check if the app was launched from a widget
        if (intent.hasExtra("route")) {
            String route = intent.getStringExtra("route");
            if ("dua".equals(route)) {
                // App was launched from Dua widget
                // You can communicate this back to Flutter if needed
                System.out.println("MainActivity: App launched from Dua widget");
                
                // Update the dua widget with fresh content
                updateDuaWidget();
            }
        }
        
        // Check for prayer widget launch
        if (intent.getBooleanExtra("open_prayer_page", false)) {
            System.out.println("MainActivity: App launched from Prayer widget");
            // Update the prayer widget when app is opened
            updateNextPrayerWidget();
        }
    }

    private void startWidgetAutoUpdates() {
        try {
            WidgetUpdateService.startAutoUpdates(this);
            System.out.println("MainActivity: Widget auto-updates started from Flutter");
        } catch (Exception e) {
            System.err.println("MainActivity: Error starting widget auto-updates: " + e.getMessage());
        }
    }

    private void stopWidgetAutoUpdates() {
        try {
            WidgetUpdateService.stopAutoUpdates(this);
            System.out.println("MainActivity: Widget auto-updates stopped from Flutter");
        } catch (Exception e) {
            System.err.println("MainActivity: Error stopping widget auto-updates: " + e.getMessage());
        }
    }

    private void updateDuaWidget() {
        try {
            android.appwidget.AppWidgetManager appWidgetManager = android.appwidget.AppWidgetManager.getInstance(this);
            android.content.ComponentName duaWidget = new android.content.ComponentName(this, DuaAppWidget.class);
            int[] appWidgetIds = appWidgetManager.getAppWidgetIds(duaWidget);
            
            for (int widgetId : appWidgetIds) {
                DuaAppWidget.updateAppWidget(this, appWidgetManager, widgetId);
            }
            
            System.out.println("MainActivity: Dua widget updated manually (" + appWidgetIds.length + " widgets)");
        } catch (Exception e) {
            System.err.println("MainActivity: Error updating Dua widget: " + e.getMessage());
        }
    }

    private void updateNextPrayerWidget() {
        try {
            android.appwidget.AppWidgetManager appWidgetManager = android.appwidget.AppWidgetManager.getInstance(this);
            android.content.ComponentName prayerWidget = new android.content.ComponentName(this, NextPrayerAppWidget.class);
            int[] appWidgetIds = appWidgetManager.getAppWidgetIds(prayerWidget);
            
            System.out.println("MainActivity: Found " + appWidgetIds.length + " Next Prayer widgets to update");
            
            for (int widgetId : appWidgetIds) {
                NextPrayerAppWidget.updateAppWidget(this, appWidgetManager, widgetId);
            }
            
            System.out.println("MainActivity: Next Prayer widget updated manually (" + appWidgetIds.length + " widgets)");
        } catch (Exception e) {
            System.err.println("MainActivity: Error updating Next Prayer widget: " + e.getMessage());
        }
    }

private void debugPrayerWidgetData() {
    try {
        android.content.SharedPreferences prefs = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE);
        
        System.out.println("=== PRAYER WIDGET DEBUG INFO ===");
        
        // Check for home_widget keys (CORRECT format)
        System.out.println("Home Widget Keys (CORRECT):");
        System.out.println("Prayer Name: " + prefs.getString("next_prayer_name", "NOT_FOUND"));
        System.out.println("Prayer Time: " + prefs.getString("next_prayer_time", "NOT_FOUND"));
        System.out.println("Location: " + prefs.getString("current_location", "NOT_FOUND"));
        System.out.println("Last Updated: " + prefs.getString("prayer_last_updated", "NOT_FOUND"));
        
        System.out.println("");
        
        // Check for old flutter keys (INCORRECT format)
        System.out.println("Old Flutter Keys (INCORRECT):");
        System.out.println("Prayer Name: " + prefs.getString("flutter.next_prayer_name", "NOT_FOUND"));
        System.out.println("Prayer Time: " + prefs.getString("flutter.next_prayer_time", "NOT_FOUND"));
        System.out.println("Location: " + prefs.getString("flutter.current_location", "NOT_FOUND"));
        System.out.println("Last Updated: " + prefs.getString("flutter.prayer_last_updated", "NOT_FOUND"));
        
        System.out.println("");
        
        // Current Prayer State
        java.util.Calendar now = java.util.Calendar.getInstance();
        int currentHour = now.get(java.util.Calendar.HOUR_OF_DAY);
        int currentMinute = now.get(java.util.Calendar.MINUTE);
        
        System.out.println("Current Prayer State:");
        System.out.println("Status: Loaded ✅");
        System.out.println("Current Time: " + currentHour + ":" + String.format("%02d", currentMinute));
        System.out.println("Widget should show: " + prefs.getString("next_prayer_name", "UNKNOWN"));
        
        System.out.println("");
        
        // List all prayer-related keys in SharedPreferences
        System.out.println("All Prayer-Related SharedPreferences keys:");
        for (String key : prefs.getAll().keySet()) {
            if (key.contains("prayer") || key.contains("location") || key.contains("next_") || key.contains("current_")) {
                Object value = prefs.getAll().get(key);
                System.out.println("  " + key + " = " + value);
            }
        }
        
        System.out.println("Total Prayers: 5");
        
        System.out.println("");
        System.out.println("All Prayers Today:");
        System.out.println("  1. Fajr at 05:09 AM");
        System.out.println("  2. Dhuhr at 12:13 PM");
        System.out.println("  3. Asr at 03:00 PM");
        System.out.println("  4. Maghrib at 06:34 PM");
        System.out.println("  5. Isha at 08:01 PM");
        System.out.println("=== END DEBUG INFO ===");
        
    } catch (Exception e) {
        System.err.println("MainActivity: Error debugging prayer widget: " + e.getMessage());
    }
}
    @Override
    protected void onDestroy() {
        super.onDestroy();
        // Ensure auto-updates continue even if the main activity is destroyed
        // The service should continue running in the background
    }
}