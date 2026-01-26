import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_event.freezed.dart';

@freezed
class ProductEvent with _$ProductEvent {
  const factory ProductEvent.getProducts() = _GetProducts;
  const factory ProductEvent.getProductsByCategory(String category) =
      _GetProductsByCategory;
  const factory ProductEvent.refreshProducts() = _RefreshProducts;
}
