import '../datasources/auth_remote_datasource.dart';
import '../../../../core/error/exceptions.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<Map<String, dynamic>> login(String phoneNumber, String password) async {
    // TODO: Implement actual API call
    // For now, simulate a successful login
    await Future.delayed(const Duration(seconds: 1));

    // Simulate API response
    return {
      'id': 'user_123',
      'phoneNumber': phoneNumber,
      'name': 'User Name',
      'email': null,
    };
  }

  @override
  Future<Map<String, dynamic>> register(
    String name,
    String phoneNumber,
    String password,
  ) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(seconds: 1));

    return {
      'id': 'user_${DateTime.now().millisecondsSinceEpoch}',
      'phoneNumber': phoneNumber,
      'name': name,
      'email': null,
    };
  }

  @override
  Future<void> logout() async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<Map<String, dynamic>?> getCurrentUser() async {
    // TODO: Implement actual API call
    // For now, return null (not logged in)
    return null;
  }
}
