import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.getCurrentUserUseCase,
  }) : super(const AuthState.initial()) {
    on<AuthEvent>(_onAuthEvent);
  }

  Future<void> _onAuthEvent(
    AuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    await event.when(
      login: (phoneNumber, password) async {
        emit(const AuthState.loading());
        final result = await loginUseCase(phoneNumber, password);
        result.fold(
          (failure) => emit(AuthState.error(failure)),
          (user) => emit(AuthState.authenticated(user)),
        );
      },
      register: (name, phoneNumber, password) async {
        emit(const AuthState.loading());
        final result = await registerUseCase(name, phoneNumber, password);
        result.fold(
          (failure) => emit(AuthState.error(failure)),
          (user) => emit(AuthState.authenticated(user)),
        );
      },
      logout: () async {
        emit(const AuthState.loading());
        // TODO: Implement logout use case
        emit(const AuthState.unauthenticated());
      },
      checkAuthStatus: () async {
        final result = await getCurrentUserUseCase();
        result.fold(
          (failure) => emit(AuthState.error(failure)),
          (user) => user != null
              ? emit(AuthState.authenticated(user))
              : emit(const AuthState.unauthenticated()),
        );
      },
    );
  }
}
