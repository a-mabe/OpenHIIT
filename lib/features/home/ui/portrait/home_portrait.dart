import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:openhiit/core/logs/logs.dart';
import 'package:openhiit/core/providers/timer_provider/timer_provider.dart';
import 'package:openhiit/features/home/ui/portrait/widgets/app_bar.dart';
import 'package:openhiit/features/home/utils/functions.dart';
import 'package:openhiit/features/import_export_timers/utils/import_export_util.dart';
import 'package:openhiit/shared/ui/widgets/bottom_app_bar.dart';
import 'package:openhiit/features/home/ui/widgets/nav_bar_icon_button.dart';
import 'package:openhiit/features/import_export_timers/ui/export_bottom_sheet.dart';
import 'package:openhiit/features/reorder_timers/ui/list_timers.dart';
import 'package:openhiit/core/models/timer_type.dart';
import 'package:openhiit/features/edit_timer/ui/edit_timer.dart';
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
        // floatingActionButton: FloatingActionButton(
        //   key: const Key("create-timer"),
        //   onPressed: () {},
        //   tooltip: 'Create a new timer',
        //   heroTag: "create",
        //   child: const Icon(Icons.add),
        // ),
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
                onTap: (timer) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewTimerPage(timer: timer),
                    ),
                  );
                },
              );
            }
          },
        ),
        bottomNavigationBar: CustomBottomAppBar(
          children: [
            Spacer(),
            NavBarIconButton(
              icon: Icons.upload,
              label: 'Export',
              fontSize: 11,
              spacing: 0,
              verticalPadding: 0,
              onPressed: () {
                onExportPressed(context, timerProvider);
              },
            ),
            Spacer(),
            NavBarIconButton(
                icon: Icons.download,
                label: 'Import',
                fontSize: 11,
                spacing: 0,
                verticalPadding: 0,
                onPressed: () async {
                  await onImportPressed(
                    context,
                    timerProvider,
                    refreshTimers,
                  );
                }),
            Spacer(),
            NavBarIconButton(
                icon: Icons.add,
                label: 'New Timer',
                fontSize: 11,
                spacing: 0,
                verticalPadding: 4,
                onPressed: () {}),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
