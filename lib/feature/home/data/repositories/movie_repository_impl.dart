import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/movie_entity.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_remote_datasource.dart';
import '../models/movie_model.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;

  MovieRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<MovieEntity>>> getMovies(
      {int page = 1, int limit = 5}) async {
    final result = await remoteDataSource.getMovies(page: page, limit: limit);
    return result
        .map((movies) => movies.map((movie) => movie as MovieEntity).toList());
  }

  @override
  Future<Either<Failure, MovieEntity>> toggleFavorite(String movieId) async {
    final result = await remoteDataSource.toggleFavorite(movieId);
    return result.map((movie) => movie as MovieEntity);
  }

  @override
  Future<Either<Failure, List<MovieEntity>>> refreshMovies() async {
    // Refresh by getting first page
    return getMovies(page: 1, limit: 5);
  }
}
