import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../photo_upload/presentation/views/photo_upload_page.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_state.dart';
import '../bloc/profile_event.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/utils/image_utils.dart';
import '../../../../../core/mixins/logger_mixin.dart';
import 'package:dio/dio.dart';
import '../../../../../data/datasources/profile_remote_datasource.dart';
import '../../../../../core/services/token_storage_service.dart';
import '../../../../../../app.dart' show LocaleProvider;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePage extends StatelessWidget with LoggerMixin {
  ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logInfo('ProfilePage: build başladı');
    logUserAction('profile_page_opened');

    return BlocProvider(
      create: (_) => ProfileBloc(
        remoteDataSource: ProfileRemoteDataSourceImpl(
          dio: Dio(),
          tokenStorage: TokenStorageServiceImpl(),
        ),
      )..add(LoadProfile()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: GestureDetector(
              onTap: () {
                logUserAction('back_button_pressed',
                    {'from': 'profile_page', 'to': 'home_page'});
                logNavigation('profile_page', 'home_page');
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey[600]!,
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.profileDetail,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppSizes.fontSizeM,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            // Limited Offer butonu
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: GestureDetector(
                onTap: () {
                  logUserAction('limited_offer_button_pressed');
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const LimitedOfferBottomSheet(),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.errorButton,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.diamond,
                          color: AppColors.textPrimary, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        AppLocalizations.of(context)!.limitedOffer,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: AppSizes.fontSizeS,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Dil seçici
            IconButton(
              icon: const Icon(Icons.language, color: Colors.white),
              tooltip: 'Dil / Language',
              onPressed: () async {
                logUserAction('language_selector_pressed');
                final provider = context.read<LocaleProvider>();
                final currentLocale = provider.locale.languageCode;
                final selected = await showModalBottomSheet<Locale>(
                  context: context,
                  backgroundColor: Colors.black,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  builder: (context) => Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[700],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Dil Seç / Select Language',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildLangButton(
                                context, 'tr', 'Türkçe', currentLocale == 'tr'),
                            _buildLangButton(context, 'en', 'English',
                                currentLocale == 'en'),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                );
                if (selected != null) {
                  logUserAction('language_changed',
                      {'from': currentLocale, 'to': selected.languageCode});
                  provider.setLocale(selected);
                }
              },
            ),
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading || state is ProfileInitial) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProfileLoaded) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                          height:
                              10), // Sınırlı Teklif ile Profil Detayı arası boşluk
                      // Profile Info Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: AppColors.surface,
                            backgroundImage: (state.user.photoUrl.isNotEmpty &&
                                    state.user.photoUrl != 'null' &&
                                    state.user.photoUrl
                                        .trim()
                                        .startsWith('http'))
                                ? NetworkImage(state.user.photoUrl)
                                : null,
                            child: !(state.user.photoUrl.isNotEmpty &&
                                    state.user.photoUrl != 'null' &&
                                    state.user.photoUrl
                                        .trim()
                                        .startsWith('http'))
                                ? Icon(Icons.person,
                                    size: 32, color: AppColors.infoText)
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.user.name,
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: AppSizes.fontSizeM,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'ID: ${state.user.id}',
                                        style: TextStyle(
                                          color: AppColors.infoText,
                                          fontSize: AppSizes.fontSizeS,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                    width: 14), // ID ile buton arası boşluk
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.errorButton,
                                    foregroundColor: AppColors.textPrimary,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  onPressed: () async {
                                    logUserAction(
                                        'photo_upload_button_pressed');
                                    logNavigation(
                                        'profile_page', 'photo_upload_page');

                                    final result =
                                        await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => PhotoUploadPage(),
                                      ),
                                    );

                                    // Eğer yeni fotoğraf URL'si döndüyse profil sayfasını güncelle
                                    if (result != null && result is String) {
                                      logInfo(
                                          'ProfilePage: Yeni fotograf URL alindi: $result');
                                      logUserAction('profile_photo_updated',
                                          {'photoUrl': result});
                                      // ProfileBloc'a yeni fotoğraf URL'sini gönder
                                      context
                                          .read<ProfileBloc>()
                                          .add(UpdateProfilePhoto(result));
                                    }
                                  },
                                  child: Text(
                                      AppLocalizations.of(context)!.addPhoto,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: AppSizes.fontSizeS)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        AppLocalizations.of(context)!.profileTab,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: AppSizes.fontSizeM,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Liked Movies Grid
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 56),
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 18,
                              mainAxisSpacing: 22,
                              childAspectRatio: 0.72,
                            ),
                            itemCount: state.likedMovies.length,
                            itemBuilder: (context, index) {
                              final movie = state.likedMovies[index];
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(
                                      28), // Daha büyük köşe
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(28),
                                        child: Image.network(
                                          ImageUtils.fixImageUrl(
                                              movie.imageUrl),
                                          width: double.infinity,
                                          height: 210, // Daha büyük resim
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Container(
                                            color: Colors.transparent,
                                            height: 210,
                                            child: Icon(Icons.broken_image,
                                                color: AppColors.infoText,
                                                size: 48),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: Text(
                                        movie.title,
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: AppSizes.fontSizeM,
                                        ),
                                        maxLines: 2,
                                        softWrap: true,
                                        overflow: TextOverflow.visible,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is ProfileError) {
                return Center(child: Text(state.message));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

class LimitedOfferBottomSheet extends StatelessWidget {
  const LimitedOfferBottomSheet({Key? key}) : super(key: key);

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
              style: TextStyle(
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
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _BonusIconText(
                          icon: Icons.diamond,
                          label: AppLocalizations.of(context)!.premiumAccount,
                          bgColor: Color(0xFFD32F2F)),
                      _BonusIconText(
                          label: AppLocalizations.of(context)!.moreMatches,
                          doubleHeart: true,
                          bgColor: Color(0xFFD32F2F)),
                      _BonusIconText(
                          icon: Icons.arrow_upward,
                          label: AppLocalizations.of(context)!.promote,
                          bgColor: Color(0xFFD32F2F)),
                      _BonusIconText(
                          icon: Icons.favorite,
                          label: AppLocalizations.of(context)!.moreLikes,
                          bgColor: Color(0xFFD32F2F)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.unlockNewEpisodes,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _JetonCard(
                  color: const Color(0xFFD32F2F),
                  badge: AppLocalizations.of(context)!.bonus10,
                  old: '200',
                  current: '330',
                  price: '₺99,99',
                  badgeType: JetonBadgeType.grayRed,
                ),
                _JetonCard(
                  color: const Color(0xFF7B1FA2),
                  badge: AppLocalizations.of(context)!.bonus70,
                  old: '2.000',
                  current: '3.375',
                  price: '₺799,99',
                  highlight: true,
                  badgeType: JetonBadgeType.bluePurple,
                ),
                _JetonCard(
                  color: const Color(0xFFD32F2F),
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum JetonBadgeType { grayRed, bluePurple }

class _BonusIconText extends StatelessWidget {
  final IconData? icon;
  final Widget? custom;
  final String label;
  final bool doubleHeart;
  final Color? bgColor;
  const _BonusIconText(
      {this.icon,
      this.custom,
      required this.label,
      this.doubleHeart = false,
      this.bgColor});
  @override
  Widget build(BuildContext context) {
    Widget iconWidget;
    if (doubleHeart) {
      iconWidget = Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            backgroundColor: bgColor ?? Colors.white.withOpacity(0.15),
            radius: 24,
            child: Icon(Icons.favorite, color: Colors.white, size: 28),
          ),
          Positioned(
            right: 8,
            bottom: 8,
            child: CircleAvatar(
              backgroundColor:
                  bgColor?.withOpacity(0.7) ?? Colors.white.withOpacity(0.18),
              radius: 12,
              child: Icon(Icons.favorite,
                  color: Colors.white.withOpacity(0.7), size: 16),
            ),
          ),
        ],
      );
    } else if (custom != null) {
      iconWidget = custom!;
    } else {
      iconWidget = CircleAvatar(
        backgroundColor: bgColor ?? Colors.white.withOpacity(0.15),
        radius: 24,
        child: Icon(icon, color: Colors.white, size: 28),
      );
    }
    return Column(
      children: [
        iconWidget,
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _JetonCard extends StatelessWidget {
  final Color color;
  final String badge;
  final String old;
  final String current;
  final String price;
  final bool highlight;
  final JetonBadgeType badgeType;
  const _JetonCard({
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
                    ? [const Color(0xFF7B1FA2), const Color(0xFF512DA8)]
                    : [color, color.withOpacity(0.85)],
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
              child: _JetonBadge(
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

class _JetonBadge extends StatelessWidget {
  final String badge;
  final JetonBadgeType type;
  const _JetonBadge({required this.badge, required this.type});
  @override
  Widget build(BuildContext context) {
    if (type == JetonBadgeType.bluePurple) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7B1FA2), Color(0xFFD32F2F)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.18),
              blurRadius: 8,
              offset: const Offset(0, 2),
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
          color: const Color(0xFFD32F2F),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.18),
              blurRadius: 8,
              offset: const Offset(0, 2),
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

Widget _buildLangButton(
    BuildContext context, String code, String label, bool selected) {
  return Expanded(
    child: GestureDetector(
      onTap: () => Navigator.pop(context, Locale(code)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: selected ? Colors.red : Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? Colors.red : Colors.grey[700]!,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : Colors.grey[200],
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            if (selected)
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(Icons.check, color: Colors.white, size: 18),
              ),
          ],
        ),
      ),
    ),
  );
}
