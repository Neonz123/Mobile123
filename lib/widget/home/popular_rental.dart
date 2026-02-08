import 'package:flutter/material.dart';

class PopularRental extends StatelessWidget {
  const PopularRental({super.key});

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
              "Popular Rentals",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B3922),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                "See all",
                style: TextStyle(color: Color(0xFF2DBB7D), fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // 🔹 HORIZONTAL LIST
        SizedBox(
          height: 220, // Give it a fixed height for horizontal scrolling
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 2,
            separatorBuilder: (_, __) => const SizedBox(width: 15),
            itemBuilder: (context, index) {
              return _MotoCard(
                name: index == 0 ? "Honda Dream 125" : "Honda PCX 160",
                rating: index == 0 ? "4.9" : "4.8",
                price: index == 0 ? "8" : "15",
                image: "assets/icons/rent.png", // Change to your moto image
              );
            },
          ),
        ),
      ],
    );
  }
}
class _MotoCard extends StatelessWidget {
  final String name;
  final String rating;
  final String price;
  final String image;

  const _MotoCard({
    required this.name,
    required this.rating,
    required this.price,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      margin: const EdgeInsets.symmetric(vertical: 5), // Space for shadow
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      // 🔹 1. Use ClipRRect so the ripple effect stays inside the rounded corners
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent, // Keeps the Container's white color
          child: InkWell(
            // 🔹 2. The effect happens here
            splashColor: const Color(0xFF2DBB7D).withOpacity(0.1), // Custom ripple color
            highlightColor: Colors.transparent,
            onTap: () {
              debugPrint("Tapped on $name");
              // Navigate or perform action here
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🏍️ MOTO IMAGE
                Image.asset(
                  image,
                  height: 130,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B3922),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.orangeAccent, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                rating,
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "\$$price",
                                  style: const TextStyle(
                                    color: Color(0xFF2DBB7D),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const TextSpan(
                                  text: "/day",
                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}