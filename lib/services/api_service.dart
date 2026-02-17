import 'dart:convert';
import 'package:http/http.dart' as http;
import 'storage_service.dart';

/// Centralized API service that handles authenticated HTTP requests
class ApiService {
  static const String baseUrl = "http://10.0.2.2:3000/api";

  /// Make an authenticated GET request
  static Future<http.Response> get(String endpoint) async {
    final token = await StorageService.getToken();
    
    if (token == null || token.isEmpty) {
      throw Exception('No authentication token found. Please login.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    // Handle authentication errors
    if (response.statusCode == 401 || response.statusCode == 403) {
      await StorageService.clearAll();
      throw Exception('Session expired. Please login again.');
    }

    return response;
  }

  /// Make an authenticated POST request
  static Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final token = await StorageService.getToken();
    
    if (token == null || token.isEmpty) {
      throw Exception('No authentication token found. Please login.');
    }

    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    // Handle authentication errors
    if (response.statusCode == 401 || response.statusCode == 403) {
      await StorageService.clearAll();
      throw Exception('Session expired. Please login again.');
    }

    return response;
  }

  /// Get bookings (public endpoint)
  static Future<List<dynamic>> getBookings() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/bookings'));

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
