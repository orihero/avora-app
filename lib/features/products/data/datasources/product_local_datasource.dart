import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../models/product_model.dart';

/// Abstract class for local data source
abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getCachedProducts();
  Future<void> cacheProducts(List<ProductModel> products);
}

/// Implementation of ProductLocalDataSource using SharedPreferences
class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String cachedProductsKey = 'CACHED_PRODUCTS';

  ProductLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<ProductModel>> getCachedProducts() async {
    try {
      final jsonString = sharedPreferences.getString(cachedProductsKey);
      if (jsonString == null) {
        throw CacheException('No cached products found');
      }
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException('Failed to get cached products: ${e.toString()}');
    }
  }

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    try {
      final jsonString = json.encode(
        products.map((product) => product.toJson()).toList(),
      );
      await sharedPreferences.setString(cachedProductsKey, jsonString);
    } catch (e) {
      throw CacheException('Failed to cache products: ${e.toString()}');
    }
  }
}
