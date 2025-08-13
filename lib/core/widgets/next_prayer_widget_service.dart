import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import '../../prayer/data/models/prayer_location.dart';

class NextPrayerWidgetService {
  static const String appGroupId = 'group.com.example.azkar.widget';
  static const String iOSWidgetName = 'NextPrayerWidget';
  static const String androidWidgetName = 'NextPrayerAppWidget';

  /// Initialize the widget service
  static Future<void> initialize() async {
    try {
      // Set app group for iOS (required for data sharing)
      await HomeWidget.setAppGroupId(appGroupId);
      debugPrint('NextPrayerWidgetService: Initialized successfully');
    } catch (e) {
      debugPrint('Error initializing next prayer widget service: $e');
    }
  }

  /// Update widget with next prayer information
  static Future<void> updateWidgetWithNextPrayer({
    required PrayerInfo? nextPrayer,
    required String location,
    String? lastUpdated,
  }) async {
    try {
      if (nextPrayer == null) {
        debugPrint('NextPrayerWidgetService: No prayer data - setting default values');
        // Set default values if no prayer data
        await _setDefaultWidgetData();
      } else {
        debugPrint('NextPrayerWidgetService: Updating widget with ${nextPrayer.name} at ${nextPrayer.time}');
        
        // Save next prayer data for the widget to access
        await HomeWidget.saveWidgetData<String>(
          'next_prayer_name',
          nextPrayer.name,
        );
        await HomeWidget.saveWidgetData<String>(
          'next_prayer_time',
          nextPrayer.time,
        );
        await HomeWidget.saveWidgetData<String>(
          'current_location',
          _truncateLocation(location),
        );
        await HomeWidget.saveWidgetData<String>(
          'prayer_last_updated',
          lastUpdated ?? DateTime.now().toIso8601String(),
        );
      }

      // Update the actual widget
      await HomeWidget.updateWidget(
        iOSName: iOSWidgetName,
        androidName: androidWidgetName,
      );

      debugPrint(
        'NextPrayerWidgetService: Widget updated successfully with: ${nextPrayer?.name ?? "Default"} at ${nextPrayer?.time ?? "00:00"}',
      );
    } catch (e) {
      debugPrint('NextPrayerWidgetService: Error updating next prayer widget: $e');
      rethrow;
    }
  }

  /// Update widget with prayer times list for better next prayer calculation
  static Future<void> updateWidgetWithPrayerTimes({
    required List<PrayerInfo> prayers,
    required String location,
    String? lastUpdated,
  }) async {
    try {
      debugPrint('NextPrayerWidgetService: Received ${prayers.length} prayers for processing');
      
      // Log all received prayers for debugging
      for (int i = 0; i < prayers.length; i++) {
        debugPrint('NextPrayerWidgetService: Prayer $i: ${prayers[i].name} at ${prayers[i].time}');
      }
      
      // Find the next prayer using improved logic
      final nextPrayer = _findNextPrayerImproved(prayers);
      
      debugPrint('NextPrayerWidgetService: Determined next prayer: ${nextPrayer?.name} at ${nextPrayer?.time}');

      // Update widget with next prayer data
      await updateWidgetWithNextPrayer(
        nextPrayer: nextPrayer,
        location: location,
        lastUpdated: lastUpdated,
      );
    } catch (e) {
      debugPrint('NextPrayerWidgetService: Error updating widget with prayer times: $e');
      rethrow;
    }
  }

