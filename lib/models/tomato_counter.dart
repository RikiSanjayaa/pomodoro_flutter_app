import 'package:flutter/material.dart';

class TomatoCounter extends StatelessWidget {
  const TomatoCounter({super.key, required this.counter});
  final int counter;

  List<Widget> checkTomatoCount() {
    int totalTomato = 4;
    int tomatoCount = (counter ~/ 2).toInt();
    List<Widget> tomatoGroup = [
      for (var i = 1; i <= totalTomato; i++)
        Opacity(
          opacity: 0.2,
          child: Image.asset(
            'assets/images/tomato.png',
            width: 40,
          ),
        ),
    ];
    if (tomatoCount > 0) {
      for (var i = 1; i <= tomatoCount; i++) {
        tomatoGroup.removeLast();
        tomatoGroup.insert(
          0,
          Opacity(
            opacity: 1,
            child: Image.asset(
              'assets/images/tomato.png',
              width: 40,
            ),
          ),
        );
      }
    }
    return tomatoGroup;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(65, 0, 65, 80),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: checkTomatoCount()),
    );
  }
}
