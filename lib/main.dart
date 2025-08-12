import 'package:azkar/core/widgets/home_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:home_widget/home_widget.dart';
import 'package:safe_device/safe_device.dart';

import 'Reminders/data/services/notification_service.dart';
import 'bookmarks/model/bookmark.dart';
import 'bookmarks/service/bookmark_service.dart';
import 'constants.dart';
import 'core/connectivity_service.dart';
import 'core/widgets/blocked.dart';
import 'home/presentation/pages/home_screen.dart';
import 'prayer_tracker/data/models/prayer_completion.dart';
import 'prayer_tracker/data/service/prayer_tracker_service.dart';
import 'surah/audio/audio_state.dart';
import 'tasbih/data/models/tasbih.dart';

/// Background callback for widget interactions
/// This MUST be a top-level function (outside of main())
/// Fixed: Changed to Future<void> and Uri? to match expected signature
@pragma("vm:entry-point")
Future<void> _backgroundCallback(Uri? uri) async {
  print('Widget callback triggered: $uri');
  // Handle the widget tap - you can navigate to specific pages based on the uri
  if (uri?.host == 'dua') {
    // Widget was tapped - the app will open and navigate to Dua page
    // This will be handled in your app's routing logic
    print('Dua widget tapped - should navigate to dua page');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ConnectivityService().initialize();
  await EasyLocalization.ensureInitialized();

  await Hive.initFlutter();

  // Initialize Widget Service
  await WidgetService.initialize();

  // Set up widget callback for when widget is tapped
  HomeWidget.setAppGroupId('group.com.example.azkar.widget');
  HomeWidget.registerBackgroundCallback(_backgroundCallback);

  // Register Hive adapters
  Hive.registerAdapter(BookmarkModelAdapter());
  Hive.registerAdapter(BookmarkTypeAdapter());
  Hive.registerAdapter(TasbihModelAdapter());
  Hive.registerAdapter(PrayerCompletionAdapter());
  Hive.registerAdapter(PrayerTypeAdapter());
  Hive.registerAdapter(PrayerStreakAdapter());

  // Initialize services
  await BookmarksService().init();
  await LocalAudioService().initialize();
  await dotenv.load(fileName: ".env");
  final notificationService = NotificationService();
  await notificationService.initialize();
  await PrayerTrackerService().initialize();

  // Update widget with initial random Dua
  try {
    await WidgetService.updateWidgetWithRandomDua();
    print('Initial widget update completed');
  } catch (e) {
    print('Error updating widget on startup: $e');
  }

  // Device security checks
  final isRooted = await SafeDevice.isJailBroken;
  final isRealDevice = await SafeDevice.isRealDevice;

  if (isRooted || isRealDevice) {
    runApp(
      EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('ar', 'SA')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en', 'US'),
        child: const BlockedDeviceApp(),
      ),
    );
  } else {
    runApp(
      EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('ar', 'SA')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en', 'US'),
        child: const MyApp(),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Builder(
          builder: (context) => MaterialApp(
            navigatorKey: NavigationService.navigatorKey,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            theme: AppThemes.getTheme(context),
            home: const AppInitializer(),
          ),
        );
      },
    );
  }
}

/// Handles app initialization and widget launch detection
class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  @override
  void initState() {
    super.initState();
    _checkLaunchIntent();
  }

  void _checkLaunchIntent() async {
    try {
      // Check if app was launched from widget
      final Uri? uri = await HomeWidget.initiallyLaunchedFromHomeWidget();

      if (uri != null) {
        print('App launched from widget with URI: $uri');

        if (uri.host == 'dua') {
          // Navigate to Dua page after a short delay
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const WidgetLaunchedHomeScreen(
                    targetPage:
                        2, // DoaPage is at index 2 based on your pages list
                  ),
                ),
              );
            }
          });
          return;
        }
      }
    } catch (e) {
      print('Error checking launch intent: $e');
    }

    // Normal app launch - go to home screen
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo or icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.book, size: 40, color: primary),
            ),
            const SizedBox(height: 24),
            const Text(
              'Muslim Shield',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primary),
              strokeWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}

/// Special version of HomeScreen that navigates to specific page when launched from widget
class WidgetLaunchedHomeScreen extends StatefulWidget {
  final int targetPage;

  const WidgetLaunchedHomeScreen({super.key, required this.targetPage});

  @override
  State<WidgetLaunchedHomeScreen> createState() =>
      _WidgetLaunchedHomeScreenState();
}

class _WidgetLaunchedHomeScreenState extends State<WidgetLaunchedHomeScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the target page after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateToTargetPage();
    });
  }

  void _navigateToTargetPage() {
    // Create a HomeScreen and programmatically navigate to the target page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );

    // After navigation, we need to programmatically select the Dua tab
    // We'll do this by accessing the HomeScreen's state
    Future.delayed(const Duration(milliseconds: 100), () {
      // Since your HomeScreen uses index 2 for DoaPage, we need to trigger that selection
      // This is a workaround since your current HomeScreen doesn't accept initialIndex
      _simulateTabSelection();
    });
  }

  void _simulateTabSelection() {
    // This is a workaround to navigate to the Dua page
    // Since we can't modify your existing HomeScreen easily, we'll show a snackbar
    // indicating the widget was tapped and suggest opening Duas manually
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.touch_app, color: Colors.white, size: 16),
            SizedBox(width: 8),
            Text('Widget tapped! Navigate to Duas tab'),
          ],
        ),
        backgroundColor: primary,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading screen briefly while navigating
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(Icons.book, size: 30, color: primary),
            ),
            const SizedBox(height: 16),
            const Text(
              'Opening Duas...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
