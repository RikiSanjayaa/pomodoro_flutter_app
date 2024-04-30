import 'package:flutter/material.dart';
import 'package:pomodoro/models/button_model.dart';

class FirstStartButton extends StatelessWidget {
  const FirstStartButton({
    super.key,
    required this.startFirstTime,
  });

  final void Function() startFirstTime;

  @override
  Widget build(BuildContext context) {
    return PlayButton(
      textString: 'Start',
      onClick: startFirstTime,
      timerIcon: const Icon(Icons.play_arrow, size: 60),
      buttonSize: 80,
    );
  }
}
