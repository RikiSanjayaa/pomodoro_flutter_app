import 'package:flutter/material.dart';
import 'package:pomodoro/models/button_model.dart';

class RestartButton extends StatelessWidget {
  const RestartButton(
      {super.key, required this.resetPage, required this.textColor});

  final void Function() resetPage;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return PlayButton(
      // <-- finish button, restart timer
      'Restart',
      onClick: resetPage,
      timerIcon: const Icon(Icons.restart_alt_rounded, size: 60),
      textColor: textColor,
      buttonSize: 80,
    );
  }
}
