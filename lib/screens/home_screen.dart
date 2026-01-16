import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/category_chip.dart';
import '../widgets/product_card.dart';
import '../widgets/bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 1; // Chair selected by default
  int _bottomNavIndex = 0;

  final List<String> _categories = ['All', 'Chair', 'Table', 'Sofa', 'Lamp', 'Bed'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    child: Text(
                      'Find Your\nDream Furniture',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2D2D2D),
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFE0E0E0),
                        width: 2,
                      ),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFE8E8E8),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      color: Color(0xFFB0B0B0),
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          hintStyle: TextStyle(
                            color: Color(0xFFB0B0B0),
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.tune,
                        color: Color(0xFF6B6B6B),
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Category Chips
            SizedBox(
              height: 48,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index < _categories.length - 1 ? 12 : 0,
                    ),
                    child: CategoryChip(
                      label: _categories[index],
                      isSelected: _selectedCategoryIndex == index,
                      onTap: () {
                        setState(() {
                          _selectedCategoryIndex = index;
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Product Cards
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(20, 0, 4, 20),
                itemCount: sampleProducts.length,
                itemBuilder: (context, index) {
                  return ProductCard(
                    product: sampleProducts[index],
                    onTap: () {
                      // Handle product tap
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Tapped on ${sampleProducts[index].name}'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    onAddToCart: () {
                      // Handle add to cart
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Added ${sampleProducts[index].name} to cart'),
                          duration: const Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _bottomNavIndex,
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index;
          });
        },
      ),
    );
  }
}
