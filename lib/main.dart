import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ConnectivityService().initialize();
  await EasyLocalization.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(BookmarkModelAdapter());
  Hive.registerAdapter(BookmarkTypeAdapter());
  Hive.registerAdapter(TasbihModelAdapter());
  Hive.registerAdapter(PrayerCompletionAdapter());
  Hive.registerAdapter(PrayerTypeAdapter());
  Hive.registerAdapter(PrayerStreakAdapter());

  await BookmarksService().init();
  await LocalAudioService().initialize();
  await dotenv.load(fileName: ".env");
  final notificationService = NotificationService();
  await notificationService.initialize();
  await PrayerTrackerService().initialize();

  final isRooted = await SafeDevice.isJailBroken;
  final isRealDevice = await SafeDevice.isRealDevice;

  if (isRooted || isRealDevice) {
    runApp(
      EasyLocalization(
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('ar', 'SA'),
        ],
        path: 'assets/translations',
        fallbackLocale: const Locale('en', 'US'),
        child: const BlockedDeviceApp(),
      ),
    );
  } else {
    runApp(
      EasyLocalization(
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('ar', 'SA'),
        ],
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
        return MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,

          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: scaffoldBackgroundColor,
            appBarTheme: const AppBarTheme(
              backgroundColor: scaffoldBackgroundColor,
            ),

            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
          home: const HomeScreen(),
        );
      },
    );
  }
}
