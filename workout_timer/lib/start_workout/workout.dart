import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_controller.dart';
// import 'package:timer_count_down/timer_count_down.dart';
import 'package:audioplayers/audioplayers.dart';
// import 'package:count_down_sound/timer_controller.dart';
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

class CountDownTimer extends StatefulWidget {
  final Workout workout;

  /// Home page
  const CountDownTimer({
    Key? key,
    required this.workout,
  }) : super(key: key);

  @override
  CountDownTimerState createState() => CountDownTimerState(workout);
}

class CountDownTimerState extends State<CountDownTimer>
    with TickerProviderStateMixin {
  // late final Workout workout;
  final CountdownController _controller = CountdownController(autoStart: true);
  final player = AudioPlayer();

  late final Workout workout;

  CountDownTimerState(this.workout);

  // late AudioPlayer player;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white10,
      body: Countdown(
        controller: _controller,
        seconds: workout.exerciseTime,
        build: (_, double time) => Text(
          time.toString(),
          style: TextStyle(
            fontSize: 100,
          ),
        ),
        interval: Duration(milliseconds: 100),
        onFinished: () async {
          // await player.setSource(AssetSource('assets/audio/beep-3.wav'));
          // await player.play(AssetSource('audio/beep-3.wav'));
          await player.play(AssetSource('audio/beep-6.wav'));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Timer is done!'),
            ),
            // await player.setAsset('assets/audio/beep-3.wav');
          );
        },
      ),
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
}

// /// Flutter code sample for [AnimatedBuilder].

// // class AnimatedBuilderExampleApp extends StatelessWidget {
// //   const AnimatedBuilderExampleApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return const MaterialApp(
// //       home: AnimatedBuilderExample(),
// //     );
// //   }
// // }

// // class AnimatedBuilderExample extends StatefulWidget {
// //   const AnimatedBuilderExample({super.key});

// //   @override
// //   State<AnimatedBuilderExample> createState() => _AnimatedBuilderExampleState();
// // }

// // /// AnimationControllers can be created with `vsync: this` because of
// // /// TickerProviderStateMixin.
// // class _AnimatedBuilderExampleState extends State<AnimatedBuilderExample>
// //     with TickerProviderStateMixin {
// //   late AnimationController _controller;

// //   String get timerString {
// //     Duration duration = _controller.duration! * _controller.value;
// //     return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
// //   }

// //   @override
// //   void initState() {
// //     super.initState();
// //     _controller = AnimationController(
// //       vsync: this,
// //       duration: Duration(seconds: 20),
// //     );
// //   }

// //   // late final AnimationController _controller = AnimationController(
// //   //   duration: const Duration(seconds: 10),
// //   //   vsync: this,
// //   // )..repeat();

// //   @override
// //   void dispose() {
// //     _controller.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return AnimatedBuilder(
// //       animation: _controller,
// //       // child: Container(
// //       //   width: 200.0,
// //       //   height: 200.0,
// //       //   color: Colors.green,
// //       //   child: const Center(
// //       //     child: Text('Whee!'),
// //       //   ),
// //       // ),
// //       builder: (BuildContext context, Widget? child) {
// //         return Text(
// //           timerString,
// //           style: const TextStyle(fontSize: 112.0, color: Colors.white),
// //         );
// //       },
// //     );
// //   }
// // }




// class CountDownTimer extends StatefulWidget {
//   final Workout workout;

//   CountDownTimer({super.key, required this.workout});

//   @override
//   CountDownTimerState createState() => CountDownTimerState(workout);
// }

// class CountDownTimerState extends State<CountDownTimer>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late CurvedAnimation _animation;

//   late final Workout workout;

//   CountDownTimerState(this.workout);

//   @override
//   void initState() {
//     super.initState();
//     _controller = new AnimationController(
//       duration: const Duration(seconds: 5),
//       vsync: this,
//     )..forward();

//     _animation = new CurvedAnimation(
//       parent: _controller,
//       curve: Curves.linear,
//     )..addStatusListener((AnimationStatus status) {
//         if (status == AnimationStatus.completed) {
//           print('completed');
//           _controller.forward();
//         }
//       });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _animation,
//       child: Container(width: 200.0, height: 200.0, color: Colors.green),
//       builder: (BuildContext context, Widget? child) {
//         return Transform.rotate(
//           angle: _controller.value * 2.0 * 3.1415,
//           child: child,
//         );
//       },
//     );
//   }
// }
