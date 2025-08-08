import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants.dart';
import '../../data/models/prayer_completion.dart';

class DailyProgressCard extends StatelessWidget {
  final PrayerCompletion completion;

  const DailyProgressCard({
    super.key,
    required this.completion,
  });

  @override
  Widget build(BuildContext context) {
    final completedCount = completion.completedCount;
    final totalCount = PrayerType.values.length;
    final progress = completedCount / totalCount;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: grey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: completion.isComplete ? primary.withOpacity(0.5) : Colors.transparent,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Today\'s Progress',
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              if (completion.isComplete)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: primary,
                        size: 12.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Complete',
                        style: GoogleFonts.poppins(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: primary,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          
          SizedBox(height: 12.h),
          
          // Progress bar
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: textColor.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      completion.isComplete ? primary : orange,
                    ),
                    minHeight: 6.h,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                '$completedCount/$totalCount',
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 8.h),
          
          Text(
            '${(progress * 100).toInt()}% completed',
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}