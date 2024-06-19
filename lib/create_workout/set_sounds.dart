import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../main.dart';
import '../workout_data_type/workout_type.dart';
import '../database/database_manager.dart';
import 'form_picker_widgets/sound_dropdown.dart';
import 'main_widgets/submit_button.dart';
import 'constants/sounds.dart';

List<String> allSounds = soundsList + countdownSounds;

class SetSounds extends StatefulWidget {
  const SetSounds({super.key});

  @override
  State<SetSounds> createState() => _SetSoundsState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _SetSoundsState extends State<SetSounds> {
  /// Submit the workout by saving to the database. After the workout
  /// is successfully added to the DB, push to the home screen.
  ///
  void submitWorkout(Workout workoutArgument) async {
    Database database = await DatabaseManager().initDB();

    await updateDatabase(database, workoutArgument).then((value) => pushHome());
  }

  /// Update the database with the workout. If this is a brand new workout,
  /// make its index the first in the list of workouts and push down the
  /// rest of the workouts. This ensures the new workout appears at the top
  /// of the list of workouts on the home page. If this is an existing workout
  /// that was edited, keep its index where it is.
  ///
  Future updateDatabase(database, Workout workoutArgument) async {
    /// If the workout does not have an ID, that means this is a brand new
    /// workout. Grab the list of existing workouts so we can bump down the
    /// index of each in order to make room for this new workout to be at
    /// the top of the list.
    ///
    if (workoutArgument.id == "") {
      List<Workout> workouts =
          await DatabaseManager().lists(DatabaseManager().initDB());

      // Give the new workout an ID
      workoutArgument.id = const Uuid().v1();

      // Insert the new workout into the top (beginning) of the list
      workouts.insert(0, workoutArgument);

      // Increase the index of all old workouts by 1.
      for (var i = 0; i < workouts.length; i++) {
        if (i == 0) {
          await DatabaseManager().insertList(workouts[i], database);
        } else {
          workouts[i].workoutIndex = workouts[i].workoutIndex + 1;
          await DatabaseManager().updateList(workouts[i], database);
        }
      }
    }

    /// If the workout already has an ID, that means this is an existing
    /// workout that was edited. Simply update the workout in the DB.
    ///
    else {
      await DatabaseManager().updateList(workoutArgument, database);
    }
  }

  /// Naviaget to the home screen.
  ///
  void pushHome() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MyHomePage()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    /// Initialize the soundpool. This will be used to play a preview of the
    /// sound effects whenever a new sound option is selected.
    ///
    Soundpool pool = Soundpool.fromOptions(options: const SoundpoolOptions());

    /// Grab the workout that was passed from the previous view.
    ///
    Workout workout = ModalRoute.of(context)!.settings.arguments as Workout;

    /// Each sound effect must be loaded into the soundpool. Create a map
    /// of soundFileString -> soundID.
    ///
    var soundIdMap = {};
    for (final sound in allSounds) {
      soundIdMap[sound] = loadSound(sound, pool);
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("New Interval Timer"),
        ),
        bottomSheet: SubmitButton(
          text: "Submit",
          color: Colors.blue,
          onTap: () {
            submitWorkout(workout);
          },
        ),
        body: SizedBox(
            height: (MediaQuery.of(context).size.height * 10) / 12,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 20, 10, 30),
                    child: Form(
                        // key: formKey,
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SoundDropdown(
                            dropdownKey: const Key("work-sound"),
                            title: "Work Sound",
                            initialSelection: workout.workSound,
                            pool: pool,
                            soundsList: soundsList,
                            onFinished: (value) async {
                              //This is called when the user selects an item.
                              if (value != 'none') {
                                await pool.play(await soundIdMap[value]);
                              }
                              setState(() {
                                workout.workSound = value!;
                              });
                            }),
                        SoundDropdown(
                            dropdownKey: const Key("rest-sound"),
                            title: "Rest Sound",
                            initialSelection: workout.restSound,
                            pool: pool,
                            soundsList: soundsList,
                            onFinished: (value) async {
                              //This is called when the user selects an item.
                              if (value != 'none') {
                                await pool.play(await soundIdMap[value]);
                              }
                              setState(() {
                                workout.restSound = value!;
                              });
                            }),
                        SoundDropdown(
                            dropdownKey: Key("halfway-sound"),
                            title: "Halfway Sound",
                            initialSelection: workout.halfwaySound,
                            pool: pool,
                            soundsList: soundsList,
                            onFinished: (value) async {
                              //This is called when the user selects an item.
                              if (value != 'none') {
                                await pool.play(await soundIdMap[value]);
                              }
                              setState(() {
                                workout.halfwaySound = value!;
                              });
                            }),
                        SoundDropdown(
                            dropdownKey: Key("countdown-sound"),
                            title: "Countdown Sound",
                            initialSelection: workout.countdownSound,
                            pool: pool,
                            soundsList: countdownSounds,
                            onFinished: (value) async {
                              //This is called when the user selects an item.
                              if (value != 'none') {
                                await pool.play(await soundIdMap[value]);
                              }
                              setState(() {
                                workout.countdownSound = value!;
                              });
                            }),
                        SoundDropdown(
                            dropdownKey: Key("end-sound"),
                            title: "Timer End Sound",
                            initialSelection: workout.completeSound,
                            pool: pool,
                            soundsList: soundsList,
                            onFinished: (value) async {
                              //This is called when the user selects an item.
                              if (value != 'none') {
                                await pool.play(await soundIdMap[value]);
                              }
                              setState(() {
                                workout.completeSound = value!;
                              });
                            }),
                      ],
                    ))))));
  }

  /// Method to load each sound effect into the soundpool.
  ///
  /// https://pub.dev/packages/soundpool
  ///
  static Future<int> loadSound(String sound, Soundpool pool) async {
    if (sound != "none") {
      return await rootBundle
          .load("packages/background_hiit_timer/lib/assets/audio/$sound.mp3")
          .then((ByteData soundData) {
        return pool.load(soundData);
      });
    }
    return -1;
  }
}
