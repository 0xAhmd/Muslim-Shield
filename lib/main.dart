import 'package:azkar/bookmarks/model/bookmark.dart';
import 'package:azkar/bookmarks/service/bookmark_service.dart';
import 'package:azkar/constants.dart';
import 'package:azkar/core/blocked.dart';
import 'package:azkar/surah/audio/audio_state.dart';
import 'package:azkar/home/presentation/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:jailbreak_root_detection/jailbreak_root_detection.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(BookmarkModelAdapter());
  Hive.registerAdapter(BookmarkTypeAdapter());
  await BookmarksService().init();
  final isJailBroken = await JailbreakRootDetection.instance.isJailBroken;
  final isRealDevice = await JailbreakRootDetection.instance.isRealDevice;

  final isUnsafe = isJailBroken || isRealDevice;

  if (isUnsafe) {
    runApp(const BlockedDeviceApp());
    return;
  }
  await AudioService().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Set your design size
      minTextAdapt: true,
      splitScreenMode:
          true, // this is the _splitScreenMode it's complaining about
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeData(
            fontFamily: GoogleFonts.poppins().fontFamily,
            scaffoldBackgroundColor: background,
            appBarTheme: const AppBarTheme(backgroundColor: background),
          ),
          debugShowCheckedModeBanner: false,
          home: const HomeScreen(),
        );
      },
    );
  }
}
