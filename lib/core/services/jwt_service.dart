import 'dart:convert';

class JwtService {
  /// Parse JWT token and extract payload
  static Map<String, dynamic>? parseToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        return null;
      }

      // Decode payload (second part)
      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final resp = utf8.decode(base64Url.decode(normalized));
      final payloadMap = json.decode(resp);
      return payloadMap;
    } catch (e) {
      print('JWT parse error: $e');
      return null;
    }
  }

  /// Check if token is expired
  static bool isTokenExpired(String token) {
    try {
      final payload = parseToken(token);
      if (payload == null) return true;

      final exp = payload['exp'];
      if (exp == null) return true;

      final expirationDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      final now = DateTime.now();

      return now.isAfter(expirationDate);
    } catch (e) {
      print('Token expiration check error: $e');
      return true;
    }
  }

  /// Get token expiration time
  static DateTime? getTokenExpiration(String token) {
    try {
      final payload = parseToken(token);
      if (payload == null) return null;

      final exp = payload['exp'];
      if (exp == null) return null;

      return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    } catch (e) {
      print('Get token expiration error: $e');
      return null;
    }
  }

  /// Get user ID from token
  static String? getUserId(String token) {
    try {
      final payload = parseToken(token);
      if (payload == null) return null;

      return payload['id']?.toString() ?? payload['_id']?.toString();
    } catch (e) {
      print('Get user ID error: $e');
      return null;
    }
  }

  /// Get user name from token
  static String? getUserName(String token) {
    try {
      final payload = parseToken(token);
      if (payload == null) return null;

      return payload['name']?.toString();
    } catch (e) {
      print('Get user name error: $e');
      return null;
    }
  }

  /// Get user email from token
  static String? getUserEmail(String token) {
    try {
      final payload = parseToken(token);
      if (payload == null) return null;

      return payload['email']?.toString();
    } catch (e) {
      print('Get user email error: $e');
      return null;
    }
  }

  /// Check if token will expire soon (within 5 minutes)
  static bool isTokenExpiringSoon(String token, {int minutes = 5}) {
    try {
      final expiration = getTokenExpiration(token);
      if (expiration == null) return true;

      final now = DateTime.now();
      final timeUntilExpiration = expiration.difference(now);
      final minutesUntilExpiration = timeUntilExpiration.inMinutes;

      return minutesUntilExpiration <= minutes;
    } catch (e) {
      print('Token expiring soon check error: $e');
      return true;
    }
  }

  /// Get all user data from token
  static Map<String, dynamic>? getUserData(String token) {
    try {
      final payload = parseToken(token);
      if (payload == null) return null;

      return {
        'id': payload['id'] ?? payload['_id'],
        'name': payload['name'],
        'email': payload['email'],
        'iat': payload['iat'], // issued at
        'exp': payload['exp'], // expiration
      };
    } catch (e) {
      print('Get user data error: $e');
      return null;
    }
  }
}
