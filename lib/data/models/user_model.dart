import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  final String? password; // Sadece localde eşleşme için, API döndürüyorsa ekle

  UserModel({
    required String id,
    required String name,
    required String email,
    this.password,
    String photoUrl = '',
  }) : super(id: id, name: name, email: email, photoUrl: photoUrl);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'], // API döndürüyorsa
      photoUrl: json['photoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'photoUrl': photoUrl,
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      photoUrl: entity.photoUrl,
    );
  }
}
