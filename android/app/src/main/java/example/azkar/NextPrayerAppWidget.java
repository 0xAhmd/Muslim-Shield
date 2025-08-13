package example.azkar;

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
import io.flutter.embedding.android.FlutterActivity;

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

        // Get package name for resources
        String packageName = context.getPackageName();
        
        // Construct the RemoteViews object
        RemoteViews views = new RemoteViews(packageName, 
            context.getResources().getIdentifier("next_prayer_widget", "layout", packageName));
        
        // Update widget views using resource identifiers
        views.setTextViewText(
            context.getResources().getIdentifier("widget_location", "id", packageName), 
            location);
        views.setTextViewText(
            context.getResources().getIdentifier("widget_date", "id", packageName), 
            currentDate);
        views.setTextViewText(
            context.getResources().getIdentifier("widget_next_prayer_name", "id", packageName), 
            prayerName);
        views.setTextViewText(
            context.getResources().getIdentifier("widget_next_prayer_time", "id", packageName), 
            prayerTime);
        
        // Set prayer icon based on prayer name
        int iconResource = getPrayerIcon(context, prayerName);
        views.setImageViewResource(
            context.getResources().getIdentifier("widget_prayer_icon", "id", packageName), 
            iconResource);
        
        // Calculate time remaining
        String timeRemaining = calculateTimeRemaining(prayerTime);
        views.setTextViewText(
            context.getResources().getIdentifier("widget_time_remaining", "id", packageName), 
            timeRemaining);

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
        
        views.setOnClickPendingIntent(
            context.getResources().getIdentifier("widget_container", "id", packageName), 
            pendingIntent);

        // Instruct the widget manager to update the widget
        appWidgetManager.updateAppWidget(appWidgetId, views);
    }

    private static int getPrayerIcon(Context context, String prayerName) {
        String packageName = context.getPackageName();
        switch (prayerName.toLowerCase()) {
            case "fajr":
                return context.getResources().getIdentifier("ic_fajr", "drawable", packageName);
            case "dhuhr":
            case "zuhr":
                return context.getResources().getIdentifier("ic_dhuhr", "drawable", packageName);
            case "asr":
                return context.getResources().getIdentifier("ic_asr", "drawable", packageName);
            case "maghrib":
                return context.getResources().getIdentifier("ic_maghrib", "drawable", packageName);
            case "isha":
                return context.getResources().getIdentifier("ic_isha", "drawable", packageName);
            default:
                return context.getResources().getIdentifier("ic_prayer_default", "drawable", packageName);
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