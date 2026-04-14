import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

abstract class ApiError implements Exception {
  const ApiError({
    required this.message,
    this.statusCode,
    this.details,
  });

  final String message;
  final int? statusCode;
  final Object? details;

  factory ApiError.fromResponse(http.Response response) {
    final message = _extractMessage(response);

    switch (response.statusCode) {
      case 400:
        return BadRequestApiError(
          message: message,
          statusCode: response.statusCode,
          details: response.body,
        );
      case 401:
        return UnauthorizedApiError(
          message: message,
          statusCode: response.statusCode,
          details: response.body,
        );
      case 403:
        return ForbiddenApiError(
          message: message,
          statusCode: response.statusCode,
          details: response.body,
        );
      case 404:
        return NotFoundApiError(
          message: message,
          statusCode: response.statusCode,
          details: response.body,
        );
      case 422:
        return ValidationApiError(
          message: message,
          statusCode: response.statusCode,
          details: response.body,
        );
      default:
        if (response.statusCode >= 500) {
          return ServerApiError(
            message: message,
            statusCode: response.statusCode,
            details: response.body,
          );
        }

        return UnknownApiError(
          message: message,
          statusCode: response.statusCode,
          details: response.body,
        );
    }
  }

  factory ApiError.fromException(Object error) {
    if (error is ApiError) {
      return error;
    }

    if (error is SocketException) {
      return NetworkApiError(message: error.message, details: error);
    }

    if (error is HttpException) {
      return UnknownApiError(message: error.message, details: error);
    }

    return UnknownApiError(message: error.toString(), details: error);
  }

  static String _extractMessage(http.Response response) {
    if (response.body.trim().isEmpty) {
      return response.reasonPhrase ?? 'Request failed';
    }

    try {
      final body = jsonDecode(response.body);

      if (body is Map<String, dynamic>) {
        for (final key in ['message', 'error', 'detail']) {
          final value = body[key];
          if (value is String && value.trim().isNotEmpty) {
            return value;
          }
        }

        final errors = body['errors'];
        if (errors is List && errors.isNotEmpty) {
          return errors.first.toString();
        }
      }

      if (body is String && body.trim().isNotEmpty) {
        return body;
      }
    } catch (_) {
      if (response.body.trim().isNotEmpty) {
        return response.body;
      }
    }

    return response.reasonPhrase ??
        'Request failed with status code ${response.statusCode}';
  }

  @override
  String toString() {
    return '$runtimeType(statusCode: $statusCode, message: $message)';
  }
}

class BadRequestApiError extends ApiError {
  const BadRequestApiError({
    required super.message,
    super.statusCode,
    super.details,
  });
}

class UnauthorizedApiError extends ApiError {
  const UnauthorizedApiError({
    required super.message,
    super.statusCode,
    super.details,
  });
}

class ForbiddenApiError extends ApiError {
  const ForbiddenApiError({
    required super.message,
    super.statusCode,
    super.details,
  });
}

class NotFoundApiError extends ApiError {
  const NotFoundApiError({
    required super.message,
    super.statusCode,
    super.details,
  });
}

class ValidationApiError extends ApiError {
  const ValidationApiError({
    required super.message,
    super.statusCode,
    super.details,
  });
}

class ServerApiError extends ApiError {
  const ServerApiError({
    required super.message,
    super.statusCode,
    super.details,
  });
}

class NetworkApiError extends ApiError {
  const NetworkApiError({
    required super.message,
    super.statusCode,
    super.details,
  });
}

class UnknownApiError extends ApiError {
  const UnknownApiError({
    required super.message,
    super.statusCode,
    super.details,
  });
}


