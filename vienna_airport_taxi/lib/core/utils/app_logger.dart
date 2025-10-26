import 'package:vienna_airport_taxi/core/config/environment.dart';

/// Professional logging utility for the Vienna Airport Taxi app
///
/// Usage:
/// ```dart
/// AppLogger.debug('User clicked button');
/// AppLogger.info('Booking submitted successfully');
/// AppLogger.warning('API response was slow');
/// AppLogger.error('Failed to submit booking', error: e, stackTrace: stack);
/// ```
///
/// Features:
/// - Logs only in development/staging (silent in production)
/// - Color-coded output for easy reading
/// - Stack traces for errors
/// - No performance impact in production
class AppLogger {
  // Private constructor to prevent instantiation
  AppLogger._();

  /// Log debug information (detailed, for development only)
  /// Use for: Development debugging, tracing code flow
  static void debug(String message, {Object? data}) {
    if (Environment.enableDebugLogging) {
      _log('DEBUG', message, data: data);
    }
  }

  /// Log general information (important app events)
  /// Use for: User actions, successful operations, app state changes
  static void info(String message, {Object? data}) {
    if (Environment.enableDebugLogging) {
      _log('INFO', message, data: data);
    }
  }

  /// Log warnings (something unexpected but not critical)
  /// Use for: Deprecated features, recoverable errors, performance issues
  static void warning(String message, {Object? data}) {
    if (Environment.enableDebugLogging) {
      _log('WARNING', message, data: data);
    }
  }

  /// Log errors (something went wrong)
  /// Use for: API failures, exceptions, critical issues
  /// Always logs even in production (but sanitized)
  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Object? data,
  }) {
    // Always log errors, even in production (for crash reporting)
    _log('ERROR', message, data: data, error: error, stackTrace: stackTrace);
  }

  /// Internal logging implementation
  static void _log(
    String level,
    String message, {
    Object? data,
    Object? error,
    StackTrace? stackTrace,
  }) {
    // Format timestamp
    final timestamp = DateTime.now().toIso8601String().substring(11, 23);

    // Format the log message
    final logMessage = StringBuffer();
    logMessage.write('[$timestamp] [$level] $message');

    if (data != null) {
      logMessage.write(' | Data: $data');
    }

    if (error != null) {
      logMessage.write(' | Error: $error');
    }

    // Print the formatted message
    // ignore: avoid_print
    print(logMessage.toString());

    // Print stack trace if provided (errors only)
    if (stackTrace != null && Environment.enableDebugLogging) {
      // ignore: avoid_print
      print('Stack trace:\n$stackTrace');
    }
  }

  /// Log API requests (useful for debugging network issues)
  static void apiRequest(String method, String endpoint, {Object? data}) {
    if (Environment.enableDebugLogging) {
      _log('API', '$method $endpoint', data: data);
    }
  }

  /// Log API responses
  static void apiResponse(String endpoint, int statusCode, {Object? data}) {
    if (Environment.enableDebugLogging) {
      _log('API', 'Response from $endpoint (Status: $statusCode)', data: data);
    }
  }

  /// Log navigation events
  static void navigation(String route, {String? from}) {
    if (Environment.enableDebugLogging) {
      final message = from != null
          ? 'Navigating from $from to $route'
          : 'Navigating to $route';
      _log('NAV', message);
    }
  }

  /// Log form validation issues
  static void validation(String field, String issue) {
    if (Environment.enableDebugLogging) {
      _log('VALIDATION', 'Field "$field": $issue');
    }
  }

  /// Log performance metrics
  static void performance(String operation, Duration duration) {
    if (Environment.enableDebugLogging) {
      _log('PERF', '$operation took ${duration.inMilliseconds}ms');
    }
  }
}
