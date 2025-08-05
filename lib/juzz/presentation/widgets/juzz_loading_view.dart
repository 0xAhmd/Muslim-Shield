import 'package:azkar/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JuzzLoadingView extends StatelessWidget {
  final int juzzNumber;

  const JuzzLoadingView({super.key, required this.juzzNumber});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: primary),
          const SizedBox(height: 24),
          Text(
            'Loading Juzz $juzzNumber...',
            style: GoogleFonts.poppins(color: textColor, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Please wait while we fetch the verses',
            style: GoogleFonts.poppins(
              color: textColor.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
