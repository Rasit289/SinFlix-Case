import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class _SignupPageState extends State<SignupPage> {
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
                        AppStrings.signupTitle,
                        style: TextStyle(
                          color: context.textPrimary,
                          fontSize: AppSizes.fontSizeXXL,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: AppSizes.paddingM),

                      Text(
                        AppStrings.signupSubtitle,
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
                            hintText: AppStrings.nameHint,
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
                            hintText: AppStrings.emailHint,
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
                            hintText: AppStrings.passwordHint,
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
                            hintText: AppStrings.passwordRepeatHint,
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
                                  TextSpan(text: AppStrings.agreement),
                                  TextSpan(
                                    text: AppStrings.agreementAccept,
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
                                  TextSpan(text: AppStrings.agreementContinue),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: AppSizes.paddingS),

                          // Signup Button
                          CustomButton(
                            text: AppStrings.signupButton,
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
                                AppStrings.alreadyAccount,
                                style: TextStyle(color: context.textSecondary),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  AppStrings.loginNow,
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
