part of 'contact_cubit.dart';

@Freezed()
class ContactState with _$ContactState {
  const factory ContactState({
    @Default(UIInitial()) UIStatus status,
  }) = _ContactState;
}
