import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _dark = true;

  ThemeMode get themeMode =>
      _dark ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _dark = !_dark;
    notifyListeners();
  }
}