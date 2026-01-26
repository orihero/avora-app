import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_event.freezed.dart';

@freezed
class OnboardingEvent with _$OnboardingEvent {
  const factory OnboardingEvent.pageChanged(int page) = _PageChanged;
  const factory OnboardingEvent.nextPage() = _NextPage;
  const factory OnboardingEvent.skipOnboarding() = _SkipOnboarding;
  const factory OnboardingEvent.completeOnboarding() = _CompleteOnboarding;
}
