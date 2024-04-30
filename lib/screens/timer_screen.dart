import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomodoro/providers/theme_provider.dart';
import 'package:pomodoro/screens/home_screen.dart';

import 'package:pomodoro/models/tomato_counter.dart';
import 'package:pomodoro/buttons/first_start_button.dart';
import 'package:pomodoro/buttons/restart_button.dart';
import 'package:pomodoro/buttons/started_buttons.dart';
import 'package:pomodoro/providers/timer_provider.dart';
import 'package:provider/provider.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen>
    with AutomaticKeepAliveClientMixin {
  Timer? countdownTimer;

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
    if (counter % 2 == 0) {
      myDuration = Duration(seconds: restDuration);
    } else {
      myDuration = Duration(seconds: workDuration);
    }
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
    Provider.of<ThemeProvider>(context, listen: false)
        .changeBgColor(Theme.of(context).colorScheme.background, 'background');
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
            // _iconColor = 'green';
            // widget.getBgColor(_iconColor);
            Provider.of<ThemeProvider>(context, listen: false).changeBgColor(
                Theme.of(context).colorScheme.tertiary, 'tertiary');
            textBelowTimer = 'Good Work!';
            isNotFinish = false;
            countdownTimer!.cancel();
          });
        } else if (seconds < 0 && counter % 2 == 0) {
          // <-- timer work 25 menit
          stopTimer();
          setState(() {
            myDuration = Duration(seconds: workDuration);
            // _iconColor = 'yellow';
            // widget.getBgColor(_iconColor);
            Provider.of<ThemeProvider>(context, listen: false).changeBgColor(
                Theme.of(context).colorScheme.background, 'background');
            textBelowTimer = 'Work Time';
          });
          counter++;
          startTimer();
        } else if (seconds < 0 && counter % 2 != 0) {
          // <-- timer istirahat 5 menit
          stopTimer();
          setState(() {
            myDuration = Duration(seconds: restDuration);
            // _iconColor = 'blue';
            // widget.getBgColor(_iconColor);
            Provider.of<ThemeProvider>(context, listen: false).changeBgColor(
                Theme.of(context).colorScheme.secondary, 'secondary');
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
                  buttonIcon: const Icon(Icons.pause, size: 60),
                )
              else
                StartedButtons(
                  'Start',
                  pauseOrStart: startTimer,
                  resetCurrentTimer: resetCurrentTimer,
                  resetPage: resetPage,
                  buttonIcon: const Icon(Icons.play_arrow_rounded, size: 60),
                )
            else
              RestartButton(
                resetPage: resetPage,
              )
          else
            FirstStartButton(
              startFirstTime: startFirstTime,
            )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
