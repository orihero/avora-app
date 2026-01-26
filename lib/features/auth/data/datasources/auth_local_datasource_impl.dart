import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../datasources/auth_local_datasource.dart';
import '../../../../core/error/exceptions.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _cachedUserKey = 'CACHED_USER';

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheUser(Map<String, dynamic> userJson) async {
    try {
      final userJsonString = jsonEncode(userJson);
      await sharedPreferences.setString(_cachedUserKey, userJsonString);
    } catch (e) {
      throw CacheException('Failed to cache user: $e');
    }
  }

  @override
  Future<Map<String, dynamic>?> getCachedUser() async {
    try {
      final userJsonString = sharedPreferences.getString(_cachedUserKey);
      if (userJsonString != null) {
        return jsonDecode(userJsonString) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get cached user: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await sharedPreferences.remove(_cachedUserKey);
    } catch (e) {
      throw CacheException('Failed to clear cache: $e');
    }
  }
}
