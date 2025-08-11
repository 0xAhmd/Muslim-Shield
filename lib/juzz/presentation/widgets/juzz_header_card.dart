import 'package:easy_localization/easy_localization.dart';

import '../../../constants.dart';
import '../../data/models/juzz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class JuzzHeaderCard extends StatelessWidget {
  final Juzz juzz;

  const JuzzHeaderCard({super.key, required this.juzz});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      child: Stack(
        children: [
          // Background icon
          Positioned(
            bottom: -8,
            right: -8,
            child: Icon(
              Icons.menu_book_rounded,
              size: 70,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          // Main container
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primary.withOpacity(0.8), primary],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: primary.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  '${'juzz.juzz'.tr()} ${juzz.number}',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${juzz.totalAyahs} ${'juzz.ayahs'.tr()} • ${juzz.containedSurahs.length} ${'juzz.surahs'.tr()}',
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  juzz.surahRange,
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Background icon - positioned after main container
          Positioned(
            bottom: -32.h,
            right: 0.w,
            child: Opacity(
              opacity: 0.29,
              child: Image.asset(
                'assets/images/quran.png',
                width: 80.w,
                height: 80.h,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
