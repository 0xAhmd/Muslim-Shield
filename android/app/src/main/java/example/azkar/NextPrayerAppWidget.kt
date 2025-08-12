// File: android/app/src/main/java/com/example/azkar/NextPrayerAppWidget.kt
package com.example.azkar

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import java.text.SimpleDateFormat
import java.util.*

class NextPrayerAppWidget : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }

    companion object {
        fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            // Get shared preferences to read prayer data
            val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            
            // Read prayer data
            val nextPrayerName = prefs.getString("flutter.next_prayer_name", "Fajr") ?: "Fajr"
            val nextPrayerTime = prefs.getString("flutter.next_prayer_time", "05:00") ?: "05:00"
            val currentLocation = prefs.getString("flutter.current_location", "Loading...") ?: "Loading..."
            val lastUpdated = prefs.getString("flutter.prayer_last_updated", "") ?: ""
            
            // Calculate time remaining
            val timeRemaining = calculateTimeRemaining(nextPrayerTime)
            
            // Get current date
            val currentDate = SimpleDateFormat("MMM dd, yyyy", Locale.getDefault()).format(Date())
            
            // Construct the RemoteViews object
            val views = RemoteViews(context.packageName, R.layout.next_prayer_widget)
            
            // Update widget content
            views.setTextViewText(R.id.widget_next_prayer_name, nextPrayerName)
            views.setTextViewText(R.id.widget_next_prayer_time, nextPrayerTime)
            views.setTextViewText(R.id.widget_time_remaining, timeRemaining)
            views.setTextViewText(R.id.widget_location, currentLocation)
            views.setTextViewText(R.id.widget_date, currentDate)
            
            // Set prayer icon based on prayer name
            val prayerIconRes = when (nextPrayerName.lowercase()) {
                "fajr" -> R.drawable.ic_fajr
                "dhuhr" -> R.drawable.ic_dhuhr
                "asr" -> R.drawable.ic_asr
                "maghrib" -> R.drawable.ic_maghrib
                "isha" -> R.drawable.ic_isha
                else -> R.drawable.ic_prayer_default
            }
            views.setImageViewResource(R.id.widget_prayer_icon, prayerIconRes)
            
            // Create intent to open app when widget is clicked
            val intent = Intent(context, MainActivity::class.java)
            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
            intent.putExtra("open_prayer_page", true)
            
            val pendingIntent = PendingIntent.getActivity(
                context, 
                appWidgetId, 
                intent, 
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_container, pendingIntent)
            
            // Update the widget
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
        
        private fun calculateTimeRemaining(prayerTime: String): String {
            return try {
                val currentTime = Calendar.getInstance()
                val prayerCalendar = Calendar.getInstance()
                
                val timeParts = prayerTime.split(":")
                if (timeParts.size >= 2) {
                    prayerCalendar.set(Calendar.HOUR_OF_DAY, timeParts[0].toInt())
                    prayerCalendar.set(Calendar.MINUTE, timeParts[1].toInt())
                    prayerCalendar.set(Calendar.SECOND, 0)
                    
                    // If prayer time has passed today, set it for tomorrow
                    if (prayerCalendar.before(currentTime)) {
                        prayerCalendar.add(Calendar.DAY_OF_MONTH, 1)
                    }
                    
                    val diffInMillis = prayerCalendar.timeInMillis - currentTime.timeInMillis
                    val hours = (diffInMillis / (1000 * 60 * 60)).toInt()
                    val minutes = ((diffInMillis / (1000 * 60)) % 60).toInt()
                    
                    when {
                        hours > 0 -> "${hours}h ${minutes}m"
                        minutes > 0 -> "${minutes}m"
                        else -> "Now"
                    }
                } else {
                    "Invalid time"
                }
            } catch (e: Exception) {
                "Error"
            }
        }
    }
}