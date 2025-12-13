import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Hardcoded base URL - Update this with your actual API base URL
  final String _baseUrl = 'https://your-api-url.com';

  ApiService();

  // Get base URL
  String get baseUrl => _baseUrl;

  // Private method to get headers with token
  Map<String, String> _getHeadersWithToken(String token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Private method to get headers without token
  Map<String, String> _getHeadersWithoutToken() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  // Public GET - No token required
  Future<http.Response> getPublic(String endpoint) async {
    try {
      final url = Uri.parse('$_baseUrl$endpoint');
      final response = await http.get(
        url,
        headers: _getHeadersWithoutToken(),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Private GET - Token required
  Future<http.Response> getPrivate(String endpoint, String token) async {
    try {
      final url = Uri.parse('$_baseUrl$endpoint');
      final response = await http.get(
        url,
        headers: _getHeadersWithToken(token),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Public POST - No token required
  Future<http.Response> postPublic(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final url = Uri.parse('$_baseUrl$endpoint');
      final response = await http.post(
        url,
        headers: _getHeadersWithoutToken(),
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Private POST - Token required
  Future<http.Response> postPrivate(
    String endpoint,
    Map<String, dynamic> body,
    String token,
  ) async {
    try {
      final url = Uri.parse('$_baseUrl$endpoint');
      final response = await http.post(
        url,
        headers: _getHeadersWithToken(token),
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Private PUT - Token required
  Future<http.Response> putPrivate(
    String endpoint,
    Map<String, dynamic> body,
    String token,
  ) async {
    try {
      final url = Uri.parse('$_baseUrl$endpoint');
      final response = await http.put(
        url,
        headers: _getHeadersWithToken(token),
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Private DELETE - Token required
  Future<http.Response> deletePrivate(String endpoint, String token) async {
    try {
      final url = Uri.parse('$_baseUrl$endpoint');
      final response = await http.delete(
        url,
        headers: _getHeadersWithToken(token),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Helper method to parse response
  Map<String, dynamic> parseResponse(http.Response response) {
    if (response.body.isEmpty) {
      return {};
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  // Helper method to check if response is successful
  bool isSuccess(http.Response response) {
    return response.statusCode >= 200 && response.statusCode < 300;
  }
}
