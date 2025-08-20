import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants.dart';

class MasjidLoadingShimmer extends StatefulWidget {
  const MasjidLoadingShimmer({super.key});

  @override
  State<MasjidLoadingShimmer> createState() => _MasjidLoadingShimmerState();
}

class _MasjidLoadingShimmerState extends State<MasjidLoadingShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          // Header shimmer
          _buildHeaderShimmer(),
          SizedBox(height: 24.h),

          // Cards shimmer
          ...List.generate(
            3, // Show 3 shimmer cards
            (index) => Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: _buildCardShimmer(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderShimmer() {
    return Row(
      children: [
        _buildShimmerBox(width: 20.w, height: 20.w, borderRadius: 10.r),
        SizedBox(width: 8.w),
        _buildShimmerBox(width: 200.w, height: 16.h, borderRadius: 8.r),
      ],
    );
  }

  Widget _buildCardShimmer() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: grey,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: primary.withOpacity(0.1), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  _buildShimmerBox(
                    width: 36.w,
                    height: 36.w,
                    borderRadius: 8.r,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildShimmerBox(
                          width: double.infinity,
                          height: 18.h,
                          borderRadius: 4.r,
                        ),
                        SizedBox(height: 8.h),
                        _buildShimmerBox(
                          width: 120.w,
                          height: 14.h,
                          borderRadius: 4.r,
                        ),
                      ],
                    ),
                  ),
                  _buildShimmerBox(
                    width: 60.w,
                    height: 20.h,
                    borderRadius: 6.r,
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // Address row
              Row(
                children: [
                  _buildShimmerBox(
                    width: 16.w,
                    height: 16.w,
                    borderRadius: 8.r,
                  ),
                  SizedBox(width: 8.w),
                  _buildShimmerBox(
                    width: 180.w,
                    height: 14.h,
                    borderRadius: 4.r,
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              // Coordinates row
              Row(
                children: [
                  _buildShimmerBox(
                    width: 14.w,
                    height: 14.w,
                    borderRadius: 7.r,
                  ),
                  SizedBox(width: 6.w),
                  _buildShimmerBox(
                    width: 140.w,
                    height: 12.h,
                    borderRadius: 4.r,
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: _buildShimmerBox(height: 36.h, borderRadius: 8.r),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildShimmerBox(height: 36.h, borderRadius: 8.r),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShimmerBox({
    double? width,
    required double height,
    required double borderRadius,
  }) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                textColor.withOpacity(0.1),
                textColor.withOpacity(0.2),
                textColor.withOpacity(0.1),
              ],
              stops: [0.0, _animation.value, 1.0],
            ),
          ),
        );
      },
    );
  }
}
