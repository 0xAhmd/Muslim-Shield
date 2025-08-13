package com.example.azkar;

import android.content.Intent;
import android.net.Uri;
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
                System.out.println("App launched from Dua widget");
                
                // Update the dua widget with fresh content
                updateDuaWidget();
            }
        }
        
        // Check for prayer widget launch
        if (intent.getBooleanExtra("open_prayer_page", false)) {
            System.out.println("App launched from Prayer widget");
        }
    }

    private void startWidgetAutoUpdates() {
        try {
            WidgetUpdateService.startAutoUpdates(this);
            System.out.println("Widget auto-updates started from Flutter");
        } catch (Exception e) {
            System.err.println("Error starting widget auto-updates: " + e.getMessage());
        }
    }

    private void stopWidgetAutoUpdates() {
        try {
            WidgetUpdateService.stopAutoUpdates(this);
            System.out.println("Widget auto-updates stopped from Flutter");
        } catch (Exception e) {
            System.err.println("Error stopping widget auto-updates: " + e.getMessage());
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
            
            System.out.println("Dua widget updated manually");
        } catch (Exception e) {
            System.err.println("Error updating Dua widget: " + e.getMessage());
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        // Ensure auto-updates continue even if the main activity is destroyed
        // The service should continue running in the background
    }
}