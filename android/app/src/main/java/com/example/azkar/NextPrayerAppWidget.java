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
import java.util.Calendar;

public class NextPrayerAppWidget extends AppWidgetProvider {

    private static final String PREFS_NAME = "FlutterSharedPreferences";
    
    // FIXED: Updated keys to match home_widget package format (without "flutter." prefix)
    private static final String PRAYER_NAME_KEY = "next_prayer_name";
    private static final String PRAYER_TIME_KEY = "next_prayer_time";
    private static final String LOCATION_KEY = "current_location";
    private static final String LAST_UPDATED_KEY = "prayer_last_updated";

    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        for (int appWidgetId : appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId);
        }
    }

    static void updateAppWidget(Context context, AppWidgetManager appWidgetManager, int appWidgetId) {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        
        // Try to get data from home_widget (Flutter data) with CORRECT keys
        String prayerName = prefs.getString(PRAYER_NAME_KEY, null);
        String prayerTime = prefs.getString(PRAYER_TIME_KEY, null);
        String location = prefs.getString(LOCATION_KEY, null);
        
        System.out.println("NextPrayerAppWidget: Raw data from SharedPreferences:");
        System.out.println("  Prayer Name: " + prayerName);
        System.out.println("  Prayer Time: " + prayerTime);
        System.out.println("  Location: " + location);
        
        // Also check for old Flutter keys as fallback
        if (prayerName == null) {
            prayerName = prefs.getString("flutter.next_prayer_name", null);
            System.out.println("  Fallback Prayer Name: " + prayerName);
        }
        if (prayerTime == null) {
            prayerTime = prefs.getString("flutter.next_prayer_time", null);
            System.out.println("  Fallback Prayer Time: " + prayerTime);
        }
        if (location == null) {
            location = prefs.getString("flutter.current_location", null);
            System.out.println("  Fallback Location: " + location);
        }
        
        // If still no data available, use fallback values
        if (prayerName == null || prayerTime == null) {
            System.out.println("NextPrayerAppWidget: No Flutter data found, using fallback");
            prayerName = "Fajr";
            prayerTime = "05:00";
            location = "Please open Prayer Times";
        } else {
            System.out.println("NextPrayerAppWidget: Using Flutter data");
        }
        
        // Ensure we have valid location
        if (location == null || location.isEmpty()) {
            location = "Loading...";
        }

        System.out.println("NextPrayerAppWidget: Final data to display:");
        System.out.println("  Prayer Name: " + prayerName);
        System.out.println("  Prayer Time: " + prayerTime);
        System.out.println("  Location: " + location);
        
        // Format current date
        SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy", Locale.getDefault());
        String currentDate = dateFormat.format(new Date());

        // Construct the RemoteViews object
        RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.next_prayer_widget);
        
        // Update widget views
        views.setTextViewText(R.id.widget_location, location);
        views.setTextViewText(R.id.widget_date, currentDate);
        views.setTextViewText(R.id.widget_next_prayer_name, prayerName);
        
        // Format prayer time for display (convert 24h to 12h if needed)
        String displayTime = formatPrayerTimeForDisplay(prayerTime);
        views.setTextViewText(R.id.widget_next_prayer_time, displayTime);
        
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
        
        System.out.println("NextPrayerAppWidget: Widget updated successfully with: " + prayerName + " at " + displayTime);
    }

    private static String formatPrayerTimeForDisplay(String time24h) {
        try {
            System.out.println("NextPrayerAppWidget: Formatting time: " + time24h);
            
            // Parse the 24-hour format time (e.g., "05:04" or "13:13")
            String[] parts = time24h.split(":");
            if (parts.length != 2) {
                System.out.println("NextPrayerAppWidget: Invalid time format, returning as-is");
                return time24h;
            }
            
            int hour = Integer.parseInt(parts[0]);
            int minute = Integer.parseInt(parts[1]);
            
            // Convert to 12-hour format
            String amPm = (hour >= 12) ? "PM" : "AM";
            int displayHour = hour;
            
            if (hour == 0) {
                displayHour = 12; // Midnight
            } else if (hour > 12) {
                displayHour = hour - 12; // Afternoon/evening
            }
            
            String result = String.format(Locale.getDefault(), "%d:%02d %s", displayHour, minute, amPm);
            System.out.println("NextPrayerAppWidget: Formatted time result: " + result);
            return result;
            
        } catch (Exception e) {
            System.err.println("NextPrayerAppWidget: Error formatting prayer time: " + e.getMessage());
            return time24h; // Return original if parsing fails
        }
    }

    private static int getPrayerIcon(Context context, String prayerName) {
        if (prayerName == null) return R.drawable.ic_prayer_default;
        
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
            System.out.println("NextPrayerAppWidget: Calculating time remaining for: " + prayerTime);
            
            // Parse the prayer time (24-hour format: "HH:mm")
            String[] parts = prayerTime.split(":");
            if (parts.length != 2) {
                System.out.println("NextPrayerAppWidget: Invalid time format for calculation");
                return "N/A";
            }
            
            int prayerHour = Integer.parseInt(parts[0]);
            int prayerMinute = Integer.parseInt(parts[1]);
            
            // Get current time
            Calendar now = Calendar.getInstance();
            int currentHour = now.get(Calendar.HOUR_OF_DAY);
            int currentMinute = now.get(Calendar.MINUTE);
            
            System.out.println("NextPrayerAppWidget: Current time: " + currentHour + ":" + currentMinute);
            System.out.println("NextPrayerAppWidget: Prayer time: " + prayerHour + ":" + prayerMinute);
            
            // Calculate difference in minutes
            int totalPrayerMinutes = prayerHour * 60 + prayerMinute;
            int totalCurrentMinutes = currentHour * 60 + currentMinute;
            
            int diff = totalPrayerMinutes - totalCurrentMinutes;
            
            // If negative, it means the prayer is tomorrow
            if (diff <= 0) {
                diff += 24 * 60; // Add 24 hours in minutes
                System.out.println("NextPrayerAppWidget: Prayer is tomorrow, adjusted diff: " + diff);
            }
            
            int hoursRemaining = diff / 60;
            int minutesRemaining = diff % 60;
            
            System.out.println("NextPrayerAppWidget: Time remaining: " + hoursRemaining + "h " + minutesRemaining + "m");
            
            if (hoursRemaining > 0) {
                return hoursRemaining + "h " + minutesRemaining + "m";
            } else if (minutesRemaining > 0) {
                return minutesRemaining + "m";
            } else {
                return "Now";
            }
            
        } catch (Exception e) {
            System.err.println("NextPrayerAppWidget: Error calculating time remaining: " + e.getMessage());
            return "N/A";
        }
    }

    @Override
    public void onEnabled(Context context) {
        // Enter relevant functionality for when the first widget is created
        System.out.println("NextPrayerAppWidget: Widget enabled");
    }

    @Override
    public void onDisabled(Context context) {
        // Enter relevant functionality for when the last widget is disabled
        System.out.println("NextPrayerAppWidget: Widget disabled");
    }
}