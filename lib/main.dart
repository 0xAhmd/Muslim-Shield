import 'package:azkar/Reminders/data/services/notification_service.dart';
import 'package:azkar/core/widgets/blocked.dart';
import 'package:azkar/core/connectivity_service.dart';
import 'package:azkar/prayer_tracker/data/models/prayer_completion.dart';
import 'package:azkar/prayer_tracker/data/service/prayer_tracker_service.dart';
import 'package:azkar/tasbih/data/models/tasbih.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'bookmarks/model/bookmark.dart';
import 'bookmarks/service/bookmark_service.dart';
import 'constants.dart';
import 'surah/audio/audio_state.dart';
import 'home/presentation/pages/home_screen.dart';

import 'package:safe_device/safe_device.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ConnectivityService().initialize();

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
    runApp(const BlockedDeviceApp());
  } else {
    runApp(const MyApp());
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
