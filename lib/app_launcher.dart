import 'package:azkar/core/widgets/home_widget_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:home_widget/home_widget.dart';

import '../constants.dart';
import '../home/presentation/pages/home_screen.dart';
import 'onboarding/onboarding_screen.dart';
import 'onboarding/onboarding_service.dart';

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
      debugPrint('Widgets updated on app resume');
    } catch (e) {
      debugPrint('Error updating widgets on app resume: $e');
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

      // Check onboarding status first (only if not launched from widget)
      if (uri == null) {
        final isOnboardingComplete =
            await OnboardingService.isOnboardingComplete();

        if (!isOnboardingComplete) {
          // Show onboarding screen for first-time users
          _navigateToOnboarding();
          return;
        }
      }

      // Handle widget launch or normal app launch
      if (uri != null) {
        debugPrint('App launched from widget with URI: $uri');
        await _handleWidgetLaunch(uri);
      } else {
        // Normal app launch - navigate to home screen
        _navigateToHome();
      }
    } catch (e) {
      debugPrint('Error during app initialization: $e');
      // Remove splash screen even if there's an error
      FlutterNativeSplash.remove();
      if (mounted) {
        // If there's an error, check onboarding status as fallback
        _handleErrorNavigation();
      }
    } finally {
      _isInitialized = true;
    }
  }

  Future<void> _handleErrorNavigation() async {
    try {
      final isOnboardingComplete =
          await OnboardingService.isOnboardingComplete();
      if (isOnboardingComplete) {
        _navigateToHome();
      } else {
        _navigateToOnboarding();
      }
    } catch (e) {
      debugPrint('Error in fallback navigation: $e');
      // Last resort - go to home screen
      _navigateToHome();
    }
  }

  Future<void> _handleWidgetLaunch(Uri uri) async {
    // Mark onboarding as complete if user accessed app via widget
    // (implies they've used the app before)
    if (!await OnboardingService.isOnboardingComplete()) {
      await OnboardingService.setOnboardingComplete();
    }

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
    } else if (uri.host == 'prayer' ||
        uri.queryParameters['open_prayer_page'] == 'true') {
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

  void _navigateToOnboarding() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const OnboardingScreen()),
    );
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
