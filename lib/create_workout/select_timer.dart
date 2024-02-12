import 'package:flutter/material.dart';
import '../utils/functions.dart';
import '../workout_data_type/workout_type.dart';
import './helper_widgets/timer_option_card.dart';

class SelectTimer extends StatefulWidget {
  const SelectTimer({super.key});

  @override
  SelectTimerState createState() => SelectTimerState();
}

class SelectTimerState extends State<SelectTimer> {
  /// Since this will be a new timer, go ahead and create an
  /// empty workout to pass to the next views.
  ///
  final workout = Workout.empty();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: Column(
              children: [
                /// Card for the interval timer option.
                ///
                TimerOptionCard(
                    onTap: () {
                      pushCreateTimer(workout, context);
                    },
                    optionIcon: Icons.timer,
                    optionTitle: "Interval Timer",
                    optionDescription:
                        "An interval timer is a tool that helps you track the time spent working and resting during a workout."),

                /// Card for the workout option.
                ///
                TimerOptionCard(
                  onTap: () {
                    pushCreateWorkout(workout, context);
                  },
                  optionIcon: Icons.fitness_center,
                  optionTitle: "Workout",
                  optionDescription:
                      "A workout is a planned set of exercises combined with an interval timer.",
                ),
              ],
            )));
  }
}
