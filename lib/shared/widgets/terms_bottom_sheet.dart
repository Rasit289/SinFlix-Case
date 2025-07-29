import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../theme/app_theme.dart';

class TermsBottomSheet extends StatelessWidget {
  const TermsBottomSheet({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const TermsBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: context.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSizes.radiusL),
          topRight: Radius.circular(AppSizes.radiusL),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingL),
            decoration: BoxDecoration(
              color: context.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppSizes.radiusL),
                topRight: Radius.circular(AppSizes.radiusL),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.description_outlined,
                  color: context.primary,
                  size: 24,
                ),
                const SizedBox(width: AppSizes.paddingM),
                Expanded(
                  child: Text(
                    loc.termsTitle,
                    style: TextStyle(
                      color: context.textPrimary,
                      fontSize: AppSizes.fontSizeL,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close,
                    color: context.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Last Updated
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingM,
                      vertical: AppSizes.paddingS,
                    ),
                    decoration: BoxDecoration(
                      color: context.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusS),
                    ),
                    child: Text(
                      loc.termsLastUpdate,
                      style: TextStyle(
                        color: context.primary,
                        fontSize: AppSizes.fontSizeS,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingL),
                  // Terms Content
                  Text(
                    loc.termsSection1Title,
                    style: TextStyle(
                      color: context.textPrimary,
                      fontSize: AppSizes.fontSizeM,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingS),
                  Text(
                    loc.termsSection1Body,
                    style: TextStyle(
                      color: context.textSecondary,
                      fontSize: AppSizes.fontSizeS,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingL),
                  Text(
                    loc.termsSection2Title,
                    style: TextStyle(
                      color: context.textPrimary,
                      fontSize: AppSizes.fontSizeM,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingS),
                  Text(
                    loc.termsSection2Body,
                    style: TextStyle(
                      color: context.textSecondary,
                      fontSize: AppSizes.fontSizeS,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingL),
                  Text(
                    loc.termsSection3Title,
                    style: TextStyle(
                      color: context.textPrimary,
                      fontSize: AppSizes.fontSizeM,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingS),
                  Text(
                    loc.termsSection3Body,
                    style: TextStyle(
                      color: context.textSecondary,
                      fontSize: AppSizes.fontSizeS,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingL),
                  Text(
                    loc.termsSection4Title,
                    style: TextStyle(
                      color: context.textPrimary,
                      fontSize: AppSizes.fontSizeM,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingS),
                  Text(
                    loc.termsSection4Body,
                    style: TextStyle(
                      color: context.textSecondary,
                      fontSize: AppSizes.fontSizeS,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingL),
                  Text(
                    loc.termsSection5Title,
                    style: TextStyle(
                      color: context.textPrimary,
                      fontSize: AppSizes.fontSizeM,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingS),
                  Text(
                    loc.termsSection5Body,
                    style: TextStyle(
                      color: context.textSecondary,
                      fontSize: AppSizes.fontSizeS,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingXXL),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
