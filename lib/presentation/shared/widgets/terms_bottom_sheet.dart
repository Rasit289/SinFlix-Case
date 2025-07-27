import 'package:flutter/material.dart';
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
                    'Kullanıcı Sözleşmesi',
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
                      'Son Güncelleme: 26 Temmuz 2025',
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
                    '1. Hizmet Kullanımı',
                    style: TextStyle(
                      color: context.textPrimary,
                      fontSize: AppSizes.fontSizeM,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingS),
                  Text(
                    'Bu uygulamayı kullanarak, aşağıdaki şartları kabul etmiş sayılırsınız. Uygulamamız, kullanıcılarımıza en iyi deneyimi sunmak için sürekli olarak geliştirilmektedir.',
                    style: TextStyle(
                      color: context.textSecondary,
                      fontSize: AppSizes.fontSizeS,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: AppSizes.paddingL),

                  Text(
                    '2. Kullanıcı Sorumlulukları',
                    style: TextStyle(
                      color: context.textPrimary,
                      fontSize: AppSizes.fontSizeM,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingS),
                  Text(
                    '• Hesap bilgilerinizi güvenli tutmak sizin sorumluluğunuzdadır.\n• Uygulamayı yasal amaçlar için kullanmalısınız.\n• Diğer kullanıcıların haklarına saygı göstermelisiniz.\n• Spam veya zararlı içerik paylaşmamalısınız.',
                    style: TextStyle(
                      color: context.textSecondary,
                      fontSize: AppSizes.fontSizeS,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: AppSizes.paddingL),

                  Text(
                    '3. Gizlilik Politikası',
                    style: TextStyle(
                      color: context.textPrimary,
                      fontSize: AppSizes.fontSizeM,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingS),
                  Text(
                    'Kişisel verileriniz, gizlilik politikamız kapsamında korunmaktadır. Verileriniz sadece hizmet kalitesini artırmak ve güvenliği sağlamak amacıyla kullanılmaktadır.',
                    style: TextStyle(
                      color: context.textSecondary,
                      fontSize: AppSizes.fontSizeS,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: AppSizes.paddingL),

                  Text(
                    '4. Hizmet Değişiklikleri',
                    style: TextStyle(
                      color: context.textPrimary,
                      fontSize: AppSizes.fontSizeM,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingS),
                  Text(
                    'Hizmetlerimizi geliştirmek için zaman zaman değişiklikler yapabiliriz. Bu değişiklikler önceden duyurulacak ve kullanıcılarımız bilgilendirilecektir.',
                    style: TextStyle(
                      color: context.textSecondary,
                      fontSize: AppSizes.fontSizeS,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: AppSizes.paddingL),

                  Text(
                    '5. İletişim',
                    style: TextStyle(
                      color: context.textPrimary,
                      fontSize: AppSizes.fontSizeM,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingS),
                  Text(
                    'Sorularınız veya önerileriniz için bizimle iletişime geçebilirsiniz:\n\nEmail: support@sinflix.com\nTelefon: +90 212 XXX XX XX',
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
