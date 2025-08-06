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
        _buildNavItem(icon: "assets/radio.png"),
        _buildNavItem(icon: "assets/svgs/lamp-icon.svg"),
        _buildNavItem(icon: "assets/svgs/bookmark-icon.svg"),
      ],
    );
  }

  BottomNavigationBarItem _buildNavItem({required String icon}) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(icon, color: textColor),
      activeIcon: SvgPicture.asset(icon, color: primary),
      label: "",
    );
  }
}
