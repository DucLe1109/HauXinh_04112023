import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  Utils._();

  static void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static String getDateTimeNow({String outputFormat = 'dd/MM/yyyy HH:mm:ss'}) {
    final now = DateTime.now();
    final formatter = DateFormat(outputFormat);
    final String formattedTime = formatter.format(now);
    return formattedTime;
  }
}