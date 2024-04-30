import 'package:flutter/material.dart';
import 'package:pomodoro/models/button_model.dart';

class StartedButtons extends StatelessWidget {
  const StartedButtons(
    this.buttonText, {
    super.key,
    required this.pauseOrStart,
    required this.resetCurrentTimer,
    required this.resetPage,
    required this.buttonIcon,
  });

  final void Function() pauseOrStart;
  final void Function() resetCurrentTimer;
  final void Function() resetPage;
  final Icon buttonIcon;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: PlayButton(
              onClick: resetCurrentTimer,
              timerIcon: const Icon(Icons.keyboard_double_arrow_left, size: 50),
              buttonSize: 60,
            ),
          ),
          PlayButton(
            textString: buttonText,
            onClick: pauseOrStart,
            timerIcon: buttonIcon,
            buttonSize: 80,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: PlayButton(
              onClick: resetPage,
              timerIcon: const Icon(Icons.restart_alt_rounded, size: 50),
              buttonSize: 60,
            ),
          ),
        ],
      ),
    );
  }
}
