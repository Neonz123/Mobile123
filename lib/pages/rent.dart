import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


/// MOTO MODEL

class Moto {
  final int id;
  final String name;
  final int pricePerDay;
  final bool isAvailable;
  final String? image; // 

  Moto({
    required this.id,
    required this.name,
    required this.pricePerDay,
    required this.isAvailable,
    this.image
  });

  factory Moto.fromJson(Map<String, dynamic> json) {
    return Moto(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      pricePerDay: int.tryParse(json['price_per_day'].toString()) ?? 0,
      isAvailable:
          json['status'].toString().toLowerCase() == 'available',
    );
  }
}
/// RENT PAGE

class RentPage extends StatefulWidget {
  final String bookingId;
  final String clientName;
  final String contact;
  final DateTime startDate;
  final DateTime endDate;

  const RentPage({
    super.key,
    required this.bookingId,
    required this.clientName,
    required this.contact,
    required this.startDate,
    required this.endDate,
  });

  @override
  State<RentPage> createState() => _RentPageState();
}

class _RentPageState extends State<RentPage> {
  final String _motoApiUrl = "http://10.0.2.2:3000/api/motos";
  final String _rentApiUrl = "http://10.0.2.2:3000/api/rentals";

  final TextEditingController _searchController =
      TextEditingController();

  List<Moto> _allMotos = [];
  List<Moto> _displayMotos = [];

  bool _isLoading = true;
  bool _isSubmitting = false;

  @override
void initState() {
  super.initState();
  print("🚀 [DEBUG]: initState is running!");

  // Call the function
  _fetchMotos();

  Future.delayed(const Duration(seconds: 3), () {
    if (mounted && _isLoading) {
      print("🚨 [DEBUG]: Forced stop of loading spinner");
      setState(() => _isLoading = false);
    }
  });
}

