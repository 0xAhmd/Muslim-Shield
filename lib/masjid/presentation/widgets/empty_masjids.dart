import 'package:flutter/material.dart';
import '../../../constants.dart';

class EmptyMasjidsWidget extends StatelessWidget {
  final VoidCallback onRefresh;

  const EmptyMasjidsWidget({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                Icons.mosque_outlined,
                color: primary.withOpacity(0.7),
                size: 40,
              ),
            ),

            const SizedBox(height: 24),

            // Title
            const Text(
              'No Masjids Found',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Description
            Text(
              'We couldn\'t find any masjids within 5km of your location. This might be due to limited data in your area.',
              style: TextStyle(
                color: textColor.withOpacity(0.8),
                fontSize: 16,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Action buttons
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onRefresh,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.refresh, size: 20),
                    label: const Text(
                      'Refresh Location',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'Or try moving to a different area',
                  style: TextStyle(
                    color: textColor.withOpacity(0.6),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
