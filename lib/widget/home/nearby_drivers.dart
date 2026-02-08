import 'package:flutter/material.dart';

class NearbyDrivers extends StatelessWidget {
  const NearbyDrivers({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🔹 HEADER WITH "SEE ALL"
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Nearby Drivers",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B3922), // Dark green title
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

        // 🔹 DRIVER LIST
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 2,
          separatorBuilder: (_, _) => const SizedBox(height: 15),
          itemBuilder: (context, index) {
            return _DriverCard(
              name: index == 0 ? "Sokha" : "Vannak",
              rating: index == 0 ? "4.9" : "4.8",
              trips: index == 0 ? "1240" : "890",
              time: index == 0 ? "4 min" : "3 min",
              image: "assets/icons/rent.png", // Replace with your asset
            );
          },
        ),
      ],
    );
  }
}

class _DriverCard extends StatelessWidget {
  final String name;
  final String rating;
  final String trips;
  final String time;
  final String image;

  const _DriverCard({
    required this.name,
    required this.rating,
    required this.trips,
    required this.time,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      // 🔹 1. Provide color and shape here
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
      // 🔹 2. Elevation gives it a nice shadow
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      child: InkWell(
        // 🔹 3. The click action
        onTap: () {
          debugPrint("Clicked on driver: $name");
        },
        // 🔹 4. Match the border radius for the ripple
        borderRadius: BorderRadius.circular(30),
        splashColor: const Color(0xFF2DBB7D).withOpacity(0.1), // Subtle green ripple
        child: Container(
          padding: const EdgeInsets.all(12),
          // Note: Decoration is removed from Container because Material handles it
          child: Row(
            children: [
              // 👤 DRIVER IMAGE WITH GREEN BORDER
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color.fromARGB(255, 93, 255, 64), 
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage(image),
                ),
              ),
              const SizedBox(width: 15),

              // 📝 DRIVER INFO
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B3922),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orangeAccent, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          "$rating • $trips trips",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 🕒 TIME AWAY
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2DBB7D),
                    ),
                  ),
                  const Text(
                    "away",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
      );
    }
  }