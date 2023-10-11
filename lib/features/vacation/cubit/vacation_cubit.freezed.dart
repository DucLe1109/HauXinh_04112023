// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vacation_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$VacationState {
  UIStatus get status => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $VacationStateCopyWith<VacationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VacationStateCopyWith<$Res> {
  factory $VacationStateCopyWith(
          VacationState value, $Res Function(VacationState) then) =
      _$VacationStateCopyWithImpl<$Res, VacationState>;
  @useResult
  $Res call({UIStatus status});
}

/// @nodoc
class _$VacationStateCopyWithImpl<$Res, $Val extends VacationState>
    implements $VacationStateCopyWith<$Res> {
  _$VacationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
  }) {
    return _then(_value.copyWith(
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as UIStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VacationStateImplCopyWith<$Res>
    implements $VacationStateCopyWith<$Res> {
  factory _$$VacationStateImplCopyWith(
          _$VacationStateImpl value, $Res Function(_$VacationStateImpl) then) =
      __$$VacationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({UIStatus status});
}

/// @nodoc
class __$$VacationStateImplCopyWithImpl<$Res>
    extends _$VacationStateCopyWithImpl<$Res, _$VacationStateImpl>
    implements _$$VacationStateImplCopyWith<$Res> {
  __$$VacationStateImplCopyWithImpl(
      _$VacationStateImpl _value, $Res Function(_$VacationStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
  }) {
    return _then(_$VacationStateImpl(
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as UIStatus,
    ));
  }
}

/// @nodoc

class _$VacationStateImpl implements _VacationState {
  const _$VacationStateImpl({this.status = const UIInitial()});

  @override
  @JsonKey()
  final UIStatus status;

  @override
  String toString() {
    return 'VacationState(status: $status)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VacationStateImpl &&
            const DeepCollectionEquality().equals(other.status, status));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(status));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VacationStateImplCopyWith<_$VacationStateImpl> get copyWith =>
      __$$VacationStateImplCopyWithImpl<_$VacationStateImpl>(this, _$identity);
}

abstract class _VacationState implements VacationState {
  const factory _VacationState({final UIStatus status}) = _$VacationStateImpl;

  @override
  UIStatus get status;
  @override
  @JsonKey(ignore: true)
  _$$VacationStateImplCopyWith<_$VacationStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
