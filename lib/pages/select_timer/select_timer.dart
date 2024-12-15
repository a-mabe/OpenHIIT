import 'package:flutter/material.dart';
import 'package:openhiit/data/timer_type.dart';
import 'package:openhiit/pages/create_timer/create_timer.dart';
import 'package:openhiit/pages/import_workout/import_workout.dart';
import '../../data/workout_type.dart';
import 'widgets/timer_option_card.dart';

class SelectTimer extends StatefulWidget {
  const SelectTimer({super.key});

  @override
  SelectTimerState createState() => SelectTimerState();
}

class SelectTimerState extends State<SelectTimer> {
  final workout = Workout.empty();
  final timer = TimerType.empty();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: Column(
              children: [
                TimerOptionCard(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateTimer(
                            timer: timer,
                            workout: false,
                          ),
                        ),
                      );
                    },
                    optionIcon: Icons.timer,
                    optionTitle: "Interval Timer",
                    optionDescription:
                        "An interval timer is a tool that helps you track the time spent working and resting during a workout."),
                TimerOptionCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateTimer(
                          timer: timer,
                          workout: true,
                        ),
                      ),
                    );
                  },
                  optionIcon: Icons.fitness_center,
                  optionTitle: "Workout",
                  optionDescription:
                      "A workout is a planned set of exercises combined with an interval timer.",
                ),
                TimerOptionCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ImportWorkout(),
                        settings: RouteSettings(
                          arguments: workout,
                        ),
                      ),
                    );
                  },
                  optionIcon: Icons.upload_file,
                  optionTitle: "Import",
                  optionDescription: "Import a workout or timer from file.",
                ),
              ],
            )));
  }
}
