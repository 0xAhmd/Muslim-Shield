import '../../../constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SajdaLoadingView extends StatelessWidget {
  final int? sajdaId;

  const SajdaLoadingView({super.key, this.sajdaId});

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
              sajdaId != null
                  ? 'Loading Sajda $sajdaId...'
                  : 'Loading sajdas...',
              style: GoogleFonts.poppins(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Fetching data...',
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