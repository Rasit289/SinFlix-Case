import 'dart:io';

abstract class PhotoUploadRepository {
  Future<String> uploadPhoto(File imageFile);
}
