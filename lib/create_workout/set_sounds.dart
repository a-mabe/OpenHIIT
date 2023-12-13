import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../main.dart';
import '../workout_data_type/workout_type.dart';
import '../database/database_manager.dart';
import './helper_widgets/sound_dropdown.dart';

const List<String> soundsList = <String>[
  'short-whistle',
  'long-whistle',
  'short-rest-beep',
  'long-rest-beep',
  'short-halfway-beep',
  'long-halfway-beep',
  'harsh-beep',
  'harsh-beep-sequence',
  'halfway-beep2',
  'horn',
  'long-bell',
  'ding',
  'ding-sequence',
  'thunk',
  'none',
];

const List<String> countdownSounds = <String>[
  'countdown-beep',
  'short-rest-beep',
  'none',
];

// class Sounds extends StatelessWidget {
//   const Sounds({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Select Sounds'),
//       ),
//       body: const Center(
//         child: SetSounds(),
//       ),
//     );
//   }
// }

class SetSounds extends StatefulWidget {
  const SetSounds({super.key});

  @override
  State<SetSounds> createState() => _SetSoundsState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _SetSoundsState extends State<SetSounds> {
  String _workSound = "short-whistle";
  String _restSound = "short-rest-beep";
  String _halfwaySound = "short-halfway-beep";
  String _completeSound = "long-bell";
  String _countdownSound = "countdown-beep";

  bool _workSoundChanged = false;
  bool _restSoundChanged = false;
  bool _halfwaySoundChanged = false;
  bool _completeSoundChanged = false;
  bool _countdownSoundChanged = false;

  void pushHome() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MyHomePage()),
        (route) => false);
  }

  void submitWorkout(Workout workoutArgument, submitDisabled) async {
    setState(() {
      submitDisabled = true;
    });

    workoutArgument.workSound = _workSound;
    workoutArgument.restSound = _restSound;
    workoutArgument.halfwaySound = _halfwaySound;
    workoutArgument.completeSound = _completeSound;
    workoutArgument.countdownSound = _countdownSound;

    Database database = await DatabaseManager().initDB();

    await updateDatabase(database, workoutArgument).then((value) => pushHome());
  }

  Future updateDatabase(database, Workout workoutArgument) async {
    if (workoutArgument.id == "") {
      List<Workout> workouts =
          await DatabaseManager().lists(DatabaseManager().initDB());

      // Set the workout ID
      workoutArgument.id = const Uuid().v1();
      workouts.insert(0, workoutArgument);

      for (var i = 0; i < workouts.length; i++) {
        if (i == 0) {
          await DatabaseManager().insertList(workouts[i], database);
        } else {
          workouts[i].workoutIndex = workouts[i].workoutIndex + 1;
          await DatabaseManager().updateList(workouts[i], database);
        }
      }
    } else {
      await DatabaseManager().updateList(workoutArgument, database);
    }
  }

  @override
  Widget build(BuildContext context) {
    SoundpoolOptions soundpoolOptions = const SoundpoolOptions();

    Soundpool pool = Soundpool.fromOptions(options: soundpoolOptions);

    var allSounds = soundsList + countdownSounds;

    var soundIdMap = {};

    bool submitDisabled = false;

    for (final sound in allSounds) {
      soundIdMap[sound] = loadSound(sound, pool);
    }

    Workout workoutArgument =
        ModalRoute.of(context)!.settings.arguments as Workout;

    if (workoutArgument.workSound != "") {
      if (!_workSoundChanged) {
        _workSound = workoutArgument.workSound;
      }
      if (!_restSoundChanged) {
        _restSound = workoutArgument.restSound;
      }
      if (!_halfwaySoundChanged) {
        _halfwaySound = workoutArgument.halfwaySound;
      }
      if (!_completeSoundChanged) {
        _completeSound = workoutArgument.completeSound;
      }
      if (!_countdownSoundChanged) {
        _countdownSound = workoutArgument.countdownSound;
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Select Sounds'),
        ),
        bottomSheet: InkWell(
          onTap: submitDisabled
              ? null
              : () async {
                  submitWorkout(workoutArgument, submitDisabled);
                },
          child: Ink(
            height: MediaQuery.of(context).size.height / 12,
            width: MediaQuery.of(context).size.width,
            color: Colors.blue,
            child: const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AutoSizeText(
                    "Submit",
                    minFontSize: 18,
                    maxFontSize: 40,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.only(top: 30),
          children: [
            FractionallySizedBox(
              widthFactor: 0.8,
              child: SoundDropdown(
                  title: "Work Sound",
                  initialSelection: _workSound,
                  pool: pool,
                  soundsList: soundsList,
                  onFinished: (value) async {
                    // This is called when the user selects an item.
                    if (value != 'none') {
                      await pool.play(await soundIdMap[value]);
                    }
                    setState(() {
                      _workSound = value!;
                      _workSoundChanged = true;
                    });
                  }),
            ),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: SoundDropdown(
                  title: "Rest Sound",
                  initialSelection: _restSound,
                  pool: pool,
                  soundsList: soundsList,
                  onFinished: (value) async {
                    // This is called when the user selects an item.
                    if (value != 'none') {
                      await pool.play(await soundIdMap[value]);
                    }
                    setState(() {
                      _restSound = value!;
                      _restSoundChanged = true;
                    });
                  }),
            ),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: SoundDropdown(
                  title: "Halfway Sound",
                  initialSelection: _halfwaySound,
                  pool: pool,
                  soundsList: soundsList,
                  onFinished: (value) async {
                    // This is called when the user selects an item.
                    if (value != 'none') {
                      await pool.play(await soundIdMap[value]);
                    }
                    setState(() {
                      _halfwaySound = value!;
                      _halfwaySoundChanged = true;
                    });
                  }),
            ),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: SoundDropdown(
                  title: "Countdown Sound",
                  initialSelection: _countdownSound,
                  pool: pool,
                  soundsList: countdownSounds,
                  onFinished: (value) async {
                    // This is called when the user selects an item.
                    if (value != 'none') {
                      await pool.play(await soundIdMap[value]);
                    }
                    setState(() {
                      _countdownSound = value!;
                      _countdownSoundChanged = true;
                    });
                  }),
            ),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: SoundDropdown(
                  title: "Timer End Sound",
                  initialSelection: _completeSound,
                  pool: pool,
                  soundsList: soundsList,
                  onFinished: (value) async {
                    // This is called when the user selects an item.
                    if (value != 'none') {
                      await pool.play(await soundIdMap[value]);
                    }
                    setState(() {
                      _completeSound = value!;
                      _completeSoundChanged = true;
                    });
                  }),
            ),
            // Center(
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(vertical: 16.0),
            //     child: ElevatedButton(
            //       onPressed: submitDisabled
            //           ? null
            //           : () async {
            //               submitWorkout(workoutArgument, submitDisabled);
            //             },
            //       child: const Text('Submit'),
            //     ),
            //   ),
            // ),
          ],
        ));
  }

  static Future<int> loadSound(String sound, Soundpool pool) async {
    if (sound != "none") {
      return await rootBundle
          .load("packages/background_timer/lib/assets/audio/$sound.mp3")
          .then((ByteData soundData) {
        return pool.load(soundData);
      });
    }
    return -1;
  }
}
