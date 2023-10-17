// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dog_image.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

DogImage _$DogImageFromJson(Map<String, dynamic> json) {
  return _DogImage.fromJson(json);
}

/// @nodoc
mixin _$DogImage {
  String get message => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DogImageCopyWith<DogImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DogImageCopyWith<$Res> {
  factory $DogImageCopyWith(DogImage value, $Res Function(DogImage) then) =
      _$DogImageCopyWithImpl<$Res, DogImage>;
  @useResult
  $Res call({String message, String status});
}

/// @nodoc
class _$DogImageCopyWithImpl<$Res, $Val extends DogImage>
    implements $DogImageCopyWith<$Res> {
  _$DogImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DogImageImplCopyWith<$Res>
    implements $DogImageCopyWith<$Res> {
  factory _$$DogImageImplCopyWith(
          _$DogImageImpl value, $Res Function(_$DogImageImpl) then) =
      __$$DogImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, String status});
}

/// @nodoc
class __$$DogImageImplCopyWithImpl<$Res>
    extends _$DogImageCopyWithImpl<$Res, _$DogImageImpl>
    implements _$$DogImageImplCopyWith<$Res> {
  __$$DogImageImplCopyWithImpl(
      _$DogImageImpl _value, $Res Function(_$DogImageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? status = null,
  }) {
    return _then(_$DogImageImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DogImageImpl implements _DogImage {
  const _$DogImageImpl({required this.message, required this.status});

  factory _$DogImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$DogImageImplFromJson(json);

  @override
  final String message;
  @override
  final String status;

  @override
  String toString() {
    return 'DogImage(message: $message, status: $status)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DogImageImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, message, status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DogImageImplCopyWith<_$DogImageImpl> get copyWith =>
      __$$DogImageImplCopyWithImpl<_$DogImageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DogImageImplToJson(
      this,
    );
  }
}

abstract class _DogImage implements DogImage {
  const factory _DogImage(
      {required final String message,
      required final String status}) = _$DogImageImpl;

  factory _DogImage.fromJson(Map<String, dynamic> json) =
      _$DogImageImpl.fromJson;

  @override
  String get message;
  @override
  String get status;
  @override
  @JsonKey(ignore: true)
  _$$DogImageImplCopyWith<_$DogImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
