package com.example.azkar;

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.widget.RemoteViews;
import java.util.Random;

public class DuaAppWidget extends AppWidgetProvider {

    // Array of duas data - this should match your Flutter DuasData
    private static final String[][] DUAS_DATA = {
        // {title, arabic, translation, category}
        {"Morning Dhikr", "أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ", "We have reached the morning and with it Allah's dominion", "Morning & Evening"},
        {"Seeking Allah's Protection", "أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ", "I seek refuge in Allah from Satan the accursed", "Morning & Evening"},
        {"Evening Protection", "أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ", "We have reached the evening and with it Allah's dominion", "Morning & Evening"},
        {"Before Prayer", "اللَّهُمَّ بَاعِدْ بَيْنِي وَبَيْنَ خَطَايَايَ", "O Allah, distance me from my sins", "Before/After Salah"},
        {"After Salah", "أَسْتَغْفِرُ اللَّهَ، أَسْتَغْفِرُ اللَّهَ", "I seek Allah's forgiveness", "Before/After Salah"},
        {"Tasbih after Prayer", "سُبْحَانَ اللَّهِ وَالْحَمْدُ لِلَّهِ", "Glory be to Allah, praise be to Allah", "Before/After Salah"},
        {"Before Eating", "بِسْمِ اللَّهِ", "In the name of Allah", "Daily Duas"},
        {"After Eating", "الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنِي هَذَا", "Praise be to Allah who has fed me this food", "Daily Duas"},
        {"Before Sleep", "بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا", "In Your name, O Allah, I die and I live", "Daily Duas"},
        {"Upon Waking Up", "الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا", "Praise be to Allah who has brought us back to life", "Daily Duas"},
        {"Ayat al-Kursi", "اللَّهُ لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ", "Allah - there is no deity except Him", "Protection Duas"},
        {"Seeking Refuge from Evil", "أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ", "I seek refuge in the perfect words of Allah", "Protection Duas"},
        {"Protection from Harm", "بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ", "In the name of Allah, with whose name nothing can cause harm", "Protection Duas"},
        {"Before Journey", "سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا", "Glory be to Him who has subjected this to us", "Travel Duas"},
        {"During Journey", "اللَّهُمَّ إِنَّا نَسْأَلُكَ فِي سَفَرِنَا", "O Allah, we ask You in this journey", "Travel Duas"},
        {"Safe Return", "آيِبُونَ تَائِبُونَ عَابِدُونَ", "We return, repentant, worshipping", "Travel Duas"}
    };

    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        // Update each widget instance
        for (int appWidgetId : appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId);
        }
    }

    @Override
    public void onEnabled(Context context) {
        // Enter relevant functionality for when the first widget is created
        super.onEnabled(context);
    }

    @Override
    public void onDisabled(Context context) {
        // Enter relevant functionality for when the last widget is disabled  
        super.onDisabled(context);
    }

    static void updateAppWidget(Context context, AppWidgetManager appWidgetManager, int appWidgetId) {
        // Get SharedPreferences using the same key as Flutter
        SharedPreferences widgetData = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE);
        
        RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.dua_widget);
        
        // Try to get data from Flutter first
        String title = widgetData.getString("flutter.dua_title", null);
        String arabic = widgetData.getString("flutter.dua_arabic", null);
        String translation = widgetData.getString("flutter.dua_translation", null);
        String category = widgetData.getString("flutter.dua_category", null);
        
        // If Flutter data is not available or widget needs auto-update, get random dua
        if (title == null || shouldAutoUpdate(widgetData)) {
            String[] randomDua = getRandomDua();
            title = randomDua[0];
            arabic = truncateArabic(randomDua[1]);
            translation = truncateTranslation(randomDua[2]);
            category = randomDua[3];
            
            // Save the new data back to SharedPreferences for Flutter to see
            SharedPreferences.Editor editor = widgetData.edit();
            editor.putString("flutter.dua_title", title);
            editor.putString("flutter.dua_arabic", arabic);
            editor.putString("flutter.dua_translation", translation);
            editor.putString("flutter.dua_category", category);
            editor.putLong("flutter.last_auto_update", System.currentTimeMillis());
            editor.apply();
        }
        
        // Update the widget views
        views.setTextViewText(R.id.widget_title, title);
        views.setTextViewText(R.id.widget_arabic, arabic);
        views.setTextViewText(R.id.widget_translation, translation);
        views.setTextViewText(R.id.widget_category, category);
        
        // Set click listener to open the app
        Intent intent = new Intent(context, MainActivity.class);
        intent.putExtra("route", "dua");
        intent.setAction("WIDGET_CLICK");
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        
        PendingIntent pendingIntent = PendingIntent.getActivity(
            context, 
            appWidgetId,
            intent, 
            PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE
        );
        
        // Set click listener on the entire widget
        views.setOnClickPendingIntent(R.id.widget_container, pendingIntent);
        
        appWidgetManager.updateAppWidget(appWidgetId, views);
    }

    private static boolean shouldAutoUpdate(SharedPreferences prefs) {
        long lastUpdate = prefs.getLong("flutter.last_auto_update", 0);
        long currentTime = System.currentTimeMillis();
        long tenMinutesInMillis = 10 * 60 * 1000; // 10 minutes
        
        return (currentTime - lastUpdate) >= tenMinutesInMillis;
    }

    private static String[] getRandomDua() {
        Random random = new Random();
        int index = random.nextInt(DUAS_DATA.length);
        return DUAS_DATA[index];
    }

    private static String truncateArabic(String text) {
        final int maxLength = 60;
        if (text.length() <= maxLength) return text;
        
        int cutoff = maxLength;
        while (cutoff > 0 && text.charAt(cutoff) != ' ') {
            cutoff--;
        }
        
        if (cutoff == 0) cutoff = maxLength;
        return text.substring(0, cutoff) + "...";
    }

    private static String truncateTranslation(String text) {
        final int maxLength = 80;
        if (text.length() <= maxLength) return text;
        
        int cutoff = maxLength;
        while (cutoff > 0 && text.charAt(cutoff) != ' ') {
            cutoff--;
        }
        
        if (cutoff == 0) cutoff = maxLength;
        return text.substring(0, cutoff) + "...";
    }
}