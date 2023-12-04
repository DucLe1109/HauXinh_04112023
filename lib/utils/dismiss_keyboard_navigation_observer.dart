import 'package:flutter/material.dart';

class DismissKeyboardNavigationObserver extends NavigatorObserver {
  @override
  void didStartUserGesture(Route route, Route? previousRoute) {
    debugPrint('Start swipe back in IOS');
    super.didStartUserGesture(route, previousRoute);
  }
}
