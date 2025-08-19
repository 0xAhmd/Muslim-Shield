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
    // Morning & Evening Duas
    {"Morning Dhikr", 
     "أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ", 
     "We have reached the morning and with it Allah's dominion. All praise is for Allah. There is no god but Allah alone, with no partner. To Him belongs the dominion, to Him belongs all praise, and He has power over everything.", 
     "Morning & Evening"},

    {"Seeking Allah's Protection", 
     "أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ، اللهُ لاَ إِلَهَ إِلاَّ هُوَ الْحَيُّ الْقَيُّومُ", 
     "I seek refuge in Allah from Satan the accursed. Allah - there is no deity except Him, the Ever-Living, the Sustainer.", 
     "Morning & Evening"},

    {"Evening Protection", 
     "أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ", 
     "We have reached the evening and with it Allah's dominion. All praise is for Allah. There is no god but Allah alone, with no partner.", 
     "Morning & Evening"},

    // Before/After Salah
    {"Before Prayer", 
     "اللَّهُمَّ بَاعِدْ بَيْنِي وَبَيْنَ خَطَايَايَ كَمَا بَاعَدْتَ بَيْنَ الْمَشْرِقِ وَالْمَغْرِبِ", 
     "O Allah, distance me from my sins as You have distanced the East from the West.", 
     "Before/After Salah"},

    {"After Salah", 
     "أَسْتَغْفِرُ اللَّهَ، أَسْتَغْفِرُ اللَّهَ، أَسْتَغْفِرُ اللَّهَ، اللَّهُمَّ أَنْتَ السَّلَامُ وَمِنْكَ السَّلَامُ", 
     "I seek Allah's forgiveness (3x). O Allah, You are Peace and from You comes peace.", 
     "Before/After Salah"},

    {"Tasbih after Prayer", 
     "سُبْحَانَ اللَّهِ وَالْحَمْدُ لِلَّهِ وَاللَّهُ أَكْبَرُ", 
     "Glory be to Allah, praise be to Allah, and Allah is the Greatest.", 
     "Before/After Salah"},

    // Daily Duas
    {"Before Eating", 
     "بِسْمِ اللَّهِ", 
     "In the name of Allah.", 
     "Daily Duas"},

    {"After Eating", 
     "الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنِي هَذَا وَرَزَقَنِيهِ مِنْ غَيْرِ حَوْلٍ مِنِّي وَلَا قُوَّةٍ", 
     "Praise be to Allah who has fed me this food and provided it for me without any effort or power from myself.", 
     "Daily Duas"},

    {"Before Sleep", 
     "بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا", 
     "In Your name, O Allah, I die and I live.", 
     "Daily Duas"},

    {"Upon Waking Up", 
     "الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ", 
     "Praise be to Allah who has brought us back to life after causing us to die, and to Him is the resurrection.", 
     "Daily Duas"},

    // Protection Duas
    {"Ayat al-Kursi", 
     "اللَّهُ لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ", 
     "Allah - there is no deity except Him, the Ever-Living, the Sustainer. Neither drowsiness overtakes Him nor sleep.", 
     "Protection Duas"},

    {"Seeking Refuge from Evil", 
     "أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ", 
     "I seek refuge in the perfect words of Allah from the evil of what He has created.", 
     "Protection Duas"},

    {"Protection from Harm", 
     "بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ", 
     "In the name of Allah, with whose name nothing in the earth or the heavens can cause harm, and He is the All-Hearing, All-Knowing.", 
     "Protection Duas"},

    // Travel Duas
    {"Before Journey", 
     "سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ وَإِنَّا إِلَى رَبِّنَا لَمُنْقَلِبُونَ", 
     "Glory be to Him who has subjected this to us, and we could never have it by our efforts. Surely, to our Lord we shall return.", 
     "Travel Duas"},

    {"During Journey", 
     "اللَّهُمَّ إِنَّا نَسْأَلُكَ فِي سَفَرِنَا هَذَا الْبِرَّ وَالتَّقْوَى وَمِنَ الْعَمَلِ مَا تَرْضَى", 
     "O Allah, we ask You in this journey of ours for righteousness, piety, and such deeds as are pleasing to You.", 
     "Travel Duas"},

    {"Safe Return", 
     "آيِبُونَ تَائِبُونَ عَابِدُونَ لِرَبِّنَا حَامِدُونَ", 
     "We return, repentant, worshipping, and praising our Lord.", 
     "Travel Duas"}
};


  @Override
