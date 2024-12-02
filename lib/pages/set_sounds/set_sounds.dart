import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openhiit/data/timer_sound_settings.dart';
import 'package:openhiit/data/timer_time_settings.dart';
import 'package:openhiit/data/timer_type.dart';
import 'package:openhiit/pages/home/home.dart';
import 'package:openhiit/providers/workout_provider.dart';
import 'package:openhiit/utils/database/migrations/workout_type_migration.dart';
import 'package:openhiit/utils/log/log.dart';
import 'package:provider/provider.dart';
import 'package:soundpool/soundpool.dart';
import 'package:uuid/uuid.dart';
import '../../data/workout_type.dart';
import '../../utils/database/database_manager.dart';
import 'widgets/sound_dropdown.dart';
import '../../widgets/form_widgets/submit_button.dart';
import 'constants/sounds.dart';

List<String> allSounds = soundsList + countdownSounds;

class SetSounds extends StatefulWidget {
  final TimerType timer;
  final bool edit;

  const SetSounds({super.key, required this.timer, this.edit = false});

  @override
  State<SetSounds> createState() => _SetSoundsState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _SetSoundsState extends State<SetSounds> {
  /// Submit the workout by saving to the database. After the workout
  /// is successfully added to the DB, push to the home screen.
  ///
  void submitWorkout(TimerType timer, BuildContext context) async {
    WorkoutProvider workoutProvider =
        Provider.of<WorkoutProvider>(context, listen: false);

    timer.totalTime = workoutProvider.calculateTotalTimeFromTimer(timer);

    if (timer.id == "") {
      timer.id = const Uuid().v1();
      timer.timeSettings.id = const Uuid().v1();
      timer.soundSettings.id = const Uuid().v1();
      timer.timeSettings.timerId = timer.id;
      timer.soundSettings.timerId = timer.id;

      // Save the intervals
      await workoutProvider
          .addIntervals(workoutProvider.generateIntervalsFromSettings(timer));

      await workoutProvider.addTimer(timer);
    } else {
      await workoutProvider.updateIntervals(
          workoutProvider.generateIntervalsFromSettings(timer));
      await workoutProvider.updateTimer(timer);
    }

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MyHomePage()),
        (route) => false);
  }

  /// Update the database with the workout. If this is a brand new workout,
  /// make its index the first in the list of workouts and push down the
  /// rest of the workouts. This ensures the new workout appears at the top
  /// of the list of workouts on the home page. If this is an existing workout
  /// that was edited, keep its index where it is.
  ///
  // Future saveWorkout(Workout workoutArgument) async {
  //   WorkoutProvider workoutProvider =
  //       Provider.of<WorkoutProvider>(context, listen: false);
  //   DatabaseManager databaseManager = DatabaseManager();

  //   if (workoutArgument.id == "") {
  //     // workoutArgument.id = const Uuid().v1();
  //     // workoutProvider.updateWorkoutIndices(1);
  //     // await workoutProvider.addWorkout(workoutArgument).then((value) {
  //     //   workoutProvider.sort((d) => d.workoutIndex, true);
  //     //   databaseManager.updateWorkouts(workoutProvider.workouts);
  //     // });

  //     TimerType timer = workoutProvider.migrateToTimer(workoutArgument, false);

  //     workoutProvider.updateTimerIndices(1);
  //     await workoutProvider.addTimer(timer).then((value) {
  //       workoutProvider.sortTimers((d) => d.timerIndex, true);
  //       databaseManager.updateTimers(workoutProvider.timers);
  //     });
  //     await workoutProvider.addIntervals(
  //         workoutProvider.migrateToInterval(workoutArgument, false));
  //   } else {
  //     // await workoutProvider.updateWorkout(workoutArgument);
  //     // await workoutProvider.migrateToInterval(workoutArgument, true);
  //     // await workoutProvider.migrateToTimer(workoutArgument, true);
  //   }
  // }

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
    // Workout workout = ModalRoute.of(context)!.settings.arguments as Workout;

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
            submitWorkout(widget.timer, context);
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
                            initialSelection:
                                widget.timer.soundSettings.workSound,
                            pool: pool,
                            soundsList: soundsList,
                            onFinished: (value) async {
                              //This is called when the user selects an item.
                              if (value != 'none') {
                                await pool.play(await soundIdMap[value]);
                              }
                              widget.timer.soundSettings.workSound = value!;
                            }),
                        SoundDropdown(
                            dropdownKey: const Key("rest-sound"),
                            title: "Rest Sound",
                            initialSelection:
                                widget.timer.soundSettings.restSound,
                            pool: pool,
                            soundsList: soundsList,
                            onFinished: (value) async {
                              //This is called when the user selects an item.
                              if (value != 'none') {
                                await pool.play(await soundIdMap[value]);
                              }
                              widget.timer.soundSettings.restSound = value!;
                            }),
                        SoundDropdown(
                            dropdownKey: const Key("halfway-sound"),
                            title: "Halfway Sound",
                            initialSelection:
                                widget.timer.soundSettings.halfwaySound,
                            pool: pool,
                            soundsList: soundsList,
                            onFinished: (value) async {
                              //This is called when the user selects an item.
                              if (value != 'none') {
                                await pool.play(await soundIdMap[value]);
                              }
                              widget.timer.soundSettings.halfwaySound = value!;
                            }),
                        SoundDropdown(
                            dropdownKey: const Key("countdown-sound"),
                            title: "Countdown Sound",
                            initialSelection:
                                widget.timer.soundSettings.countdownSound,
                            pool: pool,
                            soundsList: countdownSounds,
                            onFinished: (value) async {
                              //This is called when the user selects an item.
                              if (value != 'none') {
                                await pool.play(await soundIdMap[value]);
                              }
                              widget.timer.soundSettings.countdownSound =
                                  value!;
                            }),
                        SoundDropdown(
                            dropdownKey: const Key("end-sound"),
                            title: "Timer End Sound",
                            initialSelection:
                                widget.timer.soundSettings.endSound,
                            pool: pool,
                            soundsList: soundsList,
                            onFinished: (value) async {
                              //This is called when the user selects an item.
                              if (value != 'none') {
                                await pool.play(await soundIdMap[value]);
                              }
                              widget.timer.soundSettings.endSound = value!;
                            }),
                      ],
                    ))))));

    // return Scaffold(
    //     appBar: AppBar(
    //       title: const Text("New Interval Timer"),
    //     ),
    //     bottomSheet: SubmitButton(
    //       text: "Submit",
    //       color: Colors.blue,
    //       onTap: () {
    //         submitWorkout(widget.timer);
    //       },
    //     ),
    //     body: SizedBox(
    //         height: (MediaQuery.of(context).size.height * 10) / 12,
    //         width: MediaQuery.of(context).size.width,
    //         child: SingleChildScrollView(
    //             child: Padding(
    //                 padding: const EdgeInsets.fromLTRB(30, 20, 10, 30),
    //                 child: Form(
    //                     // key: formKey,
    //                     child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     SoundDropdown(
    //                         dropdownKey: const Key("work-sound"),
    //                         title: "Work Sound",
    //                         initialSelection: workout.workSound,
    //                         pool: pool,
    //                         soundsList: soundsList,
    //                         onFinished: (value) async {
    //                           //This is called when the user selects an item.
    //                           if (value != 'none') {
    //                             await pool.play(await soundIdMap[value]);
    //                           }
    //                           setState(() {
    //                             workout.workSound = value!;
    //                           });
    //                         }),
    //                     SoundDropdown(
    //                         dropdownKey: const Key("rest-sound"),
    //                         title: "Rest Sound",
    //                         initialSelection: workout.restSound,
    //                         pool: pool,
    //                         soundsList: soundsList,
    //                         onFinished: (value) async {
    //                           //This is called when the user selects an item.
    //                           if (value != 'none') {
    //                             await pool.play(await soundIdMap[value]);
    //                           }
    //                           setState(() {
    //                             workout.restSound = value!;
    //                           });
    //                         }),
    //                     SoundDropdown(
    //                         dropdownKey: Key("halfway-sound"),
    //                         title: "Halfway Sound",
    //                         initialSelection: workout.halfwaySound,
    //                         pool: pool,
    //                         soundsList: soundsList,
    //                         onFinished: (value) async {
    //                           //This is called when the user selects an item.
    //                           if (value != 'none') {
    //                             await pool.play(await soundIdMap[value]);
    //                           }
    //                           setState(() {
    //                             workout.halfwaySound = value!;
    //                           });
    //                         }),
    //                     SoundDropdown(
    //                         dropdownKey: Key("countdown-sound"),
    //                         title: "Countdown Sound",
    //                         initialSelection: workout.countdownSound,
    //                         pool: pool,
    //                         soundsList: countdownSounds,
    //                         onFinished: (value) async {
    //                           //This is called when the user selects an item.
    //                           if (value != 'none') {
    //                             await pool.play(await soundIdMap[value]);
    //                           }
    //                           setState(() {
    //                             workout.countdownSound = value!;
    //                           });
    //                         }),
    //                     SoundDropdown(
    //                         dropdownKey: Key("end-sound"),
    //                         title: "Timer End Sound",
    //                         initialSelection: workout.completeSound,
    //                         pool: pool,
    //                         soundsList: soundsList,
    //                         onFinished: (value) async {
    //                           //This is called when the user selects an item.
    //                           if (value != 'none') {
    //                             await pool.play(await soundIdMap[value]);
    //                           }
    //                           setState(() {
    //                             workout.completeSound = value!;
    //                           });
    //                         }),
    //                   ],
    //                 ))))));
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
