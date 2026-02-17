import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../services/storage_service.dart'; 
import '../pages/myride.dart'; 
import '../pages/rental_history.dart';

class UserProfile {
  final String name;      
  final String email;     
  final String membership;

  UserProfile({required this.name, required this.email, required this.membership});

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] ?? 'Guest', 
      email: json['email'] ?? 'No Email',
      membership: json['membership_type'] ?? 'Premium Member',
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<UserProfile> _userProfile;

  @override
  void initState() {
    super.initState();
    // FIXED: Matched the function name below
    _userProfile = fetchUserData();
  }

  // FIXED: Renamed to fetchUserData to match initState
  Future<UserProfile> fetchUserData() async {
  print('🚀 fetchUserData CALLED');

  final token = await StorageService.getToken();

  print('🔐 TOKEN FROM STORAGE = "$token"');

  if (token == null || token.isEmpty) {
    print('❌ TOKEN IS NULL OR EMPTY');
  }

  final String baseUrl = dotenv.get('API_BASE_URL');
  final url = Uri.parse('$baseUrl/profile');

  final response = await http.get(
    url,
   headers: {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  // Make SURE there is a space after Bearer
  'Authorization': 'Bearer $token', 
},
  );

  print('📥 STATUS = ${response.statusCode}');
  print('📥 BODY = ${response.body}');

  if (response.statusCode == 200) {
    return UserProfile.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Session expired (${response.statusCode})');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Account", 
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900)),
        centerTitle: true,
      ),
      body: FutureBuilder<UserProfile>(
        future: _userProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF279A3E)));
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 40),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text("${snapshot.error}", textAlign: TextAlign.center),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _handleLogout(context),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF279A3E)),
                    child: const Text("Return to Login", style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            );
          } else if (snapshot.hasData) {
            return _buildProfileUI(snapshot.data!);
          }
          return const Center(child: Text("No profile data found"));
        },
      ),
    );
  }

  Widget _buildProfileUI(UserProfile user) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 30),
            decoration: const BoxDecoration(
              color: Colors.white, 
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50, 
                  backgroundColor: Color(0xFF279A3E), 
                  child: Icon(Icons.person, size: 50, color: Colors.white)
                ),
                const SizedBox(height: 15),
                Text(user.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(user.email, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 5),
                Text(user.membership, 
                  style: const TextStyle(color: Color(0xFF279A3E), fontWeight: FontWeight.w600, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildActionList(),
        ],
      ),
    );
  }

  Widget _buildActionList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("MY ACTIVITY", 
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2)),
          const SizedBox(height: 10),
          _buildProfileTile(
            Icons.motorcycle, "View My Ride", "Active rentals", 
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MyRidePage()))
          ),
          _buildProfileTile(
            Icons.history, "Rental History", "Past rides", 
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RentalHistoryPage()))
          ),
          const SizedBox(height: 20),
          const Text("ACCOUNT SETTINGS", 
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2)),
          const SizedBox(height: 10),
          _buildProfileTile(Icons.logout, "Sign Out", "Logout from account", 
            onTap: () => _handleLogout(context)),
        ],
      ),
    );
  }

  void _handleLogout(BuildContext context) async {
    await StorageService.clearAll();
    if (mounted) Navigator.pushReplacementNamed(context, '/login');
  }

  Widget _buildProfileTile(IconData icon, String title, String subtitle, {required VoidCallback onTap}) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap, 
        leading: Icon(icon, color: const Color(0xFF279A3E)), 
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), 
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      ),
    );
  }
}