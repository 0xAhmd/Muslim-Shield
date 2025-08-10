import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constants.dart';

class PrayerPageShimmers {
  // Next Prayer Card Shimmer
  static Widget nextPrayerCardShimmer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Stack(
        children: [
          // Background shimmer shape for masjid icon
          Positioned(
            bottom: -6.h,
            right: 0.w,
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                width: 130.w,
                height: 80.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ),
          // Main container shimmer
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primary.withOpacity(0.3), primary.withOpacity(0.2)],
              ),
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: primary.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.white.withOpacity(0.3),
              highlightColor: Colors.white.withOpacity(0.6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location shimmer
                  Row(
                    children: [
                      Container(
                        width: 18.w,
                        height: 18.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        width: 120.w,
                        height: 14.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Next prayer label shimmer
                  Container(
                    width: 80.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // Prayer name and time shimmer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 80.w,
                        height: 24.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                      Container(
                        width: 70.w,
                        height: 36.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Prayer Times List Shimmer
  static Widget prayerTimesListShimmer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 22.w),
      decoration: BoxDecoration(
        color: grey,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header shimmer
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                width: 120.w,
                height: 18.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
          ),

          // Prayer items shimmer
          ...List.generate(5, (index) {
            final isLast = index == 4;
            return _prayerTimeItemShimmer(isLast: isLast);
          }),
        ],
      ),
    );
  }

  // Individual Prayer Time Item Shimmer
  static Widget _prayerTimeItemShimmer({required bool isLast}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(color: Colors.grey.shade300, width: 0.8),
              ),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Row(
          children: [
            // Icon shimmer
            Container(
              width: 28.w,
              height: 28.w,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(6.r),
              ),
            ),
            SizedBox(width: 16.w),

            // Prayer name shimmer
            Expanded(
              child: Container(
                width: double.infinity,
                height: 16.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            SizedBox(width: 16.w),

            // Time shimmer
            Container(
              width: 50.w,
              height: 15.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Qiblah Compass Shimmer
  static Widget qiblahCompassShimmer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: grey,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title shimmer
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: 120.w,
              height: 18.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
          SizedBox(height: 20.h),

          // Compass circle shimmer
          Center(
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                width: 200.w,
                height: 200.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade300,
                ),
              ),
            ),
          ),

          SizedBox(height: 20.h),

          // Direction info shimmer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [_directionInfoShimmer(), _directionInfoShimmer()],
          ),
        ],
      ),
    );
  }

  static Widget _directionInfoShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          Container(
            width: 40.w,
            height: 12.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          SizedBox(height: 4.h),
          Container(
            width: 30.w,
            height: 16.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ],
      ),
    );
  }

  // Sunnah Prayers List Shimmer
  static Widget sunnahPrayersListShimmer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: grey,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header shimmer
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Row(
                children: [
                  Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Container(
                    width: 120.w,
                    height: 18.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Sunnah prayer items shimmer
          ...List.generate(6, (index) {
            final isLast = index == 5;
            return _sunnahPrayerItemShimmer(isLast: isLast);
          }),
        ],
      ),
    );
  }

  static Widget _sunnahPrayerItemShimmer({required bool isLast}) {
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
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Rakaat badge shimmer
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),

              SizedBox(width: 16.w),

              // Prayer details shimmer
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Prayer name shimmer
                    Container(
                      width: double.infinity,
                      height: 16.h,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Timing shimmer
                    Container(
                      width: 100.w,
                      height: 13.h,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),

                    SizedBox(height: 8.h),

                    // Description shimmer (multiple lines)
                    Container(
                      width: double.infinity,
                      height: 12.h,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      width: 150.w,
                      height: 12.h,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ],
                ),
              ),

              // Rakaat suffix shimmer
              Column(
                children: [
                  Container(
                    width: 35.w,
                    height: 10.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Container(
                    width: 30.w,
                    height: 16.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Full Page Loading Shimmer (combines all components)
  static Widget fullPageLoadingShimmer() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Next Prayer Card Shimmer
          nextPrayerCardShimmer(),

          // Tab Bar Shimmer
          Container(
            margin: EdgeInsets.symmetric(horizontal: 24.w),
            height: 48.h,
            decoration: BoxDecoration(
              color: grey,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Row(
                children: List.generate(
                  3,
                  (index) => Expanded(
                    child: Container(
                      margin: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Prayer Times List Shimmer
          prayerTimesListShimmer(),

          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  // Tab-specific shimmer widgets
  static Widget prayerTimesTabShimmer() {
    return SingleChildScrollView(
      child: Column(
        children: [
          prayerTimesListShimmer(),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  static Widget qiblahTabShimmer() {
    return SingleChildScrollView(
      child: Column(
        children: [
          qiblahCompassShimmer(),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  static Widget sunnahTabShimmer() {
    return SingleChildScrollView(
      child: Column(
        children: [
          sunnahPrayersListShimmer(),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
