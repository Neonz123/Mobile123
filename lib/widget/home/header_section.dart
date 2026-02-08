import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

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
              'Where to today?',
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
            // 🔔 NOTIFICATION ICON
            _buildHeaderCircle(
              iconPath: 'assets/icons/notificat.png',
              onTap: () => debugPrint("Notification clicked"),
            ),
            const SizedBox(width: 10),
            // 👤 PROFILE ICON
            _buildHeaderCircle(
              iconPath: 'assets/icons/profile.png',
              onTap: () => debugPrint("Profile clicked"),
            ),
          ],
        )
      ],
    );
  }

  // 🛠️ Helper to create circular clickable buttons
  Widget _buildHeaderCircle({required String iconPath, required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent, // Keeps it clean
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(), // 👈 Makes the ripple circular
        splashColor: Colors.black.withOpacity(0.1), // Subtle tap effect
        child: Padding(
          padding: const EdgeInsets.all(4.0), // Extra tap area around the icon
          child: Image.asset(
            iconPath,
            width: 44,
            height: 44,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}