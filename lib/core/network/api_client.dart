import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000/api';
    }
    // For mobile emulators/simulators or desktop
    try {
      if (Platform.isAndroid) {
        return 'http://10.0.2.2:8000/api';
      } else {
        // iOS simulator or macOS desktop
        return 'http://127.0.0.1:8000/api';
      }
    } catch (e) {
      // In case Platform check is not supported on certain environments
      return 'http://127.0.0.1:8000/api';
    }
  }

  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$path');
    try {
      final response = await _client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> get(String path, {Map<String, String>? queryParameters}) async {
    var uriString = '$baseUrl$path';
    if (queryParameters != null && queryParameters.isNotEmpty) {
      final queryString = Uri(queryParameters: queryParameters).query;
      uriString += '?$queryString';
    }
    final url = Uri.parse(uriString);
    try {
      final response = await _client.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final responseBody = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return responseBody;
    } else {
      final message = responseBody['message'] ?? 'An error occurred (${response.statusCode})';
      throw Exception(message);
    }
  }
}
