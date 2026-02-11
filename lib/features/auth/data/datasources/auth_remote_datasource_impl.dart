import 'package:appwrite/appwrite.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/appwrite_config.dart';
import 'auth_remote_datasource.dart';

/// Appwrite implementation of auth remote data source.
/// Uses shared Client and Account so session is stored on the client.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Client client;
  final Account account;
  final AppwriteConfig config;

  AuthRemoteDataSourceImpl({
    required this.client,
    required this.account,
    required this.config,
  });

  void _ensureConfigured() {
    if (!config.isConfigured) {
      throw ServerException('Appwrite is not configured');
    }
  }

  /// True when Appwrite rejects creating a session because one is already active.
  static bool _isSessionActiveError(String? message) {
    if (message == null) return false;
    return message.contains('session is active') ||
        message.contains('session is prohibited') ||
        message.contains('Creating of a session is prohibited when the session is active');
  }

  @override
  Future<void> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    _ensureConfigured();
    try {
      await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );
      // Log the user in immediately after signup
      await _createSessionOrRetryAfterLogout(
        email: email,
        password: password,
        failureLabel: 'Sign up failed',
      );
    } on AppwriteException catch (e) {
      throw ServerException(e.message ?? 'Sign up failed');
    }
  }

  /// Creates email/password session; on "session is active" error, deletes sessions and retries once.
  Future<void> _createSessionOrRetryAfterLogout({
    required String email,
    required String password,
    String failureLabel = 'Request failed',
  }) async {
    try {
      await account.createEmailPasswordSession(
        email: email,
        password: password,
      );
    } on AppwriteException catch (e) {
      if (_isSessionActiveError(e.message)) {
        await account.deleteSessions();
        try {
          await account.createEmailPasswordSession(
            email: email,
            password: password,
          );
        } on AppwriteException catch (retryE) {
          throw ServerException(retryE.message ?? failureLabel);
        } catch (e) {
          throw ServerException('$failureLabel: ${e.toString()}');
        }
      } else {
        throw ServerException(e.message ?? failureLabel);
      }
    }
  }

  @override
  Future<void> login({
    required String email,
    required String password,
  }) async {
    _ensureConfigured();
    await _createSessionOrRetryAfterLogout(
      email: email,
      password: password,
      failureLabel: 'Login failed',
    );
  }

  @override
  Future<bool> hasSession() async {
    if (!config.isConfigured) return false;
    try {
      await account.get();
      return true;
    } catch (_) {
      return false;
    }
  }
}
