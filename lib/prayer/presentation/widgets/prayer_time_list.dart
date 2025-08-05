import 'package:azkar/prayer/data/models/prayer_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants.dart';

class PrayerTimesList extends StatelessWidget {
  final List<PrayerInfo> prayers;

  const PrayerTimesList({super.key, required this.prayers});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: gray,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Text(
              'Today\'s Prayers',
              style: TextStyle(
                color: textColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...prayers.asMap().entries.map((entry) {
            final index = entry.key;
            final prayer = entry.value;
            final isLast = index == prayers.length - 1;

            return _PrayerTimeItem(prayer: prayer, isLast: isLast);
          }),
        ],
      ),
    );
  }
}

class _PrayerTimeItem extends StatelessWidget {
  final PrayerInfo prayer;
  final bool isLast;

  const _PrayerTimeItem({required this.prayer, required this.isLast});

  IconData _getPrayerIcon(String prayerName) {
    switch (prayerName.toLowerCase()) {
      case 'fajr':
        return Icons.wb_twilight;
      case 'dhuhr':
        return Icons.wb_sunny;
      case 'asr':
        return Icons.wb_sunny_outlined;
      case 'maghrib':
        return Icons.wb_twilight;
      case 'isha':
        return Icons.nights_stay;
      default:
        return Icons.access_time;
    }
  }

  Color _getPrayerIconColor(String prayerName) {
    switch (prayerName.toLowerCase()) {
      case 'fajr':
        return Colors.orange.shade300;
      case 'dhuhr':
        return Colors.yellow.shade600;
      case 'asr':
        return Colors.orange.shade400;
      case 'maghrib':
        return Colors.deepOrange.shade400;
      case 'isha':
        return Colors.indigo.shade300;
      default:
        return primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(color: Colors.grey.shade300, width: 0.8),
              ),
      ),
      child: Row(
        children: [
          Icon(
            _getPrayerIcon(prayer.name),
            color: _getPrayerIconColor(prayer.name),
            size: 28.sp,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              prayer.name,
              style: TextStyle(
                color: textColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            prayer.time,
            style: TextStyle(
              color: textColor.withOpacity(0.8),
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
