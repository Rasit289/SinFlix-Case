import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class TestApiConnectionUseCase {
  final AuthRepository repository;

  TestApiConnectionUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call() {
    return repository.testApiConnection();
  }
}
