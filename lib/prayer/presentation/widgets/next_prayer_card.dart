// lib/prayer/presentation/widgets/next_prayer_card.dart
import 'package:azkar/prayer/data/models/prayer_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants.dart';

class NextPrayerCard extends StatelessWidget {
  final PrayerInfo? nextPrayer;
  final LocationInfo? location;

  const NextPrayerCard({super.key, this.nextPrayer, this.location});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primary.withOpacity(0.8), primary.withOpacity(0.6)],
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location info
          if (location != null) ...[
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.white.withOpacity(0.8),
                  size: 18.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    '${location!.cityName}, ${location!.countryName}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
          ],

          // Next prayer info
          if (nextPrayer != null) ...[
            Text(
              'Next Prayer',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  nextPrayer!.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    nextPrayer!.time,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            // Loading or error state
            Center(
              child: Text(
                'Loading next prayer...',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16.sp,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
