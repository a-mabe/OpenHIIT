import 'package:flutter/material.dart';
import 'package:openhiit/core/providers/timer_provider/timer_provider.dart';
import 'package:openhiit/features/list_timers/ui/portrait/widgets/fab_column.dart';
import 'package:openhiit/features/list_timers/ui/portrait/widgets/app_bar.dart';
import 'package:openhiit/features/list_timers/ui/widgets/reorderable_list.dart';
import 'package:provider/provider.dart';

class ListTimersPortrait extends StatefulWidget {
  const ListTimersPortrait({super.key});

  @override
  State<ListTimersPortrait> createState() => _ListTimersPortraitState();
}

class _ListTimersPortraitState extends State<ListTimersPortrait> {
  late TimerProvider timerProvider;

  @override
  void initState() {
    super.initState();
    timerProvider = Provider.of<TimerProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: ListTimersAppBar(),
          floatingActionButton: Visibility(
            child: FABColumn(),
          ),
          body: FutureBuilder(
            future: timerProvider.loadTimers(),
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
          )),
    );
  }
}
