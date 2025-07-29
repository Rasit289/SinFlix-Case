import 'package:equatable/equatable.dart';
import 'dart:io';

abstract class PhotoUploadState extends Equatable {
  const PhotoUploadState();

  @override
  List<Object?> get props => [];
}

class PhotoUploadInitial extends PhotoUploadState {}

class PhotoUploadLoading extends PhotoUploadState {}

class PhotoUploadSuccess extends PhotoUploadState {
  final File imageFile;
  final String? photoUrl;

  const PhotoUploadSuccess(this.imageFile, {this.photoUrl});

  @override
  List<Object?> get props => [imageFile, photoUrl];
}

class PhotoUploadError extends PhotoUploadState {
  final String message;

  const PhotoUploadError(this.message);

  @override
  List<Object?> get props => [message];
}
