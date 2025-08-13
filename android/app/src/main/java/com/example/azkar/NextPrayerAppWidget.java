package com.example.azkar;

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.widget.RemoteViews;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

public class NextPrayerAppWidget extends AppWidgetProvider {

    private static final String PREFS_NAME = "FlutterSharedPreferences";
    private static final String PRAYER_NAME_KEY = "flutter.next_prayer_name";
    private static final String PRAYER_TIME_KEY = "flutter.next_prayer_time";
    private static final String LOCATION_KEY = "flutter.current_location";
    private static final String LAST_UPDATED_KEY = "flutter.prayer_last_updated";

    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        for (int appWidgetId : appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId);
        }
    }

    static void updateAppWidget(Context context, AppWidgetManager appWidgetManager, int appWidgetId) {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        
        // Get data from SharedPreferences
        String prayerName = prefs.getString(PRAYER_NAME_KEY, "Fajr");
        String prayerTime = prefs.getString(PRAYER_TIME_KEY, "05:00");
        String location = prefs.getString(LOCATION_KEY, "Loading...");
        
        // Format current date
        SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy", Locale.getDefault());
        String currentDate = dateFormat.format(new Date());

        // Construct the RemoteViews object
        RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.next_prayer_widget);
        
        // Update widget views
        views.setTextViewText(R.id.widget_location, location);
        views.setTextViewText(R.id.widget_date, currentDate);
        views.setTextViewText(R.id.widget_next_prayer_name, prayerName);
        views.setTextViewText(R.id.widget_next_prayer_time, prayerTime);
        
        // Set prayer icon based on prayer name
        int iconResource = getPrayerIcon(context, prayerName);
        views.setImageViewResource(R.id.widget_prayer_icon, iconResource);
        
        // Calculate time remaining
        String timeRemaining = calculateTimeRemaining(prayerTime);
        views.setTextViewText(R.id.widget_time_remaining, timeRemaining);

        // Create an Intent to launch the app when widget is clicked
        Intent intent = new Intent(context, MainActivity.class);
        intent.putExtra("open_prayer_page", true);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        
        PendingIntent pendingIntent = PendingIntent.getActivity(
            context, 
            appWidgetId, 
            intent, 
            PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE
        );
        
        views.setOnClickPendingIntent(R.id.widget_container, pendingIntent);

        // Instruct the widget manager to update the widget
        appWidgetManager.updateAppWidget(appWidgetId, views);
    }

    private static int getPrayerIcon(Context context, String prayerName) {
        switch (prayerName.toLowerCase()) {
            case "fajr":
                return R.drawable.ic_fajr;
            case "dhuhr":
            case "zuhr":
                return R.drawable.ic_dhuhr;
            case "asr":
                return R.drawable.ic_asr;
            case "maghrib":
                return R.drawable.ic_maghrib;
            case "isha":
                return R.drawable.ic_isha;
            default:
                return R.drawable.ic_prayer_default;
        }
    }

    private static String calculateTimeRemaining(String prayerTime) {
        try {
            String[] parts = prayerTime.split(":");
            if (parts.length != 2) return "N/A";
            
            int prayerHour = Integer.parseInt(parts[0]);
            int prayerMinute = Integer.parseInt(parts[1]);
            
            // Get current time
            Date now = new Date();
            @SuppressWarnings("deprecation")
            int currentHour = now.getHours();
            @SuppressWarnings("deprecation")
            int currentMinute = now.getMinutes();
            
            // Calculate difference
            int totalPrayerMinutes = prayerHour * 60 + prayerMinute;
            int totalCurrentMinutes = currentHour * 60 + currentMinute;
            
            int diff = totalPrayerMinutes - totalCurrentMinutes;
            
            // If negative, it means the prayer is tomorrow
            if (diff < 0) {
                diff += 24 * 60; // Add 24 hours in minutes
            }
            
            int hoursRemaining = diff / 60;
            int minutesRemaining = diff % 60;
            
            if (hoursRemaining > 0) {
                return hoursRemaining + "h " + minutesRemaining + "m";
            } else {
                return minutesRemaining + "m";
            }
        } catch (Exception e) {
            return "N/A";
        }
    }

    @Override
    public void onEnabled(Context context) {
        // Enter relevant functionality for when the first widget is created
    }

    @Override
    public void onDisabled(Context context) {
        // Enter relevant functionality for when the last widget is disabled
    }
}