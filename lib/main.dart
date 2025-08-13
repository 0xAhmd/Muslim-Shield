import 'package:azkar/app.dart';
import 'package:azkar/app_launcher.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:safe_device/safe_device.dart';

import 'core/widgets/blocked.dart';
import 'constants.dart';

/// Background callback for widget interactions
/// This MUST be a top-level function (outside of main())
@pragma("vm:entry-point")
Future<void> _backgroundCallback(Uri? uri) async {
  print('Widget callback triggered: $uri');

  // Handle different widget types
  if (uri?.host == 'dua') {
    print('Dua widget tapped - should navigate to dua page');
  } else if (uri?.host == 'prayer' ||
      uri?.queryParameters['open_prayer_page'] == 'true') {
    print('Next Prayer widget tapped - should navigate to prayer page');
  }
}

void main() async {
  // Preserve the native splash screen
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize all app services and dependencies
  await AppInitializer.initialize(_backgroundCallback);

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
            home: const AppLauncher(),
          ),
        );
      },
    );
  }
}
