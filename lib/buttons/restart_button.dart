import 'package:flutter/material.dart';
import 'package:pomodoro/models/button_model.dart';

class RestartButton extends StatelessWidget {
  const RestartButton({
    super.key,
    required this.resetPage,
  });

  final void Function() resetPage;

  @override
  Widget build(BuildContext context) {
    return PlayButton(
      // <-- finish button, restart timer
      textString: 'Restart',
      onClick: resetPage,
      timerIcon: const Icon(Icons.restart_alt_rounded, size: 60),
      buttonSize: 80,
    );
  }
}
