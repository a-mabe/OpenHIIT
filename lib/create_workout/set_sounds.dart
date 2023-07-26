import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'package:audioplayers/audioplayers.dart';
import '../main.dart';
import '../workout_data_type/workout_type.dart';
import '../database/database_manager.dart';

const List<String> list = <String>[
  'short-whistle',
  'long-whistle',
  'short-rest-beep',
  'long-rest-beep',
  'short-halfway-beep',
  'long-halfway-beep',
  'long-bell',
  'ding',
  'thunk',
  'none'
];

const List<String> countdownSounds = <String>[
  'countdown-beep',
  'short-rest-beep',
  'none'
];

class Sounds extends StatelessWidget {
  const Sounds({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Sounds'),
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
  String restSound = "short-rest-beep";
  String halfwaySound = "short-halfway-beep";
  String completeSound = "long-bell";
  String countdownSound = "countdown-beep";

  bool workSoundChanged = false;
  bool restSoundChanged = false;
  bool halfwaySoundChanged = false;
  bool completeSoundChanged = false;
  bool countdownSoundChanged = false;

  void pushHome() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MyHomePage()),
        (route) => false);
  }

  void submitWorkout(Workout workoutArgument) async {
    workoutArgument.workSound = workSound;
    workoutArgument.restSound = restSound;
    workoutArgument.halfwaySound = halfwaySound;
    workoutArgument.completeSound = completeSound;
    workoutArgument.countdownSound = countdownSound;

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
    }
  }

  @override
  Widget build(BuildContext context) {
    Workout workoutArgument =
        ModalRoute.of(context)!.settings.arguments as Workout;

    if (workoutArgument.workSound != "") {
      if (!workSoundChanged) {
        workSound = workoutArgument.workSound;
      }
      if (!restSoundChanged) {
        restSound = workoutArgument.restSound;
      }
      if (!halfwaySoundChanged) {
        halfwaySound = workoutArgument.halfwaySound;
      }
      if (!completeSoundChanged) {
        completeSound = workoutArgument.completeSound;
      }
      if (!countdownSoundChanged) {
        countdownSound = workoutArgument.countdownSound;
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
                const Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                  child: Text(
                    "Work sound:",
                  ),
                ),
                DropdownButton<String>(
                  value: workSound,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  underline: Container(
                    height: 2,
                  ),
                  onChanged: (String? value) async {
                    // This is called when the user selects an item.
                    if (value != 'none') {
                      await player.play(AssetSource('audio/$value.mp3'));
                    }
                    setState(() {
                      workSound = value!;
                      workSoundChanged = true;
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
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                  child: Text(
                    "Rest sound:",
                  ),
                ),
                DropdownButton<String>(
                  value: restSound,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  underline: Container(
                    height: 2,
                  ),
                  onChanged: (String? value) async {
                    // This is called when the user selects an item.
                    if (value != 'none') {
                      await player.play(AssetSource('audio/$value.mp3'));
                    }
                    setState(() {
                      restSound = value!;
                      restSoundChanged = true;
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
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                  child: Text(
                    "Halfway sound:",
                  ),
                ),
                DropdownButton<String>(
                  value: halfwaySound,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  underline: Container(
                    height: 2,
                  ),
                  onChanged: (String? value) async {
                    // This is called when the user selects an item.
                    if (value != 'none') {
                      await player.play(AssetSource('audio/$value.mp3'));
                    }
                    setState(() {
                      halfwaySound = value!;
                      halfwaySoundChanged = true;
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
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                  child: Text(
                    "Complete sound:",
                  ),
                ),
                DropdownButton<String>(
                  value: completeSound,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  underline: Container(
                    height: 2,
                  ),
                  onChanged: (String? value) async {
                    // This is called when the user selects an item.
                    if (value != 'none') {
                      await player.play(AssetSource('audio/$value.mp3'));
                    }
                    setState(() {
                      completeSound = value!;
                      completeSoundChanged = true;
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
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                  child: Text(
                    "Countdown sound:",
                  ),
                ),
                DropdownButton<String>(
                  value: countdownSound,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  underline: Container(
                    height: 2,
                  ),
                  onChanged: (String? value) async {
                    // This is called when the user selects an item.
                    if (value != 'none') {
                      await player.play(AssetSource('audio/$value.mp3'));
                    }
                    setState(() {
                      countdownSound = value!;
                      countdownSoundChanged = true;
                    });
                  },
                  items: countdownSounds
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
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