  @override
  void didChangeDependencies() {
  super.didChangeDependencies();
  _fetchMotos(); // 🔥 refresh every time page becomes active
}
  /// FETCH MOTOS
Future<void> _fetchMotos() async {
  if (mounted) setState(() => _isLoading = true); // Spinner starts

  try {
    final response = await http.get(Uri.parse(_motoApiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> decoded = jsonDecode(response.body);
      
      if (mounted) {
        setState(() {
          _allMotos = decoded.map((item) => Moto.fromJson(item)).toList();
          _displayMotos = List.from(_allMotos);
          // ❌ Don't just put _isLoading = false here...
        });
      }
    }
  } catch (e) {
    print("Error: $e");
  } finally {
    // ✅ PUT IT HERE! This runs no matter what (success or error).
    if (mounted) {
      setState(() {
        _isLoading = false; // This kills the spinner
      });
    }
  }
}

 void _filterMotos(String value) {
  setState(() {
    if (value.isEmpty) {
      _displayMotos = List.from(_allMotos); // 🔥 reset
    } else {
      _displayMotos = _allMotos
          .where((m) =>
              m.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
  });
}


  /// MODAL
  void _showMotoPreview(Moto moto) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                moto.name,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text("\$${moto.pricePerDay} / day",
                  style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: _isSubmitting
                      ? null
                      : () => _confirmRental(moto),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(
                          color: Colors.white)
                      : const Text("Confirm Rental",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  /// CONFIRM RENT
 Future<void> _confirmRental(Moto moto) async {
  final int bId = int.tryParse(widget.bookingId) ?? 0;

  // 🔥 SAFETY CHECK
  if (bId <= 0) {
    if (Navigator.canPop(context)) Navigator.pop(context);
    _showWarningDialog(
      "You must complete the booking first before renting a moto."
    );
    return;
  }

  setState(() => _isSubmitting = true);

  try {
    final response = await http.post(
      Uri.parse(_rentApiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "booking_id": bId,
        "moto_id": moto.id,
        "start_date": widget.startDate.toIso8601String(),
        "end_date": widget.endDate.toIso8601String(),
        "client_name": widget.clientName,
        "contact": widget.contact,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (!mounted) return;

      // ✅ Close bottom sheet safely
      if (Navigator.canPop(context)) Navigator.pop(context);

      // ✅ REFRESH DATA FROM SERVER
      await _fetchMotos();

      // ✅ Tell previous page something changed
      Navigator.pop(context, true);
   
      // ✅ Success message
      _showSuccessDialog("✅ ${moto.name} rented successfully!");

    } else {
      final errorData = jsonDecode(response.body);
      _showWarningDialog(
        errorData['message'] ?? "Failed to rent moto"
      );
    }
  } catch (e) {
    debugPrint("❌ Rent error: $e");
    _showWarningDialog(
      "Server connection failed. Please try again."
    );
  } finally {
    if (mounted) setState(() => _isSubmitting = false);
  }
}


// Helper to show the warning you asked for
void _showWarningDialog(String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text("⚠️ Booking Required", style: TextStyle(fontWeight: FontWeight.bold)),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("OK"),
        ),
      ],
    ),
  );
}

// Helper for a clean success message
void _showSuccessDialog(String message) {
  showDialog(
    context: context,
    barrierDismissible: false, // User must click OK
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 80),
          const SizedBox(height: 20),
          const Text(
            "Success!",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 24),
          // --- THE OK BUTTON ---
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50), // Green from your UI
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () {
                Navigator.pop(context); // Close dialog
                // Optional: Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
              },
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  /// UI
 
 @override
Widget build(BuildContext context) {
  return Scaffold(
    resizeToAvoidBottomInset: false,
    backgroundColor: const Color(0xFFF9FAFB),
    appBar: AppBar(
      title: const Text("Select Moto",
          style: TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: Colors.white,
      foregroundColor: const Color.fromARGB(255, 40, 146, 47),
      elevation: 0,
    ),
    body: Column(
      children: [
        // 1. Header & Search (Fixed at top)
        Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Client: ${widget.clientName}",
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text("Booking ID: ${widget.bookingId}",
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterMotos,
                  decoration: InputDecoration(
                    hintText: "Search moto...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: const Color(0xFFF3F4F6),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none),
                  ),
                ),
              ),
            ],
          ),
        ),

        // 2. The List Section
        Expanded(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.green))
              : RefreshIndicator(
                  onRefresh: _fetchMotos, // Allows pull-to-refresh
                  child: _displayMotos.isEmpty
                      ? const Center(
                          child: Text("No motos found", 
                          style: TextStyle(color: Colors.grey)))
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 20, top: 10),
                          itemCount: _displayMotos.length,
                          itemBuilder: (context, i) {
                            return _buildMotoTile(_displayMotos[i]);
                          },
                        ),
                ),
        ),
      ],
    ),
  );
}

  Widget _buildMotoTile(Moto moto) {
  final bool canRent = moto.isAvailable;

  return Opacity(
    opacity: canRent ? 1.0 : 0.7,
    child: Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)), // Extra rounded
      elevation: 4,
      shadowColor: const Color.fromARGB(158, 26, 148, 34),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- TOP IMAGE SECTION ---
          Stack(
            children: [
              Container(
                height: 180, // Height of the image area
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  child: moto.image != null
                      ? Image.network(
                          "http://10.0.2.2:3000/uploads/${moto.image}",
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) => 
                              const Icon(Icons.motorcycle, size: 50, color: Colors.grey),
                        )
                      : const Icon(Icons.motorcycle, size: 50, color: Colors.grey),
                ),
              ),
              // Floating Star Rating Badge
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange, size: 16),
                      SizedBox(width: 4),
                      Text("4.9", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // --- BOTTOM INFO SECTION ---
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Name and Status
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        moto.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900, // Very bold
                          color: Color(0xFF1B3022), // Dark forest green/black
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        canRent ? "Available Now" : "Currently Rented",
                        style: TextStyle(
                          color: canRent ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Price Tag
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "\$${moto.pricePerDay}",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2EBD85), // The minty green color
                      ),
                    ),
                    const Text(
                      "/day",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // --- RENT BUTTON ---
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: canRent ? const Color.fromARGB(255, 23, 129, 22) : Colors.grey,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                ),
                onPressed: canRent ? () => _showMotoPreview(moto) : null,
                child: Text(
                  canRent ? "Rent This Motorcycle" : "Unavailable",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}