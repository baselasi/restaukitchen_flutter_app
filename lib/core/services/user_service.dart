import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:restaukitchen_app/core/models/user.dart';
import 'package:restaukitchen_app/core/services/secure_storage_service.dart';
import 'package:restaukitchen_app/core/services/sevices_loactor.dart';

class UserService {
  User? _user;
  final SecureStorageService _secureStorage = getIt<SecureStorageService>();
  UserService();

  /// Get current user
  User? get user => _user;

  /// Set current user
  set user(User? user) {
    _user = user;
  }

  /// Clear current user
  void clearUser() {
    _user = null;
  }

  /// Check if user is logged in
  bool get isLoggedIn => _user != null;

  /// Decode JWT token and create User object
  ///
  /// Throws [Exception] if token is invalid or cannot be decoded
  User createUserFromToken(String token) {
    try {
      // Decode the JWT token
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

      // Create User from decoded token
      return User.fromJson(decodedToken);
    } catch (e) {
      throw Exception('Failed to decode token and create user: $e');
    }
  }

  /// Check if JWT token is expired
  bool isTokenExpired(String token) {
    try {
      return JwtDecoder.isExpired(token);
    } catch (e) {
      return true; // Consider invalid tokens as expired
    }
  }

  /// Get expiration date from token
  DateTime? getTokenExpirationDate(String token) {
    try {
      return JwtDecoder.getExpirationDate(token);
    } catch (e) {
      return null;
    }
  }

  /// Validate token and create User if valid
  ///
  /// Throws [Exception] if token is expired or invalid
  User validateAndCreateUser(String token) {
    if (isTokenExpired(token)) {
      throw Exception('Token is expired');
    }

    return createUserFromToken(token);
  }

  // Token Management Methods

  /// Save token securely and create user from it
  Future<void> saveTokenAndUser(String token) async {
    // Validate and create user from token
    final user = validateAndCreateUser(token);

    // Save token securely
    await _secureStorage.saveToken(token);

    _user = user;
  }

  /// Get saved token
  Future<String?> getToken() async {
    return await _secureStorage.getToken();
  }

  /// Check if token exists
  Future<bool> hasToken() async {
    return await _secureStorage.hasToken();
  }

  /// Load user from saved token
  Future<User?> loadUserFromSavedToken() async {
    final token = await getToken();
    if (token == null) {
      return null;
    }

    try {
      final user = validateAndCreateUser(token);
      _user = user;
      return user;
    } catch (e) {
      // Token might be expired or invalid, clear it
      await clearAuthData();
      return null;
    }
  }

  /// Clear all authentication data (token and user)
  Future<void> clearAuthData() async {
    await _secureStorage.clearAuthData();
    _user = null;
  }

  /// Logout - clear all data
  Future<void> logout() async {
    await clearAuthData();
  }
}
