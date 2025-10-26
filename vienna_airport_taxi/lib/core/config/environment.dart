/// Environment configuration for the Vienna Airport Taxi app
///
/// This file manages different configurations for development, staging, and production.
///
/// Usage:
/// ```dart
/// // In main.dart, before runApp():
/// Environment.init(EnvironmentType.development); // For local development
/// // or
/// Environment.init(EnvironmentType.production); // For production build
///
/// // Anywhere in your app:
/// final apiUrl = Environment.apiBaseUrl;
/// ```
library;

enum EnvironmentType {
  development,
  staging,
  production,
}

class Environment {
  // Private constructor to prevent instantiation
  Environment._();

  // Current environment
  static EnvironmentType _currentEnvironment = EnvironmentType.development;

  /// Initialize the environment
  /// Call this in main.dart before runApp()
  static void init(EnvironmentType environment) {
    _currentEnvironment = environment;
  }

  /// Get current environment type
  static EnvironmentType get currentEnvironment => _currentEnvironment;

  /// Check if running in production
  static bool get isProduction => _currentEnvironment == EnvironmentType.production;

  /// Check if running in development
  static bool get isDevelopment => _currentEnvironment == EnvironmentType.development;

  /// Check if running in staging
  static bool get isStaging => _currentEnvironment == EnvironmentType.staging;

  /// Get the base API URL based on current environment
  static String get apiBaseUrl {
    switch (_currentEnvironment) {
      case EnvironmentType.development:
        // Local development server
        return 'http://localhost:5001';

      case EnvironmentType.staging:
        // Staging server (optional - create this if you have a test server)
        // For now, we'll use the same as production
        return 'https://awt.eu.pythonanywhere.com';

      case EnvironmentType.production:
        // Production server
        return 'https://awt.eu.pythonanywhere.com';
    }
  }

  /// Get the orders endpoint
  static String get ordersEndpoint => '$apiBaseUrl/orders';

  /// Get the price calculation endpoint
  static String get priceEndpoint => '$apiBaseUrl/public_calculate_price';

  /// Enable debug logging in development
  static bool get enableDebugLogging => !isProduction;

  /// API timeout duration
  static Duration get apiTimeout => const Duration(seconds: 30);

  /// Maximum retry attempts for API calls
  static int get maxRetries => 3;

  /// Retry delay in milliseconds
  static int get retryDelayMs => 1000;

  /// Get environment name as string (useful for debugging)
  static String get environmentName {
    switch (_currentEnvironment) {
      case EnvironmentType.development:
        return 'Development';
      case EnvironmentType.staging:
        return 'Staging';
      case EnvironmentType.production:
        return 'Production';
    }
  }

  /// Print current configuration (for debugging)
  static void printConfig() {
    if (enableDebugLogging) {
    }
  }
}
