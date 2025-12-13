import 'package:http/http.dart' as http;
import 'package:restaukitchen_app/core/form/services/api_service.dart';
import 'package:restaukitchen_app/core/form/services/sevices_loactor.dart';

class LoginRepo {
  final ApiService _apiService;
  final String _loginEndpoint;

  LoginRepo({String? loginEndpoint})
    : _apiService = getIt<ApiService>(),
      _loginEndpoint = loginEndpoint ?? '/api/login';

  /// Login method that takes username and password
  /// Returns a Future with the response data
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      // Make POST request to login endpoint
      final response = await _apiService.postPublic(_loginEndpoint, {
        'email': email,
        'password': password,
      });

      // Check if request was successful
      if (_apiService.isSuccess(response)) {
        // Parse and return the response
        return _apiService.parseResponse(response);
      } else {
        // Handle error response
        throw Exception(
          'Login failed: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      // Re-throw with more context
      throw Exception('Login error: $e');
    }
  }

  /// Alternative login method that returns the full HTTP response
  /// Useful if you need access to headers or status code
  Future<http.Response> loginRaw({
    required String email,
    required String password,
  }) async {
    try {
      return await _apiService.postPublic(_loginEndpoint, {
        'email': email,
        'password': password,
      });
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }
}
