import 'package:azkar/core/widgets/home_widget.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';

class WidgetControlPage extends StatefulWidget {
  const WidgetControlPage({super.key});

  @override
  State<WidgetControlPage> createState() => _WidgetControlPageState();
}

class _WidgetControlPageState extends State<WidgetControlPage> {
  bool _isUpdating = false;

  Future<void> _updateWidget() async {
    setState(() {
      _isUpdating = true;
    });

    try {
      await WidgetService.updateWidgetWithRandomDua();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text('Widget updated with new Dua!'),
              ],
            ),
            backgroundColor: primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update widget: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    setState(() {
      _isUpdating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget Settings'),
        backgroundColor: background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Home Screen Widget',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Update your home screen widget with a new random Dua. The widget will display a different Dua each time you update it.',
              style: TextStyle(color: textColor, fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 32),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: grey,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: primary.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  const Icon(Icons.widgets, color: primary, size: 48),
                  const SizedBox(height: 16),
                  const Text(
                    'Random Dua Widget',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Displays a random Dua on your home screen',
                    style: TextStyle(color: textColor, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton.icon(
                    onPressed: _isUpdating ? null : _updateWidget,
                    icon: _isUpdating
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : const Icon(Icons.refresh),
                    label: Text(_isUpdating ? 'Updating...' : 'Update Widget'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: orange, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'How to add the widget',
                        style: TextStyle(
                          color: orange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    '1. Long press on your home screen\n'
                    '2. Tap the "+" button or "Widgets"\n'
                    '3. Search for "Muslim Shield"\n'
                    '4. Select the Dua widget\n'
                    '5. Tap "Add Widget"',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
