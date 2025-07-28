import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../bloc/photo_upload_bloc.dart';
import '../bloc/photo_upload_state.dart';
import '../bloc/photo_upload_event.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/mixins/logger_mixin.dart';
import '../../../../../domain/usecases/upload_photo_usecase.dart';
import '../../../../../data/repositories/photo_upload_repository_impl.dart';
import '../../../../../data/datasources/photo_upload_remote_datasource.dart';
import '../../../../../core/services/token_storage_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PhotoUploadPage extends StatelessWidget with LoggerMixin {
  PhotoUploadPage({Key? key}) : super(key: key);

  void _showPhotoOptions(BuildContext context) {
    logUserAction('photo_options_modal_opened');
    final photoUploadBloc = context.read<PhotoUploadBloc>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              AppLocalizations.of(context)!.photoSelectTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Options
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      logUserAction('camera_option_selected');
                      Navigator.pop(context);
                      photoUploadBloc.add(TakePhoto());
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF333333),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[600]!),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context)!.camera,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      logUserAction('gallery_option_selected');
                      Navigator.pop(context);
                      photoUploadBloc.add(SelectPhoto());
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF333333),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[600]!),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.photo_library,
                            color: Colors.white,
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context)!.gallery,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    logInfo('PhotoUploadPage: build başladı');
    logUserAction('photo_upload_page_opened');

    return BlocProvider(
      create: (_) => PhotoUploadBloc(
        uploadPhotoUseCase: UploadPhotoUseCase(
          repository: PhotoUploadRepositoryImpl(
            remoteDataSource: PhotoUploadRemoteDataSourceImpl(
              dio: Dio(BaseOptions(
                baseUrl: 'https://caseapi.servicelabs.tech',
                connectTimeout: const Duration(seconds: 30),
                receiveTimeout: const Duration(seconds: 30),
              )),
              tokenStorageService: TokenStorageServiceImpl(),
            ),
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: BlocBuilder<PhotoUploadBloc, PhotoUploadState>(
            builder: (context, state) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
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
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                                padding: EdgeInsets.zero,
                              ),
                            ),
                            Container(width: 48), // Placeholder for symmetry
                          ],
                        ),
                        Center(
                          child: Text(
                            AppLocalizations.of(context)!.profileDetail,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: AppSizes.fontSizeL,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),

                    // Main Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            AppLocalizations.of(context)!.photoUploadTitle,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Description
                          Text(
                            AppLocalizations.of(context)!.photoUploadDesc,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Photo Upload Area
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                _showPhotoOptions(context);
                              },
                              child: Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF333333),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: state is PhotoUploadLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.loadingIndicator,
                                        ),
                                      )
                                    : state is PhotoUploadSuccess
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: state.photoUrl != null
                                                ? Image.network(
                                                    state.photoUrl!,
                                                    fit: BoxFit.cover,
                                                    loadingBuilder: (context,
                                                        child,
                                                        loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) return child;
                                                      return Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          value: loadingProgress
                                                                      .expectedTotalBytes !=
                                                                  null
                                                              ? loadingProgress
                                                                      .cumulativeBytesLoaded /
                                                                  loadingProgress
                                                                      .expectedTotalBytes!
                                                              : null,
                                                          color: Colors.white,
                                                        ),
                                                      );
                                                    },
                                                  )
                                                : Image.file(
                                                    state.imageFile,
                                                    fit: BoxFit.cover,
                                                  ),
                                          )
                                        : Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add,
                                                color: Colors.white,
                                                size: 60,
                                              ),
                                            ],
                                          ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Continue Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF0000),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: state is PhotoUploadSuccess
                            ? () async {
                                context
                                    .read<PhotoUploadBloc>()
                                    .add(UploadPhoto());

                                // Upload işlemini bekle
                                await Future.delayed(
                                    const Duration(seconds: 1));

                                // Eğer başarılı olduysa profil sayfasına dön
                                if (context.mounted) {
                                  final currentState =
                                      context.read<PhotoUploadBloc>().state;
                                  if (currentState is PhotoUploadSuccess &&
                                      currentState.photoUrl != null) {
                                    print(
                                        'PhotoUploadPage: Profil sayfasına dönülüyor, yeni photoUrl: ${currentState.photoUrl}');
                                    Navigator.of(context)
                                        .pop(currentState.photoUrl);
                                  }
                                }
                              }
                            : null,
                        child: Text(
                          AppLocalizations.of(context)!.continueButton,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppSizes.fontSizeL,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
