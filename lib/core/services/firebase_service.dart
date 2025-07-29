import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Firebase Service
/// Provides Firebase Crashlytics and Analytics functionality
class FirebaseService {
  static FirebaseAnalytics? _analytics;
  static FirebaseCrashlytics? _crashlytics;

  /// Initialize Firebase
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
      _analytics = FirebaseAnalytics.instance;
      _crashlytics = FirebaseCrashlytics.instance;

      // Enable Crashlytics in debug mode for testing
      await _crashlytics?.setCrashlyticsCollectionEnabled(true);

      // Set user identifier for Crashlytics
      await _crashlytics
          ?.setUserIdentifier('user_${DateTime.now().millisecondsSinceEpoch}');

      print('Firebase initialized successfully');
    } catch (e) {
      print('Firebase initialization failed: $e');
    }
  }

  /// Log custom event to Analytics
  static Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      await _analytics?.logEvent(
        name: name,
        parameters: parameters,
      );
      print('Analytics event logged: $name');
    } catch (e) {
      print('Failed to log analytics event: $e');
    }
  }

  /// Log user property to Analytics
  static Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    try {
      await _analytics?.setUserProperty(name: name, value: value);
      print('User property set: $name = $value');
    } catch (e) {
      print('Failed to set user property: $e');
    }
  }

  /// Log user ID to Analytics
  static Future<void> setUserId(String userId) async {
    try {
      await _analytics?.setUserId(id: userId);
      await _crashlytics?.setUserIdentifier(userId);
      print('User ID set: $userId');
    } catch (e) {
      print('Failed to set user ID: $e');
    }
  }

  /// Log error to Crashlytics
  static Future<void> logError(
    dynamic error,
    StackTrace? stackTrace, {
    String? reason,
  }) async {
    try {
      await _crashlytics?.recordError(
        error,
        stackTrace,
        reason: reason,
      );
      print('Error logged to Crashlytics: $error');
    } catch (e) {
      print('Failed to log error to Crashlytics: $e');
    }
  }

  /// Log non-fatal error to Crashlytics
  static Future<void> logNonFatalError(
    dynamic error,
    StackTrace? stackTrace, {
    String? reason,
  }) async {
    try {
      await _crashlytics?.recordError(
        error,
        stackTrace,
        reason: reason,
        fatal: false,
      );
      print('Non-fatal error logged to Crashlytics: $error');
    } catch (e) {
      print('Failed to log non-fatal error to Crashlytics: $e');
    }
  }

  /// Log custom key to Crashlytics
  static Future<void> setCustomKey(String key, dynamic value) async {
    try {
      await _crashlytics?.setCustomKey(key, value);
      print('Custom key set: $key = $value');
    } catch (e) {
      print('Failed to set custom key: $e');
    }
  }

  /// Log screen view to Analytics
  static Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    try {
      await _analytics?.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );
      print('Screen view logged: $screenName');
    } catch (e) {
      print('Failed to log screen view: $e');
    }
  }

  /// Log app open event
  static Future<void> logAppOpen() async {
    try {
      await _analytics?.logAppOpen();
      print('App open event logged');
    } catch (e) {
      print('Failed to log app open event: $e');
    }
  }

  /// Log login event
  static Future<void> logLogin({required String method}) async {
    try {
      await _analytics?.logLogin(loginMethod: method);
      print('Login event logged: $method');
    } catch (e) {
      print('Failed to log login event: $e');
    }
  }

  /// Log sign up event
  static Future<void> logSignUp({required String method}) async {
    try {
      await _analytics?.logSignUp(signUpMethod: method);
      print('Sign up event logged: $method');
    } catch (e) {
      print('Failed to log sign up event: $e');
    }
  }

  /// Log search event
  static Future<void> logSearch({required String searchTerm}) async {
    try {
      await _analytics?.logSearch(searchTerm: searchTerm);
      print('Search event logged: $searchTerm');
    } catch (e) {
      print('Failed to log search event: $e');
    }
  }

  /// Log select content event
  static Future<void> logSelectContent({
    required String contentType,
    required String itemId,
  }) async {
    try {
      await _analytics?.logSelectContent(
        contentType: contentType,
        itemId: itemId,
      );
      print('Select content event logged: $contentType - $itemId');
    } catch (e) {
      print('Failed to log select content event: $e');
    }
  }

  /// Log share event
  static Future<void> logShare({
    required String contentType,
    required String itemId,
    String? method,
  }) async {
    try {
      await _analytics?.logShare(
        contentType: contentType,
        itemId: itemId,
        method: method ?? 'unknown',
      );
      print('Share event logged: $contentType - $itemId');
    } catch (e) {
      print('Failed to log share event: $e');
    }
  }

  /// Test Crashlytics with a sample error
  static Future<void> testCrashlytics() async {
    try {
      await _crashlytics?.recordError(
        'Test error from Sinflix app',
        StackTrace.current,
        reason: 'Testing Crashlytics integration',
      );
      print('Test error logged to Crashlytics');
    } catch (e) {
      print('Failed to log test error: $e');
    }
  }
}
