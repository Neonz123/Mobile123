import 'package:flutter/material.dart';

class LocationCard extends StatelessWidget {
  const LocationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      // 1. Background color and shape go here
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      // 2. Add shadow/elevation if you want it to pop from the background
      elevation: 1, 
      shadowColor: Colors.black.withOpacity(0.1),
      child: InkWell(
        // 3. The click action
        onTap: () {
          debugPrint("Location card clicked!");
        },
        // 4. Round the ripple corners to match the Material
        borderRadius: BorderRadius.circular(14),
        splashColor: const Color(0xFF628478).withOpacity(0.1), // Subtle green ripple
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Image.asset(
                'assets/icons/location2.png',
                width: 34,
                height: 34,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'poppins',
                      height: 1.4,
                    ),
                    children: [
                      TextSpan(
                        text: "Your location\n",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: const Color(0xFF628478).withOpacity(0.7),
                        ),
                      ),
                      const TextSpan(
                        text: "Phnom Penh, Cambodia",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Color(0xFF628478),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}