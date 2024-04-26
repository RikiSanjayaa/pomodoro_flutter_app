import 'package:flutter/material.dart';
import 'package:pomodoro/models/button_model.dart';

class FirstStartButton extends StatelessWidget {
  const FirstStartButton({
    super.key,
    required this.startFirstTime,
    required this.textColor,
    required this.iconColor,
  });

  final void Function() startFirstTime;
  final Color textColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return PlayButton(
      'Start',
      onClick: startFirstTime,
      timerIcon: const Icon(Icons.play_arrow, size: 60),
      textColor: textColor,
      buttonSize: 80,
      iconColor: iconColor,
    );
  }
}
