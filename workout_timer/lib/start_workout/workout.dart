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

///
/// Home page
///
// class CountDownTimer extends StatefulWidget {
//   ///
//   /// AppBar title
//   ///
//   final Workout workout;

//   /// Home page
//   CountDownTimer({
//     Key? key,
//     required this.workout,
//   }) : super(key: key);

//   @override
//   CountDownTimerState createState() => CountDownTimerState();
// }

// ///
// /// Page state
// ///
// class CountDownTimerState extends State<CountDownTimer> {
//   // Controller
//   final CountdownController _controller = CountdownController(autoStart: true);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             Container(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   // Start
//                   ElevatedButton(
//                     child: Text('Start'),
//                     onPressed: () {
//                       _controller.start();
//                     },
//                   ),
//                   // Pause
//                   ElevatedButton(
//                     child: Text('Pause'),
//                     onPressed: () {
//                       _controller.pause();
//                     },
//                   ),
//                   // Resume
//                   ElevatedButton(
//                     child: Text('Resume'),
//                     onPressed: () {
//                       _controller.resume();
//                     },
//                   ),
//                   // Stop
//                   ElevatedButton(
//                     child: Text('Restart'),
//                     onPressed: () {
//                       _controller.restart();
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             Countdown(
//               controller: _controller,
//               seconds: 5,
//               build: (_, double time) => Text(
//                 time.toString(),
//                 style: TextStyle(
//                   fontSize: 100,
//                 ),
//               ),
//               interval: Duration(milliseconds: 100),
//               onFinished: () {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text('Timer is done!'),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class StartWorkout extends StatelessWidget {
  const StartWorkout({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   // title: const Text('Enter Time Intervals'),
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      // ),
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

  @override
  Widget build(BuildContext context) {
    Workout workoutArgument =
        ModalRoute.of(context)!.settings.arguments as Workout;

    List<dynamic> exercises = jsonDecode(workoutArgument.exercises);

    return Scaffold(
        backgroundColor: Colors.white10,
        body: SizedBox.expand(
          child: Container(
            color: BackgroundColor(),
            child: Center(
              child: Stack(
                children: [
                  Visibility(
                    visible: currentInterval == "start" ? true : false,
                    child: Column(
                      children: [
                        // const Padding(
                        //     padding:
                        //         EdgeInsets.fromLTRB(20.0, 100.0, 20.0, 20.0),
                        //     child: Row(
                        //       children: [Icon(Icons.abc)],
                        //     )),
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
                          build: (_, double time) => Text(
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
                                20.0, 100.0, 20.0, 20.0),
                            child: Text(
                              intervals < exercises.length
                                  ? exercises[intervals]
                                  : "",
                              style: const TextStyle(
                                  fontSize: 40, color: Colors.white),
                            )),
                        Countdown(
                          controller: _workoutController,
                          seconds: workoutArgument.exerciseTime,
                          build: (_, double time) => Text(
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
                              print("$intervals");
                              if (intervals < workoutArgument.numExercises) {
                                currentInterval = "rest";
                                _restController.restart();
                              } else {
                                print("Done!");
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
                          seconds: 3,
                          build: (_, double time) => Text(
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
                    visible: true,
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
            // child: Countdown(
            //   controller: _controller,
            //   seconds: workoutArgument.exerciseTime,
            //   build: (_, double time) => Text(
            //     time.toString(),
            //     style: const TextStyle(
            //       fontSize: 100,
            //     ),
            //   ),
            //   interval: const Duration(milliseconds: 100),
            //   onFinished: () async {
            //     // await player.setSource(AssetSource('assets/audio/beep-3.wav'));
            //     // await player.play(AssetSource('audio/beep-3.wav'));
            //     await player.play(AssetSource('audio/beep-6.wav'));
            //   },
            // ),
          ),
        )
        // body: Countdown(
        //   controller: _controller,
        //   seconds: workoutArgument.exerciseTime,
        //   build: (_, double time) => Text(
        //     time.toString(),
        //     style: const TextStyle(
        //       fontSize: 100,
        //     ),
        //   ),
        //   interval: const Duration(milliseconds: 100),
        //   onFinished: () async {
        //     // await player.setSource(AssetSource('assets/audio/beep-3.wav'));
        //     // await player.play(AssetSource('audio/beep-3.wav'));
        //     await player.play(AssetSource('audio/beep-6.wav'));
        //   },
        // ),
        // body: AnimatedBuilder(
        //     animation: _controller,
        //     builder: (context, child) {
        //       return Stack(
        //         children: <Widget>[
        //           Align(
        //             alignment: Alignment.bottomCenter,
        //             child: Container(
        //               color: Colors.amber,
        //               height: _controller.value *
        //                   MediaQuery.of(context).size.height,
        //             ),
        //           ),
        //           Padding(
        //             padding: EdgeInsets.all(8.0),
        //             child: Column(
        //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //               children: <Widget>[
        //                 Expanded(
        //                   child: Align(
        //                     alignment: FractionalOffset.center,
        //                     child: AspectRatio(
        //                       aspectRatio: 1.0,
        //                       child: Stack(
        //                         children: <Widget>[
        //                           // Positioned.fill(
        //                           //   child: CustomPaint(
        //                           //       painter: CustomTimerPainter(
        //                           //         animation: controller,
        //                           //         backgroundColor: Colors.white,
        //                           //         color: themeData.indicatorColor,
        //                           //       )),
        //                           // ),
        //                           Align(
        //                             alignment: FractionalOffset.center,
        //                             child: Column(
        //                               mainAxisAlignment:
        //                                   MainAxisAlignment.spaceEvenly,
        //                               crossAxisAlignment:
        //                                   CrossAxisAlignment.center,
        //                               children: <Widget>[
        //                                 Countdown(
        //                                   controller: _controller,
        //                                   seconds: 5,
        //                                   build: (_, double time) => Text(
        //                                     time.toString(),
        //                                     style: TextStyle(
        //                                       fontSize: 100,
        //                                     ),
        //                                   ),
        //                                   interval: Duration(milliseconds: 100),
        //                                   onFinished: () {
        //                                     ScaffoldMessenger.of(context)
        //                                         .showSnackBar(
        //                                       SnackBar(
        //                                         content: Text('Timer is done!'),
        //                                       ),
        //                                     );
        //                                   },
        //                                 ),
        //                               ],
        //                             ),
        //                           ),
        //                         ],
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        // AnimatedBuilder(
        //     animation: controller,
        //     builder: (context, child) {
        //       return FloatingActionButton.extended(
        //           onPressed: () {
        //             if (controller.isAnimating) {
        //               controller.stop();
        //             } else {
        //               controller.reverse(
        //                   from: controller.value == 0.0
        //                       ? 1.0
        //                       : controller.value);
        //             }
        //           },
        //           icon: Icon(controller.isAnimating
        //               ? Icons.pause
        //               : Icons.play_arrow),
        //           label: Text(
        //               controller.isAnimating ? "Pause" : "Play"));
        //     }),
        //           ],
        //         ),
        //       ),
        //     ],
        //   );
        // }),
        );
  }

  BackgroundColor() {
    if (currentInterval == "workout") {
      return Colors.red;
    } else if (currentInterval == "rest") {
      return Colors.blue;
    } else {
      return Colors.teal;
    }
  }
}
