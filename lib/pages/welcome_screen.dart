import 'package:flutter/material.dart';
// import 'dart:math' as math;

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Book Rides Instantly',
      subtitle: 'बुक करें तुरंत',
      description:
          'Find two-wheelers offering a range of bikes and scooters. Safe, fast, and affordable.',
      image: 'assets/scooter.png',
      backgroundColor: const Color(0xFFE8F5F1),
      accentColor: const Color(0xFF1DB88E),
      stepNumber: '01',
    ),
    OnboardingData(
      title: 'Rent by Hour or Day',
      subtitle: 'kokoma',
      description:
          'Choose from hundreds of quality motorcycles. Flexible pricing for short and long rides.',
      image: 'assets/atv.png',
      backgroundColor: const Color(0xFFFFF4E6),
      accentColor: const Color(0xFFF5A623),
      stepNumber: '02',
    ),
    OnboardingData(
      title: 'Safe & Trusted Service',
      subtitle: 'सुरक्षित और विश्वसनीय',
      description:
          'All drivers and vehicles verified. 24/7 support and emergency assistance.',
      image: 'assets/horse.png',
      backgroundColor: const Color(0xFFE8F5F1),
      accentColor: const Color(0xFF1DB88E),
      stepNumber: '03',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _getStarted();
    }
  }

  void _skipToEnd() {
    _pageController.animateToPage(
      _pages.length - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _getStarted() {
    // Navigate to home or main app
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
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
                  if (_currentPage < _pages.length - 1)
                    GestureDetector(
                      onTap: _skipToEnd,
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
            ),

            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return OnboardingPage(
                    data: _pages[index],
                    isActive: _currentPage == index,
                  );
                },
              ),
            ),

            // Bottom Navigation
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Page Indicators
                  Row(
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 8),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? _pages[_currentPage].accentColor
                              : const Color(0xFFE5E7EB),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  // Next Button
                  ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _pages[_currentPage].accentColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      shadowColor:
                          _pages[_currentPage].accentColor.withOpacity(0.3),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _currentPage == _pages.length - 1
                              ? 'Get Started'
                              : 'Next',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;
  final bool isActive;

  const OnboardingPage({
    Key? key,
    required this.data,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Image Container
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    data.backgroundColor,
                    data.backgroundColor.withOpacity(0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Stack(
                children: [
                  // Step Indicator
                  Positioned(
                    top: 20,
                    left: 20,
                    child: PulsingCircle(
                      color: data.accentColor,
                      child: Center(
                        child: Text(
                          data.stepNumber,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Vehicle Image
                  Center(
                    child: AnimatedScale(
                      scale: isActive ? 1.0 : 0.8,
                      duration: const Duration(milliseconds: 400),
                      child: Image.asset(
                        data.image,
                        height: 250,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 250,
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.directions_bike,
                              size: 120,
                              color: data.accentColor.withOpacity(0.3),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Text Content
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                    letterSpacing: -0.5,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  data.subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: data.accentColor,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    data.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PulsingCircle extends StatefulWidget {
  final Color color;
  final Widget child;

  const PulsingCircle({
    Key? key,
    required this.color,
    required this.child,
  }) : super(key: key);

  @override
  State<PulsingCircle> createState() => _PulsingCircleState();
}

class _PulsingCircleState extends State<PulsingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: widget.color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: widget.color.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: widget.child,
          ),
        );
      },
    );
  }
}

class OnboardingData {
  final String title;
  final String subtitle;
  final String description;
  final String image;
  final Color backgroundColor;
  final Color accentColor;
  final String stepNumber;

  OnboardingData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.image,
    required this.backgroundColor,
    required this.accentColor,
    required this.stepNumber,
  });
}
