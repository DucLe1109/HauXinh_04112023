import 'package:boilerplate/core/themes/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppThemes {
  AppThemes._();

  //Primary
  static const Color _lightPrimaryColor = Color(0xffffffff);
  static const Color _darkPrimaryColor = Color(0xFF1F161E);

  //Background
  static const Color _lightBackgroundColor = AppColors.naturalWhite;
  static const Color _darkBackgroundColor = AppColors.grey800;

  //Text
  static const Color _lightTextColor = Color(0xff000000);
  static const Color _darkTextColor = Color(0xffffffff);

  //Icon
  static const Color _lightIconColor = Color(0xff000000);
  static const Color _darkIconColor = Color(0xffffffff);

  //Text themes
  static const TextTheme _lightTextTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 96, color: _lightTextColor),
    displayMedium: TextStyle(fontSize: 60, color: _lightTextColor),
    displaySmall: TextStyle(fontSize: 48, color: _lightTextColor),
    headlineMedium: TextStyle(fontSize: 34, color: _lightTextColor),
    headlineSmall: TextStyle(fontSize: 24, color: _lightTextColor),
    titleLarge: TextStyle(
      fontSize: 20,
      color: _lightTextColor,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: TextStyle(fontSize: 16, color: _lightTextColor),
    titleSmall: TextStyle(
      fontSize: 14,
      color: _lightTextColor,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: TextStyle(fontSize: 16, color: _lightTextColor),
    bodyMedium: TextStyle(fontSize: 14, color: _lightTextColor),
    labelLarge: TextStyle(
      fontSize: 14,
      color: _lightTextColor,
      fontWeight: FontWeight.w500,
    ),
    bodySmall: TextStyle(fontSize: 12, color: _lightTextColor),
    labelSmall: TextStyle(fontSize: 14, color: _lightTextColor),
  );

  static const TextTheme _darkTextTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 96, color: _darkTextColor),
    displayMedium: TextStyle(fontSize: 60, color: _darkTextColor),
    displaySmall: TextStyle(fontSize: 48, color: _darkTextColor),
    headlineMedium: TextStyle(fontSize: 34, color: _darkTextColor),
    headlineSmall: TextStyle(fontSize: 24, color: _darkTextColor),
    titleLarge: TextStyle(
      fontSize: 20,
      color: _darkTextColor,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: TextStyle(fontSize: 16, color: _darkTextColor),
    titleSmall: TextStyle(
      fontSize: 14,
      color: _darkTextColor,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: TextStyle(fontSize: 16, color: _darkTextColor),
    bodyMedium: TextStyle(fontSize: 14, color: _darkTextColor),
    labelLarge: TextStyle(
      fontSize: 14,
      color: _darkTextColor,
      fontWeight: FontWeight.w500,
    ),
    bodySmall: TextStyle(fontSize: 12, color: _darkTextColor),
    labelSmall: TextStyle(fontSize: 14, color: _darkTextColor),
  );

  //Button themes

  static const ButtonThemeData _lightButtonTheme = ButtonThemeData(
    buttonColor: Color(0xff002DE3),
    focusColor: Color(0xff002DE3),
    height: 48,
  );
  static const ButtonThemeData _darkButtonTheme = ButtonThemeData(
    buttonColor: Color(0xff375FFF),
    focusColor: Color(0xff375FFF),
    height: 48,
  );

  static const IconThemeData _lightSelectedIconThemeData = IconThemeData(
    color: _lightIconColor,
  );
  static const IconThemeData _darkSelectedIconThemeData = IconThemeData(
    color: _darkIconColor,
  );

  static const IconThemeData _lightUnSelectedIconThemeData = IconThemeData(
    color: CupertinoColors.systemGrey,
  );
  static const IconThemeData _darkUnSelectedIconThemeData = IconThemeData(
    color: CupertinoColors.systemGrey,
  );

  static const BottomNavigationBarThemeData _darkBottomNavigationBarThemeData =
      BottomNavigationBarThemeData(
          backgroundColor: _darkPrimaryColor,
          selectedIconTheme: _darkSelectedIconThemeData,
          unselectedIconTheme: _darkUnSelectedIconThemeData);
  static const BottomNavigationBarThemeData _lightBottomNavigationBarThemeData =
      BottomNavigationBarThemeData(
          backgroundColor: _lightPrimaryColor,
          selectedIconTheme: _lightSelectedIconThemeData,
          unselectedIconTheme: _lightUnSelectedIconThemeData);

  static final SearchBarThemeData _lightSearchBarThemeData = SearchBarThemeData(
    backgroundColor: MaterialStateProperty.all(const Color(0xFFF7F7FC)),
  );
  static final SearchBarThemeData _darkSearchBarThemeData = SearchBarThemeData(
    backgroundColor: MaterialStateProperty.all(Colors.grey[800]),
  );

  ///Light theme
  static final ThemeData lightTheme = ThemeData(
      unselectedWidgetColor: const Color.fromRGBO(143, 148, 251, 1),
      brightness: Brightness.light,
      primaryColor: _lightPrimaryColor,
      scaffoldBackgroundColor: _lightBackgroundColor,
      appBarTheme: AppBarTheme(
        color: _lightBackgroundColor,
        iconTheme: const IconThemeData(color: _lightIconColor),
        toolbarTextStyle: _lightTextTheme.bodyMedium,
        titleTextStyle: _lightTextTheme.titleLarge,
      ),
      iconTheme: _lightSelectedIconThemeData,
      textTheme: _lightTextTheme,
      dividerTheme: const DividerThemeData(
        color: Colors.grey,
      ),
      searchBarTheme: _lightSearchBarThemeData,
      buttonTheme: _lightButtonTheme,
      colorScheme: const ColorScheme.light().copyWith(
          primary: const Color.fromARGB(255, 232, 250, 217),
          secondary: const Color.fromARGB(255, 241, 241, 241),
          background: const Color.fromARGB(255, 255, 255, 235),
          onPrimary: AppColors.blue200,
          inversePrimary: Colors.grey[800]),
      bottomNavigationBarTheme: _lightBottomNavigationBarThemeData);

  ///Dark theme
  static final ThemeData darkTheme = ThemeData(
      unselectedWidgetColor: const Color.fromRGBO(143, 148, 251, 1),
      brightness: Brightness.dark,
      primaryColor: _darkPrimaryColor,
      scaffoldBackgroundColor: _darkBackgroundColor,
      appBarTheme: AppBarTheme(
        color: _darkBackgroundColor,
        iconTheme: const IconThemeData(color: _darkIconColor),
        toolbarTextStyle: _darkTextTheme.bodyMedium,
        titleTextStyle: _darkTextTheme.titleLarge,
      ),
      iconTheme: _darkSelectedIconThemeData,
      textTheme: _darkTextTheme,
      dividerTheme: const DividerThemeData(
        color: Colors.grey,
      ),
      colorScheme: const ColorScheme.dark().copyWith(
          primary: const Color.fromARGB(255, 45, 78, 70),
          secondary: const Color.fromARGB(255, 30, 43, 70),
          background: const Color.fromARGB(255, 23, 32, 50),
          onPrimary: AppColors.blue200,
          inversePrimary: Colors.white30),
      searchBarTheme: _darkSearchBarThemeData,
      buttonTheme: _darkButtonTheme,
      bottomNavigationBarTheme: _darkBottomNavigationBarThemeData);
}
