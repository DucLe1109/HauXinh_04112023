import 'package:boilerplate/features/personal_chat/cubit/chat_state.dart';
import 'package:boilerplate/firebase/firebase_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_bloc/d_bloc.dart';
import 'package:rest_client/rest_client.dart';

class ChatCubit extends DCubit {
  bool isFirstLoad = true;
  Message lastSendingMessage = const Message();
  final ChatUser chatUser;
  final currentTotalMessage = 0;

  ChatCubit(this.chatUser) {
    FirebaseUtils.getAllMessages(chatUser).listen((newData) {
      if (!isFirstLoad) {
        final List<Message> list =
            newData.docs.map((e) => Message.fromJson(e.data())).toList();
        if (list.last.fromId != FirebaseUtils.user?.uid) {
          emit(NewMessageState(message: list.last));
        }
      }
    }, cancelOnError: false, onError: _onError);
  }

  Future<void> getNewestMessage(
      {required ChatUser chatUser, required int amount}) async {
    try {
      emit(const LoadingState());
      final result = await FirebaseUtils.getNewestMessage(
          amount: amount, chatUser: chatUser);
      final listMessage =
          result.docs.map((e) => Message.fromJson(e.data())).toList();
      emit(SuccessState(data: listMessage));
      isFirstLoad = listMessage.isEmpty;
    } on FirebaseException catch (e) {
      emit(ErrorState(
          error: DefaultException(
              message: FirebaseUtils.handleException(e.code), statusCode: -1)));
    }
  }

  void _onError(Object error) {}

  Future<void> sendMessage(
      {required ChatUser chatUser, required String msg}) async {
    try {
      emit(SendMessageLoadingState());
      lastSendingMessage = await FirebaseUtils.sendMessage(chatUser, msg);
      if (isFirstLoad) isFirstLoad = false;
      emit(SendMessageSuccessState(
        message: lastSendingMessage,
      ));
    } on FirebaseException catch (e) {
      emit(ErrorState(
          error: DefaultException(
              message: FirebaseUtils.handleException(e.code), statusCode: -1)));
    }
  }
}
