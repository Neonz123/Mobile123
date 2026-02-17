import 'package:flutter/material.dart';
import 'package:_assignment_mobile/theme/app.colors.dart';
import 'package:_assignment_mobile/pages/booking.dart';
import 'package:_assignment_mobile/pages/rent.dart';

class ActionCards extends StatelessWidget {
  const ActionCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 🔹 RIDE CARD
        Expanded(
          child: _buildCard(
            color: AppColors.primary,
            title: "Ride",
            subtitle: "Book a moto taxi",
            icon: 'assets/icons/ride.png',
            onTap: () {
              // 👈 NAVIGATION TO RIDE PAGE
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BookingPage ()), // Ensure RidePage class exists
              );
            },
          ),
        ),
        const SizedBox(width: 12),

        // 🔹 RENT CARD
        Expanded(
          child: _buildCard(
            color: const Color.fromARGB(255, 223, 125, 6),
            title: "Rent",
            subtitle: "Book a moto rental",
            icon: 'assets/icons/rent.png',
            iconColor: const Color.fromARGB(255, 61, 39, 39),
            onTap: () {
          Navigator.push(
            context,
         MaterialPageRoute(
        builder: (_) => RentPage(
        bookingId: "0", // ❌ not booked
        clientName: "",
        contact: "N/A",
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 1)),
      ),
    ),
  );
},

          ),
        ),
      ],
    );
  }

  Widget _buildCard({
    required Color color,
    required String title,
    required String subtitle,
    required String icon,
    required VoidCallback onTap,
    Color iconColor = Colors.white,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        splashColor: Colors.white.withOpacity(0.3),
        child: SizedBox(
          height: 150,
          child: Stack(
            children: [
              Positioned(
                right: -40,
                bottom: -40,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.15),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      icon,
                      width: 34,
                      height: 34,
                      color: iconColor,
                    ),
                    const Spacer(),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 🔹 TEMPORARY PLACEHOLDERS (Replace these with your actual Page classes)
class RidePage extends StatelessWidget {
  const RidePage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text("Ride Page")));
}

class RentalPage extends StatelessWidget {
  const RentalPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text("Rental Page")));
}