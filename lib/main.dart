import 'package:azkar/core/widgets/home_widget_service.dart';
import 'package:azkar/core/widgets/next_prayer_widget_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
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
@pragma("vm:entry-point")
Future<void> _backgroundCallback(Uri? uri) async {
  print('Widget callback triggered: $uri');
  
  // Handle different widget types
  if (uri?.host == 'dua') {
    print('Dua widget tapped - should navigate to dua page');
  } else if (uri?.host == 'prayer' || uri?.queryParameters['open_prayer_page'] == 'true') {
    print('Next Prayer widget tapped - should navigate to prayer page');
  }
}

void main() async {
  // Preserve the native splash screen
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await ConnectivityService().initialize();
  await EasyLocalization.ensureInitialized();

  await Hive.initFlutter();

  // Initialize Widget Services
  await WidgetService.initialize();
  await NextPrayerWidgetService.initialize();

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

  // Update widgets with initial data
  try {
    await WidgetService.updateWidgetWithRandomDua();
    // Initialize Next Prayer Widget with default data
    await NextPrayerWidgetService.updateWidgetWithNextPrayer(
      nextPrayer: null,
      location: 'Please open Prayer Times',
    );
    
    // Start Android auto-update service for widgets
    await _startWidgetAutoUpdateService();
    
    print('Initial widgets update completed and auto-update service started');
  } catch (e) {
    print('Error updating widgets on startup: $e');
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

/// Start the Android widget auto-update service
Future<void> _startWidgetAutoUpdateService() async {
  try {
    // This will call the Android native method to start the auto-update service
    const platform = MethodChannel('com.example.azkar/widget_service');
    await platform.invokeMethod('startAutoUpdates');
    print('Widget auto-update service started successfully');
  } catch (e) {
    print('Error starting widget auto-update service: $e');
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
            home: const AppLauncher(),
          ),
        );
      },
    );
  }
}

/// Handles app launch detection and navigation without interfering with splash screen
class AppLauncher extends StatefulWidget {
  const AppLauncher({super.key});

  @override
  State<AppLauncher> createState() => _AppLauncherState();
}

class _AppLauncherState extends State<AppLauncher> with WidgetsBindingObserver {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeApp();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    if (state == AppLifecycleState.resumed && _isInitialized) {
      // App came to foreground - update widgets with fresh content
      _updateWidgetsOnResume();
    }
  }

  Future<void> _updateWidgetsOnResume() async {
    try {
      // Update Dua widget with a new random dua when app resumes
      await WidgetService.updateWidgetWithRandomDua();
      print('Widgets updated on app resume');
    } catch (e) {
      print('Error updating widgets on app resume: $e');
    }
  }

  Future<void> _initializeApp() async {
    try {
      // Small delay to ensure splash screen is fully displayed
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Check if app was launched from widget
      final Uri? uri = await HomeWidget.initiallyLaunchedFromHomeWidget();
      
      // Remove splash screen
      FlutterNativeSplash.remove();
      
      if (!mounted) return;
      
      if (uri != null) {
        print('App launched from widget with URI: $uri');
        await _handleWidgetLaunch(uri);
      } else {
        // Normal app launch - navigate to home screen
        _navigateToHome();
      }
    } catch (e) {
      print('Error during app initialization: $e');
      // Remove splash screen even if there's an error
      FlutterNativeSplash.remove();
      if (mounted) {
        _navigateToHome();
      }
    } finally {
      _isInitialized = true;
    }
  }

  Future<void> _handleWidgetLaunch(Uri uri) async {
    if (uri.host == 'dua') {
      // Navigate to Dua page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const WidgetLaunchedHomeScreen(
            targetPage: 2, // DoaPage is at index 2
            widgetType: 'dua',
          ),
        ),
      );
    } else if (uri.host == 'prayer' || uri.queryParameters['open_prayer_page'] == 'true') {
      // Navigate to Prayer page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const WidgetLaunchedHomeScreen(
            targetPage: 1, // PrayerPage is at index 1
            widgetType: 'prayer',
          ),
        ),
      );
    } else {
      // Unknown widget type, go to home
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Return a transparent container while initialization is happening
    // The native splash screen will be visible until FlutterNativeSplash.remove() is called
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox.shrink(), // Invisible placeholder
    );
  }
}

/// Special version of HomeScreen that navigates to specific page when launched from widget
class WidgetLaunchedHomeScreen extends StatefulWidget {
  final int targetPage;
  final String widgetType;

  const WidgetLaunchedHomeScreen({
    super.key, 
    required this.targetPage,
    required this.widgetType,
  });

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

    // After navigation, show a snackbar indicating which widget was tapped
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _showWidgetTappedNotification();
      }
    });
  }

  void _showWidgetTappedNotification() {
    String message;
    IconData icon;
    
    switch (widget.widgetType) {
      case 'dua':
        message = 'Dua widget tapped! Opening fresh Dua content';
        icon = Icons.auto_awesome;
        break;
      case 'prayer':
        message = 'Prayer widget tapped! Navigate to Prayer Times tab';
        icon = Icons.schedule;
        break;
      default:
        message = 'Widget tapped!';
        icon = Icons.touch_app;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: primary,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This is just a brief transition screen, should be barely visible
    return const Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      body: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(primary),
          strokeWidth: 2,
        ),
      ),
    );
  }
}