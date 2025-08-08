import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants.dart';
import '../../data/models/prayer_completion.dart';

class PrayerCompletionCard extends StatelessWidget {
  final PrayerType prayer;
  final bool isCompleted;
  final VoidCallback onToggle;

  const PrayerCompletionCard({
    super.key,
    required this.prayer,
    required this.isCompleted,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: isCompleted 
                  ? primary.withOpacity(0.15) 
                  : grey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isCompleted ? primary : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                // Checkbox
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24.w,
                  height: 24.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted ? primary : Colors.transparent,
                    border: Border.all(
                      color: isCompleted ? primary : textColor.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: isCompleted
                      ? Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16.sp,
                        )
                      : null,
                ),
                
                SizedBox(width: 16.w),
                
                // Prayer details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prayer.displayName,
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: isCompleted ? Colors.white : textColor,
                        ),
                      ),
                      Text(
                        prayer.arabicName,
                        style: GoogleFonts.amiri(
                          fontSize: 14.sp,
                          color: isCompleted 
                              ? Colors.white.withOpacity(0.8) 
                              : textColor.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Status indicator
                if (isCompleted)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      'Complete',
                      style: GoogleFonts.poppins(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

