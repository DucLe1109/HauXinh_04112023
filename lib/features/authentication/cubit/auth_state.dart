part of 'auth_cubit.dart';

@Freezed()
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(UIInitial()) UIStatus status,
  }) = _AuthState;
}