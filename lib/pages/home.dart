import 'package:flutter/material.dart';
import 'package:_assignment_mobile/widgets/bottom_nav.dart';
import 'package:_assignment_mobile/pages/booking.dart';
import 'package:_assignment_mobile/pages/rent.dart';
import 'package:_assignment_mobile/pages/profile.dart';

// home widgets
import 'package:_assignment_mobile/widget/home/header_section.dart';
import 'package:_assignment_mobile/widget/home/location_cards.dart';
import 'package:_assignment_mobile/widget/home/quick_actions.dart';
import 'package:_assignment_mobile/widget/home/feature.dart';
import 'package:_assignment_mobile/widget/home/popular_rental.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    // HOME CONTENT
    SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            HeaderSection(),
            SizedBox(height: 16),
            LocationCard(),
            SizedBox(height: 20),
            ActionCards(),
            SizedBox(height: 20),
            FeaturedBikesList(),
            SizedBox(height: 20),
            PopularRental(),
          ],
        ),
      ),
    ),

    const BookingPage(),
    RentPage(
      bookingId: '',
      clientName: '',
      contact: '',
      startDate: DateTime.now(),
      endDate: DateTime.now(),
    ),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD5D8DE),

      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),

      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
