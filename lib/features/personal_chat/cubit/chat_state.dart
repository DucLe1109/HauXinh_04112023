import 'package:boilerplate/features/personal_chat/model/message_model.dart';
import 'package:d_bloc/state/d_state.dart';
import 'package:rest_client/rest_client.dart';

class SendMessageSuccessState extends BlocState {
  final Message message;

  const SendMessageSuccessState({required this.message});

  @override
  List<Object?> get props => [message];
}

class SendMessageLoadingState extends BlocState {}

class ReadingMessageState extends BlocState {}

class ReadMessageDoneState extends BlocState {}

class NewMessageState extends BlocState {
  final MessageModel message;

  const NewMessageState({required this.message});

  @override
  List<Object?> get props => [message];
}

class InitiateData extends BlocState {}

class InitiateDataSuccessFully extends BlocState {}

class LoadingMore extends BlocState {}

class LoadMoreSuccessfully extends BlocState {
  final int numberOfNewMessage;

  const LoadMoreSuccessfully({required this.numberOfNewMessage});
  @override
  List<Object?> get props => [numberOfNewMessage];
}

class LoadMoreDone extends BlocState {}
