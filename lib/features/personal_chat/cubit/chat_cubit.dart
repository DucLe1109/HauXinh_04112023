import 'package:boilerplate/core/bloc_core/ui_status.dart';
import 'package:boilerplate/injector/injector.dart';
import 'package:boilerplate/services/auth_service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'chat_cubit.freezed.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(const ChatState()) {}
}
