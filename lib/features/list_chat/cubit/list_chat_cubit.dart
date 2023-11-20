import 'package:boilerplate/core/bloc_core/ui_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'list_chat_cubit.freezed.dart';

part 'list_chat_state.dart';

class ListChatCubit extends Cubit<ListChatState> {
  ListChatCubit() : super(const ListChatState());

}
