import 'package:flutter/material.dart';
import '../config/env_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'rent.dart';

class BookingData {
  final String id;
  final String name;
  final String contact;
  final DateTime pickUp;
  final DateTime dropOff;

  BookingData({
    required this.id,
    required this.name,
    required this.contact,
    required this.pickUp,
    required this.dropOff,
  });

  Map<String, dynamic> toJson() {
    return {
      'client_name': name,
      'contact': contact,
      'pickup_time': pickUp.toIso8601String(),
      'dropoff_time': dropOff.toIso8601String(),
    };
  }

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      id: json['id'].toString(),
      name: json['client_name'],
      contact: json['contact'],
      pickUp: DateTime.parse(json['pickup_time']),
      dropOff: DateTime.parse(json['dropoff_time']),
    );
  }
}

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final List<BookingData> _bookings = [];
  bool _isLoading = false;

  BookingData? _lastRemovedBooking;
  int? _lastRemovedIndex;

  final _nameController = TextEditingController();
  final _contactController = TextEditingController();

  DateTime? _pickUpDateTime;
  DateTime? _dropOffDateTime;

  Future<DateTime?> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
    );
    if (date == null) return null;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return null;

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<void> _addBooking() async {
    FocusScope.of(context).unfocus();

    if (_nameController.text.isEmpty || _pickUpDateTime == null || _dropOffDateTime == null) {
      _showError("Please fill all fields");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final tempBooking = BookingData(
        id: "TEMP",
        name: _nameController.text.trim(),
        contact: _contactController.text.trim(),
        pickUp: _pickUpDateTime!,
        dropOff: _dropOffDateTime!,
      );

      final response = await http.post(
      Uri.parse(EnvConfig.getEndpoint('bookings')),
      headers: {"Content-Type": "application/json"},
       body: jsonEncode(tempBooking.toJson()),
       );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final dynamic bookingObject = responseData['booking'];
        final String realId = bookingObject['id'].toString();

        if (mounted) {
          setState(() {
            _bookings.add(BookingData(
              id: realId,
              name: tempBooking.name,
              contact: tempBooking.contact,
              pickUp: tempBooking.pickUp,
              dropOff: tempBooking.dropOff,
            ));
          });

          _nameController.clear();
          _contactController.clear();
          _pickUpDateTime = null;
          _dropOffDateTime = null;
          _showSuccess("✅ Booking saved with ID: $realId");
        }
      } else {
        throw Exception("Server rejected booking");
      }
    } catch (e) {
      _showError("⚠️ Failed to save to server.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _removeBooking(int index, BookingData booking) {
  _lastRemovedBooking = booking;
  _lastRemovedIndex = index;

  setState(() {
    _bookings.removeAt(index);
  });

  final messenger = ScaffoldMessenger.of(context);
  messenger.clearSnackBars();

  final snackBar = SnackBar(
    content: Text("${booking.name} removed"),
    duration: const Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.red,
    action: SnackBarAction(
      label: "UNDO",
      textColor: Colors.white,
      onPressed: _undoRemove,
    ),
  );

  messenger.showSnackBar(snackBar);

  // ⛔️ FORCE REMOVE after 3 seconds
  Future.delayed(const Duration(seconds: 3), () {
    messenger.hideCurrentSnackBar(); // 🔥 THIS LINE FIXES IT
    _lastRemovedBooking = null;
    _lastRemovedIndex = null;
  });
}

 
  // ↩️ Local undo (UI only)
  void _undoRemove() {
  if (_lastRemovedBooking != null && _lastRemovedIndex != null) {
    setState(() {
      _bookings.insert(_lastRemovedIndex!, _lastRemovedBooking!);
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}


  // Helper methods
  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Booking", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      // FIXED: Using SingleChildScrollView + Column to prevent overflow
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- Input Section ---
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _inputField(Icons.person, "Client Name", _nameController),
                  const SizedBox(height: 15),
                  _inputField(Icons.phone, "Contact Number", _contactController),
                  const SizedBox(height: 15),
                  _dateRow("Pick-up Time", _pickUpDateTime, () async {
                    final dt = await _pickDateTime();
                    if (dt != null) setState(() => _pickUpDateTime = dt);
                  }),
                  const SizedBox(height: 10),
                  _dateRow("Drop-off Time", _dropOffDateTime, () async {
                    final dt = await _pickDateTime();
                    if (dt != null) setState(() => _dropOffDateTime = dt);
                  }),
                  const SizedBox(height: 20),
                  _confirmButton(),
                  if (_isLoading) const Padding(padding: EdgeInsets.only(top: 10), child: LinearProgressIndicator()),
                ],
              ),
            ),

            // --- Bookings List Section ---
            Container(
              width: double.infinity,
              constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.4),
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF279A3E),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Bookings (${_bookings.length})",
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  if (_bookings.isEmpty)
                    const Center(child: Text("No bookings yet", style: TextStyle(color: Colors.white70)))
                  else
                    ListView.builder(
                      shrinkWrap: true, // IMPORTANT: Prevents height error
                      physics: const NeverScrollableScrollPhysics(), // Let the page scroll
                      itemCount: _bookings.length,
                      itemBuilder: (context, index) {
                        final item = _bookings[index];
                        return Dismissible(
                          key: ValueKey(item.id),
                          onDismissed: (_) => _removeBooking(index, item),
                          child: _bookingCard(item),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // UI Helper Widgets (InputField, DateRow, etc. stay as you wrote them)
  Widget _inputField(IconData icon, String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF279A3E)),
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  Widget _dateRow(String label, DateTime? value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                Text(value == null ? "Not selected" : _formatDateTime(value),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
            const Icon(Icons.calendar_today, color: Color(0xFF279A3E)),
          ],
        ),
      ),
    );
  }

  Widget _confirmButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1B3922),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: _isLoading ? null : _addBooking,
        child: const Text("Confirm Booking", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _bookingCard(BookingData data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.person, color: Color(0xFF279A3E)),
            const SizedBox(width: 8),
            Text(data.name, style: const TextStyle(fontWeight: FontWeight.bold))
          ]),
          Text("Contact: ${data.contact}", style: const TextStyle(color: Colors.grey)),
          const Divider(),
          Text("Pick-up: ${_formatDateTime(data.pickUp)}"),
          Text("Drop-off: ${_formatDateTime(data.dropOff)}"),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B3922)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => RentPage(
                    bookingId: data.id,
                    clientName: data.name,
                    contact: data.contact,
                    startDate: data.pickUp,
                    endDate: data.dropOff,
                  )),
                );
              },
              child: const Text("Rent Moto", style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    return "${dt.day}/${dt.month}/${dt.year} at ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }
}