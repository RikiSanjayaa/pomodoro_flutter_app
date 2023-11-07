import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomodoro/play_button.dart';
import 'package:pomodoro/tomato_counter.dart';

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

class _HomeScreenState extends State<HomeScreen> {
  Timer? countdownTimer;

  int counter = 1;
  final int workDuration = 10;
  final int restDuration = 5;
  Duration myDuration = const Duration(seconds: 10);

  Color bgAppColor = const Color.fromARGB(255, 255, 255, 231);
  Color textColor = const Color.fromARGB(255, 43, 52, 103);
  String textBelowTimer = "Work Time";
  bool isOnPause = false;
  bool isNotFinish = true;
  bool isStarted = false;

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
          myDuration = Duration(seconds: workDuration);
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
          myDuration = Duration(seconds: restDuration);
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
            isStarted
                ? Text(
                    textBelowTimer,
                    style: GoogleFonts.roboto(
                      fontSize: 24,
                      color: textColor,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  )
                : Text(
                    "Let's Work!",
                    style: GoogleFonts.roboto(
                      fontSize: 24,
                      color: textColor,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
            isStarted
                ? isNotFinish
                    ? isOnPause
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 70),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: PlayButton(
                                    '',
                                    onClick: resetCurrentTimer,
                                    timerIcon: const Icon(
                                        Icons.keyboard_double_arrow_left,
                                        size: 50),
                                    textColor: textColor,
                                    buttonSize: 60,
                                  ),
                                ),
                                PlayButton(
                                  'Pause',
                                  onClick: stopTimer,
                                  timerIcon: const Icon(Icons.pause, size: 60),
                                  textColor: textColor,
                                  buttonSize: 80,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: PlayButton(
                                    '',
                                    onClick: resetPage,
                                    timerIcon: const Icon(
                                        Icons.restart_alt_rounded,
                                        size: 50),
                                    textColor: textColor,
                                    buttonSize: 60,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 70),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: PlayButton(
                                    '',
                                    onClick: resetCurrentTimer,
                                    timerIcon: const Icon(
                                        Icons.keyboard_double_arrow_left,
                                        size: 50),
                                    textColor: textColor,
                                    buttonSize: 60,
                                  ),
                                ),
                                PlayButton(
                                  'Start',
                                  onClick: startTimer,
                                  timerIcon: const Icon(
                                      Icons.play_arrow_rounded,
                                      size: 60),
                                  textColor: textColor,
                                  buttonSize: 80,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: PlayButton(
                                    '',
                                    onClick: resetPage,
                                    timerIcon: const Icon(
                                        Icons.restart_alt_rounded,
                                        size: 50),
                                    textColor: textColor,
                                    buttonSize: 60,
                                  ),
                                ),
                              ],
                            ),
                          )
                    : PlayButton(
                        // <-- finish button, restart timer
                        'Restart',
                        onClick: resetPage,
                        timerIcon:
                            const Icon(Icons.restart_alt_rounded, size: 60),
                        textColor: textColor,
                        buttonSize: 80,
                      )
                : PlayButton(
                    'Start',
                    onClick: startFirstTime,
                    timerIcon: const Icon(Icons.play_arrow, size: 60),
                    textColor: textColor,
                    buttonSize: 80,
                  ),
          ],
        ),
      ),
    );
  }
}
