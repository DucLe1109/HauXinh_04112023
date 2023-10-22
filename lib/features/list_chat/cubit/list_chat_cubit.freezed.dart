// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'list_chat_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ListChatState {
  UIStatus get status => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ListChatStateCopyWith<ListChatState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListChatStateCopyWith<$Res> {
  factory $ListChatStateCopyWith(
          ListChatState value, $Res Function(ListChatState) then) =
      _$ListChatStateCopyWithImpl<$Res, ListChatState>;
  @useResult
  $Res call({UIStatus status});

  $UIStatusCopyWith<$Res> get status;
}

/// @nodoc
class _$ListChatStateCopyWithImpl<$Res, $Val extends ListChatState>
    implements $ListChatStateCopyWith<$Res> {
  _$ListChatStateCopyWithImpl(this._value, this._then);

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
abstract class _$$ListChatStateImplCopyWith<$Res>
    implements $ListChatStateCopyWith<$Res> {
  factory _$$ListChatStateImplCopyWith(
          _$ListChatStateImpl value, $Res Function(_$ListChatStateImpl) then) =
      __$$ListChatStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({UIStatus status});

  @override
  $UIStatusCopyWith<$Res> get status;
}

/// @nodoc
class __$$ListChatStateImplCopyWithImpl<$Res>
    extends _$ListChatStateCopyWithImpl<$Res, _$ListChatStateImpl>
    implements _$$ListChatStateImplCopyWith<$Res> {
  __$$ListChatStateImplCopyWithImpl(
      _$ListChatStateImpl _value, $Res Function(_$ListChatStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
  }) {
    return _then(_$ListChatStateImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as UIStatus,
    ));
  }
}

/// @nodoc

class _$ListChatStateImpl implements _ListChatState {
  const _$ListChatStateImpl({this.status = const UIInitial()});

  @override
  @JsonKey()
  final UIStatus status;

  @override
  String toString() {
    return 'ListChatState(status: $status)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ListChatStateImpl &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ListChatStateImplCopyWith<_$ListChatStateImpl> get copyWith =>
      __$$ListChatStateImplCopyWithImpl<_$ListChatStateImpl>(this, _$identity);
}

abstract class _ListChatState implements ListChatState {
  const factory _ListChatState({final UIStatus status}) = _$ListChatStateImpl;

  @override
  UIStatus get status;
  @override
  @JsonKey(ignore: true)
  _$$ListChatStateImplCopyWith<_$ListChatStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
