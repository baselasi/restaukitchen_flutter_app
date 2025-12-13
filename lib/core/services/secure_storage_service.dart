import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const String _tokenKey = 'access_token';
  static const String _userKey = 'user_data';

  final FlutterSecureStorage _storage;

  SecureStorageService()
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(
            encryptedSharedPreferences: true,
          ),
          iOptions: IOSOptions(
            accessibility: KeychainAccessibility.first_unlock_this_device,
          ),
        );

  // Token Methods

  /// Save access token
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Get access token
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Delete access token
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  /// Check if token exists
  Future<bool> hasToken() async {
    return await _storage.containsKey(key: _tokenKey);
  }

  // User Data Methods

  /// Save user data as JSON string
  Future<void> saveUserData(String userData) async {
    await _storage.write(key: _userKey, value: userData);
  }

  /// Get user data
  Future<String?> getUserData() async {
    return await _storage.read(key: _userKey);
  }

  /// Delete user data
  Future<void> deleteUserData() async {
    await _storage.delete(key: _userKey);
  }

  // Generic Methods

  /// Save any value securely
  Future<void> saveValue(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Get any value securely
  Future<String?> getValue(String key) async {
    return await _storage.read(key: key);
  }

  /// Delete any value
  Future<void> deleteValue(String key) async {
    await _storage.delete(key: key);
  }

  /// Check if key exists
  Future<bool> containsKey(String key) async {
    return await _storage.containsKey(key: key);
  }

  /// Delete all secure data
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  /// Clear all authentication data (token and user)
  Future<void> clearAuthData() async {
    await deleteToken();
    await deleteUserData();
  }
}

