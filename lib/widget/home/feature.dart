import 'package:flutter/material.dart';

class FeaturedBikesList extends StatelessWidget {
  const FeaturedBikesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Header Section
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Featured Bikes",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F0C1D),
                ),
              ),
           
            ],
          ),
        ),

        // 2. Full-Width Vertical List
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          itemCount: 2,
          separatorBuilder: (_, __) => const SizedBox(height: 20),
          itemBuilder: (context, index) {
            return _FeaturedBikeCard(
              name: index == 0 ? "Honda dream" : "Ducati",
              brand: index == 0 ? "dream" : "big bike",
              price: index == 0 ? "50" : "30",
              image: index == 0
                  ? 'assets/icons/honda_white.png'
                  : 'assets/icons/ducati.png',
              description: index == 0
                  ? "The ultimate sportbike designed for track days and adrenaline junkies. Features cutting-edge electronics."
                  : "Comfortable city ride, fuel efficient and reliable for daily commuting.",
            );
          },
        ),
      ],
    );
  }
}

class _FeaturedBikeCard extends StatelessWidget {
  final String name, brand, price, description, image;

  const _FeaturedBikeCard({
    required this.name,
    required this.brand,
    required this.price,
    required this.description,
    required this.image,
  });

  // 🔹 THE POPUP FUNCTION
  void _showDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    
                    // Main Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        color: Colors.grey[100],
                        child: Image.asset(image, height: 220, width: double.infinity, fit: BoxFit.contain),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Category Tag
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
                          child: const Text("Sport", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 12),
                        Text(brand, style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 25),

                    const Text("Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(description, style: TextStyle(color: Colors.grey[600], height: 1.5)),
                    const SizedBox(height: 30),

                    // Specs Grid
                    Row(
                      children: [
                        _buildSpecItem("Engine", "998cc Inline-4"),
                        const Spacer(),
                        _buildSpecItem("Power", "200 HP @ 13k RPM"),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _buildSpecItem("Weight", "199 kg"),
                        const Spacer(),
                        _buildSpecItem("Top Speed", "80 km/h"),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // Footer Price
                    const Text("Price", style: TextStyle(color: Colors.grey)),
                    Text("\$$price", style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            // Close Button
            Positioned(
              top: 20,
              right: 20,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.close, size: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 14)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => _showDetails(context), // 👈 FIXED: Opens details now
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(image, fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                    const Row(
                      children: [
                        Icon(Icons.star, color: Colors.orange, size: 18),
                        Text(" 7.8", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                Text(brand, style: TextStyle(color: Colors.white.withOpacity(0.6))),
                const SizedBox(height: 12),
                Text(description, style: TextStyle(color: Colors.white.withOpacity(0.8), height: 1.4)),
                const SizedBox(height: 16),
                Text("\$$price", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFFFFC371))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}