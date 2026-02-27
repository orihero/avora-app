import 'package:appwrite/appwrite.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/appwrite_config.dart';
import '../../../../core/utils/phone_to_email.dart';
import 'auth_remote_datasource.dart';

/// Appwrite implementation of auth remote data source.
/// Uses shared Client and Account so session is stored on the client.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Client client;
  final Account account;
  final AppwriteConfig config;
  late final Databases _databases;

  AuthRemoteDataSourceImpl({
    required this.client,
    required this.account,
    required this.config,
  }) {
    _databases = Databases(client);
  }

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
      // Ensure user profile exists in database
      await _ensureUserProfileExists();
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

  /// Ensures user profile exists in user_profiles collection.
  /// Creates profile if it doesn't exist, updates if it does.
  /// This method is safe to call multiple times and won't fail the auth flow if it errors.
  Future<void> _ensureUserProfileExists() async {
    if (!config.isConfigured || config.userProfilesCollectionId.isEmpty) {
      return; // Silently skip if not configured
    }

    try {
      // Get current user info
      final user = await account.get();
      final userId = user.$id;
      final userEmail = user.email;
      final userName = user.name;
      final phoneNumber = syntheticEmailToPhone(userEmail);

      // Check if profile already exists
      try {
        final existingProfiles = await _databases.listDocuments(
          databaseId: config.databaseId,
          collectionId: config.userProfilesCollectionId,
          queries: [
            Query.equal('authId', userId),
          ],
        );

        if (existingProfiles.documents.isNotEmpty) {
          // Profile exists, update it if needed
          final profileId = existingProfiles.documents.first.$id;
          final updateData = <String, dynamic>{
            'phoneNumber': phoneNumber,
          };
          if (userName.isNotEmpty) {
            updateData['name'] = userName;
          }
          await _databases.updateDocument(
            databaseId: config.databaseId,
            collectionId: config.userProfilesCollectionId,
            documentId: profileId,
            data: updateData,
          );
        } else {
          // Profile doesn't exist, create it
          final createData = <String, dynamic>{
            'authId': userId,
            'phoneNumber': phoneNumber,
            'role': 'user',
            'name': userName,
          };
          await _databases.createDocument(
            databaseId: config.databaseId,
            collectionId: config.userProfilesCollectionId,
            documentId: ID.unique(),
            data: createData,
          );
        }
      } on AppwriteException catch (e) {
        // Log but don't fail - profile operations shouldn't block auth
        // In production, you might want to log this to a monitoring service
        print('Warning: Failed to ensure user profile exists: ${e.message}');
      }
    } catch (e) {
      // Silently handle any errors - don't block authentication
      print('Warning: Error ensuring user profile: ${e.toString()}');
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
    // Ensure user profile exists in database
    await _ensureUserProfileExists();
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
