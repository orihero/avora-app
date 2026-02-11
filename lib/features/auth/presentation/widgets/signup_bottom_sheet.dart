import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_password_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/phone_number_field.dart';
import '../../../../core/widgets/sheet_error_banner.dart';
import '../../../../features/onboarding/domain/repositories/onboarding_repository.dart';
import '../../../../features/products/presentation/pages/home_screen.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../../../l10n/l10n.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

/// Glassmorphism bottom sheet for signup/registration
class SignupBottomSheet extends StatefulWidget {
  const SignupBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      builder: (context) => const SignupBottomSheet(),
    );
  }

  @override
  State<SignupBottomSheet> createState() => _SignupBottomSheetState();
}

class _SignupBottomSheetState extends State<SignupBottomSheet> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _fullPhoneNumber = '';
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context).nameHint;
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty || value.length < 10) {
      return 'Please enter a valid phone number';
    }
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.length < 10) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context).passwordHint;
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context).confirmPasswordHint;
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _handleSubmit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    if (_fullPhoneNumber.isEmpty || _fullPhoneNumber.replaceAll(RegExp(r'[^\d]'), '').length < 10) {
      setState(() => _errorMessage = 'Please enter a valid phone number');
      return;
    }
    setState(() => _isLoading = true);
    final result = await di.getIt<SignUpUseCase>().call(
      name: _nameController.text.trim(),
      phone: _fullPhoneNumber,
      password: _passwordController.text,
    );
    if (!mounted) return;
    setState(() => _isLoading = false);
    result.fold(
      (failure) {
        setState(() => _errorMessage = failure.message);
      },
      (_) async {
        context.read<AuthBloc>().add(const AuthEvent.justLoggedIn());
        await di.getIt<OnboardingRepository>().completeOnboarding();
        if (!context.mounted) return;
        Navigator.of(context).pop();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return DraggableScrollableSheet(
        initialChildSize: .95,
        minChildSize: 0.5,
        maxChildSize: .95,
        builder: (context, scrollController) {
          return ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Stack(
              children: [
                // Backdrop filter for blur effect
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0.25),
                          Colors.white.withOpacity(0.15),
                        ],
                      ),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                  ),
                ),
                // Content with border
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.4),
                      width: 1.5,
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Handle bar
                          Center(
                            child: Container(
                              margin: const EdgeInsets.only(top: 12),
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Title
                          Text(
                            l10n.registerTitle,
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(0.95),
                              letterSpacing: -0.5,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.registerSubtitle,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.8),
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Name field with custom label for glass background
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.nameLabel,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withOpacity(0.95),
                                ),
                              ),
                              const SizedBox(height: 8),
                              AppTextField(
                                hintText: l10n.nameHint,
                                controller: _nameController,
                                textCapitalization: TextCapitalization.words,
                                validator: _validateName,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Phone field with custom label
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.phoneNumberLabel,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withOpacity(0.95),
                                ),
                              ),
                              const SizedBox(height: 8),
                              PhoneNumberField(
                                hintText: l10n.phoneNumberHint,
                                controller: _phoneController,
                                validator: _validatePhoneNumber,
                                onFullNumberChanged: (fullNumber) {
                                  setState(() => _fullPhoneNumber = fullNumber);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Password field with custom label
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.passwordLabel,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withOpacity(0.95),
                                ),
                              ),
                              const SizedBox(height: 8),
                              AppPasswordField(
                                hintText: l10n.passwordHint,
                                controller: _passwordController,
                                validator: _validatePassword,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Confirm password field with custom label
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.confirmPasswordLabel,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withOpacity(0.95),
                                ),
                              ),
                              const SizedBox(height: 8),
                              AppPasswordField(
                                hintText: l10n.confirmPasswordHint,
                                controller: _confirmPasswordController,
                                validator: _validateConfirmPassword,
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          PrimaryButton(
                            text: l10n.signUp,
                            isLoading: _isLoading,
                            backgroundColor: const Color(0xFF7BB5C9),
                            onPressed: _isLoading ? null : () => _handleSubmit(context),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                l10n.alreadyHaveAccount,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  l10n.signInLink,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.95),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Add bottom padding for safe area
                          SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 24),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SheetErrorBanner(
                    message: _errorMessage,
                    onDismiss: () => setState(() => _errorMessage = null),
                  ),
                ),
              ],
            ),
          );
        },
    );
  }
}
