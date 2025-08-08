import 'dart:convert';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class AdhanService {
  static final AdhanService _instance = AdhanService._internal();
  factory AdhanService() => _instance;
  AdhanService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  late AudioPlayer _audioPlayer;

  bool _isInitialized = false;
  static const String _channelId = 'adhan_notifications';
  static const String _channelName = 'Adhan Notifications';
  static const String _adhanEnabledKey = 'adhan_notifications_enabled';

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      tz.initializeTimeZones();

      // Initialize AudioPlayer with proper configuration
      _audioPlayer = AudioPlayer();
      await _audioPlayer.setPlayerMode(PlayerMode.mediaPlayer);

      await _initializeNotifications();
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing AdhanService: $e');
      // Don't mark as initialized if there was an error
      // This allows retry later
    }
  }

  Future<void> _initializeNotifications() async {
    try {
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          );

      const InitializationSettings settings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notifications.initialize(
        settings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Create notification channel with sound
      await _createNotificationChannel();

      // Delay permission request to ensure context is ready
      await Future.delayed(const Duration(seconds: 1));
      await _requestPermissions();
    } catch (e) {
      debugPrint('Error initializing notifications: $e');
      rethrow; // Let the caller handle the error
    }
  }

  Future<void> _createNotificationChannel() async {
    final AndroidNotificationChannel channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: 'Adhan call for prayer times',
      importance: Importance.max,
      playSound: true,
      sound: const RawResourceAndroidNotificationSound(
        'adhan',
      ), // Reference to adhan.mp3 in res/raw/
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  Future<void> _requestPermissions() async {
    try {
      // Add delay to ensure context is available
      await Future.delayed(const Duration(milliseconds: 500));

      final androidImplementation = _notifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      if (androidImplementation != null) {
        await androidImplementation.requestNotificationsPermission();
        await androidImplementation.requestExactAlarmsPermission();
      }

      await _notifications
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } catch (e) {
      debugPrint('Error requesting notification permissions: $e');
      // Don't throw error, just log it - permissions can be requested later
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Adhan notification tapped: ${response.payload}');

    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!);
        final prayerName = data['prayer'] as String;

        // Play sound when notification is tapped
        Future.delayed(const Duration(milliseconds: 500), () {
          _playAdhanSound(prayerName);
        });
      } catch (e) {
        debugPrint('Error parsing notification payload: $e');
      }
    }
  }

  Future<void> _playAdhanSound(String prayerName) async {
    try {
      // Stop any currently playing audio
      await _audioPlayer.stop();

      // Set volume to maximum
      await _audioPlayer.setVolume(1.0);

      // Play the Adhan audio from assets
      await _audioPlayer.play(AssetSource('audio/adhan.mp3'));

      debugPrint('Playing Adhan for $prayerName prayer');

      // Listen for completion
      _audioPlayer.onPlayerComplete.listen((event) {
        debugPrint('Adhan playback completed for $prayerName');
      });

      // Listen for errors
      _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
        debugPrint('Audio player state changed: $state');
      });
    } catch (e) {
      debugPrint('Error playing Adhan sound: $e');
      // Try alternative approach if asset fails
      try {
        debugPrint('Attempting to play system notification sound as fallback');
        // This will trigger the system default notification sound
        await _showSoundNotification(prayerName);
      } catch (fallbackError) {
        debugPrint('Fallback sound also failed: $fallbackError');
      }
    }
  }

  Future<void> _showSoundNotification(String prayerName) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'adhan_sound_fallback',
          'Adhan Sound',
          channelDescription: 'Adhan sound notification',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          sound: RawResourceAndroidNotificationSound(
            'notification',
          ), // Default system sound
          enableVibration: true,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      9998,
      'Adhan - $prayerName',
      'اللَّهُ أَكْبَرُ - Allah is Greatest',
      details,
    );
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  Future<void> scheduleAdhanNotifications({
    required String fajrTime,
    required String dhuhrTime,
    required String asrTime,
    required String maghribTime,
    required String ishaTime,
  }) async {
    try {
      await _ensureInitialized();

      if (!await isAdhanEnabled()) {
        debugPrint('Adhan notifications are disabled');
        return;
      }

      // Cancel existing notifications
      await cancelAllAdhanNotifications();

      final prayers = [
        {'name': 'Fajr', 'time': fajrTime, 'id': 1001},
        {'name': 'Dhuhr', 'time': dhuhrTime, 'id': 1002},
        {'name': 'Asr', 'time': asrTime, 'id': 1003},
        {'name': 'Maghrib', 'time': maghribTime, 'id': 1004},
        {'name': 'Isha', 'time': ishaTime, 'id': 1005},
      ];

      for (final prayer in prayers) {
        await _scheduleAdhanForPrayer(
          id: prayer['id'] as int,
          prayerName: prayer['name'] as String,
          prayerTime: prayer['time'] as String,
        );
      }

      debugPrint('Scheduled Adhan notifications for all prayers');
    } catch (e) {
      debugPrint('Error scheduling Adhan notifications: $e');
    }
  }

  Future<void> _scheduleAdhanForPrayer({
    required int id,
    required String prayerName,
    required String prayerTime,
  }) async {
    try {
      final scheduledTime = _parseTimeToToday(prayerTime);

      // If the prayer time has already passed today, schedule for tomorrow
      final now = DateTime.now();
      DateTime finalScheduledTime = scheduledTime;

      if (scheduledTime.isBefore(now)) {
        finalScheduledTime = scheduledTime.add(const Duration(days: 1));
      }

      final AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: 'Adhan call for prayer times',
            importance: Importance.max,
            priority: Priority.high,
            fullScreenIntent: true,
            category: AndroidNotificationCategory.alarm,
            visibility: NotificationVisibility.public,
            playSound: true, // Enable sound in notification
            sound: const RawResourceAndroidNotificationSound(
              'adhan',
            ), // Custom sound
            enableVibration: true,
            vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
            autoCancel: false, // Keep notification visible
            ongoing: false,
            timeoutAfter: 30000, // 30 seconds timeout
          );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'adhan.mp3', // Custom sound file in iOS bundle
        interruptionLevel: InterruptionLevel.critical,
      );

      final NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      final payload = jsonEncode({
        'prayer': prayerName,
        'time': prayerTime,
        'type': 'adhan',
        'action': 'play_sound',
      });

      await _notifications.zonedSchedule(
        id,
        'Time for $prayerName Prayer',
        'اللَّهُ أَكْبَرُ - Allah is Greatest',
        tz.TZDateTime.from(finalScheduledTime, tz.local),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );

      // Schedule recurring daily notifications
      for (int day = 1; day <= 7; day++) {
        await _notifications.zonedSchedule(
          id + (day * 10), // Different ID for each day
          'Time for $prayerName Prayer',
          'اللَّهُ أَكْبَرُ - Allah is Greatest',
          tz.TZDateTime.from(
            finalScheduledTime.add(Duration(days: day)),
            tz.local,
          ),
          details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: payload,
        );
      }

      debugPrint('Scheduled Adhan for $prayerName at $finalScheduledTime');
    } catch (e) {
      debugPrint('Error scheduling Adhan for $prayerName: $e');
    }
  }

  DateTime _parseTimeToToday(String timeString) {
    try {
      // Remove timezone info if present (e.g., "05:30 (+03)")
      final cleanTime = timeString.split(' ')[0];
      final parts = cleanTime.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day, hour, minute);
    } catch (e) {
      debugPrint('Error parsing time $timeString: $e');
      return DateTime.now();
    }
  }

  Future<void> cancelAllAdhanNotifications() async {
    // Cancel all Adhan notification IDs (1001-1005 and their daily repeats)
    for (int i = 1001; i <= 1005; i++) {
      await _notifications.cancel(i);
      // Cancel daily repeats
      for (int day = 1; day <= 7; day++) {
        await _notifications.cancel(i + (day * 10));
      }
    }
    debugPrint('Cancelled all Adhan notifications');
  }

  Future<void> enableAdhanNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_adhanEnabledKey, true);
  }

  Future<void> disableAdhanNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_adhanEnabledKey, false);
    await cancelAllAdhanNotifications();
  }

  Future<bool> isAdhanEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_adhanEnabledKey) ?? false;
  }

  Future<void> testAdhanNotification() async {
    await _ensureInitialized();

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: 'Test Adhan notification',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('adhan'),
          enableVibration: true,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'adhan.mp3',
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final payload = jsonEncode({
      'prayer': 'Test',
      'time': DateTime.now().toString(),
      'type': 'adhan',
      'action': 'play_sound',
    });

    await _notifications.show(
      9999,
      'Test Adhan Call',
      'This is a test Adhan notification - Tap to play sound',
      details,
      payload: payload,
    );

    // Also play sound immediately for test
    await Future.delayed(const Duration(milliseconds: 1000));
    await _playAdhanSound('Test');
  }

  // Method to play Adhan sound directly (useful for manual testing)
  Future<void> playAdhanSoundDirectly() async {
    await _ensureInitialized();
    await _playAdhanSound('Manual Test');
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
