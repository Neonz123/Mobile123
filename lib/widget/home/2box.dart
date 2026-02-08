  import 'package:flutter/material.dart';
  import 'package:_assignment_mobile/theme/app.colors.dart';

  class TwoBoxWidget extends StatelessWidget {
    const TwoBoxWidget({super.key});

    @override
    Widget build(BuildContext context) {
      return Row(
        children: [
          // RIDE BUTTON
          Expanded(
            child: _buildButton(
              color: AppColors.primary,
              icon: 'assets/icons/ride.png',
              title: "Become a\nDriver", // Added \n to match your image
              subtitle: "Earn money on your schedule",
              onTap: () {
              },
            ),
          ),
          const SizedBox(width: 12),
          // RENT BUTTON
          Expanded(
            child: _buildButton(
              color: AppColors.orange,
              icon: 'assets/icons/wallet.png',
              title: "Add\nPayment", // Added \n to match your image
              subtitle: "Fast & secure checkout",
              onTap: () {
              },
            ),
          ),
        ],
      );
    }
Widget _buildButton({
  required Color color,
  required String icon,
  required String title,
  required String subtitle,
  required VoidCallback onTap,
}) {
  return Material(
    color: color,
    borderRadius: BorderRadius.circular(24),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 120, // ✅ FIXED, SAFE HEIGHT
        child: Stack(
          children: [  
                 // BIG DECORATIVE CIRCLE (BACKGROUND)
                Positioned(
                  right: -50,
                  bottom: -50,
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.12), // transparent look
                    ),
                  ),
                ),
            Positioned(
              top: 20,       
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    icon,
                    width: 22,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // TEXT (BOTTOM LEFT)
            Positioned(
              left: 60,
              bottom: 20,
              right: -32,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            // ARROW (BOTTOM RIGHT)
            const Positioned(
              bottom: -5,
              right: 0,
              child: Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white70,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


  }