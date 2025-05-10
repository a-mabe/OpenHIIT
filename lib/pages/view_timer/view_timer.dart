import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openhiit/models/timer/timer_type.dart';
import 'package:openhiit/models/lists/timer_list_tile_model.dart';
import 'package:openhiit/pages/active_timer/workout.dart';
import 'package:openhiit/pages/create/create.dart';
import 'package:openhiit/pages/home/home.dart';
import 'package:openhiit/pages/view_timer/widgets/start_button.dart';
import 'package:openhiit/pages/view_timer/widgets/view_timer_appbar.dart';
import 'package:openhiit/providers/timer_creation_notifier.dart';
import 'package:openhiit/providers/timer_provider.dart';
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
  bool isLoading = false;
  late TimerProvider timerProvider;

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    timerProvider = Provider.of<TimerProvider>(context);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
    ));

    return FutureBuilder(
      future: DatabaseManager().getIntervalsByWorkoutId(widget.timer.id),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.data.length > 0) {
          List<TimerListTileModel> items =
              listItems(widget.timer, snapshot.data);
          return Stack(
            children: [
              Scaffold(
                bottomNavigationBar: Container(
                    color: Color(widget.timer.color),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? MediaQuery.of(context).size.height / 8
                        : MediaQuery.of(context).size.height / 5,
                    child: StartButton(
                      onTap: () async {
                        if (!isLoading) {
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
                                    timer: widget.timer,
                                    intervals: snapshot.data),
                              ),
                            ).then((value) {
                              SystemChrome.setSystemUIOverlayStyle(
                                  SystemUiOverlayStyle(
                                statusBarBrightness: Brightness.dark,
                              ));
                            });
                          }
                        }
                      },
                    )),
                appBar: ViewTimerAppbar(
                  timer: widget.timer,
                  height:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? 40
                          : 80,
                  onDelete: () async {
                    setState(() {
                      isLoading = true;
                    });
                    logger.d(
                        "Delete button pressed for timer: ${widget.timer.name}");

                    await timerProvider.deleteTimer(widget.timer).then((value) {
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyHomePage(),
                          ),
                          (route) => false,
                        );
                      }
                    }).whenComplete(() {
                      setState(() {
                        isLoading = false;
                      });
                    });
                  },
                  onEdit: () {
                    logger.d(
                        "Edit button pressed for timer: ${widget.timer.name}");

                    TimerCreationNotifier timerCreationNotifier =
                        Provider.of<TimerCreationNotifier>(context,
                            listen: false);
                    timerCreationNotifier.setTimerDraft(widget.timer);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateTabBar(),
                      ),
                    );
                  },
                  onCopy: () async {
                    setState(() {
                      isLoading = true;
                    });
                    TimerType timerCopy = widget.timer.copyNew();
                    await timerProvider.addIntervals(await timerProvider
                        .generateIntervalsFromSettings(timerCopy));
                    await timerProvider.addTimer(timerCopy).then((value) {
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyHomePage(),
                          ),
                        );
                      }
                    }).whenComplete(() {
                      setState(() {
                        isLoading = false;
                      });
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.timer,
                                    color: Colors.white,
                                    size: sizeHeight * .07,
                                  ),
                                  Text(
                                    "${(widget.timer.totalTime / 60).round()} minutes",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: sizeHeight * .03),
                                  )
                                ],
                              ),
                              const Spacer(),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.view_timeline,
                                    color: Colors.white,
                                    size: sizeHeight * .07,
                                  ),
                                  Text(
                                    "${widget.timer.activeIntervals} intervals",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: sizeHeight * .03),
                                  )
                                ],
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ),
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
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isLoading)
                SafeArea(
                    child:
                        Scaffold(body: LoaderTransparent(visible: isLoading)))
            ],
          );
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
