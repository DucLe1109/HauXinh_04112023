part of 'list_chat_cubit.dart';

@Freezed()
class ListChatState with _$ListChatState {
  const factory ListChatState({
    @Default(UIInitial()) UIStatus status,
  }) = _ListChatState;
}
