import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/get_products_by_category.dart';
import 'product_event.dart';
import 'product_state.dart';
import '../../domain/usecases/get_products.dart' show NoParams;
import '../../domain/usecases/get_products_by_category.dart' show CategoryParams;

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProducts getProducts;
  final GetProductsByCategory getProductsByCategory;

  ProductBloc({
    required this.getProducts,
    required this.getProductsByCategory,
  }) : super(const ProductState.initial()) {
    on<ProductEvent>(_onProductEvent);
  }

  Future<void> _onProductEvent(
    ProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    await event.when(
      getProducts: () async {
        emit(const ProductState.loading());
        final result = await getProducts(NoParams());
        result.fold(
          (failure) => emit(ProductState.error(failure)),
          (products) => emit(ProductState.loaded(products)),
        );
      },
      getProductsByCategory: (category) async {
        emit(const ProductState.loading());
        final result = await getProductsByCategory(
          CategoryParams(category: category),
        );
        result.fold(
          (failure) => emit(ProductState.error(failure)),
          (products) => emit(ProductState.loaded(products)),
        );
      },
      refreshProducts: () async {
        emit(const ProductState.loading());
        final result = await getProducts(NoParams());
        result.fold(
          (failure) => emit(ProductState.error(failure)),
          (products) => emit(ProductState.loaded(products)),
        );
      },
    );
  }
}
