import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../features/onboarding/domain/repositories/onboarding_repository.dart';
import '../../../../features/onboarding/presentation/pages/onboarding_screen.dart';
import '../../../../features/products/presentation/pages/home_screen.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

/// Picks the initial screen based on auth state and onboarding completion:
/// - If authenticated → HomeScreen
/// - If not authenticated → OnboardingScreen (regardless of onboarding completion)
/// - While checking → Loading indicator
class AuthInitialRoute extends StatelessWidget {
  const AuthInitialRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        // If authenticated, navigate to home
        if (state.isAuthenticated) {
          return const HomeScreen();
        }
        
        // If auth check is complete but user is not authenticated,
        // check onboarding completion status
        if (!state.isInitial) {
          return FutureBuilder<bool>(
            future: _checkOnboardingCompletion(),
            builder: (context, snapshot) {
              // While checking onboarding, show loading
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              
              // Navigate to onboarding screen
              // If onboarding is completed, skip to last page and show login
              final isOnboardingCompleted = snapshot.data ?? false;
              return OnboardingScreen(
                initialPage: isOnboardingCompleted ? 2 : null,
                showBottomSheetOnInit: isOnboardingCompleted,
              );
            },
          );
        }
        
        // Auth check still in progress
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  /// Checks if onboarding has been completed
  Future<bool> _checkOnboardingCompletion() async {
    try {
      final repository = getIt<OnboardingRepository>();
      final result = await repository.isOnboardingCompleted();
      return result.fold(
        (_) => false, // On error, assume not completed
        (isCompleted) => isCompleted,
      );
    } catch (_) {
      // On exception, assume not completed
      return false;
    }
  }
}
