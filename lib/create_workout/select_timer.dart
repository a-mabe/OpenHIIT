import 'package:flutter/material.dart';
import './create_workout.dart';
import './create_timer.dart';
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
  final _workout = Workout.empty();

  /// Push to the [CreateTimer] page.
  ///
  void pushCreateTimer() {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ChooseIntervals(),
          settings: RouteSettings(
            arguments: _workout,
          ),
        ),
      );
    });
  }

  /// Push to the [CreateWorkout] page.
  ///
  void pushCreateWorkout() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateWorkout(),
        settings: RouteSettings(
          arguments: _workout,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
            padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: Column(
              children: [
                /// Card for the interval timer option.
                ///
                TimerOptionCard(
                    onTap: () {
                      pushCreateTimer();
                    },
                    optionIcon: Icons.timer,
                    optionTitle: "Interval Timer",
                    optionDescription:
                        "An interval timer is a tool that helps you track the time spent working and resting during a workout."),

                /// Card for the workout option.
                ///
                TimerOptionCard(
                  onTap: () {
                    pushCreateWorkout();
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
