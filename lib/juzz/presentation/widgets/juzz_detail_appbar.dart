import 'package:azkar/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class JuzzDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int juzzNumber;
  final VoidCallback onRefresh;

  const JuzzDetailAppBar({
    super.key,
    required this.juzzNumber,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: background,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: SvgPicture.asset(
          'assets/svgs/back-icon.svg',
          // ignore: deprecated_member_use
          color: Colors.white,
        ),
      ),
      title: Text(
        'Juzz $juzzNumber',
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      actions: [
        IconButton(
          onPressed: onRefresh,
          icon: const Icon(Icons.refresh, color: Colors.white),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
