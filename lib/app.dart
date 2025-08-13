import 'package:azkar/core/connectivity_service.dart';
import 'package:azkar/core/widgets/home_widget_service.dart';
import 'package:azkar/core/widgets/next_prayer_widget_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:home_widget/home_widget.dart';

import '../bookmarks/model/bookmark.dart';
import '../bookmarks/service/bookmark_service.dart';
import '../Reminders/data/services/notification_service.dart';
import '../prayer_tracker/data/models/prayer_completion.dart';
import '../prayer_tracker/data/service/prayer_tracker_service.dart';
import '../surah/audio/audio_state.dart';
import '../tasbih/data/models/tasbih.dart';

/// Handles all app initialization logic
class AppInitializer {
  static Future<void> initialize(Function(Uri?) backgroundCallback) async {
    await _initializeCore();
    await _initializeHive();
    await _initializeServices();
    await _initializeWidgets(backgroundCallback);
    await _startServices();
  }

  static Future<void> _initializeCore() async {
    await ConnectivityService().initialize();
    await dotenv.load(fileName: ".env");
  }

  static Future<void> _initializeHive() async {
    await Hive.initFlutter();

    // Register Hive adapters
    Hive.registerAdapter(BookmarkModelAdapter());
    Hive.registerAdapter(BookmarkTypeAdapter());
    Hive.registerAdapter(TasbihModelAdapter());
    Hive.registerAdapter(PrayerCompletionAdapter());
    Hive.registerAdapter(PrayerTypeAdapter());
    Hive.registerAdapter(PrayerStreakAdapter());
  }

  static Future<void> _initializeServices() async {
    await BookmarksService().init();
    await LocalAudioService().initialize();

    final notificationService = NotificationService();
    await notificationService.initialize();

    await PrayerTrackerService().initialize();
  }

  static Future<void> _initializeWidgets(
    Function(Uri?) backgroundCallback,
  ) async {
    // Initialize Widget Services
    await WidgetService.initialize();
    await NextPrayerWidgetService.initialize();

    // Set up widget callback for when widget is tapped
    HomeWidget.setAppGroupId('group.com.example.azkar.widget');
    HomeWidget.registerBackgroundCallback(backgroundCallback);
  }

  static Future<void> _startServices() async {
    try {
      // Update widgets with initial data
      await WidgetService.updateWidgetWithRandomDua();

      // Initialize Next Prayer Widget with default data
      await NextPrayerWidgetService.updateWidgetWithNextPrayer(
        nextPrayer: null,
        location: 'Please open Prayer Times',
      );

      // Start Android auto-update service for widgets
      await _startWidgetAutoUpdateService();

      debugPrint('All services started successfully');
    } catch (e) {
      debugPrint('Error starting services: $e');
    }
  }

  /// Start the Android widget auto-update service
  static Future<void> _startWidgetAutoUpdateService() async {
    try {
      const platform = MethodChannel('com.example.azkar/widget_service');
      await platform.invokeMethod('startAutoUpdates');
      debugPrint('Widget auto-update service started successfully');
    } catch (e) {
      debugPrint('Error starting widget auto-update service: $e');
    }
  }
}
