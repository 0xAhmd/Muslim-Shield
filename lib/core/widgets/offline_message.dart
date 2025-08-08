import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants.dart';

class OfflineMessageWidget extends StatelessWidget {
  final String? customMessage;
  final VoidCallback? onRetry;

  const OfflineMessageWidget({super.key, this.customMessage, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Icon(Icons.wifi_off, size: 64, color: Colors.red[400]),
            ),
            const SizedBox(height: 24),
            Text(
              'No Internet Connection',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              customMessage ??
                  'This content needs internet connectivity.\nPlease make sure you have an internet connection.',
              style: GoogleFonts.poppins(
                color: textColor,
                fontSize: 14,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
