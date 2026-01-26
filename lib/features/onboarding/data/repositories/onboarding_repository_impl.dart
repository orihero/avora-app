import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final SharedPreferences sharedPreferences;
  static const String onboardingCompletedKey = 'ONBOARDING_COMPLETED';

  OnboardingRepositoryImpl({required this.sharedPreferences});

  @override
  Future<Either<Failure, bool>> isOnboardingCompleted() async {
    try {
      final isCompleted =
          sharedPreferences.getBool(onboardingCompletedKey) ?? false;
      return Right(isCompleted);
    } catch (e) {
      return Left(CacheFailure('Failed to check onboarding status: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> completeOnboarding() async {
    try {
      await sharedPreferences.setBool(onboardingCompletedKey, true);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to complete onboarding: ${e.toString()}'));
    }
  }
}
