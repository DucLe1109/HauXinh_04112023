import 'dart:io';

import 'package:boilerplate/features/personal_chat/message_type.dart';
import 'package:boilerplate/firebase/firebase_firestore_exception.dart';
import 'package:boilerplate/generated/l10n.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:rest_client/rest_client.dart';

class FirebaseUtils {
  FirebaseUtils._();

  /// --------------- Get firebase instance ---------------
  static FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  static FirebaseFirestore get firebaseStore => FirebaseFirestore.instance;

  static FirebaseStorage get firebaseStorage => FirebaseStorage.instance;

  static User? get user => firebaseAuth.currentUser;

  /// --------------- End get firebase instance ---------------

  /// --------------- User information ---------------
  static Future<void> createUser() async {
    final String currentTime = DateFormat('dd/MM/yyyy').format(DateTime.now());
    final ChatUser chatUser = ChatUser(
        about: '',
        createdAt: currentTime,
        email: user?.email ?? '',
        id: user?.uid ?? '',
        isOnline: false,
        isHasStory: false,
        lastActive: currentTime,
        fullName: user?.displayName ?? '',
        pushToken: '',
        avatar: user?.photoURL ?? '',
        birthday: '');
    await firebaseStore
        .collection(Collections.chatUser.value)
        .doc(user?.uid)
        .set(chatUser.toJson());
  }

  static Future<bool> isExistUser() async {
    return (await firebaseStore
            .collection(Collections.chatUser.value)
            .doc(user?.uid)
            .get())
        .exists;
  }

  static late ChatUser me;

  static Future<void> getSelfInfo() async {
    return firebaseStore
        .collection(Collections.chatUser.value)
        .doc(user?.uid)
        .get()
        .then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
      }
    });
  }

  static Future<void> updateUserInfo(
      String fullName, String about, String birthday) async {
    await firebaseStore
        .collection(Collections.chatUser.value)
        .doc(user?.uid)
        .update(me
            .copyWith(about: about, birthday: birthday, fullName: fullName)
            .toJson());
  }

  static Future<void> updateAvatar(File file) async {
    /// get extension image
    final extension = file.path.split('.')[1];

    /// upload image
    final ref = firebaseStorage.ref().child('avatar/${user?.uid}.$extension');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/*'))
        .then((p0) {
      debugPrint('Data transferred : ${p0.bytesTransferred / 1000} kb');
    });

    /// update avatar path in firebase storage
    final String avatarPath = await ref.getDownloadURL();
    await firebaseStore
        .collection(Collections.chatUser.value)
        .doc(user?.uid)
        .update(me.copyWith(avatar: avatarPath).toJson());
  }

  /// --------------- End user information ---------------

  /// --------------- Firebase chat ---------------
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firebaseStore
        .collection(Collections.chatUser.value)
        .where('id', isNotEqualTo: user?.uid)
        .snapshots();
  }

  /// Function to generate unique ID by 2 user id
  static String getConversationID(String id) =>
      user!.uid.hashCode <= id.hashCode
          ? '${user?.uid}_$id'
          : '${id}_${user?.uid}';

  /// Function to get all message of myself  with specific user.
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser chatUser) {
    return firebaseStore
        .collection(
            '${Collections.chats.value}/${getConversationID(chatUser.id)}/${Collections.messages.value}/')
        .snapshots();
  }

  /// Function to send message to specific user.
  static Future<Message> sendMessage(ChatUser chatUser, String msg) async {
    final messageID = DateTime.now().millisecondsSinceEpoch.toString();
    final now = DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());
    final ref = firebaseStore.collection(
        '${Collections.chats.value}/${getConversationID(chatUser.id)}/${Collections.messages.value}/');
    final message = Message(
      toId: chatUser.id,
      createdTime: now,
      updatedTime: '',
      type: MessageType.text.name,
      readAt: '',
      msg: msg,
      timeStamp: messageID,
      fromId: user?.uid,
    );
    await ref.doc(messageID).set(message.toJson());
    return message;
  }

  /// Function to get 50 (optional) newest message
  static Future<QuerySnapshot<Map<String, dynamic>>> getNewestMessage(
      {required ChatUser chatUser, required int amount}) async {
    return firebaseStore
        .collection(
            '${Collections.chats.value}/${getConversationID(chatUser.id)}/${Collections.messages.value}/')
        .orderBy('timeStamp', descending: true)
        .limit(amount)
        .get();
  }

  /// Function to update read message
  static Future<void> readMessage(Message message) {
    final now = DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());
    return firebaseStore
        .collection(
            '${Collections.chats.value}/${getConversationID(message.fromId ?? '')}/${Collections.messages.value}/')
        .doc(message.timeStamp)
        .update({'readAt': now});
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

  /// --------------- End firebase exception ---------------
}
