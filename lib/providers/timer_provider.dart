import 'package:flutter/material.dart';

class TimerProvider extends ChangeNotifier {
  // initially work time = 25 minutes, rest time = 5 minutes
  int _workTime = 25;
  int _restTime = 5;

  // get time
  int get workTime => _workTime;
  int get restTime => _restTime;

  // set work time
  set workTime(int workTime) {
    _workTime = workTime;

    // update UI
    notifyListeners();
  }

  // set rest time
  set restTime(int restTime) {
    _restTime = restTime;

    // update UI
    notifyListeners();
  }
}
