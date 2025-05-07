class AppConstants {
  // App name
  static const String appName = "Vienna Airport Taxi";

  // API base URL (replace with your actual API URL)
  static const String apiBaseUrl = "http://localhost:3000/api";

  // Endpoints
  static const String loginEndpoint = "/auth/login";
  static const String registerEndpoint = "/auth/register";
  static const String bookingEndpoint = "/bookings";

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
