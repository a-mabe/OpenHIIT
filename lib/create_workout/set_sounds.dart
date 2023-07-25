import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'package:audioplayers/audioplayers.dart';
import '../main.dart';
import '../workout_data_type/workout_type.dart';
import '../database/database_manager.dart';

const List<String> list = <String>[
  'short-rest-beep',
  'long-rest-beep',
  'short-whistle',
  'long-whistle',
  'long-bell',
  'ding',
  'thunk'
];

class Sounds extends StatelessWidget {
  const Sounds({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Time Intervals'),
      ),
      body: const Center(
        child: SetSounds(),
      ),
    );
  }
}

class SetSounds extends StatefulWidget {
  const SetSounds({super.key});

  @override
  State<SetSounds> createState() => _SetSoundsState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _SetSoundsState extends State<SetSounds> {
  final player = AudioPlayer();

  String workSound = "short-whistle";

  bool workSoundChanged = false;

  void pushHome() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MyHomePage()),
        (route) => false);
  }

  void submitWorkout(workoutArgument) async {
    // workoutArgument.exerciseTime = exerciseTime;
    // workoutArgument.restTime = restTime;
    // workoutArgument.halfTime = halfTime;

    // if (exerciseTime > 6) {
    //   workoutArgument.halfwayMark = halfwayMark == false ? 0 : 1;
    // } else {
    //   workoutArgument.halfwayMark = 0;
    // }

    // setState(() {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => const Sounds(),
    //       settings: RouteSettings(
    //         arguments: workoutArgument,
    //       ),
    //     ),
    //   );
    // });

    // if (workoutArgument.id == "") {
    //   // Set the workout ID
    //   workoutArgument.id = const Uuid().v1();

    //   Database database = await DatabaseManager().initDB();
    //   await DatabaseManager()
    //       .insertList(workoutArgument, database)
    //       .then((value) {
    //     pushHome();
    //   });
    // } else {
    //   Database database = await DatabaseManager().initDB();
    //   await DatabaseManager()
    //       .updateList(workoutArgument, database)
    //       .then((value) {
    //     pushHome();
    //   });
    //   ;
    // }
  }

  @override
  Widget build(BuildContext context) {
    Workout workoutArgument =
        ModalRoute.of(context)!.settings.arguments as Workout;

    if (workoutArgument.exerciseTime > 0) {
      // if (!exerciseChanged) {
      //   exerciseTime = workoutArgument.exerciseTime;
      // }
      // if (!restChanged) {
      //   restTime = workoutArgument.restTime;
      // }
      // if (!halfChanged) {
      //   halfTime = workoutArgument.halfTime;
      // }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text("Work sound"),
            DropdownButton<String>(
              value: workSound,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? value) async {
                // This is called when the user selects an item.
                await player.play(AssetSource('audio/$value.mp3'));
                setState(() {
                  workSound = value!;
                });
              },
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
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
