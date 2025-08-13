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
    } catch (e) {
      print('Error initializing next prayer widget service: $e');
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
        // Set default values if no prayer data
        await _setDefaultWidgetData();
      } else {
        // Save next prayer data for the widget to access
        await HomeWidget.saveWidgetData<String>('next_prayer_name', nextPrayer.name);
        await HomeWidget.saveWidgetData<String>('next_prayer_time', nextPrayer.time);
        await HomeWidget.saveWidgetData<String>('current_location', _truncateLocation(location));
        await HomeWidget.saveWidgetData<String>('prayer_last_updated', lastUpdated ?? DateTime.now().toIso8601String());
      }

      // Update the actual widget
      await HomeWidget.updateWidget(
        iOSName: iOSWidgetName,
        androidName: androidWidgetName,
      );
      
      print('Next Prayer Widget updated successfully with: ${nextPrayer?.name ?? "Default"} at ${nextPrayer?.time ?? "00:00"}');
    } catch (e) {
      print('Error updating next prayer widget: $e');
    }
  }

  /// Update widget with prayer times list for better next prayer calculation
  static Future<void> updateWidgetWithPrayerTimes({
    required List<PrayerInfo> prayers,
    required String location,
    String? lastUpdated,
  }) async {
    try {
      // Find the next prayer
      final nextPrayer = _findNextPrayer(prayers);
      
      // Update widget with next prayer data
      await updateWidgetWithNextPrayer(
        nextPrayer: nextPrayer,
        location: location,
        lastUpdated: lastUpdated,
      );
    } catch (e) {
      print('Error updating widget with prayer times: $e');
    }
  }

  /// Find the next prayer from the prayer times list
  static PrayerInfo? _findNextPrayer(List<PrayerInfo> prayers) {
    if (prayers.isEmpty) return null;

    final now = DateTime.now();
    final currentTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    // Find the next prayer that hasn't passed yet today
    for (final prayer in prayers) {
      if (_isTimeAfter(prayer.time, currentTime)) {
        return prayer;
      }
    }

    // If all prayers have passed today, return the first prayer (Fajr) for tomorrow
    return prayers.isNotEmpty ? prayers.first : null;
  }

  /// Check if time1 is after time2 (format: "HH:mm")
  static bool _isTimeAfter(String time1, String time2) {
    try {
      final time1Parts = time1.split(':');
      final time2Parts = time2.split(':');
      
      if (time1Parts.length != 2 || time2Parts.length != 2) return false;
      
      final time1Hour = int.parse(time1Parts[0]);
      final time1Minute = int.parse(time1Parts[1]);
      final time2Hour = int.parse(time2Parts[0]);
      final time2Minute = int.parse(time2Parts[1]);
      
      if (time1Hour > time2Hour) return true;
      if (time1Hour == time2Hour && time1Minute > time2Minute) return true;
      
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Set default widget data when no prayer information is available
  static Future<void> _setDefaultWidgetData() async {
    await HomeWidget.saveWidgetData<String>('next_prayer_name', 'Fajr');
    await HomeWidget.saveWidgetData<String>('next_prayer_time', '05:00');
    await HomeWidget.saveWidgetData<String>('current_location', 'Loading...');
    await HomeWidget.saveWidgetData<String>('prayer_last_updated', DateTime.now().toIso8601String());
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
    print('Next Prayer Widget tapped - opening app to prayer page');
  }

  /// Schedule periodic updates (called every minute for accurate countdown)
  static Future<void> schedulePeriodicUpdates() async {
    // You can implement periodic updates here
    // For example, update every minute to keep countdown accurate
    print('Scheduling periodic updates for Next Prayer Widget');
  }

  /// Update widget when app comes to foreground
  static Future<void> updateOnAppResume() async {
    try {
      // Re-fetch current prayer data and update widget
      print('App resumed - updating Next Prayer Widget');
      // This should be called from your prayer cubit/bloc when app resumes
    } catch (e) {
      print('Error updating widget on app resume: $e');
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
      print('Next Prayer Widget data cleared');
    } catch (e) {
      print('Error clearing Next Prayer Widget data: $e');
    }
  }
}