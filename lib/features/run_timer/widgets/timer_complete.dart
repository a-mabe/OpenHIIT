import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class TimerComplete extends StatefulWidget {
  final ConfettiController controller;
  final bool visible;
  final VoidCallback? onRestart;
  final String timerName;

  const TimerComplete(
      {super.key,
      required this.controller,
      required this.visible,
      required this.onRestart,
      required this.timerName});

  @override
  TimerCompleteState createState() => TimerCompleteState();
}

class TimerCompleteState extends State<TimerComplete> {
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
    widget.controller.play();

    return Visibility(
        visible: widget.visible,
        child: Stack(children: [
          SizedBox.expand(
              child: Container(
            color: const Color.fromARGB(255, 0, 188, 202),
            child: Align(
              alignment: Alignment.center,
              child: ConfettiWidget(
                confettiController: widget.controller,
                blastDirectionality: BlastDirectionality
                    .explosive, // don't specify a direction, blast randomly
                emissionFrequency: .03,
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
          )),
          Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Nice job!',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Completed: ${widget.timerName}',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 40,
              ),
              FilledButton.icon(
                key: const Key('timer-end-back'),
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                        const Color.fromARGB(123, 0, 0, 0))),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                label: const Text('Back   ',
                    style: TextStyle(color: Colors.white)),
              ),
              SizedBox(
                height: 10,
              ),
              FilledButton.icon(
                key: const Key('restart'),
                onPressed: widget.onRestart,
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                        const Color.fromARGB(123, 0, 0, 0))),
                icon: const Icon(Icons.restart_alt, color: Colors.white),
                label: const Text('Restart',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ))
        ]));
  }
}
