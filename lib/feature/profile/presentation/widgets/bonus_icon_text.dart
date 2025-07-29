import 'package:flutter/material.dart';

/// Bonus icon with text widget
/// Displays bonus feature icons with labels
class BonusIconText extends StatelessWidget {
  final IconData? icon;
  final Widget? custom;
  final String label;
  final bool doubleHeart;
  final Color? bgColor;
  final String? imagePath;

  const BonusIconText({
    super.key,
    this.icon,
    this.custom,
    required this.label,
    this.doubleHeart = false,
    this.bgColor,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    Widget iconWidget;

    if (imagePath != null) {
      // Image usage with limited_offer_background.png background
      iconWidget = Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage('assets/images/limited_offer_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Image.asset(
          imagePath!,
          width: 48,
          height: 48,
        ),
      );
    } else if (doubleHeart) {
      iconWidget = Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF8B0000), // Dark red background
          boxShadow: [
            BoxShadow(
              color:
                  const Color(0xFFD32F2F).withOpacity(0.4), // Red glow effect
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Icon(
          Icons.favorite,
          color: Colors.white,
          size: 28,
        ),
      );
    } else if (custom != null) {
      iconWidget = custom!;
    } else {
      iconWidget = Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF8B0000), // Dark red background
          boxShadow: [
            BoxShadow(
              color:
                  const Color(0xFFD32F2F).withOpacity(0.4), // Red glow effect
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white, // White color
          size: 28,
        ),
      );
    }

    return Column(
      children: [
        iconWidget,
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
      ],
    );
  }
}
