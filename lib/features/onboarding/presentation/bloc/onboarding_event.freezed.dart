// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$OnboardingEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int page) pageChanged,
    required TResult Function() nextPage,
    required TResult Function() skipOnboarding,
    required TResult Function() completeOnboarding,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int page)? pageChanged,
    TResult? Function()? nextPage,
    TResult? Function()? skipOnboarding,
    TResult? Function()? completeOnboarding,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int page)? pageChanged,
    TResult Function()? nextPage,
    TResult Function()? skipOnboarding,
    TResult Function()? completeOnboarding,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PageChanged value) pageChanged,
    required TResult Function(_NextPage value) nextPage,
    required TResult Function(_SkipOnboarding value) skipOnboarding,
    required TResult Function(_CompleteOnboarding value) completeOnboarding,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PageChanged value)? pageChanged,
    TResult? Function(_NextPage value)? nextPage,
    TResult? Function(_SkipOnboarding value)? skipOnboarding,
    TResult? Function(_CompleteOnboarding value)? completeOnboarding,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PageChanged value)? pageChanged,
    TResult Function(_NextPage value)? nextPage,
    TResult Function(_SkipOnboarding value)? skipOnboarding,
    TResult Function(_CompleteOnboarding value)? completeOnboarding,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OnboardingEventCopyWith<$Res> {
  factory $OnboardingEventCopyWith(
    OnboardingEvent value,
    $Res Function(OnboardingEvent) then,
  ) = _$OnboardingEventCopyWithImpl<$Res, OnboardingEvent>;
}

/// @nodoc
class _$OnboardingEventCopyWithImpl<$Res, $Val extends OnboardingEvent>
    implements $OnboardingEventCopyWith<$Res> {
  _$OnboardingEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OnboardingEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$PageChangedImplCopyWith<$Res> {
  factory _$$PageChangedImplCopyWith(
    _$PageChangedImpl value,
    $Res Function(_$PageChangedImpl) then,
  ) = __$$PageChangedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int page});
}

/// @nodoc
class __$$PageChangedImplCopyWithImpl<$Res>
    extends _$OnboardingEventCopyWithImpl<$Res, _$PageChangedImpl>
    implements _$$PageChangedImplCopyWith<$Res> {
  __$$PageChangedImplCopyWithImpl(
    _$PageChangedImpl _value,
    $Res Function(_$PageChangedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OnboardingEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? page = null}) {
    return _then(
      _$PageChangedImpl(
        null == page
            ? _value.page
            : page // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$PageChangedImpl implements _PageChanged {
  const _$PageChangedImpl(this.page);

  @override
  final int page;

  @override
  String toString() {
    return 'OnboardingEvent.pageChanged(page: $page)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PageChangedImpl &&
            (identical(other.page, page) || other.page == page));
  }

  @override
  int get hashCode => Object.hash(runtimeType, page);

  /// Create a copy of OnboardingEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PageChangedImplCopyWith<_$PageChangedImpl> get copyWith =>
      __$$PageChangedImplCopyWithImpl<_$PageChangedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int page) pageChanged,
    required TResult Function() nextPage,
    required TResult Function() skipOnboarding,
    required TResult Function() completeOnboarding,
  }) {
    return pageChanged(page);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int page)? pageChanged,
    TResult? Function()? nextPage,
    TResult? Function()? skipOnboarding,
    TResult? Function()? completeOnboarding,
  }) {
    return pageChanged?.call(page);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int page)? pageChanged,
    TResult Function()? nextPage,
    TResult Function()? skipOnboarding,
    TResult Function()? completeOnboarding,
    required TResult orElse(),
  }) {
    if (pageChanged != null) {
      return pageChanged(page);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PageChanged value) pageChanged,
    required TResult Function(_NextPage value) nextPage,
    required TResult Function(_SkipOnboarding value) skipOnboarding,
    required TResult Function(_CompleteOnboarding value) completeOnboarding,
  }) {
    return pageChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PageChanged value)? pageChanged,
    TResult? Function(_NextPage value)? nextPage,
    TResult? Function(_SkipOnboarding value)? skipOnboarding,
    TResult? Function(_CompleteOnboarding value)? completeOnboarding,
  }) {
    return pageChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PageChanged value)? pageChanged,
    TResult Function(_NextPage value)? nextPage,
    TResult Function(_SkipOnboarding value)? skipOnboarding,
    TResult Function(_CompleteOnboarding value)? completeOnboarding,
    required TResult orElse(),
  }) {
    if (pageChanged != null) {
      return pageChanged(this);
    }
    return orElse();
  }
}

