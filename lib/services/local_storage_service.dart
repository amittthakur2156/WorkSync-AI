import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String onboardingKey = "onboarding_completed";

  /// Save onboarding status
  static Future<void> setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(onboardingKey, true);
  }

  /// Check onboarding status
  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(onboardingKey) ?? false;
  }

  /// Clear onboarding status (For Testing)
  static Future<void> clearOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(onboardingKey);
  }
}