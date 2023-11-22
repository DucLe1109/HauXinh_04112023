import 'package:boilerplate/generated/l10n.dart';
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

  static String formatToLastMessageTime(String? value) {
    if(value != null){
      try {
        final datetime = DateFormat('dd/MM/yyyy HH:mm:ss').parse(value);
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
    return '';
  }

  static String formatToLastStatusTime(String? value) {
    if (value != null && value.isNotEmpty) {
      try {
        final datetime = DateFormat('dd/MM/yyyy HH:mm:ss').parse(value);

        final now = DateTime.now();
        if (datetime.day == now.day &&
            datetime.month == now.month &&
            datetime.year == now.year &&
            datetime.hour == now.hour) {
          final lastMinuteActive = int.parse(DateFormat('mm').format(datetime));
          var minute = now.minute - lastMinuteActive;
          if (minute == 0) minute += 1;

          return '${S.current.active} $minute ${minute > 1 ? S.current.minute : S.current.minutes} ${S.current.ago}';
        }
        if (datetime.day == now.day &&
            datetime.month == now.month &&
            datetime.year == now.year) {
          final lastHourActive = int.parse(DateFormat('HH').format(datetime));
          final hour = now.hour - lastHourActive;

          return '${S.current.active} $hour ${hour == 1 ? S.current.hour : S.current.hours} ${S.current.ago}';
        }
        if (datetime.month == now.month && datetime.year == now.year) {
          final lastDayActive = int.parse(DateFormat('dd').format(datetime));
          final day = now.day - lastDayActive;
          return '${S.current.active} $day ${day == 1 ? S.current.day : S.current.days} ${S.current.ago}';
        } else {
          return '${S.current.active} ${DateFormat('dd/MM/yyyy').format(datetime)}';
        }
      } catch (e) {
        debugPrint('jiihihihih');

        debugPrint(e.toString());
        return '';
      }
    }
    return '';
  }
}
