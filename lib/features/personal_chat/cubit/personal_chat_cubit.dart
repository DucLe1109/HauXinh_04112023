import 'dart:async';
import 'dart:io';

import 'package:boilerplate/core/global_variable.dart';
import 'package:boilerplate/features/personal_chat/cubit/personal_chat_state.dart';
import 'package:boilerplate/features/personal_chat/message_type.dart';
import 'package:boilerplate/features/personal_chat/model/message_model.dart';
import 'package:boilerplate/features/personal_chat/notifier/animated_list_notifier.dart';
import 'package:boilerplate/firebase/firebase_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_bloc/d_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rest_client/rest_client.dart';

class PersonalChatCubit extends DCubit {
  late Stream<QuerySnapshot<Map<String, dynamic>>> chatStream;
  late List<MessageModel> currentListMessage;
  late AnimatedListNotifier animatedListNotifier;
  late List<DocumentSnapshot> currentListDocumentSnapshot;
  bool isLoadMoreDone = false;
  bool isFirstLoad = true;
  late StreamSubscription chatStreamSubscription;

  PersonalChatCubit() {
    currentListMessage = [];
    currentListDocumentSnapshot = [];
    animatedListNotifier = AnimatedListNotifier();
  }

  void listenMessageStream(ChatUser chatUser) {
    chatStream = FirebaseUtils.getLatestMessage(chatUser: chatUser);
    chatStreamSubscription = chatStream.listen((newData) {
      if (isFirstLoad) {
        isFirstLoad = false;
        return;
      }
      if (newData.docs.isNotEmpty && !isFirstLoad) {
        final newListMessage =
            newData.docs.map((e) => MessageModel.fromJson(e.data())).toList();
        final newListDocumentSnapshot = newData.docs;

        /// first message
        final firstMessage = newListMessage.first;
        final firstDocumentSnapshot = newListDocumentSnapshot.first;

        /// Has new message in conversation (do not execute when message type is Image)
        if (currentListMessage.isNotEmpty &&
            firstMessage.timeStamp != currentListMessage.first.timeStamp) {
          /// handle when message type is Text
          if (firstMessage.type == MessageType.text.name) {
            insertNewItem(
                newDocumentSnapshot: firstDocumentSnapshot,
                newMessage: firstMessage);

            emit(NewMessageState(message: firstMessage));
          }

          /// Handle when message type is Image
          else if (firstMessage.type == MessageType.image.name) {
            /// Check if is out message
            if (firstMessage.fromId == FirebaseUtils.me.id) {
              updateImageStatus(firstMessage);
            }

            /// Check if is in message
            else {
              insertNewItem(
                  newDocumentSnapshot: firstDocumentSnapshot,
                  newMessage: firstMessage);

              emit(NewMessageState(message: firstMessage));
            }
          }
        }

        /// New conversation
        else if (currentListMessage.isEmpty) {
          currentListMessage.insert(0, firstMessage);
          currentListDocumentSnapshot.insert(0, firstDocumentSnapshot);
          emit(NewMessageState(message: firstMessage));
        }

        /// update message status
        else if (currentListMessage.isNotEmpty &&
            firstMessage.timeStamp == currentListMessage.first.timeStamp) {
          updateReadStatus(newListMessage);
          updateInteractionStatus(newListMessage);
          reloadAnimatedList();
        }
      }
    });
  }

  void stopListenMessageStream() {
    chatStreamSubscription.cancel();
  }

  void updateImageStatus(MessageModel newMessage) {
    currentListMessage
        .where((element) =>
            element.imageCacheUri == newMessage.imageCacheUri &&
            element.type == MessageType.temp.name)
        .firstOrNull
      ?..type = MessageType.local.name
      ..timeStamp = newMessage.timeStamp
      ..fromId = newMessage.fromId
      ..interaction = newMessage.interaction
      ..readAt = newMessage.readAt
      ..toId = newMessage.toId;

    reloadAnimatedList();
  }

  void insertNewItem({
    required MessageModel newMessage,
    required DocumentSnapshot newDocumentSnapshot,
  }) {
    currentListMessage.insert(0, newMessage);

    /// Check if has limit number of message in chat screen
    if (currentListMessage.length > numOfMessagePerPage) {
      currentListDocumentSnapshot
        ..insert(0, newDocumentSnapshot)
        ..removeLast();
    }

    ///
    else {
      currentListDocumentSnapshot.insert(0, newDocumentSnapshot);
    }
  }

  void updateReadStatus(List<MessageModel> newListMessage) {
    for (int i = 0; i < newListMessage.length; i++) {
      currentListMessage[i].readAt = newListMessage[i].readAt;
    }
  }

  void updateInteractionStatus(List<MessageModel> newListMessage) {
    for (int i = 0; i < newListMessage.length; i++) {
      currentListMessage[i].interaction = newListMessage[i].interaction;
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

    animatedListNotifier = AnimatedListNotifier();
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
    animatedListNotifier.reloadList();
  }

  Future<void> sendAllMessage(
      {required List<XFile> photos, required ChatUser chatUser}) async {
    final List<FirebaseException> exceptions = [];
    emit(SendingFile());
    for (final XFile e in List.from(photos)) {
      try {
        await FirebaseUtils.sendFile(chatUser: chatUser, file: File(e.path));
      } on FirebaseException catch (e) {
        exceptions.add(e);
      }
    }

    if (exceptions.isEmpty) {
      emit(SendFileSuccessfully());
    } else {
      emit(ErrorState(
          error: DefaultException(
              message: FirebaseUtils.handleException(exceptions.first.code),
              statusCode: -1)));
    }
  }

  void clearRedundantData() {
    if (currentListMessage.length > numOfMessagePerPage) {
      final redundantDataCount =
          currentListMessage.length - numOfMessagePerPage;

      currentListMessage.removeRange(
          currentListMessage.length - redundantDataCount,
          currentListMessage.length);

      currentListDocumentSnapshot.removeRange(
          currentListDocumentSnapshot.length - redundantDataCount,
          currentListDocumentSnapshot.length);

      // reloadAnimatedList();
    }
  }
}
