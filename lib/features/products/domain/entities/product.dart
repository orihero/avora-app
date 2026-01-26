import 'package:equatable/equatable.dart';

/// Pure domain entity representing a product
/// No dependencies on Flutter or external libraries
class Product extends Equatable {
  final String id;
  final String name;
  final String brand;
  final double price;
  final String imageUrl;
  final String backgroundColorHex; // Store as hex string instead of Color

  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.imageUrl,
    required this.backgroundColorHex,
  });

  @override
  List<Object> get props => [
        id,
        name,
        brand,
        price,
        imageUrl,
        backgroundColorHex,
      ];
}
