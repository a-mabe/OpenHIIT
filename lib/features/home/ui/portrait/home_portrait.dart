import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:openhiit/core/logs/logs.dart';
import 'package:openhiit/core/providers/timer_provider/timer_provider.dart';
import 'package:openhiit/features/home/ui/portrait/widgets/app_bar.dart';
import 'package:openhiit/features/home/ui/portrait/widgets/bottom_app_bar.dart';
import 'package:openhiit/features/reorderable_timer_list/ui/list_timers.dart';
import 'package:openhiit/old/models/timer/timer_type.dart';
import 'package:provider/provider.dart';

class ListTimersPortrait extends StatefulWidget {
  const ListTimersPortrait({super.key});

  @override
  State<ListTimersPortrait> createState() => _ListTimersPortraitState();
}

class _ListTimersPortraitState extends State<ListTimersPortrait> {
  late TimerProvider timerProvider;
  late Future<List<TimerType>> _loadTimersFuture;

  Logger logger = Logger(
    printer: JsonLogPrinter('ListTimersPortrait'),
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
        appBar: ListTimersAppBar(),
        floatingActionButton: FloatingActionButton(
          key: const Key("create-timer"),
          onPressed: () {},
          tooltip: 'Create a new timer',
          heroTag: "create",
          child: const Icon(Icons.add),
        ),
        body: FutureBuilder(
          future: _loadTimersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
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
        bottomNavigationBar:
            ListTimersBottomAppBar(timerProvider: timerProvider),
      ),
    );
  }
}
