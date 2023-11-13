import 'package:flutter/material.dart';
import 'package:pomodoro/models/button_model.dart';

class FirstStartButton extends StatelessWidget {
  const FirstStartButton(
      {super.key, required this.startFirstTime, required this.textColor});

  final void Function() startFirstTime;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return PlayButton(
      'Start',
      onClick: startFirstTime,
      timerIcon: const Icon(Icons.play_arrow, size: 60),
      textColor: textColor,
      buttonSize: 80,
    );
  }
}
