import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../domain/usecases/get_movies_usecase.dart';
import '../../../../../domain/usecases/toggle_favorite_usecase.dart';
import '../../../../../domain/usecases/refresh_movies_usecase.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../domain/entities/movie_entity.dart';
import '../../../../../core/mixins/logger_mixin.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> with LoggerMixin {
  final GetMoviesUseCase getMoviesUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;
  final RefreshMoviesUseCase refreshMoviesUseCase;

  HomeBloc({
    required this.getMoviesUseCase,
    required this.toggleFavoriteUseCase,
    required this.refreshMoviesUseCase,
  }) : super(HomeInitial()) {
    on<LoadMovies>(_onLoadMovies);
    on<ToggleFavorite>(_onToggleFavorite);
    on<RefreshMovies>(_onRefreshMovies);
  }

  Future<void> _onLoadMovies(LoadMovies event, Emitter<HomeState> emit) async {
    logStateChange('HomeBloc', 'LoadMovies',
        {'page': event.page, 'isRefresh': event.isRefresh});

    if (event.isRefresh) {
      emit(const HomeLoading(isRefresh: true));
    } else if (state is HomeInitial) {
      emit(const HomeLoading());
    }

    try {
      final result = await getMoviesUseCase(page: event.page, limit: 5);

      result.fold(
        (failure) {
          logError('HomeBloc: Film yükleme hatası', failure);
          emit(HomeError(failure.message));
        },
        (newMovies) {
          logInfo(
              'HomeBloc: Filmler yüklendi - Sayfa: ${event.page}, Film sayısı: ${newMovies.length}');
          if (state is HomeLoaded) {
            final currentState = state as HomeLoaded;
            final updatedMovies = [...currentState.movies, ...newMovies];

            emit(HomeLoaded(
              movies: updatedMovies,
              currentPage: event.page,
              hasReachedMax: newMovies.length < 5,
            ));
          } else {
            emit(HomeLoaded(
              movies: newMovies,
              currentPage: event.page,
              hasReachedMax: newMovies.length < 5,
            ));
          }
        },
      );
    } catch (e) {
      logError('HomeBloc: Beklenmeyen hata', e);
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onToggleFavorite(
      ToggleFavorite event, Emitter<HomeState> emit) async {
    try {
      logStateChange('HomeBloc', 'ToggleFavorite', {'movieId': event.movieId});
      final currentState = state;
      final result = await toggleFavoriteUseCase(event.movieId);

      result.fold(
        (failure) {
          logError('HomeBloc: Favori değiştirme hatası', failure);
          emit(HomeError(failure.message));
        },
        (updatedMovie) {
          logInfo(
              'HomeBloc: Favori durumu güncellendi - Film: ${updatedMovie.title}');
          if (currentState is HomeLoaded) {
            final updatedMovies = currentState.movies.map((movie) {
              if (movie.id == event.movieId) {
                // Sadece isFavorite alanını güncelle, diğer alanları koru
                return movie.copyWith(isFavorite: updatedMovie.isFavorite);
              }
              return movie;
            }).toList();
            logInfo(
                'HomeBloc: Film listesi güncellendi - Toplam film: ${updatedMovies.length}');
            emit(HomeLoaded(
              movies: updatedMovies,
              currentPage: currentState.currentPage,
              hasReachedMax: currentState.hasReachedMax,
            ));
          } else {
            logWarning(
                'HomeBloc: State HomeLoaded değil, filmler güncellenemiyor');
          }
        },
      );
    } catch (e) {
      logError('HomeBloc: Favori değiştirme beklenmeyen hata', e);
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onRefreshMovies(
      RefreshMovies event, Emitter<HomeState> emit) async {
    try {
      logStateChange('HomeBloc', 'RefreshMovies');
      emit(const HomeLoading(isRefresh: true));

      // İlk sayfayı yeniden yükle
      final result = await getMoviesUseCase(page: 1, limit: 5);

      result.fold(
        (failure) {
          logError('HomeBloc: Refresh hatası', failure);
          emit(HomeError(failure.message));
        },
        (movies) {
          logInfo(
              'HomeBloc: Refresh tamamlandı - Film sayısı: ${movies.length}');
          emit(HomeLoaded(
            movies: movies,
            currentPage: 1,
            hasReachedMax: movies.length < 5,
          ));
        },
      );
    } catch (e) {
      logError('HomeBloc: Refresh beklenmeyen hata', e);
      emit(HomeError(e.toString()));
    }
  }
}
