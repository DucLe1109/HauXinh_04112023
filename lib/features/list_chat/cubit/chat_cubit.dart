import 'dart:async';

import 'package:boilerplate/firebase/firebase_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_bloc/d_bloc.dart';
import 'package:rest_client/rest_client.dart';

class ChatCubit extends DCubit {
  late Stream<QuerySnapshot<Map<String, dynamic>>> latestMessageStream;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? subscription;

  ChatCubit({required ChatUser chatUser}) {
    latestMessageStream = FirebaseUtils.getLatestMessage(chatUser);
    subscription = latestMessageStream.listen((event) {
      if (event.docs.isNotEmpty) {
        getAllUnreadMessage(chatUser);
      }
    }, onError: (e) {
      subscription?.cancel();
    });
  }

  Future<void> getAllUnreadMessage(ChatUser chatUser) async {
    emit(const LoadingState());
    try {
      final result = await FirebaseUtils.getAllUnreadMessage(chatUser);
      emit(SuccessState(data: result.docs.length));
    } on FirebaseException catch (e) {
      emit(ErrorState(
          error: DefaultException(
              message: FirebaseUtils.handleException(e.code), statusCode: -1)));
    }
  }
}
