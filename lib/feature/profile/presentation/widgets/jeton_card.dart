import 'package:flutter/material.dart';

/// Badge type enum for jeton cards
enum JetonBadgeType { bluePurple, grayRed }

/// Jeton card widget
/// Displays subscription package with pricing and bonus information
class JetonCard extends StatelessWidget {
  final Color color;
  final String badge;
  final String old;
  final String current;
  final String price;
  final bool highlight;
  final JetonBadgeType badgeType;

  const JetonCard({
    super.key,
    required this.color,
    required this.badge,
    required this.old,
    required this.current,
    required this.price,
    this.highlight = false,
    required this.badgeType,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: highlight
                    ? [
                        const Color(0xFF5949E6), // Mavi (#5949E6)
                        const Color(0xFFE50914), // Kırmızı (#E50914)
                      ]
                    : [
                        color, // Kırmızı
                        color.withOpacity(0.7), // Daha koyu kırmızı
                      ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                if (highlight)
                  const BoxShadow(
                    color: Color(0xFF7B1FA2),
                    blurRadius: 16,
                    spreadRadius: 1,
                    offset: Offset(0, 4),
                  ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 18),
                Text(
                  old,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  current,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Jeton',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Text(
                  price,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    fontFamily: 'Montserrat', // Montserrat font
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Başına haftalık',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          Positioned(
            top: -14,
            left: 0,
            right: 0,
            child: Center(
              child: JetonBadge(
                badge: badge,
                type: badgeType,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Jeton badge widget
/// Displays bonus percentage with colored background
class JetonBadge extends StatelessWidget {
  final String badge;
  final JetonBadgeType type;

  const JetonBadge({
    super.key,
    required this.badge,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    if (type == JetonBadgeType.bluePurple) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF5949E6), // Blue badge (#5949E6)
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white, width: 0.5), // Thinner border
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF5949E6).withOpacity(0.4), // Blue shadow
              blurRadius: 12,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          badge,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFB71C1C), // Darker red badge
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white, width: 0.5), // Thinner border
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFB71C1C).withOpacity(0.4), // Red shadow
              blurRadius: 12,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          badge,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      );
    }
  }
}
