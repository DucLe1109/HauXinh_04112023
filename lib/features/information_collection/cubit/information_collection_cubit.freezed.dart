// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'information_collection_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$InformationCollectionState {
  UIStatus get status => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $InformationCollectionStateCopyWith<InformationCollectionState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InformationCollectionStateCopyWith<$Res> {
  factory $InformationCollectionStateCopyWith(InformationCollectionState value,
          $Res Function(InformationCollectionState) then) =
      _$InformationCollectionStateCopyWithImpl<$Res,
          InformationCollectionState>;
  @useResult
  $Res call({UIStatus status});

  $UIStatusCopyWith<$Res> get status;
}

/// @nodoc
class _$InformationCollectionStateCopyWithImpl<$Res,
        $Val extends InformationCollectionState>
    implements $InformationCollectionStateCopyWith<$Res> {
  _$InformationCollectionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as UIStatus,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UIStatusCopyWith<$Res> get status {
    return $UIStatusCopyWith<$Res>(_value.status, (value) {
      return _then(_value.copyWith(status: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$InformationCollectionStateImplCopyWith<$Res>
    implements $InformationCollectionStateCopyWith<$Res> {
  factory _$$InformationCollectionStateImplCopyWith(
          _$InformationCollectionStateImpl value,
          $Res Function(_$InformationCollectionStateImpl) then) =
      __$$InformationCollectionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({UIStatus status});

  @override
  $UIStatusCopyWith<$Res> get status;
}

/// @nodoc
class __$$InformationCollectionStateImplCopyWithImpl<$Res>
    extends _$InformationCollectionStateCopyWithImpl<$Res,
        _$InformationCollectionStateImpl>
    implements _$$InformationCollectionStateImplCopyWith<$Res> {
  __$$InformationCollectionStateImplCopyWithImpl(
      _$InformationCollectionStateImpl _value,
      $Res Function(_$InformationCollectionStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
  }) {
    return _then(_$InformationCollectionStateImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as UIStatus,
    ));
  }
}

/// @nodoc

class _$InformationCollectionStateImpl implements _InformationCollectionState {
  const _$InformationCollectionStateImpl({this.status = const UIInitial()});

  @override
  @JsonKey()
  final UIStatus status;

  @override
  String toString() {
    return 'InformationCollectionState(status: $status)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InformationCollectionStateImpl &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InformationCollectionStateImplCopyWith<_$InformationCollectionStateImpl>
      get copyWith => __$$InformationCollectionStateImplCopyWithImpl<
          _$InformationCollectionStateImpl>(this, _$identity);
}

abstract class _InformationCollectionState
    implements InformationCollectionState {
  const factory _InformationCollectionState({final UIStatus status}) =
      _$InformationCollectionStateImpl;

  @override
  UIStatus get status;
  @override
  @JsonKey(ignore: true)
  _$$InformationCollectionStateImplCopyWith<_$InformationCollectionStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
