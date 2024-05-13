import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:openhiit/database/database_manager.dart';
import 'package:openhiit/import_export/local_file_util.dart';
import 'package:openhiit/utils/functions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../main.dart';
import '../workout_data_type/workout_type.dart';
import 'main_widgets/submit_button.dart';
import 'package:file_picker/file_picker.dart';
import 'set_exercises.dart';

var logger = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

class ImportWorkout extends StatefulWidget {
  const ImportWorkout({super.key});

  @override
  ImportWorkoutState createState() => ImportWorkoutState();
}

class ImportWorkoutState extends State<ImportWorkout> {
  @override
  Widget build(BuildContext context) {
    /// Grab the [workout] that was passed to this view
    /// from the previous view.
    ///
    Workout workout = ModalRoute.of(context)!.settings.arguments as Workout;

    /// Create a global key that uniquely identifies the Form widget
    /// and allows validation of the form.
    ///
    /// Note: This is a `GlobalKey<FormState>`,
    /// not a GlobalKey<MyCustomFormState>.
    ///
    final formKey = GlobalKey<FormState>();

    /// Push to the SetExercises page.
    ///
    void pushExercises(workout) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SetExercises(),
          settings: RouteSettings(
            arguments: workout,
          ),
        ),
      );
    }

    /// Submit and form, save the workout values, and move
    /// to the next view.
    ///
    // void submitForm(Workout workout) {
    //   // Validate returns true if the form is valid, or false otherwise.
    //   final form = formKey.currentState!;
    //   if (form.validate()) {
    //     form.save();

    //     logger.i(
    //         "Title: ${workout.title}, Color: ${workout.colorInt}, Intervals: ${workout.numExercises}");

    //     pushExercises(workout);
    //   }
    // }
    // ---

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

      print("UPdate database");

      List<Workout> workouts =
          await DatabaseManager().lists(DatabaseManager().initDB());

      // Give the new workout an ID
      // workoutArgument.id = const Uuid().v1();

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

      print("Adding workout");
    }

    void pushHome() {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MyHomePage()),
          (route) => false);
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Import Workout"),
        ),
        // bottomSheet: SubmitButton(
        //   text: "Submit",
        //   color: Colors.blue,
        //   onTap: () {
        //     submitForm(workout);
        //   },
        // ),
        body: Center(
            child: Container(
                height: 100,
                width: 140,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // backgroundColor: Colors.red,
                    elevation: 8,
                  ),
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(
                            type: FileType.custom, allowedExtensions: ['json']);

                    if (result != null) {
                      PlatformFile file = result.files.first;

                      print(file.name);
                      print(file.bytes);
                      print(file.size);
                      print(file.extension);
                      print(file.path);

                      String contents = await LocalFileUtil().readFile(file);
                      print(contents);

                      final Map<String, dynamic> parsed = jsonDecode(contents);
                      final workout = Workout.fromJson(parsed);
                      print(workout);

                      /// Parsing the exercises data from the Workout object.
                      ///
                      List<dynamic> exercises = workout.exercises != ""
                          ? jsonDecode(workout.exercises)
                          : [];

                      workout.id = "";

                      if (context.mounted) {
                        if (exercises.isEmpty) {
                          pushCreateTimer(workout, context, true, (value) {});
                        } else {
                          pushCreateWorkout(workout, context, true, (value) {});
                        }
                      }
                    } else {
                      // User canceled the picker
                    }
                  },
                  child: const Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Icon(Icons.file_open),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Select file")
                    ],
                  ),
                ))));

    // TextButton(
    //   child: Text("Select file"),
    //   onPressed: () async {
    //     FilePickerResult? result = await FilePicker.platform.pickFiles(
    //         type: FileType.custom,
    //         allowedExtensions: ['json']);

    //     if (result != null) {
    //       PlatformFile file = result.files.first;

    //       print(file.name);
    //       print(file.bytes);
    //       print(file.size);
    //       print(file.extension);
    //       print(file.path);
    //     } else {
    //       // User canceled the picker
    //     }
    //   },
    // ));
  }
}
