import 'package:flutter/material.dart';
import './create_workout.dart';
import './create_timer.dart';
import '../workout_data_type/workout_type.dart';

class SelectTimer extends StatelessWidget {
  const SelectTimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(''),
      ),
      body: const Center(
        child: SelectTimerType(),
      ),
    );
  }
}

class SelectTimerType extends StatefulWidget {
  const SelectTimerType({super.key});

  @override
  // ignore: library_private_types_in_public_api
  SelectTimerTypeState createState() => SelectTimerTypeState();
}

class SelectTimerTypeState extends State<SelectTimerType> {
  final workout = Workout.empty();

  void pushCreateWorkout() {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CreateWorkout(),
          settings: RouteSettings(
            arguments: workout,
          ),
        ),
      );
    });
  }

  void pushCreateTimer() {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CreateTimer(),
          settings: RouteSettings(
            arguments: workout,
          ),
        ),
      );
    });
  }

  Widget timerOption(String optionText, String descriptionText,
      IconData optionIcon, bool timer) {
    return ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 190.0),
        child: Padding(
            padding: const EdgeInsets.all(
              10.0,
            ),
            child: Card(
              child: InkWell(
                child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                              child: Icon(optionIcon, size: 20),
                            ),
                            Text(
                              optionText,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_forward,
                              size: 20,
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Text(descriptionText),
                        )
                      ],
                    )),
                onTap: () {
                  if (timer) {
                    pushCreateTimer();
                  } else {
                    pushCreateWorkout();
                  }
                },
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Column(
          children: [
            timerOption(
                "Interval Timer",
                "An interval timer is a tool that helps you track the time spent working and resting during a workout.",
                Icons.timer,
                true),
            timerOption(
                "Workout",
                "A workout is a planned set of exercise combined with an interval timer.",
                Icons.fitness_center,
                false),
          ],
        ));
  }
}
