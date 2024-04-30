import 'package:flutter/material.dart';
import 'package:pomodoro/providers/theme_provider.dart';
import 'package:pomodoro/providers/timer_provider.dart';
import 'package:provider/provider.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    int workTimerInMinutes =
        Provider.of<TimerProvider>(context, listen: true).workTime;
    int restTimerInMinutes =
        Provider.of<TimerProvider>(context, listen: true).restTime;

    return Drawer(
      backgroundColor:
          Provider.of<ThemeProvider>(context, listen: true).bgColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100, bottom: 50),
            child: Center(
              child: Icon(
                Icons.settings,
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'D A R K  M O D E',
                  style: TextStyle(fontSize: 16),
                ),
                Switch(
                  value: Provider.of<ThemeProvider>(context, listen: false)
                      .isDarkMode,
                  onChanged: (value) {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleTheme();
                  },
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(24, 30, 24, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'W O R K  T I M E',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'default: 25min',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          // work time setting
          Slider(
            value: workTimerInMinutes.toDouble(),
            min: 1,
            max: 60,
            divisions: 59,
            label: '${workTimerInMinutes.toString()} minutes',
            onChanged: (double value) {
              Provider.of<TimerProvider>(context, listen: false).workTime =
                  value.toInt();
            },
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(24, 30, 24, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'R E S T  T I M E',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'default: 5min',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          // rest time setting
          Slider(
            value: restTimerInMinutes.toDouble(),
            min: 1,
            max: 60,
            divisions: 59,
            label: '${restTimerInMinutes.toString()} minutes',
            onChanged: (double value) {
              Provider.of<TimerProvider>(context, listen: false).restTime =
                  value.toInt();
            },
          ),
        ],
      ),
    );
  }
}
