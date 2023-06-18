import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_controller.dart';
// import 'package:timer_count_down/timer_count_down.dart';
import 'package:audioplayers/audioplayers.dart';
// import 'package:count_down_sound/timer_controller.dart';
// ignore: depend_on_referenced_packages
import 'package:count_down_sound/timer_count_down.dart';
import 'package:confetti/confetti.dart';
import '../workout_type/workout_type.dart';

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
  // late final Workout workout;
  final CountdownController _workoutController =
      CountdownController(autoStart: true);
  final CountdownController _restController =
      CountdownController(autoStart: true);

  String currentInterval = "start";
  bool start = true;
  final player = AudioPlayer();
  int intervals = 0;
  IconData pausePlayIcon = Icons.pause;

  late ConfettiController _controllerCenter;

  @override
  void initState() {
    super.initState();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 10;
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

  @override
  Widget build(BuildContext context) {
    Workout workoutArgument =
        ModalRoute.of(context)!.settings.arguments as Workout;

    print(workoutArgument);

    List<dynamic> exercises = jsonDecode(workoutArgument.exercises);

    return Scaffold(
        backgroundColor: Colors.white10,
        body: SizedBox.expand(
          child: Container(
            color: backgroundColor(),
            child: Center(
              child: Stack(
                children: [
                  Visibility(
                    visible: currentInterval == "start" ? true : false,
                    child: Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.fromLTRB(
                                20.0, 60.0, 20.0, 0.0),
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                        size: 50.0, Icons.arrow_back),
                                    color: Colors.white),
                                const Spacer(),
                                IconButton(
                                    onPressed: () {
                                      if (pausePlayIcon == Icons.pause) {
                                        _workoutController.pause();
                                        setState(() {
                                          pausePlayIcon = Icons.play_arrow;
                                        });
                                      } else {
                                        _workoutController.start();
                                        setState(() {
                                          pausePlayIcon = Icons.pause;
                                        });
                                      }
                                    },
                                    icon: Icon(size: 50.0, pausePlayIcon),
                                    color: Colors.white),
                              ],
                            )),
                        const Padding(
                            padding:
                                EdgeInsets.fromLTRB(20.0, 100.0, 20.0, 20.0),
                            child: Text(
                              "Get ready",
                              style:
                                  TextStyle(fontSize: 70, color: Colors.white),
                            )),
                        Countdown(
                          controller: _workoutController,
                          seconds: 10,
                          build: (_, int time) => Text(
                            time.toString(),
                            style: const TextStyle(
                                fontSize: 140, color: Colors.white),
                          ),
                          interval: const Duration(milliseconds: 100),
                          onFinished: () async {
                            // await player.setSource(AssetSource('assets/audio/beep-3.wav'));
                            // await player.play(AssetSource('audio/beep-3.wav'));
                            await player
                                .play(AssetSource('audio/short-whistle.wav'));
                            await Future.delayed(
                                const Duration(milliseconds: 200));
                            setState(() {
                              start = false;
                              currentInterval = "workout";
                              _workoutController.restart();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: currentInterval == "workout" && start == false
                        ? true
                        : false,
                    child: Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.fromLTRB(
                                20.0, 60.0, 20.0, 0.0),
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                        size: 50.0, Icons.arrow_back),
                                    color: Colors.white),
                                const Spacer(),
                                IconButton(
                                    onPressed: () {
                                      if (pausePlayIcon == Icons.pause) {
                                        _workoutController.pause();
                                        setState(() {
                                          pausePlayIcon = Icons.play_arrow;
                                        });
                                      } else {
                                        _workoutController.start();
                                        setState(() {
                                          pausePlayIcon = Icons.pause;
                                        });
                                      }
                                    },
                                    icon: Icon(size: 50.0, pausePlayIcon),
                                    color: Colors.white),
                              ],
                            )),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(
                                20.0, 100.0, 20.0, 20.0),
                            child: Text(
                              intervals < exercises.length
                                  ? exercises[intervals]
                                  : "",
                              style: const TextStyle(
                                  fontSize: 25, color: Colors.white),
                            )),
                        Countdown(
                          controller: _workoutController,
                          seconds: workoutArgument.exerciseTime,
                          build: (_, int time) => Text(
                            time.toString(),
                            style: const TextStyle(
                                fontSize: 140, color: Colors.white),
                          ),
                          interval: const Duration(milliseconds: 100),
                          onFinished: () async {
                            // await player.setSource(AssetSource('assets/audio/beep-3.wav'));
                            // await player.play(AssetSource('audio/beep-3.wav'));
                            await player.play(AssetSource('audio/beep-6.wav'));
                            await Future.delayed(
                                const Duration(milliseconds: 200));
                            intervals = intervals + 1;
                            setState(() {
                              if (intervals < workoutArgument.numExercises) {
                                currentInterval = "rest";
                                _restController.restart();
                              } else {
                                currentInterval = "done";
                                _controllerCenter.play();
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: currentInterval == "rest" ? true : false,
                    child: Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.fromLTRB(
                                20.0, 60.0, 20.0, 0.0),
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                        size: 50.0, Icons.arrow_back),
                                    color: Colors.white),
                                const Spacer(),
                                IconButton(
                                    onPressed: () {
                                      if (pausePlayIcon == Icons.pause) {
                                        _restController.pause();
                                        setState(() {
                                          pausePlayIcon = Icons.play_arrow;
                                        });
                                      } else {
                                        _restController.start();
                                        setState(() {
                                          pausePlayIcon = Icons.pause;
                                        });
                                      }
                                    },
                                    icon: Icon(size: 50.0, pausePlayIcon),
                                    color: Colors.white),
                              ],
                            )),
                        const Padding(
                            padding:
                                EdgeInsets.fromLTRB(20.0, 100.0, 20.0, 20.0),
                            child: Text(
                              "REST",
                              style:
                                  TextStyle(fontSize: 70, color: Colors.white),
                            )),
                        Countdown(
                          controller: _restController,
                          seconds: workoutArgument.restTime,
                          build: (_, int time) => Text(
                            time.toString(),
                            style: const TextStyle(
                                fontSize: 140, color: Colors.white),
                          ),
                          interval: const Duration(milliseconds: 100),
                          onFinished: () async {
                            // await player.setSource(AssetSource('assets/audio/beep-3.wav'));
                            // await player.play(AssetSource('audio/beep-3.wav'));
                            await player.play(AssetSource('audio/beep-6.wav'));
                            await Future.delayed(
                                const Duration(milliseconds: 200));
                            setState(() {
                              print("$intervals");
                              if (intervals < workoutArgument.numExercises) {
                                currentInterval = "workout";
                                _workoutController.restart();
                              } else {}
                            });
                            if (intervals == workoutArgument.numExercises) {
                              await player.play(AssetSource('audio/bell.mp3'));
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: currentInterval == "done" ? true : false,
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
                      createParticlePath:
                          drawStar, // define a custom shape/path.
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Color backgroundColor() {
    if (currentInterval == "workout") {
      return Colors.red;
    } else if (currentInterval == "rest") {
      return Colors.blue;
    } else {
      return Colors.teal;
    }
  }
}
