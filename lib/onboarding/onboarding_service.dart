import 'package:shared_preferences/shared_preferences.dart';

/// Service to handle onboarding state persistence
class OnboardingService {
  static const String _onboardingCompleteKey = 'onboarding_complete';

  /// Check if onboarding has been completed
  static Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompleteKey) ?? false;
  }

  /// Mark onboarding as complete
  static Future<void> setOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompleteKey, true);
  }

  /// Reset onboarding state (for testing purposes)
  static Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_onboardingCompleteKey);
  }
}
