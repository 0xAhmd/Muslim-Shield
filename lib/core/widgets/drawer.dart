import 'package:azkar/Reminders/presentation/pages/reminders_page.dart';
import 'package:azkar/calc/presentation/pages/zakaat_calc_page.dart';
import 'package:azkar/hadith/presentation/pages/books_page.dart';
import 'package:azkar/names/presentation/pages/adhkar_page.dart';
import 'package:azkar/names/presentation/pages/allah_names_page.dart';
import 'package:azkar/prayer_tracker/presentation/pages/prayer_tracker_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../constants.dart';
import '../../../../tasbih/presentation/pages/tasbih_page.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(24.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primary.withOpacity(0.1), primary.withOpacity(0.05)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Image.asset(
                          'assets/images/al-quran.png',
                          width: 28.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'Muslim Shield',
                        style: GoogleFonts.poppins(
                          fontSize: 19.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Menu Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                children: [
                  // Names of Allah
                  _buildDrawerItem(
                    context,
                    iconWidget: Image.asset('assets/images/allah.png'),
                    title: 'Names of Allah',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AllahNamesPage(),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 2.h),

                  // Digital Tasbih
                  _buildDrawerItem(
                    context,
                    iconWidget: Image.asset('assets/images/tasbih.png'),
                    title: 'Digital Tasbih',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TasbihPage(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 2.h),

                  // Morning & Evening Adhkar
                  _buildDrawerItem(
                    context,
                    iconWidget: Image.asset('assets/images/dua.png'),
                    title: 'Morning & Evening Adhkar',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdhkarPage(),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 2.h),

                  // NEW: Hadith Browser
                  _buildDrawerItem(
                    context,
                    iconWidget: Image.asset(
                      'assets/images/muhammad.png',
                      color: Colors.white,
                    ),
                    title: 'Hadith Collection',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BooksPage(),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 2.h),

                  // Zakat Calculator
                  _buildDrawerItem(
                    context,
                    iconWidget: Image.asset('assets/images/zakat.png'),
                    title: 'Zakat Calculator',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const EnhancedZakatCalculatorPage(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 2.h),

                  _buildDrawerItem(
                    context,
                    iconWidget: Image.asset(
                      'assets/images/fire.png',
                      width: 38,
                    ),
                    title: 'Prayer Tracker',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PrayerTrackerPage(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 2.h),

                  // Reminders
                  _buildDrawerItem(
                    context,
                    iconWidget: SvgPicture.asset(
                      'assets/svgs/lamp-icon.svg',
                      width: 40,
                    ),
                    title: 'Reminders',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RemindersPage(),
                        ),
                      );
                    },
                    isComingSoon: false,
                  ),
                  SizedBox(height: 2.h),
                  Divider(
                    color: grey,
                    thickness: 1,
                    indent: 24.w,
                    endIndent: 24.w,
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.info_outline,

                    title: 'About',
                    onTap: () {
                      Navigator.pop(context);
                      _showAboutDialog(context);
                    },
                  ),

                  // _buildDrawerItem(
                  //   context,
                  //   icon: Icons.widgets_outlined,

                  //   title: 'Widget Settings',
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => const WidgetControlPage(),
                  //       ),
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),

            // Footer
            Container(
              padding: EdgeInsets.all(24.r),
              child: Text(
                'Version 1.3.2+1',
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  color: textColor.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    IconData? icon,
    Widget? iconWidget, // SVG or custom widget
    required String title,
    required VoidCallback onTap,
    bool isComingSoon = false,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
      leading: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: isComingSoon
              ? grey.withOpacity(0.5)
              : primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child:
            iconWidget ??
            Icon(
              icon,
              color: isComingSoon ? textColor.withOpacity(0.5) : primary,
              size: 28.sp,
            ),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: isComingSoon ? textColor.withOpacity(0.5) : Colors.white,
        ),
      ),

      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      hoverColor: primary.withOpacity(0.05),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'About Muslim Shield',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'A comprehensive Islamic app designed to help Muslims in their daily spiritual journey.',
              style: GoogleFonts.poppins(fontSize: 14.sp, color: textColor),
            ),
            SizedBox(height: 16.h),
            Text(
              'Features:',
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              '• Quran reading with audio\n• Prayer times\n• Duas collection\n• Radio stations\n• Masjid finder\n• Digital Tasbih\n• Names of Allah (99 Names)\n• Morning & Evening Adhkar\n• Hadith Collection Browser\n• Zakat Calculator\n• And more...',
              style: GoogleFonts.poppins(fontSize: 12.sp, color: textColor),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.poppins(
                color: primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
