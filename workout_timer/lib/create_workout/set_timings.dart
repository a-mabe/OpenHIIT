import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'package:workout_timer/main.dart';
import '../workout_type/workout_type.dart';
import '../database/database_manager.dart';

class Timings extends StatelessWidget {
  const Timings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Time Intervals'),
      ),
      body: const Center(
        child: SetTimings(),
      ),
    );
  }
}

class SetTimings extends StatefulWidget {
  const SetTimings({super.key});

  @override
  State<SetTimings> createState() => _SetTimingsState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _SetTimingsState extends State<SetTimings> {
  int exerciseTime = 20;
  int restTime = 10;
  int halfTime = 0;

  bool exerciseChanged = false;
  bool restChanged = false;
  bool halfChanged = false;
  bool halfwayMark = false;

  void pushHome() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MyHomePage()),
        (route) => false);
  }

  void submitWorkout(workoutArgument) async {
    workoutArgument.exerciseTime = exerciseTime;
    workoutArgument.restTime = restTime;
    workoutArgument.halfTime = halfTime;
    workoutArgument.halfwayMark = workoutArgument.halfwayMark == false ? 0 : 1;

    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //       content: Text(
    //           "${workoutArgument.restTime} + ${workoutArgument.exerciseTime}")),
    // );

    if (workoutArgument.id == "") {
      // Set the workout ID
      workoutArgument.id = const Uuid().v1();

      Database database = await DatabaseManager().initDB();
      await DatabaseManager()
          .insertList(workoutArgument, database)
          .then((value) {
        pushHome();
      });
    } else {
      Database database = await DatabaseManager().initDB();
      await DatabaseManager()
          .updateList(workoutArgument, database)
          .then((value) {
        pushHome();
      });
      ;
    }
  }

  @override
  Widget build(BuildContext context) {
    Workout workoutArgument =
        ModalRoute.of(context)!.settings.arguments as Workout;

    if (workoutArgument.exerciseTime > 0) {
      if (!exerciseChanged) {
        exerciseTime = workoutArgument.exerciseTime;
      }
      if (!restChanged) {
        restTime = workoutArgument.restTime;
      }
      if (!halfChanged) {
        halfTime = workoutArgument.halfTime;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.fitness_center),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => setState(() {
                    final newValue = exerciseTime - 1;
                    exerciseTime = newValue.clamp(1, 120);
                    exerciseChanged = true;
                  }),
                ),
                Text('Working time: $exerciseTime seconds'),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => setState(() {
                    final newValue = exerciseTime + 1;
                    exerciseTime = newValue.clamp(1, 120);
                    exerciseChanged = true;
                  }),
                ),
              ],
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.snooze),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => setState(() {
                    final newValue = restTime - 1;
                    restTime = newValue.clamp(1, 120);
                    restChanged = true;
                  }),
                ),
                Text('Rest time: $restTime seconds'),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => setState(() {
                    final newValue = restTime + 1;
                    restTime = newValue.clamp(1, 120);
                    restChanged = true;
                  }),
                ),
              ],
            ),
          ),
        ),
        Center(
            child: CheckboxListTile(
          title: Text("Play sound at half time:"),
          value: halfwayMark,
          onChanged: (newValue) {
            setState(() {
              halfwayMark = newValue!;
            });
          },
          // controlAffinity:
          //     ListTileControlAffinity.leading, //  <-- leading Checkbox
        )),
        // Center(
        //   child: Padding(
        //     padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         const Icon(Icons.timelapse),
        //         IconButton(
        //           icon: const Icon(Icons.remove),
        //           onPressed: () => setState(() {
        //             final newValue = halfTime - 1;
        //             halfTime = newValue.clamp(1, 60);
        //             halfChanged = true;
        //           }),
        //         ),
        //         Text('Half time: $halfTime seconds'),
        //         IconButton(
        //           icon: const Icon(Icons.add),
        //           onPressed: () => setState(() {
        //             final newValue = halfTime + 1;
        //             halfTime = newValue.clamp(1, 50);
        //             halfChanged = true;
        //           }),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () async {
                submitWorkout(workoutArgument);
              },
              child: const Text('Submit'),
            ),
          ),
        ),
      ],
    );
  }
}
