import 'package:flutter/material.dart';
import 'package:_assignment_mobile/pages/booking.dart';
import 'package:_assignment_mobile/pages/rent.dart';
 

class AvailableMotos extends StatelessWidget {
  const AvailableMotos({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 HEADER
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "New Model",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B3922),
              ),
            ),
            TextButton(
              onPressed: () {
                // 🏁 LINK: Go to Motorcycle List (RentPage)
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
              child: const Text(
                "See all",
                style: TextStyle(
                  color: Color(0xFF2DBB7D),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // 🔹 HORIZONTAL SWIPE
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final name = index == 0 ? "Honda Click 125" : index == 1 ? "Yamaha Aerox" : "PCX 160";
              final priceStr = index == 0 ? "\$8 / day" : index == 1 ? "\$10 / day" : "\$12 / day";
              
              return _MotoCard(
                motoName: name,
                price: priceStr,
                rating: index == 0 ? "4.9" : index == 1 ? "4.8" : "5.0",
                image: "assets/icons/rent.png", // Replace with your bike image assets
                onTap: () {
                  // 🏁 LINK: Go to Booking Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BookingPage()),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _MotoCard extends StatelessWidget {
  final String motoName;
  final String price;
  final String rating;
  final String image;
  final VoidCallback onTap; // Added callback for navigation

  const _MotoCard({
    required this.motoName,
    required this.price,
    required this.rating,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 3,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap, // 👈 Triggers the navigation passed from parent
        child: Container(
          width: 160,
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🏍 IMAGE
              Container(
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xFFF3F6F5),
                ),
                child: Center(
                  child: Image.asset(image, height: 60),
                ),
              ),
              const SizedBox(height: 10),
              // 📝 NAME
              Text(
                motoName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 6),
              // ⭐ RATING
              Row(
                children: [
                  const Icon(Icons.star, size: 16, color: Colors.orange),
                  const SizedBox(width: 4),
                  Text(rating),
                ],
              ),
              const Spacer(),
              // 💰 PRICE
              Text(
                price,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF2DBB7D),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}