import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/onboarding_repository.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final OnboardingRepository repository;
  int currentPage = 0;
  final int totalPages = 3;

  OnboardingBloc(this.repository) : super(const OnboardingState.initial()) {
    on<OnboardingEvent>(_onOnboardingEvent);
  }

  Future<void> _onOnboardingEvent(
    OnboardingEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    await event.when(
      pageChanged: (page) {
        currentPage = page;
        emit(OnboardingState.pageChanged(currentPage));
      },
      nextPage: () {
        if (currentPage < totalPages - 1) {
          currentPage++;
          emit(OnboardingState.pageChanged(currentPage));
        } else {
          add(const OnboardingEvent.completeOnboarding());
        }
      },
      skipOnboarding: () {
        add(const OnboardingEvent.completeOnboarding());
      },
      completeOnboarding: () async {
        final result = await repository.completeOnboarding();
        result.fold(
          (failure) {
            // Even if saving fails, we still complete onboarding in the UI
            emit(const OnboardingState.completed());
          },
          (_) => emit(const OnboardingState.completed()),
        );
      },
    );
  }
}
