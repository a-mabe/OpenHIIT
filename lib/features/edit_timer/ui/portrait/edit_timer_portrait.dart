import 'package:background_hiit_timer/models/interval_type.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:openhiit/core/logs/logs.dart';
import 'package:openhiit/core/models/timer_type.dart';
import 'package:openhiit/core/providers/interval_provider/interval_provider.dart';
import 'package:openhiit/features/edit_timer/ui/tabs/editor_tab/editor_tab.dart';
import 'package:openhiit/features/edit_timer/ui/tabs/general_tab/general_tab.dart';
import 'package:openhiit/features/edit_timer/ui/tabs/sound_tab/sound_tab.dart';
import 'package:openhiit/features/edit_timer/ui/portrait/widgets/start_button.dart';
import 'package:openhiit/features/home/ui/widgets/nav_bar_icon_button.dart';
import 'package:openhiit/shared/ui/widgets/bottom_app_bar.dart';
import 'package:provider/provider.dart';

class EditTimerPortrait extends StatefulWidget {
  final TimerType timer;
  final GlobalKey<FormState> formKey;

  const EditTimerPortrait(
      {super.key, required this.timer, required this.formKey});

  @override
  State<EditTimerPortrait> createState() => _EditTimerPortraitState();
}

class _EditTimerPortraitState extends State<EditTimerPortrait> {
  late IntervalProvider intervalProvider;
  late Future<List<IntervalType>> _loadIntervalsFuture;

  Logger logger = Logger(
    printer: JsonLogPrinter('EditTimerPortrait'),
    level: Level.info,
  );

  @override
  void initState() {
    super.initState();
    refreshTimers();
  }

  void refreshTimers() {
    intervalProvider = Provider.of<IntervalProvider>(context, listen: false);
    setState(() {
      _loadIntervalsFuture = intervalProvider.loadIntervals(widget.timer.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Form(
          key: widget.formKey,
          child: Scaffold(
              appBar: AppBar(
                key: const Key("view-timer-app-bar"),
                title: Text(widget.timer.name),
                bottom: const TabBar(
                  tabs: <Widget>[
                    Tab(icon: Icon(Icons.settings)),
                    Tab(icon: Icon(Icons.volume_up)),
                    Tab(text: "Editor"),
                  ],
                ),
              ),
              body: TabBarView(
                children: <Widget>[
                  GeneralTab(timer: widget.timer),
                  SoundTab(timer: widget.timer),
                  EditorTab(timer: widget.timer),
                ],
              ),
              bottomNavigationBar: CustomBottomAppBar(children: [
                Spacer(),
                NavBarIconButton(
                  key: const Key("delete-timer"),
                  label: 'Delete',
                  icon: Icons.delete,
                  onPressed: () {
                    // Delete timer logic
                    logger.i('Delete timer pressed');
                  },
                ),
                Spacer(),
                StartButton(),
                Spacer(),
                NavBarIconButton(
                  key: const Key("copy-timer"),
                  label: 'Copy',
                  icon: Icons.copy,
                  onPressed: () {
                    // Copy timer logic
                    logger.i('Copy timer pressed');
                  },
                ),
                Spacer(),
              ])

              // FutureBuilder(
              //   future: _loadIntervalsFuture,
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return const Center(child: CircularProgressIndicator());
              //     } else if (snapshot.hasError) {
              //       return const Center(child: Text('Error fetching timers'));
              //     } else {
              //       final timers = snapshot.data ?? [];
              //       if (timers.isEmpty) {
              //         return const Center(
              //           child: Column(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             crossAxisAlignment: CrossAxisAlignment.center,
              //             children: [
              //               Padding(
              //                 padding: EdgeInsets.only(top: 16),
              //                 child: Text('No saved timers',
              //                     style: TextStyle(fontSize: 20)),
              //               ),
              //               Padding(
              //                 padding: EdgeInsets.only(top: 16),
              //                 child: Text("Hit the + to get started!"),
              //               ),
              //             ],
              //           ),
              //         );
              //       }
              //       return ListView.builder(
              //         itemCount: timers.length,
              //         itemBuilder: (context, index) {
              //           final interval = timers[index];
              //           return ListTile(
              //             title: Text(interval.name ?? 'Unnamed Interval'),
              //             subtitle: Text('Duration: ${interval.time} seconds'),
              //           );
              //         },
              //       );
              //       // return ListTimersReorderableList(
              //       //   items: timers,
              //       //   onReorderCompleted: (reorderedItems) {},
              //       //   onTap: (timer) {
              //       //     Navigator.push(
              //       //       context,
              //       //       MaterialPageRoute(
              //       //         builder: (context) => ViewTimerPage(timer: timer),
              //       //       ),
              //       //     );
              //       //   },
              //       // );
              //     }
              //   },
              // ),
              // bottomNavigationBar:
              //     ListTimersBottomAppBar(timerProvider: timerProvider),
              )),
    ));
  }
}
