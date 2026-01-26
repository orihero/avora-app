// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'model_viewer_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ModelViewerEvent {
  String get assetPath => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String assetPath) loadModel,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String assetPath)? loadModel,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String assetPath)? loadModel,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadModel value) loadModel,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadModel value)? loadModel,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadModel value)? loadModel,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Create a copy of ModelViewerEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ModelViewerEventCopyWith<ModelViewerEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ModelViewerEventCopyWith<$Res> {
  factory $ModelViewerEventCopyWith(
    ModelViewerEvent value,
    $Res Function(ModelViewerEvent) then,
  ) = _$ModelViewerEventCopyWithImpl<$Res, ModelViewerEvent>;
  @useResult
  $Res call({String assetPath});
}

/// @nodoc
class _$ModelViewerEventCopyWithImpl<$Res, $Val extends ModelViewerEvent>
    implements $ModelViewerEventCopyWith<$Res> {
  _$ModelViewerEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ModelViewerEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? assetPath = null}) {
    return _then(
      _value.copyWith(
            assetPath: null == assetPath
                ? _value.assetPath
                : assetPath // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LoadModelImplCopyWith<$Res>
    implements $ModelViewerEventCopyWith<$Res> {
  factory _$$LoadModelImplCopyWith(
    _$LoadModelImpl value,
    $Res Function(_$LoadModelImpl) then,
  ) = __$$LoadModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String assetPath});
}

/// @nodoc
class __$$LoadModelImplCopyWithImpl<$Res>
    extends _$ModelViewerEventCopyWithImpl<$Res, _$LoadModelImpl>
    implements _$$LoadModelImplCopyWith<$Res> {
  __$$LoadModelImplCopyWithImpl(
    _$LoadModelImpl _value,
    $Res Function(_$LoadModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ModelViewerEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? assetPath = null}) {
    return _then(
      _$LoadModelImpl(
        null == assetPath
            ? _value.assetPath
            : assetPath // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$LoadModelImpl implements _LoadModel {
  const _$LoadModelImpl(this.assetPath);

  @override
  final String assetPath;

  @override
  String toString() {
    return 'ModelViewerEvent.loadModel(assetPath: $assetPath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadModelImpl &&
            (identical(other.assetPath, assetPath) ||
                other.assetPath == assetPath));
  }

  @override
  int get hashCode => Object.hash(runtimeType, assetPath);

  /// Create a copy of ModelViewerEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadModelImplCopyWith<_$LoadModelImpl> get copyWith =>
      __$$LoadModelImplCopyWithImpl<_$LoadModelImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String assetPath) loadModel,
  }) {
    return loadModel(assetPath);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String assetPath)? loadModel,
  }) {
    return loadModel?.call(assetPath);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String assetPath)? loadModel,
    required TResult orElse(),
  }) {
    if (loadModel != null) {
      return loadModel(assetPath);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadModel value) loadModel,
  }) {
    return loadModel(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadModel value)? loadModel,
  }) {
    return loadModel?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadModel value)? loadModel,
    required TResult orElse(),
  }) {
    if (loadModel != null) {
      return loadModel(this);
    }
    return orElse();
  }
}

abstract class _LoadModel implements ModelViewerEvent {
  const factory _LoadModel(final String assetPath) = _$LoadModelImpl;

  @override
  String get assetPath;

  /// Create a copy of ModelViewerEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadModelImplCopyWith<_$LoadModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
