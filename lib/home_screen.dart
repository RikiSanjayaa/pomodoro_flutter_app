import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:pomodoro/models/tomato_counter.dart';
import 'package:pomodoro/buttons/first_start_button.dart';
import 'package:pomodoro/buttons/restart_button.dart';
import 'package:pomodoro/buttons/started_buttons.dart';

class ResetPage extends StatelessWidget {
  const ResetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

const int workDuration = 1500; // work timer in seconds
const int restDuration = 300; // rest timer in seconds

class _HomeScreenState extends State<HomeScreen> {
  Timer? countdownTimer;

  int counter = 1; // count the work and rest timer
  Duration myDuration = const Duration(seconds: workDuration);

  Color bgAppColor = const Color.fromARGB(255, 255, 255, 231);
  Color textColor = const Color.fromARGB(255, 43, 52, 103);
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
        myDuration = const Duration(seconds: restDuration);
      } else {
        myDuration = const Duration(seconds: workDuration);
      }
    });
  }

  void resetPage() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        pageBuilder: (_, __, ___) => const ResetPage(),
      ),
    );
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0 && counter == 8) {
        // <-- kapan berenti timernya setelah 8 kali
        setState(() {
          bgAppColor = const Color.fromARGB(255, 43, 52, 103);
          textColor = const Color.fromARGB(255, 255, 255, 231);
          textBelowTimer = 'Good Work!';
          isNotFinish = false;
          countdownTimer!.cancel();
        });
      } else if (seconds < 0 && counter % 2 == 0) {
        // <-- timer work 25 menit
        stopTimer();
        setState(() {
          myDuration = const Duration(seconds: workDuration);
          bgAppColor = const Color.fromARGB(255, 255, 255, 231);
          textColor = const Color.fromARGB(255, 43, 52, 103);
          textBelowTimer = 'Work Time';
        });
        counter++;
        startTimer();
      } else if (seconds < 0 && counter % 2 != 0) {
        // <-- timer istirahat 5 menit
        stopTimer();
        setState(() {
          myDuration = const Duration(seconds: restDuration);
          bgAppColor = const Color.fromARGB(255, 186, 215, 233);
          textColor = const Color.fromARGB(255, 43, 52, 103);
          textBelowTimer = 'Rest Time';
        });
        counter++;
        startTimer();
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');

    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));

    return Scaffold(
      backgroundColor: bgAppColor,
      body: Center(
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
                  )
                else
                  StartedButtons(
                    'Start',
                    pauseOrStart: startTimer,
                    resetCurrentTimer: resetCurrentTimer,
                    resetPage: resetPage,
                    textColor: textColor,
                    buttonIcon: const Icon(Icons.play_arrow_rounded, size: 60),
                  )
              else
                RestartButton(resetPage: resetPage, textColor: textColor)
            else
              FirstStartButton(
                  startFirstTime: startFirstTime, textColor: textColor)
          ],
        ),
      ),
    );
  }
}
