import 'dart:convert';
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wakelock/wakelock.dart';
import 'package:background_timer/background_timer_controller.dart';
import 'package:audio_session/audio_session.dart';
import 'package:background_timer/background_timer.dart';
import 'package:background_timer/background_timer_data.dart';
import 'package:confetti/confetti.dart';
import '../workout_data_type/workout_type.dart';
import '../card_widgets/card_item_animated.dart';
import '../models/list_model_animated.dart';
import '../models/list_tile_model.dart';

class StartWorkout extends StatelessWidget {
  const StartWorkout({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CountDownTimer(),
      ),
    );
  }
}

class CountDownTimer extends StatefulWidget {
  const CountDownTimer({super.key});

  @override
  CountDownTimerState createState() => CountDownTimerState();
}

class CountDownTimerState extends State<CountDownTimer>
    with TickerProviderStateMixin {
  /// VARS

  final CountdownController _workoutController =
      CountdownController(autoStart: true);

  IconData pausePlayIcon = Icons.pause;
  int currentWorkInterval = 0;
  bool flipCurrentWorkInterval = true;
  bool doneVisible = false;
  bool done = false;

  late ConfettiController _controllerCenter;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late ListModel<ListTileModel> intervalInfo;

  /// END VARS

  @override
  void initState() {
    super.initState();
    intervalInfo = ListModel<ListTileModel>(
      listKey: _listKey,
      initialItems: <ListTileModel>[],
      removedItemBuilder: _buildRemovedItem,
    );
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    Wakelock.enable();
    init();
  }

  void init() async {
    final session = await AudioSession.instance;
    session.setActive(false);
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  Widget _buildRemovedItem(
      ListTileModel item, BuildContext context, Animation<double> animation) {
    return CardItemAnimated(
      animation: animation,
      item: item,
      fontColor: const Color.fromARGB(153, 255, 255, 255),
      fontWeight: FontWeight.normal,
    );
  }

  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  String timerScreenText(interval, status, exercises, Workout workoutArgument) {
    switch (status) {
      case 'start':
        return "Get ready";
      case 'work':
        String exercise = workoutArgument.numExercises == exercises.length
            ? exercises[interval]
            : "Work";
        flipCurrentWorkInterval = true;
        return exercise;
      case 'rest':
        if (flipCurrentWorkInterval) {
          currentWorkInterval++;
          flipCurrentWorkInterval = false;
        }
        return "Rest";
      default:
        return "Rest";
    }
  }

  List<ListTileModel> listItems(List exercises, Workout workoutArgument) {
    List<ListTileModel> listItems = [];

    for (var i = 0; i < workoutArgument.numExercises + 1; i++) {
      if (i == 0) {
        listItems.add(
          ListTileModel(
            action: "Prepare",
            showMinutes: workoutArgument.showMinutes,
            interval: 0,
            total: workoutArgument.numExercises,
            seconds: 10,
          ),
        );
      } else {
        if (exercises.length < workoutArgument.numExercises) {
          listItems.add(
            ListTileModel(
              action: "Work",
              showMinutes: workoutArgument.showMinutes,
              interval: i,
              total: workoutArgument.numExercises,
              seconds: workoutArgument.exerciseTime,
            ),
          );
          if (i < workoutArgument.numExercises) {
            listItems.add(
              ListTileModel(
                action: "Rest",
                showMinutes: workoutArgument.showMinutes,
                interval: 0,
                total: workoutArgument.numExercises,
                seconds: workoutArgument.restTime,
              ),
            );
          }
        } else {
          listItems.add(
            ListTileModel(
              action: exercises[i - 1],
              showMinutes: workoutArgument.showMinutes,
              interval: i,
              total: workoutArgument.numExercises,
              seconds: workoutArgument.exerciseTime,
            ),
          );
          if (i < workoutArgument.numExercises) {
            listItems.add(
              ListTileModel(
                action: "Rest",
                showMinutes: workoutArgument.showMinutes,
                interval: 0,
                total: workoutArgument.numExercises,
                seconds: workoutArgument.restTime,
              ),
            );
          }
        }
      }
    }

    return listItems;
  }

  bool shouldReset = true;
  bool restart = false;
  int intervalsCompleted = 0;
  String lastStatus = "start";
  int intervalTotal = 0;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.renderViews.first.automaticSystemUiAdjustment =
        false;

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
    ));

    Workout workoutArgument =
        ModalRoute.of(context)!.settings.arguments as Workout;

    List<dynamic> exercises = workoutArgument.exercises != ""
        ? jsonDecode(workoutArgument.exercises)
        : [];

    final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

    // ignore: unused_local_variable
    String backgroundColorStatus = "start";

    setState(() {
      if (shouldReset) {
        shouldReset = false;
        intervalInfo = ListModel<ListTileModel>(
          listKey: listKey,
          initialItems: listItems(exercises, workoutArgument),
          removedItemBuilder: _buildRemovedItem,
        );
        intervalTotal = intervalInfo.length;
        if (restart) {
          _workoutController.restart();
          restart = false;
        }
      }
    });

    Widget complete() {
      return Visibility(
          visible: doneVisible,
          maintainAnimation: true,
          maintainState: true,
          child: Container(
            alignment: Alignment.center,
            color: const Color.fromARGB(255, 0, 225, 255),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: ConfettiWidget(
                    confettiController: _controllerCenter,
                    blastDirectionality: BlastDirectionality
                        .explosive, // don't specify a direction, blast randomly
                    shouldLoop:
                        true, // start again as soon as the animation is finished
                    colors: const [
                      Colors.green,
                      Colors.blue,
                      Colors.pink,
                      Colors.orange,
                      Colors.purple
                    ], // manually specify the colors to be used
                    createParticlePath: drawStar, // define a custom shape/path.
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: AnimatedOpacity(
                    opacity: doneVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 800),
                    child: SizedBox(
                      width: 300,
                      height: 300,
                      child: Center(
                        child: Column(
                          children: [
                            const Text("Nice job!",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 45,
                                    fontWeight: FontWeight.bold)),
                            const Spacer(),
                            Align(
                              alignment: Alignment.center,
                              child: Row(
                                children: [
                                  TextButton.icon(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  const Color.fromARGB(
                                                      133, 255, 255, 255))),
                                      label: const Text(
                                        "Back",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(Icons.arrow_back,
                                          color: Colors.white, size: 38)),
                                  const Spacer(),
                                  TextButton.icon(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  const Color.fromARGB(
                                                      133, 255, 255, 255))),
                                      label: const Text(
                                        "Restart",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22),
                                      ),
                                      onPressed: () async {
                                        final session =
                                            await AudioSession.instance;
                                        session.setActive(false);
                                        setState(() {
                                          shouldReset = true;
                                          doneVisible = false;
                                          restart = true;
                                          done = false;
                                          Wakelock.enable();
                                        });
                                      },
                                      icon: const Icon(Icons.restart_alt,
                                          color: Colors.white, size: 38))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ));
    }

    return Countdown(
        controller: _workoutController,
        workSeconds: workoutArgument.exerciseTime,
        restSeconds: workoutArgument.restTime,
        workSound: workoutArgument.workSound,
        restSound: workoutArgument.restSound,
        endSound: workoutArgument.completeSound,
        countdownSound: workoutArgument.countdownSound,
        halfwaySound: workoutArgument.halfwaySound,
        numberOfWorkIntervals: workoutArgument.numExercises,
        onFinished: () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (intervalInfo.length == 1) {
              intervalInfo.removeAt(0);

              Future.delayed(const Duration(microseconds: 500000), () {
                setState(() {
                  doneVisible = true;
                  _controllerCenter.play();
                });
              });
            }
          });
        },
        build: (_, BackgroundTimerData timerData) {
          backgroundColorStatus = timerData.status;

          if (timerData.status == "complete" && restart == false) {
            done = true;
          } else if (timerData.status == "start") {
            currentWorkInterval = 0;
            ListModel<ListTileModel> intervalList = ListModel<ListTileModel>(
              listKey: listKey,
              initialItems: listItems(exercises, workoutArgument),
              removedItemBuilder: _buildRemovedItem,
            );

            int count = 0;
            while (intervalInfo.length < intervalTotal) {
              intervalInfo.insert(count, intervalList[count]);
              count++;
            }
          } else {
            done = false;
            restart = true;
          }

          while ((intervalInfo.length + timerData.numberOfIntervals) >
              intervalTotal) {
            if (intervalInfo.length > 0 && doneVisible == false) {
              intervalInfo.removeAt(0);
            }
          }

          return Container(
              color: backgroundColor(timerData.status),
              child: SafeArea(
                  child: Scaffold(
                      body: Stack(children: [
                Container(
                  color: backgroundColor(timerData.status),
                  child: Column(
                    children: [
                      Expanded(
                          flex: 6,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Row(children: [
                              IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(
                                      minHeight: 400, minWidth: 80),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon:
                                      const Icon(size: 50.0, Icons.arrow_back),
                                  color: Colors.white),
                              const Spacer(),
                              IconButton(
                                  padding: EdgeInsets.all(0),
                                  constraints: const BoxConstraints(
                                      minHeight: 300, minWidth: 80),
                                  onPressed: () {
                                    if (!timerData.paused) {
                                      _workoutController.pause();
                                    } else {
                                      _workoutController.resume();
                                    }
                                  },
                                  icon: Icon(
                                      size: 40.0,
                                      timerData.paused
                                          ? Icons.play_arrow
                                          : Icons.pause),
                                  color: Colors.white),
                            ]),
                          )),
                      Expanded(
                          flex: 10,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: FittedBox(
                              child: Text(
                                timerScreenText(
                                    currentWorkInterval,
                                    timerData.status,
                                    exercises,
                                    workoutArgument),
                                style: const TextStyle(
                                    color: Colors.white, height: 1),
                              ),
                            ),
                          )),
                      Expanded(
                        flex: 34,
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                          child: AutoSizeText(
                            timerText(timerData.currentMicroSeconds.toString(),
                                workoutArgument),
                            maxLines: 1,
                            minFontSize: 20,
                            // presetFontSizes: presetFontSizes,
                            style: GoogleFonts.dmMono(
                              fontSize: 20000,
                              height: 1.1,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 50,
                        child: Container(
                            color: const Color.fromARGB(22, 0, 0, 0),
                            child: AnimatedList(
                              key: listKey,
                              initialItemCount: intervalInfo.length,
                              itemBuilder: (context, index, animation) {
                                return CardItemAnimated(
                                  animation: animation,
                                  item: intervalInfo[index],
                                  fontColor: index == 0
                                      ? Colors.white
                                      : const Color.fromARGB(
                                          153, 255, 255, 255),
                                  fontWeight: index == 0
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                );
                              },
                            )),
                      ),
                    ],
                  ),
                ),
                complete()
              ]))));
        });
  }

  Color backgroundColor(String status) {
    if (status == "work") {
      return Colors.green;
    } else if (status == "rest") {
      return Colors.red;
    } else if (status == "start") {
      return Colors.black;
    } else {
      return const Color.fromARGB(255, 0, 225, 255);
    }
  }

  String timerText(String currentSeconds, Workout workout) {
    if (workout.showMinutes == 1) {
      int currentSecondsInt = int.parse(currentSeconds);
      int seconds = currentSecondsInt % 60;
      int minutes = ((currentSecondsInt - seconds) / 60).round();

      if (minutes == 0) {
        return currentSeconds;
      }

      String secondsString = seconds.toString();
      if (seconds < 10) {
        secondsString = "0$seconds";
      }

      return "$minutes:$secondsString";
    } else {
      return currentSeconds;
    }
  }
}
