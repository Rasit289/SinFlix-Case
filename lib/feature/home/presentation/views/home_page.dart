import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../domain/entities/movie_entity.dart';
import '../../../../../core/utils/image_utils.dart';
import '../../../../../core/mixins/logger_mixin.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with LoggerMixin {
  final PageController _pageController = PageController();
  int _currentPage = 1;
  int _currentMovieIndex = 0;
  Map<String, bool> _expandedTexts = {}; // Track which texts are expanded
  Map<String, bool> _localFavorites = {}; // Anlık favori güncelleme için

  // Lottie animasyonu için state
  bool showLottie = false;
  Offset? lottiePosition;

  @override
  void initState() {
    super.initState();
    logInfo('HomePage: initState başladı');
    logUserAction('home_page_opened');
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

    logUserAction(
        'page_changed', {'index': index, 'currentPage': _currentPage});

    // Load more movies when user reaches near the end
    final state = context.read<HomeBloc>().state;
    if (state is HomeLoaded) {
      final totalMovies = state.movies.length;
      final moviesPerPage = 5;

      // If user is at 80% of loaded movies, load next page
      if (index >= totalMovies * 0.8 && !state.hasReachedMax) {
        _currentPage++;
        logInfo('HomePage: Yeni sayfa yükleniyor - Page: $_currentPage');
        context.read<HomeBloc>().add(LoadMovies(page: _currentPage));
      }
    }
  }

  void _toggleTextExpansion(String movieId) {
    setState(() {
      _expandedTexts[movieId] = !(_expandedTexts[movieId] ?? false);
    });
    logUserAction('text_expansion_toggled',
        {'movieId': movieId, 'isExpanded': _expandedTexts[movieId]});
  }

  void showFavoriteSnackbar(
    BuildContext context, {
    required bool added,
    required String movieTitle,
  }) {
    final color = added ? Colors.green[600] : Colors.red[600];
    final icon = added ? Icons.favorite : Icons.favorite_border;
    final iconColor = added ? Colors.red : Colors.white;
    final text = added
        ? '$movieTitle favorilere eklendi'
        : '$movieTitle favorilerden çıkarıldı';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        duration: const Duration(seconds: 2),
        elevation: 8,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
                      logInfo('HomePage: Pull-to-refresh başladı');
                      logUserAction('pull_to_refresh');
                      _currentPage = 1;
                      _currentMovieIndex = 0;
                      _pageController.jumpToPage(0);
                      context.read<HomeBloc>().add(RefreshMovies());
                      // Refresh işleminin tamamlanmasını bekle
                      await Future.delayed(const Duration(milliseconds: 500));
                    },
                    color: AppColors.loadingIndicator,
                    backgroundColor: AppColors.loadingIndicatorBackground,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: PageView.builder(
                          controller: _pageController,
                          scrollDirection: Axis.vertical,
                          onPageChanged: _onPageChanged,
                          itemCount: state.movies.length +
                              (state.hasReachedMax ? 0 : 1),
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
                      ),
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
                          AppLocalizations.of(context)!.homeErrorTitle,
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
                            context
                                .read<HomeBloc>()
                                .add(const LoadMovies(page: 1));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.errorButton,
                            foregroundColor: AppColors.errorButtonText,
                          ),
                          child: Text(
                              AppLocalizations.of(context)!.homeErrorRetry),
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
        ),
        if (showLottie)
          Center(
            child: IgnorePointer(
              child: Lottie.asset(
                'assets/animations/Heart_fav.json',
                width: 220,
                height: 220,
                repeat: false,
                onLoaded: (composition) {
                  debugPrint(
                      'Lottie loaded: duration = ${composition.duration}');
                },
                onWarning: (warning) {
                  debugPrint('Lottie warning: ${warning.toString()}');
                },
                errorBuilder: (context, error, stackTrace) {
                  debugPrint('Lottie error: ${error.toString()}');
                  return Container(
                    color: Colors.red.withOpacity(0.7),
                    child: const Text(
                      'Animasyon yüklenemedi',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMovieCard(MovieEntity movie) {
    final isFavorite = _localFavorites[movie.id] ?? movie.isFavorite;
    return LayoutBuilder(
      builder: (context, constraints) {
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
                    image: NetworkImage(ImageUtils.fixImageUrl(movie.imageUrl)),
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
                  onTap: () async {
                    logUserAction('favorite_toggled', {
                      'movieId': movie.id,
                      'movieTitle': movie.title,
                      'previousState': isFavorite,
                      'newState': !isFavorite,
                    });
                    setState(() {
                      _localFavorites[movie.id] = !isFavorite;
                    });
                    showFavoriteSnackbar(
                      context,
                      added: !isFavorite,
                      movieTitle: movie.title,
                    );
                    // Sadece favorilere eklenince animasyonu göster
                    if (!isFavorite) {
                      setState(() {
                        showLottie = true;
                      });
                      await Future.delayed(const Duration(milliseconds: 1200));
                      setState(() => showLottie = false);
                    }
                    context.read<HomeBloc>().add(ToggleFavorite(movie.id));
                  },
                  child: Container(
                    width: 48,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: AppColors.favoriteBorder,
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: AppColors.favoriteIcon,
                      size: AppSizes.fontSizeXL,
                    ),
                  ),
                ),
              ),

              // Movie details overlay on the image
              Positioned(
                bottom: 100,
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
                                    ? ' ${AppLocalizations.of(context)!.homeLess}'
                                    : AppLocalizations.of(context)!.homeMore,
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
      },
    );
  }
}