  /// Improved logic to find the next prayer from the prayer times list
  static PrayerInfo? _findNextPrayerImproved(List<PrayerInfo> prayers) {
    if (prayers.isEmpty) {
      debugPrint('NextPrayerWidgetService: No prayers provided');
      return null;
    }

    final now = DateTime.now();
    final currentTimeString = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    
    debugPrint('NextPrayerWidgetService: Current time: $currentTimeString');

    // Convert prayer times to comparable format and sort them
    List<MapEntry<PrayerInfo, int>> prayerTimes = prayers.map((prayer) {
      final timeInMinutes = _timeStringToMinutes(prayer.time);
      debugPrint('NextPrayerWidgetService: ${prayer.name} -> ${prayer.time} -> $timeInMinutes minutes');
      return MapEntry(prayer, timeInMinutes);
    }).toList();

    // Sort by time
    prayerTimes.sort((a, b) => a.value.compareTo(b.value));

    final currentTimeInMinutes = _timeStringToMinutes(currentTimeString);
    debugPrint('NextPrayerWidgetService: Current time in minutes: $currentTimeInMinutes');

    // Find the next prayer that hasn't passed yet today
    for (final entry in prayerTimes) {
      if (entry.value > currentTimeInMinutes) {
        debugPrint('NextPrayerWidgetService: Found next prayer: ${entry.key.name} at ${entry.key.time}');
        return entry.key;
      }
    }

    // If all prayers have passed today, return the first prayer (Fajr) for tomorrow
    final firstPrayer = prayerTimes.isNotEmpty ? prayerTimes.first.key : null;
    debugPrint('NextPrayerWidgetService: All prayers passed, next is tomorrow: ${firstPrayer?.name}');
    return firstPrayer;
  }

  /// Convert time string (HH:mm) to minutes since midnight
  static int _timeStringToMinutes(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length != 2) return 0;
      
      final hours = int.parse(parts[0]);
      final minutes = int.parse(parts[1]);
      
      return hours * 60 + minutes;
    } catch (e) {
      debugPrint('NextPrayerWidgetService: Error converting time string "$timeString": $e');
      return 0;
    }
  }


  /// Set default widget data when no prayer information is available
  static Future<void> _setDefaultWidgetData() async {
    debugPrint('NextPrayerWidgetService: Setting default widget data');
    await HomeWidget.saveWidgetData<String>('next_prayer_name', 'Fajr');
    await HomeWidget.saveWidgetData<String>('next_prayer_time', '05:00');
    await HomeWidget.saveWidgetData<String>('current_location', 'Please open Prayer Times');
    await HomeWidget.saveWidgetData<String>(
      'prayer_last_updated',
      DateTime.now().toIso8601String(),
    );
  }

  /// Truncate location text for widget display
  static String _truncateLocation(String location) {
    const maxLength = 25;
    if (location.length <= maxLength) return location;

    int cutoff = maxLength;
    while (cutoff > 0 && location[cutoff] != ' ' && location[cutoff] != ',') {
      cutoff--;
    }

    if (cutoff == 0) cutoff = maxLength;
    return '${location.substring(0, cutoff)}...';
  }

  /// Handle widget tap (when user taps the widget)
  static Future<void> handleWidgetTap() async {
    // This will be called when the widget is tapped
    // The native code will handle opening the app to prayer page
    debugPrint('NextPrayerWidgetService: Widget tapped - opening app to prayer page');
  }

  /// Schedule periodic updates (called every minute for accurate countdown)
  static Future<void> schedulePeriodicUpdates() async {
    // You can implement periodic updates here
    // For example, update every minute to keep countdown accurate
    debugPrint('NextPrayerWidgetService: Scheduling periodic updates');
  }

  /// Update widget when app comes to foreground
  static Future<void> updateOnAppResume() async {
    try {
      // Re-fetch current prayer data and update widget
      debugPrint('NextPrayerWidgetService: App resumed - updating widget');
      // This should be called from your prayer cubit/bloc when app resumes
    } catch (e) {
      debugPrint('NextPrayerWidgetService: Error updating widget on app resume: $e');
    }
  }

  /// Clear widget data (useful when signing out or clearing data)
  static Future<void> clearWidgetData() async {
    try {
      await _setDefaultWidgetData();
      await HomeWidget.updateWidget(
        iOSName: iOSWidgetName,
        androidName: androidWidgetName,
      );
      debugPrint('NextPrayerWidgetService: Widget data cleared');
    } catch (e) {
      debugPrint('NextPrayerWidgetService: Error clearing widget data: $e');
    }
  }
}