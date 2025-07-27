import '../../domain/entities/movie_entity.dart';

class MovieModel extends MovieEntity {
  const MovieModel({
    required String id,
    required String title,
    required String description,
    required String imageUrl,
    String? userTag,
    String? userInitials,
    bool isFavorite = false,
    String? category,
    double? rating,
  }) : super(
          id: id,
          title: title,
          description: description,
          imageUrl: imageUrl,
          userTag: userTag,
          userInitials: userInitials,
          isFavorite: isFavorite,
          category: category,
          rating: rating,
        );

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    // Helper function to safely convert to double
    double? parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) {
        try {
          return double.parse(value);
        } catch (e) {
          return null;
        }
      }
      return null;
    }

    return MovieModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      title: json['Title'] ?? json['title'] ?? '',
      description: json['Plot'] ?? json['description'] ?? '',
      imageUrl: json['Poster'] ?? json['posterUrl'] ?? '',
      userTag: json['userTag'] ?? 'TM', // Default value
      userInitials: json['userInitials'] ?? 'TM', // Default value
      isFavorite: json['isFavorite'] ?? false,
      category: json['Genre'] ?? json['category'] ?? 'Drama', // Default value
      rating: parseDouble(json['imdbRating']) ??
          parseDouble(json['rating']) ??
          4.0, // Default value
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'userTag': userTag,
      'userInitials': userInitials,
      'isFavorite': isFavorite,
      'category': category,
      'rating': rating,
    };
  }

  factory MovieModel.fromEntity(MovieEntity entity) {
    return MovieModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      imageUrl: entity.imageUrl,
      userTag: entity.userTag,
      userInitials: entity.userInitials,
      isFavorite: entity.isFavorite,
      category: entity.category,
      rating: entity.rating,
    );
  }
}
