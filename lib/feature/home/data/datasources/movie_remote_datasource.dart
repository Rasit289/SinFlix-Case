import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/mixins/logger_mixin.dart';
import '../models/movie_model.dart';

abstract class MovieRemoteDataSource {
  Future<Either<Failure, List<MovieModel>>> getMovies(
      {int page = 1, int limit = 5});
  Future<Either<Failure, MovieModel>> toggleFavorite(String movieId);
}

class MovieRemoteDataSourceImpl
    with LoggerMixin
    implements MovieRemoteDataSource {
  final Dio dio;
  final String baseUrl = 'https://caseapi.servicelabs.tech';

  MovieRemoteDataSourceImpl({required this.dio});

  @override
  Future<Either<Failure, List<MovieModel>>> getMovies(
      {int page = 1, int limit = 5}) async {
    try {
      logApiRequest(
          'GET', '$baseUrl/movies', null, {'page': page, 'limit': limit});

      final response = await dio.get(
        '$baseUrl/movies',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      logApiResponse(
          'GET', '$baseUrl/movies', response.statusCode ?? 0, response.data);

      if (response.statusCode == 200) {
        final List<dynamic> moviesData = response.data['data'] ?? [];
        final movies = moviesData
            .map((movieData) => MovieModel.fromJson(movieData))
            .toList();

        logInfo(
            'MovieRemoteDataSource: Filmler yüklendi - Sayfa: $page, Film sayısı: ${movies.length}');
        return Right(movies);
      } else {
        logApiError(
            'GET', '$baseUrl/movies', 'Status Code: ${response.statusCode}');
        return Left(
            ServerFailure('Failed to load movies: ${response.statusCode}'));
      }
    } catch (e) {
      logApiError('GET', '$baseUrl/movies', e);
      return Left(ServerFailure('Failed to load movies: $e'));
    }
  }

  @override
  Future<Either<Failure, MovieModel>> toggleFavorite(String movieId) async {
    try {
      logApiRequest('POST', '$baseUrl/movies/$movieId/toggle-favorite');

      final response = await dio.post(
        '$baseUrl/movies/$movieId/toggle-favorite',
      );

      logApiResponse('POST', '$baseUrl/movies/$movieId/toggle-favorite',
          response.statusCode ?? 0, response.data);

      if (response.statusCode == 200) {
        final movieData = response.data['data'];
        final movie = MovieModel.fromJson(movieData);

        logInfo(
            'MovieRemoteDataSource: Favori durumu güncellendi - Film: ${movie.title}');
        return Right(movie);
      } else {
        logApiError('POST', '$baseUrl/movies/$movieId/toggle-favorite',
            'Status Code: ${response.statusCode}');
        return Left(
            ServerFailure('Failed to toggle favorite: ${response.statusCode}'));
      }
    } catch (e) {
      logApiError('POST', '$baseUrl/movies/$movieId/toggle-favorite', e);
      return Left(ServerFailure('Failed to toggle favorite: $e'));
    }
  }
}
