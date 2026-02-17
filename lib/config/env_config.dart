import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  /// Get the API base URL from environment variables
  /// Returns the configured API base URL or throws an error if not found
  static String get apiBaseUrl {
    final url = dotenv.env['API_BASE_URL'];
    if (url == null || url.isEmpty) {
      throw Exception(
        'API_BASE_URL not found in .env file. '
        'Please create a .env file based on .env.example',
      );
    }
    return url;
  }

  /// Get the full API endpoint URL
  static String getEndpoint(String path) {
    // Remove leading slash if present to avoid double slashes
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    return '$apiBaseUrl/$cleanPath';
  }

  /// Initialize environment variables
  /// Should be called in main() before runApp()
  static Future<void> initialize() async {
    try {
      await dotenv.load(fileName: '.env');
    } catch (e) {
      throw Exception(
        'Failed to load .env file: $e\n'
        'Please ensure .env file exists in the project root.',
      );
    }
  }
}
