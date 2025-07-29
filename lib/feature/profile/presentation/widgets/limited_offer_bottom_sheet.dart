import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'bonus_icon_text.dart';
import 'jeton_card.dart';

/// Limited Offer bottom sheet widget
/// Displays premium subscription options with bonus features
class LimitedOfferBottomSheet extends StatelessWidget {
  const LimitedOfferBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2B0A0A), // Daha koyu kırmızı
            Color(0xFF1A1A1A), // Siyah
          ],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.limitedOffer,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.limitedOfferDescription,
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!.bonusEarned,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BonusIconText(
                        imagePath: 'assets/images/premium.png',
                        label: AppLocalizations.of(context)!.premiumAccount,
                      ),
                      BonusIconText(
                        imagePath: 'assets/images/more_match.png',
                        label: AppLocalizations.of(context)!.moreMatches,
                      ),
                      BonusIconText(
                        imagePath: 'assets/images/highlight.png',
                        label: AppLocalizations.of(context)!.promote,
                      ),
                      BonusIconText(
                        imagePath: 'assets/images/more_like.png',
                        label: AppLocalizations.of(context)!.moreLikes,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.unlockNewEpisodes,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                JetonCard(
                  color: const Color(0xFFB71C1C),
                  badge: AppLocalizations.of(context)!.bonus10,
                  old: '200',
                  current: '330',
                  price: '₺99,99',
                  badgeType: JetonBadgeType.grayRed,
                ),
                JetonCard(
                  color: const Color(0xFF5949E6),
                  badge: AppLocalizations.of(context)!.bonus70,
                  old: '2.000',
                  current: '3.375',
                  price: '₺799,99',
                  highlight: true,
                  badgeType: JetonBadgeType.bluePurple,
                ),
                JetonCard(
                  color: const Color(0xFFB71C1C),
                  badge: AppLocalizations.of(context)!.bonus35,
                  old: '1.000',
                  current: '1.350',
                  price: '₺399,99',
                  badgeType: JetonBadgeType.grayRed,
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  AppLocalizations.of(context)!.viewAllTokens,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
