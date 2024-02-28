import 'package:todo_app/global/global.dart';
import 'package:flutter/material.dart';

enum ThemeModeOptions { Light, Dark }

class ThemeProvider with ChangeNotifier {
  late SharedPreferences prefs;
  late ThemeMode themeMode = ThemeMode.light;
  //dark theme mode
  final darkTheme = ThemeData(
    colorSchemeSeed: Colors.blue,
    brightness: Brightness.dark,
    useMaterial3: true,
  );
  //light theme mode
  final lightTheme = ThemeData(
      colorSchemeSeed: Colors.blue,
      brightness: Brightness.light,
      useMaterial3: true);

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
