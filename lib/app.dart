import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'core/services/firebase_service.dart';
import 'presentation/shared/theme/app_theme.dart';
import 'routes/app_router.dart';
import 'presentation/features/login/views/login_page.dart';
import 'presentation/features/login/blocs/login_bloc.dart';
import 'presentation/features/login/viewmodels/login_viewmodel.dart';
import 'presentation/features/signup/views/signup_page.dart';
import 'presentation/features/signup/blocs/signup_bloc.dart';
import 'presentation/features/signup/viewmodels/signup_viewmodel.dart';
import 'presentation/shared/blocs/auth_bloc.dart';
import 'presentation/shared/widgets/splash_screen.dart';
import 'presentation/features/home/presentation/views/main_navigation_page.dart';
import 'presentation/features/home/presentation/bloc/home_bloc.dart';
import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/signup_usecase.dart';
import 'domain/usecases/test_api_connection_usecase.dart';
import 'domain/usecases/get_movies_usecase.dart';
import 'domain/usecases/toggle_favorite_usecase.dart';
import 'domain/usecases/refresh_movies_usecase.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/movie_repository_impl.dart';
import 'data/datasources/auth_remote_datasource.dart';
import 'data/datasources/movie_remote_datasource.dart';
import 'core/services/token_storage_service.dart';
import 'core/services/auth_interceptor.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('tr');
  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!['en', 'tr'].contains(locale.languageCode)) return;
    _locale = locale;
    notifyListeners();
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize Firebase
    FirebaseService.initialize();
    // Initialize services
    final tokenStorage = TokenStorageServiceImpl();
    final dio = Dio();

    // Add auth interceptor to Dio
    dio.interceptors.add(AuthInterceptor(
      tokenStorage: tokenStorage,
      dio: dio,
    ));

    // Initialize data layer
    final authRemoteDataSource = AuthRemoteDataSourceImpl(
      dio: dio,
      tokenStorage: tokenStorage,
    );
    final movieRemoteDataSource = MovieRemoteDataSourceImpl(dio: dio);

    final authRepository = AuthRepositoryImpl(authRemoteDataSource);
    final movieRepository = MovieRepositoryImpl(movieRemoteDataSource);

    final loginUseCase = LoginUseCase(authRepository);
    final signupUseCase = SignupUseCase(authRepository);
    final testApiConnectionUseCase = TestApiConnectionUseCase(authRepository);
    final getMoviesUseCase = GetMoviesUseCase(movieRepository);
    final toggleFavoriteUseCase = ToggleFavoriteUseCase(movieRepository);
    final refreshMoviesUseCase = RefreshMoviesUseCase(movieRepository);

    // Test API connection on app start
    testApiConnectionUseCase().then((result) {
      result.fold(
        (failure) => print('API Test Failed: ${failure.message}'),
        (data) => print(
            'API Test Success: ${data['endpoint']} - Status: ${data['status']}'),
      );
    });

    return MultiBlocProvider(
      providers: [
        // Global auth bloc
        BlocProvider<AuthBloc>(
          create: (context) =>
              AuthBloc(tokenStorage: tokenStorage)..add(CheckAuthStatus()),
        ),
        // Feature blocs
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(loginUseCase: loginUseCase),
        ),
        BlocProvider<SignupBloc>(
          create: (context) => SignupBloc(signupUseCase: signupUseCase),
        ),
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(
            getMoviesUseCase: getMoviesUseCase,
            toggleFavoriteUseCase: toggleFavoriteUseCase,
            refreshMoviesUseCase: refreshMoviesUseCase,
          ),
        ),
      ],
      child: ChangeNotifierProvider(
        create: (_) => LocaleProvider(),
        child: Consumer<LocaleProvider>(
          builder: (context, localeProvider, child) {
            return MaterialApp(
              title: 'Sinflix',
              theme: AppTheme.darkTheme,
              debugShowCheckedModeBanner: false,
              onGenerateRoute: AppRouter.generateRoute,
              locale: localeProvider.locale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en'),
                Locale('tr'),
              ],
              home: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  print('App: Current AuthBloc state: ${state.runtimeType}');

                  if (state is AuthLoading) {
                    print('App: Showing loading screen');
                    return const Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (state is Authenticated) {
                    // User is authenticated, show main navigation page
                    print(
                        'App: User authenticated, showing MainNavigationPage');
                    return const MainNavigationPage();
                  }

                  // User is not authenticated, show splash screen first
                  print('App: User not authenticated, showing SplashScreen');
                  return const SplashScreen();
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
