import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

class AuthViewModel {
  final AuthBloc authBloc;

  AuthViewModel(this.authBloc);

  void login(String email, String password) {
    authBloc.add(LoginRequested(email, password));
  }

  void signup(String name, String email, String password) {
    authBloc.add(SignupRequested(name, email, password));
  }
}
