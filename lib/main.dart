import 'package:azkar/constants.dart';
import 'package:azkar/surah/audio/audio_state.dart';
import 'package:azkar/home/presentation/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  WidgetsFlutterBinding.ensureInitialized();
  await AudioService().initialize();
  runApp(MyApp());
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
            appBarTheme: AppBarTheme(backgroundColor: background),
          ),
          debugShowCheckedModeBanner: false,
          home: HomeScreen(),
        );
      },
    );
  }
}
