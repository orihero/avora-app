import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../features/onboarding/presentation/pages/onboarding_screen.dart';
import '../../../../features/products/presentation/pages/home_screen.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

/// Picks the initial screen based on auth state: loading, Home (session active),
/// or Onboarding (no session).
class AuthInitialRoute extends StatelessWidget {
  const AuthInitialRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.isAuthenticated) {
          return const HomeScreen();
        }
        if (!state.isInitial) {
          return const OnboardingScreen();
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
