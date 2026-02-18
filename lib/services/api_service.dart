import 'dart:convert';
import 'package:http/http.dart' as http;
import 'storage_service.dart';
import '../config/env_config.dart';

/// Centralized API service that handles authenticated HTTP requests
class ApiService {
  // Removed hardcoded baseUrl. Now using EnvConfig.

  /// Helper to generate headers with the Bearer token
  static Future<Map<String, String>> _getHeaders() async {
    final token = await StorageService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('No authentication token found. Please login.');
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  /// Handle auth errors (401/403)
  static Future<void> _handleAuthError(http.Response response) async {
    if (response.statusCode == 401 || response.statusCode == 403) {
      await StorageService.clearAll();
      throw Exception('Session expired. Please login again.');
    }
  }

  /// Make an authenticated GET request
  static Future<http.Response> get(String endpoint) async {
    final headers = await _getHeaders();
    final url = EnvConfig.getEndpoint(endpoint);

    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    await _handleAuthError(response);
    return response;
  }

  /// Make an authenticated POST request
  static Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final headers = await _getHeaders();
    final url = EnvConfig.getEndpoint(endpoint);

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    await _handleAuthError(response);
    return response;
  }

  /// Get bookings (public endpoint)
  static Future<List<dynamic>> getBookings() async {
    try {
      // Build full URL via EnvConfig
      final url = EnvConfig.getEndpoint('bookings');
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return [];
      }
    } catch (e) {
      print("Connection Error: $e");
      return [];
    }
  }
}