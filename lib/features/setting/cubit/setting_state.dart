part of 'setting_cubit.dart';

@Freezed()
class SettingState with _$SettingState {
  const factory SettingState({
    @Default(UIInitial()) UIStatus status,
  }) = _SettingState;
}