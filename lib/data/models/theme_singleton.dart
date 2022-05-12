import 'package:flutter/material.dart';

class ThemeSingleton extends ChangeNotifier {
   static final ThemeSingleton _singleton = ThemeSingleton._internal();
  factory ThemeSingleton() {
    return _singleton;
  }

  ThemeSingleton._internal();
  bool isDark = false;
  ThemeMode currentTheme() {
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }
  void switchTheme() {
    isDark = !isDark;
    notifyListeners();
  }
}