import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart'; // for kReleaseMode
import 'package:jailbreak_root_detection/jailbreak_root_detection.dart';

import 'bookmarks/model/bookmark.dart';
import 'bookmarks/service/bookmark_service.dart';
import 'constants.dart';
import 'core/blocked.dart';
import 'surah/audio/audio_state.dart';
import 'home/presentation/pages/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

  await Hive.initFlutter();
  Hive.registerAdapter(BookmarkModelAdapter());
  Hive.registerAdapter(BookmarkTypeAdapter());
  await BookmarksService().init();
  await LocalAudioService().initialize();

  runApp(const AppEntry());
}

class AppEntry extends StatefulWidget {
  const AppEntry({super.key});

  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  bool? _isUnsafe;

  @override
  void initState() {
    super.initState();
    if (kReleaseMode) {
      _checkRootStatus(); // Only check in release mode
    } else {
      _isUnsafe = false; // Allow emulator/dev in debug & profile
    }
  }

  Future<void> _checkRootStatus() async {
    try {
      final isJailBroken = await JailbreakRootDetection.instance.isJailBroken;
      final isRealDevice = await JailbreakRootDetection.instance.isRealDevice;
      setState(() {
        _isUnsafe = isJailBroken || !isRealDevice;
      });
    } catch (e) {
      debugPrint('Root check failed: $e');
      setState(() {
        _isUnsafe = false; // Assume safe if detection fails
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isUnsafe == null) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return _isUnsafe! ? const BlockedDeviceApp() : const MyApp();
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
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
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

class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Muslim Shield',
      theme: ThemeData(scaffoldBackgroundColor: scaffoldBackgroundColor),
      home: const Scaffold(
        backgroundColor: scaffoldBackgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 64),
              SizedBox(height: 16),
              Text(
                'Initialization Error',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(height: 8),
              Text(
                'Please restart the app',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
