import 'package:flutter/material.dart';

import 'package:pomodoro/music_screen.dart';
import 'package:pomodoro/themes/theme_provider.dart';
import 'package:pomodoro/timer_provider.dart';
import 'package:pomodoro/timer_screen.dart';
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
    int workTimerInMinutes =
        Provider.of<TimerProvider>(context, listen: true).workTime;
    int restTimerInMinutes =
        Provider.of<TimerProvider>(context, listen: true).restTime;
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
        appBar: AppBar(
          backgroundColor: bgColor,
        ),
        drawer: Drawer(
          backgroundColor: bgColor,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 100, bottom: 50),
                child: Center(
                  child: Icon(
                    Icons.settings,
                    size: 40,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: SwitchListTile(
                  title: const Text("D A R K  M O D E"),
                  value: Provider.of<ThemeProvider>(context, listen: false)
                      .isDarkMode,
                  onChanged: (value) {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleTheme();
                  },
                ),
              ),
              // work time setting
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ListTile(
                  leading: const Text(
                    'W O R K  T I M E',
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.normal),
                  ),
                  title: Slider(
                    value: workTimerInMinutes.toDouble(),
                    min: 1,
                    max: 60,
                    divisions: 59,
                    label: '${workTimerInMinutes.toString()} minutes',
                    onChanged: (double value) {
                      Provider.of<TimerProvider>(context, listen: false)
                          .workTime = value.toInt();
                    },
                  ),
                ),
              ),
              // rest time setting
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ListTile(
                  leading: const Text(
                    'R E S T  T I M E',
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.normal),
                  ),
                  title: Slider(
                    value: restTimerInMinutes.toDouble(),
                    min: 1,
                    max: 30,
                    divisions: 29,
                    label: '${restTimerInMinutes.toString()} minutes',
                    onChanged: (double value) {
                      Provider.of<TimerProvider>(context, listen: false)
                          .restTime = value.toInt();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
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
