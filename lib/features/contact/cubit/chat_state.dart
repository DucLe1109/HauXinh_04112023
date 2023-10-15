part of 'chat_cubit.dart';

@Freezed()
class ChatState with _$ChatState {
  const factory ChatState({
    @Default(UIInitial()) UIStatus status,
  }) = _ChatState;
}
