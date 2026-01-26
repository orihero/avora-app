abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String phoneNumber, String password);
  Future<void> logout();
  Future<Map<String, dynamic>?> getCurrentUser();
}
