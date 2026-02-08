import 'package:flutter/material.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        _QuickActionItem(
          iconPath: "assets/icons/airport.png",
          label: "Airport",
        ),
        _QuickActionItem(
          iconPath: "assets/icons/schedule.png",
          label: "Schedule",
        ),
        _QuickActionItem(
          iconPath: "assets/icons/history.png",
          label: "History",
        ),
        _QuickActionItem(
          iconPath: "assets/icons/save.png",
          label: "Saved",
        ),
      ],
    );
  }
}
class _QuickActionItem extends StatelessWidget {
  final String iconPath;
  final String label;

  const _QuickActionItem({
    required this.iconPath,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 🔹 Material provides the background and ripple surface
        Material(
          color: const Color(0xFFF2F6F5), // Your background color
          shape: const CircleBorder(),    // Keeps the shape circular
          clipBehavior: Clip.hardEdge,    // Clips the ripple to the circle
          child: InkWell(
            onTap: () {
              debugPrint("$label clicked");
            },
            // The color of the ripple effect
            splashColor: Colors.black.withOpacity(0.05),
            child: Container(
              width: 70,
              height: 70,
              // padding: const EdgeInsets.all(12), // Optional: space for the icon
              child: Center(
                child: Image.asset(
                  iconPath,
                  width: 40, // Reduced from 54 to give ripple more room
                  height: 40,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'poppins',
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}