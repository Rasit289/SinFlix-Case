import '../services/firebase_service.dart';

/// Firebase Mixin
/// Provides easy access to Firebase functionality across all pages and components
mixin FirebaseMixin {
  /// Log custom event to Analytics
  Future<void> logAnalyticsEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    await FirebaseService.logEvent(name: name, parameters: parameters);
  }

  /// Log user property to Analytics
  Future<void> setAnalyticsUserProperty({
    required String name,
    required String value,
  }) async {
    await FirebaseService.setUserProperty(name: name, value: value);
  }

  /// Log user ID to Analytics and Crashlytics
  Future<void> setAnalyticsUserId(String userId) async {
    await FirebaseService.setUserId(userId);
  }

  /// Log error to Crashlytics
  Future<void> logCrashlyticsError(
    dynamic error,
    StackTrace? stackTrace, {
    String? reason,
  }) async {
    await FirebaseService.logError(error, stackTrace, reason: reason);
  }

  /// Log non-fatal error to Crashlytics
  Future<void> logCrashlyticsNonFatalError(
    dynamic error,
    StackTrace? stackTrace, {
    String? reason,
  }) async {
    await FirebaseService.logNonFatalError(error, stackTrace, reason: reason);
  }

  /// Set custom key in Crashlytics
  Future<void> setCrashlyticsCustomKey(String key, dynamic value) async {
    await FirebaseService.setCustomKey(key, value);
  }

  /// Log screen view to Analytics
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    await FirebaseService.logScreenView(
        screenName: screenName, screenClass: screenClass);
  }

  /// Log app open event
  Future<void> logAppOpen() async {
    await FirebaseService.logAppOpen();
  }

  /// Log login event
  Future<void> logLogin({required String method}) async {
    await FirebaseService.logLogin(method: method);
  }

  /// Log sign up event
  Future<void> logSignUp({required String method}) async {
    await FirebaseService.logSignUp(method: method);
  }

  /// Log search event
  Future<void> logSearch({required String searchTerm}) async {
    await FirebaseService.logSearch(searchTerm: searchTerm);
  }

  /// Log select content event
  Future<void> logSelectContent({
    required String contentType,
    required String itemId,
  }) async {
    await FirebaseService.logSelectContent(
        contentType: contentType, itemId: itemId);
  }

  /// Log share event
  Future<void> logShare({
    required String contentType,
    required String itemId,
    String? method,
  }) async {
    await FirebaseService.logShare(
        contentType: contentType, itemId: itemId, method: method);
  }

  /// Log movie view event
  Future<void> logMovieView({
    required String movieId,
    required String movieTitle,
  }) async {
    await logAnalyticsEvent(
      name: 'movie_view',
      parameters: {
        'movie_id': movieId,
        'movie_title': movieTitle,
      },
    );
  }

  /// Log favorite toggle event
  Future<void> logFavoriteToggle({
    required String movieId,
    required String movieTitle,
    required bool isFavorite,
  }) async {
    await logAnalyticsEvent(
      name: 'favorite_toggle',
      parameters: {
        'movie_id': movieId,
        'movie_title': movieTitle,
        'is_favorite': isFavorite,
      },
    );
  }

  /// Log photo upload event
  Future<void> logPhotoUpload({
    required String source, // 'camera' or 'gallery'
    required bool success,
    String? error,
  }) async {
    await logAnalyticsEvent(
      name: 'photo_upload',
      parameters: {
        'source': source,
        'success': success,
        'error': error,
      },
    );
  }

  /// Log language change event
  Future<void> logLanguageChange({
    required String fromLanguage,
    required String toLanguage,
  }) async {
    await logAnalyticsEvent(
      name: 'language_change',
      parameters: {
        'from_language': fromLanguage,
        'to_language': toLanguage,
      },
    );
  }

  /// Log page navigation event
  Future<void> logPageNavigation({
    required String fromPage,
    required String toPage,
  }) async {
    await logAnalyticsEvent(
      name: 'page_navigation',
      parameters: {
        'from_page': fromPage,
        'to_page': toPage,
      },
    );
  }
}
