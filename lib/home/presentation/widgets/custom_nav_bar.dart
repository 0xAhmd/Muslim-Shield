// lib/home/presentation/widgets/custom_bottom_nav.dart
import 'package:azkar/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: gray,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        _buildNavItem(icon: "assets/svgs/quran-icon.svg"),
        _buildNavItem(icon: "assets/svgs/lamp-icon.svg"),
        _buildNavItem(icon: "assets/svgs/pray-icon.svg"),
        _buildNavItem(icon: "assets/svgs/doa-icon.svg"),
        _buildNavItem(icon: "assets/svgs/bookmark-icon.svg"),
      ],
    );
  }

  BottomNavigationBarItem _buildNavItem({required String icon}) {
    return BottomNavigationBarItem(
      // ignore: deprecated_member_use
      icon: SvgPicture.asset(icon, color: textColor),
      activeIcon: SvgPicture.asset(icon, color: primary),
      label: "",
    );
  }
}
