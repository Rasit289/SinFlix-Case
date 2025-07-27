import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, UserEntity>> signup(
      String name, String email, String password) async {
    final result = await remoteDataSource.register(
        name: name, email: email, password: password);
    return result.map((data) => data['user'] as UserModel);
  }

  @override
  Future<Either<Failure, UserEntity>> login(
      String email, String password) async {
    final result =
        await remoteDataSource.login(email: email, password: password);
    return result.map((data) => data['user'] as UserModel);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> testApiConnection() async {
    return await remoteDataSource.testApiConnection();
  }
}
