import 'package:flutter/material.dart';
import 'package:openhiit/constants/strings.dart';
import 'package:openhiit/models/timer/timer_type.dart';
import 'package:openhiit/pages/create_timer/create_timer.dart';
import 'package:openhiit/pages/import_workout/import_workout.dart';
import 'widgets/timer_option_card.dart';

class SelectTimer extends StatefulWidget {
  const SelectTimer({super.key});

  @override
  SelectTimerState createState() => SelectTimerState();
}

class SelectTimerState extends State<SelectTimer> {
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
                            timer: TimerType.empty(),
                            workout: false,
                          ),
                        ),
                      );
                    },
                    optionIcon: Icons.timer,
                    optionTitle: intervalTimerTitle,
                    optionDescription: intervalTimerDescription),
                TimerOptionCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateTimer(
                          timer: TimerType.empty(),
                          workout: true,
                        ),
                      ),
                    );
                  },
                  optionIcon: Icons.fitness_center,
                  optionTitle: workoutTitle,
                  optionDescription: workoutDescription,
                ),
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
}
