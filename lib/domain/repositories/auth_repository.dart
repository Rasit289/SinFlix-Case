import '../entities/user_entity.dart';
import '../../core/error/failures.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(String email, String password);
  Future<Either<Failure, UserEntity>> signup(
      String name, String email, String password);
  Future<Either<Failure, Map<String, dynamic>>> testApiConnection();
}
