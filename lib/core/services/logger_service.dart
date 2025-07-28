import 'package:logger/logger.dart';

/// Logger Service Interface
/// Provides logging functionality for the entire application
abstract class LoggerService {
  /// Log debug information
  void debug(String message, [dynamic error, StackTrace? stackTrace]);

  /// Log general information
  void info(String message, [dynamic error, StackTrace? stackTrace]);

  /// Log warnings
  void warning(String message, [dynamic error, StackTrace? stackTrace]);

  /// Log errors
  void error(String message, [dynamic error, StackTrace? stackTrace]);

  /// Log fatal errors
  void fatal(String message, [dynamic error, StackTrace? stackTrace]);

  /// Log API requests
  void logApiRequest(String method, String url,
      [Map<String, dynamic>? headers, dynamic body]);

  /// Log API responses
  void logApiResponse(String method, String url, int statusCode,
      [dynamic response]);

  /// Log API errors
  void logApiError(String method, String url, dynamic error);

  /// Log user actions
  void logUserAction(String action, [Map<String, dynamic>? parameters]);

  /// Log navigation events
  void logNavigation(String from, String to,
      [Map<String, dynamic>? parameters]);

  /// Log state changes
  void logStateChange(String blocName, String event,
      [Map<String, dynamic>? parameters]);

  /// Log performance metrics
  void logPerformance(String operation, Duration duration);

  /// Log authentication events
  void logAuth(String event, [Map<String, dynamic>? parameters]);

  /// Log file operations
  void logFileOperation(String operation, String filePath, [dynamic error]);
}
