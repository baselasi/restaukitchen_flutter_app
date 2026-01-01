import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const String _tokenKey = 'access_token';

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
  }
}

