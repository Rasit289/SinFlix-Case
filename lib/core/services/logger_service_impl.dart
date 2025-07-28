import 'package:logger/logger.dart';
import 'logger_service.dart';

/// Logger Service Implementation
/// Provides comprehensive logging functionality for the entire application
class LoggerServiceImpl implements LoggerService {
  late final Logger _logger;
  late final Logger _apiLogger;
  late final Logger _userLogger;
  late final Logger _performanceLogger;
  late final Logger _authLogger;

  LoggerServiceImpl() {
    _initializeLoggers();
  }

  void _initializeLoggers() {
    // Main logger for general application logs
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        printTime: true,
      ),
      level: Level.debug,
    );

    // API logger for network requests/responses
    _apiLogger = Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 4,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        printTime: true,
      ),
      level: Level.debug,
    );

    // User logger for user actions
    _userLogger = Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 2,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        printTime: true,
      ),
      level: Level.info,
    );

    // Performance logger for performance metrics
    _performanceLogger = Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 2,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        printTime: true,
      ),
      level: Level.info,
    );

    // Auth logger for authentication events
    _authLogger = Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 4,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        printTime: true,
      ),
      level: Level.info,
    );
  }

  @override
  void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d('🔍 DEBUG: $message', error: error, stackTrace: stackTrace);
  }

  @override
  void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i('ℹ️ INFO: $message', error: error, stackTrace: stackTrace);
  }

  @override
  void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w('⚠️ WARNING: $message', error: error, stackTrace: stackTrace);
  }

  @override
  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e('❌ ERROR: $message', error: error, stackTrace: stackTrace);
  }

  @override
  void fatal(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f('💀 FATAL: $message', error: error, stackTrace: stackTrace);
  }

  @override
  void logApiRequest(String method, String url,
      [Map<String, dynamic>? headers, dynamic body]) {
    final logMessage = '''
🌐 API REQUEST:
Method: $method
URL: $url
Headers: ${headers ?? 'None'}
Body: ${body ?? 'None'}
''';
    _apiLogger.i(logMessage);
  }

  @override
  void logApiResponse(String method, String url, int statusCode,
      [dynamic response]) {
    final logMessage = '''
📡 API RESPONSE:
Method: $method
URL: $url
Status Code: $statusCode
Response: ${response ?? 'None'}
''';
    _apiLogger.i(logMessage);
  }

  @override
  void logApiError(String method, String url, dynamic error) {
    final logMessage = '''
🚫 API ERROR:
Method: $method
URL: $url
Error: $error
''';
    _apiLogger.e(logMessage, error: error);
  }

  @override
  void logUserAction(String action, [Map<String, dynamic>? parameters]) {
    final logMessage = '''
👤 USER ACTION:
Action: $action
Parameters: ${parameters ?? 'None'}
''';
    _userLogger.i(logMessage);
  }

  @override
  void logNavigation(String from, String to,
      [Map<String, dynamic>? parameters]) {
    final logMessage = '''
🧭 NAVIGATION:
From: $from
To: $to
Parameters: ${parameters ?? 'None'}
''';
    _userLogger.i(logMessage);
  }

  @override
  void logStateChange(String blocName, String event,
      [Map<String, dynamic>? parameters]) {
    final logMessage = '''
🔄 STATE CHANGE:
Bloc: $blocName
Event: $event
Parameters: ${parameters ?? 'None'}
''';
    _logger.i(logMessage);
  }

  @override
  void logPerformance(String operation, Duration duration) {
    final logMessage = '''
⚡ PERFORMANCE:
Operation: $operation
Duration: ${duration.inMilliseconds}ms
''';
    _performanceLogger.i(logMessage);
  }

  @override
  void logAuth(String event, [Map<String, dynamic>? parameters]) {
    final logMessage = '''
🔐 AUTH EVENT:
Event: $event
Parameters: ${parameters ?? 'None'}
''';
    _authLogger.i(logMessage);
  }

  @override
  void logFileOperation(String operation, String filePath, [dynamic error]) {
    final logMessage = '''
📁 FILE OPERATION:
Operation: $operation
File Path: $filePath
Error: ${error ?? 'None'}
''';
    if (error != null) {
      _logger.e(logMessage, error: error);
    } else {
      _logger.i(logMessage);
    }
  }
}
