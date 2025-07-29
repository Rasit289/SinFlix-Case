import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../../domain/entities/movie_entity.dart';
import '../../../../../core/constants/app_sizes.dart';

class MovieCard extends StatefulWidget {
  final MovieEntity movie;

  final VoidCallback onFavoriteToggle;

  final VoidCallback? onTap;

  const MovieCard({
    Key? key,
    required this.movie,
    required this.onFavoriteToggle,
    this.onTap,
  }) : super(key: key);

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  bool showLottie = false;

  void _onFavoritePressed() async {
    widget.onFavoriteToggle();
    setState(() => showLottie = true);
    await Future.delayed(const Duration(milliseconds: 2000));
    setState(() => showLottie = false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: widget.onTap,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: AppSizes.paddingM),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.radiusL),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusL),
              child: Stack(
                children: [
                  // Movie Image
                  Container(
                    width: double.infinity,
                    height: 400,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.movie.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // User Tag Badge
                  if (widget.movie.userTag != null)
                    Positioned(
                      top: AppSizes.paddingM,
                      left: AppSizes.paddingM,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.paddingM,
                          vertical: AppSizes.paddingS,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(AppSizes.radiusM),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.white,
                              child: Text(
                                widget.movie.userInitials ?? 'U',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSizes.paddingS),
                            Text(
                              widget.movie.userTag!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Movie Info Overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(AppSizes.paddingL),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.8),
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title and Category Icon
                          Row(
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: AppSizes.paddingM),
                              Expanded(
                                child: Text(
                                  widget.movie.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: AppSizes.paddingS),

                          // Description
                          Text(
                            widget.movie.description,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            icon: Icon(
              widget.movie.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: _onFavoritePressed,
          ),
        ),
        // Lottie animasyonu en üste alındı
        if (showLottie)
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: Lottie.asset(
                  'assets/animations/Heart_fav.json',
                  width: 120,
                  height: 120,
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
          ),
      ],
    );
  }
}