public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
    System.out.println("DuaAppWidget: onUpdate called with " + appWidgetIds.length + " widgets");
    for (int appWidgetId : appWidgetIds) {
        System.out.println("DuaAppWidget: Updating widget ID: " + appWidgetId);
        updateAppWidget(context, appWidgetManager, appWidgetId);
    }
}

@Override
public void onEnabled(Context context) {
    super.onEnabled(context);
    System.out.println("DuaAppWidget: Widget enabled - first widget added");
}

@Override
public void onDisabled(Context context) {
    super.onDisabled(context);
    System.out.println("DuaAppWidget: Widget disabled - last widget removed");
}

@Override
public void onDeleted(Context context, int[] appWidgetIds) {
    super.onDeleted(context, appWidgetIds);
    for (int appWidgetId : appWidgetIds) {
        System.out.println("DuaAppWidget: Widget deleted: " + appWidgetId);
    }
}

  static void updateAppWidget(Context context, AppWidgetManager appWidgetManager, int appWidgetId) {
    try {
        System.out.println("DuaAppWidget: Starting widget update for ID: " + appWidgetId);
        
        SharedPreferences widgetData = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE);
        RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.dua_widget);
        
        // Try to get data from Flutter first
        String title = widgetData.getString("flutter.dua_title", null);
        String arabic = widgetData.getString("flutter.dua_arabic", null);
        String translation = widgetData.getString("flutter.dua_translation", null);
        String category = widgetData.getString("flutter.dua_category", null);
        
        System.out.println("DuaAppWidget: Flutter data - Title: " + title);
        
        // If Flutter data is not available, get random dua
        if (title == null || shouldAutoUpdate(widgetData)) {
            System.out.println("DuaAppWidget: Using random dua data");
            String[] randomDua = getRandomDua();
            title = randomDua[0];
            arabic = truncateArabic(randomDua[1]);
            translation = truncateTranslation(randomDua[2]);
            category = randomDua[3];
            
            // Save the new data back to SharedPreferences
            SharedPreferences.Editor editor = widgetData.edit();
            editor.putString("flutter.dua_title", title);
            editor.putString("flutter.dua_arabic", arabic);
            editor.putString("flutter.dua_translation", translation);
            editor.putString("flutter.dua_category", category);
            editor.putLong("flutter.last_auto_update", System.currentTimeMillis());
            editor.apply();
        }
        
        // Ensure we have valid data
        if (title == null) title = "Morning Dhikr";
        if (arabic == null) arabic = "أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ";
        if (translation == null) translation = "We have reached the morning";
        if (category == null) category = "Morning & Evening";
        
        // Update the widget views
        views.setTextViewText(R.id.widget_title, title);
        views.setTextViewText(R.id.widget_arabic, arabic);
        views.setTextViewText(R.id.widget_translation, translation);
        views.setTextViewText(R.id.widget_category, category);
        
        // Set click listener to open the app
        Intent intent = new Intent(context, MainActivity.class);
        intent.putExtra("route", "dua");
        intent.setAction("WIDGET_CLICK_" + appWidgetId); // Make action unique
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        
        PendingIntent pendingIntent = PendingIntent.getActivity(
            context, 
            appWidgetId, // Use unique request code
            intent, 
            PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE
        );
        
        views.setOnClickPendingIntent(R.id.widget_container, pendingIntent);
        
        appWidgetManager.updateAppWidget(appWidgetId, views);
        System.out.println("DuaAppWidget: Widget updated successfully");
        
    } catch (Exception e) {
        System.err.println("DuaAppWidget: Error updating widget: " + e.getMessage());
        e.printStackTrace();
        
        // Create a simple error widget
        RemoteViews errorViews = new RemoteViews(context.getPackageName(), R.layout.dua_widget);
        errorViews.setTextViewText(R.id.widget_title, "Error");
        errorViews.setTextViewText(R.id.widget_arabic, "خطأ");
        errorViews.setTextViewText(R.id.widget_translation, "Widget failed to load");
        errorViews.setTextViewText(R.id.widget_category, "Error");
        
        appWidgetManager.updateAppWidget(appWidgetId, errorViews);
    }
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
