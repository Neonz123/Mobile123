import 'package:flutter/material.dart';

class WelcomePageTwo extends StatelessWidget {
  const WelcomePageTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ride',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1DB88E),
                      letterSpacing: -0.5,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Image Container
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFFFF4E6),
                        Color(0xFFFFF4E6),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Stack(
                    children: [
                      // Step Number Badge
                      Positioned(
                        top: 20,
                        left: 20,
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5A623),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFF5A623).withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              '02',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // ATV Image
                      Center(
                        child: Image.asset(
                          'assets/atv.png',
                          height: 250,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.sports_motorsports,
                              size: 150,
                              color: Color(0xFFF5A623),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Text Content
              const Text(
                'Rent by Hour or Day',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: -0.5,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'घंटे या दिन के हिसाब से',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFF5A623),
                ),
              ),

              const SizedBox(height: 16),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Choose from hundreds of quality motorcycles. Flexible pricing for short and long rides.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Bottom Navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Page Indicators
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5E7EB),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 24,
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5A623),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5E7EB),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),

                  // Next Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, '/welcome-page-three');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF5A623),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      shadowColor: const Color(0xFFF5A623).withOpacity(0.3),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Next',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
