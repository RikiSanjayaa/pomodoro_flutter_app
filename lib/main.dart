import 'package:flutter/material.dart';
import 'package:pomodoro/home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Pomodoro App',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
