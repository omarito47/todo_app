import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeModeOptions { Light, Dark }

class ThemeProvider with ChangeNotifier {
  late SharedPreferences prefs;
  late ThemeMode themeMode = ThemeMode.light;
  //dark theme mode
  final darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
        color: Colors.grey[900],
        iconTheme: const IconThemeData(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.blue)),
    textTheme: const TextTheme(
      bodyText2: TextStyle(color: Colors.white),
      subtitle1: TextStyle(color: Colors.white),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.grey[800],
      contentTextStyle: TextStyle(color: Colors.white),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Colors.blueGrey,
    ),
    cardTheme: CardTheme(
      color: Colors.grey[800],
    ),
  );
  //light theme mode
  final lightTheme = ThemeData(
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
        checkColor: MaterialStateColor.resolveWith((states) => Colors.black),
      ),
      dialogTheme: DialogTheme(
        backgroundColor:
            MaterialStateColor.resolveWith((states) => Colors.white),
      ),
      hintColor: Colors.grey,
      // buttonTheme: ButtonThemeData(buttonColor: Colors.blueGrey),
      textTheme: const TextTheme(
        bodyText2: TextStyle(color: Colors.black),
        bodyText1: TextStyle(color: Colors.black),
        // Add more text styles as needed
      ),
      appBarTheme: const AppBarTheme(
        color: Colors.blueGrey,
        // Customize app bar attributes if needed
      ),
      scaffoldBackgroundColor: Colors.white,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.blueGrey));

  ThemeProvider() {
    initPrefs();
  }
  //to get and  initilize the current theme mode storad in local storage
  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final savedThemeMode = prefs.getString('themeMode');

    if (savedThemeMode == null) {
      themeMode = ThemeMode.system;
    } else {
      //Convert the string to a ThemeMode type 
      themeMode = convertStringToThemeModeType(savedThemeMode);
    }

    notifyListeners();
  }

  //select theme mode function
  ThemeModeOptions get selectedMode {
    if (themeMode == ThemeMode.light) {
      return ThemeModeOptions.Light;
    } else {
      return ThemeModeOptions.Dark;
    }
  }

  //set and save the theme mode function
  Future<void> setThemeMode(ThemeModeOptions themeModeOption) async {
    switch (themeModeOption) {
      case ThemeModeOptions.Light:
        themeMode = ThemeMode.light;
        break;
      case ThemeModeOptions.Dark:
        themeMode = ThemeMode.dark;
        break;
    }

    await saveThemeMode();
    notifyListeners();
  }

  //save the theme mode function  to local storage
  Future<void> saveThemeMode() async {
    await prefs.setString('themeMode', themeMode.toString());
  }
  //get the theme mode from string function
  ThemeMode convertStringToThemeModeType(String value) {
    switch (value) {
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;

      default:
        return ThemeMode.light;
    }
  }
}
