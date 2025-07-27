import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/usecases/login_usecase.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;

  LoginBloc({required this.loginUseCase}) : super(LoginInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LoginReset>(_onLoginReset);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<LoginState> emit,
  ) async {
    print('LoginBloc: LoginRequested for email: ${event.email}');
    emit(LoginLoading());

    final result = await loginUseCase(event.email, event.password);

    result.fold(
      (failure) {
        print('LoginBloc: Login failed: ${failure.message}');
        emit(LoginFailure(failure.message));
      },
      (user) {
        print('LoginBloc: Login success for user: ${user.name}');
        emit(LoginSuccess(user));
      },
    );
  }

  void _onLoginReset(
    LoginReset event,
    Emitter<LoginState> emit,
  ) {
    emit(LoginInitial());
  }
}
