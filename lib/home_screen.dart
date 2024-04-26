import 'package:flutter/material.dart';

import 'package:pomodoro/music_screen.dart';
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
  String _bgColor = 'yellow';

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
  void getColor(String bgColor) {
    setState(() {
      _bgColor = bgColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor = Theme.of(context).colorScheme.onBackground;
    final Color redPrimary = Theme.of(context).colorScheme.primary;

    late Color bgColor;
    switch (_bgColor) {
      case 'green':
        bgColor = Theme.of(context).colorScheme.tertiary;
        break;
      case 'blue':
        bgColor = Theme.of(context).colorScheme.secondary;
      default:
        bgColor = Theme.of(context).colorScheme.background;
    }
    return Scaffold(
        backgroundColor: bgColor,
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
          children: [
            TimerScreen(
              getBgColor: getColor,
            ),
            const MusicScreen()
          ],
        ));
  }
}
