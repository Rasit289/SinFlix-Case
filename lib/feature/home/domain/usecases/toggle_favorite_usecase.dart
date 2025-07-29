import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/movie_entity.dart';
import '../repositories/movie_repository.dart';

class ToggleFavoriteUseCase {
  final MovieRepository repository;

  ToggleFavoriteUseCase(this.repository);

  Future<Either<Failure, MovieEntity>> call(String movieId) {
    return repository.toggleFavorite(movieId);
  }
}
