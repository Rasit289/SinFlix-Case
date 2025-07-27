import 'package:equatable/equatable.dart';
import '../../../../../domain/entities/movie_entity.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {
  final bool isRefresh;

  const HomeLoading({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

class HomeLoaded extends HomeState {
  final List<MovieEntity> movies;
  final bool hasReachedMax;
  final int currentPage;

  const HomeLoaded({
    required this.movies,
    this.hasReachedMax = false,
    this.currentPage = 1,
  });

  @override
  List<Object?> get props => [movies, hasReachedMax, currentPage];

  HomeLoaded copyWith({
    List<MovieEntity>? movies,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return HomeLoaded(
      movies: movies ?? this.movies,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}

class FavoriteToggled extends HomeState {
  final MovieEntity movie;

  const FavoriteToggled(this.movie);

  @override
  List<Object?> get props => [movie];
}
