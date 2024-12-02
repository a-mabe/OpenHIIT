import 'dart:io';

import 'package:flutter/material.dart';
import 'package:openhiit/data/timer_type.dart';
import 'package:openhiit/models/lists/timer_list_tile_model.dart';
import 'package:openhiit/pages/active_timer/workout.dart';
import 'package:openhiit/pages/create_timer/create_timer.dart';
import 'package:openhiit/pages/home/home.dart';
import 'package:openhiit/pages/view_workout/widgets/start_button.dart';
import 'package:openhiit/pages/view_workout/widgets/view_workout_appbar.dart';
import 'package:openhiit/providers/workout_provider.dart';
import 'package:openhiit/utils/database/database_manager.dart';
import 'package:openhiit/utils/functions.dart';
import 'package:openhiit/utils/log/log.dart';
import 'package:openhiit/widgets/loader.dart';
import 'package:openhiit/widgets/timer_card_item_animated.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class ViewTimer extends StatefulWidget {
  final TimerType timer;
  const ViewTimer({super.key, required this.timer});
  @override
  ViewTimerState createState() => ViewTimerState();
}

class ViewTimerState extends State<ViewTimer> {
  GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    final workoutProvider =
        Provider.of<WorkoutProvider>(context, listen: false);

    return FutureBuilder(
      future: DatabaseManager().getIntervalsByWorkoutId(widget.timer.id),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.data.length > 0) {
          List<TimerListTileModel> items =
              listItems(widget.timer, snapshot.data);

          return Scaffold(
              bottomNavigationBar: Container(
                  color: Color(widget.timer.color),
                  width: MediaQuery.of(context).size.width,
                  height:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? MediaQuery.of(context).size.height / 8
                          : MediaQuery.of(context).size.height / 5,
                  child: StartButton(
                    onTap: () async {
                      logger.d(
                          "Start button pressed for timer: ${widget.timer.name}");

                      if (Platform.isAndroid) {
                        await Permission.scheduleExactAlarm.isDenied
                            .then((value) {
                          if (value) {
                            Permission.scheduleExactAlarm.request();
                          }
                        });

                        if (await Permission.scheduleExactAlarm.isDenied) {
                          return;
                        }
                      }

                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RunTimer(
                                timer: widget.timer, intervals: snapshot.data),
                          ),
                        ).then((value) {
                          if (context.mounted) {
                            setStatusBarBrightness(context);
                          }
                        });
                      }
                    },
                  )),
              appBar: ViewWorkoutAppBar(
                timer: widget.timer,
                height:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? 40
                        : 80,
                onDelete: () async {
                  logger.d(
                      "Delete button pressed for timer: ${widget.timer.name}");

                  await workoutProvider.deleteTimer(widget.timer).then((value) {
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyHomePage(),
                        ),
                        (route) => false,
                      );
                    }
                  });
                },
                onEdit: () {
                  logger
                      .d("Edit button pressed for timer: ${widget.timer.name}");

                  TimerType timerCopy = widget.timer.copy();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateTimer(
                        timer: timerCopy,
                        workout: widget.timer.activities.isNotEmpty,
                      ),
                    ),
                  );
                },
                onCopy: () async {
                  TimerType timerCopy = widget.timer.copyNew();

                  await workoutProvider.addIntervals(
                      workoutProvider.generateIntervalsFromSettings(timerCopy));
                  await workoutProvider.addTimer(timerCopy).then((value) {
                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyHomePage(),
                        ),
                      );
                    }
                  });
                },
              ),
              body: Container(
                  color: Color(widget.timer.color),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                            visible: MediaQuery.of(context).orientation ==
                                    Orientation.portrait
                                ? true
                                : false,
                            child: Expanded(
                                flex: 4,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Spacer(),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.timer,
                                          color: Colors.white,
                                          size: sizeHeight * .07,
                                        ),
                                        Text(
                                          "${widget.timer.totalTime} minutes",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: sizeHeight * .03),
                                        )
                                      ],
                                    ),
                                    const Spacer(),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.view_timeline,
                                          color: Colors.white,
                                          size: sizeHeight * .07,
                                        ),
                                        Text(
                                          "${snapshot.data.length} intervals",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: sizeHeight * .03),
                                        )
                                      ],
                                    ),
                                    const Spacer(),
                                  ],
                                ))),
                        Expanded(
                            flex: 10,
                            child: AnimatedList(
                              key: listKey,
                              initialItemCount: items.length,
                              itemBuilder: (context, index, animation) {
                                return TimerCardItemAnimated(
                                  animation: animation,
                                  item: items[index],
                                  fontColor: Colors.white,
                                  fontWeight: index == 0
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  backgroundColor: Color(widget.timer.color),
                                  sizeMultiplier: 1,
                                );
                              },
                            ))
                      ])));
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Error loading timer"),
          );
        } else {
          return SafeArea(
              child: Scaffold(
                  body: LoaderTransparent(
            visible: true,
            loadingMessage: "Fetching timer...",
          )));
        }
      },
    );
  }
}
