import 'package:azkar/Reminders/presentation/pages/reminders_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants.dart';
import '../../../tasbih/presentation/pages/tasbih_page.dart';

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
                        child: Image.asset('assets/al-quran.png', width: 28.sp),
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
                  _buildDrawerItem(
                    context,
                    iconWidget: SvgPicture.asset('assets/svgs/lamp-icon.svg'),
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
                  SizedBox(height: 5.h),

                  _buildDrawerItem(
                    context,
                    iconWidget: Image.asset('assets/tasbih.png'),
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

                  // Placeholder for future features
                  // _buildDrawerItem(
                  //   context,
                  //   iconWidget: Image.asset('assets/radio.png'),
                  //   title: 'Quran Radio',
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => const RadioPage(),
                  //       ),
                  //     );
                  //   },
                  //   isComingSoon: false,
                  // ),
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
                ],
              ),
            ),

            // Footer
            Container(
              padding: EdgeInsets.all(24.r),
              child: Text(
                'Version 1.2.2',
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
              size: 20.sp,
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
              '• Quran reading with audio\n• Prayer times\n• Duas collection\n• Radio stations\n• Masjid finder\n• Digital Tasbih\n• And more...',
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
