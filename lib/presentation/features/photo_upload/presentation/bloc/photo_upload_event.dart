import 'package:equatable/equatable.dart';

abstract class PhotoUploadEvent extends Equatable {
  const PhotoUploadEvent();

  @override
  List<Object?> get props => [];
}

class SelectPhoto extends PhotoUploadEvent {}

class TakePhoto extends PhotoUploadEvent {}

class UploadPhoto extends PhotoUploadEvent {}
