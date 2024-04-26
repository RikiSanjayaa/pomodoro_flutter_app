import 'package:flutter/material.dart';
import 'package:pomodoro/home_screen.dart';
import 'package:pomodoro/themes/dark_theme.dart';
// import 'package:pomodoro/themes/light_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro App',
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      theme: darkBlueMode,
    );
  }
}
