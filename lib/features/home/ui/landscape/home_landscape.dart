import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:openhiit/core/logs/logs.dart';
import 'package:openhiit/core/providers/timer_provider/timer_provider.dart';
import 'package:openhiit/features/home/ui/landscape/widgets/nav_rail.dart';
import 'package:openhiit/features/reorderable_timer_list/ui/list_timers.dart';
import 'package:openhiit/old/models/timer/timer_type.dart';
import 'package:provider/provider.dart';

class ListTimersLandscape extends StatefulWidget {
  const ListTimersLandscape({super.key});

  @override
  State<ListTimersLandscape> createState() => _ListTimersLandscapeState();
}

class _ListTimersLandscapeState extends State<ListTimersLandscape> {
  late TimerProvider timerProvider;
  late Future<List<TimerType>> _loadTimersFuture;

  Logger logger = Logger(
    printer: JsonLogPrinter('ListTimersLandscape'),
    level: Level.info,
  );

  @override
  void initState() {
    super.initState();
    refreshTimers();
  }

  void refreshTimers() {
    timerProvider = Provider.of<TimerProvider>(context, listen: false);
    setState(() {
      _loadTimersFuture = timerProvider.loadTimers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Row(children: [
        ListTimersNavRail(
            timerProvider: timerProvider, onImport: refreshTimers),
        Expanded(
          child: FutureBuilder(
            future: _loadTimersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                logger.e("Error fetching timers: ${snapshot.error}");
                return const Center(child: Text('Error fetching timers'));
              } else {
                final timers = snapshot.data ?? [];
                if (timers.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Text('No saved timers',
                              style: TextStyle(fontSize: 20)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Text("Hit the + to get started!"),
                        ),
                      ],
                    ),
                  );
                }
                return ListTimersReorderableList(
                  items: timers,
                  onReorderCompleted: (reorderedItems) {},
                );
              }
            },
          ),
        ),
      ]),
    ));
  }
}