abstract class _PageChanged implements OnboardingEvent {
  const factory _PageChanged(final int page) = _$PageChangedImpl;

  int get page;

  /// Create a copy of OnboardingEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PageChangedImplCopyWith<_$PageChangedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NextPageImplCopyWith<$Res> {
  factory _$$NextPageImplCopyWith(
    _$NextPageImpl value,
    $Res Function(_$NextPageImpl) then,
  ) = __$$NextPageImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NextPageImplCopyWithImpl<$Res>
    extends _$OnboardingEventCopyWithImpl<$Res, _$NextPageImpl>
    implements _$$NextPageImplCopyWith<$Res> {
  __$$NextPageImplCopyWithImpl(
    _$NextPageImpl _value,
    $Res Function(_$NextPageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OnboardingEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$NextPageImpl implements _NextPage {
  const _$NextPageImpl();

  @override
  String toString() {
    return 'OnboardingEvent.nextPage()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$NextPageImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int page) pageChanged,
    required TResult Function() nextPage,
    required TResult Function() skipOnboarding,
    required TResult Function() completeOnboarding,
  }) {
    return nextPage();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int page)? pageChanged,
    TResult? Function()? nextPage,
    TResult? Function()? skipOnboarding,
    TResult? Function()? completeOnboarding,
  }) {
    return nextPage?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int page)? pageChanged,
    TResult Function()? nextPage,
    TResult Function()? skipOnboarding,
    TResult Function()? completeOnboarding,
    required TResult orElse(),
  }) {
    if (nextPage != null) {
      return nextPage();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PageChanged value) pageChanged,
    required TResult Function(_NextPage value) nextPage,
    required TResult Function(_SkipOnboarding value) skipOnboarding,
    required TResult Function(_CompleteOnboarding value) completeOnboarding,
  }) {
    return nextPage(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PageChanged value)? pageChanged,
    TResult? Function(_NextPage value)? nextPage,
    TResult? Function(_SkipOnboarding value)? skipOnboarding,
    TResult? Function(_CompleteOnboarding value)? completeOnboarding,
  }) {
    return nextPage?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PageChanged value)? pageChanged,
    TResult Function(_NextPage value)? nextPage,
    TResult Function(_SkipOnboarding value)? skipOnboarding,
    TResult Function(_CompleteOnboarding value)? completeOnboarding,
    required TResult orElse(),
  }) {
    if (nextPage != null) {
      return nextPage(this);
    }
    return orElse();
  }
}

abstract class _NextPage implements OnboardingEvent {
  const factory _NextPage() = _$NextPageImpl;
}

