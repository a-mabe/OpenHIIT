import 'package:flutter/material.dart';
import 'package:openhiit/core/providers/timer_provider/timer_provider.dart';
import 'package:openhiit/features/list_timers/ui/widgets/app_bar.dart';
import 'package:openhiit/features/list_timers/ui/widgets/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:openhiit/features/list_timers/ui/widgets/reorderable_list.dart';
import 'package:provider/provider.dart';

class ListTimersPage extends StatefulWidget {
  const ListTimersPage({super.key});

  @override
  State<ListTimersPage> createState() => _ListTimersPageState();
}

class _ListTimersPageState extends State<ListTimersPage> {
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
          body: FutureBuilder(
            future: timerProvider.loadTimers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error fetching timers'));
              } else {
                final timers = snapshot.data ?? [];
                return ListTimersReorderableList(
                  items: timers,
                  onReorderCompleted: (reorderedItems) {},
                );
              }
            },
          ),
          bottomNavigationBar: ListTimersBottomNavigationBar()),
    );
  }
}
