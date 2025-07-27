import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../domain/entities/movie_entity.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 1;
  int _currentMovieIndex = 0;
  Map<String, bool> _expandedTexts = {}; // Track which texts are expanded

  @override
  void initState() {
    super.initState();
    // Load initial movies
    context.read<HomeBloc>().add(const LoadMovies(page: 1));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentMovieIndex = index;
    });

    // Load more movies when user reaches near the end
    final state = context.read<HomeBloc>().state;
    if (state is HomeLoaded) {
      final totalMovies = state.movies.length;
      final moviesPerPage = 5;

      // If user is at 80% of loaded movies, load next page
      if (index >= totalMovies * 0.8 && !state.hasReachedMax) {
        _currentPage++;
        context.read<HomeBloc>().add(LoadMovies(page: _currentPage));
      }
    }
  }

  void _toggleTextExpansion(String movieId) {
    setState(() {
      _expandedTexts[movieId] = !(_expandedTexts[movieId] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.errorButton,
              ),
            );
          }
          if (state is FavoriteToggled) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.movie.title} favorilere eklendi'),
                backgroundColor: AppColors.success,
              ),
            );
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeInitial || state is HomeLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.loadingIndicator,
                ),
              );
            }

            if (state is HomeLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  _currentPage = 1;
                  _currentMovieIndex = 0;
                  context.read<HomeBloc>().add(RefreshMovies());
                },
                color: AppColors.loadingIndicator,
                backgroundColor: AppColors.loadingIndicatorBackground,
                child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  onPageChanged: _onPageChanged,
                  itemCount:
                      state.movies.length + (state.hasReachedMax ? 0 : 1),
                  itemBuilder: (context, index) {
                    if (index >= state.movies.length) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.loadingIndicator,
                        ),
                      );
                    }

                    final movie = state.movies[index];
                    return _buildMovieCard(movie);
                  },
                ),
              );
            }

            if (state is HomeError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: AppSizes.fontSizeXXL * 2,
                      color: AppColors.errorIcon,
                    ),
                    const SizedBox(height: AppSizes.paddingL),
                    Text(
                      AppStrings.homeErrorTitle,
                      style: TextStyle(
                        color: AppColors.errorText,
                        fontSize: AppSizes.fontSizeL,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSizes.paddingM),
                    Text(
                      state.message,
                      style: TextStyle(
                        color: AppColors.infoText,
                        fontSize: AppSizes.fontSizeM,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.paddingXL),
                    ElevatedButton(
                      onPressed: () {
                        _currentPage = 1;
                        _currentMovieIndex = 0;
                        context.read<HomeBloc>().add(const LoadMovies(page: 1));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.errorButton,
                        foregroundColor: AppColors.errorButtonText,
                      ),
                      child: Text(AppStrings.homeErrorRetry),
                    ),
                  ],
                ),
              );
            }

            return Center(
              child: Text(
                AppStrings.homeUnknown,
                style: TextStyle(color: AppColors.unknownText),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMovieCard(MovieEntity movie) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Stack(
        children: [
          // Movie poster with full width
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.radiusL),
              image: DecorationImage(
                image: NetworkImage(movie.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Gradient overlay for better text visibility and smooth transition
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.radiusL),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.movieCardGradient1,
                  AppColors.movieCardGradient2,
                  AppColors.movieCardGradient3,
                  AppColors.movieCardGradient4,
                  AppColors.movieCardGradient5,
                ],
                stops: [0.0, 0.6, 0.75, 0.85, 1.0],
              ),
            ),
          ),

          // Favorite button
          Positioned(
            right: AppSizes.paddingL,
            bottom: 245, // TODO: AppSizes ile merkezi yönetim
            child: GestureDetector(
              onTap: () {
                context.read<HomeBloc>().add(ToggleFavorite(movie.id));
              },
              child: Container(
                width: 48, // TODO: AppSizes ile merkezi yönetim
                height: 64, // TODO: AppSizes ile merkezi yönetim
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(32), // TODO: AppSizes
                  border: Border.all(
                    color: AppColors.favoriteBorder,
                    width: 1,
                  ),
                ),
                child: Icon(
                  movie.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: AppColors.favoriteIcon,
                  size: AppSizes.fontSizeXL,
                ),
              ),
            ),
          ),

          // Movie details overlay on the image
          Positioned(
            bottom: 100, // TODO: AppSizes ile merkezi yönetim
            left: AppSizes.paddingL,
            right: AppSizes.paddingL,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Custom icon from assets
                    ClipOval(
                      child: Image.asset(
                        'assets/images/movies_logo.png',
                        width: 40, // TODO: AppSizes
                        height: 40, // TODO: AppSizes
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(width: AppSizes.paddingM),
                    // Movie title
                    Expanded(
                      child: Text(
                        movie.title,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: AppSizes.fontSizeL,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.paddingS),
                // Movie description with expandable text
                GestureDetector(
                  onTap: () => _toggleTextExpansion(movie.id),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: AppColors.infoText,
                        fontSize: AppSizes.fontSizeM,
                      ),
                      children: [
                        TextSpan(
                          text: _expandedTexts[movie.id] == true
                              ? movie.description
                              : movie.description.length > 80
                                  ? '${movie.description.substring(0, 80)}... '
                                  : movie.description,
                        ),
                        if (movie.description.length > 80)
                          TextSpan(
                            text: _expandedTexts[movie.id] == true
                                ? ' ${AppStrings.homeLess}'
                                : AppStrings.homeMore,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
