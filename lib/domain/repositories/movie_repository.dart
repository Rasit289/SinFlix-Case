import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/movie_entity.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<MovieEntity>>> getMovies(
      {int page = 1, int limit = 5});
  Future<Either<Failure, MovieEntity>> toggleFavorite(String movieId);
  Future<Either<Failure, List<MovieEntity>>> refreshMovies();
}
