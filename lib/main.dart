import 'package:flutter/material.dart';
import 'package:pomodoro/screens/home_screen.dart';
import 'package:pomodoro/providers/theme_provider.dart';
import 'package:pomodoro/providers/timer_provider.dart';
import 'package:provider/provider.dart';
// import 'package:pomodoro/themes/light_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => TimerProvider()),
      ],
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