/// @nodoc
abstract class _$$SkipOnboardingImplCopyWith<$Res> {
  factory _$$SkipOnboardingImplCopyWith(
    _$SkipOnboardingImpl value,
    $Res Function(_$SkipOnboardingImpl) then,
  ) = __$$SkipOnboardingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SkipOnboardingImplCopyWithImpl<$Res>
    extends _$OnboardingEventCopyWithImpl<$Res, _$SkipOnboardingImpl>
    implements _$$SkipOnboardingImplCopyWith<$Res> {
  __$$SkipOnboardingImplCopyWithImpl(
    _$SkipOnboardingImpl _value,
    $Res Function(_$SkipOnboardingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OnboardingEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SkipOnboardingImpl implements _SkipOnboarding {
  const _$SkipOnboardingImpl();

  @override
  String toString() {
    return 'OnboardingEvent.skipOnboarding()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SkipOnboardingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int page) pageChanged,
    required TResult Function() nextPage,
    required TResult Function() skipOnboarding,
    required TResult Function() completeOnboarding,
  }) {
    return skipOnboarding();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int page)? pageChanged,
    TResult? Function()? nextPage,
    TResult? Function()? skipOnboarding,
    TResult? Function()? completeOnboarding,
  }) {
    return skipOnboarding?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int page)? pageChanged,
    TResult Function()? nextPage,
    TResult Function()? skipOnboarding,
    TResult Function()? completeOnboarding,
    required TResult orElse(),
  }) {
    if (skipOnboarding != null) {
      return skipOnboarding();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PageChanged value) pageChanged,
    required TResult Function(_NextPage value) nextPage,
    required TResult Function(_SkipOnboarding value) skipOnboarding,
    required TResult Function(_CompleteOnboarding value) completeOnboarding,
  }) {
    return skipOnboarding(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PageChanged value)? pageChanged,
    TResult? Function(_NextPage value)? nextPage,
    TResult? Function(_SkipOnboarding value)? skipOnboarding,
    TResult? Function(_CompleteOnboarding value)? completeOnboarding,
  }) {
    return skipOnboarding?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PageChanged value)? pageChanged,
    TResult Function(_NextPage value)? nextPage,
    TResult Function(_SkipOnboarding value)? skipOnboarding,
    TResult Function(_CompleteOnboarding value)? completeOnboarding,
    required TResult orElse(),
  }) {
    if (skipOnboarding != null) {
      return skipOnboarding(this);
    }
    return orElse();
  }
}

abstract class _SkipOnboarding implements OnboardingEvent {
  const factory _SkipOnboarding() = _$SkipOnboardingImpl;
}

/// @nodoc
abstract class _$$CompleteOnboardingImplCopyWith<$Res> {
  factory _$$CompleteOnboardingImplCopyWith(
    _$CompleteOnboardingImpl value,
    $Res Function(_$CompleteOnboardingImpl) then,
  ) = __$$CompleteOnboardingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CompleteOnboardingImplCopyWithImpl<$Res>
    extends _$OnboardingEventCopyWithImpl<$Res, _$CompleteOnboardingImpl>
    implements _$$CompleteOnboardingImplCopyWith<$Res> {
  __$$CompleteOnboardingImplCopyWithImpl(
    _$CompleteOnboardingImpl _value,
    $Res Function(_$CompleteOnboardingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OnboardingEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CompleteOnboardingImpl implements _CompleteOnboarding {
  const _$CompleteOnboardingImpl();

  @override
  String toString() {
    return 'OnboardingEvent.completeOnboarding()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CompleteOnboardingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int page) pageChanged,
    required TResult Function() nextPage,
    required TResult Function() skipOnboarding,
    required TResult Function() completeOnboarding,
  }) {
    return completeOnboarding();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int page)? pageChanged,
    TResult? Function()? nextPage,
    TResult? Function()? skipOnboarding,
    TResult? Function()? completeOnboarding,
  }) {
    return completeOnboarding?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int page)? pageChanged,
    TResult Function()? nextPage,
    TResult Function()? skipOnboarding,
    TResult Function()? completeOnboarding,
    required TResult orElse(),
  }) {
    if (completeOnboarding != null) {
      return completeOnboarding();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PageChanged value) pageChanged,
    required TResult Function(_NextPage value) nextPage,
    required TResult Function(_SkipOnboarding value) skipOnboarding,
    required TResult Function(_CompleteOnboarding value) completeOnboarding,
  }) {
    return completeOnboarding(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PageChanged value)? pageChanged,
    TResult? Function(_NextPage value)? nextPage,
    TResult? Function(_SkipOnboarding value)? skipOnboarding,
    TResult? Function(_CompleteOnboarding value)? completeOnboarding,
  }) {
    return completeOnboarding?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PageChanged value)? pageChanged,
    TResult Function(_NextPage value)? nextPage,
    TResult Function(_SkipOnboarding value)? skipOnboarding,
    TResult Function(_CompleteOnboarding value)? completeOnboarding,
    required TResult orElse(),
  }) {
    if (completeOnboarding != null) {
      return completeOnboarding(this);
    }
    return orElse();
  }
}

abstract class _CompleteOnboarding implements OnboardingEvent {
  const factory _CompleteOnboarding() = _$CompleteOnboardingImpl;
}
