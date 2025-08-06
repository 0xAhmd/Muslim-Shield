import '../../../constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        _buildNavItem(icon: "assets/svgs/quran-icon.svg"),
        _buildNavItem(icon: "assets/svgs/pray-icon.svg"),
        _buildNavItem(icon: "assets/svgs/doa-icon.svg"),
        _buildNavItem(icon: "assets/radio.png"), // Fixed radio item
        _buildNavItem(icon: "assets/svgs/lamp-icon.svg"),
        _buildNavItem(icon: "assets/svgs/bookmark-icon.svg"),
      ],
    );
  }

  BottomNavigationBarItem _buildNavItem({required String icon}) {
    final bool isSvg = icon.toLowerCase().endsWith('.svg');

    return BottomNavigationBarItem(
      icon: isSvg
          ? SvgPicture.asset(icon, color: textColor)
          : Image.asset(icon, color: textColor, width: 38, height: 38),
      activeIcon: isSvg
          ? SvgPicture.asset(icon, color: primary)
          : Image.asset(icon, color: primary, width: 24, height: 24),
      label: "",
    );
  }
}
