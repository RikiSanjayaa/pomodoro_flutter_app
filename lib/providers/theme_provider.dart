import 'package:flutter/material.dart';
import 'package:pomodoro/themes/dark_theme.dart';
import 'package:pomodoro/themes/light_theme.dart';

class ThemeProvider extends ChangeNotifier {
  // initially light mode
  ThemeData _themeData = lightYellowMode;
  late Color _bgColor;
  late String _currentBgColor;

  ThemeProvider() : _bgColor = lightYellowMode.colorScheme.background {
    _bgColor = _themeData.colorScheme.background;
    _currentBgColor = 'background';
  }

  // get theme
  ThemeData get themeData => _themeData;

  // get bg color
  Color get bgColor => _bgColor;
  String get currentBgColor => _currentBgColor;

  // is dark mode
  bool get isDarkMode => _themeData == darkBlueMode;

  // set Theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;

    // update UI
    notifyListeners();
  }

  // set bg color
  set bgColor(Color color) {
    _bgColor = color;

    // update UI
    notifyListeners();
  }

  set currentBgColor(String colorName) {
    _currentBgColor = colorName;

    // update UI
    notifyListeners();
  }

  // toggle theme
  void toggleTheme() {
    if (_themeData == lightYellowMode) {
      themeData = darkBlueMode;
      switch (_currentBgColor) {
        case 'secondary':
          bgColor = darkBlueMode.colorScheme.secondary;
          break;
        case 'tertiary':
          bgColor = darkBlueMode.colorScheme.tertiary;
          break;
        default:
          bgColor = darkBlueMode.colorScheme.background;
      }
    } else {
      themeData = lightYellowMode;
      switch (_currentBgColor) {
        case 'secondary':
          bgColor = lightYellowMode.colorScheme.secondary;
          break;
        case 'tertiary':
          bgColor = lightYellowMode.colorScheme.tertiary;
          break;
        default:
          bgColor = lightYellowMode.colorScheme.background;
      }
    }
  }

  // change bg color
  void changeBgColor(Color color, String colorName) {
    bgColor = color;
    currentBgColor = colorName;
  }
}
