// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:boilerplate/core/global_variable.dart';
import 'package:boilerplate/features/personal_chat/message_type.dart';
import 'package:boilerplate/features/personal_chat/model/message_model.dart';
import 'package:boilerplate/firebase/model/fcm/message_notification.dart';
import 'package:boilerplate/firebase/model/fcm/notification_body.dart';
import 'package:boilerplate/firebase/model/firebase_collections.dart';
import 'package:boilerplate/firebase/model/firebase_firestore_exception.dart';
import 'package:boilerplate/generated/l10n.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:rest_client/rest_client.dart';

class FirebaseUtils {
  FirebaseUtils._();

  /// --------------- Get firebase instance ---------------

  static FirebaseFirestore get firebaseStore => FirebaseFirestore.instance;

  static FirebaseStorage get firebaseStorage => FirebaseStorage.instance;

  static FirebaseMessaging get firebaseMessaging => FirebaseMessaging.instance;

  /// --------------- End get firebase instance ---------------

  /// Firebase Notification

  static Future<void> getFCMToken() async {
    NotificationSettings? settings;
    if (Platform.isAndroid) {
      settings =
          await FirebaseMessaging.instance.requestPermission(provisional: true);
    } else if (Platform.isIOS) {
      final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      if (apnsToken != null) {
        settings = await FirebaseMessaging.instance.requestPermission();
      }
    }

    if (settings?.authorizationStatus == AuthorizationStatus.authorized) {
      await firebaseMessaging.getToken().then((value) {
        if (value != null) {
          updateUserToken(value);
        }
      });
    }
  }

  /// End firebase Notification

  /// --------------- User information ---------------
  static Future<void> createUser() async {
    final String currentTime = DateFormat('dd/MM/yyyy').format(DateTime.now());
    final ChatUser chatUser = ChatUser(
        about: '',
        createdAt: currentTime,
        email: FirebaseAuth.instance.currentUser?.email ?? '',
        id: FirebaseAuth.instance.currentUser?.uid ?? '',
        isOnline: false,
        isHasStory: false,
        lastActive: currentTime,
        fullName: FirebaseAuth.instance.currentUser?.displayName ?? '',
        pushToken: '',
        avatar: FirebaseAuth.instance.currentUser?.photoURL ?? '',
        birthday: '',
        nickName: '',
        phoneNumber: '');
    await firebaseStore
        .collection(Collections.chatUser.value)
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .set(chatUser.toJson());
  }

  static void updateUserToken(String pushToken) {
    firebaseStore
        .collection(Collections.chatUser.value)
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({ChatUserProperty.pushToken.value: pushToken});
  }

  static Future<bool> isExistUser() async {
    return (await firebaseStore
            .collection(Collections.chatUser.value)
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .get())
        .exists;
  }

  static late ChatUser me;

