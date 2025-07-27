import 'dart:io';
import 'package:dio/dio.dart';
import '../../core/services/token_storage_service.dart';

abstract class PhotoUploadRemoteDataSource {
  Future<String> uploadPhoto(File imageFile);
}

class PhotoUploadRemoteDataSourceImpl implements PhotoUploadRemoteDataSource {
  final Dio dio;
  final TokenStorageService tokenStorageService;

  PhotoUploadRemoteDataSourceImpl({
    required this.dio,
    required this.tokenStorageService,
  });

  @override
  Future<String> uploadPhoto(File imageFile) async {
    try {
      print('PhotoUploadRemoteDataSource: Upload başladı');
      print('PhotoUploadRemoteDataSource: Dosya yolu: ${imageFile.path}');
      print(
          'PhotoUploadRemoteDataSource: Dosya boyutu: ${await imageFile.length()} bytes');

      // Token al
      final token = await tokenStorageService.getToken();
      print(
          'PhotoUploadRemoteDataSource: Token: ${token != null ? "Mevcut" : "Yok"}');

      if (token == null) {
        throw Exception('Authentication token bulunamadı');
      }

      // FormData oluştur
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: 'profile_photo.jpg',
          contentType: DioMediaType('image', 'jpeg'),
        ),
      });

      print('PhotoUploadRemoteDataSource: FormData oluşturuldu');

      // POST isteği gönder
      Response response = await dio.post(
        '/user/upload_photo',
        data: formData,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print(
          'PhotoUploadRemoteDataSource: API yanıtı - Status: ${response.statusCode}');
      print('PhotoUploadRemoteDataSource: API yanıtı - Data: ${response.data}');

      if (response.statusCode == 200) {
        // Başarılı yanıt
        Map<String, dynamic> responseData = response.data;
        Map<String, dynamic> data =
            responseData['data'] as Map<String, dynamic>;
        String photoUrl = data['photoUrl'] as String;
        print('PhotoUploadRemoteDataSource: PhotoUrl alındı: $photoUrl');
        return photoUrl;
      } else {
        throw Exception('Fotoğraf yüklenirken hata oluştu');
      }
    } on DioException catch (e) {
      print(
          'PhotoUploadRemoteDataSource: DioException - Status: ${e.response?.statusCode}');
      print(
          'PhotoUploadRemoteDataSource: DioException - Message: ${e.message}');
      print(
          'PhotoUploadRemoteDataSource: DioException - Response: ${e.response?.data}');

      if (e.response?.statusCode == 400) {
        throw Exception('Geçersiz dosya formatı: ${e.response?.data}');
      } else if (e.response?.statusCode == 401) {
        throw Exception('Yetkisiz erişim');
      } else {
        throw Exception('Fotoğraf yüklenirken hata oluştu: ${e.message}');
      }
    } catch (e) {
      throw Exception('Fotoğraf yüklenirken hata oluştu: $e');
    }
  }
}
