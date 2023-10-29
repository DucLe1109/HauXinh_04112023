import 'package:d_bloc/default_widget/default_error_widget.dart';
import 'package:flutter/material.dart';

import '../default_widget/default_loading_widget.dart';

class DefaultBuilderConfig {
  static Widget Function()? _onLoading;

  static Widget Function() get onLoading {
    return DefaultBuilderConfig._onLoading ??
        () {
          return const DefaultLoadingWidget();
        };
  }

  static _configureOnLoading(Widget Function()? onLoading) {
    DefaultBuilderConfig._onLoading = onLoading;
  }

  static Widget Function<E>(E error)? _onError;

  static Widget Function<E>(E error) get onError {
    return DefaultBuilderConfig._onError ??
        <E>(error) {
          return DefaultErrorWidget(errorMessage: error.toString());
        };
  }

  static _configureOnError(Widget Function<E>(E error) onError) {
    DefaultBuilderConfig._onError = onError;
  }

  static configure(
      {Widget Function()? onLoading,
      Widget Function<E>(E error)? onError}) {
    if (onLoading != null) {
      _configureOnLoading(onLoading);
    }
    if (onError != null) {
      _configureOnError(onError);
    }
  }
}
