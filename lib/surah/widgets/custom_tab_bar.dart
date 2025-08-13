import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';

class CustomTabBar extends StatelessWidget {
  final TabController controller;
  final ValueChanged<int>? onTap;

  const CustomTabBar({super.key, required this.controller, this.onTap});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      unselectedLabelColor: textColor,
      indicatorWeight: 3,
      labelStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        fontSize: 17,
        color: Colors.white,
      ),
      dividerHeight: 0,
      onTap: onTap,
      tabs: const [
        Tab(text: "Surah"),
        Tab(text: "Juzz"),
        Tab(text: "Hizb"),
        Tab(text: "Sajda"),
      ],
    );
  }
}