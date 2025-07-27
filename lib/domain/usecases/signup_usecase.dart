import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';
import '../../core/error/failures.dart';
import 'package:dartz/dartz.dart';

class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(
      String name, String email, String password) {
    return repository.signup(name, email, password);
  }
}
