import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

/// Repository interface for authentication operations (Appwrite).
abstract class AuthRepository {
  /// Sign up with name, E.164 phone, and password.
  /// Phone is converted to a synthetic email for Appwrite email/password auth.
  Future<Either<Failure, void>> signUp({
    required String name,
    required String phone,
    required String password,
  });

  /// Log in with E.164 phone and password.
  /// Phone is converted to a synthetic email for Appwrite email/password auth.
  Future<Either<Failure, void>> login({
    required String phone,
    required String password,
  });

  /// Returns true if the current client has a valid session.
  Future<Either<Failure, bool>> isLoggedIn();
}
