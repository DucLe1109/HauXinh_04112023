import 'package:d_bloc/config_default_function/default_listener_config.dart';
import 'package:d_bloc/state/d_state.dart';
import 'package:flutter/cupertino.dart';

/// T is Type of return Data
/// E is Type of Error

void Function(BuildContext, BlocState) dListener<T, E>({
  void Function(BuildContext context)? onLoading,
  void Function(BuildContext context, T data)? onSuccess,
  void Function(BuildContext context, E error)? onError,
  void Function(BuildContext context)? onStateChange,
  void Function(BlocState state)? otherwise,
}) =>
    (context, BlocState state) {
      bool isHasLoading = false;
      if (state is LoadingState) {
        isHasLoading = true;
      }
      if (state is LoadingState) {
        return (onLoading != null)
            ? onLoading(context)
            : DefaultListenerConfig.onLoading(context);
      }
      (onStateChange != null)
          ? onStateChange(context)
          : (isHasLoading ? DefaultListenerConfig.onStateChange(context) : null);
      if (state is SuccessState) {
        return (onSuccess != null) ? onSuccess(context, state.data as T) : null;
      }
      if (state is ErrorState) {
        return (onError != null)
            ? onError(context, state.error)
            : DefaultListenerConfig.onError(context, state.error);
      }
      if (state is! ErrorState &&
          state is! SuccessState &&
          state is! LoadingState) {
        return (otherwise != null) ? otherwise(state) : null;
      }
    };
