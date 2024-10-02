import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openhiit/pages/home/home.dart';
import 'package:openhiit/providers/workout_provider.dart';
import 'package:provider/provider.dart';
import 'package:soundpool/soundpool.dart';
import 'package:uuid/uuid.dart';
import '../../models/workout_type.dart';
import '../../utils/database/database_manager.dart';
import 'widgets/sound_dropdown.dart';
import '../../widgets/form_widgets/submit_button.dart';
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
    await saveWorkout(workoutArgument).then((value) => pushHome());
  }

  /// Update the database with the workout. If this is a brand new workout,
  /// make its index the first in the list of workouts and push down the
  /// rest of the workouts. This ensures the new workout appears at the top
  /// of the list of workouts on the home page. If this is an existing workout
  /// that was edited, keep its index where it is.
  ///
  Future saveWorkout(Workout workoutArgument) async {
    WorkoutProvider workoutProvider =
        Provider.of<WorkoutProvider>(context, listen: false);
    DatabaseManager databaseManager = DatabaseManager();

    if (workoutArgument.id == "") {
      workoutArgument.id = const Uuid().v1();
      workoutProvider.updateWorkoutIndices(1);
      await workoutProvider.addWorkout(workoutArgument).then((value) {
        workoutProvider.sort((d) => d.workoutIndex, true);
        databaseManager.updateWorkouts(workoutProvider.workouts);
      });
    } else {
      await workoutProvider.updateWorkout(workoutArgument);
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
