import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/movie_entity.dart';
import '../repositories/movie_repository.dart';

class GetMoviesUseCase {
  final MovieRepository repository;

  GetMoviesUseCase(this.repository);

  Future<Either<Failure, List<MovieEntity>>> call(
      {int page = 1, int limit = 5}) {
    return repository.getMovies(page: page, limit: limit);
  }
}
