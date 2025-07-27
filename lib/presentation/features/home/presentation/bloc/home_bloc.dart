import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../domain/usecases/get_movies_usecase.dart';
import '../../../../../domain/usecases/toggle_favorite_usecase.dart';
import '../../../../../domain/usecases/refresh_movies_usecase.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../domain/entities/movie_entity.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
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
    if (event.isRefresh) {
      emit(const HomeLoading(isRefresh: true));
    } else if (state is HomeInitial) {
      emit(const HomeLoading());
    }

    try {
      final result = await getMoviesUseCase(page: event.page, limit: 5);

      result.fold(
        (failure) => emit(HomeError(failure.message)),
        (newMovies) {
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
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onToggleFavorite(
      ToggleFavorite event, Emitter<HomeState> emit) async {
    try {
      final result = await toggleFavoriteUseCase(event.movieId);

      result.fold(
        (failure) => emit(HomeError(failure.message)),
        (updatedMovie) {
          if (state is HomeLoaded) {
            final currentState = state as HomeLoaded;
            final updatedMovies = currentState.movies.map((movie) {
              return movie.id == event.movieId ? updatedMovie : movie;
            }).toList();

            emit(HomeLoaded(
              movies: updatedMovies,
              currentPage: currentState.currentPage,
              hasReachedMax: currentState.hasReachedMax,
            ));
          }

          emit(FavoriteToggled(updatedMovie));
        },
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onRefreshMovies(
      RefreshMovies event, Emitter<HomeState> emit) async {
    try {
      final result = await refreshMoviesUseCase();

      result.fold(
        (failure) => emit(HomeError(failure.message)),
        (movies) => emit(HomeLoaded(
          movies: movies,
          currentPage: 1,
          hasReachedMax: movies.length < 5,
        )),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
