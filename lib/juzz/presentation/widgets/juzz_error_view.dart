import 'package:azkar/constants.dart';
import 'package:azkar/juzz/presentation/cubit/juzz_state.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JuzzErrorView extends StatelessWidget {
  final JuzzDetailError state;
  final VoidCallback onRetry;
  final VoidCallback onBack;

  const JuzzErrorView({
    super.key,
    required this.state,
    required this.onRetry,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              'Error Loading Juzz',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.message,
              style: GoogleFonts.poppins(color: textColor, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                  ),
                  icon: Icon(Icons.refresh, size: 18),
                  label: Text('Retry'),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: onBack,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: textColor),
                    foregroundColor: textColor,
                  ),
                  icon: Icon(Icons.arrow_back, size: 18),
                  label: Text('Go Back'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
