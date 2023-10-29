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
  final Message message;

  const NewMessageState({required this.message});

  @override
  List<Object?> get props => [message];
}
