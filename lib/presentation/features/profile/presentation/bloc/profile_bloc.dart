import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../domain/entities/user_entity.dart';
import '../../../../../domain/entities/movie_entity.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import '../../../../../data/datasources/profile_remote_datasource.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileBloc({required this.remoteDataSource}) : super(ProfileInitial()) {
    on<LoadProfile>((event, emit) async {
      emit(ProfileLoading());
      final profileResult = await remoteDataSource.getProfile();
      final moviesResult = await remoteDataSource.getFavoriteMovies();
      profileResult.fold(
        (failure) => emit(ProfileError(failure.message)),
        (user) {
          moviesResult.fold(
            (failure) => emit(ProfileError(failure.message)),
            (movies) => emit(ProfileLoaded(user: user, likedMovies: movies)),
          );
        },
      );
    });

    on<UpdateProfilePhoto>((event, emit) async {
      final currentState = state;
      if (currentState is ProfileLoaded) {
        // Mevcut user'ı güncelle
        final updatedUser = UserEntity(
          id: currentState.user.id,
          name: currentState.user.name,
          email: currentState.user.email,
          photoUrl: event.photoUrl, // Yeni fotoğraf URL'si
        );

        // Güncellenmiş state'i emit et
        emit(ProfileLoaded(
            user: updatedUser, likedMovies: currentState.likedMovies));
      }
    });
  }
}
