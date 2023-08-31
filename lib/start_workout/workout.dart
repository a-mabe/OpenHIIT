import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';
import 'package:background_timer/background_timer_controller.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:background_timer/background_timer.dart';
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

  String _currentInterval = "start";
  bool _start = true;
  final _player = AudioPlayer();
  int _intervals = 0;
  IconData _pausePlayIcon = Icons.pause;
  bool _doneVisible = false;

  late ConfettiController _controllerCenter;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late ListModel<ListTileModel> _intervalInfo;

  /// END VARS

  @override
  void initState() {
    super.initState();
    _intervalInfo = ListModel<ListTileModel>(
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
    // final session = await AudioSession.instance;
    // await session.configure(const AudioSessionConfiguration.music());
    await _player.play(AssetSource('audio/blank.mp3'));
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

  String timerScreenText(currentVisibleInterval, exercises) {
    switch (currentVisibleInterval) {
      case 'start':
        return "Get ready";
      case 'workout':
        return _intervals < exercises.length ? exercises[_intervals] : "Work";
      case 'rest':
        return "Rest";
      default:
        return "";
    }
  }

  void startOnFinished() async {
    await Future.delayed(const Duration(milliseconds: 400));
    setState(() {
      _start = false;
      _currentInterval = "workout";
      _intervalInfo.removeAt(0);
      _workoutController.restart();
    });
  }

  void workoutOnFinished(workoutArgument, exercises) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _intervals = _intervals + 1;
    if (!(_intervals < workoutArgument.numExercises) &&
        workoutArgument.completeSound != 'none') {
      await _player
          .play(AssetSource('audio/${workoutArgument.completeSound}.mp3'));
    }
    setState(() {
      if (_intervals < workoutArgument.numExercises) {
        _currentInterval = "rest";
        _intervalInfo.removeAt(0);
        _workoutController.restart();
      } else {
        _currentInterval = "done";
        _controllerCenter.play();
        _doneVisible = !_doneVisible;
        Wakelock.disable();
      }
    });
  }

  void restOnFinished(workoutArgument) async {
    await Future.delayed(const Duration(milliseconds: 400));
    setState(() {
      if (_intervals < workoutArgument.numExercises) {
        _currentInterval = "workout";
        _intervalInfo.removeAt(0);
        // intervalInfo.removeAt(intervals + 1);
        // intervalInfo.insert(intervalInfo.length, "Rest");
        _workoutController.restart();
      } else {}
    });
  }

  // Widget timerScreen(
  //     currentVisibleInterval, exercises, endSound, seconds, workoutArgument) {
  //   return Visibility(
  //     visible: currentInterval == currentVisibleInterval ? true : false,
  //     child: Column(
  //       children: [
  //         Padding(
  //             padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
  //             child: Row(
  //               children: [
  //                 IconButton(
  //                     onPressed: () {
  //                       Navigator.pop(context);
  //                     },
  //                     icon: const Icon(size: 50.0, Icons.arrow_back),
  //                     color: Colors.white),
  //                 const Spacer(),
  //                 IconButton(
  //                     onPressed: () {
  //                       if (pausePlayIcon == Icons.pause) {
  //                         _workoutController.pause();
  //                         setState(() {
  //                           pausePlayIcon = Icons.play_arrow;
  //                           Wakelock.disable();
  //                         });
  //                       } else {
  //                         _workoutController.start();
  //                         setState(() {
  //                           pausePlayIcon = Icons.pause;
  //                           Wakelock.enable();
  //                         });
  //                       }
  //                     },
  //                     icon: Icon(size: 50.0, pausePlayIcon),
  //                     color: Colors.white),
  //               ],
  //             )),
  //         Padding(
  //             padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
  //             child: Text(
  //               timerScreenText(currentVisibleInterval, exercises),
  //               // intervals < exercises.length ? exercises[intervals] : "",
  //               style: const TextStyle(fontSize: 35, color: Colors.white),
  //             )),
  //         Countdown(
  //           controller: _workoutController,
  //           seconds: seconds,
  //           build: (_, int time) => Text(
  //             time.toString(),
  //             style: const TextStyle(fontSize: 205, color: Colors.white),
  //           ),
  //           interval: const Duration(milliseconds: 100),
  //           endSound: endSound,
  //           halfwaySound: workoutArgument.halfwaySound,
  //           countdownSound: workoutArgument.countdownSound,
  //           halfwayMark: (currentInterval == "workout") ? true : false,
  //           onFinished: () async {
  //             if (currentInterval == "start") {
  //               startOnFinished();
  //             } else if (currentInterval == "workout") {
  //               workoutOnFinished(workoutArgument, exercises);
  //             } else if (currentInterval == "rest") {
  //               restOnFinished(workoutArgument);
  //             }
  //           },
  //         ),
  //         Expanded(
  //           child: Container(
  //             color: Color.fromARGB(22, 0, 0, 0),
  //             child: AnimatedList(
  //               key: _listKey,
  //               initialItemCount: intervalInfo.length,
  //               itemBuilder: (context, index, animation) {
  //                 return CardItemAnimated(
  //                   animation: animation,
  //                   item: intervalInfo[index],
  //                   fontColor: index == 0
  //                       ? Colors.white
  //                       : Color.fromARGB(153, 255, 255, 255),
  //                   fontWeight:
  //                       index == 0 ? FontWeight.bold : FontWeight.normal,
  //                 );
  //                 // return slideIt(context, index, animation);
  //               },
  //             ),
  //           ),
  //           //     child: Container(
  //           //   color: Color.fromARGB(22, 0, 0, 0), // height: 200,
  //           //   child: AnimatedList(
  //           //     key: _listKey,
  //           //     initialItemCount: intervalInfo.length,
  //           //     itemBuilder: (context, index, animation) {
  //           //       return CardItem(
  //           //           animation: animation,
  //           //           item: intervalInfo[index],
  //           //           fontColor: index == 0
  //           //               ? Colors.white
  //           //               : Color.fromARGB(153, 255, 255, 255));
  //           //       // return slideIt(context, index, animation);
  //           //     },
  //           //   ),
  //           // )),
  //         )
  //       ],
  //     ),
  //   );
  // }

  // Widget slideIt(context, index, animation) {
  //   TextStyle? textStyle = Theme.of(context).textTheme.bodyMedium;
  //   return SlideTransition(
  //     position: Tween<Offset>(
  //       begin: const Offset(-1, 0),
  //       end: const Offset(0, 0),
  //     ).animate(CurvedAnimation(
  //         parent: animation,
  //         curve: Curves.easeIn,
  //         reverseCurve: Curves.easeOut)),
  //     child: SizedBox(
  //       height: 50.0,
  //       child: Container(
  //         // color: Colors.transparent,
  //         child: Center(
  //           child: Text('Item $index', style: textStyle),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  List<ListTileModel> listItems(List exercises, Workout workoutArgument) {
    List<ListTileModel> listItems = [];

    for (var i = 0; i < workoutArgument.numExercises + 1; i++) {
      // message.write('!');
      // intervalInfo.insert(i + 1, exercises[i]);
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

  @override
  Widget build(BuildContext context) {
    Workout workoutArgument =
        ModalRoute.of(context)!.settings.arguments as Workout;

    List<dynamic> exercises = workoutArgument.exercises != ""
        ? jsonDecode(workoutArgument.exercises)
        : [];

    if (_currentInterval == "start") {
      _intervalInfo = ListModel<ListTileModel>(
        listKey: _listKey,
        initialItems: listItems(exercises, workoutArgument),
        removedItemBuilder: _buildRemovedItem,
      );
    }

    return SafeArea(
      child: Countdown(
        controller: _workoutController,
        workSeconds: 5,
        restSeconds: 3,
        numberOfIntervals: 2,
        build: (_, int time) => Text(
          time.toString(),
          style: TextStyle(
            fontSize: 100,
          ),
        ),
        interval: Duration(milliseconds: 100),
        onFinished: () {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text('Timer is done!'),
          //   ),
          // );
        },
      ),
    );

    // return Scaffold(
    //     backgroundColor: Colors.white10,
    //     body: SizedBox.expand(
    //       child: Container(
    //         color: backgroundColor(),
    //         child: Center(
    //           child: Stack(
    //             children: [
    //               timerScreen("start", exercises, workoutArgument.workSound, 10,
    //                   workoutArgument),
    //               timerScreen("workout", exercises, workoutArgument.restSound,
    //                   workoutArgument.exerciseTime, workoutArgument),
    //               timerScreen("rest", exercises, workoutArgument.workSound,
    //                   workoutArgument.restTime, workoutArgument),
    //               Visibility(
    //                 visible: currentInterval == "done" ? true : false,
    //                 maintainAnimation: true,
    //                 maintainState: true,
    //                 child: Stack(
    //                   children: [
    //                     Align(
    //                       alignment: Alignment.center,
    //                       child: ConfettiWidget(
    //                         confettiController: _controllerCenter,
    //                         blastDirectionality: BlastDirectionality
    //                             .explosive, // don't specify a direction, blast randomly
    //                         shouldLoop:
    //                             true, // start again as soon as the animation is finished
    //                         colors: const [
    //                           Colors.green,
    //                           Colors.blue,
    //                           Colors.pink,
    //                           Colors.orange,
    //                           Colors.purple
    //                         ], // manually specify the colors to be used
    //                         createParticlePath:
    //                             drawStar, // define a custom shape/path.
    //                       ),
    //                     ),
    //                     Align(
    //                       alignment: Alignment.center,
    //                       child: AnimatedOpacity(
    //                         opacity: doneVisible ? 1.0 : 0.0,
    //                         duration: const Duration(milliseconds: 800),
    //                         child: SizedBox(
    //                           width: 300,
    //                           height: 300,
    //                           // color: Colors.green,
    //                           child: Center(
    //                             child: Column(
    //                               children: [
    //                                 const Text("Nice job!",
    //                                     style: TextStyle(
    //                                         color: Colors.white,
    //                                         fontSize: 45,
    //                                         fontWeight: FontWeight.bold)),
    //                                 const Spacer(),
    //                                 Align(
    //                                   alignment: Alignment.center,
    //                                   child: Row(
    //                                     children: [
    //                                       TextButton.icon(
    //                                           style: ButtonStyle(
    //                                               backgroundColor:
    //                                                   MaterialStateProperty.all(
    //                                                       const Color.fromARGB(
    //                                                           133,
    //                                                           255,
    //                                                           255,
    //                                                           255))),
    //                                           label: const Text(
    //                                             "Back",
    //                                             style: TextStyle(
    //                                                 color: Colors.white,
    //                                                 fontWeight: FontWeight.bold,
    //                                                 fontSize: 22),
    //                                           ),
    //                                           onPressed: () {
    //                                             Navigator.pop(context);
    //                                           },
    //                                           icon: const Icon(Icons.arrow_back,
    //                                               color: Colors.white,
    //                                               size: 38)),
    //                                       const Spacer(),
    //                                       TextButton.icon(
    //                                           style: ButtonStyle(
    //                                               backgroundColor:
    //                                                   MaterialStateProperty.all(
    //                                                       const Color.fromARGB(
    //                                                           133,
    //                                                           255,
    //                                                           255,
    //                                                           255))),
    //                                           label: const Text(
    //                                             "Restart",
    //                                             style: TextStyle(
    //                                                 color: Colors.white,
    //                                                 fontWeight: FontWeight.bold,
    //                                                 fontSize: 22),
    //                                           ),
    //                                           onPressed: () {
    //                                             setState(() {
    //                                               currentInterval = "start";
    //                                               start = true;
    //                                               intervals = 0;
    //                                               pausePlayIcon = Icons.pause;
    //                                               doneVisible = false;
    //                                               _workoutController.restart();
    //                                               Wakelock.enable();
    //                                             });
    //                                           },
    //                                           icon: const Icon(
    //                                               Icons.restart_alt,
    //                                               color: Colors.white,
    //                                               size: 38))
    //                                     ],
    //                                   ),
    //                                 ),
    //                               ],
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ));
  }

  Color backgroundColor() {
    if (_currentInterval == "workout") {
      return Colors.green;
    } else if (_currentInterval == "rest") {
      return Colors.red;
    } else if (_currentInterval == "start") {
      return Colors.black;
    } else {
      return const Color.fromARGB(255, 0, 225, 255);
    }
  }
}
