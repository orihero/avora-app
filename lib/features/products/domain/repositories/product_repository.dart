import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/product.dart';

/// Repository interface for product operations
abstract class ProductRepository {
  /// Get all products
  Future<Either<Failure, List<Product>>> getProducts();

  /// Get products filtered by category
  Future<Either<Failure, List<Product>>> getProductsByCategory(String category);
}
