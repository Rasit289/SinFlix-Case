import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../models/movie_model.dart';

abstract class MovieRemoteDataSource {
  Future<Either<Failure, List<MovieModel>>> getMovies(
      {int page = 1, int limit = 5});
  Future<Either<Failure, MovieModel>> toggleFavorite(String movieId);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final Dio dio;
  final String baseUrl = 'https://caseapi.servicelabs.tech';

  MovieRemoteDataSourceImpl({required this.dio});

  @override
  Future<Either<Failure, List<MovieModel>>> getMovies(
      {int page = 1, int limit = 5}) async {
    try {
      // Simulated API call - in real app, this would be an actual API endpoint
      await Future.delayed(
          const Duration(milliseconds: 800)); // Simulate network delay

      // Mock data for demonstration
      final mockMovies = _generateMockMovies(page, limit);

      return Right(mockMovies);
    } catch (e) {
      return Left(ServerFailure('Failed to load movies: $e'));
    }
  }

  @override
  Future<Either<Failure, MovieModel>> toggleFavorite(String movieId) async {
    try {
      // Simulated API call
      await Future.delayed(const Duration(milliseconds: 300));

      // Mock response - in real app, this would update the server
      final mockMovie = _generateMockMovie(movieId);

      return Right(mockMovie);
    } catch (e) {
      return Left(ServerFailure('Failed to toggle favorite: $e'));
    }
  }

  List<MovieModel> _generateMockMovies(int page, int limit) {
    final movies = <MovieModel>[];
    final startIndex = (page - 1) * limit;

    for (int i = 0; i < limit; i++) {
      final index = startIndex + i;
      movies.add(_generateMockMovie('movie_$index'));
    }

    return movies;
  }

  MovieModel _generateMockMovie(String id) {
    final titles = [
      'Günahkar Adam',
      'Karanlık Gece',
      'Aşk ve İntikam',
      'Son Umut',
      'Kayıp Şehir',
      'Gizli Plan',
      'Yıldızlar Arası',
      'Son Savaş',
      'Unutulmaz Anılar',
      'Yeni Başlangıç'
    ];

    final descriptions = [
      'Community every territories dogpile so. Last they investigation model Daha Fazlası',
      'A gripping tale of love and betrayal in the modern world.',
      'An epic journey through time and space.',
      'The story of one man\'s quest for redemption.',
      'A mysterious adventure that will change everything.',
    ];

    final imageUrls = [
      'https://picsum.photos/400/600?random=${id.hashCode}',
      'https://picsum.photos/400/600?random=${id.hashCode + 1}',
      'https://picsum.photos/400/600?random=${id.hashCode + 2}',
    ];

    final userTags = ['TM', 'AB', 'CD', 'EF', 'GH'];
    final userInitials = ['TM', 'AB', 'CD', 'EF', 'GH'];

    return MovieModel(
      id: id,
      title: titles[id.hashCode % titles.length],
      description: descriptions[id.hashCode % descriptions.length],
      imageUrl: imageUrls[id.hashCode % imageUrls.length],
      userTag: userTags[id.hashCode % userTags.length],
      userInitials: userInitials[id.hashCode % userInitials.length],
      isFavorite: id.hashCode % 3 == 0, // Random favorite status
      category: 'Drama',
      rating: 4.0 + (id.hashCode % 10) / 10, // Random rating between 4.0-4.9
    );
  }
}
