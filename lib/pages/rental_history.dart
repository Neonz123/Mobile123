import 'package:flutter/material.dart';
import 'dart:convert';
import '../services/api_service.dart';

class RentalHistoryPage extends StatefulWidget {
  const RentalHistoryPage({super.key});

  @override
  State<RentalHistoryPage> createState() => _RentalHistoryPageState();
}

class _RentalHistoryPageState extends State<RentalHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Rental History", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return _errorState(snapshot.error.toString());
          }
          
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _emptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) => _historyCard(snapshot.data![index]),
          );
        },
      ),
    );
  }

  Future<List<dynamic>> _fetchHistory() async {
    try {
      debugPrint("🔍 Fetching rental history...");
      final response = await ApiService.get('/history');
      
      debugPrint("📡 Response status: ${response.statusCode}");
      debugPrint("📦 Response body: ${response.body}");
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        debugPrint("✅ Found ${data.length} completed rentals");
        return data;
      } else {
        debugPrint("❌ Failed with status: ${response.statusCode}");
        throw Exception('Failed to load history');
      }
    } catch (e) {
      debugPrint("💥 Error fetching history: $e");
      rethrow; // Let FutureBuilder handle the error
    }
  }

  Widget _historyCard(dynamic data) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.motorcycle, color: Colors.grey),
                const SizedBox(width: 10),
                Text(data['moto_name'] ?? 'Moto', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Spacer(),
                const Text("COMPLETED", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
            const Divider(),
            _infoRow(Icons.person, "Client: ${data['client_name']}"), //
            _infoRow(Icons.calendar_today, "Returned: ${data['end_date'].split('T')[0]}"), //
            _infoRow(Icons.attach_money, "Total Paid: \$${data['total_price']}"), //
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _errorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 15),
            Text(
              message,
              style: const TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
              child: const Text('Login Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return const Center(
      child: Text("No completed rentals yet.", style: TextStyle(color: Colors.grey)),
    );
  }
}