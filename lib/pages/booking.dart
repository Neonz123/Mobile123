import 'package:flutter/material.dart';
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

  // Convert to JSON for API
  Map<String, dynamic> toJson() {
    return {
      'client_name': name,
      'contact': contact,
      'pickup_time': pickUp.toIso8601String(),
      'dropoff_time': dropOff.toIso8601String(),
    };
  }

  // Factory from JSON
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
  
  // ✅ USE THIS FOR ANDROID EMULATOR
  final String _apiUrl = "http://10.0.2.2:3000/api/bookings";
  
  // Teacher's Undo Storage
  BookingData? _lastRemovedBooking;
  int? _lastRemovedIndex;

  final _nameController = TextEditingController();
  final _contactController = TextEditingController();

  DateTime? _pickUpDateTime;
  DateTime? _dropOffDateTime;

  @override
  void initState() {
    super.initState();
    // Load bookings when page starts
    // _loadBookings();
  }
  // 📅 Pick Date and Time Helper
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

  // ➕ Add Booking to Database
  Future<void> _addBooking() async {
  FocusScope.of(context).unfocus();

  // Validation... (Keep your existing validation logic)
  if (_nameController.text.isEmpty || _pickUpDateTime == null || _dropOffDateTime == null) {
    _showError("Please fill all fields");
    return;
  }

  setState(() => _isLoading = true);

  try {
    // 1. Create temporary object (This ID is just a placeholder)
    final tempBooking = BookingData(
      id: "TEMP", 
      name: _nameController.text.trim(),
      contact: _contactController.text.trim(),
      pickUp: _pickUpDateTime!,
      dropOff: _dropOffDateTime!,
    );

    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(tempBooking.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      
      // 🎯 THE FIX: Get the ID from responseData['booking']['id']
      // Your Node backend returns { "booking": { "id": 102, ... } }
      final dynamic bookingObject = responseData['booking'];
      final String realId = bookingObject['id'].toString();

      if (mounted) {
        setState(() {
          _bookings.add(BookingData(
            id: realId, // ✅ Use the Real ID from the Database (e.g., "102")
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
    print("❌ Save error: $e");
    _showError("⚠️ Failed to save to server. Please check connection.");
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

  // ⛔ FORCE REMOVE after 3 seconds
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
      body: Column(
        children: [
          // Input Section
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
                  if (dt != null && mounted) {
                    setState(() => _pickUpDateTime = dt);
                  }
                }),
                const SizedBox(height: 10),
                _dateRow("Drop-off Time", _dropOffDateTime, () async {
                  final dt = await _pickDateTime();
                  if (dt != null && mounted) {
                    setState(() => _dropOffDateTime = dt);
                  }
                }),
                const SizedBox(height: 20),
                _confirmButton(),
                const SizedBox(height: 10),
                _isLoading
                    ? const LinearProgressIndicator(
                        backgroundColor: Color(0xFF279A3E),
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1B3922)),
                      )
                    : Container(),
              ],
            ),
          ),
          
          // Bookings List Section
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF279A3E),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Bookings",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "(${_bookings.length})",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  
                  if (_isLoading && _bookings.isEmpty)
                    const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  else if (_bookings.isEmpty)
                    const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_today, size: 50, color: Colors.white70),
                          SizedBox(height: 10),
                          Text(
                            "No bookings yet",
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Add your first booking above",
                            style: TextStyle(color: Colors.white54, fontSize: 12),
                          ),
                        ],
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: _bookings.length,
                        itemBuilder: (context, index) {
                          final item = _bookings[index];
                          return Dismissible(
                            key: ValueKey(item.id),
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) => _removeBooking(index, item),
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              color: Colors.red,
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            child: _bookingCard(item),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _inputField(IconData icon, String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF279A3E)),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF279A3E), width: 2),
        ),
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
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value == null ? "Not selected" : _formatDateTime(value),
                  style: TextStyle(
                    color: value == null ? Colors.grey : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.calendar_today,
              color: value == null ? Colors.grey : const Color(0xFF279A3E),
            ),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        onPressed: _isLoading ? null : _addBooking,
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    "Confirm Booking",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
Widget _bookingCard(BookingData data) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 Name
        Row(
          children: [
            const Icon(Icons.person, size: 20, color: Color(0xFF279A3E)),
            const SizedBox(width: 8),
            Text(
              data.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),

        // 🔹 Contact
        Row(
          children: [
            const Icon(Icons.phone, size: 16, color: Colors.grey),
            const SizedBox(width: 6),
            Text(
              data.contact,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),

        const Divider(height: 20),

        // 🔹 Pick up
        Row(
          children: [
            const Icon(Icons.arrow_upward, size: 16, color: Colors.green),
            const SizedBox(width: 6),
            const Text(
              "Pick-up:",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 6),
            Text(_formatDateTime(data.pickUp)),
          ],
        ),

        const SizedBox(height: 6),

        // 🔹 Drop off
        Row(
          children: [
            const Icon(Icons.arrow_downward, size: 16, color: Colors.red),
            const SizedBox(width: 6),
            const Text(
              "Drop-off:",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 6),
            Text(_formatDateTime(data.dropOff)),
          ],
        ),

        const SizedBox(height: 16),

        // 🔹 RENT BUTTON (THIS IS THE FIX)
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B3922),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RentPage(
                    bookingId: data.id,
                    clientName: data.name,
                    contact: data.contact,
                    startDate: data.pickUp,
                    endDate: data.dropOff,
                  ),
                ),
              );
            },
            child: const Text(
              "Rent Moto",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

 
  // Helper methods
  String _formatDateTime(DateTime dt) {
    final String date = "${dt.day}/${dt.month}/${dt.year}";
    final String time = "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
    return "$date at $time";
  }

    
}