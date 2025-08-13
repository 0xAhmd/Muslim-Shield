import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants.dart';

class QiblahCompass extends StatefulWidget {
  const QiblahCompass({super.key});

  @override
  State<QiblahCompass> createState() => _QiblahCompassState();
}

class _QiblahCompassState extends State<QiblahCompass>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          Text(
            'Qiblah Direction',
            style: TextStyle(
              color: textColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.h),

          // Check if device supports qiblah
          FutureBuilder<bool?>(
            future: FlutterQiblah.androidDeviceSensorSupport(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingCompass();
              }

              if (snapshot.hasError || snapshot.data != true) {
                return _buildUnsupportedDevice();
              }

              return _buildQiblahCompass();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCompass() {
    return SizedBox(
      height: 200.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: primary, strokeWidth: 3),
            SizedBox(height: 16.h),
            Text(
              'Loading compass...',
              style: TextStyle(
                color: textColor.withOpacity(0.7),
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnsupportedDevice() {
    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.red.withOpacity(0.3), width: 1),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade400, size: 48.sp),
            SizedBox(height: 16.h),
            Text(
              'Device not supported',
              style: TextStyle(
                color: Colors.red.shade400,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Your device does not have compass sensors',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor.withOpacity(0.7),
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQiblahCompass() {
    return StreamBuilder<QiblahDirection>(
      stream: FlutterQiblah.qiblahStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingCompass();
        }

        if (snapshot.hasError) {
          return _buildErrorCompass(snapshot.error.toString());
        }

        final qiblahDirection = snapshot.data!;

        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Column(
              children: [
                // Compass
                SizedBox(
                  height: 200.h,
                  width: 200.w,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Compass background
                      Transform.scale(
                        scale: _animation.value,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              center: Alignment.center,
                              colors: [
                                primary.withOpacity(0.1),
                                primary.withOpacity(0.05),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Compass needle
                      Transform.rotate(
                        angle: (qiblahDirection.qiblah * (math.pi / 180) * -1),
                        child: Container(
                          width: 8.w,
                          height: 80.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.r),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.red.shade400, primary],
                            ),
                          ),
                        ),
                      ),

                      // Center dot
                      Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primary,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),

                      // Direction indicators
                      ..._buildDirectionIndicators(),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),

                // Direction info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildDirectionInfo(
                      'Qiblah',
                      '${qiblahDirection.qiblah.toStringAsFixed(1)}°',
                      primary,
                    ),
                    _buildDirectionInfo(
                      'Direction',
                      qiblahDirection.direction.toStringAsFixed(1),
                      orange,
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildErrorCompass(String error) {
    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.orange.withOpacity(0.3), width: 1),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.warning_amber_outlined, color: orange, size: 48.sp),
            SizedBox(height: 16.h),
            Text(
              'Compass Error',
              style: TextStyle(
                color: orange,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Please check your device sensors',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor.withOpacity(0.7),
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDirectionIndicators() {
    return [
      // North indicator
      Positioned(
        top: 10.h,
        child: Text(
          'N',
          style: TextStyle(
            color: textColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // Kaaba indicator
      Positioned(
        top: 40.h,
        child: Icon(Icons.location_on, color: primary, size: 20.sp),
      ),
    ];
  }

  Widget _buildDirectionInfo(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: textColor.withOpacity(0.7),
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}