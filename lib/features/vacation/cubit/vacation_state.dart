part of 'vacation_cubit.dart';

@Freezed()
class VacationState with _$VacationState {
  const factory VacationState({
    @Default(UIInitial()) UIStatus status,
  }) = _VacationState;
}
