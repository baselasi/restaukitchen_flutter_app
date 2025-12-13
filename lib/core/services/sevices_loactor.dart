import 'package:get_it/get_it.dart';
import 'package:restaukitchen_app/core/services/api_service.dart';

final getIt = GetIt.instance;

/// Setup service locator and register all dependencies
Future<void> setupServiceLocator() async {
  // Register ApiService as singleton
  getIt.registerSingleton<ApiService>(
    ApiService(),
  );
}

