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
import 'package:sinflix/feature/home/presentation/views/main_navigation_page.dart';

// Import separated widgets
import '../widgets/limited_offer_bottom_sheet.dart';
import '../widgets/language_button.dart';

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
                    {'from': 'profile_page', 'to': 'main_navigation_page'});
                logNavigation('profile_page', 'main_navigation_page');
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const MainNavigationPage()),
                  (route) => false,
                );
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
