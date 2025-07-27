import 'dart:io';
import '../../domain/repositories/photo_upload_repository.dart';
import '../datasources/photo_upload_remote_datasource.dart';

class PhotoUploadRepositoryImpl implements PhotoUploadRepository {
  final PhotoUploadRemoteDataSource remoteDataSource;

  PhotoUploadRepositoryImpl({required this.remoteDataSource});

  @override
  Future<String> uploadPhoto(File imageFile) async {
    try {
      return await remoteDataSource.uploadPhoto(imageFile);
    } catch (e) {
      throw Exception('Repository: $e');
    }
  }
}
