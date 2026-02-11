import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  const factory AuthEvent.checkRequested() = _AuthCheckRequested;
  const factory AuthEvent.justLoggedIn() = _AuthJustLoggedIn;

  @override
  List<Object?> get props => [];

  T when<T>({
    required T Function() checkRequested,
    required T Function() justLoggedIn,
  }) {
    if (this is _AuthCheckRequested) return checkRequested();
    if (this is _AuthJustLoggedIn) return justLoggedIn();
    throw StateError('Unknown AuthEvent: $this');
  }
}

class _AuthCheckRequested extends AuthEvent {
  const _AuthCheckRequested();
}

class _AuthJustLoggedIn extends AuthEvent {
  const _AuthJustLoggedIn();
}
