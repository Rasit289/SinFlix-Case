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
    return MovieModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      userTag: json['userTag'],
      userInitials: json['userInitials'],
      isFavorite: json['isFavorite'] ?? false,
      category: json['category'],
      rating: json['rating']?.toDouble(),
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
