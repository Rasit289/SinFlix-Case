import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../domain/entities/user_entity.dart';
import '../../../../../domain/entities/movie_entity.dart';
import '../../../../../core/mixins/logger_mixin.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import '../../../../../data/datasources/profile_remote_datasource.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> with LoggerMixin {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileBloc({required this.remoteDataSource}) : super(ProfileInitial()) {
    on<LoadProfile>((event, emit) async {
      logStateChange('ProfileBloc', 'LoadProfile');
      emit(ProfileLoading());

      final profileResult = await remoteDataSource.getProfile();
      final moviesResult = await remoteDataSource.getFavoriteMovies();

      profileResult.fold(
        (failure) {
          logError('ProfileBloc: Profil yükleme hatası', failure);
          emit(ProfileError(failure.message));
        },
        (user) {
          moviesResult.fold(
            (failure) {
              logError('ProfileBloc: Favori filmler yükleme hatası', failure);
              emit(ProfileError(failure.message));
            },
            (movies) {
              logInfo(
                  'ProfileBloc: Profil ve favori filmler yüklendi - Kullanıcı: ${user.name}, Film sayısı: ${movies.length}');
              emit(ProfileLoaded(user: user, likedMovies: movies));
            },
          );
        },
      );
    });

    on<UpdateProfilePhoto>((event, emit) async {
      logStateChange(
          'ProfileBloc', 'UpdateProfilePhoto', {'photoUrl': event.photoUrl});
      final currentState = state;
      if (currentState is ProfileLoaded) {
        // Mevcut user'ı güncelle
        final updatedUser = UserEntity(
          id: currentState.user.id,
          name: currentState.user.name,
          email: currentState.user.email,
          photoUrl: event.photoUrl, // Yeni fotoğraf URL'si
        );

        logInfo(
            'ProfileBloc: Profil fotoğrafı güncellendi - Kullanıcı: ${updatedUser.name}');
        // Güncellenmiş state'i emit et
        emit(ProfileLoaded(
            user: updatedUser, likedMovies: currentState.likedMovies));
      } else {
        logWarning(
            'ProfileBloc: State ProfileLoaded değil, fotoğraf güncellenemiyor');
      }
    });
  }
}
