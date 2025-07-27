import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import '../error/failures.dart';
import 'token_storage_service.dart';
import 'jwt_service.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorageService tokenStorage;
  final Dio dio;

  AuthInterceptor({
    required this.tokenStorage,
    required this.dio,
  });

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Skip token for login and register endpoints
    if (options.path.contains('/user/login') ||
        options.path.contains('/user/register')) {
      return handler.next(options);
    }

    // Add token to request headers
    final token = await tokenStorage.getToken();
    if (token != null && !JwtService.isTokenExpired(token)) {
      options.headers['Authorization'] = 'Bearer $token';
      print('Added token to request: ${options.path}');
    } else if (token != null && JwtService.isTokenExpired(token)) {
      print('Token expired, attempting refresh...');
      // Token expired, try to refresh
      final refreshResult = await _refreshToken();
      refreshResult.fold(
        (failure) {
          // Refresh failed, clear tokens and continue without auth
          print('Token refresh failed: ${failure.message}');
          tokenStorage.clearAllAuthData();
          return handler.next(options);
        },
        (newToken) {
          // Refresh successful, add new token
          options.headers['Authorization'] = 'Bearer $newToken';
          print('Added refreshed token to request: ${options.path}');
          return handler.next(options);
        },
      );
      return;
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Handle successful responses
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data;
      if (data is Map<String, dynamic> && data['token'] != null) {
        // Save new token from response
        _saveTokenFromResponse(data);
      }
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Unauthorized - token might be invalid
      print('401 Unauthorized, clearing tokens...');
      await tokenStorage.clearAllAuthData();

      // You might want to navigate to login screen here
      // This can be handled by a global auth state management
    }
    handler.next(err);
  }

  Future<Either<Failure, String>> _refreshToken() async {
    try {
      final refreshToken = await tokenStorage.getRefreshToken();
      if (refreshToken == null) {
        return Left(AuthFailure('No refresh token available'));
      }

      final response = await dio.post(
        'https://caseapi.servicelabs.tech/user/refresh', // Adjust endpoint as needed
        data: {'refreshToken': refreshToken},
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['token'] != null) {
          final newToken = data['token'] as String;
          await tokenStorage.saveToken(newToken);

          // Save refresh token if provided
          if (data['refreshToken'] != null) {
            await tokenStorage.saveRefreshToken(data['refreshToken']);
          }

          return Right(newToken);
        }
      }

      return Left(AuthFailure('Token refresh failed'));
    } catch (e) {
      print('Token refresh error: $e');
      return Left(AuthFailure('Token refresh error: $e'));
    }
  }

  void _saveTokenFromResponse(Map<String, dynamic> data) async {
    try {
      final token = data['token'] as String;
      await tokenStorage.saveToken(token);

      // Save refresh token if provided
      if (data['refreshToken'] != null) {
        await tokenStorage.saveRefreshToken(data['refreshToken']);
      }

      // Save user data if provided
      if (data['user'] != null) {
        final userData = data['user'] as Map<String, dynamic>;
        await tokenStorage.saveUserData(userData.toString());
      }

      print('Token and user data saved successfully');
    } catch (e) {
      print('Error saving token: $e');
    }
  }
}
