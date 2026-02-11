import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  const factory AuthState.initial() = _AuthInitial;
  const factory AuthState.authenticated() = _AuthAuthenticated;
  const factory AuthState.unauthenticated() = _AuthUnauthenticated;

  /// True when the user has a valid session.
  bool get isAuthenticated => this is _AuthAuthenticated;

  /// True while auth check is in progress (before first emission).
  bool get isInitial => this is _AuthInitial;

  @override
  List<Object?> get props => [];
}

class _AuthInitial extends AuthState {
  const _AuthInitial();
}

class _AuthAuthenticated extends AuthState {
  const _AuthAuthenticated();
}

class _AuthUnauthenticated extends AuthState {
  const _AuthUnauthenticated();
}
