import 'package:flutter/material.dart';
import 'package:pomodoro/home_drawer.dart';
import 'package:pomodoro/providers/theme_provider.dart';

import 'package:pomodoro/screens/music_screen.dart';
import 'package:pomodoro/screens/timer_screen.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final Color textColor = Theme.of(context).colorScheme.onBackground;
    final Color redPrimary = Theme.of(context).colorScheme.primary;

    Color bgColor = Provider.of<ThemeProvider>(context, listen: true).bgColor;

    return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
        ),
        drawer: const HomeDrawer(),
        bottomNavigationBar: TabBar(
          controller: _tabController,
          unselectedLabelColor: textColor,
          labelColor: redPrimary,
          indicatorColor: redPrimary,
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: bgColor,
          tabs: const [
            Tab(icon: Icon(Icons.timer_rounded)),
            Tab(icon: Icon(Icons.music_note_rounded)),
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [TimerScreen(), MusicScreen()],
        ));
  }
}
