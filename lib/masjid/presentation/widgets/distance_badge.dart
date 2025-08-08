import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants.dart';

class DistanceBadge extends StatelessWidget {
  final String distance;
  final bool isClosest;

  const DistanceBadge({
    super.key,
    required this.distance,
    this.isClosest = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isClosest ? primary.withOpacity(0.2) : orange.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isClosest ? primary.withOpacity(0.3) : orange.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isClosest) ...[
            Icon(Icons.near_me, color: primary, size: 12.sp),
            SizedBox(width: 4.w),
          ],
          Text(
            distance,
            style: TextStyle(
              color: isClosest ? primary : orange,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
