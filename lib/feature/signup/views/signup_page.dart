import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../app.dart' show LocaleProvider;
import '../../../../core/mixins/logger_mixin.dart';
import '../blocs/signup_bloc.dart';
import '../blocs/signup_state.dart';
import '../viewmodels/signup_viewmodel.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/terms_bottom_sheet.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../../core/utils/validators.dart';

class SignupPage extends StatefulWidget {
  final SignupViewModel viewModel;
  const SignupPage({required this.viewModel, Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> with LoggerMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordRepeatController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscurePasswordRepeat = true;
  bool _agreementAccepted = false;

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
      body: BlocListener<SignupBloc, SignupState>(
        bloc: widget.viewModel.signupBloc,
        listener: (context, state) {
          if (state is SignupSuccess) {
            // Başarılı kayıt sonrası text field'ları temizle
            nameController.clear();
            emailController.clear();
            passwordController.clear();
            passwordRepeatController.clear();
            // Başarı mesajı göster
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('Hoş geldiniz, ${state.user.name}! Kayıt başarılı.'),
                backgroundColor: context.success,
                duration: const Duration(seconds: 2),
              ),
            );
            // Login sayfasına yönlendir
            Navigator.of(context).pop();
          }
        },
        child: BlocBuilder<SignupBloc, SignupState>(
          bloc: widget.viewModel.signupBloc,
          builder: (context, state) {
            if (state is SignupLoading) {
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: AppSizes.paddingXXXL),

                      // Header Section
                      Text(
                        AppLocalizations.of(context)!.signupTitle,
                        style: TextStyle(
                          color: context.textPrimary,
                          fontSize: AppSizes.fontSizeXXL,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: AppSizes.paddingM),

                      Text(
                        AppLocalizations.of(context)!.signupSubtitle,
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
                          // Name Field
                          CustomTextField(
                            controller: nameController,
                            hintText: AppLocalizations.of(context)!.nameHint,
                            prefixIcon: Icons.person_outline,
                            validator: Validators.validateName,
                            onChanged: (value) {
                              // Kullanıcı yazmaya başladığında hata state'ini temizle
                              if (state is SignupFailure) {
                                widget.viewModel.reset();
                              }
                            },
                          ),

                          const SizedBox(height: AppSizes.paddingM),

                          // Email Field
                          CustomTextField(
                            controller: emailController,
                            hintText: AppLocalizations.of(context)!.emailHint,
                            prefixIcon: Icons.email,
                            validator: Validators.validateEmail,
                            onChanged: (value) {
                              // Kullanıcı yazmaya başladığında hata state'ini temizle
                              if (state is SignupFailure) {
                                widget.viewModel.reset();
                              }
                            },
                          ),

                          const SizedBox(height: AppSizes.paddingM),

                          // Password Field
                          CustomTextField(
                            controller: passwordController,
                            hintText:
                                AppLocalizations.of(context)!.passwordHint,
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
                            validator: Validators.validatePassword,
                            onChanged: (value) {
                              // Kullanıcı yazmaya başladığında hata state'ini temizle
                              if (state is SignupFailure) {
                                widget.viewModel.reset();
                              }
                            },
                          ),

                          const SizedBox(height: AppSizes.paddingM),

                          // Password Repeat Field
                          CustomTextField(
                            controller: passwordRepeatController,
                            hintText: AppLocalizations.of(context)!
                                .passwordRepeatHint,
                            prefixIcon: Icons.lock,
                            obscureText: _obscurePasswordRepeat,
                            suffixIcon: _obscurePasswordRepeat
                                ? Icons.visibility_off
                                : Icons.visibility,
                            onSuffixIconPressed: () {
                              setState(() {
                                _obscurePasswordRepeat =
                                    !_obscurePasswordRepeat;
                              });
                            },
                            validator: (value) =>
                                Validators.validatePasswordMatch(
                              passwordController.text,
                              value,
                            ),
                            onChanged: (value) {
                              // Kullanıcı yazmaya başladığında hata state'ini temizle
                              if (state is SignupFailure) {
                                widget.viewModel.reset();
                              }
                            },
                          ),

                          const SizedBox(height: AppSizes.paddingM),

                          // User Agreement
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.paddingXS,
                              vertical: AppSizes.paddingS,
                            ),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: context.textSecondary,
                                  fontSize: AppSizes.fontSizeS,
                                ),
                                children: [
                                  TextSpan(
                                      text: AppLocalizations.of(context)!
                                          .agreement),
                                  TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .agreementAccept,
                                    style: TextStyle(
                                      color: context.textPrimary,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        TermsBottomSheet.show(context);
                                      },
                                  ),
                                  TextSpan(
                                      text: AppLocalizations.of(context)!
                                          .agreementContinue),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: AppSizes.paddingS),

                          // Signup Button
                          CustomButton(
                            text: AppLocalizations.of(context)!.signupButton,
                            onPressed: () {
                              // Form validation'ı geçerse hata state'ini temizle
                              if (_formKey.currentState!.validate()) {
                                widget.viewModel
                                    .reset(); // Önceki hataları temizle
                                widget.viewModel.signup(
                                  nameController.text,
                                  emailController.text,
                                  passwordController.text,
                                );
                              }
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

                          // Login Prompt
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.alreadyAccount,
                                style: TextStyle(color: context.textSecondary),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.loginNow,
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
                          if (state is SignupFailure)
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
              ),
            );
          },
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

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordRepeatController.dispose();
    super.dispose();
  }
}
