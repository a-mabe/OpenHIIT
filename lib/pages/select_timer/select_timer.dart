import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:openhiit/constants/strings.dart';
import 'package:openhiit/models/timer/timer_type.dart';
import 'package:openhiit/pages/create/create.dart';
import 'package:openhiit/pages/import_workout/import_workout.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'widgets/timer_option_card.dart';

class SelectTimer extends StatefulWidget {
  const SelectTimer({super.key});

  @override
  SelectTimerState createState() => SelectTimerState();
}

class SelectTimerState extends State<SelectTimer> {
  GlobalKey intervalTimerKey = GlobalKey();
  late TutorialCoachMark tutorialCoachMark;

  @override
  void initState() {
    // createTutorial();
    // Future.delayed(Duration.zero, showTutorial);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: Column(
              children: [
                TimerOptionCard(
                    key: intervalTimerKey,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            // builder: (context) => CreateTimer(
                            //   timer: TimerType.empty(),
                            //   workout: false,
                            // ),
                            builder: (context) => CreateTabBar()),
                      );
                    },
                    optionIcon: Icons.timer,
                    optionTitle: intervalTimerTitle,
                    optionDescription: intervalTimerDescription),
                // TimerOptionCard(
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => CreateTimer(
                //           timer: TimerType.empty(),
                //           workout: true,
                //         ),
                //       ),
                //     );
                //   },
                //   optionIcon: Icons.fitness_center,
                //   optionTitle: workoutTitle,
                //   optionDescription: workoutDescription,
                // ),
                TimerOptionCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ImportWorkout(),
                      ),
                    );
                  },
                  optionIcon: Icons.upload_file,
                  optionTitle: importTitle,
                  optionDescription: importDescription,
                ),
              ],
            )));
  }

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.red,
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.5,
      imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      onSkip: () {
        print("skip");
        return true;
      },
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation1",
        keyTarget: intervalTimerKey,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        shape: ShapeLightFocus.RRect,
        radius: 5, // smaller radius for tighter corner
        color: Colors.blue,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Workout creation has moved!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Creating a workout with named exercises has been merged in with interval timer creation.",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
    return targets;
  }
}
