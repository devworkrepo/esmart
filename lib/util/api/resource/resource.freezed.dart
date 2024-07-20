// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'resource.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$ResourceTearOff {
  const _$ResourceTearOff();

  Success<T> onSuccess<T>(T data) {
    return Success<T>(
      data,
    );
  }

  Failure<T> onFailure<T>(dynamic error) {
    return Failure<T>(
      error,
    );
  }

  Loading<T> onInit<T>({T? data}) {
    return Loading<T>(
      data: data,
    );
  }
}

/// @nodoc
const $Resource = _$ResourceTearOff();

/// @nodoc
mixin _$Resource<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T data) onSuccess,
    required TResult Function(dynamic error) onFailure,
    required TResult Function(T? data) onInit,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(T data)? onSuccess,
    TResult Function(dynamic error)? onFailure,
    TResult Function(T? data)? onInit,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T data)? onSuccess,
    TResult Function(dynamic error)? onFailure,
    TResult Function(T? data)? onInit,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Success<T> value) onSuccess,
    required TResult Function(Failure<T> value) onFailure,
    required TResult Function(Loading<T> value) onInit,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(Success<T> value)? onSuccess,
    TResult Function(Failure<T> value)? onFailure,
    TResult Function(Loading<T> value)? onInit,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Success<T> value)? onSuccess,
    TResult Function(Failure<T> value)? onFailure,
    TResult Function(Loading<T> value)? onInit,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResourceCopyWith<T, $Res> {
  factory $ResourceCopyWith(
          Resource<T> value, $Res Function(Resource<T>) then) =
      _$ResourceCopyWithImpl<T, $Res>;
}

/// @nodoc
class _$ResourceCopyWithImpl<T, $Res> implements $ResourceCopyWith<T, $Res> {
  _$ResourceCopyWithImpl(this._value, this._then);

  final Resource<T> _value;
  // ignore: unused_field
  final $Res Function(Resource<T>) _then;
}

/// @nodoc
abstract class $SuccessCopyWith<T, $Res> {
  factory $SuccessCopyWith(Success<T> value, $Res Function(Success<T>) then) =
      _$SuccessCopyWithImpl<T, $Res>;
  $Res call({T data});
}

/// @nodoc
class _$SuccessCopyWithImpl<T, $Res> extends _$ResourceCopyWithImpl<T, $Res>
    implements $SuccessCopyWith<T, $Res> {
  _$SuccessCopyWithImpl(Success<T> _value, $Res Function(Success<T>) _then)
      : super(_value, (v) => _then(v as Success<T>));

  @override
  Success<T> get _value => super._value as Success<T>;

  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(Success<T>(
      data == freezed
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$Success<T> with DiagnosticableTreeMixin implements Success<T> {
  const _$Success(this.data);

  @override
  final T data;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Resource<$T>.onSuccess(data: $data)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Resource<$T>.onSuccess'))
      ..add(DiagnosticsProperty('data', data));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Success<T> &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(data);

  @JsonKey(ignore: true)
  @override
  $SuccessCopyWith<T, Success<T>> get copyWith =>
      _$SuccessCopyWithImpl<T, Success<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T data) onSuccess,
    required TResult Function(dynamic error) onFailure,
    required TResult Function(T? data) onInit,
  }) {
    return onSuccess(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(T data)? onSuccess,
    TResult Function(dynamic error)? onFailure,
    TResult Function(T? data)? onInit,
  }) {
    return onSuccess?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T data)? onSuccess,
    TResult Function(dynamic error)? onFailure,
    TResult Function(T? data)? onInit,
    required TResult orElse(),
  }) {
    if (onSuccess != null) {
      return onSuccess(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Success<T> value) onSuccess,
    required TResult Function(Failure<T> value) onFailure,
    required TResult Function(Loading<T> value) onInit,
  }) {
    return onSuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(Success<T> value)? onSuccess,
    TResult Function(Failure<T> value)? onFailure,
    TResult Function(Loading<T> value)? onInit,
  }) {
    return onSuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Success<T> value)? onSuccess,
    TResult Function(Failure<T> value)? onFailure,
    TResult Function(Loading<T> value)? onInit,
    required TResult orElse(),
  }) {
    if (onSuccess != null) {
      return onSuccess(this);
    }
    return orElse();
  }
}

abstract class Success<T> implements Resource<T> {
  const factory Success(T data) = _$Success<T>;

