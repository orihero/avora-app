// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ProductEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() getProducts,
    required TResult Function(String category) getProductsByCategory,
    required TResult Function() refreshProducts,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? getProducts,
    TResult? Function(String category)? getProductsByCategory,
    TResult? Function()? refreshProducts,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? getProducts,
    TResult Function(String category)? getProductsByCategory,
    TResult Function()? refreshProducts,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_GetProducts value) getProducts,
    required TResult Function(_GetProductsByCategory value)
    getProductsByCategory,
    required TResult Function(_RefreshProducts value) refreshProducts,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_GetProducts value)? getProducts,
    TResult? Function(_GetProductsByCategory value)? getProductsByCategory,
    TResult? Function(_RefreshProducts value)? refreshProducts,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_GetProducts value)? getProducts,
    TResult Function(_GetProductsByCategory value)? getProductsByCategory,
    TResult Function(_RefreshProducts value)? refreshProducts,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductEventCopyWith<$Res> {
  factory $ProductEventCopyWith(
    ProductEvent value,
    $Res Function(ProductEvent) then,
  ) = _$ProductEventCopyWithImpl<$Res, ProductEvent>;
}

/// @nodoc
class _$ProductEventCopyWithImpl<$Res, $Val extends ProductEvent>
    implements $ProductEventCopyWith<$Res> {
  _$ProductEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$GetProductsImplCopyWith<$Res> {
  factory _$$GetProductsImplCopyWith(
    _$GetProductsImpl value,
    $Res Function(_$GetProductsImpl) then,
  ) = __$$GetProductsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$GetProductsImplCopyWithImpl<$Res>
    extends _$ProductEventCopyWithImpl<$Res, _$GetProductsImpl>
    implements _$$GetProductsImplCopyWith<$Res> {
  __$$GetProductsImplCopyWithImpl(
    _$GetProductsImpl _value,
    $Res Function(_$GetProductsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$GetProductsImpl implements _GetProducts {
  const _$GetProductsImpl();

  @override
  String toString() {
    return 'ProductEvent.getProducts()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$GetProductsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() getProducts,
    required TResult Function(String category) getProductsByCategory,
    required TResult Function() refreshProducts,
  }) {
    return getProducts();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? getProducts,
    TResult? Function(String category)? getProductsByCategory,
    TResult? Function()? refreshProducts,
  }) {
    return getProducts?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? getProducts,
    TResult Function(String category)? getProductsByCategory,
    TResult Function()? refreshProducts,
    required TResult orElse(),
  }) {
    if (getProducts != null) {
      return getProducts();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_GetProducts value) getProducts,
    required TResult Function(_GetProductsByCategory value)
    getProductsByCategory,
    required TResult Function(_RefreshProducts value) refreshProducts,
  }) {
    return getProducts(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_GetProducts value)? getProducts,
    TResult? Function(_GetProductsByCategory value)? getProductsByCategory,
    TResult? Function(_RefreshProducts value)? refreshProducts,
  }) {
    return getProducts?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_GetProducts value)? getProducts,
    TResult Function(_GetProductsByCategory value)? getProductsByCategory,
    TResult Function(_RefreshProducts value)? refreshProducts,
    required TResult orElse(),
  }) {
    if (getProducts != null) {
      return getProducts(this);
    }
    return orElse();
  }
}

abstract class _GetProducts implements ProductEvent {
  const factory _GetProducts() = _$GetProductsImpl;
}

/// @nodoc
abstract class _$$GetProductsByCategoryImplCopyWith<$Res> {
  factory _$$GetProductsByCategoryImplCopyWith(
    _$GetProductsByCategoryImpl value,
    $Res Function(_$GetProductsByCategoryImpl) then,
  ) = __$$GetProductsByCategoryImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String category});
}

