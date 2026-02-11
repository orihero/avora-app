/// Remote data source for authentication (Appwrite Account).
abstract class AuthRemoteDataSource {
  /// Create a new user and optionally create a session.
  /// [email] is the synthetic email (e.g. from phone).
  Future<void> signUp({
    required String email,
    required String password,
    String? name,
  });

  /// Create an email/password session.
  Future<void> login({
    required String email,
    required String password,
  });

  /// Returns true if the client has a valid session (user is logged in).
  Future<bool> hasSession();
}
