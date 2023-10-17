import 'package:boilerplate/core/bloc_core/ui_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rest_client/rest_client.dart';

part 'chat_cubit.freezed.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(const ChatState()) {
    // firebaseFirestore = FirebaseFirestore.instance;
    // chatStream =
    //     firebaseFirestore.collection(Collections.users.value).snapshots();
  }
  //
  // late FirebaseFirestore firebaseFirestore;
  // late Stream<QuerySnapshot> chatStream;
}
