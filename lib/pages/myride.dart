import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyRidePage extends StatefulWidget {
  const MyRidePage({super.key});

  @override
  State<MyRidePage> createState() => _MyRidePageState();
}

class _MyRidePageState extends State<MyRidePage> {
  bool _isLoading = true; 
  List<dynamic> _allMotos = []; 
  final String _motoApiUrl = "http://10.0.2.2:3000/api/my-rentals";

  @override
  void initState() {
    super.initState();
    _fetchMyRides();
  }

  Future<void> _fetchMyRides() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final response = await http.get(Uri.parse(_motoApiUrl));
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            _allMotos = jsonDecode(response.body);
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint("Error: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("My Active Rides", 
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Colors.green))
        : RefreshIndicator(
            onRefresh: _fetchMyRides,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                if (_allMotos.isEmpty)
                  const Center(child: Text("No active rides found"))
                else
                 ..._allMotos.map((ride) {
  // 💡 TEMPORARY: Add this print to your console to see what the server sends
                print("SERVER DATA: $ride"); 
                // Inside your ListView or FutureBuilder in myride.dart
                return _buildRideItem(
                 ride['moto_name'] ?? "Unknown Moto", 
                 ride['start_date'] ?? "N/A", 
                 ride['total_price']?.toString() ?? "0.00",
                 ride['client_name'] ?? "Unknown", 
                 ride['contact'] ?? "N/A",
                 ride['image'] ?? "default_moto.png" // Use the 'image' field from your DB
);


                
}),
            ],
            ),
          ),
    );
  }

 Widget _buildRideItem(
    String moto, 
    String date, 
    String price, 
    String booker, 
    String phone, 
    String imagePath // Add imagePath to display the moto image
) {
  // Cleans "2026-02-07T..." into "2026-02-07"
  String formattedDate = date.contains('T') ? date.split('T')[0] : date;

  return Container(
    margin: const EdgeInsets.only(bottom: 15),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10)],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the moto image from your DB (e.g., click125.png)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/$imagePath', // Using 'image' column from motos table
                width: 80,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => 
                    const Icon(Icons.motorcycle, size: 50),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(moto, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text("\$$price", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Text("Rented on: $formattedDate", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
        const Divider(height: 30),
        Row(
          children: [
            const Icon(Icons.person, size: 16, color: Colors.blueGrey),
            const SizedBox(width: 8),
            Text("Booker: $booker", style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.phone, size: 16, color: Colors.blueGrey),
            const SizedBox(width: 8),
            Text("Contact: $phone", style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    ),
  );
}
}