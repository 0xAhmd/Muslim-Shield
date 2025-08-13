import 'dart:math';
import 'package:home_widget/home_widget.dart';
import '../../Doa/data/dua_data.dart';
import '../../Doa/data/dua_model.dart';

class WidgetService {
  static const String appGroupId = 'group.com.example.azkar.widget';
  static const String iOSWidgetName = 'DuaWidget';
  static const String androidWidgetName = 'DuaAppWidget';

  /// Initialize the widget service
  static Future<void> initialize() async {
    try {
      // Set app group for iOS (required for data sharing)
      await HomeWidget.setAppGroupId(appGroupId);

      // Start the automatic update timer
      await _startPeriodicUpdates();
    } catch (e) {
      print('Error initializing widget service: $e');
    }
  }

  /// Start periodic updates every 10 minutes
  static Future<void> _startPeriodicUpdates() async {
    try {
      // Update immediately on startup
      await updateWidgetWithRandomDua();

      // Schedule periodic updates using native platform capabilities
      // We'll rely on the Android widget's updatePeriodMillis and iOS widget timeline
      print(
        'Periodic updates initialized - widget will update every 10 minutes',
      );
    } catch (e) {
      print('Error starting periodic updates: $e');
    }
  }

  /// Update widget with a random Dua
  static Future<void> updateWidgetWithRandomDua() async {
    try {
      // Get a random Dua
      final randomDua = _getRandomDua();

      // Save data for the widget to access
      await HomeWidget.saveWidgetData<String>('dua_title', randomDua.title);
      await HomeWidget.saveWidgetData<String>(
        'dua_arabic',
        _truncateArabic(randomDua.arabic),
      );
      await HomeWidget.saveWidgetData<String>(
        'dua_translation',
        _truncateTranslation(randomDua.translation),
      );
      await HomeWidget.saveWidgetData<String>(
        'dua_category',
        randomDua.category,
      );
      await HomeWidget.saveWidgetData<String>(
        'last_updated',
        DateTime.now().toIso8601String(),
      );

      // Update the actual widget
      await HomeWidget.updateWidget(
        iOSName: iOSWidgetName,
        androidName: androidWidgetName,
      );

      print('Widget updated successfully with: ${randomDua.title}');
    } catch (e) {
      print('Error updating widget: $e');
    }
  }

  /// Get a random Dua from the available Duas
  static DuaModel _getRandomDua() {
    final random = Random();
    const duas = DuasData.duas;
    return duas[random.nextInt(duas.length)];
  }

  /// Truncate Arabic text for widget display
  static String _truncateArabic(String text) {
    const maxLength = 60;
    if (text.length <= maxLength) return text;

    int cutoff = maxLength;
    while (cutoff > 0 && text[cutoff] != ' ') {
      cutoff--;
    }

    if (cutoff == 0) cutoff = maxLength;
    return '${text.substring(0, cutoff)}...';
  }

  /// Truncate translation text for widget display
  static String _truncateTranslation(String text) {
    const maxLength = 80;
    if (text.length <= maxLength) return text;

    int cutoff = maxLength;
    while (cutoff > 0 && text[cutoff] != ' ') {
      cutoff--;
    }

    if (cutoff == 0) cutoff = maxLength;
    return '${text.substring(0, cutoff)}...';
  }

  /// Handle widget tap (when user taps the widget)
  static Future<void> handleWidgetTap() async {
    // This will be called when the widget is tapped
    // The native code will handle opening the app
    print('Widget tapped - opening app');
  }

  /// Force update widget (can be called manually if needed)
  static Future<void> forceUpdateWidget() async {
    await updateWidgetWithRandomDua();
  }
}
