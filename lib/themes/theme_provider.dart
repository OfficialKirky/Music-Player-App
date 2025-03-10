import 'package:flutter/material.dart';
import 'package:music_player/themes/dark_mode.dart';
import 'package:music_player/themes/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  // Initially set to light mode
  ThemeData _themeData = lightMode;

  // Getter for theme data
  ThemeData get themeData => _themeData;

  // Check if dark mode is active
  bool get isDarkMode => _themeData == darkMode;

  // Setter for theme data
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners(); // Notify listeners to rebuild UI
  }

  // Toggle theme between light and dark mode
  void toggleTheme() {
    themeData = isDarkMode ? lightMode : darkMode;
  }
}
