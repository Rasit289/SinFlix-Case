import 'dart:io';
import '../repositories/photo_upload_repository.dart';

class UploadPhotoUseCase {
  final PhotoUploadRepository repository;

  UploadPhotoUseCase({required this.repository});

  Future<String> call(File imageFile) async {
    return await repository.uploadPhoto(imageFile);
  }
}
