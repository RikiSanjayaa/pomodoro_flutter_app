import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomodoro/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class PlayButton extends StatelessWidget {
  const PlayButton({
    super.key,
    required this.onClick,
    required this.timerIcon,
    required this.buttonSize,
    this.textString = '',
  });

  final void Function() onClick;
  final Icon timerIcon;
  final String textString;
  final double buttonSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 45, 0, 15),
          child: SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: FloatingActionButton(
              shape: const CircleBorder(),
              onPressed: onClick,
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor:
                  Provider.of<ThemeProvider>(context, listen: true).bgColor,
              elevation: 0,
              focusElevation: 0,
              child: timerIcon,
            ),
          ),
        ),
        textString.isNotEmpty
            ? Text(
                textString,
                style: GoogleFonts.roboto(
                  fontSize: 24,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                ),
              )
            : const SizedBox(height: 10)
      ],
    );
  }
}
