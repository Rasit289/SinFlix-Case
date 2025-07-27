import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../models/movie_model.dart';
import '../models/movie_response_model.dart';

abstract class MovieRemoteDataSource {
  Future<Either<Failure, MovieResponseModel>> getMovies({int page = 1});
  Future<Either<Failure, MovieModel>> toggleFavorite(String movieId);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final Dio dio;
  final String baseUrl = 'https://caseapi.servicelabs.tech';

  MovieRemoteDataSourceImpl({required this.dio});

  @override
  Future<Either<Failure, MovieResponseModel>> getMovies({int page = 1}) async {
    try {
      print(
          'MovieDataSource: Making API call to $baseUrl/movie/list with page: $page');

      final response = await dio.get(
        '$baseUrl/movie/list',
        queryParameters: {
          'page': page,
        },
      );

      print('MovieDataSource: Response status: ${response.statusCode}');
      print('MovieDataSource: Response data: ${response.data}');

      if (response.statusCode == 200) {
        final responseModel = MovieResponseModel.fromJson(response.data);
        print('MovieDataSource: Parsed ${responseModel.movies.length} movies');
        return Right(responseModel);
      } else {
        return Left(
            ServerFailure('Failed to load movies: ${response.statusCode}'));
      }
    } catch (e) {
      print('MovieDataSource: Error: $e');
      return Left(ServerFailure('Failed to load movies: $e'));
    }
  }

  @override
  Future<Either<Failure, MovieModel>> toggleFavorite(String movieId) async {
    try {
      final response = await dio.post(
        '$baseUrl/movie/favorite/$movieId',
      );

      if (response.statusCode == 200) {
        final movieData = response.data;

        final movie = MovieModel(
          id: movieData['id'] ?? movieId,
          title: movieData['title'] ?? '',
          description: movieData['description'] ?? '',
          imageUrl: movieData['posterUrl'] ?? '',
          userTag: 'TM',
          userInitials: 'TM',
          isFavorite: movieData['isFavorite'] ?? false,
          category: 'Drama',
          rating: 4.0,
        );

        return Right(movie);
      } else {
        return Left(
            ServerFailure('Failed to toggle favorite: ${response.statusCode}'));
      }
    } catch (e) {
      return Left(ServerFailure('Failed to toggle favorite: $e'));
    }
  }
}
