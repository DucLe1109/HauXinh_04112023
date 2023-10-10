import 'package:flutter/material.dart';

class Utils {
  Utils._();

  static void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
