import 'package:flutter/material.dart';

import 'package:pomodoro/materials/colors.dart';
import 'package:pomodoro/timer_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Color _bgColor = MyColors.lightPrimaryColor;
  Color _textColor = MyColors.darkPrimaryColor;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // get color from timer state
  void getColor(bgColor, textColor) {
    setState(() {
      _bgColor = bgColor;
      _textColor = textColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: _bgColor,
        bottomNavigationBar: TabBar(
          controller: _tabController,
          unselectedLabelColor: _textColor,
          labelColor: MyColors.redPrimaryColor,
          indicatorColor: MyColors.redPrimaryColor,
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: _bgColor,
          tabs: const [
            Tab(icon: Icon(Icons.timer_rounded)),
            Tab(icon: Icon(Icons.music_note_rounded)),
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            TimerScreen(
              getColors: getColor,
            ),
            Container(), // TODO: make a music player screen
          ],
        ));
  }
}
