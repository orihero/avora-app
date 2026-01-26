import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/onboarding_state.dart';

/// Repository interface for onboarding operations
abstract class OnboardingRepository {
  /// Check if onboarding has been completed
  Future<Either<Failure, bool>> isOnboardingCompleted();

  /// Mark onboarding as completed
  Future<Either<Failure, void>> completeOnboarding();
}
