import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../core/services/token_storage_service.dart';
import '../../domain/entities/movie_entity.dart';

abstract class ProfileRemoteDataSource {
  Future<Either<Failure, UserEntity>> getProfile();
  Future<Either<Failure, List<MovieEntity>>> getFavoriteMovies();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;
  final TokenStorageService tokenStorage;
  final String baseUrl = 'https://caseapi.servicelabs.tech';

  ProfileRemoteDataSourceImpl({required this.dio, required this.tokenStorage});

  @override
  Future<Either<Failure, UserEntity>> getProfile() async {
    try {
      final token = await tokenStorage.getToken();
      final response = await dio.get(
        '$baseUrl/user/profile',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        return Right(UserEntity(
          id: data['id'] ?? '',
          name: data['name'] ?? '',
          email: data['email'] ?? '',
          photoUrl: data['photoUrl'] ?? '',
        ));
      } else {
        return Left(
            ServerFailure('Failed to load profile: ${response.statusCode}'));
      }
    } catch (e) {
      return Left(ServerFailure('Failed to load profile: $e'));
    }
  }

  @override
  Future<Either<Failure, List<MovieEntity>>> getFavoriteMovies() async {
    try {
      final token = await tokenStorage.getToken();
      final response = await dio.get(
        '$baseUrl/movie/favorites',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      print('FavoriteMovies: Response status: ${response.statusCode}');
      print('FavoriteMovies: Response data: ${response.data}');
      if (response.statusCode == 200) {
        final moviesData = response.data['data'] as List? ?? [];
        print('FavoriteMovies: moviesData length: ${moviesData.length}');
        final movies = moviesData
            .map((m) => MovieEntity(
                  id: m['id'] ?? m['_id'] ?? '',
                  title: m['title'] ?? m['Title'] ?? '',
                  description: m['description'] ?? m['Plot'] ?? '',
                  imageUrl: m['imageUrl'] ?? m['Poster'] ?? '',
                  isFavorite: true,
                  category: m['Genre'] ?? '',
                  rating:
                      double.tryParse(m['imdbRating']?.toString() ?? '') ?? 0.0,
                ))
            .toList();
        print('FavoriteMovies: parsed movies length: ${movies.length}');
        return Right(movies);
      } else {
        return Left(ServerFailure(
            'Failed to load favorite movies: ${response.statusCode}'));
      }
    } catch (e) {
      print('FavoriteMovies: Error: $e');
      return Left(ServerFailure('Failed to load favorite movies: $e'));
    }
  }
}
