class AppConstants {
  // App name
  static const String appName = "Vienna Airport Taxi";

  // Note: API configuration is now managed in lib/core/config/environment.dart
  // Use Environment.apiBaseUrl to get the correct URL based on the current environment

  // Shared Preferences Keys
  static const String tokenKey = "auth_token";
  static const String userIdKey = "user_id";
  static const String userNameKey = "user_name";
  static const String userEmailKey = "user_email";
  static const String addressKey = "saved_address";

  // Animation durations
  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration pageDuration = Duration(milliseconds: 300);
}
