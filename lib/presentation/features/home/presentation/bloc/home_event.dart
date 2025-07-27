import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadMovies extends HomeEvent {
  final int page;
  final bool isRefresh;

  const LoadMovies({this.page = 1, this.isRefresh = false});

  @override
  List<Object?> get props => [page, isRefresh];
}

class ToggleFavorite extends HomeEvent {
  final String movieId;

  const ToggleFavorite(this.movieId);

  @override
  List<Object?> get props => [movieId];
}

class RefreshMovies extends HomeEvent {}
