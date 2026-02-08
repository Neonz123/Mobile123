import 'package:flutter/material.dart';
import '../pages/myride.dart'; 
import '../pages/rental_history.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 👤 Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: const Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(0xFF279A3E),
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  SizedBox(height: 15),
                  Text("John Doe", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text("Premium Member", style: TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("MY ACTIVITY", 
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2)),
                  const SizedBox(height: 10),

                  // 🏍️ VIEW MY RIDE TILE
                  _buildProfileTile(
                    Icons.motorcycle_rounded, 
                    "View My Ride", 
                    "Active rentals and bookings",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyRidePage()),
                      );
                    },
                  ),

                  // 📜 RENTAL HISTORY TILE (Updated)
                  _buildProfileTile(
                    Icons.history_rounded, 
                    "Rental History", 
                    "View your past completed rides",
                    onTap: () {
                      Navigator.push(
                     context,
                     MaterialPageRoute(builder: (context) => const RentalHistoryPage()),
    );
                    },
                  ),

                  const SizedBox(height: 20),
                  const Text("SETTINGS", 
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2)),
                  const SizedBox(height: 10),
                  
                  _buildProfileTile(Icons.payment, "Payment", "Visa ** 4421", onTap: () {}),
                  _buildProfileTile(Icons.settings, "Preferences", "Language, Theme", onTap: () {}),
                  
                  const SizedBox(height: 20),
                  // Logout Button
                  _buildProfileTile(Icons.logout, "Sign Out", "Logout from your account", onTap: () {}),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile(IconData icon, String title, String subtitle, {required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F9F1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF279A3E), size: 22),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      ),
    );
  }
}