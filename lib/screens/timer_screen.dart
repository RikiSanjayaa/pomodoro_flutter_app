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
import 'package:pomodoro/services/local_notifications.dart';
import 'package:provider/provider.dart';

enum TimerState { initial, started, paused, finished }

TimerState _timerState = TimerState.initial;

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
    workDuration = Provider.of<TimerProvider>(context, listen: true).workTime;
    restDuration = Provider.of<TimerProvider>(context, listen: true).restTime;
    if (counter % 2 == 0) {
      myDuration = Duration(seconds: restDuration);
    } else {
      myDuration = Duration(seconds: workDuration);
    }
  }

  String textBelowTimer = "Let's Work";

  void startTimer() {
    setState(() {
      countdownTimer = Timer.periodic(
        const Duration(seconds: 1),
        (_) => setCountDown(),
      );
      _timerState = TimerState.started;
    });
  }

  void startFirstTime() {
    setState(() {
      _timerState = TimerState.started;
      textBelowTimer = 'Work Time';
    });
    startTimer();
  }

  void stopTimer() {
    setState(() {
      if (countdownTimer != null) {
        countdownTimer!.cancel();
      }
      _timerState = TimerState.paused;
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
    _timerState = TimerState.initial;
    Provider.of<ThemeProvider>(context, listen: false)
        .changeBgColor(Theme.of(context).colorScheme.surface, 'background');
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
            LocalNotifications.showNotification(
              title: 'Good Job!',
              body: 'You have completed a full set of pomodoro timer!',
              payload: 'finish notification',
            );
            Provider.of<ThemeProvider>(context, listen: false).changeBgColor(
                Theme.of(context).colorScheme.tertiary, 'tertiary');
            textBelowTimer = 'Good Work!';
            // isNotFinish = false;
            _timerState = TimerState.finished;
            countdownTimer!.cancel();
          });
        } else if (seconds < 0 && counter % 2 == 0) {
          // <-- timer work 25 menit
          stopTimer();
          setState(() {
            LocalNotifications.showNotification(
              title: 'Work Time!',
              body: 'have enough rest? lets work again!',
              payload: 'work time notification',
            );
            myDuration = Duration(seconds: workDuration);
            Provider.of<ThemeProvider>(context, listen: false).changeBgColor(
                Theme.of(context).colorScheme.surface, 'background');
            textBelowTimer = 'Work Time';
          });
          counter++;
          startTimer();
        } else if (seconds < 0 && counter % 2 != 0) {
          // <-- timer istirahat 5 menit
          stopTimer();
          setState(() {
            LocalNotifications.showNotification(
              title: 'Rest Time!',
              body: 'Great work! now its time to rest',
              payload: 'rest time notification',
            );
            myDuration = Duration(seconds: restDuration);
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

  // buttons widgets
  Widget getButttonBasedOnState() {
    switch (_timerState) {
      case TimerState.initial:
        return FirstStartButton(
          startFirstTime: startFirstTime,
        );
      case TimerState.started:
        return StartedButtons(
          'Pause',
          pauseOrStart: stopTimer,
          resetCurrentTimer: resetCurrentTimer,
          resetPage: resetPage,
          buttonIcon: const Icon(Icons.pause, size: 60),
        );
      case TimerState.paused:
        return StartedButtons(
          'Start',
          pauseOrStart: startTimer,
          resetCurrentTimer: resetCurrentTimer,
          resetPage: resetPage,
          buttonIcon: const Icon(Icons.play_arrow_rounded, size: 60),
        );
      case TimerState.finished:
        return RestartButton(
          resetPage: resetPage,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Color textColor = Theme.of(context).colorScheme.onSurface;

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
            width: MediaQuery.of(context).size.width * 0.5,
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
          Text(
            textBelowTimer,
            style: GoogleFonts.roboto(
              fontSize: 24,
              color: textColor,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),

          // buttons:
          getButttonBasedOnState()
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