  T get data => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SuccessCopyWith<T, Success<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FailureCopyWith<T, $Res> {
  factory $FailureCopyWith(Failure<T> value, $Res Function(Failure<T>) then) =
      _$FailureCopyWithImpl<T, $Res>;
  $Res call({dynamic error});
}

/// @nodoc
class _$FailureCopyWithImpl<T, $Res> extends _$ResourceCopyWithImpl<T, $Res>
    implements $FailureCopyWith<T, $Res> {
  _$FailureCopyWithImpl(Failure<T> _value, $Res Function(Failure<T>) _then)
      : super(_value, (v) => _then(v as Failure<T>));

  @override
  Failure<T> get _value => super._value as Failure<T>;

  @override
  $Res call({
    Object? error = freezed,
  }) {
    return _then(Failure<T>(
      error == freezed
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc

class _$Failure<T> with DiagnosticableTreeMixin implements Failure<T> {
  const _$Failure(this.error);

  @override
  final dynamic error;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Resource<$T>.onFailure(error: $error)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Resource<$T>.onFailure'))
      ..add(DiagnosticsProperty('error', error));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Failure<T> &&
            (identical(other.error, error) ||
                const DeepCollectionEquality().equals(other.error, error)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(error);

  @JsonKey(ignore: true)
  @override
  $FailureCopyWith<T, Failure<T>> get copyWith =>
      _$FailureCopyWithImpl<T, Failure<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T data) onSuccess,
    required TResult Function(dynamic error) onFailure,
    required TResult Function(T? data) onInit,
  }) {
    return onFailure(error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(T data)? onSuccess,
    TResult Function(dynamic error)? onFailure,
    TResult Function(T? data)? onInit,
  }) {
    return onFailure?.call(error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T data)? onSuccess,
    TResult Function(dynamic error)? onFailure,
    TResult Function(T? data)? onInit,
    required TResult orElse(),
  }) {
    if (onFailure != null) {
      return onFailure(error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Success<T> value) onSuccess,
    required TResult Function(Failure<T> value) onFailure,
    required TResult Function(Loading<T> value) onInit,
  }) {
    return onFailure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(Success<T> value)? onSuccess,
    TResult Function(Failure<T> value)? onFailure,
    TResult Function(Loading<T> value)? onInit,
  }) {
    return onFailure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Success<T> value)? onSuccess,
    TResult Function(Failure<T> value)? onFailure,
    TResult Function(Loading<T> value)? onInit,
    required TResult orElse(),
  }) {
    if (onFailure != null) {
      return onFailure(this);
    }
    return orElse();
  }
}

abstract class Failure<T> implements Resource<T> {
  const factory Failure(dynamic error) = _$Failure<T>;

  dynamic get error => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FailureCopyWith<T, Failure<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoadingCopyWith<T, $Res> {
  factory $LoadingCopyWith(Loading<T> value, $Res Function(Loading<T>) then) =
      _$LoadingCopyWithImpl<T, $Res>;
  $Res call({T? data});
}

/// @nodoc
class _$LoadingCopyWithImpl<T, $Res> extends _$ResourceCopyWithImpl<T, $Res>
    implements $LoadingCopyWith<T, $Res> {
  _$LoadingCopyWithImpl(Loading<T> _value, $Res Function(Loading<T>) _then)
      : super(_value, (v) => _then(v as Loading<T>));

  @override
  Loading<T> get _value => super._value as Loading<T>;

  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(Loading<T>(
      data: data == freezed
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T?,
    ));
  }
}

/// @nodoc

class _$Loading<T> with DiagnosticableTreeMixin implements Loading<T> {
  const _$Loading({this.data});

  @override
  final T? data;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Resource<$T>.onInit(data: $data)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Resource<$T>.onInit'))
      ..add(DiagnosticsProperty('data', data));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Loading<T> &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(data);

  @JsonKey(ignore: true)
  @override
  $LoadingCopyWith<T, Loading<T>> get copyWith =>
      _$LoadingCopyWithImpl<T, Loading<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T data) onSuccess,
    required TResult Function(dynamic error) onFailure,
    required TResult Function(T? data) onInit,
  }) {
    return onInit(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(T data)? onSuccess,
    TResult Function(dynamic error)? onFailure,
    TResult Function(T? data)? onInit,
  }) {
    return onInit?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T data)? onSuccess,
    TResult Function(dynamic error)? onFailure,
    TResult Function(T? data)? onInit,
    required TResult orElse(),
  }) {
    if (onInit != null) {
      return onInit(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Success<T> value) onSuccess,
    required TResult Function(Failure<T> value) onFailure,
    required TResult Function(Loading<T> value) onInit,
  }) {
    return onInit(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(Success<T> value)? onSuccess,
    TResult Function(Failure<T> value)? onFailure,
    TResult Function(Loading<T> value)? onInit,
  }) {
    return onInit?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Success<T> value)? onSuccess,
    TResult Function(Failure<T> value)? onFailure,
    TResult Function(Loading<T> value)? onInit,
    required TResult orElse(),
  }) {
    if (onInit != null) {
      return onInit(this);
    }
    return orElse();
  }
}

abstract class Loading<T> implements Resource<T> {
  const factory Loading({T? data}) = _$Loading<T>;

  T? get data => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LoadingCopyWith<T, Loading<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
