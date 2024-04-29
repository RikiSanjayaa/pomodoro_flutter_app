import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomodoro/home_screen.dart';

import 'package:pomodoro/models/tomato_counter.dart';
import 'package:pomodoro/buttons/first_start_button.dart';
import 'package:pomodoro/buttons/restart_button.dart';
import 'package:pomodoro/buttons/started_buttons.dart';
import 'package:pomodoro/timer_provider.dart';
import 'package:provider/provider.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key, required this.getBgColor});

  final Function getBgColor;

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen>
    with AutomaticKeepAliveClientMixin {
  Timer? countdownTimer;

  String _iconColor = 'yellow';

  int counter = 1; // count the work and rest timer
  late int workDuration;
  late int restDuration;
  late Duration myDuration;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    workDuration =
        Provider.of<TimerProvider>(context, listen: true).workTime * 60;
    restDuration =
        Provider.of<TimerProvider>(context, listen: true).restTime * 60;
    myDuration = Duration(seconds: workDuration);
  }

  String textBelowTimer = "Work Time";
  bool isStarted = false; // to make the starting button different
  bool isOnPause = false; // to pause or start timer
  bool isNotFinish = true; // to view the finish page

  void startTimer() {
    countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setCountDown(),
    );
    setState(() {
      isOnPause = true;
    });
  }

  void startFirstTime() {
    isStarted = true;
    startTimer();
  }

  void stopTimer() {
    setState(() {
      countdownTimer!.cancel();
      isOnPause = false;
    });
  }

  void resetCurrentTimer() {
    stopTimer();
    setState(() {
      if (counter % 2 == 0) {
        myDuration = Duration(seconds: restDuration);
      } else {
        myDuration = Duration(seconds: workDuration);
      }
    });
  }

  void resetPage() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        pageBuilder: (_, __, ___) => const HomeScreen(),
      ),
    );
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    if (mounted) {
      setState(() {
        final seconds = myDuration.inSeconds - reduceSecondsBy;
        if (seconds < 0 && counter == 8) {
          // <-- kapan berenti timernya setelah 8 kali
          setState(() {
            _iconColor = 'green';
            widget.getBgColor(_iconColor);
            textBelowTimer = 'Good Work!';
            isNotFinish = false;
            countdownTimer!.cancel();
          });
        } else if (seconds < 0 && counter % 2 == 0) {
          // <-- timer work 25 menit
          stopTimer();
          setState(() {
            myDuration = Duration(seconds: workDuration);
            _iconColor = 'yellow';
            widget.getBgColor(_iconColor);
            textBelowTimer = 'Work Time';
          });
          counter++;
          startTimer();
        } else if (seconds < 0 && counter % 2 != 0) {
          // <-- timer istirahat 5 menit
          stopTimer();
          setState(() {
            myDuration = Duration(seconds: restDuration);
            _iconColor = 'blue';
            widget.getBgColor(_iconColor);
            textBelowTimer = 'Rest Time';
          });
          counter++;
          startTimer();
        } else {
          myDuration = Duration(seconds: seconds);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Color textColor = Theme.of(context).colorScheme.onBackground;
    late Color iconColor;
    switch (_iconColor) {
      case 'green':
        iconColor = Theme.of(context).colorScheme.tertiary;
        break;
      case 'blue':
        iconColor = Theme.of(context).colorScheme.secondary;
      default:
        iconColor = Theme.of(context).colorScheme.background;
    }

    String strDigits(int n) => n.toString().padLeft(2, '0');

    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TomatoCounter(counter: counter),
          Image.asset(
            'assets/images/tomato.png',
            width: 230,
          ),
          const SizedBox(
            height: 75,
          ),
          Text(
            "$minutes:$seconds",
            style: GoogleFonts.roboto(
              fontSize: 64,
              color: textColor,
              fontWeight: FontWeight.w800,
              letterSpacing: 5,
            ),
          ),
          if (isStarted)
            Text(
              textBelowTimer,
              style: GoogleFonts.roboto(
                fontSize: 24,
                color: textColor,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
              ),
            )
          else
            Text(
              "Let's Work!",
              style: GoogleFonts.roboto(
                fontSize: 24,
                color: textColor,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
              ),
            ),
          if (isStarted)
            if (isNotFinish)
              if (isOnPause)
                StartedButtons(
                  'Pause',
                  pauseOrStart: stopTimer,
                  resetCurrentTimer: resetCurrentTimer,
                  resetPage: resetPage,
                  textColor: textColor,
                  buttonIcon: const Icon(Icons.pause, size: 60),
                  iconColor: iconColor,
                )
              else
                StartedButtons(
                  'Start',
                  pauseOrStart: startTimer,
                  resetCurrentTimer: resetCurrentTimer,
                  resetPage: resetPage,
                  textColor: textColor,
                  buttonIcon: const Icon(Icons.play_arrow_rounded, size: 60),
                  iconColor: iconColor,
                )
            else
              RestartButton(
                resetPage: resetPage,
                textColor: textColor,
                iconColor: iconColor,
              )
          else
            FirstStartButton(
              startFirstTime: startFirstTime,
              textColor: textColor,
              iconColor: iconColor,
            )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
