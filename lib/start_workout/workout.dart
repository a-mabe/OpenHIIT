import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
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
    print("------------- interval");
    print(currentWorkInterval);
    print("------------- end");

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
        return "";
    }
  }

  List<ListTileModel> listItems(List exercises, Workout workoutArgument) {
    List<ListTileModel> listItems = [];

    for (var i = 0; i < workoutArgument.numExercises + 1; i++) {
      if (i == 0) {
        listItems.add(
          ListTileModel(
            action: "Prepare",
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
              interval: i,
              total: workoutArgument.numExercises,
              seconds: workoutArgument.exerciseTime,
            ),
          );
          if (i < workoutArgument.numExercises) {
            listItems.add(
              ListTileModel(
                action: "Rest",
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
              interval: i,
              total: workoutArgument.numExercises,
              seconds: workoutArgument.exerciseTime,
            ),
          );
          if (i < workoutArgument.numExercises) {
            listItems.add(
              ListTileModel(
                action: "Rest",
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
    Workout workoutArgument =
        ModalRoute.of(context)!.settings.arguments as Workout;

    List<dynamic> exercises = workoutArgument.exercises != ""
        ? jsonDecode(workoutArgument.exercises)
        : [];

    final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

    print(shouldReset);

    setState(() {
      if (shouldReset) {
        shouldReset = false;
        intervalInfo = ListModel<ListTileModel>(
          listKey: listKey,
          initialItems: listItems(exercises, workoutArgument),
          removedItemBuilder: _buildRemovedItem,
        );
        intervalTotal = intervalInfo.length;
        print("${intervalInfo.length}");
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
            color: Color.fromARGB(255, 0, 225, 255),
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
                      // color: Colors.green,
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
                                          // currentWorkInterval = 0;
                                          // _workoutController.restart();
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

    return SafeArea(
        bottom: false,
        child: Countdown(
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
              print("FINISHED");
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (intervalInfo.length == 1) {
                  intervalInfo.removeAt(0);
                  print("should be empty");
                  print(intervalInfo.length);

                  Future.delayed(Duration(microseconds: 500000), () {
                    setState(() {
                      // _showText = true;
                      doneVisible = true;
                      _controllerCenter.play();

                      // intervalInfo = ListModel<ListTileModel>(
                      //   listKey: listKey,
                      //   initialItems: listItems(exercises, workoutArgument),
                      //   removedItemBuilder: _buildRemovedItem,
                      // );
                    });
                  });

                  // intervalInfo = ListModel<ListTileModel>(
                  //   listKey: listKey,
                  //   initialItems: listItems(exercises, workoutArgument),
                  //   removedItemBuilder: _buildRemovedItem,
                  // );
                }
                // print("---------------------------");
                // print(intervalInfo.length);
                // intervalInfo.removeAt(0);

                // print("REMOVED");
                // if (intervalInfo.length == 0) {
                //   Future.delayed(Duration(microseconds: 500000), () {
                //     setState(() {
                //       // _showText = true;
                //       doneVisible = true;
                //       _controllerCenter.play();
                //     });
                //   });
                // }
              });
            },
            build: (_, BackgroundTimerData timerData) {
              // if (timerData.status == "complete") {
              //   doneVisible = true;
              //   // shouldReset = true;
              // } else {
              //   doneVisible = false;
              //   // shouldReset = false;
              // }

              if (timerData.status == "complete" && restart == false) {
                done = true;
              } else if (timerData.status == "start") {
                currentWorkInterval = 0;
                ListModel<ListTileModel> intervalList =
                    ListModel<ListTileModel>(
                  listKey: listKey,
                  initialItems: listItems(exercises, workoutArgument),
                  removedItemBuilder: _buildRemovedItem,
                );

                int count = 0;
                while (intervalInfo.length < intervalTotal) {
                  // if (intervalInfo.length > 0 && doneVisible == false) {
                  intervalInfo.insert(count, intervalList[count]);
                  count++;
                  // }
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

              // int intervalDifference =
              // if ()

              // if (intervalsCompleted > 0) {
              //   WidgetsBinding.instance.addPostFrameCallback((_) {
              //     print("Remove");
              //     _intervalInfo.removeAt(0);
              //     intervalsCompleted--;
              //     // if (_intervalInfo.length == 0) {
              //     //   Future.delayed(const Duration(microseconds: 500000), () {
              //     //     setState(() {
              //     //       doneVisible = true;
              //     //       _controllerCenter.play();
              //     //     });
              //     //   });
              //   });
              // }

              print(intervalsCompleted);
              print(intervalInfo.length);

              return Stack(children: [
                Container(
                  color: backgroundColor(timerData.status),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
                        child: Row(children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(size: 50.0, Icons.arrow_back),
                              color: Colors.white),
                          const Spacer(),
                          IconButton(
                              onPressed: () {
                                if (!timerData.paused) {
                                  _workoutController.pause();
                                } else {
                                  _workoutController.resume();
                                }
                              },
                              icon: Icon(
                                  size: 50.0,
                                  timerData.paused
                                      ? Icons.play_arrow
                                      : Icons.pause),
                              color: Colors.white),
                        ]),
                      ),
                      Container(
                          alignment: Alignment.center,
                          child: Align(
                              alignment: Alignment.topCenter,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0.0, 20.0, 0.0, 0.0),
                                    child: Text(
                                      timerScreenText(
                                          currentWorkInterval,
                                          timerData.status,
                                          exercises,
                                          workoutArgument),
                                      style: const TextStyle(
                                          fontSize: 30, color: Colors.white),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0.0, 0.0, 0.0, 0.0),
                                    child: Text(
                                      timerData.currentMicroSeconds.toString(),
                                      style: const TextStyle(
                                          fontSize: 160, color: Colors.white),
                                    ),
                                  )
                                ],
                              ))),
                    ],
                  ),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: FractionallySizedBox(
                        widthFactor: 1.0,
                        heightFactor: 0.5,
                        child: Container(
                            alignment: AlignmentDirectional.bottomCenter,
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
                                // return slideIt(context, index, animation);
                              },
                            )))),
                complete()
              ]);
            })
        // child: Stack(
        //   children: [
        //     Countdown(
        //       controller: _workoutController,
        //       workSeconds: workoutArgument.exerciseTime,
        //       restSeconds: workoutArgument.restTime,
        //       workSound: workoutArgument.workSound,
        //       restSound: workoutArgument.restSound,
        //       endSound: workoutArgument.completeSound,
        //       countdownSound: workoutArgument.countdownSound,
        //       halfwaySound: workoutArgument.halfwaySound,
        //       numberOfIntervals: workoutArgument.numExercises,
        //       build: (_, BackgroundTimerData timerData) {
        //         if (timerData.status == "complete" && restart == false) {
        //           done = true;
        //         } else {
        //           done = false;
        //           restart = true;
        //         }

        //         return Text("Hi");

        //         // return Container(
        //         //     color: backgroundColor(timerData.status),
        //         //     child: AnimatedList(
        //         //         initialItemCount: 5,
        //         //         itemBuilder: (context, index, animation) {
        //         //           return Text("Hi");
        //         //         }));

        //         // return AnimatedList(
        //         //     initialItemCount: 5,
        //         //     itemBuilder: (context, index, animation) {
        //         //       return Text("Hi");
        //         //     });

        //         // if (currentStatus != timerData.status) {}
        //         // WidgetsBinding.instance.addPostFrameCallback((_) {
        //         //   _intervalInfo.removeAt(0);
        //         //   if (_intervalInfo.length == 0) {
        //         //     Future.delayed(const Duration(microseconds: 500000), () {
        //         //       setState(() {
        //         //         doneVisible = true;
        //         //         _controllerCenter.play();
        //         //       });
        //         //     });
        //         //   }
        //         // });

        //         // return Container(
        //         //     color: backgroundColor(timerData.status),
        //         //     child: Column(
        //         //       children: [
        //         //         Padding(
        //         //             padding:
        //         //                 const EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
        //         //             child: Row(
        //         //               children: [
        //         //                 IconButton(
        //         //                     onPressed: () {
        //         //                       Navigator.pop(context);
        //         //                     },
        //         //                     icon:
        //         //                         const Icon(size: 50.0, Icons.arrow_back),
        //         //                     color: Colors.white),
        //         //                 const Spacer(),
        //         //                 IconButton(
        //         //                     onPressed: () {
        //         //                       if (!timerData.paused) {
        //         //                         _workoutController.pause();
        //         //                       } else {
        //         //                         _workoutController.resume();
        //         //                       }
        //         //                     },
        //         //                     icon: Icon(
        //         //                         size: 50.0,
        //         //                         timerData.paused
        //         //                             ? Icons.play_arrow
        //         //                             : Icons.pause),
        //         //                     color: Colors.white),
        //         //               ],
        //         //             )),
        //         //         Container(
        //         //             alignment: Alignment.center,
        //         //             child: Align(
        //         //                 alignment: Alignment.topCenter,
        //         //                 child: Column(
        //         //                   children: [
        //         //                     Padding(
        //         //                       padding: const EdgeInsets.fromLTRB(
        //         //                           0.0, 20.0, 0.0, 0.0),
        //         //                       child: Text(
        //         //                         timerScreenText(
        //         //                             timerData.numberOfIntervals,
        //         //                             timerData.status,
        //         //                             exercises,
        //         //                             workoutArgument),
        //         //                         style: const TextStyle(
        //         //                             fontSize: 30, color: Colors.white),
        //         //                       ),
        //         //                     ),
        //         //                     Padding(
        //         //                       padding: const EdgeInsets.fromLTRB(
        //         //                           0.0, 0.0, 0.0, 0.0),
        //         //                       child: Text(
        //         //                         timerData.currentMicroSeconds.toString(),
        //         //                         style: const TextStyle(
        //         //                             fontSize: 160, color: Colors.white),
        //         //                       ),
        //         //                     )
        //         //                   ],
        //         //                 ))),
        //         //       ],
        //         //     ));
        //       },
        //       onFinished: () {
        //         // WidgetsBinding.instance.addPostFrameCallback((_) {
        //         //   _intervalInfo.removeAt(0);
        //         //   if (_intervalInfo.length == 0) {
        //         //     Future.delayed(const Duration(microseconds: 500000), () {
        //         //       setState(() {
        //         //         doneVisible = true;
        //         //         _controllerCenter.play();
        //         //       });
        //         //     });
        //         //   }
        //         // });
        //       },
        //     ),
        //     // Align(
        //     //     alignment: Alignment.bottomCenter,
        //     //     child: FractionallySizedBox(
        //     //         widthFactor: 1.0,
        //     //         heightFactor: 0.5,
        //     //         child: Container(
        //     //             alignment: AlignmentDirectional.bottomCenter,
        //     //             color: const Color.fromARGB(22, 0, 0, 0),
        //     //             child: AnimatedList(
        //     //               key: listKey,
        //     //               initialItemCount: _intervalInfo.length,
        //     //               itemBuilder: (context, index, animation) {
        //     //                 return CardItemAnimated(
        //     //                   animation: animation,
        //     //                   item: _intervalInfo[index],
        //     //                   fontColor: index == 0
        //     //                       ? Colors.white
        //     //                       : const Color.fromARGB(153, 255, 255, 255),
        //     //                   fontWeight: index == 0
        //     //                       ? FontWeight.bold
        //     //                       : FontWeight.normal,
        //     //                 );
        //     //                 // return slideIt(context, index, animation);
        //     //               },
        //     //             )))),
        //     complete()
        //   ],
        // ),
        );
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
}
