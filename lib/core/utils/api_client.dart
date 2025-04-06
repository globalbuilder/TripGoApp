import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../errors/app_exceptions.dart';
import 'network_checker.dart';
import 'preferences_helper.dart';

/// ApiClient is a wrapper around [http.Client] that:
/// 1. Automatically attaches the auth token (if any) to headers.
/// 2. Checks for network connectivity before making a request.
/// 3. Applies a timeout to HTTP requests so they fail fast.
/// 4. Processes responses, throwing exceptions as needed.
class ApiClient {
  final http.Client httpClient;
  final PreferencesHelper preferencesHelper;

  ApiClient({
    required this.httpClient,
    required this.preferencesHelper,
  });

  Future<dynamic> get(
    String url, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    await _checkInternetConnection();

    final token = await preferencesHelper.getToken();
    final finalHeaders = await _buildHeaders(token: token, customHeaders: headers);
    final uri = _buildUri(url, queryParameters);

    try {
      final response = await httpClient
          .get(uri, headers: finalHeaders)
          .timeout(const Duration(seconds: 10));
      return _processResponse(response);
    } catch (e) {
      debugPrint('ApiClient GET error: $e');
      throw NetworkException("Failed to connect to the server.");
    }
  }

  Future<dynamic> post(
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    await _checkInternetConnection();

    final token = await preferencesHelper.getToken();
    final finalHeaders = await _buildHeaders(token: token, customHeaders: headers);
    final uri = _buildUri(url, queryParameters);

    try {
      final response = await httpClient
          .post(uri, headers: finalHeaders, body: body == null ? null : jsonEncode(body))
          .timeout(const Duration(seconds: 10));
      return _processResponse(response);
    } catch (e) {
      debugPrint('ApiClient POST error: $e');
      throw NetworkException("Failed to connect to the server.");
    }
  }

  Future<dynamic> put(
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    await _checkInternetConnection();

    final token = await preferencesHelper.getToken();
    final finalHeaders = await _buildHeaders(token: token, customHeaders: headers);
    final uri = _buildUri(url, queryParameters);

    try {
      final response = await httpClient
          .put(uri, headers: finalHeaders, body: body == null ? null : jsonEncode(body))
          .timeout(const Duration(seconds: 10));
      return _processResponse(response);
    } catch (e) {
      debugPrint('ApiClient PUT error: $e');
      throw NetworkException("Failed to connect to the server.");
    }
  }

  Future<dynamic> patch(
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    await _checkInternetConnection();

    final token = await preferencesHelper.getToken();
    final finalHeaders = await _buildHeaders(token: token, customHeaders: headers);
    final uri = _buildUri(url, queryParameters);

    try {
      final response = await httpClient
          .patch(uri, headers: finalHeaders, body: body == null ? null : jsonEncode(body))
          .timeout(const Duration(seconds: 10));
      return _processResponse(response);
    } catch (e) {
      debugPrint('ApiClient PATCH error: $e');
      throw NetworkException("Failed to connect to the server.");
    }
  }

  Future<dynamic> delete(
    String url, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    await _checkInternetConnection();

    final token = await preferencesHelper.getToken();
    final finalHeaders = await _buildHeaders(token: token, customHeaders: headers);
    final uri = _buildUri(url, queryParameters);

    try {
      final response = await httpClient
          .delete(uri, headers: finalHeaders)
          .timeout(const Duration(seconds: 10));
      return _processResponse(response);
    } catch (e) {
      debugPrint('ApiClient DELETE error: $e');
      throw NetworkException("Failed to connect to the server.");
    }
  }

  Uri _buildUri(String url, Map<String, String>? queryParameters) {
    final uri = Uri.parse(url);
    if (queryParameters != null && queryParameters.isNotEmpty) {
      return uri.replace(queryParameters: queryParameters);
    }
    return uri;
  }

  Future<Map<String, String>> _buildHeaders({
    required String? token,
    Map<String, String>? customHeaders,
  }) async {
    final defaultHeaders = {
      'Content-Type': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      defaultHeaders['Authorization'] = 'Token $token';
    }
    if (customHeaders != null) {
      defaultHeaders.addAll(customHeaders);
    }
    return defaultHeaders;
  }

  Future<void> _checkInternetConnection() async {
    final connected = await NetworkChecker.hasConnection();
    if (!connected) {
      throw NetworkException("No internet connection. Please check your network.");
    }
  }

  dynamic _processResponse(http.Response response) {
    final statusCode = response.statusCode;
    if (statusCode >= 200 && statusCode < 300) {
      if (response.body.isEmpty) {
        return null;
      }
      return jsonDecode(response.body);
    } else {
      dynamic decodedBody;
      try {
        decodedBody = jsonDecode(response.body);
      } catch (_) {
        decodedBody = {'detail': 'An unknown error occurred.'};
      }
      final errorMsg = decodedBody['error'] ??
          decodedBody['detail'] ??
          'Error: Status Code $statusCode';
      throw ServerException(errorMsg);
    }
  }
}
