import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_controller.dart';
// import 'package:timer_count_down/timer_count_down.dart';
import 'package:audioplayers/audioplayers.dart';
// import 'package:count_down_sound/timer_controller.dart';
// ignore: depend_on_referenced_packages
import 'package:count_down_sound/timer_count_down.dart';
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // title: const Text('Enter Time Intervals'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(
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

  String currentInterval = "workout";
  final player = AudioPlayer();
  int intervals = 0;

  @override
  Widget build(BuildContext context) {
    Workout workoutArgument =
        ModalRoute.of(context)!.settings.arguments as Workout;

    return Scaffold(
        backgroundColor: Colors.white10,
        body: SizedBox.expand(
          child: Container(
            color: BackgroundColor(),
            child: Center(
              child: Stack(
                children: [
                  Visibility(
                    visible: currentInterval == "workout" ? true : false,
                    child: Countdown(
                      controller: _workoutController,
                      seconds: workoutArgument.exerciseTime,
                      build: (_, double time) => Text(
                        time.toString(),
                        style:
                            const TextStyle(fontSize: 120, color: Colors.white),
                      ),
                      interval: const Duration(milliseconds: 100),
                      onFinished: () async {
                        // await player.setSource(AssetSource('assets/audio/beep-3.wav'));
                        // await player.play(AssetSource('audio/beep-3.wav'));
                        await player.play(AssetSource('audio/beep-6.wav'));
                        await Future.delayed(const Duration(milliseconds: 500));
                        setState(() {
                          print("$intervals");
                          print("${workoutArgument.numExercises}");
                          if (intervals < workoutArgument.numExercises) {
                            print("workout complete");
                            // await Future.delayed(const Duration(seconds: 2));
                            // intervals--;
                            currentInterval = "rest";
                            _restController.restart();
                          } else {}
                        });
                      },
                    ),
                  ),
                  Visibility(
                    visible: currentInterval == "rest" ? true : false,
                    child: Countdown(
                      controller: _restController,
                      seconds: 3,
                      build: (_, double time) => Text(
                        time.toString(),
                        style:
                            const TextStyle(fontSize: 120, color: Colors.white),
                      ),
                      interval: const Duration(milliseconds: 100),
                      onFinished: () async {
                        // await player.setSource(AssetSource('assets/audio/beep-3.wav'));
                        // await player.play(AssetSource('audio/beep-3.wav'));
                        await player.play(AssetSource('audio/beep-6.wav'));
                        await Future.delayed(const Duration(milliseconds: 500));
                        setState(() {
                          print("$intervals");
                          print("${workoutArgument.numExercises}");
                          intervals = intervals + 1;
                          if (intervals < workoutArgument.numExercises) {
                            print("rest complete");
                            // await Future.delayed(const Duration(seconds: 2));
                            currentInterval = "workout";
                            _workoutController.restart();
                          } else {}
                        });
                      },
                    ),
                  )
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
