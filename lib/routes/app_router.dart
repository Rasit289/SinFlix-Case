import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../presentation/features/login/views/login_page.dart';
import '../presentation/features/login/blocs/login_bloc.dart';
import '../presentation/features/login/viewmodels/login_viewmodel.dart';
import '../presentation/features/signup/views/signup_page.dart';
import '../presentation/features/signup/blocs/signup_bloc.dart';
import '../presentation/features/signup/viewmodels/signup_viewmodel.dart';
import '../presentation/shared/widgets/splash_screen.dart';

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
