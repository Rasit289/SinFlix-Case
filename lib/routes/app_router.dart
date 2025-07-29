import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../feature/login/views/login_page.dart';
import '../feature/login/blocs/login_bloc.dart';
import '../feature/login/viewmodels/login_viewmodel.dart';
import '../feature/signup/views/signup_page.dart';
import '../feature/signup/blocs/signup_bloc.dart';
import '../feature/signup/viewmodels/signup_viewmodel.dart';
import '../shared/widgets/splash_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/splash':
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case '/login':
        return MaterialPageRoute(
          builder: (_) => LoginPage(
            viewModel:
                LoginViewModel(BlocProvider.of<LoginBloc>(_ as BuildContext)),
          ),
        );
      case '/signup':
        return MaterialPageRoute(
          builder: (_) => SignupPage(
            viewModel:
                SignupViewModel(BlocProvider.of<SignupBloc>(_ as BuildContext)),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Route not found!'),
            ),
          ),
        );
    }
  }
}
