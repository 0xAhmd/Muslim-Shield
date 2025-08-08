import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../constants.dart';

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: grey,
      highlightColor: grey.withOpacity(0.3),
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            height: 120.h,
            margin: EdgeInsets.only(bottom: 16.h, right: 16.h, left: 16.h),
            decoration: BoxDecoration(
              color: grey,
              borderRadius: BorderRadius.circular(16.r),
            ),
          );
        },
      ),
    );
  }
}
