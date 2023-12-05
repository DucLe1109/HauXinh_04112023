import 'package:boilerplate/core/keys/app_keys.dart';

enum AppProperty { keyboardHeight }

extension AppPropertyExtension on AppProperty {
  String get value {
    switch (this) {
      case AppProperty.keyboardHeight:
        return AppKeys.keyboardHeight;
    }
  }
}

abstract class AppService {
  String get locale;

  bool get isDarkMode;

  bool get isFirstUse;

  double get keyboardHeight;

  Future<void> setLocale({
    required String locale,
  });

  Future<void> setIsDarkMode({
    required bool darkMode,
  });

  Future<void> setIsFirstUse({
    required bool isFirstUse,
  });


  Future<void> setAppProperty({
    required AppProperty property,
    required dynamic value,
  });
}
