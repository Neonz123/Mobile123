import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RentalHistoryPage extends StatefulWidget {
  const RentalHistoryPage({super.key});

  @override
  State<RentalHistoryPage> createState() => _RentalHistoryPageState();
}

class _RentalHistoryPageState extends State<RentalHistoryPage> {
  final String _historyUrl = "http://10.0.2.2:3000/api/history";

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
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
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
    final response = await http.get(Uri.parse(_historyUrl));
    return response.statusCode == 200 ? jsonDecode(response.body) : [];
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

  Widget _emptyState() {
    return const Center(
      child: Text("No completed rentals yet.", style: TextStyle(color: Colors.grey)),
    );
  }
}