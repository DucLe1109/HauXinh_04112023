import 'package:d_bloc/config_default_function/default_builder_config.dart';
import 'package:d_bloc/state/d_state.dart';
import 'package:flutter/material.dart';

/// T is Type of return Data

Widget Function(BuildContext, BlocState) dBuilder<T, E>({
  Widget Function()? onLoading,
  required Widget Function(T? data) onSuccess,
  Widget Function(E error)? onError,
  required Widget Function(BlocState state) otherwise,
}) =>
    (context, BlocState state) {
      if (state is LoadingState) {
        return (onLoading != null)
            ? onLoading()
            : DefaultBuilderConfig.onLoading();
      }
      if (state is SuccessState) {
        return onSuccess(state.data as T);
      }
      if (state is ErrorState) {
        return (onError != null)
            ? onError(state.error)
            : DefaultBuilderConfig.onError(state.error);
      }
      return otherwise(state);
    };