/// @nodoc
class __$$GetProductsByCategoryImplCopyWithImpl<$Res>
    extends _$ProductEventCopyWithImpl<$Res, _$GetProductsByCategoryImpl>
    implements _$$GetProductsByCategoryImplCopyWith<$Res> {
  __$$GetProductsByCategoryImplCopyWithImpl(
    _$GetProductsByCategoryImpl _value,
    $Res Function(_$GetProductsByCategoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? category = null}) {
    return _then(
      _$GetProductsByCategoryImpl(
        null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$GetProductsByCategoryImpl implements _GetProductsByCategory {
  const _$GetProductsByCategoryImpl(this.category);

  @override
  final String category;

  @override
  String toString() {
    return 'ProductEvent.getProductsByCategory(category: $category)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetProductsByCategoryImpl &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @override
  int get hashCode => Object.hash(runtimeType, category);

  /// Create a copy of ProductEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetProductsByCategoryImplCopyWith<_$GetProductsByCategoryImpl>
  get copyWith =>
      __$$GetProductsByCategoryImplCopyWithImpl<_$GetProductsByCategoryImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() getProducts,
    required TResult Function(String category) getProductsByCategory,
    required TResult Function() refreshProducts,
  }) {
    return getProductsByCategory(category);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? getProducts,
    TResult? Function(String category)? getProductsByCategory,
    TResult? Function()? refreshProducts,
  }) {
    return getProductsByCategory?.call(category);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? getProducts,
    TResult Function(String category)? getProductsByCategory,
    TResult Function()? refreshProducts,
    required TResult orElse(),
  }) {
    if (getProductsByCategory != null) {
      return getProductsByCategory(category);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_GetProducts value) getProducts,
    required TResult Function(_GetProductsByCategory value)
    getProductsByCategory,
    required TResult Function(_RefreshProducts value) refreshProducts,
  }) {
    return getProductsByCategory(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_GetProducts value)? getProducts,
    TResult? Function(_GetProductsByCategory value)? getProductsByCategory,
    TResult? Function(_RefreshProducts value)? refreshProducts,
  }) {
    return getProductsByCategory?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_GetProducts value)? getProducts,
    TResult Function(_GetProductsByCategory value)? getProductsByCategory,
    TResult Function(_RefreshProducts value)? refreshProducts,
    required TResult orElse(),
  }) {
    if (getProductsByCategory != null) {
      return getProductsByCategory(this);
    }
    return orElse();
  }
}

abstract class _GetProductsByCategory implements ProductEvent {
  const factory _GetProductsByCategory(final String category) =
      _$GetProductsByCategoryImpl;

  String get category;

  /// Create a copy of ProductEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetProductsByCategoryImplCopyWith<_$GetProductsByCategoryImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RefreshProductsImplCopyWith<$Res> {
  factory _$$RefreshProductsImplCopyWith(
    _$RefreshProductsImpl value,
    $Res Function(_$RefreshProductsImpl) then,
  ) = __$$RefreshProductsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RefreshProductsImplCopyWithImpl<$Res>
    extends _$ProductEventCopyWithImpl<$Res, _$RefreshProductsImpl>
    implements _$$RefreshProductsImplCopyWith<$Res> {
  __$$RefreshProductsImplCopyWithImpl(
    _$RefreshProductsImpl _value,
    $Res Function(_$RefreshProductsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$RefreshProductsImpl implements _RefreshProducts {
  const _$RefreshProductsImpl();

  @override
  String toString() {
    return 'ProductEvent.refreshProducts()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$RefreshProductsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() getProducts,
    required TResult Function(String category) getProductsByCategory,
    required TResult Function() refreshProducts,
  }) {
    return refreshProducts();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? getProducts,
    TResult? Function(String category)? getProductsByCategory,
    TResult? Function()? refreshProducts,
  }) {
    return refreshProducts?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? getProducts,
    TResult Function(String category)? getProductsByCategory,
    TResult Function()? refreshProducts,
    required TResult orElse(),
  }) {
    if (refreshProducts != null) {
      return refreshProducts();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_GetProducts value) getProducts,
    required TResult Function(_GetProductsByCategory value)
    getProductsByCategory,
    required TResult Function(_RefreshProducts value) refreshProducts,
  }) {
    return refreshProducts(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_GetProducts value)? getProducts,
    TResult? Function(_GetProductsByCategory value)? getProductsByCategory,
    TResult? Function(_RefreshProducts value)? refreshProducts,
  }) {
    return refreshProducts?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_GetProducts value)? getProducts,
    TResult Function(_GetProductsByCategory value)? getProductsByCategory,
    TResult Function(_RefreshProducts value)? refreshProducts,
    required TResult orElse(),
  }) {
    if (refreshProducts != null) {
      return refreshProducts(this);
    }
    return orElse();
  }
}

abstract class _RefreshProducts implements ProductEvent {
  const factory _RefreshProducts() = _$RefreshProductsImpl;
}
