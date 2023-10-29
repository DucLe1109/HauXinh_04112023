import 'package:d_bloc/d_bloc.dart';
import 'package:flutter/material.dart';

class DefaultListenerConfig {
  static void Function(BuildContext context)? _onLoading;
  static void Function<E>(BuildContext context, E error)? _onError;
  static void Function(BuildContext context)? _onStateChange;

  static void Function(BuildContext context) get onLoading =>
      _onLoading ??
      (context) {
        showLoadingDialog(context);
      };

  static void Function<E>(BuildContext context, E error) get onError =>
      _onError ??
      <E>(context, error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              error.toString(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      };

  static void Function(BuildContext context) get onStateChange =>
      _onStateChange ??
      (context) {
        Navigator.of(context).pop();
      };

  /// Use this function inside [main] to configure [dListener]

  static void configureEmptyAction() {
    _onLoading = (context) {};
    _onError = <E>(context, error) {};
    _onStateChange = (context) {};
  }

  /// Use this function inside [main] to configure [dListener]

  static void configure({
    required void Function(BuildContext context)? onLoading,
    required void Function<E>(BuildContext context, E error)? onError,
    void Function(BuildContext context)? onStateChange,
  }) {
    if (onLoading != null) {
      _onLoading = onLoading;
    }
    if (onStateChange != null) {
      _onStateChange = onStateChange;
    }
    if (onError != null) {
      _onError = onError;
    }
  }
}
