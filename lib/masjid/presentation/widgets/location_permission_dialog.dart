import 'package:flutter/material.dart';
import '../../../constants.dart';

class LocationPermissionDialog extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final VoidCallback? onOpenSettings;

  const LocationPermissionDialog({
    super.key,
    required this.message,
    required this.onRetry,
    this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: grey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(32),
              ),
              child: const Icon(Icons.location_off, color: orange, size: 32),
            ),

            const SizedBox(height: 16),

            // Title
            const Text(
              'Location Access Needed',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Message
            Text(
              message,
              style: TextStyle(
                color: textColor.withOpacity(0.9),
                fontSize: 14,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                if (onOpenSettings != null) ...[
                  Expanded(
                    child: TextButton(
                      onPressed: onOpenSettings,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: primary.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                      ),
                      child: const Text(
                        'Open Settings',
                        style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: ElevatedButton(
                    onPressed: onRetry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Try Again',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static void show(
    BuildContext context, {
    required String message,
    required VoidCallback onRetry,
    VoidCallback? onOpenSettings,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LocationPermissionDialog(
        message: message,
        onRetry: onRetry,
        onOpenSettings: onOpenSettings,
      ),
    );
  }
}
