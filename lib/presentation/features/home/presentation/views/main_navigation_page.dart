import 'package:flutter/material.dart';
import 'home_page.dart';
import '../../../../../presentation/features/profile/presentation/views/profile_page.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_strings.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({Key? key}) : super(key: key);

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          _pages[_currentIndex],
          Positioned(
            bottom: AppSizes.paddingM,
            left: 0,
            right: 0,
            child: Container(
              width: 300,
              height: AppSizes.buttonHeight,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(AppSizes.buttonHeight / 2),
              ),
              child: Center(
                child: Container(
                  width: 300,
                  height: AppSizes.buttonHeight,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius:
                        BorderRadius.circular(AppSizes.buttonHeight / 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTabButton(
                        icon: Icons.home_filled,
                        label: AppStrings.homeTab,
                        isSelected: _currentIndex == 0,
                        onTap: () => setState(() => _currentIndex = 0),
                      ),
                      SizedBox(width: AppSizes.paddingL),
                      _buildTabButton(
                        icon: Icons.person,
                        label: AppStrings.profileTab,
                        isSelected: _currentIndex == 1,
                        onTap: () => setState(() => _currentIndex = 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 130, // Reduced width
        height: AppSizes.buttonHeight * 0.75, // Slightly smaller height
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: AppColors.border,
            width: 0.8,
          ),
          borderRadius: BorderRadius.circular(AppSizes.buttonHeight * 0.375),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppColors.textPrimary,
              size: AppSizes.fontSizeL, // Smaller icon
            ),
            SizedBox(width: AppSizes.paddingXS),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: AppSizes.fontSizeS, // Smaller text
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
