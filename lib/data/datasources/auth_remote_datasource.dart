import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/services/token_storage_service.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failure, Map<String, dynamic>>> register({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, Map<String, dynamic>>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, Map<String, dynamic>>> testApiConnection();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  final String baseUrl = 'https://caseapi.servicelabs.tech';
  final TokenStorageService tokenStorage;

  AuthRemoteDataSourceImpl({
    required this.dio,
    required this.tokenStorage,
  });

  @override
  Future<Either<Failure, Map<String, dynamic>>> testApiConnection() async {
    try {
      print('Testing API connection...');

      // Test the base API endpoint
      final response = await dio.get(
        '$baseUrl/api-docs',
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => status! < 500,
        ),
      );

      print('API connection test - Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return Right({
          'endpoint': '$baseUrl/api-docs',
          'status': response.statusCode,
          'message': 'API documentation accessible',
        });
      } else {
        return Left(ServerFailure(
            'API documentation not accessible: ${response.statusCode}'));
      }
    } catch (e) {
      print('API connection test failed: $e');
      return Left(ServerFailure('API bağlantı testi başarısız: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      print('Attempting to register user: $email');

      final response = await dio.post(
        '$baseUrl/user/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => status! < 500,
        ),
      );

      print('Register response status: ${response.statusCode}');
      print('Register response data: ${response.data}');

      // API dokümantasyonuna göre 201 olmalı ama 200 döndürüyor
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        // API'nin gerçek response formatı:
        // {
        //   "response": {
        //     "code": 200,
        //     "message": ""
        //   },
        //   "data": {
        //     "_id": "string",
        //     "id": "string",
        //     "name": "string",
        //     "email": "string",
        //     "photoUrl": "string",
        //     "token": "string"
        //   }
        // }

        if (data is Map<String, dynamic> &&
            data['data'] is Map<String, dynamic>) {
          final userData = data['data'] as Map<String, dynamic>;
          final user = UserModel.fromJson(userData);

          // Save token if available
          if (userData['token'] != null) {
            await tokenStorage.saveToken(userData['token']);
            print('Token saved from register response');
          }

          return Right({
            'user': user,
            'token': userData['token'],
          });
        } else {
          return Left(ServerFailure('Geçersiz response formatı'));
        }
      } else {
        final responseData = response.data;
        String errorMessage = 'Kayıt başarısız: ${response.statusCode}';

        // API'nin response formatına göre hata mesajını al
        if (responseData is Map<String, dynamic>) {
          if (responseData['response'] is Map<String, dynamic>) {
            final responseInfo =
                responseData['response'] as Map<String, dynamic>;
            final apiMessage = responseInfo['message']?.toString() ?? '';

            // Kullanıcı dostu hata mesajları
            switch (apiMessage) {
              case 'USER_EXISTS':
                errorMessage = 'Bu email adresi zaten kayıtlı.';
                break;
              case 'INVALID_EMAIL':
                errorMessage = 'Geçersiz email formatı.';
                break;
              case 'INVALID_PASSWORD':
                errorMessage = 'Şifre çok kısa veya geçersiz.';
                break;
              case 'INVALID_NAME':
                errorMessage = 'Geçersiz isim.';
                break;
              default:
                errorMessage =
                    apiMessage.isNotEmpty ? apiMessage : errorMessage;
            }
          } else {
            errorMessage = responseData['message']?.toString() ?? errorMessage;
          }
        }

        return Left(ServerFailure(errorMessage));
      }
    } on DioException catch (e) {
      print('DioException in register: ${e.message}');
      print('DioException response: ${e.response?.data}');

      if (e.response != null) {
        final errorMessage =
            e.response?.data['message'] ?? e.message ?? 'Bilinmeyen hata';
        return Left(ServerFailure(errorMessage));
      }
      return Left(ServerFailure(e.message ?? 'Bilinmeyen hata'));
    } catch (e) {
      print('General exception in register: $e');
      return Left(ServerFailure('Bilinmeyen hata: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    try {
      print('Attempting to login user: $email');

      final response = await dio.post(
        '$baseUrl/user/login',
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => status! < 500,
        ),
      );

      print('Login response status: ${response.statusCode}');
      print('Login response data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;

        // API'nin gerçek response formatı (login için de aynı):
        // {
        //   "response": {
        //     "code": 200,
        //     "message": ""
        //   },
        //   "data": {
        //     "_id": "string",
        //     "id": "string",
        //     "name": "string",
        //     "email": "string",
        //     "photoUrl": "string",
        //     "token": "string"
        //   }
        // }

        if (data is Map<String, dynamic> &&
            data['data'] is Map<String, dynamic>) {
          final userData = data['data'] as Map<String, dynamic>;
          final user = UserModel.fromJson(userData);

          // Save token if available
          if (userData['token'] != null) {
            await tokenStorage.saveToken(userData['token']);
            print('Token saved from login response');
          }

          return Right({
            'user': user,
            'token': userData['token'],
          });
        } else {
          return Left(ServerFailure('Geçersiz response formatı'));
        }
      } else {
        final responseData = response.data;
        String errorMessage = 'Giriş başarısız: ${response.statusCode}';

        // API'nin response formatına göre hata mesajını al
        if (responseData is Map<String, dynamic>) {
          if (responseData['response'] is Map<String, dynamic>) {
            final responseInfo =
                responseData['response'] as Map<String, dynamic>;
            final apiMessage = responseInfo['message']?.toString() ?? '';

            // Kullanıcı dostu hata mesajları
            switch (apiMessage) {
              case 'USER_NOT_FOUND':
                errorMessage = 'Kullanıcı bulunamadı.';
                break;
              case 'INVALID_CREDENTIALS':
                errorMessage = 'Email veya şifre hatalı.';
                break;
              case 'INVALID_EMAIL':
                errorMessage = 'Geçersiz email formatı.';
                break;
              case 'INVALID_PASSWORD':
                errorMessage = 'Geçersiz şifre.';
                break;
              default:
                errorMessage =
                    apiMessage.isNotEmpty ? apiMessage : errorMessage;
            }
          } else {
            errorMessage = responseData['message']?.toString() ?? errorMessage;
          }
        }

        return Left(ServerFailure(errorMessage));
      }
    } on DioException catch (e) {
      print('DioException in login: ${e.message}');
      print('DioException response: ${e.response?.data}');

      if (e.response != null) {
        final errorMessage =
            e.response?.data['message'] ?? e.message ?? 'Bilinmeyen hata';
        return Left(ServerFailure(errorMessage));
      }
      return Left(ServerFailure(e.message ?? 'Bilinmeyen hata'));
    } catch (e) {
      print('General exception in login: $e');
      return Left(ServerFailure('Bilinmeyen hata: $e'));
    }
  }
}
