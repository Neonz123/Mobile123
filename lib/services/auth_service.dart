import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/env_config.dart';
import 'storage_service.dart';

/// Authentication service for handling user login and registration
class AuthService {
  /// Register a new user
  /// Returns user data and token on success
 
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse(EnvConfig.getEndpoint('register'));
      print('📤 Registering user at: $url');
      
      final requestBody = {
        'name': name,
        'email': email,
        'password': password,
      };
      print('📤 Request body: ${jsonEncode(requestBody)}');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Save token and user data
        if (responseData['token'] != null) {
          await StorageService.saveToken(responseData['token']);
          print('✅ Token saved');
        }
        if (responseData['user'] != null) {
          await StorageService.saveUserData(responseData['user']);
          print('✅ User data saved');
        }
        
        return responseData;
      } else {
        // Handle error response
        final errorMessage = responseData['message'] ?? 
                            responseData['error'] ?? 
                            'Registration failed';
        print('❌ Registration error: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ Exception in register: $e');
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception('Network error: Unable to connect to server');
    }
  }

  /// Login existing user
  /// Returns user data and token on success
  /// Throws exception on failure
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse(EnvConfig.getEndpoint('login'));
      print('📤 Logging in at: $url');
      
      final requestBody = {
        'email': email,
        'password': password,
      };
      print('📤 Request body: ${jsonEncode(requestBody)}');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Save token and user data
        if (responseData['token'] != null) {
          await StorageService.saveToken(responseData['token']);
          print('✅ Token saved');
        }
        if (responseData['user'] != null) {
          await StorageService.saveUserData(responseData['user']);
          print('✅ User data saved');
        }
        
        return responseData;
      } else {
        // Handle error response
        final errorMessage = responseData['message'] ?? 
                            responseData['error'] ?? 
                            'Login failed';
        print('❌ Login error: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ Exception in login: $e');
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception('Network error: Unable to connect to server');
    }
  }

  /// Logout user (clear stored data)
  static Future<void> logout() async {
    await StorageService.clearAll();
  }

  /// Get current auth token
  static Future<String?> getToken() async {
    return await StorageService.getToken();
  }

  /// Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    return await StorageService.isLoggedIn();
  }
}
