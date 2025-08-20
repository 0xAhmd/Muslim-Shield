import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants.dart';
import '../cubit/juzz_state.dart';

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
              'Error loading Juzz',
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
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Retry'),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: onBack,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: textColor),
                    foregroundColor: textColor,
                  ),
                  icon: const Icon(Icons.arrow_back, size: 18),
                  label: const Text('Go Back'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
