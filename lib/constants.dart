import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color scaffoldBackgroundColor = Color(0xff030A1D);

const Color background = Color(0xFF040C23);
const Color textColor = Color(0xFFA19CC5);
const Color orange = Color(0xFFF9B091);
const Color primary = Color(0xFFA44AFF);
const Color grey = Color(0xFF121931);

class AppThemes {
  static ThemeData getTheme() {
    // Default to English/Poppins font
    return ThemeData(
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      appBarTheme: const AppBarTheme(backgroundColor: scaffoldBackgroundColor),
      fontFamily: GoogleFonts.poppins().fontFamily,
      textTheme: _getTextTheme(),
    );
  }

  static TextTheme _getTextTheme() {
    return GoogleFonts.poppinsTextTheme().apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    );
  }
}

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