  static Future<void> getSelfInfo() async {
    return firebaseStore
        .collection(Collections.chatUser.value)
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
      }
    });
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getSelfInfoStream() {
    return firebaseStore
        .collection(Collections.chatUser.value)
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .snapshots();
  }

  static Future<void> updateUserInfo(
      {required String fullName,
      required String about,
      required String nickName,
      required String phone,
      required String birthday}) async {
    await firebaseStore
        .collection(Collections.chatUser.value)
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update(me
            .copyWith(
                phoneNumber: phone,
                about: about,
                birthday: birthday,
                fullName: fullName,
                nickName: nickName)
            .toJson());
  }

  static Future<void> addInformation(String nickName, String phone) async {
    await firebaseStore
        .collection(Collections.chatUser.value)
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update(me.copyWith(nickName: nickName, phoneNumber: phone).toJson());
  }

  static Future<void> updateAvatar(File file) async {
    /// get extension image
    final extension = file.path.split('.')[1];

    /// upload image
    final ref = firebaseStorage
        .ref()
        .child('avatar/${FirebaseAuth.instance.currentUser?.uid}.$extension');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/*'))
        .then((p0) {
      debugPrint('Data transferred : ${p0.bytesTransferred / 1000} kb');
    });

    /// update avatar path in firebase storage
    final String avatarPath = await ref.getDownloadURL();
    await firebaseStore
        .collection(Collections.chatUser.value)
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update(me.copyWith(avatar: avatarPath).toJson());
  }

  static Future<void> updateUserStatus({required bool isOnline}) async {
    if (FirebaseAuth.instance.currentUser != null) {
      await firebaseStore
          .collection(Collections.chatUser.value)
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update({
        ChatUserProperty.lastActive.value:
            DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now()),
        ChatUserProperty.isOnline.value: isOnline,
      });
    }
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUser user) {
    return firebaseStore
        .collection(Collections.chatUser.value)
        .doc(user.id)
        .snapshots();
  }

  /// --------------- End user information ---------------

  /// --------------- Firebase chat ---------------
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firebaseStore
        .collection(Collections.chatUser.value)
        .where(ChatUserProperty.id.value,
            isNotEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots();
  }

  /// Function to generate unique ID by 2 user id
  static String getConversationID(String id) {
    if (FirebaseAuth.instance.currentUser != null) {
      return FirebaseAuth.instance.currentUser!.uid.hashCode <= id.hashCode
          ? '${FirebaseAuth.instance.currentUser?.uid}_$id'
          : '${id}_${FirebaseAuth.instance.currentUser?.uid}';
    }
    return '';
  }

  /// Function to get all message of myself  with specific user.
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser chatUser) {
    return firebaseStore
        .collection(
            '${Collections.chats.value}/${getConversationID(chatUser.id)}/${Collections.messages.value}/')
        .orderBy(MessageProperty.timeStamp.value, descending: true)
        .snapshots();
  }

  /// Function to get message with pagination
  static Future<QuerySnapshot<Map<String, dynamic>>> getMessage(
      {required ChatUser chatUser,
      DocumentSnapshot? lastItemVisible,
      required int numberOfItem}) {
    if (lastItemVisible != null) {
      return firebaseStore
          .collection(
              '${Collections.chats.value}/${getConversationID(chatUser.id)}/${Collections.messages.value}/')
          .orderBy(MessageProperty.timeStamp.value, descending: true)
          .startAfterDocument(lastItemVisible)
          .limit(numberOfItem)
          .get();
    } else {
      return firebaseStore
          .collection(
              '${Collections.chats.value}/${getConversationID(chatUser.id)}/${Collections.messages.value}/')
          .orderBy(MessageProperty.timeStamp.value, descending: true)
          .limit(numberOfItem)
          .get();
    }
  }

  /// Function to send message to specific user.
  static Future<Message> sendMessage(
      {required ChatUser chatUser,
      required String msg,
      String? imageCacheUri,
      required MessageType messageType}) async {
    final messageID = DateTime.now().millisecondsSinceEpoch.toString();
    final now = DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());
    final ref = firebaseStore.collection(
        '${Collections.chats.value}/${getConversationID(chatUser.id)}/${Collections.messages.value}/');
    final message = Message(
      interaction: '',
      imageCacheUri: imageCacheUri,
      toId: chatUser.id,
      createdTime: now,
      updatedTime: '',
      type: messageType.name,
      readAt: '',
      msg: msg,
      timeStamp: messageID,
      fromId: FirebaseAuth.instance.currentUser?.uid,
    );
    await ref.doc(messageID).set(message.toJson()).then((value) =>
        pushNotification(
            chatUser: chatUser,
            message: messageType == MessageType.text ? msg : S.current.image));
    return message;
  }

  static void updateMessageInteraction(
      {required MessageModel messageModel,
      required bool isSender,
      String interactionType = 'heart'}) {
    final conversationId = getConversationID(
        isSender ? (messageModel.toId ?? '') : (messageModel.fromId ?? ''));
    firebaseStore
        .collection(
            '${Collections.chats.value}/$conversationId/${Collections.messages.value}/')
        .doc(messageModel.timeStamp)
        .update({MessageProperty.interaction.value: interactionType});
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> listenMessage({
    required MessageModel messageModel,
    required bool isSender,
  }) {
    final conversationId = getConversationID(
        isSender ? (messageModel.toId ?? '') : (messageModel.fromId ?? ''));
    return firebaseStore
        .collection(
            '${Collections.chats.value}/$conversationId/${Collections.messages.value}/')
        .doc(messageModel.timeStamp)
        .snapshots();
  }

  static Future<void> pushNotification(
      {required ChatUser chatUser,
      required String message,
      bool mutableContent = true,
      String sound = 'Tri-tone'}) async {
    final body = NotificationBody(
        to: chatUser.pushToken,
        notification: MessageNotification(
            android_channel_id: androidChannelId,
            title: me.fullName,
            body: message,
            mutable_content: mutableContent,
            sound: sound));

    try {
      await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'key=$firebaseMessagingServerKey'
          },
          body: json.encode(body));
    } catch (e) {
      debugPrint('Push notification error: $e');
    }
  }

  static Future<void> sendFile(
      {required ChatUser chatUser, required File file}) async {
    final extension = p.extension(file.path).replaceAll('.', '');

    final ref = firebaseStorage.ref().child(
        'chat_image/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$extension');
    await ref.putFile(file, SettableMetadata(contentType: 'image/$extension'));

    final imageUrl = await ref.getDownloadURL();

    await sendMessage(
        messageType: MessageType.image,
        chatUser: chatUser,
        msg: imageUrl,
        imageCacheUri: file.path);
  }

  /// Function to update read message
  static Future<void> readMessage(MessageModel message) {
    final now = DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());
    return firebaseStore
        .collection(
            '${Collections.chats.value}/${getConversationID(message.fromId ?? '')}/${Collections.messages.value}/')
        .doc(message.timeStamp)
        .update({MessageProperty.readAt.value: now});
  }

  /// Function to get latest message of specific user
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLatestMessage(
      {int? limit, required ChatUser chatUser}) {
    if (limit != null) {
      return firebaseStore
          .collection(
              '${Collections.chats.value}/${getConversationID(chatUser.id)}/${Collections.messages.value}/')
          .orderBy(MessageProperty.timeStamp.value, descending: true)
          .limit(limit)
          .snapshots();
    } else {
      return firebaseStore
          .collection(
              '${Collections.chats.value}/${getConversationID(chatUser.id)}/${Collections.messages.value}/')
          .orderBy(MessageProperty.timeStamp.value, descending: true)
          .snapshots();
    }
  }

  /// Function to get all unread message by user
  static Future<QuerySnapshot<Map<String, dynamic>>> getAllUnreadMessage(
      ChatUser chatUser) {
    return firebaseStore
        .collection(
            '${Collections.chats.value}/${getConversationID(chatUser.id)}/${Collections.messages.value}/')
        .where(MessageProperty.fromId.value, isEqualTo: chatUser.id)
        .where(MessageProperty.readAt.value, isEqualTo: '')
        .orderBy(MessageProperty.timeStamp.value, descending: true)
        .limit(numOfMessagePerPage)
        .get();
  }

  /// --------------- End firebase chat ---------------

  /// --------------- Firebase exception ---------------
  static String handleException(String errorCode) {
    if (errorCode == FirebaseFirestoreException.CANCELLED.code) {
      return S.current.error_code_cancelled;
    } else if (errorCode == FirebaseFirestoreException.UNKNOWN.code) {
      return S.current.error_code_unknown;
    } else if (errorCode == FirebaseFirestoreException.INVALID_ARGUMENT.code) {
      return S.current.error_code_unknown;
    } else if (errorCode == FirebaseFirestoreException.INVALID_ARGUMENT.code) {
      return S.current.error_code_invalid_argument;
    } else if (errorCode == FirebaseFirestoreException.NOT_FOUND.code) {
      return S.current.error_code_not_found;
    } else if (errorCode == FirebaseFirestoreException.ALREADY_EXISTS.code) {
      return S.current.error_code_already_exists;
    } else if (errorCode == FirebaseFirestoreException.PERMISSION_DENIED.code) {
      return S.current.error_code_permission_deny;
    } else if (errorCode == FirebaseFirestoreException.ABORTED.code) {
      return S.current.error_code_aborted;
    } else if (errorCode == FirebaseFirestoreException.OUT_OF_RANGE.code) {
      return S.current.error_code_out_of_range;
    } else if (errorCode ==
        FirebaseFirestoreException.RESOURCE_EXHAUSTED.code) {
      return S.current.error_code_resource_exhausted;
    } else if (errorCode ==
        FirebaseFirestoreException.FAILED_PRECONDITION.code) {
      return S.current.error_code_failed_precondition;
    } else if (errorCode == FirebaseFirestoreException.UNIMPLEMENTED.code) {
      return S.current.error_code_unimplemented;
    } else if (errorCode == FirebaseFirestoreException.INTERNAL.code) {
      return S.current.error_code_internal;
    } else if (errorCode == FirebaseFirestoreException.UNAVAILABLE.code) {
      return S.current.error_code_unavailable;
    } else if (errorCode == FirebaseFirestoreException.DATA_LOSS.code) {
      return S.current.error_code_data_loss;
    } else if (errorCode == FirebaseFirestoreException.DEADLINE_EXCEEDED.code) {
      return S.current.error_code_deadline_exceeded;
    }
    return '';
  }
}

/// --------------- End firebase exception ---------------
