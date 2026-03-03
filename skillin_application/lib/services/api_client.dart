import 'dart:async';        // For TimeoutException
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'app_error.dart';

class ApiClient {
  final String baseUrl;
  final Duration timeout;

  ApiClient({
    required this.baseUrl,
    this.timeout = const Duration(seconds: 15),
  });

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    final normalizedBase =
        baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;

    final normalizedPath = path.startsWith('/') ? path : '/$path';

    final uri = Uri.parse('$normalizedBase$normalizedPath');

    return query == null
        ? uri
        : uri.replace(
            queryParameters:
                query.map((key, value) => MapEntry(key, '$value')),
          );
  }

  Map<String, String> _headers({String? token}) {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Future<T> getJson<T>(
    String path, {
    String? token,
    Map<String, dynamic>? query,
    T Function(dynamic json)? parser,
  }) async {
    try {
      final response = await http
          .get(_uri(path, query), headers: _headers(token: token))
          .timeout(timeout);

      return _handleResponse<T>(response, parser);
    } on TimeoutException {
      throw AppError('Request timed out. Please try again.');
    } on SocketException {
      throw AppError('No internet connection.');
    } on HttpException {
      throw AppError('Network error.');
    } on FormatException {
      throw AppError('Invalid server response.');
    }
  }

  Future<T> postJson<T>(
    String path, {
    String? token,
    Object? body,
    T Function(dynamic json)? parser,
  }) async {
    try {
      final response = await http
          .post(
            _uri(path),
            headers: _headers(token: token),
            body: jsonEncode(body ?? {}),
          )
          .timeout(timeout);

      return _handleResponse<T>(response, parser);
    } on TimeoutException {
      throw AppError('Request timed out. Please try again.');
    } on SocketException {
      throw AppError('No internet connection.');
    } on HttpException {
      throw AppError('Network error.');
    } on FormatException {
      throw AppError('Invalid server response.');
    }
  }

  T _handleResponse<T>(
    http.Response response,
    T Function(dynamic json)? parser,
  ) {
    final statusCode = response.statusCode;

    dynamic data;

    if (response.body.isNotEmpty) {
      try {
        data = jsonDecode(response.body);
      } catch (_) {
        data = response.body;
      }
    }

    if (statusCode >= 200 && statusCode < 300) {
      if (parser != null) return parser(data);
      return data as T;
    }

    String message = 'Something went wrong.';

    if (data is Map && data['detail'] is String) {
      message = data['detail'];
    } else {
      if (statusCode == 401) message = 'Unauthorized. Please login again.';
      if (statusCode == 403) message = 'Forbidden.';
      if (statusCode == 404) message = 'Not found.';
      if (statusCode == 422) message = 'Invalid input. Please check your data.';
      if (statusCode >= 500) message = 'Server error. Please try later.';
    }

    throw AppError(message, statusCode: statusCode);
  }
}