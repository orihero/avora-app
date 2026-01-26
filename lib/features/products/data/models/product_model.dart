import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/product.dart';

part 'product_model.g.dart';

/// Data model (DTO) for Product
/// Extends domain entity and adds JSON serialization
@JsonSerializable()
class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.brand,
    required super.price,
    required super.imageUrl,
    required super.backgroundColorHex,
  });

  /// Create ProductModel from JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  /// Convert ProductModel to JSON
  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  /// Create ProductModel from domain entity
  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      brand: product.brand,
      price: product.price,
      imageUrl: product.imageUrl,
      backgroundColorHex: product.backgroundColorHex,
    );
  }

  /// Convert to domain entity (returns the same instance as it extends Product)
  Product toEntity() {
    return this;
  }
}
