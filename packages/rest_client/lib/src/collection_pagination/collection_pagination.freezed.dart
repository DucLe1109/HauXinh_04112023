// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'collection_pagination.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

CollectionPagination<T> _$CollectionPaginationFromJson<T>(
    Map<String, dynamic> json, T Function(Object?) fromJsonT) {
  return _CollectionPagination<T>.fromJson(json, fromJsonT);
}

/// @nodoc
mixin _$CollectionPagination<T> {
  @JsonKey(name: 'totalCount')
  int? get totalCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'currentCount')
  int? get currentCount => throw _privateConstructorUsedError;
  List<T> get items => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson(Object? Function(T) toJsonT) =>
      throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CollectionPaginationCopyWith<T, CollectionPagination<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CollectionPaginationCopyWith<T, $Res> {
  factory $CollectionPaginationCopyWith(CollectionPagination<T> value,
          $Res Function(CollectionPagination<T>) then) =
      _$CollectionPaginationCopyWithImpl<T, $Res>;
  $Res call(
      {@JsonKey(name: 'totalCount') int? totalCount,
      @JsonKey(name: 'currentCount') int? currentCount,
      List<T> items});
}

/// @nodoc
class _$CollectionPaginationCopyWithImpl<T, $Res>
    implements $CollectionPaginationCopyWith<T, $Res> {
  _$CollectionPaginationCopyWithImpl(this._value, this._then);

  final CollectionPagination<T> _value;
  // ignore: unused_field
  final $Res Function(CollectionPagination<T>) _then;

  @override
  $Res call({
    Object? totalCount = freezed,
    Object? currentCount = freezed,
    Object? items = freezed,
  }) {
    return _then(_value.copyWith(
      totalCount: totalCount == freezed
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int?,
      currentCount: currentCount == freezed
          ? _value.currentCount
          : currentCount // ignore: cast_nullable_to_non_nullable
              as int?,
      items: items == freezed
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
    ));
  }
}

/// @nodoc
abstract class _$$_CollectionPaginationCopyWith<T, $Res>
    implements $CollectionPaginationCopyWith<T, $Res> {
  factory _$$_CollectionPaginationCopyWith(_$_CollectionPagination<T> value,
          $Res Function(_$_CollectionPagination<T>) then) =
      __$$_CollectionPaginationCopyWithImpl<T, $Res>;
  @override
  $Res call(
      {@JsonKey(name: 'totalCount') int? totalCount,
      @JsonKey(name: 'currentCount') int? currentCount,
      List<T> items});
}

/// @nodoc
class __$$_CollectionPaginationCopyWithImpl<T, $Res>
    extends _$CollectionPaginationCopyWithImpl<T, $Res>
    implements _$$_CollectionPaginationCopyWith<T, $Res> {
  __$$_CollectionPaginationCopyWithImpl(_$_CollectionPagination<T> _value,
      $Res Function(_$_CollectionPagination<T>) _then)
      : super(_value, (v) => _then(v as _$_CollectionPagination<T>));

  @override
  _$_CollectionPagination<T> get _value =>
      super._value as _$_CollectionPagination<T>;

  @override
  $Res call({
    Object? totalCount = freezed,
    Object? currentCount = freezed,
    Object? items = freezed,
  }) {
    return _then(_$_CollectionPagination<T>(
      totalCount: totalCount == freezed
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int?,
      currentCount: currentCount == freezed
          ? _value.currentCount
          : currentCount // ignore: cast_nullable_to_non_nullable
              as int?,
      items: items == freezed
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
    ));
  }
}

/// @nodoc
@JsonSerializable(genericArgumentFactories: true)
class _$_CollectionPagination<T> implements _CollectionPagination<T> {
  const _$_CollectionPagination(
      {@JsonKey(name: 'totalCount') this.totalCount,
      @JsonKey(name: 'currentCount') this.currentCount,
      required final List<T> items})
      : _items = items;

  factory _$_CollectionPagination.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$$_CollectionPaginationFromJson(json, fromJsonT);

  @override
  @JsonKey(name: 'totalCount')
  final int? totalCount;
  @override
  @JsonKey(name: 'currentCount')
  final int? currentCount;
  final List<T> _items;
  @override
  List<T> get items {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'CollectionPagination<$T>(totalCount: $totalCount, currentCount: $currentCount, items: $items)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CollectionPagination<T> &&
            const DeepCollectionEquality()
                .equals(other.totalCount, totalCount) &&
            const DeepCollectionEquality()
                .equals(other.currentCount, currentCount) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(totalCount),
      const DeepCollectionEquality().hash(currentCount),
      const DeepCollectionEquality().hash(_items));

  @JsonKey(ignore: true)
  @override
  _$$_CollectionPaginationCopyWith<T, _$_CollectionPagination<T>>
      get copyWith =>
          __$$_CollectionPaginationCopyWithImpl<T, _$_CollectionPagination<T>>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
    return _$$_CollectionPaginationToJson<T>(this, toJsonT);
  }
}

abstract class _CollectionPagination<T> implements CollectionPagination<T> {
  const factory _CollectionPagination(
      {@JsonKey(name: 'totalCount') final int? totalCount,
      @JsonKey(name: 'currentCount') final int? currentCount,
      required final List<T> items}) = _$_CollectionPagination<T>;

  factory _CollectionPagination.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =
      _$_CollectionPagination<T>.fromJson;

  @override
  @JsonKey(name: 'totalCount')
  int? get totalCount;
  @override
  @JsonKey(name: 'currentCount')
  int? get currentCount;
  @override
  List<T> get items;
  @override
  @JsonKey(ignore: true)
  _$$_CollectionPaginationCopyWith<T, _$_CollectionPagination<T>>
      get copyWith => throw _privateConstructorUsedError;
}