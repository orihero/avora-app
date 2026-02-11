import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../l10n/l10n.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../onboarding/presentation/pages/onboarding_screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _handleSignIn(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const OnboardingScreen(
          initialPage: 2,
          showBottomSheetOnInit: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.isAuthenticated) {
          return _buildAuthenticatedView(context);
        }
        final l10n = AppLocalizations.of(context);
        return _buildUnauthenticatedView(context, l10n);
      },
    );
  }

  Widget _buildAuthenticatedView(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.person,
                  size: 80,
                  color: Color(0xFF7BB5C9),
                ),
                const SizedBox(height: 24),
                Text(
                  "You're logged in",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D2D2D),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Your profile and favorites will appear here.',
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF2D2D2D).withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUnauthenticatedView(BuildContext context, AppLocalizations l10n) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 80,
                  color: Color(0xFFB0B0B0),
                ),
                const SizedBox(height: 24),
                Text(
                  'Sign in to access your profile',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D2D2D),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Create an account or sign in to view your profile, favorites, and more',
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF2D2D2D).withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                PrimaryButton(
                  text: l10n.signIn,
                  backgroundColor: const Color(0xFF7BB5C9),
                  onPressed: () => _handleSignIn(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
