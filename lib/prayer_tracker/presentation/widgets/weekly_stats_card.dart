import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants.dart';

class WeeklyStatsCard extends StatelessWidget {
  final Map<String, dynamic> weeklyStats;
  final Map<String, dynamic> monthlyStats;

  const WeeklyStatsCard({
    super.key,
    required this.weeklyStats,
    required this.monthlyStats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: grey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistics',
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          
          SizedBox(height: 16.h),
          
          // Weekly stats
          _buildStatsSection('This Week', weeklyStats),
          
          SizedBox(height: 16.h),
          
          Divider(color: textColor.withOpacity(0.2)),
          
          SizedBox(height: 16.h),
          
          // Monthly stats
          _buildStatsSection('This Month', monthlyStats),
        ],
      ),
    );
  }

  Widget _buildStatsSection(String title, Map<String, dynamic> stats) {
    final completeDays = stats['completeDays'] ?? 0;
    final totalPrayers = stats['totalPrayers'] ?? 0;
    final possiblePrayers = stats['possiblePrayers'] ?? 0;
    final completionRate = (stats['completionRate'] ?? 0.0) as double;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        
        SizedBox(height: 8.h),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatItem('Complete Days', '$completeDays'),
            _buildStatItem('Prayers', '$totalPrayers/$possiblePrayers'),
            _buildStatItem('Rate', '${(completionRate * 100).toInt()}%'),
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: primary,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10.sp,
            color: textColor,
          ),
        ),
      ],
    );
  }
}