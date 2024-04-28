import 'package:flutter/material.dart';
import 'package:pomodoro/home_screen.dart';
import 'package:pomodoro/themes/theme_provider.dart';
import 'package:provider/provider.dart';
// import 'package:pomodoro/themes/light_theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro App',
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
