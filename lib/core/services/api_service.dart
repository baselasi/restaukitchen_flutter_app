import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:restaukitchen_app/core/services/secure_storage_service.dart';
import 'package:restaukitchen_app/core/services/sevices_loactor.dart';

class ApiService {
  // Hardcoded base URL - Update this with your actual API base URL
  final String _baseUrl = 'https://restaukitchen.com';

  ApiService();

  // Get base URL
  String get baseUrl => _baseUrl;

  Future<String?> get token async {
    return await getIt<SecureStorageService>().getToken();
  }

  // Private method to get headers with token
  Future<Map<String, String>> _getHeadersWithToken() async {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await token}',
    };
  }

  // Private method to get headers without token
  Map<String, String> _getHeadersWithoutToken() {
    return {'Content-Type': 'application/json', 'Accept': 'application/json'};
  }

  // Public GET - No token required
  Future<http.Response> getPublic(String endpoint) async {
    try {
      final url = Uri.parse('$_baseUrl$endpoint');
      final response = await http.get(url, headers: _getHeadersWithoutToken());
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Private GET - Token required
  Future<http.Response> getPrivate(String endpoint) async {
    try {
      final url = Uri.parse('$_baseUrl$endpoint');
      final headers = await _getHeadersWithToken();
      final response = await http.get(url, headers: headers);
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
  ) async {
    try {
      final url = Uri.parse('$_baseUrl$endpoint');
      final headers = await _getHeadersWithToken();
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Private POST - Token required
  Future<http.Response> postRawPayload(
    String endpoint,
    String body,
  ) async {
    try {
      final url = Uri.parse('$_baseUrl$endpoint');
      final headers = await _getHeadersWithToken();
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Private PUT - Token required
  Future<http.Response> putPrivate(
    String endpoint,
    Map<String, dynamic>? body,
  ) async {
    try {
      final url = Uri.parse('$_baseUrl$endpoint');
      final headers = await _getHeadersWithToken();
      final response = await http.patch(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Private DELETE - Token required
  Future<http.Response> deletePrivate(String endpoint) async {
    try {
      final url = Uri.parse('$_baseUrl$endpoint');
      final headers = await _getHeadersWithToken();
      final response = await http.delete(url, headers: headers);
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

  // Private POST file - Token required (multipart/form-data)
  Future<http.Response> postFilePrivate(
    String endpoint,
    File file, {
    Map<String, String>? fields,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl$endpoint');
      final token = await this.token;

      var request = http.MultipartRequest('POST', url);

      // Add authorization header
      request.headers['Authorization'] = 'Bearer $token';

      // Add file
      request.files.add(await http.MultipartFile.fromPath('image', file.path));

      // Add additional fields if provided
      if (fields != null) {
        request.fields.addAll(fields);
      }

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> patchFilePrivate(
    String endpoint,
    File file, {
    Map<String, String>? fields,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl$endpoint');
      final token = await this.token;

      var request = http.MultipartRequest('PUT', url);

      // Add authorization header
      request.headers['Authorization'] = 'Bearer $token';

      // Add file
      request.files.add(await http.MultipartFile.fromPath('image', file.path));

      // Add additional fields if provided
      if (fields != null) {
        request.fields.addAll(fields);
      }

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Helper method to check if response is successful
  bool isSuccess(http.Response response) {
    return response.statusCode >= 200 && response.statusCode < 300;
  }

  /// Establishes a private SSE (Server-Sent Events) connection.
  /// Returns a record containing the decoded UTF-8 stream and the
  /// [http.Client] so the caller can close it when done.
  Future<({Stream<String> stream, http.Client client})> connectToSSE(
    String endpoint,
  ) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    final headers = await _getHeadersWithToken();
    headers['Accept'] = 'text/event-stream';
    headers['Cache-Control'] = 'no-cache';
    headers['Authorization'] = 'Bearer ${await token}';
    final client = http.Client();
    final request = http.Request('GET', url);
    request.headers.addAll(headers);

    final response = await client.send(request);

    if (response.statusCode != 200) {
      client.close();
      throw Exception(
        'SSE connection failed with status: ${response.statusCode}',
      );
    }

    return (stream: response.stream.transform(utf8.decoder), client: client);
  }
}
