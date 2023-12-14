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
import 'package:intl/intl.dart';
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
    chatStream = FirebaseUtils.getLatestMessage(chatUser);
    chatStreamSubscription = chatStream.listen((newData) {
      if (isFirstLoad) {
        isFirstLoad = false;
        return;
      }
      if (newData.docs.isNotEmpty && !isFirstLoad) {
        final newListMessage =
            newData.docs.map((e) => MessageModel.fromJson(e.data())).toList();
        final newListDocumentSnapshot = newData.docs;

        /// Latest message
        final newMessage = newListMessage.first;
        final newDocumentSnapshot = newListDocumentSnapshot.first;

        /// Has new message in conversation (do not execute when message type is Image)
        if (currentListMessage.isNotEmpty &&
            newMessage.timeStamp != currentListMessage.first.timeStamp) {
          /// handle when message type is Text
          if (newMessage.type == MessageType.text.name) {
            insertNewItem(
                newDocumentSnapshot: newDocumentSnapshot,
                newMessage: newMessage);

            emit(NewMessageState(message: newMessage));
          }

          /// Handle when message type is Image
          else if (newMessage.type == MessageType.image.name) {
            /// Check if is out message
            if (newMessage.fromId == FirebaseUtils.me.id) {
              updateImageStatus(newMessage);
            }

            /// Check if is in message
            else {
              insertNewItem(
                  newDocumentSnapshot: newDocumentSnapshot,
                  newMessage: newMessage);

              emit(NewMessageState(message: newMessage));
            }
          }
        }

        /// New conversation
        else if (currentListMessage.isEmpty) {
          currentListMessage.insert(0, newMessage);
          currentListDocumentSnapshot.insert(0, newDocumentSnapshot);
          emit(NewMessageState(message: newMessage));
        }

        /// update message status
        else if (currentListMessage.isNotEmpty &&
            newMessage.timeStamp == currentListMessage.first.timeStamp) {
          updateReadStatus();
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

    animatedListNotifier = AnimatedListNotifier();
  }

  Future<void> loadMoreMessage({
    required ChatUser chatUser,
    required int numberOfItem,
    required DocumentSnapshot lastItemVisible,
  }) async {
    print('x..................');

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
