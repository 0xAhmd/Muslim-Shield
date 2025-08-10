// Updated lib/core/widgets/drawer.dart
import 'package:azkar/Reminders/presentation/pages/reminders_page.dart';
import 'package:azkar/calc/presentation/pages/zakaat_calc_page.dart';
import 'package:azkar/names/presentation/pages/adhkar_page.dart';
import 'package:azkar/names/presentation/pages/allah_names_page.dart';
import 'package:azkar/prayer_tracker/presentation/pages/prayer_tracker_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
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
                        'app_name'.tr(),
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
                    title: 'drawer.names_of_allah'.tr(),
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

                  SizedBox(height: 5.h),

                  // Digital Tasbih
                  _buildDrawerItem(
                    context,
                    iconWidget: Image.asset('assets/images/tasbih.png'),
                    title: 'drawer.digital_tasbih'.tr(),
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
                  SizedBox(height: 5.h),

                  // Morning & Evening Adhkar
                  _buildDrawerItem(
                    context,
                    iconWidget: Image.asset('assets/images/dua.png'),
                    title: 'drawer.morning_evening_adhkar'.tr(),
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

                  SizedBox(height: 5.h),

            

                  // Zakat Calculator
                  _buildDrawerItem(
                    context,
                    iconWidget: Image.asset('assets/images/zakat.png'),
                    title: 'drawer.zakat_calculator'.tr(),
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
                  SizedBox(height: 5.h),

                  _buildDrawerItem(
                    context,
                    iconWidget: Image.asset(
                      'assets/images/fire.png',
                      width: 38,
                    ),
                    title: 'drawer.prayer_tracker'.tr(),
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
                  SizedBox(height: 5.h),

                  // Reminders
                  _buildDrawerItem(
                    context,
                    iconWidget: SvgPicture.asset(
                      'assets/svgs/lamp-icon.svg',
                      width: 40,
                    ),
                    title: 'drawer.reminders'.tr(),
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
                  SizedBox(height: 5.h),

                  Divider(
                    color: grey,
                    thickness: 1,
                    indent: 24.w,
                    endIndent: 24.w,
                  ),

                  // Language Selection
                  _buildDrawerItem(
                    context,
                    icon: Icons.language,
                    title: 'Language',
                    subtitle: context.locale.languageCode == 'ar'
                        ? 'العربية'
                        : 'English',
                    onTap: () {
                      _showLanguageDialog(context);
                    },
                  ),

                  SizedBox(height: 5.h),

                  _buildDrawerItem(
                    context,
                    icon: Icons.info_outline,
                    title: 'drawer.about'.tr(),
                    onTap: () {
                      Navigator.pop(context);
                      _showAboutDialog(context);
                    },
                  ),
                ],
              ),
            ),

            // Footer
            Container(
              padding: EdgeInsets.all(24.r),
              child: Text(
                '${'drawer.version'.tr()} 1.3.2+1',
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
    String? subtitle,
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
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                color: textColor.withOpacity(0.7),
              ),
            )
          : null,
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      hoverColor: primary.withOpacity(0.05),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Select Language',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // English Option
            RadioListTile<String>(
              value: 'en',
              groupValue: context.locale.languageCode,
              title: Text(
                'English',
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  color: Colors.white,
                ),
              ),
              activeColor: primary,
              onChanged: (value) async {
                if (value != null) {
                  await context.setLocale(const Locale('en', 'US'));
                  Navigator.pop(context);
                }
              },
            ),
            // Arabic Option
            RadioListTile<String>(
              value: 'ar',
              groupValue: context.locale.languageCode,
              title: Text(
                'العربية',
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  color: Colors.white,
                ),
              ),
              activeColor: primary,
              onChanged: (value) async {
                if (value != null) {
                  await context.setLocale(const Locale('ar', 'SA'));
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'common.cancel'.tr(),
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

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'about_dialog.title'.tr(),
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
              'about_dialog.description'.tr(),
              style: GoogleFonts.poppins(fontSize: 14.sp, color: textColor),
            ),
            SizedBox(height: 16.h),
            Text(
              'about_dialog.features'.tr(),
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'about_dialog.feature_list'.tr(),
              style: GoogleFonts.poppins(fontSize: 12.sp, color: textColor),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'about_dialog.close'.tr(),
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
