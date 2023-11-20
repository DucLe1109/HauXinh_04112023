import 'package:boilerplate/features/personal_chat/cubit/chat_state.dart';
import 'package:boilerplate/features/personal_chat/model/message_model.dart';
import 'package:boilerplate/features/personal_chat/notifier/animated_list_notifier.dart';
import 'package:boilerplate/firebase/firebase_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_bloc/d_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rest_client/rest_client.dart';

class ChatCubit extends DCubit {
  ChatCubit() {
    currentListMessage = [];
    currentListDocumentSnapshot = [];
    animatedListNotifier = AnimatedListNotifier(messages: currentListMessage);
  }

  void listenMessageStream(ChatUser chatUser) {
    chatStream = FirebaseUtils.getLatestMessage(chatUser);
    chatStream.listen((newData) {
      if (newData.docs.isNotEmpty) {
        final newListMessage =
            newData.docs.map((e) => MessageModel.fromJson(e.data())).toList();
        final newListDocumentSnapshot = newData.docs;

        /// Has new message in conversation
        if (currentListMessage.isNotEmpty &&
            newListMessage.first.timeStamp !=
                currentListMessage.first.timeStamp) {
          currentListMessage.insert(0, newListMessage.first);

          /// Check if has limit number of message in chat screen
          if (currentListMessage.length > numOfInitialMessage) {
            currentListDocumentSnapshot
              ..insert(0, newListDocumentSnapshot.first)
              ..removeLast();
          }

          ///
          else {
            currentListDocumentSnapshot.insert(
                0, newListDocumentSnapshot.first);
          }

          emit(NewMessageState(message: newListMessage.first));
        }

        /// New conversation
        else if (currentListMessage.isEmpty) {
          currentListMessage.insert(0, newListMessage.first);
          currentListDocumentSnapshot.insert(0, newListDocumentSnapshot.first);
          emit(NewMessageState(message: newListMessage.first));
        }

        /// update message status
        else if (currentListMessage.isNotEmpty &&
            newListMessage.first.timeStamp ==
                currentListMessage.first.timeStamp) {
          updateReadStatus();
          reloadAnimatedList();
        }
      }
    });
  }

  void updateReadStatus() {
    for (final e in currentListMessage) {
      if (e.readAt?.isEmpty ?? false) {
        e.readAt = DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());
      }
    }
  }

  Future<void> initData(
      {required ChatUser chatUser, required int numberOfItem}) async {
    emit(InitiateData());
    try {
      final QuerySnapshot<Map<String, dynamic>> initialData =
          await FirebaseUtils.getMessage(
              chatUser: chatUser, numberOfItem: numberOfItem);
      if (initialData.docs.isNotEmpty) {
        currentListMessage = initialData.docs
            .map((e) => MessageModel.fromJson(e.data()))
            .toList();
        currentListDocumentSnapshot = initialData.docs;
      }
      emit(InitiateDataSuccessFully());

      /// Start listen new message
      listenMessageStream(chatUser);
    } on FirebaseException catch (e) {
      emit(ErrorState(
          error: DefaultException(
              message: FirebaseUtils.handleException(e.code), statusCode: -1)));
    }

    animatedListNotifier = AnimatedListNotifier(messages: currentListMessage);
  }

  Future<void> loadMoreMessage({
    required ChatUser chatUser,
    required int numberOfItem,
    required DocumentSnapshot lastItemVisible,
  }) async {
    if (!isLoadMoreDone) emit(LoadingMore());
    try {
      final additionalMessage = await FirebaseUtils.getMessage(
          chatUser: chatUser,
          numberOfItem: numberOfItem,
          lastItemVisible: lastItemVisible);

      if (additionalMessage.docs.isNotEmpty) {
        final additionalMessageModel =
            additionalMessage.docs.map((e) => MessageModel.fromJson(e.data()));

        final additionalMessageSnapshot = additionalMessage.docs;

        currentListMessage.addAll(additionalMessageModel);
        currentListDocumentSnapshot.addAll(additionalMessageSnapshot);

        emit(LoadMoreSuccessfully(
            numberOfNewMessage: additionalMessageModel.length));
      } else {
        emit(LoadMoreDone());
        isLoadMoreDone = true;
      }
    } on FirebaseException catch (e) {
      emit(ErrorState(
          error: DefaultException(
              message: FirebaseUtils.handleException(e.code), statusCode: -1)));
    }
  }

  void reloadAnimatedList() {
    animatedListNotifier.reloadList(newData: currentListMessage);
  }

  late Stream<QuerySnapshot<Map<String, dynamic>>> chatStream;
  late List<MessageModel> currentListMessage;
  late AnimatedListNotifier animatedListNotifier;
  late List<DocumentSnapshot> currentListDocumentSnapshot;
  int numOfInitialMessage = 50;
  bool isLoadMoreDone = false;
}
