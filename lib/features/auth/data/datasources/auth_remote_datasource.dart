abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String phoneNumber, String password);
  Future<Map<String, dynamic>> register(
    String name,
    String phoneNumber,
    String password,
  );
  Future<void> logout();
  Future<Map<String, dynamic>?> getCurrentUser();
}
