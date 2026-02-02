import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.freezed.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.login(String phoneNumber, String password) = _Login;
  const factory AuthEvent.register(
    String name,
    String phoneNumber,
    String password,
  ) = _Register;
  const factory AuthEvent.logout() = _Logout;
  const factory AuthEvent.checkAuthStatus() = _CheckAuthStatus;
}
