import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'dart:convert';
import '../../pages/myride.dart';

class HeaderSection extends StatefulWidget {
  const HeaderSection({super.key});

  @override
  State<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> {
  int _activeRentalsCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchActiveRentalsCount();
  }

  Future<void> _fetchActiveRentalsCount() async {
    try {
      final response = await ApiService.get('/my-rentals');
      if (response.statusCode == 200) {
        final List<dynamic> rentals = jsonDecode(response.body);
        if (mounted) {
          setState(() => _activeRentalsCount = rentals.length);
        }
      }
    } catch (e) {
      debugPrint("Error fetching rentals count: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Good morning 👋",
                style: TextStyle(
                    fontFamily: 'poppins',
                    color: Color.fromARGB(255, 22, 17, 17))),
            SizedBox(height: 4),
            Text(
              'Where to go today?',
              style: TextStyle(
                fontFamily: 'poppins',
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        ),
        Row(
          children: [
            // 🔔 NOTIFICATION ICON WITH BADGE
            _buildNotificationBell(),
            const SizedBox(width: 10),
         
          
          ],
        )
      ],
    );
  }

  // 🔔 Notification bell with badge
  Widget _buildNotificationBell() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyRidePage()),
              );
            },
            customBorder: const CircleBorder(),
            splashColor: Colors.black.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.asset(
                'assets/icons/notificat.png',
                width: 44,
                height: 44,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        
        // 🔴 RED BADGE (only show if count > 0)
        if (_activeRentalsCount > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              constraints: const BoxConstraints(
                minWidth: 20,
                minHeight: 20,
              ),
              child: Text(
                '$_activeRentalsCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
