import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String brand;
  final double price;
  final String imageUrl;
  final Color backgroundColor;

  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.imageUrl,
    required this.backgroundColor,
  });
}

// Sample product data
final List<Product> sampleProducts = [
  Product(
    id: '1',
    name: 'Comfort Soft Ball Chair',
    brand: 'By Blade Soft',
    price: 149.00,
    imageUrl: 'https://images.unsplash.com/photo-1567538096630-e0c55bd6374c?w=400',
    backgroundColor: const Color(0xFFF8B4B4), // Coral pink
  ),
  Product(
    id: '2',
    name: 'Comfort Lounge Chair',
    brand: 'By Blade',
    price: 149.00,
    imageUrl: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=400',
    backgroundColor: const Color(0xFF5CB8C2), // Teal
  ),
  Product(
    id: '3',
    name: 'Modern Accent Chair',
    brand: 'By Luxe Home',
    price: 199.00,
    imageUrl: 'https://images.unsplash.com/photo-1506439773649-6e0eb8cfb237?w=400',
    backgroundColor: const Color(0xFFE8D5B7), // Warm beige
  ),
  Product(
    id: '4',
    name: 'Ergonomic Office Chair',
    brand: 'By WorkStyle',
    price: 299.00,
    imageUrl: 'https://images.unsplash.com/photo-1580480055273-228ff5388ef8?w=400',
    backgroundColor: const Color(0xFFB8C5D6), // Soft blue-gray
  ),
];
