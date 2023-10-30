import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  Utils._();

  static void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static String getNow({String outputFormat = 'dd/MM/yyyy HH:mm:ss'}) {
    final now = DateTime.now();
    final formatter = DateFormat(outputFormat);
    final String formattedTime = formatter.format(now);
    return formattedTime;
  }

  static String formatToTime(String? value) {
    try {
      final datetime = DateFormat('dd/MM/yyyy HH:mm:ss').parse(value ?? '');
      final now = DateTime.now();
      if (datetime.day == now.day &&
          datetime.month == now.month &&
          datetime.year == now.year) {
        return DateFormat('HH:mm').format(datetime);
      } else {
        return DateFormat('dd/MM/yyyy').format(datetime);
      }
    } catch (e) {
      debugPrint(e.toString());
      return '';
    }
  }
}
