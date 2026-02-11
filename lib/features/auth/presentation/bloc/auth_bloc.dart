import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CheckAuthStatusUseCase checkAuthStatusUseCase;

  AuthBloc({required this.checkAuthStatusUseCase})
      : super(const AuthState.initial()) {
    on<AuthEvent>(_onAuthEvent);
  }

  Future<void> _onAuthEvent(
    AuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    await event.when(
      checkRequested: () async {
        final result = await checkAuthStatusUseCase();
        result.fold(
          (_) => emit(const AuthState.unauthenticated()),
          (isLoggedIn) => emit(
            isLoggedIn
                ? const AuthState.authenticated()
                : const AuthState.unauthenticated(),
          ),
        );
      },
      justLoggedIn: () {
        emit(const AuthState.authenticated());
      },
    );
  }
}
