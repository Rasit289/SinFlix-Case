import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {}

class UpdateProfilePhoto extends ProfileEvent {
  final String photoUrl;

  const UpdateProfilePhoto(this.photoUrl);

  @override
  List<Object?> get props => [photoUrl];
}
