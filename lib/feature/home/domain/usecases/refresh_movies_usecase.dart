import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/movie_entity.dart';
import '../repositories/movie_repository.dart';

class RefreshMoviesUseCase {
  final MovieRepository repository;

  RefreshMoviesUseCase(this.repository);

  Future<Either<Failure, List<MovieEntity>>> call() {
    return repository.refreshMovies();
  }
}
