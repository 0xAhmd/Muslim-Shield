import 'package:easy_localization/easy_localization.dart';

import '../../data/constants/sunnah_prayer_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants.dart';

class SunnahPrayersList extends StatelessWidget {
  const SunnahPrayersList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: grey,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Row(
              children: [
                Icon(Icons.auto_awesome, color: orange, size: 24.sp),
                SizedBox(width: 12.w),
                Text(
                  'prayer.sunnah_prayers'.tr(),
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ...SunnahPrayersConstants.sunnahPrayers.asMap().entries.map((entry) {
            final index = entry.key;
            final prayer = entry.value;
            final isLast =
                index == SunnahPrayersConstants.sunnahPrayers.length - 1;

            return _SunnahPrayerItem(prayer: prayer, isLast: isLast);
          }),
        ],
      ),
    );
  }
}

class _SunnahPrayerItem extends StatelessWidget {
  final SunnahPrayer prayer;
  final bool isLast;

  const _SunnahPrayerItem({required this.prayer, required this.isLast});

  Color _getTimingColor(String timing) {
    if (timing.contains('Before')) {
      return Colors.blue.shade300;
    } else if (timing.contains('After')) {
      return Colors.green.shade300;
    } else if (timing.contains('night')) {
      return Colors.purple.shade300;
    }
    return orange;
  }

  IconData _getTimingIcon(String timing) {
    if (timing.contains('Before')) {
      return Icons.schedule;
    } else if (timing.contains('After')) {
      return Icons.schedule_send;
    } else if (timing.contains('night')) {
      return Icons.nights_stay;
    }
    return Icons.access_time;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: !isLast
            ? Border(
                bottom: BorderSide(color: textColor.withOpacity(0.1), width: 1),
              )
            : null,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rakaat count badge
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: primary.withOpacity(0.3), width: 1),
              ),
              child: Center(
                child: Text(
                  '${prayer.rakaat}',
                  style: TextStyle(
                    color: primary,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            SizedBox(width: 16.w),

            // Prayer details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Prayer name
                  Text(
                    prayer.name,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Timing with icon
                  Row(
                    children: [
                      Icon(
                        _getTimingIcon(prayer.timing),
                        color: _getTimingColor(prayer.timing),
                        size: 16.sp,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        prayer.timing,
                        style: TextStyle(
                          color: _getTimingColor(prayer.timing),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  // Description
                  Text(
                    prayer.description,
                    style: TextStyle(
                      color: textColor.withOpacity(0.7),
                      fontSize: 12.sp,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            // Rakaat suffix
            Column(
              children: [
                Text(
                  'prayer.rakah'.tr(),
                  style: TextStyle(
                    color: textColor.withOpacity(0.5),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: _getRakaatBadgeColor(prayer.rakaat),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    _getRakaatLabel(prayer.rakaat),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getRakaatBadgeColor(int rakaat) {
    switch (rakaat) {
      case 2:
        return Colors.green.shade400;
      case 3:
        return Colors.orange.shade400;
      case 4:
        return Colors.blue.shade400;
      case 8:
        return Colors.purple.shade400;
      default:
        return primary;
    }
  }

  String _getRakaatLabel(int rakaat) {
    if (rakaat <= 4) {
      return 'prayer.short'.tr();
    } else if (rakaat <= 6) {
      return 'prayer.medium'.tr();
    } else {
      return 'prayer.long'.tr();
    }
  }
}
