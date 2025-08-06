import '../../../constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HizbLoadingView extends StatelessWidget {
  final int? hizbNumber;

  const HizbLoadingView({super.key, this.hizbNumber});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primary),
              strokeWidth: 3.0,
            ),
            const SizedBox(height: 24),
            Text(
              hizbNumber != null
                  ? 'Loading Hizb $hizbNumber...'
                  : 'Loading Hizb sections...',
              style: GoogleFonts.poppins(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Please wait while we fetch the data',
              style: GoogleFonts.poppins(
                color: textColor.withOpacity(0.7),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
