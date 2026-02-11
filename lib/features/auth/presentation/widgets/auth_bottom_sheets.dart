import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/widgets/app_password_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/phone_number_field.dart';
import '../../../../core/widgets/sheet_error_banner.dart';
import '../../../../features/onboarding/domain/repositories/onboarding_repository.dart';
import '../../../../features/products/presentation/pages/home_screen.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../../../l10n/l10n.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import 'signup_bottom_sheet.dart';

/// Public API for auth bottom sheets. Use from onboarding or elsewhere.
class AuthBottomSheets {
  /// Shows the login bottom sheet
  static Future<void> showLogin(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (context) => const _LoginBottomSheetContent(),
    );
  }

  /// Shows the sign-up bottom sheet
  static Future<void> showSignUp(BuildContext context) {
    return SignupBottomSheet.show(context);
  }
}

class _LoginBottomSheetContent extends StatefulWidget {
  const _LoginBottomSheetContent();

  @override
  State<_LoginBottomSheetContent> createState() => _LoginBottomSheetContentState();
}

class _LoginBottomSheetContentState extends State<_LoginBottomSheetContent> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _fullPhoneNumber = '';
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
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
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void _toggleAuthMode() {
    Navigator.of(context).pop();
    SignupBottomSheet.show(context);
  }

  Future<void> _handleSubmit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    if (_fullPhoneNumber.isEmpty || _fullPhoneNumber.replaceAll(RegExp(r'[^\d]'), '').length < 10) {
      setState(() => _errorMessage = 'Please enter a valid phone number');
      return;
    }
    setState(() => _isLoading = true);
    final result = await di.getIt<LoginUseCase>().call(
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
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.85,
        builder: (context, scrollController) {
          return ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Stack(
              children: [
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
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20)),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        controller: scrollController,
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
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
                            Text(
                              l10n.loginTitle,
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
                              l10n.loginSubtitle,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.8),
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 32),
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
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Forgot password'),
                                    ),
                                  );
                                },
                                child: Text(
                                  l10n.forgotPassword,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.95),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            PrimaryButton(
                              text: l10n.signIn,
                              isLoading: _isLoading,
                              backgroundColor: const Color(0xFF7BB5C9),
                              onPressed: _isLoading ? null : () => _handleSubmit(context),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  l10n.dontHaveAccount,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                                TextButton(
                                  onPressed: _toggleAuthMode,
                                  child: Text(
                                    l10n.registerLink,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.95),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).viewInsets.bottom + 24),
                          ],
                        ),
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
