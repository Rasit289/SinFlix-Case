import 'movie_model.dart';

class MovieResponseModel {
  final List<MovieModel> movies;
  final int totalPages;
  final int currentPage;

  MovieResponseModel({
    required this.movies,
    required this.totalPages,
    required this.currentPage,
  });

  factory MovieResponseModel.fromJson(Map<String, dynamic> json) {
    // Handle the nested response structure
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final moviesData = data['movies'] as List? ?? [];

    final movies =
        moviesData.map((movieData) => MovieModel.fromJson(movieData)).toList();

    return MovieResponseModel(
      movies: movies,
      totalPages: data['totalPages'] ?? 0,
      currentPage: data['currentPage'] ?? 0,
    );
  }
}
