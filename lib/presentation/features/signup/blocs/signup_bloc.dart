import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/usecases/signup_usecase.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignupUseCase signupUseCase;

  SignupBloc({required this.signupUseCase}) : super(SignupInitial()) {
    on<SignupRequested>(_onSignupRequested);
    on<SignupReset>(_onSignupReset);
  }

  Future<void> _onSignupRequested(
    SignupRequested event,
    Emitter<SignupState> emit,
  ) async {
    emit(SignupLoading());

    final result = await signupUseCase(event.name, event.email, event.password);

    result.fold(
      (failure) => emit(SignupFailure(failure.message)),
      (user) => emit(SignupSuccess(user)),
    );
  }

  void _onSignupReset(
    SignupReset event,
    Emitter<SignupState> emit,
  ) {
    emit(SignupInitial());
  }
}
