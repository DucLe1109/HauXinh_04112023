import 'package:boilerplate/core/bloc_core/ui_status.dart';
import 'package:boilerplate/firebase/firebase_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rest_client/rest_client.dart';

part 'list_chat_cubit.freezed.dart';

part 'list_chat_state.dart';

class ListChatCubit extends Cubit<ListChatState> {
  ListChatCubit() : super(const ListChatState()) {
    chatStream = FirebaseUtils.firebaseStore
        .collection(Collections.users.value)
        .snapshots();
  }

  late Stream<QuerySnapshot<Map<String, dynamic>>> chatStream;
}
