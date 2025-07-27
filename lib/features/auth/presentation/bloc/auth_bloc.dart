import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/usecases/login_usecase.dart';
import '../../../../domain/usecases/signup_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SignupUseCase signupUseCase;

  AuthBloc({required this.loginUseCase, required this.signupUseCase})
      : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final result = await loginUseCase(event.email, event.password);
        result.fold(
          (failure) => emit(AuthFailure(failure.message)),
          (user) => emit(AuthSuccess()),
        );
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<SignupRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final result =
            await signupUseCase(event.name, event.email, event.password);
        result.fold(
          (failure) => emit(AuthFailure(failure.message)),
          (user) => emit(AuthSuccess()),
        );
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
