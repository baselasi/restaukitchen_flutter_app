import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String _userBoxName = 'userBox';
  static const String _tokenBoxName = 'tokenBox';
  static const String _tokenKey = 'accessToken';
  static const String _userKey = 'user';

  /// Initialize Hive
  Future<void> init() async {
    await Hive.initFlutter();
  }

  /// Open a box with the given name
  Future<Box> openBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box(boxName);
    }
    return await Hive.openBox(boxName);
  }

  /// Close a box
  Future<void> closeBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box(boxName).close();
    }
  }

  /// Close all boxes
  Future<void> closeAllBoxes() async {
    await Hive.close();
  }

  /// Delete a box
  Future<void> deleteBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box(boxName).deleteFromDisk();
    } else {
      await Hive.deleteBoxFromDisk(boxName);
    }
  }

  // Token Box Methods

  /// Save access token
  Future<void> saveToken(String token) async {
    final box = await openBox(_tokenBoxName);
    await box.put(_tokenKey, token);
  }

  /// Get access token
  String? getToken() {
    if (!Hive.isBoxOpen(_tokenBoxName)) {
      return null;
    }
    final box = Hive.box(_tokenBoxName);
    return box.get(_tokenKey) as String?;
  }

  /// Delete access token
  Future<void> deleteToken() async {
    if (Hive.isBoxOpen(_tokenBoxName)) {
      final box = Hive.box(_tokenBoxName);
      await box.delete(_tokenKey);
    }
  }

  /// Check if token exists
  bool hasToken() {
    if (!Hive.isBoxOpen(_tokenBoxName)) {
      return false;
    }
    final box = Hive.box(_tokenBoxName);
    return box.containsKey(_tokenKey);
  }

  // User Box Methods

  /// Save user data as JSON
  Future<void> saveUser(Map<String, dynamic> userData) async {
    final box = await openBox(_userBoxName);
    await box.put(_userKey, userData);
  }

  /// Get user data
  Map<String, dynamic>? getUser() {
    if (!Hive.isBoxOpen(_userBoxName)) {
      return null;
    }
    final box = Hive.box(_userBoxName);
    return box.get(_userKey) as Map<String, dynamic>?;
  }

  /// Delete user data
  Future<void> deleteUser() async {
    if (Hive.isBoxOpen(_userBoxName)) {
      final box = Hive.box(_userBoxName);
      await box.delete(_userKey);
    }
  }

  /// Check if user exists
  bool hasUser() {
    if (!Hive.isBoxOpen(_userBoxName)) {
      return false;
    }
    final box = Hive.box(_userBoxName);
    return box.containsKey(_userKey);
  }

  // Generic Methods

  /// Save any value to a box
  Future<void> saveValue(String boxName, String key, dynamic value) async {
    final box = await openBox(boxName);
    await box.put(key, value);
  }

  /// Get value from a box
  dynamic getValue(String boxName, String key) {
    if (!Hive.isBoxOpen(boxName)) {
      return null;
    }
    final box = Hive.box(boxName);
    return box.get(key);
  }

  /// Delete value from a box
  Future<void> deleteValue(String boxName, String key) async {
    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box(boxName);
      await box.delete(key);
    }
  }

  /// Clear all data from a box
  Future<void> clearBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box(boxName);
      await box.clear();
    }
  }

  /// Clear all data (token and user)
  Future<void> clearAll() async {
    await deleteToken();
    await deleteUser();
  }
}

