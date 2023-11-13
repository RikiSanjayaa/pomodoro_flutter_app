import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlayButton extends StatelessWidget {
  const PlayButton(
    this.textString, {
    super.key,
    required this.onClick,
    required this.textColor,
    required this.timerIcon,
    required this.buttonSize,
  });

  final void Function() onClick;
  final Icon timerIcon;
  final String textString;
  final Color textColor;
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
              onPressed: onClick,
              backgroundColor: const Color.fromARGB(255, 235, 69, 95),
              foregroundColor: const Color.fromARGB(255, 255, 255, 231),
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
                  color: textColor,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                ),
              )
            : const SizedBox(height: 10)
      ],
    );
  }
}
