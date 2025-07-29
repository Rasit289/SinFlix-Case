import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/services/token_storage_service.dart';
import '../../../core/services/jwt_service.dart';
import '../../../domain/entities/user_entity.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthStatus extends AuthEvent {}

class LoginSuccess extends AuthEvent {
  final String token;
  final UserEntity user;

  const LoginSuccess({required this.token, required this.user});

  @override
  List<Object?> get props => [token, user];
}

class Logout extends AuthEvent {}

class TokenExpired extends AuthEvent {}

// States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserEntity user;
  final String token;

  const Authenticated({required this.user, required this.token});

  @override
  List<Object?> get props => [user, token];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final TokenStorageService tokenStorage;

  AuthBloc({required this.tokenStorage}) : super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LoginSuccess>(_onLoginSuccess);
    on<Logout>(_onLogout);
    on<TokenExpired>(_onTokenExpired);
  }

  Future<void> _onCheckAuthStatus(
      CheckAuthStatus event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final token = await tokenStorage.getToken();

      if (token == null) {
        emit(Unauthenticated());
        return;
      }

      // Check if token is expired
      if (JwtService.isTokenExpired(token)) {
        await tokenStorage.clearAllAuthData();
        emit(Unauthenticated());
        return;
      }

      // Extract user data from token
      final userData = JwtService.getUserData(token);
      if (userData == null) {
        await tokenStorage.clearAllAuthData();
        emit(Unauthenticated());
        return;
      }

      final user = UserEntity(
        id: userData['id']?.toString() ?? '',
        name: userData['name']?.toString() ?? '',
        email: userData['email']?.toString() ?? '',
      );

      emit(Authenticated(user: user, token: token));
    } catch (e) {
      emit(AuthError('Authentication check failed: $e'));
    }
  }

  Future<void> _onLoginSuccess(
      LoginSuccess event, Emitter<AuthState> emit) async {
    try {
      print(
          'AuthBloc: LoginSuccess event received for user: ${event.user.name}');
      await tokenStorage.saveToken(event.token);
      print('AuthBloc: Token saved, emitting Authenticated state');
      emit(Authenticated(user: event.user, token: event.token));
    } catch (e) {
      print('AuthBloc: Error in LoginSuccess: $e');
      emit(AuthError('Failed to save authentication data: $e'));
    }
  }

  Future<void> _onLogout(Logout event, Emitter<AuthState> emit) async {
    try {
      await tokenStorage.clearAllAuthData();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError('Logout failed: $e'));
    }
  }

  Future<void> _onTokenExpired(
      TokenExpired event, Emitter<AuthState> emit) async {
    try {
      await tokenStorage.clearAllAuthData();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError('Token expiration handling failed: $e'));
    }
  }
}
