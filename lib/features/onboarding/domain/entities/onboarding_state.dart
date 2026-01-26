import 'package:equatable/equatable.dart';

/// Entity representing onboarding completion state
class OnboardingState extends Equatable {
  final bool isCompleted;
  final int currentPage;

  const OnboardingState({
    required this.isCompleted,
    required this.currentPage,
  });

  @override
  List<Object> get props => [isCompleted, currentPage];
}
