part of 'home_cubit.dart';

@Freezed()
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(UIInitial()) UIStatus status,
  }) = _HomeState;
}
