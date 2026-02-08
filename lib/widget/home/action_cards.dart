import 'package:flutter/material.dart';
import 'package:_assignment_mobile/theme/app.colors.dart';

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
              print("Ride clicked!");
            },
          ),
        ),
        const SizedBox(width: 12),

        // 🔹 RENT CARD
        Expanded(
          child: _buildCard(
            color: const Color.fromARGB(255, 223, 125, 6),
            title: "Rent", // Fixed name to match action
            subtitle: "Book a moto rental",
            icon: 'assets/icons/rent.png',
            iconColor: const Color.fromARGB(255, 61, 39, 39),
            onTap: () {
              print("Rent clicked!");
            },
          ),
        ),
      ],
    );
  }

  // 🛠️ Helper method to apply the click effect to both cards
  Widget _buildCard({
    required Color color,
    required String title,
    required String subtitle,
    required String icon,
    required VoidCallback onTap,
    Color iconColor = Colors.white,
  }) {
    return Material(
      color: color, // Set background here
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap, // 👈 Click action
        borderRadius: BorderRadius.circular(18), // 👈 Keeps ripple inside corners
        splashColor: Colors.white.withOpacity(0.3), // 👈 Color of the "click effect"
        child: SizedBox(
          height: 150,
          child: Stack(
            children: [
              // 🔵 DECORATIVE CIRCLE
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

              // 🔤 CONTENT
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