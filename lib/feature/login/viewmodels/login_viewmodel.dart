import 'package:flutter/material.dart';
import '../blocs/login_bloc.dart';
import '../blocs/login_event.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginBloc loginBloc;

  LoginViewModel(this.loginBloc);

  void login(String email, String password) {
    print('LoginViewModel: login called with email: $email');
    loginBloc.add(LoginRequested(email: email, password: password));
  }

  void reset() {
    loginBloc.add(LoginReset());
  }
}
