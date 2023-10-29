import 'package:d_bloc/state/d_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DCubit extends Cubit<BlocState> {
  DCubit({BlocState? blocState}) : super(blocState ?? const InitialState());

  void executeAsyncAction(
      {required Future<void> Function() action,
      Function(Object e)? errorAction,
      required bool showLoading}) async {
    if (showLoading) {
      emit(const LoadingState());
    }
    try {
      await action();
    } catch (e) {
      if (errorAction != null) {
        errorAction(e);
      } else {
        emit(ErrorState(error: e.toString()));
      }
    }
  }

  void executeNormalAction(
      {required Future<void> Function() action,
      Function(Object e)? errorAction,
      required bool showLoading}) {
    if (showLoading) {
      emit(const LoadingState());
    }
    try {
      action();
    } catch (e) {
      if (errorAction != null) {
        errorAction(e);
      } else {
        emit(ErrorState(error: e.toString()));
      }
    }
  }
}
