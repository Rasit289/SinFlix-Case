import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../app.dart' show LocaleProvider;
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/blocs/auth_bloc.dart' as global_auth;
import '../../home/presentation/views/main_navigation_page.dart';
import '../blocs/login_bloc.dart';
import '../blocs/login_event.dart';
import '../blocs/login_state.dart';
import '../viewmodels/login_viewmodel.dart';

class LoginPage extends StatefulWidget {
  final LoginViewModel viewModel;

  const LoginPage({Key? key, required this.viewModel}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const SizedBox.shrink(),
        actions: [
          IconButton(
            icon: const Icon(Icons.language, color: Colors.white),
            tooltip: 'Dil / Language',
            onPressed: () async {
              final provider = context.read<LocaleProvider>();
              final currentLocale = provider.locale.languageCode;
              final selected = await showModalBottomSheet<Locale>(
                context: context,
                backgroundColor: Colors.black,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                          _buildLangButton(
                              context, 'en', 'English', currentLocale == 'en'),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              );
              if (selected != null) {
                provider.setLocale(selected);
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<LoginBloc, LoginState>(
        bloc: widget.viewModel.loginBloc,
        builder: (context, state) {
          if (state is LoginLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: context.primary,
              ),
            );
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header Section
                  Text(
                    AppLocalizations.of(context)!.loginTitle,
                    style: TextStyle(
                      color: context.textPrimary,
                      fontSize: AppSizes.fontSizeXXL,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: AppSizes.paddingM),

                  Text(
                    AppLocalizations.of(context)!.loginSubtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: context.textSecondary,
                      fontSize: AppSizes.fontSizeM,
                    ),
                  ),

                  const SizedBox(height: AppSizes.paddingXXL),

                  // Form Section
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Email Field
                      CustomTextField(
                        controller: emailController,
                        hintText: AppLocalizations.of(context)!.emailHint,
                        prefixIcon: Icons.email,
                        onChanged: (value) {
                          if (state is LoginFailure) {
                            widget.viewModel.reset();
                          }
                        },
                      ),

                      const SizedBox(height: AppSizes.paddingM),

                      // Password Field
                      CustomTextField(
                        controller: passwordController,
                        hintText: AppLocalizations.of(context)!.passwordHint,
                        prefixIcon: Icons.lock,
                        obscureText: _obscurePassword,
                        suffixIcon: _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        onSuffixIconPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        onChanged: (value) {
                          if (state is LoginFailure) {
                            widget.viewModel.reset();
                          }
                        },
                      ),

                      const SizedBox(height: AppSizes.paddingM),

                      // Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            AppLocalizations.of(context)!.forgotPassword,
                            style: TextStyle(
                              color: context.primary,
                              fontSize: AppSizes.fontSizeS,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: AppSizes.paddingM),

                      // Login Button
                      CustomButton(
                        text: AppLocalizations.of(context)!.loginButton,
                        onPressed: () {
                          widget.viewModel.login(
                              emailController.text, passwordController.text);

                          // Eğer login başarılı olursa hemen ana sayfaya geçiş yapalım
                          Future.delayed(const Duration(seconds: 1), () {
                            if (mounted) {
                              print(
                                  'LoginPage: Attempting navigation from button');
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const MainNavigationPage(),
                                ),
                              );
                            }
                          });
                        },
                      ),

                      const SizedBox(height: AppSizes.paddingXL),

                      // Social Login Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildSocialButton('G', () {}),
                          _buildSocialButton('', () {}, icon: Icons.apple),
                          _buildSocialButton('f', () {}),
                        ],
                      ),

                      const SizedBox(height: AppSizes.paddingXXL),

                      // Signup Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.noAccount,
                            style: TextStyle(color: context.textSecondary),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed('/signup');
                            },
                            child: Text(
                              AppLocalizations.of(context)!.signUpNow,
                              style: TextStyle(
                                color: context.textPrimary,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Error Message
                      if (state is LoginFailure)
                        Padding(
                          padding:
                              const EdgeInsets.only(top: AppSizes.paddingM),
                          child: Text(
                            state.message,
                            style: TextStyle(color: context.error),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: AppSizes.paddingXXL),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSocialButton(String text, VoidCallback onPressed,
      {IconData? icon}) {
    return Container(
      width: AppSizes.socialButtonSize,
      height: AppSizes.socialButtonSize,
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: context.border),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: icon != null
            ? Icon(icon, color: context.textPrimary, size: 24)
            : Text(
                text,
                style: TextStyle(
                  color: context.textPrimary,
                  fontSize: AppSizes.fontSizeL,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
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

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
