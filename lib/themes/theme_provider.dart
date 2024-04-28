import 'package:flutter/material.dart';
import 'package:pomodoro/themes/dark_theme.dart';
import 'package:pomodoro/themes/light_theme.dart';

class ThemeProvider extends ChangeNotifier {
  // initially light mode
  ThemeData _themeData = lightYellowMode;

  // get theme
  ThemeData get themeData => _themeData;

  // is dark mode
  bool get isDarkMode => _themeData == darkBlueMode;

  // set Theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;

    // update UI
    notifyListeners();
  }

  // toggle theme
  void toggleTheme() {
    if (_themeData == lightYellowMode) {
      themeData = darkBlueMode;
    } else {
      themeData = lightYellowMode;
    }
  }
}
