import '../services/logger_service.dart';
import '../services/logger_service_impl.dart';

/// Logger Mixin
/// Provides easy access to logger functionality across all pages and components
mixin LoggerMixin {
  final LoggerService _logger = LoggerServiceImpl();

  /// Get logger instance
  LoggerService get logger => _logger;

  /// Log debug information
  void logDebug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.debug(message, error, stackTrace);
  }

  /// Log general information
  void logInfo(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.info(message, error, stackTrace);
  }

  /// Log warnings
  void logWarning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.warning(message, error, stackTrace);
  }

  /// Log errors
  void logError(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.error(message, error, stackTrace);
  }

  /// Log fatal errors
  void logFatal(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.fatal(message, error, stackTrace);
  }

  /// Log API requests
  void logApiRequest(String method, String url,
      [Map<String, dynamic>? headers, dynamic body]) {
    _logger.logApiRequest(method, url, headers, body);
  }

  /// Log API responses
  void logApiResponse(String method, String url, int statusCode,
      [dynamic response]) {
    _logger.logApiResponse(method, url, statusCode, response);
  }

  /// Log API errors
  void logApiError(String method, String url, dynamic error) {
    _logger.logApiError(method, url, error);
  }

  /// Log user actions
  void logUserAction(String action, [Map<String, dynamic>? parameters]) {
    _logger.logUserAction(action, parameters);
  }

  /// Log navigation events
  void logNavigation(String from, String to,
      [Map<String, dynamic>? parameters]) {
    _logger.logNavigation(from, to, parameters);
  }

  /// Log state changes
  void logStateChange(String blocName, String event,
      [Map<String, dynamic>? parameters]) {
    _logger.logStateChange(blocName, event, parameters);
  }

  /// Log performance metrics
  void logPerformance(String operation, Duration duration) {
    _logger.logPerformance(operation, duration);
  }

  /// Log authentication events
  void logAuth(String event, [Map<String, dynamic>? parameters]) {
    _logger.logAuth(event, parameters);
  }

  /// Log file operations
  void logFileOperation(String operation, String filePath, [dynamic error]) {
    _logger.logFileOperation(operation, filePath, error);
  }
}
