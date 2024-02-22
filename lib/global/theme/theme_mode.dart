import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeModeOptions { Light, Dark }

class ThemeProvider with ChangeNotifier {
  late SharedPreferences prefs;
  late ThemeMode themeMode = ThemeMode.light;

  ThemeProvider() {
    initPrefs();
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final savedThemeMode = prefs.getString('themeMode');

    if (savedThemeMode == null) {
      themeMode = ThemeMode.system;
    } else {
      themeMode = getThemeModeFromString(savedThemeMode);
    }

    notifyListeners();
  }



  ThemeModeOptions get selectedMode {
    if (themeMode == ThemeMode.light) {
      return ThemeModeOptions.Light;
    } else {
      return ThemeModeOptions.Dark;
    } 
  }

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

  Future<void> saveThemeMode() async {
    await prefs.setString('themeMode', themeMode.toString());
  }

  ThemeMode getThemeModeFromString(String value) {
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