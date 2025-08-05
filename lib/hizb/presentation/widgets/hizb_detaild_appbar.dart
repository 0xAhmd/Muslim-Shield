import 'package:azkar/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HizbDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int hizbNumber;
  final VoidCallback onRefresh;

  const HizbDetailAppBar({
    super.key,
    required this.hizbNumber,
    required this.onRefresh,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: background,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: textColor),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hizb $hizbNumber',
            style: GoogleFonts.poppins(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'القرآن الكريم',
            style: GoogleFonts.amiri(
              color: textColor.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: textColor),
          onPressed: onRefresh,
        ),
      ],
    );
  }
}
