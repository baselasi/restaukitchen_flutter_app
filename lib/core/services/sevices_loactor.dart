import 'package:get_it/get_it.dart';
import 'package:restaukitchen_app/core/services/api_service.dart';
import 'package:restaukitchen_app/core/services/secure_storage_service.dart';
import 'package:restaukitchen_app/core/services/user_service.dart';

final getIt = GetIt.instance;

/// Setup service locator and register all dependencies
Future<void> setupServiceLocator() async {
  // Register SecureStorageService as singleton
  getIt.registerSingleton<SecureStorageService>(SecureStorageService());

  // Register UserService as singleton (depends on SecureStorageService)
  getIt.registerSingleton<UserService>(UserService());

  // Register ApiService as singleton
  getIt.registerSingleton<ApiService>(ApiService());
}
