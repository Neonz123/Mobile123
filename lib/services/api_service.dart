import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // 💡 Use 10.0.2.2 if on Android Emulator, or your local IP for physical devices
  static const String baseUrl = "http://10.0.2.2:3000/api";

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