import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16.h,
      left: 16.w,
      right: 16.w,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            height: 60.h, // Adjusted height
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBounceIcon(icon: "assets/svgs/quran-icon.svg", index: 0),
                _buildBounceIcon(icon: "assets/svgs/pray-icon.svg", index: 1),
                _buildBounceIcon(icon: "assets/svgs/doa-icon.svg", index: 2),
                _buildBounceIcon(icon: "assets/radio.png", index: 3),
                _buildBounceIcon(icon: "assets/svgs/lamp-icon.svg", index: 4),
                _buildBounceIcon(
                  icon: "assets/svgs/bookmark-icon.svg",
                  index: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBounceIcon({required String icon, required int index}) {
    final bool isSvg = icon.toLowerCase().endsWith('.svg');

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 1.0, end: currentIndex == index ? 1.25 : 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return GestureDetector(
          onTap: () => onTap(index),
          child: Transform.scale(
            scale: scale,
            child: isSvg
                ? SvgPicture.asset(
                    icon,
                    color: currentIndex == index ? primary : textColor,
                    width: 28.w,
                    height: 28.h,
                  )
                : Image.asset(
                    icon,
                    color: currentIndex == index ? primary : textColor,
                    width: 28.w,
                    height: 28.h,
                  ),
          ),
        );
      },
    );
  }
}
