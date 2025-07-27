import 'package:flutter/material.dart';
import '../blocs/signup_bloc.dart';
import '../blocs/signup_event.dart';

class SignupViewModel extends ChangeNotifier {
  final SignupBloc signupBloc;

  SignupViewModel(this.signupBloc);

  void signup(String name, String email, String password) {
    signupBloc.add(SignupRequested(
      name: name,
      email: email,
      password: password,
    ));
  }

  void reset() {
    signupBloc.add(SignupReset());
  }
}
