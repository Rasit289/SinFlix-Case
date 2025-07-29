import 'package:equatable/equatable.dart';
import '../../../../../domain/entities/user_entity.dart';
import '../../../../../domain/entities/movie_entity.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserEntity user;
  final List<MovieEntity> likedMovies;

  const ProfileLoaded({required this.user, required this.likedMovies});

  @override
  List<Object?> get props => [user, likedMovies];
}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
