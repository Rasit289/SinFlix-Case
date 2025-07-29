import 'package:equatable/equatable.dart';

class MovieEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String? userTag;
  final String? userInitials;
  final bool isFavorite;
  final String? category;
  final double? rating;

  const MovieEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.userTag,
    this.userInitials,
    this.isFavorite = false,
    this.category,
    this.rating,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        imageUrl,
        userTag,
        userInitials,
        isFavorite,
        category,
        rating,
      ];

  MovieEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? userTag,
    String? userInitials,
    bool? isFavorite,
    String? category,
    double? rating,
  }) {
    return MovieEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      userTag: userTag ?? this.userTag,
      userInitials: userInitials ?? this.userInitials,
      isFavorite: isFavorite ?? this.isFavorite,
      category: category ?? this.category,
      rating: rating ?? this.rating,
    );
  }
}
