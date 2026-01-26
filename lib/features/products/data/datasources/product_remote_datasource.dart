import '../../../../core/error/exceptions.dart';
import '../models/product_model.dart';

/// Abstract class for remote data source
abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<List<ProductModel>> getProductsByCategory(String category);
}

/// Implementation of ProductRemoteDataSource
/// Currently uses sample data, but can be replaced with API calls
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  // Sample product data matching the original structure
  static const List<ProductModel> _sampleProducts = [
    ProductModel(
      id: '1',
      name: 'Comfort Soft Ball Chair',
      brand: 'By Blade Soft',
      price: 149.00,
      imageUrl: 'https://images.unsplash.com/photo-1567538096630-e0c55bd6374c?w=400',
      backgroundColorHex: '0xFFF8B4B4', // Coral pink
    ),
    ProductModel(
      id: '2',
      name: 'Comfort Lounge Chair',
      brand: 'By Blade',
      price: 149.00,
      imageUrl: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=400',
      backgroundColorHex: '0xFF5CB8C2', // Teal
    ),
    ProductModel(
      id: '3',
      name: 'Modern Accent Chair',
      brand: 'By Luxe Home',
      price: 199.00,
      imageUrl: 'https://images.unsplash.com/photo-1506439773649-6e0eb8cfb237?w=400',
      backgroundColorHex: '0xFFE8D5B7', // Warm beige
    ),
    ProductModel(
      id: '4',
      name: 'Ergonomic Office Chair',
      brand: 'By WorkStyle',
      price: 299.00,
      imageUrl: 'https://images.unsplash.com/photo-1580480055273-228ff5388ef8?w=400',
      backgroundColorHex: '0xFFB8C5D6', // Soft blue-gray
    ),
  ];

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      return _sampleProducts;
    } catch (e) {
      throw ServerException('Failed to fetch products: ${e.toString()}');
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (category == 'All') {
        return _sampleProducts;
      }
      
      // For now, return all products as we don't have category data
      // In a real app, this would filter by category
      return _sampleProducts;
    } catch (e) {
      throw ServerException('Failed to fetch products by category: ${e.toString()}');
    }
  }
}
